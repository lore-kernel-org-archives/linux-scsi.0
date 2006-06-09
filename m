From: akpm@osdl.org
Subject: [patch 26/31] megaraid_sas: switch fw_outstanding to an atomic_t
Date: Thu, 08 Jun 2006 22:23:57 -0700
Message-ID: <200606090523.k595Nv6d032348@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:18397 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965172AbWFIFYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 01:24:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, sumantp@lsil.com, hch@lst.de, Sumant.Patro@lsil.com


From: Sumant Patro <sumantp@lsil.com>

This patch( originally submitted by Christoph Hellwig) removes
instance_lock and changes fw_outstanding variable data type to atomic_t.

Signed-off-by: Sumant Patro <Sumant.Patro@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/scsi/ChangeLog.megaraid_sas |   13 ++++++++++
 drivers/scsi/megaraid/megaraid_sas.c      |   26 +++++++-------------
 drivers/scsi/megaraid/megaraid_sas.h      |    3 --
 3 files changed, 24 insertions(+), 18 deletions(-)

diff -puN Documentation/scsi/ChangeLog.megaraid_sas~megaraid_sas-switch-fw_outstanding-to-an-atomic_t Documentation/scsi/ChangeLog.megaraid_sas
--- devel/Documentation/scsi/ChangeLog.megaraid_sas~megaraid_sas-switch-fw_outstanding-to-an-atomic_t	2006-05-30 17:51:39.000000000 -0700
+++ devel-akpm/Documentation/scsi/ChangeLog.megaraid_sas	2006-05-30 17:51:39.000000000 -0700
@@ -1,3 +1,16 @@
+
+1 Release Date    : Wed Feb 03 14:31:44 PST 2006 - Sumant Patro <Sumant.Patro@lsil.com>
+2 Current Version : 00.00.02.04
+3 Older Version   : 00.00.02.04
+
+i.	Remove superflous instance_lock
+
+	gets rid of the otherwise superflous instance_lock and avoids an unsave
+	unsynchronized access in the error handler.
+
+		- Christoph Hellwig <hch@lst.de>
+
+
 1 Release Date    : Wed Feb 03 14:31:44 PST 2006 - Sumant Patro <Sumant.Patro@lsil.com>
 2 Current Version : 00.00.02.04
 3 Older Version   : 00.00.02.04 
diff -puN drivers/scsi/megaraid/megaraid_sas.c~megaraid_sas-switch-fw_outstanding-to-an-atomic_t drivers/scsi/megaraid/megaraid_sas.c
--- devel/drivers/scsi/megaraid/megaraid_sas.c~megaraid_sas-switch-fw_outstanding-to-an-atomic_t	2006-05-30 17:51:39.000000000 -0700
+++ devel-akpm/drivers/scsi/megaraid/megaraid_sas.c	2006-05-30 17:51:39.000000000 -0700
@@ -741,7 +741,6 @@ static int
 megasas_queue_command(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
 {
 	u32 frame_count;
-	unsigned long flags;
 	struct megasas_cmd *cmd;
 	struct megasas_instance *instance;
 
@@ -776,9 +775,7 @@ megasas_queue_command(struct scsi_cmnd *
 	/*
 	 * Issue the command to the FW
 	 */
-	spin_lock_irqsave(&instance->instance_lock, flags);
-	instance->fw_outstanding++;
-	spin_unlock_irqrestore(&instance->instance_lock, flags);
+	atomic_inc(&instance->fw_outstanding);
 
 	instance->instancet->fire_cmd(cmd->frame_phys_addr ,cmd->frame_count-1,instance->reg_set);
 
@@ -826,19 +823,20 @@ static int megasas_wait_for_outstanding(
 
 	for (i = 0; i < wait_time; i++) {
 
-		if (!instance->fw_outstanding)
+		int outstanding = atomic_read(&instance->fw_outstanding);
+
+		if (!outstanding)
 			break;
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
 			printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
-			       "commands to complete\n", i,
-			       instance->fw_outstanding);
+			       "commands to complete\n",i,outstanding);
 		}
 
 		msleep(1000);
 	}
 
-	if (instance->fw_outstanding) {
+	if (atomic_read(&instance->fw_outstanding)) {
 		instance->hw_crit_error = 1;
 		return FAILED;
 	}
@@ -1050,7 +1048,6 @@ megasas_complete_cmd(struct megasas_inst
 {
 	int exception = 0;
 	struct megasas_header *hdr = &cmd->frame->hdr;
-	unsigned long flags;
 
 	if (cmd->scmd) {
 		cmd->scmd->SCp.ptr = (char *)0;
@@ -1082,9 +1079,7 @@ megasas_complete_cmd(struct megasas_inst
 
 		if (exception) {
 
-			spin_lock_irqsave(&instance->instance_lock, flags);
-			instance->fw_outstanding--;
-			spin_unlock_irqrestore(&instance->instance_lock, flags);
+			atomic_dec(&instance->fw_outstanding);
 
 			megasas_unmap_sgbuf(instance, cmd);
 			cmd->scmd->scsi_done(cmd->scmd);
@@ -1132,9 +1127,7 @@ megasas_complete_cmd(struct megasas_inst
 			break;
 		}
 
-		spin_lock_irqsave(&instance->instance_lock, flags);
-		instance->fw_outstanding--;
-		spin_unlock_irqrestore(&instance->instance_lock, flags);
+		atomic_dec(&instance->fw_outstanding);
 
 		megasas_unmap_sgbuf(instance, cmd);
 		cmd->scmd->scsi_done(cmd->scmd);
@@ -2171,11 +2164,12 @@ megasas_probe_one(struct pci_dev *pdev, 
 	 */
 	INIT_LIST_HEAD(&instance->cmd_pool);
 
+	atomic_set(&instance->fw_outstanding,0);
+
 	init_waitqueue_head(&instance->int_cmd_wait_q);
 	init_waitqueue_head(&instance->abort_cmd_wait_q);
 
 	spin_lock_init(&instance->cmd_pool_lock);
-	spin_lock_init(&instance->instance_lock);
 
 	sema_init(&instance->aen_mutex, 1);
 	sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
diff -puN drivers/scsi/megaraid/megaraid_sas.h~megaraid_sas-switch-fw_outstanding-to-an-atomic_t drivers/scsi/megaraid/megaraid_sas.h
--- devel/drivers/scsi/megaraid/megaraid_sas.h~megaraid_sas-switch-fw_outstanding-to-an-atomic_t	2006-05-30 17:51:39.000000000 -0700
+++ devel-akpm/drivers/scsi/megaraid/megaraid_sas.h	2006-05-30 17:51:39.000000000 -0700
@@ -1077,9 +1077,8 @@ struct megasas_instance {
 	struct pci_dev *pdev;
 	u32 unique_id;
 
-	u32 fw_outstanding;
+	atomic_t fw_outstanding;
 	u32 hw_crit_error;
-	spinlock_t instance_lock;
 
 	struct megasas_instance_template *instancet;
 };
_
