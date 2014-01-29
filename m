From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 4/8] be2iscsi: Fix doorbell format for EQ/CQ/RQ s per SLI spec.
Date: Wed, 29 Jan 2014 02:16:42 -0500
Message-ID: <1390979807-16718-4-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:56338 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaA2HRD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2014 02:17:03 -0500
Received: by mail-pa0-f54.google.com with SMTP id fa1so1415251pad.41
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2014 23:17:02 -0800 (PST)
In-Reply-To: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 The doorbel format has been updated to support additonal functionalities
 of SKH-R adapter. These changes are made such that older FW also works fine.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 14 +-------------
 drivers/scsi/be2iscsi/be_cmds.h |  6 +++---
 drivers/scsi/be2iscsi/be_main.c | 25 ++++++++++++++++++++++---
 drivers/scsi/be2iscsi/be_main.h | 16 ++++++++++++++--
 4 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index b14949a..86d91f3 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -432,18 +432,6 @@ void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
 	}
 }
 
-static void beiscsi_cq_notify(struct beiscsi_hba *phba, u16 qid, bool arm,
-		       u16 num_popped)
-{
-	u32 val = 0;
-	val |= qid & DB_CQ_RING_ID_MASK;
-	if (arm)
-		val |= 1 << DB_CQ_REARM_SHIFT;
-	val |= num_popped << DB_CQ_NUM_POPPED_SHIFT;
-	iowrite32(val, phba->db_va + DB_CQ_OFFSET);
-}
-
-
 int beiscsi_process_mcc(struct beiscsi_hba *phba)
 {
 	struct be_mcc_compl *compl;
@@ -474,7 +462,7 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
 	}
 
 	if (num)
-		beiscsi_cq_notify(phba, phba->ctrl.mcc_obj.cq.id, true, num);
+		hwi_ring_cq_db(phba, phba->ctrl.mcc_obj.cq.id, num, 1, 0);
 
 	spin_unlock_bh(&phba->ctrl.mcc_cq_lock);
 	return status;
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 69f849e..59abd27 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -103,7 +103,7 @@ struct be_mcc_compl {
 
 /********** MCC door bell ************/
 #define DB_MCCQ_OFFSET 0x140
-#define DB_MCCQ_RING_ID_MASK 0x7FF		/* bits 0 - 10 */
+#define DB_MCCQ_RING_ID_MASK 0xFFFF		/* bits 0 - 15 */
 /* Number of entries posted */
 #define DB_MCCQ_NUM_POSTED_SHIFT 16		/* bits 16 - 29 */
 
@@ -1025,8 +1025,8 @@ struct be_mcc_wrb_context {
 	int *users_final_status;
 } __packed;
 
-#define DB_DEF_PDU_RING_ID_MASK		0x3FF	/* bits 0 - 9 */
-#define DB_DEF_PDU_CQPROC_MASK		0x3FFF	/* bits 0 - 9 */
+#define DB_DEF_PDU_RING_ID_MASK	0x3FFF	/* bits 0 - 13 */
+#define DB_DEF_PDU_CQPROC_MASK		0x3FFF	/* bits 16 - 29 */
 #define DB_DEF_PDU_REARM_SHIFT		14
 #define DB_DEF_PDU_EVENT_SHIFT		15
 #define DB_DEF_PDU_CQPROC_SHIFT		16
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 89bf558..257e2d2 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -811,14 +811,23 @@ static void hwi_ring_eq_db(struct beiscsi_hba *phba,
 			   unsigned char rearm, unsigned char event)
 {
 	u32 val = 0;
-	val |= id & DB_EQ_RING_ID_MASK;
+
 	if (rearm)
 		val |= 1 << DB_EQ_REARM_SHIFT;
 	if (clr_interrupt)
 		val |= 1 << DB_EQ_CLR_SHIFT;
 	if (event)
 		val |= 1 << DB_EQ_EVNT_SHIFT;
+
 	val |= num_processed << DB_EQ_NUM_POPPED_SHIFT;
+	/* Setting lower order EQ_ID Bits */
+	val |= (id & DB_EQ_RING_ID_LOW_MASK);
+
+	/* Setting Higher order EQ_ID Bits */
+	val |= (((id >> DB_EQ_HIGH_FEILD_SHIFT) &
+		  DB_EQ_RING_ID_HIGH_MASK)
+		  << DB_EQ_HIGH_SET_SHIFT);
+
 	iowrite32(val, phba->db_va + DB_EQ_OFFSET);
 }
 
@@ -1150,15 +1159,25 @@ free_msix_irqs:
 	return ret;
 }
 
