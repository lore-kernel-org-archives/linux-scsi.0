From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] megaraid_sas: switch fw_outstanding to an atomic_t
Date: Mon, 6 Feb 2006 15:21:53 +0100
Message-ID: <20060206142153.GA2773@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:17117 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932124AbWBFOV5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 09:21:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreenivas.Bagalkote@lsil.com, Sumant.Patro@lsil.com
Cc: linux-scsi@vger.kernel.org

gets rid of the otherwise superflous instance_lock and avoids an unsave
unsynchronized access in the error handler.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2006-02-06 15:11:43.000000000 +0100
+++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.c	2006-02-06 15:20:19.000000000 +0100
@@ -655,7 +655,6 @@
 megasas_queue_command(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
 {
 	u32 frame_count;
-	unsigned long flags;
 	struct megasas_cmd *cmd;
 	struct megasas_instance *instance;
 
@@ -690,9 +689,7 @@
 	/*
 	 * Issue the command to the FW
 	 */
-	spin_lock_irqsave(&instance->instance_lock, flags);
-	instance->fw_outstanding++;
-	spin_unlock_irqrestore(&instance->instance_lock, flags);
+	atomic_inc(&instance->fw_outstanding);
 
 	instance->instancet->fire_cmd(cmd->frame_phys_addr ,cmd->frame_count-1,instance->reg_set);
 
@@ -735,20 +732,20 @@
 	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
 
 	for (i = 0; i < wait_time; i++) {
+		int outstanding = atomic_read(&instance->fw_outstanding);
 
-		if (!instance->fw_outstanding)
+		if (!outstanding)
 			break;
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
 			printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
-			       "commands to complete\n", i,
-			       instance->fw_outstanding);
+			       "commands to complete\n", i, outstanding);
 		}
 
 		msleep(1000);
 	}
 
-	if (instance->fw_outstanding) {
+	if (atomic_read(&instance->fw_outstanding)) {
 		instance->hw_crit_error = 1;
 		return FAILED;
 	}
@@ -960,7 +957,6 @@
 {
 	int exception = 0;
 	struct megasas_header *hdr = &cmd->frame->hdr;
-	unsigned long flags;
 
 	switch (hdr->cmd) {
 
@@ -987,10 +983,7 @@
 		}
 
 		if (exception) {
-
-			spin_lock_irqsave(&instance->instance_lock, flags);
-			instance->fw_outstanding--;
-			spin_unlock_irqrestore(&instance->instance_lock, flags);
+			atomic_dec(&instance->fw_outstanding);
 
 			megasas_unmap_sgbuf(instance, cmd);
 			cmd->scmd->scsi_done(cmd->scmd);
@@ -1038,9 +1031,7 @@
 			break;
 		}
 
-		spin_lock_irqsave(&instance->instance_lock, flags);
-		instance->fw_outstanding--;
-		spin_unlock_irqrestore(&instance->instance_lock, flags);
+		atomic_dec(&instance->fw_outstanding);
 
 		megasas_unmap_sgbuf(instance, cmd);
 		cmd->scmd->scsi_done(cmd->scmd);
@@ -2066,11 +2057,11 @@
 	 */
 	INIT_LIST_HEAD(&instance->cmd_pool);
 
+	atomic_set(&instance->fw_outstanding, 0);
 	init_waitqueue_head(&instance->int_cmd_wait_q);
 	init_waitqueue_head(&instance->abort_cmd_wait_q);
 
 	spin_lock_init(&instance->cmd_pool_lock);
-	spin_lock_init(&instance->instance_lock);
 
 	sema_init(&instance->aen_mutex, 1);
 	sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.h
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.h	2006-02-04 13:35:00.000000000 +0100
+++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.h	2006-02-06 15:19:52.000000000 +0100
@@ -1062,9 +1062,8 @@
 	struct pci_dev *pdev;
 	u32 unique_id;
 
-	u32 fw_outstanding;
+	atomic_t fw_outstanding;
 	u32 hw_crit_error;
-	spinlock_t instance_lock;
 
 	struct megasas_instance_template *instancet;
 };
