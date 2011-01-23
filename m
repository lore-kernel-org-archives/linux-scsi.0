From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH] libsas: fix ATAPI check condition termination
Date: Sun, 23 Jan 2011 08:16:24 -0600
Message-ID: <1295792184.3007.2.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab1AWOQ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jan 2011 09:16:29 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id A49B05FC9F
	for <linux-scsi@vger.kernel.org>; Sun, 23 Jan 2011 15:16:28 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

ATAPI check condition needs to be treated the same as a success or
protocol return.  The register returns from the PACKET command are all
correctly positioned in the device to host register FIS and so we
should collect them properly.  Right at the moment this doesn't matter
because libata sends a request sense always for ATAPI errors, but if
it ever checked the registers, we should have the correct contents
just in case.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index e1a395b..571603d 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -71,13 +71,13 @@ static enum ata_completion_errors sas_to_ata_err(struct task_status_struct *ts)
 		case SAS_SG_ERR:
 			return AC_ERR_INVALID;
 
-		case SAM_STAT_CHECK_CONDITION:
 		case SAS_OPEN_TO:
 		case SAS_OPEN_REJECT:
 			SAS_DPRINTK("%s: Saw error %d.  What to do?\n",
 				    __func__, ts->stat);
 			return AC_ERR_OTHER;
 
+		case SAM_STAT_CHECK_CONDITION:
 		case SAS_ABORTED_TASK:
 			return AC_ERR_DEV;
 
@@ -107,13 +107,15 @@ static void sas_ata_task_done(struct sas_task *task)
 	sas_ha = dev->port->ha;
 
 	spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
-	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_STAT_GOOD) {
+	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_STAT_GOOD ||
+	    ((stat->stat == SAM_STAT_CHECK_CONDITION && 
+	      dev->sata_dev.command_set == ATAPI_COMMAND_SET))) {
 		ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
 		qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
 		dev->sata_dev.sstatus = resp->sstatus;
 		dev->sata_dev.serror = resp->serror;
 		dev->sata_dev.scontrol = resp->scontrol;
-	} else if (stat->stat != SAM_STAT_GOOD) {
+	} else {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
 			SAS_DPRINTK("%s: SAS error %x\n", __func__,