-static void hwi_ring_cq_db(struct beiscsi_hba *phba,
+void hwi_ring_cq_db(struct beiscsi_hba *phba,
 			   unsigned int id, unsigned int num_processed,
 			   unsigned char rearm, unsigned char event)
 {
 	u32 val = 0;
-	val |= id & DB_CQ_RING_ID_MASK;
+
 	if (rearm)
 		val |= 1 << DB_CQ_REARM_SHIFT;
+
 	val |= num_processed << DB_CQ_NUM_POPPED_SHIFT;
+
+	/* Setting lower order CQ_ID Bits */
+	val |= (id & DB_CQ_RING_ID_LOW_MASK);
+
+	/* Setting Higher order CQ_ID Bits */
+	val |= (((id >> DB_CQ_HIGH_FEILD_SHIFT) &
+		  DB_CQ_RING_ID_HIGH_MASK)
+		  << DB_CQ_HIGH_SET_SHIFT);
+
 	iowrite32(val, phba->db_va + DB_CQ_OFFSET);
 }
 
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 0076119..224a8ae 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -135,11 +135,15 @@
 #define DB_RXULP0_OFFSET 0xA0
 /********* Event Q door bell *************/
 #define DB_EQ_OFFSET			DB_CQ_OFFSET
-#define DB_EQ_RING_ID_MASK		0x1FF	/* bits 0 - 8 */
+#define DB_EQ_RING_ID_LOW_MASK		0x1FF	/* bits 0 - 8 */
 /* Clear the interrupt for this eq */
 #define DB_EQ_CLR_SHIFT			(9)	/* bit 9 */
 /* Must be 1 */
 #define DB_EQ_EVNT_SHIFT		(10)	/* bit 10 */
+/* Higher Order EQ_ID bit */
+#define DB_EQ_RING_ID_HIGH_MASK	0x1F /* bits 11 - 15 */
+#define DB_EQ_HIGH_SET_SHIFT	11
+#define DB_EQ_HIGH_FEILD_SHIFT	9
 /* Number of event entries processed */
 #define DB_EQ_NUM_POPPED_SHIFT		(16)	/* bits 16 - 28 */
 /* Rearm bit */
@@ -147,7 +151,12 @@
 
 /********* Compl Q door bell *************/
 #define DB_CQ_OFFSET			0x120
-#define DB_CQ_RING_ID_MASK		0x3FF	/* bits 0 - 9 */
+#define DB_CQ_RING_ID_LOW_MASK		0x3FF	/* bits 0 - 9 */
+/* Higher Order CQ_ID bit */
+#define DB_CQ_RING_ID_HIGH_MASK	0x1F /* bits 11 - 15 */
+#define DB_CQ_HIGH_SET_SHIFT	11
+#define DB_CQ_HIGH_FEILD_SHIFT	10
+
 /* Number of event entries processed */
 #define DB_CQ_NUM_POPPED_SHIFT		(16)	/* bits 16 - 28 */
 /* Rearm bit */
@@ -833,6 +842,9 @@ void beiscsi_process_all_cqs(struct work_struct *work);
 void beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn,
 				     struct iscsi_task *task);
 
+void hwi_ring_cq_db(struct beiscsi_hba *phba,
+		     unsigned int id, unsigned int num_processed,
+		     unsigned char rearm, unsigned char event);
 static inline bool beiscsi_error(struct beiscsi_hba *phba)
 {
 	return phba->ue_detected || phba->fw_timeout;
-- 
1.8.5.3

