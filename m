Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E246C352A4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 02:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6986B2082F
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 02:38:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="mXK1/scy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbgBKCif (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Feb 2020 21:38:35 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:46297 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727935AbgBKCie (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Feb 2020 21:38:34 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581388714; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=tbDNMomGjJ7cvmYyF8PQisUL3aRlv7HcybX79OJNwX8=; b=mXK1/scyIumvxE6oKEvVkj5zfe3IaphxW7AEkdyzD5pvnWhqt56MtIrHeWOwtaAb93MT/CbG
 CHDq40b2MzMSHuuP0ve9qPO8bptRUb6Xf9hBm8TpY2hi/glNkeBdaWa9HxNjlybTX7Lvi/Eu
 rrUEF26aE/Rax0+Xr+mhcykAACc=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e4213a9.7fa68a7e5570-smtp-out-n03;
 Tue, 11 Feb 2020 02:38:33 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7069AC447B3; Tue, 11 Feb 2020 02:38:30 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4533DC447A3;
        Tue, 11 Feb 2020 02:38:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4533DC447A3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Colin Ian King <colin.king@canonical.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v9 6/7] scsi: ufs: Add dev ref clock gating wait time support
Date:   Mon, 10 Feb 2020 18:37:48 -0800
Message-Id: <1581388671-18078-7-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1581388671-18078-1-git-send-email-cang@codeaurora.org>
References: <1581388671-18078-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In UFS version 3.0, a newly added attribute bRefClkGatingWaitTime defines
the minimum time for which the reference clock is required by device during
transition to LS-MODE or HIBERN8 state. Make this change to reflect the new
requirement by adding delays before turning off the clock.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufs.h    |  3 +++
 drivers/scsi/ufs/ufshcd.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index cfe3803..990cb48 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -167,6 +167,7 @@ enum attr_idn {
 	QUERY_ATTR_IDN_FFU_STATUS		= 0x14,
 	QUERY_ATTR_IDN_PSA_STATE		= 0x15,
 	QUERY_ATTR_IDN_PSA_DATA_SIZE		= 0x16,
+	QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME	= 0x17,
 };
 
 /* Descriptor idn for Query requests */
@@ -534,6 +535,8 @@ struct ufs_dev_info {
 	u16 wmanufacturerid;
 	/*UFS device Product Name */
 	u8 *model;
+	u16 wspecversion;
+	u32 clk_gating_wait_us;
 };
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e8f7f9d..adcce41 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -91,6 +91,9 @@
 /* default delay of autosuspend: 2000 ms */
 #define RPM_AUTOSUSPEND_DELAY_MS 2000
 
+/* Default value of wait time before gating device ref clock */
+#define UFSHCD_REF_CLK_GATING_WAIT_US 0xFF /* microsecs */
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -3281,6 +3284,31 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 				      param_offset, param_read_buf, param_size);
 }
 
+static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
+{
+	int err = 0;
+	u32 gating_wait = UFSHCD_REF_CLK_GATING_WAIT_US;
+
+	if (hba->dev_info.wspecversion >= 0x300) {
+		err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+				QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME, 0, 0,
+				&gating_wait);
+		if (err)
+			dev_err(hba->dev, "Failed reading bRefClkGatingWait. err = %d, use default %uus\n",
+					 err, gating_wait);
+
+		if (gating_wait == 0) {
+			gating_wait = UFSHCD_REF_CLK_GATING_WAIT_US;
+			dev_err(hba->dev, "Undefined ref clk gating wait time, use default %uus\n",
+					 gating_wait);
+		}
+
+		hba->dev_info.clk_gating_wait_us = gating_wait;
+	}
+
+	return err;
+}
+
 /**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
@@ -6626,6 +6654,10 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	dev_info->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
 				     desc_buf[DEVICE_DESC_PARAM_MANF_ID + 1];
 
+	/* getting Specification Version in big endian format */
+	dev_info->wspecversion = desc_buf[DEVICE_DESC_PARAM_SPEC_VER] << 8 |
+				      desc_buf[DEVICE_DESC_PARAM_SPEC_VER + 1];
+
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 	err = ufshcd_read_string_desc(hba, model_index,
 				      &dev_info->model, SD_ASCII_STD);
@@ -7003,6 +7035,8 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 		goto out;
 	}
 
+	ufshcd_get_ref_clk_gating_wait(hba);
+
 	ufs_fixup_device_setup(hba);
 
 	if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
