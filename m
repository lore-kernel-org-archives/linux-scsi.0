Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4879EC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2486421508
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bg6wbOMc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgFQISv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgFQISv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 04:18:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12314C06174E
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2020 01:18:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r17so1644121ybj.22
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2020 01:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CszcNEGES3KCMayTJQzLNxJT8jQMEoo+tThr5J+kP3g=;
        b=Bg6wbOMcz4iYHV32QH4bHIHKZJmUatZufE28SNl5Dzr2AcOYSX/qD3/p8Cuo25sQSv
         ylVJBVXNESkTvr/AypleEygyXfDmqqwZoemfcoXrSIsrfEqOsqDGSbDfAVGwPxCGypnP
         aFKaTbLJroKmYbcdZzO17lXpV2VQb1XGu1g5h49/Xd2yJwLCZZcXsOdUTzoymW6cNztl
         ox/sC+0prx+MhruuS51kfv4RdES5Pdg8qZjaRI+KhxqJ0T7KvQAPfSksvJDnwyJJFRcp
         /BevYe5brD/414B8a2WFsk1edMu/pzaXHGbDQG7nDTsqmOxh/UQxXGc107uUsLLMEiXn
         P05Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CszcNEGES3KCMayTJQzLNxJT8jQMEoo+tThr5J+kP3g=;
        b=I1mEwON3Cq/G/lMtbfApnujG1vAsxeDK2C2DfurBAXqozOkUVX9Rl5Ns57kINThNdM
         bgo9FXTk0BnonadnugTOy8exxsRfm8SWP8gBsOWpXpffe/TXNPqTvOMotmmhjRz5ceg5
         NdNj6Yg/r36+NxCujf48wLoLSwx1mIR5Bd2qHN87PEVNbtJLRcgSBfxlioTZDwvGVRDA
         jWuXCLoiD+wdrqUnaLjnwOZQ1+PAZRuZNZwMqg8pJsj7kLwXxip7PFbm+2uAhur+kpm3
         uWE//ORADBBXlLX8O6Ls3sCwK0oCfONmLDb/Q5W7U4YTPbu6D+aSKUX3gBo8C4/RhksM
         qVzg==
X-Gm-Message-State: AOAM532uViaKc6EMhEFhTn9rFVW0cignVVPzz6Vy/PbsUpPi2AhLbV7i
        tq0/H8FF8AeeJ0OdvVEAhhcc4JhSLqTNWQT1LwfgiyDSU9Ho8MTzMrJivzrwP7JI42t4RVVXv07
        FEMt7h1ONAFaAbVKlhkRnN5vLjIPm4+0Vj02Xwqd5ccR92d6RG81GZtXLGDwMmRhFKPo=
X-Google-Smtp-Source: ABdhPJwzYzyiwYUzqnYnM0mZagcUyH6ThrwXEZgQRTqpSExYL3u7Mgd/qA6KWTUcBukdCC6wEjxMlNPXCqk=
X-Received: by 2002:a25:74cd:: with SMTP id p196mr7577754ybc.80.1592381929192;
 Wed, 17 Jun 2020 01:18:49 -0700 (PDT)
Date:   Wed, 17 Jun 2020 08:18:41 +0000
In-Reply-To: <20200617081841.218985-1-satyat@google.com>
Message-Id: <20200617081841.218985-4-satyat@google.com>
Mime-Version: 1.0
References: <20200617081841.218985-1-satyat@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH 3/3] scsi: ufs: Add inline encryption support to UFS
From:   Satya Tangirala <satyat@google.com>
To:     linux-scsi@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Wire up ufshcd.c with the UFS Crypto API, the block layer inline
encryption additions and the keyslot manager.

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 drivers/scsi/ufs/ufshcd-crypto.h | 18 +++++++++++++
 drivers/scsi/ufs/ufshcd.c        | 44 ++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h        |  6 +++++
 3 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.h b/drivers/scsi/ufs/ufshcd-crypto.h
index 22677619de59..9578edb63e7b 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.h
+++ b/drivers/scsi/ufs/ufshcd-crypto.h
@@ -10,6 +10,20 @@
 #include "ufshcd.h"
 #include "ufshci.h"
 
