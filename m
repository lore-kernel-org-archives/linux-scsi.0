Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5BBEC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B020020776
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:47:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GqI/alPP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732684AbgFRCrv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733105AbgFRCrp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 22:47:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73605C06174E
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2020 19:47:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n11so4936896ybg.15
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2020 19:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pRh9lc5L2fGWtXol/1rqXa4QvCwd25R5/0LOJzKKSmA=;
        b=GqI/alPP3g6m12sB1Ro8HjaYPXLITkcKRJ0yBymbRyGoyQr20Jjsd7+m+aC3hayMIu
         PW47eCiU9SUF/2qW2/yOCgbmCKcI9Jvxk8zS1m/jq4jEaM9RV6mZOUsCixCiuGFHKOMC
         lwqa8R5KJq+xy38+wnmqDETi9P+RtQHkIFg70u1OqSl0EPoDeltXXmFvsdi7IoItABH+
         rktWAtGB0uXfdsYaXFH06qw7Jv4rQ5wGnLh1ldzjxz4SpoY+hOrhotZn1M27/leIllmx
         zg1fjwWdGeUc3hMCl1D9zj3yw8VieYpZNRdMlB3ACQp16a5wLyPTVdOUToro4VRaPzze
         26QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pRh9lc5L2fGWtXol/1rqXa4QvCwd25R5/0LOJzKKSmA=;
        b=kytbD4qX7FFKs8ZEXeaPYKBfTl+na4YYS6VCYCJodNlrcehIUWoLffs/391FpJGo4C
         Zk1+5ewn1lE2bOH0XRgagUEdE2FmTtPwMZ75RXStfhJ7gZkg+q1YXl94vFI2LGdtauF0
         y+A397UIH8x3DuphOvK8PFXuKBW/tjLeDRP0fmNrk/WiEsKxHblBOCxUT41wT5ZA1y1w
         Y01tp/U5be+X0rjfWDqZvZU9YizsiA/Feh9xAdV6PRfQ6xZBczVHEabI1H/HE+t5fO9o
         2YX3O7xNDPmChfSSnuulk2I0jeTth92c2FCnQQPsdgjQ64L+9l/vaKA8M4T9W0qXFLUw
         oy9A==
X-Gm-Message-State: AOAM532SWRYBA2amgL7UvKM+jXsML9bqP1C72EXtm60PVrG7d4h6kz5j
        MRZW9j8hindF8hWRiIg0jxqcdMDWvBuWxY+8CPs+AUfeovegJAqixOPmLL56vcjnja3CeUmTIhD
        Y7cOj2RoCQMYL8tCtkRjAJk1+lglODU+ugVeePvaz2ZJM4OeUf/pYonJ4dh+FfgI3P+Y=
X-Google-Smtp-Source: ABdhPJwyVxZkupKDzNmekVGIvO5BazlnAr3Ls2+UwYN08V9AwFDyGYxl7M1uaaW2ZpbzkEYRlA+mupzOM+g=
X-Received: by 2002:a25:e911:: with SMTP id n17mr3363740ybd.280.1592448463613;
 Wed, 17 Jun 2020 19:47:43 -0700 (PDT)
Date:   Thu, 18 Jun 2020 02:47:36 +0000
In-Reply-To: <20200618024736.97207-1-satyat@google.com>
Message-Id: <20200618024736.97207-4-satyat@google.com>
Mime-Version: 1.0
References: <20200618024736.97207-1-satyat@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH v2 3/3] scsi: ufs: Add inline encryption support to UFS
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
index 4fdb200de46c..266c1d7c9f02 100644
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
 
@@ -6115,6 +6138,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	lrbp->task_tag = tag;
 	lrbp->lun = 0;
 	lrbp->intr_cmd = true;
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+	lrbp->crypto_key_slot = -1; /* No crypto operations */
+#endif
 	hba->dev_cmd.type = cmd_type;
 
 	switch (hba->ufs_version) {
@@ -8662,6 +8688,7 @@ EXPORT_SYMBOL_GPL(ufshcd_remove);
  */
 void ufshcd_dealloc_host(struct ufs_hba *hba)
 {
+	ufshcd_crypto_destroy_keyslot_manager(hba);
 	scsi_host_put(hba->host);
 }
 EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
@@ -8872,6 +8899,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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

