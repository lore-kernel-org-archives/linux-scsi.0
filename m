From: Tejun Heo <tj@kernel.org>
Subject: Re: [linux-pm] [RFC] Deferred disk spinup during system resume
Date: Fri, 31 Dec 2010 12:45:50 +0100
Message-ID: <20101231114550.GH18831@htj.dyndns.org>
References: <AANLkTinOqLOJ7JCpHeQNYUEirqAvkSce+eFDCGkWn3jE@mail.gmail.com>
 <201012302346.07275.rjw@sisk.pl>
 <AANLkTikLn7VyB+TJMz=GGTHKSHg+9feQ9bje+KS3pD3k@mail.gmail.com>
 <20101231112732.GG18831@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36058 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0LaLpz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Dec 2010 06:45:55 -0500
Received: by bwz15 with SMTP id 15so12323716bwz.19
        for <linux-scsi@vger.kernel.org>; Fri, 31 Dec 2010 03:45:53 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20101231112732.GG18831@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maksim Rayskiy <maksim.rayskiy@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On Fri, Dec 31, 2010 at 12:27:32PM +0100, Tejun Heo wrote:
> On Thu, Dec 30, 2010 at 04:49:29PM -0800, Maksim Rayskiy wrote:
> > >> When resuming from system suspend, scsi disks are being spun up which
> > >> takes quite a lot of time (5+ seconds in my case). The spinup is done
> > >> synchronously, so this time adds up to overall system resume time.
> > >> Ours is an embedded platform and we are using flash-based rootfs, so
> > >> there is no immediate need in harddrive after resume. What is much
> > >> more important for us is to minimize time-to-full-power. To speed up
> > >> resume, we would like to have an option to defer the spinup or run it
> > >> in parallel with system resume. I could not find any existing
> > >> mechanism to do the trick, but I might have missed something.
> > >>
> > >> Can anybody comment on this?
> > >
> > > Do you use asynchronous suspend/resume?
> > >
> > 
> > Yes, asynchronous suspend/resume is enabled - it saves about 0.5
> > second in my case. But resume blocks anyway because disk driver is
> > waiting on sd_resume() to complete.
> > 
> > I am wondering if we could let the resume proceed while spinup is
> > going on, just mark the scsi device as quiescent to block any data
> > transfers.
> 
> Yeah, it was asynchronous for a while when suspend/resume were
> implemented in libata proper.  It's a bit trickier to do that with sd
> doing the higher level part.  Hmmm... most SATA disks spin up
> automatically anyway so disabling START_STOP from sd should do the
> trick.  Does the following achieve async resume?
> 
>  echo 0 > /sys/block/sdX/device/scsi_disk/h:c:i:l/manage_start_stop
> 
> The problem is that the above would also prevent the kernel from
> issuing STANDBY_NOW on suspend or power down.  Maybe we should just
> make start_stop_xlat schedule async EH action instead.

So, something like the following.  It's completely untested.  Proceed
with caution.

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 17a6378..d8d2aa8 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3252,6 +3252,48 @@ static int ata_eh_maybe_retry_flush(struct ata_device *dev)
 	return rc;
 }
 
+static int ata_eh_maybe_verify(struct ata_device *dev)
+{
+	struct ata_link *link = dev->link;
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+	int rc = 0;
+
+	ata_eh_about_to_do(link, dev, ATA_EH_VERIFY);
+
+	ata_tf_init(dev, &tf);
+
+	if (dev->flags & ATA_DFLAG_LBA) {
+		tf.flags |= ATA_TFLAG_LBA;
+
+		tf.lbah = 0x0;
+		tf.lbam = 0x0;
+		tf.lbal = 0x0;
+		tf.device |= ATA_LBA;
+	} else {
+		/* CHS */
+		tf.lbal = 0x1; /* sect */
+		tf.lbam = 0x0; /* cyl low */
+		tf.lbah = 0x0; /* cyl high */
+	}
+
+	tf.command = ATA_CMD_VERIFY;	/* READ VERIFY */
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_LBA48 | ATA_TFLAG_DEVICE;
+	tf.protocol = ATA_PROT_NODATA;
+
+	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
+	if (err_mask) {
+		ata_dev_printk(dev, KERN_WARNING,
+			       "READ_VERIFY failed Emask 0x%x\n", err_mask);
+		rc = -EIO;
+	}
+
+	/* don't retry VERIFY */
+	ata_eh_done(link, dev, ATA_EH_VERIFY);
+
+	return rc;
+}
+
 /**
  *	ata_eh_set_lpm - configure SATA interface power management
  *	@link: link to configure power management
@@ -3749,6 +3791,9 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			rc = ata_eh_maybe_retry_flush(dev);
 			if (rc)
 				goto rest_fail;
+			rc = ata_eh_maybe_verify(dev);
+			if (rc)
+				goto rest_fail;
 		}
 
 	config_lpm:
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 66aa4be..ae8d9ca 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1276,6 +1276,7 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth,
  */
 static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 {
+	struct ata_device *dev = qc->dev;
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->tf;
 	const u8 *cdb = scmd->cmnd;
@@ -1294,23 +1295,9 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 		goto invalid_fld;       /* power conditions not supported */
 
 	if (cdb[4] & 0x1) {
-		tf->nsect = 1;	/* 1 sector, lba=0 */
-
-		if (qc->dev->flags & ATA_DFLAG_LBA) {
-			tf->flags |= ATA_TFLAG_LBA;
-
-			tf->lbah = 0x0;
-			tf->lbam = 0x0;
-			tf->lbal = 0x0;
-			tf->device |= ATA_LBA;
-		} else {
-			/* CHS */
-			tf->lbal = 0x1; /* sect */
-			tf->lbam = 0x0; /* cyl low */
-			tf->lbah = 0x0; /* cyl high */
-		}
-
-		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
+		dev->link->eh_info.dev_action[dev->devno] |= ATA_EH_VERIFY;
+		ata_port_schedule_eh(dev->link->ap);
+		goto skip;
 	} else {
 		/* Some odd clown BIOSen issue spindown on power off (ACPI S4
 		 * or S5) causing some drives to spin up and down again.
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d947b12..219d491 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -326,6 +326,7 @@ enum {
 	ATA_EH_HARDRESET	= (1 << 2), /* meaningful only in ->prereset */
 	ATA_EH_RESET		= ATA_EH_SOFTRESET | ATA_EH_HARDRESET,
 	ATA_EH_ENABLE_LINK	= (1 << 3),
+	ATA_EH_VERIFY		= (1 << 4), /* used to force spin up */
 	ATA_EH_PARK		= (1 << 5), /* unload heads and stop I/O */
 
 	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE | ATA_EH_PARK,
