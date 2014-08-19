From: <Kashyap.Desai@avagotech.com>
Subject: [PATCH] scsi.mq:Added enable_cmd_list flags in hostt to reduce
 lock contention
Date: Tue, 19 Aug 2014 23:47:00 +0530
Message-ID: <201408191819.s7JIIx12019025@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:25950
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751576AbaHSScV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2014 14:32:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: aacraid@adaptec.com, Elliott@hp.com, bvanassche@acm.org, jbottomley@parallels.com, hch@infradead.org, kashyap.desai@avagotech.com

Add enable_cmd_list flag in shost template to indicate scs.mq stack
to keep track of cmd_list per sdev. 

Default behaviour is not to keep track of cmd_list per sdev, as this may introduce
lock contention. (overhead is more on multi-node NUMA.)

Patch is tested using megaraid_sas driver with "enable_cmd_list" value set to 1 and 0.

Added MAINTAINER of Adaptec to verify changes.

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>

--
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 63f576c..6cb5132 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1082,6 +1082,7 @@ static struct scsi_host_template aac_driver_template = {
 	.use_clustering			= ENABLE_CLUSTERING,
 	.emulated			= 1,
 	.no_write_same			= 1,
+	.enable_cmd_list		= 1,
 };
 
 static void __aac_shutdown(struct aac_dev * aac)
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 67283ef..3c91ba6 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -3565,6 +3565,7 @@ static struct scsi_host_template driver_template = {
 	.this_id		= 7,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.enable_cmd_list	= 1,
 };
 
 static int __init adpt_init(void)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9c44392..a3ddaa5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -645,16 +645,18 @@ static void scsi_mq_free_sgtables(struct scsi_cmnd *cmd)
 static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags;
 
-	BUG_ON(list_empty(&cmd->list));
-
 	scsi_mq_free_sgtables(cmd);
 	scsi_uninit_cmd(cmd);
 
-	spin_lock_irqsave(&sdev->list_lock, flags);
-	list_del_init(&cmd->list);
-	spin_unlock_irqrestore(&sdev->list_lock, flags);
+	if (shost->hostt->enable_cmd_list) {
+		BUG_ON(list_empty(&cmd->list));
+		spin_lock_irqsave(&sdev->list_lock, flags);
+		list_del_init(&cmd->list);
+		spin_unlock_irqrestore(&sdev->list_lock, flags);
+	}
 }
 
 /*
@@ -1817,12 +1819,14 @@ static int scsi_mq_prep_fn(struct request *req)
 	cmd->jiffies_at_alloc = jiffies;
 
 	/*
-	 * XXX: cmd_list lookups are only used by two drivers, try to get
-	 * rid of this list in common code.
+	 * XXX: cmd_list lookups are only used by two drivers. Try to
+	 * reduce lock contention, managing sdev cmd_list for requested driver.
 	 */
-	spin_lock_irq(&sdev->list_lock);
-	list_add_tail(&cmd->list, &sdev->cmd_list);
-	spin_unlock_irq(&sdev->list_lock);
+	if (shost->hostt->enable_cmd_list) {
+		spin_lock_irq(&sdev->list_lock);
+		list_add_tail(&cmd->list, &sdev->cmd_list);
+		spin_unlock_irq(&sdev->list_lock);
+	}
 
 	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
 	cmd->sdb.table.sgl = sg;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ba20347..ebef2eb 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -514,6 +514,9 @@ struct scsi_host_template {
 
 	/* temporary flag to disable blk-mq I/O path */
 	bool disable_blk_mq;
+
+	/* temporary flag to enable cmd_list per sdev */
+	bool enable_cmd_list;
 };
 
 /*
