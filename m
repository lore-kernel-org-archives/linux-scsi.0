Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D38C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 12:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACF5F64E84
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 12:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhBHM5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 07:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhBHM52 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 07:57:28 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BA9C061786
        for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2021 04:56:48 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id p22so16739044ybc.18
        for <linux-scsi@vger.kernel.org>; Mon, 08 Feb 2021 04:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=sQapmmmD1H+xp8DLEh2Jo59f71Qc7V57DYbFZYvaoAY=;
        b=OuvN92SqUW+TAnggwqjIb2dlgpxNei1LU6zL/tAyxL48x74UE9j2SP1xkbflB+HLWf
         81BI1v95NBcVmy68BqAri1q6pZDbZvLTwmVqUQDOq+RZLugpXZa7Jt+nsfbkTwPkcDpF
         YyegRzS6Z0GpRq/tVfmFm5vyPdS5yXKsnwyw2YtVHNhOzjSPrpIPSHJVjRpkslvp+J9G
         +gPe8V4pbQ4N5/nAGBQv6b59NeMstXsYpTr5iVLkrm1Q08tq0AAclcJ2PieVQILiTRrR
         6zvYMG5JQFItRPjtC+zdLQk/UbIES8OOKqLy1dZJ16Wb4mnEA361eFXYkvDZD3rDjQ3P
         GQLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=sQapmmmD1H+xp8DLEh2Jo59f71Qc7V57DYbFZYvaoAY=;
        b=WhmJZ0P1rKs7tSxJdb44SC1GXWbVzr+iu+XlScdmf5qikC6dTYkFvSNA0sEUkrJrbE
         qQGPloTeoiV5lEvMYQZYXvEqMZS6COCkCNrAE79oKnTAJqeXTthKrQt7xE+S080w5Tet
         b5HLXU8FME/wJKxrDbaTOIG9X9PNUyHJ2kpsinz6xNkUSv2vPZfQ/DUPCfGahev6f7O8
         9SwRHlC2BUXtRiGRAUbzOOQ9qsYRxaomkXxx52LefcV9PnXk3lezgsaWyeMu8dZ23tXp
         RLMwD3azqdvco1xcJGFNvYykUONUSk2ZWqX8jt8iNq2VQuMFM2jn8zFkXqsotPAXhh7r
         ArIg==
X-Gm-Message-State: AOAM531P0Te59/4GU4QvO6BHvjGmV5VrZMsiIIYS20BmwsM2Wt+jXa8K
        OYO/YBA0Vl4FujdT/hHdOb1/Ja0idIfo
X-Google-Smtp-Source: ABdhPJxIwr1scQCsqW2E/bPKYUfRfRXkiadxgU/MWblekS4Dgnu0T5GCv14TtEkQEHCbpH2XlJ+0Lhd7zMNv
Sender: "leoliou via sendgmr" <leoliou@leoliou.ntc.corp.google.com>
X-Received: from leoliou.ntc.corp.google.com ([2401:fa00:fc:202:9995:e502:106b:c601])
 (user=leoliou job=sendgmr) by 2002:a25:264b:: with SMTP id
 m72mr25645047ybm.486.1612789007205; Mon, 08 Feb 2021 04:56:47 -0800 (PST)
Date:   Mon,  8 Feb 2021 20:56:28 +0800
Message-Id: <20210208125628.2758665-1-leoliou@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH] scsi: ufs: create a hook for unipro dme control
From:   Leo Liou <leoliou@google.com>
To:     agross@kernel.org, bjorn.andersson@linaro.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, asutoshd@codeaurora.org, beanhuo@micron.com,
        jaegeuk@kernel.org, adrian.hunter@intel.com, satyat@google.com,
        essuuj@gmail.com, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     leoliou@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Based on ufshci spec, it defines that "Offset C0h to FFh" belong
to vendor specific. If cpu vendor doesn't support these commands, it
makes the dme errors:

ufs: dme-set: attr-id 0xd041 val 0x1fff failed 0 retries
ufs: dme-set: attr-id 0xd042 val 0xffff failed 0 retries
ufs: dme-set: attr-id 0xd043 val 0x7fff failed 0 retries

Create a hook for unipro vendor-specific commands.

