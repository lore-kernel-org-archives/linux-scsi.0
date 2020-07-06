Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3801CC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12259206DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:10:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tiNWYH0H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgGFTK1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 15:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgGFTK1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 15:10:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D200C061755
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 12:10:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u64so29388437ybf.13
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2020 12:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dF6/JXA4hP7b0BrbwP30e66/0UmAA6OsRYGsf9RvAVM=;
        b=tiNWYH0Hc7eogLc2ps3L/mQNmFmC1pzHc+aPGLUPmmMfuu2HIhicTfu9bYNULWKfut
         EtWgdSobVR3rpO2Nfp2PO/sg+B936GO4o+zUueCllmem5EqNcektNJOY+/edDlxMdAx4
         AaVMayQpXZkT5MWaIGMeNTmmLdizdhMOFS17vlBYYKZuFuCNROLTrUlpj3OPf7SPWXUZ
         B+sVLI79zRr0u3Hx1N/oIFOh16/BVgLbIKjVOcF4sJK4rPLVm+8Nec+DFQnFhMJa8DJh
         lZI14XZI3IHL6/7MK3wjpasjktiaSwE0We+YEalT63vyfPCyb3m5M4zW74GbEN8nPZKp
         0RHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dF6/JXA4hP7b0BrbwP30e66/0UmAA6OsRYGsf9RvAVM=;
        b=ajKVV/Hm+UTt1e8P4vImvcieJhTrpMC22Dc6LoaRMJF34fEKDGl7LdCv4MaEXvJ1Fa
         a351/dGSmS+OMjScprjT6+256SXVI33/oNNI7xze/o4A+Vh9JX0Fm2vecy6lhJL3m7lj
         26UOjNnSINxH0hS7XLUprzV50pPtLVkNXcktb6OpQm8hyBKmcswSDiqs8K0Y/MaqKuRx
         4D8FIe26Y3cnG4uvzS7VG82htPy8IeINZWxFj8uDUDDhISbVfBChHSL+qfCGFHrynAO/
         KInkVHm288Nsl4PuDBVyUqpZ0SKYW2ooXRUHnnYThYuT1ryd5He6OeNVGbb9etEyrdVF
         j+Uw==
X-Gm-Message-State: AOAM531aMLZ1+Y0CmvQm0/CWub+Hwsrh94obPgC7Anpq3nC8ra45n9LB
        j2Oab27y65AcTSPMbqGHmWkqk8XsEY0T3lmG9kHJy3LhvzsvXQlu+OvwbjjTQT47KcgqlLd6NnH
        0LFMga2p6UDyTtlfynCIVJIvBJ85gsOAsuTdYMBl9dNrKkNXC7As+Ouu97t/qa9AT1EM=
X-Google-Smtp-Source: ABdhPJxWbUbtgr5U8QzZwtHrXA4W2Z2I8MfOqxTmP1FQf+UZfNZq6nDD9bpiXKBcr1+SiuWwmMk0sY9AIIY=
X-Received: by 2002:a25:db03:: with SMTP id g3mr88948702ybf.100.1594062626399;
 Mon, 06 Jul 2020 12:10:26 -0700 (PDT)
Date:   Mon,  6 Jul 2020 19:10:16 +0000
In-Reply-To: <20200706191016.2012191-1-satyat@google.com>
Message-Id: <20200706191016.2012191-4-satyat@google.com>
Mime-Version: 1.0
References: <20200706191016.2012191-1-satyat@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v3 3/3] scsi: ufs: Add inline encryption support to UFS
From:   Satya Tangirala <satyat@google.com>
To:     linux-scsi@vger.kernel.org
Cc:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Wire up ufshcd.c with the UFS Crypto API, the block layer inline
encryption additions and the keyslot manager.

Many existing inline crypto devices require some additional behaviour not
specified in the UFSHCI v2.1 specification - as such the vendor specific
drivers will need to be updated where necessary to make it possible to use
those devices. Some of these changes have already been proposed upstream,
such as for the Qualcomm 845 SoC at
https://lkml.kernel.org/linux-scsi/20200501045111.665881-1-ebiggers@kernel.org/
and for ufs-mediatek at
https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-stanley.chu@mediatek.com/

