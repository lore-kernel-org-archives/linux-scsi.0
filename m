From: <Kashyap.Desai@avagotech.com>
Subject: [PATCH/RESEND] scsi.mq: Added use_cmd_list flag in scsi_host to
 reduce lock contention
Date: Wed, 20 Aug 2014 19:24:33 +0530
Message-ID: <201408201357.s7KDvDeL021549@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:55367
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750938AbaHTNzw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2014 09:55:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, hch@infradead.org, elliott@hp.com, jbottomley@parallels.com, aacraid@adaptec.com
Cc: bvanassche@acm.org

Comment provided by Bart Van and Chris H is addressed in this patch.

Add use_cmd_list flag in scsi_host to indicate scs.mq stack
to keep track of cmd_list per sdev. 

Default behaviour is not to keep track of cmd_list per sdev, as this may introduce
lock contention. (overhead is more on multi-node NUMA.)

Patch is tested using megaraid_sas driver with "use_cmd_list" value set to 1 and 0.
Added MAINTAINER of Adaptec to verify changes.

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>

--
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 63f576c..a759cb2 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1152,6 +1152,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->irq = pdev->irq;
 	shost->unique_id = unique_id;
 	shost->max_cmd_len = 16;
+	shost->use_cmd_list = 1;
 
 	aac = (struct aac_dev *)shost->hostdata;
 	aac->base_start = pci_resource_start(pdev, 0);
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 67283ef..072f0ec 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2363,6 +2363,7 @@ static s32 adpt_scsi_host_alloc(adpt_hba* pHba, struct scsi_host_template *sht)
 	host->unique_id = (u32)sys_tbl_pa + pHba->unit;
 	host->sg_tablesize = pHba->sg_tablesize;
 	host->can_queue = pHba->post_fifo_size;
+	host->use_cmd_list = 1;
 
 	return 0;
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9c44392..f9ce306 100644
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
+	if (shost->use_cmd_list) {
+		BUG_ON(list_empty(&cmd->list));
+		spin_lock_irqsave(&sdev->list_lock, flags);
+		list_del_init(&cmd->list);
+		spin_unlock_irqrestore(&sdev->list_lock, flags);
+	}
 }
 
 /*
@@ -1815,14 +1817,12 @@ static int scsi_mq_prep_fn(struct request *req)
 	INIT_LIST_HEAD(&cmd->list);
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies;
-
-	/*
-	 * XXX: cmd_list lookups are only used by two drivers, try to get
-	 * rid of this list in common code.
-	 */
-	spin_lock_irq(&sdev->list_lock);
-	list_add_tail(&cmd->list, &sdev->cmd_list);
-	spin_unlock_irq(&sdev->list_lock);
+
+	if (shost->use_cmd_list) {
+		spin_lock_irq(&sdev->list_lock);
+		list_add_tail(&cmd->list, &sdev->cmd_list);
+		spin_unlock_irq(&sdev->list_lock);
+	}
 
 	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
 	cmd->sdb.table.sgl = sg;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ba20347..cafb260 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -680,6 +680,7 @@ struct Scsi_Host {
 	unsigned no_write_same:1;
 
 	unsigned use_blk_mq:1;
+	unsigned use_cmd_list:1;
 
 	/*
 	 * Optional work queue to be utilized by the transport