+static inline void ufshcd_prepare_lrbp_crypto(struct ufs_hba *hba,
+					      struct scsi_cmnd *cmd,
+					      struct ufshcd_lrb *lrbp)
+{
+	struct request *rq = cmd->request;
+
+	if (rq->crypt_keyslot) {
+		lrbp->crypto_key_slot = blk_ksm_get_slot_idx(rq->crypt_keyslot);
+		lrbp->data_unit_num = rq->crypt_ctx->bc_dun[0];
+	} else {
+		lrbp->crypto_key_slot = -1;
+	}
+}
+
 bool ufshcd_crypto_enable(struct ufs_hba *hba);
 
 int ufshcd_hba_init_crypto(struct ufs_hba *hba);
@@ -21,6 +35,10 @@ void ufshcd_crypto_destroy_keyslot_manager(struct ufs_hba *hba);
 
 #else /* CONFIG_SCSI_UFS_CRYPTO */
 
+static inline void ufshcd_prepare_lrbp_crypto(struct ufs_hba *hba,
+					      struct scsi_cmnd *cmd,
+					      struct ufshcd_lrb *lrbp) { }
+
 static inline bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
 	return false;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 777090a0a080..eee3e5c44517 100644
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
@@ -2237,6 +2243,8 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 	struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
 	u32 data_direction;
 	u32 dword_0;
+	u32 dword_1 = 0;
+	u32 dword_3 = 0;
 
 	if (cmd_dir == DMA_FROM_DEVICE) {
 		data_direction = UTP_DEVICE_TO_HOST;
@@ -2255,9 +2263,17 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 		dword_0 |= UTP_REQ_DESC_INT_CMD;
 
 	/* Transfer request descriptor header fields */
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+	if (lrbp->crypto_key_slot >= 0) {
+		dword_0 |= UTP_REQ_DESC_CRYPTO_ENABLE_CMD;
+		dword_0 |= lrbp->crypto_key_slot;
+		dword_1 = lower_32_bits(lrbp->data_unit_num);
+		dword_3 = upper_32_bits(lrbp->data_unit_num);
+	}
+#endif /* CONFIG_SCSI_UFS_CRYPTO */
+
 	req_desc->header.dword_0 = cpu_to_le32(dword_0);
-	/* dword_1 is reserved, hence it is set to 0 */
-	req_desc->header.dword_1 = 0;
+	req_desc->header.dword_1 = cpu_to_le32(dword_1);
 	/*
 	 * assigning invalid value for command status. Controller
 	 * updates OCS on command completion, with the command
@@ -2265,8 +2281,7 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 	 */
 	req_desc->header.dword_2 =
 		cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
-	/* dword_3 is reserved, hence it is set to 0 */
-	req_desc->header.dword_3 = 0;
+	req_desc->header.dword_3 = cpu_to_le32(dword_3);
 
 	req_desc->prd_table_length = 0;
 }
@@ -2521,6 +2536,9 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
+
+	ufshcd_prepare_lrbp_crypto(hba, cmd, lrbp);
+
 	lrbp->req_abort_skip = false;
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
@@ -2554,6 +2572,9 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 	lrbp->task_tag = tag;
 	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+	lrbp->crypto_key_slot = -1; /* No crypto operations */
+#endif
 	hba->dev_cmd.type = cmd_type;
 
 	return ufshcd_comp_devman_upiu(hba, lrbp);
@@ -4650,6 +4671,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
 
+	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
+
 	return 0;
 }
 
@@ -6114,6 +6137,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	lrbp->task_tag = tag;
 	lrbp->lun = 0;
 	lrbp->intr_cmd = true;
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+	lrbp->crypto_key_slot = -1; /* No crypto operations */
+#endif
 	hba->dev_cmd.type = cmd_type;
 
 	switch (hba->ufs_version) {
@@ -8661,6 +8687,7 @@ EXPORT_SYMBOL_GPL(ufshcd_remove);
  */
 void ufshcd_dealloc_host(struct ufs_hba *hba)
 {
+	ufshcd_crypto_destroy_keyslot_manager(hba);
 	scsi_host_put(hba->host);
 }
 EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
@@ -8871,6 +8898,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Reset the attached device */
 	ufshcd_vops_device_reset(hba);
 
+	/* Init crypto */
+	err = ufshcd_hba_init_crypto(hba);
+	if (err) {
+		dev_err(hba->dev, "crypto setup failed\n");
+		goto free_tmf_queue;
+	}
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
2.27.0.290.gba653c62da-goog

