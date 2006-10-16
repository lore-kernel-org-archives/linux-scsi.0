From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] libsas: support NCQ for SATA disks
Date: Mon, 16 Oct 2006 13:25:30 -0500
Message-ID: <1161023130.3433.21.camel@mulgrave.il.steeleye.com>
References: <453027A9.3060606@us.ibm.com>
	 <1160934124.3544.7.camel@mulgrave.il.steeleye.com>
	 <45328141.5020705@us.ibm.com>
	 <0E9A17FC-4047-48AE-A283-520B87E7F28D@mac.com>
	 <19106af40610151849n41a11e4frd8088797a4e1e65@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:18896 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1422779AbWJPS1W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 14:27:22 -0400
In-Reply-To: <19106af40610151849n41a11e4frd8088797a4e1e65@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Warner <andyw@pobox.com>
Cc: Mark Rustad <mrustad@mac.com>, "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

On Sun, 2006-10-15 at 20:49 -0500, Andy Warner wrote:
> On 10/15/06, Mark Rustad <mrustad@mac.com> wrote:
> > [...]
> > > Hm... if I put in some debug printks in the qc_issue code, I get the
> > > same symptoms.  I've observed that once again we get hung up on ATA
> > > commands where the tag number > 0.  I also noticed this pattern:
> > >
> > > 1. ATA command w/ tag 0 (command A) issued.
> > > 2. Command A goes out to sas-ata.
> > > 2. ATA command w/ tag 1 (command B) issued.
> > > 3. Command A completes
> > > 4. Command B goes out to sas-ata.
> > > [...]
> > > 5. Command B times out.
> > >
> > > Very odd that this all works if there are no printks.  I don't see
> > > anything obvious that would suggest why this apparent race seems to
> > > happen--unless there's some conflict between issuing an ATA command
> > > while completing another one.
> >
> > We have found in our system, using libata with Luben's driver, that
> > the aic94xx sequencer expects the SATA commands to always have a tag
> > of 0. The sequencer assigns its own tag before passing it to the
> > drive. Interestingly, it seems to OR-in its generated tag value, so
> > if a non-zero tag value is passed in, a real mess ensues.
> 
> Mark speaks the truth. If you're going to use libata as a SATL,
> then you have to force the sector count to 0 before feeding the
> taskfile to the aic94xx code. There may be a role for a flag to
> libata that lets it totally skip the tag allocation, when used with
> smart adapters like the 9410. There's little point maintaining
> the bitfields if they are going to be ignored anyway.
> 
> You're also in for a bunch of fun servicing the SIGNAL_NCQ_ERROR
> escbs, suspending/clearing all outstanding I/O, issuing a read log
> page 10 command, mapping the tag back onto the original scb
> via the sister ddb, erroring that one, and retrying the rest. I'm working
> with mostly frozen code, so patches to the current de-Lubenised code
> are difficult (to put it mildly.) Sorry.

Thanks.  We actually had two problems: the one with the tag type but the
other with the fact that we sent our first NCQ command to the device
before the sequencer had been informed of the NCQ tagging capabilities.
I fixed the latter by moving the rphy_add() to the correct point in the
code after the NCQ capabilities are set up.

This is my suggested fix (and now NCQ is working nicely with my seagate
SATA disc).  Someone else gets to fix the error handling, I think

James

Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_task.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_task.c	2006-10-16 10:55:10.000000000 -0500
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_task.c	2006-10-16 13:16:11.000000000 -0500
@@ -390,7 +390,6 @@ static int asd_build_ata_ascb(struct asd
 
 	scb->ata_task.total_xfer_len = cpu_to_le32(task->total_xfer_len);
 	scb->ata_task.fis = task->ata_task.fis;
-	scb->ata_task.fis.fis_type = 0x27;
 	if (likely(!task->ata_task.device_control_reg_update))
 		scb->ata_task.fis.flags |= 0x80; /* C=1: update ATA cmd reg */
 	scb->ata_task.fis.flags &= 0xF0; /* PM_PORT field shall be 0 */
Index: BUILD-2.6/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_scsi_host.c	2006-10-16 10:55:23.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_scsi_host.c	2006-10-16 13:21:13.000000000 -0500
@@ -657,6 +657,12 @@ static unsigned int sas_ata_qc_issue(str
 	task->task_proto = SAS_PROTOCOL_STP;
 	task->task_done = sas_ata_task_done;
 
+	if (qc->tf.command == ATA_CMD_FPDMA_WRITE ||
+	    qc->tf.command == ATA_CMD_FPDMA_READ) {
+		/* Need to zero out the tag libata assigned us */
+		qc->tf.nsect = 0;
+	}
+
 	ata_tf_to_fis(&qc->tf, (u8*)&task->ata_task.fis, 0);
 	task->uldd_task = qc;
 	if (is_atapi_taskfile(&qc->tf)) {
Index: BUILD-2.6/drivers/scsi/libsas/sas_discover.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_discover.c	2006-10-16 11:38:47.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_discover.c	2006-10-16 13:06:12.000000000 -0500
@@ -376,6 +376,7 @@ static int sas_issue_ata_cmd(struct doma
 
 	task->dev = dev;
 
+	task->ata_task.fis.fis_type = 0x27;
 	task->ata_task.fis.command = command;
 	task->ata_task.fis.features = features;
 	task->ata_task.fis.device = d2h_fis->device;
@@ -488,11 +489,7 @@ cont1:
 
 	sas_fill_in_rphy(dev, dev->rphy);
 
-	res = sas_rphy_add(dev->rphy);
-	if (res)
-		goto out_err;
-
-	return res;
+	return 0;
 out_err:
 	dev->sata_dev.identify_packet_device = NULL;
 	dev->sata_dev.identify_device = NULL;
@@ -576,6 +573,7 @@ int sas_discover_sata(struct domain_devi
 	sas_notify_lldd_dev_gone(dev);
 	if (!res) {
 		sas_notify_lldd_dev_found(dev);
+		res = sas_rphy_add(dev->rphy);
 	}
 	return res;
 }