This patch has been tested on the db845c, sm8150-mtp and sm8250-mtp
(which have Qualcomm chipsets) and on some mediatek chipsets using these
aforementioned vendor specific driver updates.

Signed-off-by: Satya Tangirala <satyat@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd-crypto.c | 30 ++++++++++++++------
 drivers/scsi/ufs/ufshcd-crypto.h | 41 +++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.c        | 48 +++++++++++++++++++++++++++-----
 drivers/scsi/ufs/ufshcd.h        |  6 ++++
 4 files changed, 107 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index 65a3115d2a2d..c13cf42652aa 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -138,18 +138,17 @@ ufshcd_find_blk_crypto_mode(union ufs_crypto_cap_entry cap)
 }
 
 /**
- * ufshcd_hba_init_crypto - Read crypto capabilities, init crypto fields in hba
+ * ufshcd_hba_init_crypto_capabilities - Read crypto capabilities, init crypto
+ *					 fields in hba
  * @hba: Per adapter instance
  *
  * Return: 0 if crypto was initialized or is not supported, else a -errno value.
  */
-int ufshcd_hba_init_crypto(struct ufs_hba *hba)
+int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 {
 	int cap_idx = 0;
 	int err = 0;
 	enum blk_crypto_mode_num blk_mode_num;
-	int slot = 0;
-	int num_keyslots;
 
 	/*
 	 * Don't use crypto if either the hardware doesn't advertise the
@@ -173,8 +172,8 @@ int ufshcd_hba_init_crypto(struct ufs_hba *hba)
 	}
 
 	/* The actual number of configurations supported is (CFGC+1) */
-	num_keyslots = hba->crypto_capabilities.config_count + 1;
-	err = blk_ksm_init(&hba->ksm, num_keyslots);
+	err = blk_ksm_init(&hba->ksm,
+			   hba->crypto_capabilities.config_count + 1);
 	if (err)
 		goto out_free_caps;
 
@@ -200,9 +199,6 @@ int ufshcd_hba_init_crypto(struct ufs_hba *hba)
 				hba->crypto_cap_array[cap_idx].sdus_mask * 512;
 	}
 
-	for (slot = 0; slot < num_keyslots; slot++)
-		ufshcd_clear_keyslot(hba, slot);
-
 	return 0;
 
 out_free_caps:
@@ -213,6 +209,22 @@ int ufshcd_hba_init_crypto(struct ufs_hba *hba)
 	return err;
 }
 
+/**
+ * ufshcd_init_crypto - Initialize crypto hardware
+ * @hba: Per adapter instance
+ */
+void ufshcd_init_crypto(struct ufs_hba *hba)
+{
+	int slot = 0;
+
+	if (!(hba->caps & UFSHCD_CAP_CRYPTO))
+		return;
+
+	/* Clear all keyslots - the number of keyslots is (CFGC + 1) */
+	for (slot = 0; slot < hba->crypto_capabilities.config_count + 1; slot++)
+		ufshcd_clear_keyslot(hba, slot);
+}
+
 void ufshcd_crypto_setup_rq_keyslot_manager(struct ufs_hba *hba,
 					    struct request_queue *q)
 {
diff --git a/drivers/scsi/ufs/ufshcd-crypto.h b/drivers/scsi/ufs/ufshcd-crypto.h
index 22677619de59..2512aef03f76 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.h
+++ b/drivers/scsi/ufs/ufshcd-crypto.h
@@ -10,9 +10,36 @@
 #include "ufshcd.h"
 #include "ufshci.h"
 
+static inline void ufshcd_prepare_lrbp_crypto(struct ufs_hba *hba,
+					      struct request *rq,
+					      struct ufshcd_lrb *lrbp)
+{
+	if (!rq || !rq->crypt_keyslot) {
+		lrbp->crypto_key_slot = -1;
+		return;
+	}
+
+	lrbp->crypto_key_slot = blk_ksm_get_slot_idx(rq->crypt_keyslot);
+	lrbp->data_unit_num = rq->crypt_ctx->bc_dun[0];
+}
+
+static inline void
+ufshcd_prepare_req_desc_hdr_crypto(struct ufshcd_lrb *lrbp, u32 *dword_0,
+				   u32 *dword_1, u32 *dword_3)
+{
+	if (lrbp->crypto_key_slot >= 0) {
+		*dword_0 |= UTP_REQ_DESC_CRYPTO_ENABLE_CMD;
+		*dword_0 |= lrbp->crypto_key_slot;
+		*dword_1 = lower_32_bits(lrbp->data_unit_num);
+		*dword_3 = upper_32_bits(lrbp->data_unit_num);
+	}
+}
+
 bool ufshcd_crypto_enable(struct ufs_hba *hba);
 
-int ufshcd_hba_init_crypto(struct ufs_hba *hba);
+void ufshcd_init_crypto(struct ufs_hba *hba);
+
+int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba);
 
 void ufshcd_crypto_setup_rq_keyslot_manager(struct ufs_hba *hba,
 					    struct request_queue *q);
