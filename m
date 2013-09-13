From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 06/22] be2iscsi: Fix soft lock up issue during UE or if FW taking time to respond
Date: Thu, 12 Sep 2013 22:09:56 -0700
Message-ID: <1379049014-32716-6-git-send-email-jayamohan.kallickal@emulex.com>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33633 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab3IMFgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 01:36:31 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so775793pde.23
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2013 22:36:26 -0700 (PDT)
In-Reply-To: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 The timeout set in MBX_CMD is 100sec and the ready bit checking in BMBX
 mode is done for 4sec. After 4sec the task is scheduled out for 5 secs
 to avoid kernel soft lockup stack trace. The loop of 4sec ready bit check
 and then schedule out is done until the following conditon occur
  - The Ready Bit is Set
  - The timeout set in MBX_CMD expires

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be.h      |    2 +-
 drivers/scsi/be2iscsi/be_cmds.c |   47 +++++++++++++++++++++++++--------------
 drivers/scsi/be2iscsi/be_main.c |    5 ++---
 3 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 777e7c0..2e28f6c 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -128,7 +128,7 @@ struct be_ctrl_info {
 
 #define PAGE_SHIFT_4K 12
 #define PAGE_SIZE_4K (1 << PAGE_SHIFT_4K)
-#define mcc_timeout		120000 /* 5s timeout */
+#define mcc_timeout		120000 /* 12s timeout */
 
 /* Returns number of pages spanned by the data starting at the given addr */
 #define PAGES_4K_SPANNED(_address, size)				\
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index f7788e5..01e1915 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -490,33 +490,46 @@ int be_mcc_notify_wait(struct beiscsi_hba *phba)
  **/
 static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
 {
+#define BEISCSI_MBX_RDY_BIT_TIMEOUT	4000	/* 4sec */
 	void __iomem *db = ctrl->db + MPU_MAILBOX_DB_OFFSET;
 	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
-	uint32_t wait = 0;
+	unsigned long timeout;
+	bool read_flag = false;
+	int ret = 0, i;
 	u32 ready;
 
-	do {
+	if (beiscsi_error(phba))
+		return -EIO;
 
-		if (beiscsi_error(phba))
-			return -EIO;
+	timeout = jiffies + (HZ * 110);
 
-		ready = ioread32(db) & MPU_MAILBOX_DB_RDY_MASK;
-		if (ready)
-			break;
+	do {
+		for (i = 0; i < BEISCSI_MBX_RDY_BIT_TIMEOUT; i++) {
+			ready = ioread32(db) & MPU_MAILBOX_DB_RDY_MASK;
+			if (ready) {
+				read_flag = true;
+				break;
+			}
+			mdelay(1);
+		}
 
-		if (wait > BEISCSI_HOST_MBX_TIMEOUT) {
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-				    "BC_%d : FW Timed Out\n");
+		if (!read_flag) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(HZ * 5);
+			set_current_state(TASK_RUNNING);
+		}
+	} while ((time_before(jiffies, timeout)) && !read_flag);
+
+	if (!read_flag) {
+		beiscsi_log(phba, KERN_ERR,
+			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+			    "BC_%d : FW Timed Out\n");
 			phba->fw_timeout = true;
 			beiscsi_ue_detect(phba);
-			return -EBUSY;
-		}
+			ret = -EBUSY;
+	}
 
-		mdelay(1);
-		wait++;
-	} while (true);
-	return 0;
+	return ret;
 }
 
 /*
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 9918582..6ad36af 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5002,14 +5002,13 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	ret = beiscsi_cmd_reset_function(phba);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Reset Failed. Aborting Crashdump\n");
+			    "BM_%d : Reset Failed\n");
 		goto hba_free;
 	}
 	ret = be_chk_reset_complete(phba);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Failed to get out of reset."
-			    "Aborting Crashdump\n");
+			    "BM_%d : Failed to get out of reset.\n");
 		goto hba_free;
 	}
 
-- 
1.7.10.4

