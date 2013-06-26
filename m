From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 01/10] scsi: ufs: wrap the i/o access operations
Date: Wed, 26 Jun 2013 22:33:57 +0530
Message-ID: <1372266246-2725-2-git-send-email-santoshsy@gmail.com>
References: <1372266246-2725-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:39401 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab3FZREl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jun 2013 13:04:41 -0400
Received: by mail-pa0-f51.google.com with SMTP id lf11so14419333pab.38
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2013 10:04:41 -0700 (PDT)
In-Reply-To: <1372266246-2725-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 00james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Seungwon Jeon <tgih.jun@samsung.com>, Santosh Y <santoshsy@gmail.com>

From: Seungwon Jeon <tgih.jun@samsung.com>

Simplify operations with hiding mmio_base.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Tested-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c32a478..871c2f0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -71,7 +71,7 @@ enum {
  */
 static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
 {
-	return readl(hba->mmio_base + REG_UFS_VERSION);
+	return ufshcd_readl(hba, REG_UFS_VERSION);
 }
 
 /**
@@ -130,8 +130,7 @@ static inline int ufshcd_get_tm_free_slot(struct ufs_hba *hba)
  */
 static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	writel(~(1 << pos),
-		(hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_CLEAR));
+	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
 }
 
 /**
@@ -165,7 +164,7 @@ static inline int ufshcd_get_lists_status(u32 reg)
  */
 static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
 {
-	return readl(hba->mmio_base + REG_UIC_COMMAND_ARG_2) &
+	return ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2) &
 	       MASK_UIC_COMMAND_RESULT;
 }
 