@@ -21,12 +48,22 @@ void ufshcd_crypto_destroy_keyslot_manager(struct ufs_hba *hba);
 
 #else /* CONFIG_SCSI_UFS_CRYPTO */
 
+static inline void ufshcd_prepare_lrbp_crypto(struct ufs_hba *hba,
+					      struct request *rq,
+					      struct ufshcd_lrb *lrbp) { }
+
+static inline void
+ufshcd_prepare_req_desc_hdr_crypto(struct ufshcd_lrb *lrbp, u32 *dword_0,
+				   u32 *dword_1, u32 *dword_3) { }
+
 static inline bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
 	return false;
 }
 
-static inline int ufshcd_hba_init_crypto(struct ufs_hba *hba)
+static inline void ufshcd_init_crypto(struct ufs_hba *hba) { }
+
+static inline int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 {
 	return 0;
 }
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4fdb200de46c..5b2e0689b7fc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -48,6 +48,7 @@
 #include "unipro.h"
 #include "ufs-sysfs.h"
 #include "ufs_bsg.h"
+#include "ufshcd-crypto.h"
 #include <asm/unaligned.h>
 #include <linux/blkdev.h>
 
@@ -839,7 +840,12 @@ static void ufshcd_enable_run_stop_reg(struct ufs_hba *hba)
  */
 static inline void ufshcd_hba_start(struct ufs_hba *hba)
 {
-	ufshcd_writel(hba, CONTROLLER_ENABLE, REG_CONTROLLER_ENABLE);
+	u32 val = CONTROLLER_ENABLE;
+
+	if (ufshcd_crypto_enable(hba))
+		val |= CRYPTO_GENERAL_ENABLE;
+
+	ufshcd_writel(hba, val, REG_CONTROLLER_ENABLE);
 }
 
 /**
@@ -1996,15 +2002,26 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 /**
  * ufshcd_hba_capabilities - Read controller capabilities
  * @hba: per adapter instance
+ *
+ * Return: 0 on success, negative on error.
  */
-static inline void ufshcd_hba_capabilities(struct ufs_hba *hba)
+static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 {
+	int err;
+
 	hba->capabilities = ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
 
 	/* nutrs and nutmrs are 0 based values */
 	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
 	hba->nutmrs =
 	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
+
+	/* Read crypto capabilities */
+	err = ufshcd_hba_init_crypto_capabilities(hba);
+	if (err)
+		dev_err(hba->dev, "crypto setup failed\n");
+
+	return err;
 }
 
 /**
@@ -2237,6 +2254,8 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 	struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
 	u32 data_direction;
 	u32 dword_0;
+	u32 dword_1 = 0;
+	u32 dword_3 = 0;
 
 	if (cmd_dir == DMA_FROM_DEVICE) {
 		data_direction = UTP_DEVICE_TO_HOST;
@@ -2254,10 +2273,12 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 	if (lrbp->intr_cmd)
 		dword_0 |= UTP_REQ_DESC_INT_CMD;
 
+	/* Prepare crypto related dwords */
+	ufshcd_prepare_req_desc_hdr_crypto(lrbp, &dword_0, &dword_1, &dword_3);
+
 	/* Transfer request descriptor header fields */
 	req_desc->header.dword_0 = cpu_to_le32(dword_0);
