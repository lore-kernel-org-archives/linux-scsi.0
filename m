From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 3/8] scsi: ufs: amend interrupt configuration
Date: Sun, 19 May 2013 13:51:38 +0530
Message-ID: <1368951703-2672-4-git-send-email-santoshsy@gmail.com>
References: <1368951703-2672-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58365 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3ESIWN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 May 2013 04:22:13 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp6so4803517pab.35
        for <linux-scsi@vger.kernel.org>; Sun, 19 May 2013 01:22:13 -0700 (PDT)
In-Reply-To: <1368951703-2672-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Seungwon Jeon <tgih.jun@samsung.com>, Santosh Y <santoshsy@gmail.com>

From: Seungwon Jeon <tgih.jun@samsung.com>

It makes interrupt setting more flexible especially
for disabling. And wrong bit mask is fixed for ver 1.0.
[17:16] is added for mask.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Tested-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 38412a6..aa2c8d2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -35,6 +35,10 @@
 
 #include "ufshcd.h"
 
+#define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
+				 UTP_TASK_REQ_COMPL |\
+				 UFSHCD_ERROR_MASK)
+
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
@@ -64,6 +68,20 @@ enum {
 };
 
 /**
+ * ufshcd_get_intr_mask - Get the interrupt bit mask
+ * @hba - Pointer to adapter instance
+ *
+ * Returns interrupt bit mask per version
+ */
+static inline u32 ufshcd_get_intr_mask(struct ufs_hba *hba)
+{
+	if (hba->ufs_version == UFSHCI_VERSION_10)
+		return INTERRUPT_MASK_ALL_VER_10;
+	else
+		return INTERRUPT_MASK_ALL_VER_11;
+}
+
+/**
  * ufshcd_get_ufs_version - Get the UFS version supported by the HBA
  * @hba - Pointer to adapter instance
  *
@@ -441,25 +459,45 @@ static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
 }
 
 /**
- * ufshcd_int_config - enable/disable interrupts
+ * ufshcd_enable_intr - enable interrupts
  * @hba: per adapter instance
- * @option: interrupt option
+ * @intrs: interrupt bits
  */
-static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
+static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
 {
-	switch (option) {
-	case UFSHCD_INT_ENABLE:
-		ufshcd_writel(hba, hba->int_enable_mask, REG_INTERRUPT_ENABLE);
-		break;
-	case UFSHCD_INT_DISABLE:
-		if (hba->ufs_version == UFSHCI_VERSION_10)
-			ufshcd_writel(hba, INTERRUPT_DISABLE_MASK_10,
-				      REG_INTERRUPT_ENABLE);
-		else
-			ufshcd_writel(hba, INTERRUPT_DISABLE_MASK_11,
-				      REG_INTERRUPT_ENABLE);
-		break;
+	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+
+	if (hba->ufs_version == UFSHCI_VERSION_10) {
+		u32 rw;
+		rw = set & INTERRUPT_MASK_RW_VER_10;
+		set = rw | ((set ^ intrs) & intrs);
+	} else {
+		set |= intrs;
+	}
+
+	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
+}
+
+/**
+ * ufshcd_disable_intr - disable interrupts
+ * @hba: per adapter instance
+ * @intrs: interrupt bits
+ */
+static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
+{
+	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+
+	if (hba->ufs_version == UFSHCI_VERSION_10) {
+		u32 rw;
+		rw = (set & INTERRUPT_MASK_RW_VER_10) &
+			~(intrs & INTERRUPT_MASK_RW_VER_10);
+		set = rw | ((set & intrs) & ~INTERRUPT_MASK_RW_VER_10);
+
+	} else {
+		set &= ~intrs;
 	}
+
+	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
 }
 
 /**
@@ -842,8 +880,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 	uic_cmd->argument3 = 0;
 
 	/* enable UIC related interrupts */
-	hba->int_enable_mask |= UIC_COMMAND_COMPL;
-	ufshcd_int_config(hba, UFSHCD_INT_ENABLE);
+	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
 
 	/* sending UIC commands to controller */
 	ufshcd_send_uic_command(hba, uic_cmd);
@@ -890,13 +927,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	}
 
 	/* Enable required interrupts */
-	hba->int_enable_mask |= (UTP_TRANSFER_REQ_COMPL |
-				 UIC_ERROR |
-				 UTP_TASK_REQ_COMPL |
-				 DEVICE_FATAL_ERROR |
-				 CONTROLLER_FATAL_ERROR |
-				 SYSTEM_BUS_FATAL_ERROR);
-	ufshcd_int_config(hba, UFSHCD_INT_ENABLE);
+	ufshcd_enable_intr(hba, UFSHCD_ENABLE_INTRS);
 
 	/* Configure interrupt aggregation */
 	ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
@@ -1724,7 +1755,7 @@ static void ufshcd_hba_free(struct ufs_hba *hba)
 void ufshcd_remove(struct ufs_hba *hba)
 {
 	/* disable interrupts */
-	ufshcd_int_config(hba, UFSHCD_INT_DISABLE);
+	ufshcd_disable_intr(hba, hba->intr_mask);
 
 	ufshcd_hba_stop(hba);
 	ufshcd_hba_free(hba);
@@ -1782,6 +1813,9 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	/* Get UFS version supported by the controller */
 	hba->ufs_version = ufshcd_get_ufs_version(hba);
 
+	/* Get Interrupt bit mask per version */
+	hba->intr_mask = ufshcd_get_intr_mask(hba);
+
 	/* Allocate memory for host memory space */
 	err = ufshcd_memory_alloc(hba);
 	if (err) {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6429bed..d98e046 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -153,7 +153,7 @@ struct ufs_query {
  * @ufshcd_tm_wait_queue: wait queue for task management
  * @tm_condition: condition variable for task management
  * @ufshcd_state: UFSHCD states
- * @int_enable_mask: Interrupt Mask Bits
+ * @intr_mask: Interrupt Mask Bits
  * @uic_workq: Work queue for UIC completion handling
  * @feh_workq: Work queue for fatal controller error handling
  * @errors: HBA errors
@@ -191,7 +191,7 @@ struct ufs_hba {
 	unsigned long tm_condition;
 
 	u32 ufshcd_state;
-	u32 int_enable_mask;
+	u32 intr_mask;
 
 	/* Work Queues */
 	struct work_struct uic_workq;
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 4a86247..f1e1b74 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -232,10 +232,11 @@ enum {
 /* Interrupt disable masks */
 enum {
 	/* Interrupt disable mask for UFSHCI v1.0 */
-	INTERRUPT_DISABLE_MASK_10	= 0xFFFF,
+	INTERRUPT_MASK_ALL_VER_10	= 0x30FFF,
+	INTERRUPT_MASK_RW_VER_10	= 0x30000,
 
 	/* Interrupt disable mask for UFSHCI v1.1 */
-	INTERRUPT_DISABLE_MASK_11	= 0x0,
+	INTERRUPT_MASK_ALL_VER_11	= 0x31FFF,
 };
 
 /*
-- 
1.8.2.3

