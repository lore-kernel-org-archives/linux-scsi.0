From: akpm@linux-foundation.org
Subject: [patch 30/30] libsas: convert ATA bridge to use new EH
Date: Thu, 13 Dec 2007 16:14:33 -0800
Message-ID: <200712140014.lBE0EXq1026273@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39544 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761642AbXLNAYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:24:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, djwong@us.ibm.com, jeff@garzik.org

From: "Darrick J. Wong" <djwong@us.ibm.com>

Migrate the sas_ata bridge to use the new libata EH strategy, and
finally implement correct software reset.

WARNING WARNING WARNING!  This patch is for experimental use only; it is
nowhere near complete!  Especially the sas_ata_freeze() function.  This
patch may eat your data and kill your trees.

jgarzik: If an ATA command was in-progress at the time of a port freeze,
can complete after thawing?  (Does that even make sense?)

[akpm@linux-foundation.org: coding-style fixes]
Comments-requested-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libsas/sas_ata.c |   86 ++++++++++++++++++++++++++------
 1 file changed, 71 insertions(+), 15 deletions(-)

diff -puN drivers/scsi/libsas/sas_ata.c~libsas-convert-ata-bridge-to-use-new-eh drivers/scsi/libsas/sas_ata.c
--- a/drivers/scsi/libsas/sas_ata.c~libsas-convert-ata-bridge-to-use-new-eh
+++ a/drivers/scsi/libsas/sas_ata.c
@@ -35,6 +35,8 @@
 #include "../scsi_transport_api.h"
 #include <scsi/scsi_eh.h>
 
+static int sas_issue_ata_srst(struct domain_device *dev);
+
 static enum ata_completion_errors sas_to_ata_err(struct task_status_struct *ts)
 {
 	/* Cheesy attempt to translate SAS errors into ATA.  Hah! */
@@ -233,37 +235,58 @@ static u8 sas_ata_check_status(struct at
 	return dev->sata_dev.tf.command;
 }
 
-static void sas_ata_phy_reset(struct ata_port *ap)
+static void sas_ata_freeze(struct ata_port *ap)
 {
-	struct domain_device *dev = ap->private_data;
-	struct sas_internal *i =
-		to_sas_internal(dev->port->ha->core.shost->transportt);
-	int res = 0;
+	/* reroute qc_done for all qc's on this port to a dumb free func */
+	/* i wonder if we can get away with throwing out anything that
+	 * completes in this time frame, or if we must find the commands
+	 * that are in progress and cancel only those? */
+	printk(KERN_ERR "%s: STUB\n", __FUNCTION__);
+}
 
-	if (i->dft->lldd_I_T_nexus_reset)
-		res = i->dft->lldd_I_T_nexus_reset(dev);
+static void sas_ata_thaw(struct ata_port *ap)
+{
+	/* empty */
+	printk(KERN_ERR "%s: STUB\n", __FUNCTION__);
+}
 
-	if (res)
-		SAS_DPRINTK("%s: Unable to reset I T nexus?\n", __FUNCTION__);
+static int sas_ata_soft_reset(struct ata_link *link, unsigned int *classes,
+			       unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct domain_device *dev = ap->private_data;
+	int res;
 
+	/* Send SRST to device */
+	res = sas_issue_ata_srst(dev);
+	printk(KERN_ERR "srst 0 returns %d\n", res);
+
+	/* Set new device type */
 	switch (dev->sata_dev.command_set) {
 		case ATA_COMMAND_SET:
 			SAS_DPRINTK("%s: Found ATA device.\n", __FUNCTION__);
-			ap->link.device[0].class = ATA_DEV_ATA;
+			*classes = ATA_DEV_ATA;
 			break;
 		case ATAPI_COMMAND_SET:
 			SAS_DPRINTK("%s: Found ATAPI device.\n", __FUNCTION__);
-			ap->link.device[0].class = ATA_DEV_ATAPI;
+			*classes = ATA_DEV_ATAPI;
 			break;
 		default:
 			SAS_DPRINTK("%s: Unknown SATA command set: %d.\n",
 				    __FUNCTION__,
 				    dev->sata_dev.command_set);
-			ap->link.device[0].class = ATA_DEV_UNKNOWN;
-			break;
+			*classes = ATA_DEV_UNKNOWN;
+		break;
 	}
 
-	ap->cbl = ATA_CBL_SATA;
+	/* FIXME: What if SRST fails? */
+	return 0;
+}
+
+static void sas_ata_error_handler(struct ata_port *ap)
+{
+	ata_do_eh(ap, NULL, sas_ata_soft_reset, NULL, NULL);
+	/* uh... hopefully there's no commands left in here? */
 }
 
 static void sas_ata_post_internal(struct ata_queued_cmd *qc)
@@ -353,7 +376,9 @@ static struct ata_port_operations sas_sa
 	.check_status		= sas_ata_check_status,
 	.check_altstatus	= sas_ata_check_status,
 	.dev_select		= ata_noop_dev_select,
-	.phy_reset		= sas_ata_phy_reset,
+	.error_handler		= sas_ata_error_handler,
+	.freeze			= sas_ata_freeze,
+	.thaw			= sas_ata_thaw,
 	.post_internal_cmd	= sas_ata_post_internal,
 	.tf_read		= sas_ata_tf_read,
 	.qc_prep		= ata_noop_qc_prep,
@@ -658,6 +683,37 @@ out:
 	return res;
 }
 
+static int sas_issue_ata_srst(struct domain_device *dev)
+{
+	int res = 0;
+	struct sas_task *task;
+	struct dev_to_host_fis *d2h_fis = (struct dev_to_host_fis *)
+		&dev->frame_rcvd[0];
+
+	res = -ENOMEM;
+	task = sas_alloc_task(GFP_KERNEL);
+	if (!task)
+		goto out;
+
+	task->dev = dev;
+
+	task->ata_task.fis.fis_type = 0x27;
+	/* FIXME: What's a good dummy command? */
+	task->ata_task.fis.command = ATA_CMD_CHK_POWER;
+	task->ata_task.fis.features = 0;
+	task->ata_task.fis.control = ATA_SRST;
+	task->ata_task.fis.device = d2h_fis->device;
+	task->ata_task.retry_count = 1;
+	task->ata_task.device_control_reg_update = 1;
+
+	res = sas_execute_task(task, NULL, 0, DMA_NONE);
+
+	sas_free_task(task);
+out:
+
+	return res;
+}
+
 static void sas_sata_propagate_sas_addr(struct domain_device *dev)
 {
 	unsigned long flags;
_