-	/* dword_1 is reserved, hence it is set to 0 */
-	req_desc->header.dword_1 = 0;
+	req_desc->header.dword_1 = cpu_to_le32(dword_1);
 	/*
 	 * assigning invalid value for command status. Controller
 	 * updates OCS on command completion, with the command
@@ -2265,8 +2286,7 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 	 */
 	req_desc->header.dword_2 =
 		cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
-	/* dword_3 is reserved, hence it is set to 0 */
-	req_desc->header.dword_3 = 0;
+	req_desc->header.dword_3 = cpu_to_le32(dword_3);
 
 	req_desc->prd_table_length = 0;
 }
@@ -2521,6 +2541,9 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
+
+	ufshcd_prepare_lrbp_crypto(hba, cmd->request, lrbp);
+
 	lrbp->req_abort_skip = false;
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
@@ -2554,6 +2577,7 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 	lrbp->task_tag = tag;
 	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
+	ufshcd_prepare_lrbp_crypto(hba, NULL, lrbp);
 	hba->dev_cmd.type = cmd_type;
 
 	return ufshcd_comp_devman_upiu(hba, lrbp);
@@ -4650,6 +4674,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
 
+	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
+
 	return 0;
 }
 
@@ -6115,6 +6141,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	lrbp->task_tag = tag;
 	lrbp->lun = 0;
 	lrbp->intr_cmd = true;
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+	lrbp->crypto_key_slot = -1; /* No crypto operations */
+#endif
 	hba->dev_cmd.type = cmd_type;
 
 	switch (hba->ufs_version) {
@@ -8662,6 +8691,7 @@ EXPORT_SYMBOL_GPL(ufshcd_remove);
  */
 void ufshcd_dealloc_host(struct ufs_hba *hba)
 {
+	ufshcd_crypto_destroy_keyslot_manager(hba);
 	scsi_host_put(hba->host);
 }
 EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
@@ -8762,7 +8792,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto out_error;
 
 	/* Read capabilities registers */
-	ufshcd_hba_capabilities(hba);
+	err = ufshcd_hba_capabilities(hba);
+	if (err)
+		goto out_disable;
 
 	/* Get UFS version supported by the controller */
 	hba->ufs_version = ufshcd_get_ufs_version(hba);
@@ -8872,6 +8904,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Reset the attached device */
 	ufshcd_vops_device_reset(hba);
 
+	ufshcd_init_crypto(hba);
+
 	/* Host controller enable */
 	err = ufshcd_hba_enable(hba);
 	if (err) {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 271fc19f8002..1cb0fde5772c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -184,6 +184,8 @@ struct ufs_pm_lvl_states {
  * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
  * @issue_time_stamp: time stamp for debug purposes
  * @compl_time_stamp: time stamp for statistics
+ * @crypto_key_slot: the key slot to use for inline crypto (-1 if none)
+ * @data_unit_num: the data unit number for the first block for inline crypto
  * @req_abort_skip: skip request abort task flag
  */
 struct ufshcd_lrb {
@@ -208,6 +210,10 @@ struct ufshcd_lrb {
 	bool intr_cmd;
 	ktime_t issue_time_stamp;
 	ktime_t compl_time_stamp;
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+	int crypto_key_slot;
+	u64 data_unit_num;
+#endif
 
 	bool req_abort_skip;
 };
-- 
2.27.0.212.ge8ba1cc988-goog