@@ -243,18 +242,15 @@ ufshcd_config_int_aggr(struct ufs_hba *hba, int option)
 {
 	switch (option) {
 	case INT_AGGR_RESET:
-		writel((INT_AGGR_ENABLE |
-			INT_AGGR_COUNTER_AND_TIMER_RESET),
-			(hba->mmio_base +
-			 REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL));
+		ufshcd_writel(hba, INT_AGGR_ENABLE |
+			      INT_AGGR_COUNTER_AND_TIMER_RESET,
+			      REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
 		break;
 	case INT_AGGR_CONFIG:
-		writel((INT_AGGR_ENABLE |
-			INT_AGGR_PARAM_WRITE |
-			INT_AGGR_COUNTER_THRESHOLD_VALUE |
-			INT_AGGR_TIMEOUT_VALUE),
-			(hba->mmio_base +
-			 REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL));
+		ufshcd_writel(hba, INT_AGGR_ENABLE | INT_AGGR_PARAM_WRITE |
+			      INT_AGGR_COUNTER_THRESHOLD_VALUE |
+			      INT_AGGR_TIMEOUT_VALUE,
+			      REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
 		break;
 	}
 }
@@ -267,12 +263,10 @@ ufshcd_config_int_aggr(struct ufs_hba *hba, int option)
  */
 static void ufshcd_enable_run_stop_reg(struct ufs_hba *hba)
 {
-	writel(UTP_TASK_REQ_LIST_RUN_STOP_BIT,
-	       (hba->mmio_base +
-		REG_UTP_TASK_REQ_LIST_RUN_STOP));
-	writel(UTP_TRANSFER_REQ_LIST_RUN_STOP_BIT,
-	       (hba->mmio_base +
-		REG_UTP_TRANSFER_REQ_LIST_RUN_STOP));
+	ufshcd_writel(hba, UTP_TASK_REQ_LIST_RUN_STOP_BIT,
+		      REG_UTP_TASK_REQ_LIST_RUN_STOP);
+	ufshcd_writel(hba, UTP_TRANSFER_REQ_LIST_RUN_STOP_BIT,
+		      REG_UTP_TRANSFER_REQ_LIST_RUN_STOP);
 }
 
 /**
@@ -281,7 +275,7 @@ static void ufshcd_enable_run_stop_reg(struct ufs_hba *hba)
  */
 static inline void ufshcd_hba_start(struct ufs_hba *hba)
 {
-	writel(CONTROLLER_ENABLE , (hba->mmio_base + REG_CONTROLLER_ENABLE));
+	ufshcd_writel(hba, CONTROLLER_ENABLE, REG_CONTROLLER_ENABLE);
 }
 
 /**
@@ -292,7 +286,7 @@ static inline void ufshcd_hba_start(struct ufs_hba *hba)
  */
 static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
 {
-	return (readl(hba->mmio_base + REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
+	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
 }
 
 /**
@@ -304,8 +298,7 @@ static inline
 void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
 	__set_bit(task_tag, &hba->outstanding_reqs);
-	writel((1 << task_tag),
-	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL));
+	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 }
 
 /**
@@ -329,8 +322,7 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
  */
 static inline void ufshcd_hba_capabilities(struct ufs_hba *hba)
 {
-	hba->capabilities =
-		readl(hba->mmio_base + REG_CONTROLLER_CAPABILITIES);
+	hba->capabilities = ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
 
 	/* nutrs and nutmrs are 0 based values */
 	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
@@ -347,16 +339,13 @@ static inline void
 ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
 {
 	/* Write Args */
-	writel(uic_cmnd->argument1,
-	      (hba->mmio_base + REG_UIC_COMMAND_ARG_1));
-	writel(uic_cmnd->argument2,
-	      (hba->mmio_base + REG_UIC_COMMAND_ARG_2));
-	writel(uic_cmnd->argument3,
-	      (hba->mmio_base + REG_UIC_COMMAND_ARG_3));
+	ufshcd_writel(hba, uic_cmnd->argument1, REG_UIC_COMMAND_ARG_1);
+	ufshcd_writel(hba, uic_cmnd->argument2, REG_UIC_COMMAND_ARG_2);
+	ufshcd_writel(hba, uic_cmnd->argument3, REG_UIC_COMMAND_ARG_3);
 
 	/* Write UIC Cmd */
-	writel((uic_cmnd->command & COMMAND_OPCODE_MASK),
-	       (hba->mmio_base + REG_UIC_COMMAND));
+	ufshcd_writel(hba, uic_cmnd->command & COMMAND_OPCODE_MASK,
+		      REG_UIC_COMMAND);
 }
 
 /**
@@ -408,16 +397,15 @@ static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
 {
 	switch (option) {
 	case UFSHCD_INT_ENABLE:
-		writel(hba->int_enable_mask,
-		      (hba->mmio_base + REG_INTERRUPT_ENABLE));
+		ufshcd_writel(hba, hba->int_enable_mask, REG_INTERRUPT_ENABLE);
 		break;
 	case UFSHCD_INT_DISABLE:
 		if (hba->ufs_version == UFSHCI_VERSION_10)
-			writel(INTERRUPT_DISABLE_MASK_10,
-			      (hba->mmio_base + REG_INTERRUPT_ENABLE));
+			ufshcd_writel(hba, INTERRUPT_DISABLE_MASK_10,
+				      REG_INTERRUPT_ENABLE);
 		else
-			writel(INTERRUPT_DISABLE_MASK_11,
-			       (hba->mmio_base + REG_INTERRUPT_ENABLE));
+			ufshcd_writel(hba, INTERRUPT_DISABLE_MASK_11,
+				      REG_INTERRUPT_ENABLE);
 		break;
 	}
 }
@@ -703,7 +691,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 	unsigned long flags;
 
 	/* check if controller is ready to accept UIC commands */
-	if (((readl(hba->mmio_base + REG_CONTROLLER_STATUS)) &
+	if ((ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
 	    UIC_COMMAND_READY) == 0x0) {
 		dev_err(hba->dev,
 			"Controller not ready"
@@ -748,7 +736,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	u32 reg;
 
 	/* check if device present */
-	reg = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
+	reg = ufshcd_readl(hba, REG_CONTROLLER_STATUS);
 	if (!ufshcd_is_device_present(reg)) {
 		dev_err(hba->dev, "cc: Device not present\n");
 		err = -ENXIO;
@@ -870,14 +858,14 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
 		return -EIO;
 
 	/* Configure UTRL and UTMRL base address registers */
-	writel(lower_32_bits(hba->utrdl_dma_addr),
-	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_L));
-	writel(upper_32_bits(hba->utrdl_dma_addr),
-	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_H));
-	writel(lower_32_bits(hba->utmrdl_dma_addr),
-	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_L));
-	writel(upper_32_bits(hba->utmrdl_dma_addr),
-	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_H));
+	ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
+		      REG_UTP_TRANSFER_REQ_LIST_BASE_L);
+	ufshcd_writel(hba, upper_32_bits(hba->utrdl_dma_addr),
+		      REG_UTP_TRANSFER_REQ_LIST_BASE_H);
+	ufshcd_writel(hba, lower_32_bits(hba->utmrdl_dma_addr),
+		      REG_UTP_TASK_REQ_LIST_BASE_L);
+	ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
+		      REG_UTP_TASK_REQ_LIST_BASE_H);
 
 	/* Initialize unipro link startup procedure */
 	return ufshcd_dme_link_startup(hba);
@@ -1169,8 +1157,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	int index;
 
 	lrb = hba->lrb;
-	tr_doorbell =
-		readl(hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
 
 	for (index = 0; index < hba->nutrs; index++) {
@@ -1244,9 +1231,7 @@ static void ufshcd_err_handler(struct ufs_hba *hba)
 		goto fatal_eh;
 
 	if (hba->errors & UIC_ERROR) {
-
-		reg = readl(hba->mmio_base +
-			    REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
+		reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
 		if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
 			goto fatal_eh;
 	}
@@ -1264,7 +1249,7 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba)
 {
 	u32 tm_doorbell;
 
-	tm_doorbell = readl(hba->mmio_base + REG_UTP_TASK_REQ_DOOR_BELL);
+	tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
 	hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
 	wake_up_interruptible(&hba->ufshcd_tm_wait_queue);
 }
@@ -1305,15 +1290,14 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	struct ufs_hba *hba = __hba;
 
 	spin_lock(hba->host->host_lock);
-	intr_status = readl(hba->mmio_base + REG_INTERRUPT_STATUS);
+	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 
 	if (intr_status) {
 		ufshcd_sl_intr(hba, intr_status);
 
 		/* If UFSHCI 1.0 then clear interrupt status register */
 		if (hba->ufs_version == UFSHCI_VERSION_10)
-			writel(intr_status,
-			       (hba->mmio_base + REG_INTERRUPT_STATUS));
+			ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
 		retval = IRQ_HANDLED;
 	}
 	spin_unlock(hba->host->host_lock);
@@ -1378,8 +1362,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 
 	/* send command to the controller */
 	__set_bit(free_slot, &hba->outstanding_tasks);
-	writel((1 << free_slot),
-	       (hba->mmio_base + REG_UTP_TASK_REQ_DOOR_BELL));
+	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
 
 	spin_unlock_irqrestore(host->host_lock, flags);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6b99a42..807dd2d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -186,6 +186,11 @@ struct ufs_hba {
 	u32 errors;
 };
 
+#define ufshcd_writel(hba, val, reg)	\
+	writel((val), (hba)->mmio_base + (reg))
+#define ufshcd_readl(hba, reg)	\
+	readl((hba)->mmio_base + (reg))
+
 int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
 			unsigned int);
 void ufshcd_remove(struct ufs_hba *);
@@ -196,7 +201,7 @@ void ufshcd_remove(struct ufs_hba *);
  */
 static inline void ufshcd_hba_stop(struct ufs_hba *hba)
 {
-	writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
+	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
 }
 
 #endif /* End of Header */
-- 
1.8.3.1

