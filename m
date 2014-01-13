From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 5/7] be2iscsi: Fix doorbell format for EQ/CQ/RQ s per SLI spec.
Date: Sun, 12 Jan 2014 16:42:18 -0800
Message-ID: <1389573741-3523-5-git-send-email-jayamohan.kallickal@emulex.com>
References: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38181 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaAMCiS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2014 21:38:18 -0500
Received: by mail-pb0-f44.google.com with SMTP id rr13so35545pbb.17
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2014 18:38:17 -0800 (PST)
In-Reply-To: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 The doorbel format has been updated to support additonal functionalities
 of SKH-R adapter. These changes are made such that older FW also works fine.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   12 +++++++++++-
 drivers/scsi/be2iscsi/be_cmds.h |    6 +++---
 drivers/scsi/be2iscsi/be_main.c |   23 +++++++++++++++++++++--
 drivers/scsi/be2iscsi/be_main.h |   13 +++++++++++--
 4 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index b14949a..4e1074a 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -436,10 +436,20 @@ static void beiscsi_cq_notify(struct beiscsi_hba *phba, u16 qid, bool arm,
 		       u16 num_popped)
 {
 	u32 val = 0;
-	val |= qid & DB_CQ_RING_ID_MASK;
+
 	if (arm)
 		val |= 1 << DB_CQ_REARM_SHIFT;
+
 	val |= num_popped << DB_CQ_NUM_POPPED_SHIFT;
+
+	/* Setting lower order CQ_ID Bits */
+	val |= qid & DB_CQ_RING_ID_LOW_MASK;
+
+	/* Setting Higher order CQ_ID Bits */
+	val |= (((qid >> DB_CQ_HIGH_FEILD_SHIFT) &
+		  DB_CQ_RING_ID_HIGH_MASK)
+		  << DB_CQ_HIGH_SET_SHIFT);
+
 	iowrite32(val, phba->db_va + DB_CQ_OFFSET);
 }
 
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
index a045f06..8e19b90 100644
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
 
@@ -1155,10 +1164,20 @@ static void hwi_ring_cq_db(struct beiscsi_hba *phba,
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
index d21ad9e..62c5a24 100644
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
-- 
1.7.10.4