Signed-off-by: Leo Liou <leoliou@google.com>
---
 drivers/scsi/ufs/ufs-qcom.c | 11 +++++++++++
 drivers/scsi/ufs/ufs-qcom.h |  5 +++++
 drivers/scsi/ufs/ufshcd.c   |  7 +------
 drivers/scsi/ufs/ufshcd.h   |  8 ++++++++
 drivers/scsi/ufs/unipro.h   |  4 ----
 5 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 2206b1e4b774..f2a925587029 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -759,6 +759,16 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 	return ret;
 }
 
+static void ufs_qcom_unipro_dme_set(struct ufs_hba *hba)
+{
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
+		       DL_FC0ProtectionTimeOutVal_Default);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
+		       DL_TC0ReplayTimeOutVal_Default);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
+		       DL_AFC0ReqTimeOutVal_Default);
+}
+
 static int ufs_qcom_quirk_host_pa_saveconfigtime(struct ufs_hba *hba)
 {
 	int err;
@@ -1469,6 +1479,7 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.hce_enable_notify      = ufs_qcom_hce_enable_notify,
 	.link_startup_notify    = ufs_qcom_link_startup_notify,
 	.pwr_change_notify	= ufs_qcom_pwr_change_notify,
+	.unipro_dme_set		= ufs_qcom_unipro_dme_set,
 	.apply_dev_quirks	= ufs_qcom_apply_dev_quirks,
 	.suspend		= ufs_qcom_suspend,
 	.resume			= ufs_qcom_resume,
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 8208e3a3ef59..83db97caaa1b 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -124,6 +124,11 @@ enum {
 /* QUniPro Vendor specific attributes */
 #define PA_VS_CONFIG_REG1	0x9000
 #define DME_VS_CORE_CLK_CTRL	0xD002
+
+#define DME_LocalFC0ProtectionTimeOutVal	0xD041
+#define DME_LocalTC0ReplayTimeOutVal		0xD042
+#define DME_LocalAFC0ReqTimeOutVal		0xD043
+
 /* bit and mask definitions for DME_VS_CORE_CLK_CTRL attribute */
 #define DME_VS_CORE_CLK_CTRL_CORE_CLK_DIV_EN_BIT		BIT(8)
 #define DME_VS_CORE_CLK_CTRL_MAX_CORE_CLK_1US_CYCLES_MASK	0xFF
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fb32d122f2e3..8ba2ce8c5d0c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4231,12 +4231,7 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA5),
 			DL_AFC1ReqTimeOutVal_Default);
 
-	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
-			DL_FC0ProtectionTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
-			DL_TC0ReplayTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
-			DL_AFC0ReqTimeOutVal_Default);
+	ufshcd_vops_unipro_dme_set(hba);
 
 	ret = ufshcd_uic_change_pwr_mode(hba, pwr_mode->pwr_rx << 4
 			| pwr_mode->pwr_tx);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index aa9ea3552323..b8c90bee7503 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -311,6 +311,7 @@ struct ufs_pwr_mode_info {
  * @pwr_change_notify: called before and after a power mode change
  *			is carried out to allow vendor spesific capabilities
  *			to be set.
+ * @unipro_dme_set: called when vendor speicific control is needed
  * @setup_xfer_req: called before any transfer request is issued
  *                  to set some things
  * @setup_task_mgmt: called before any task management request is issued
@@ -342,6 +343,7 @@ struct ufs_hba_variant_ops {
 					enum ufs_notify_change_status status,
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
+	void    (*unipro_dme_set)(struct ufs_hba *hba);
 	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
@@ -1161,6 +1163,12 @@ static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
 	return -ENOTSUPP;
 }
 
+static inline void ufshcd_vops_unipro_dme_set(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->unipro_dme_set)
+		return hba->vops->unipro_dme_set(hba);
+}
+
 static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
 					bool is_scsi_cmd)
 {
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 8e9e486a4f7b..224162e5afd8 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -192,10 +192,6 @@
 #define DL_TC1ReplayTimeOutVal_Default		65535
 #define DL_AFC1ReqTimeOutVal_Default		32767
 
-#define DME_LocalFC0ProtectionTimeOutVal	0xD041
-#define DME_LocalTC0ReplayTimeOutVal		0xD042
-#define DME_LocalAFC0ReqTimeOutVal		0xD043
-
 /* PA power modes */
 enum {
 	FAST_MODE	= 1,
-- 
2.30.0.478.g8a0d178c01-goog

