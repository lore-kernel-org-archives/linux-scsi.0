Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11989C33CB6
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 06:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF8552467E
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 06:13:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="hC+fpt1E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgAWGNX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 01:13:23 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:42451 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727022AbgAWGNP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 01:13:15 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579759994; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=MOdMAxrcAideJ7LYVu0nZQnvT4WEvP6V9dfh/O1zF10=; b=hC+fpt1ECE9pxWlKEhPu54GLKhu1dHPYTH/q4ZFY4qPTTY4Pp5FO1pWplY+XtJQ0ode2Do4O
 0A4KE0Tlk93nIRkS3N34OeVkfYvBl/m9nmiqQoMNqlC0CbHJs9pvbII4/3/zqh4Fng/RPz2G
 wmJIrhUkyjdy7CzJ6gu74F33tco=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e293978.7f6f9d33fe30-smtp-out-n01;
 Thu, 23 Jan 2020 06:13:12 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7C776C447B5; Thu, 23 Jan 2020 06:13:10 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5EEF0C447A4;
        Thu, 23 Jan 2020 06:13:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5EEF0C447A4
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 6/8] scsi: ufs: Add dev ref clock gating wait time support
Date:   Wed, 22 Jan 2020 22:12:23 -0800
Message-Id: <1579759946-5448-7-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1579759946-5448-1-git-send-email-cang@codeaurora.org>
References: <1579759946-5448-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In UFS version 3.0, a newly added attribute bRefClkGatingWaitTime defines
the minimum time for which the reference clock is required by device during
transition to LS-MODE or HIBERN8 state. Make this change to reflect the new
requirement by adding delays before turning off the clock.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs.h    |  3 +++
 drivers/scsi/ufs/ufshcd.c | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 3327981..385bac8 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -168,6 +168,7 @@ enum attr_idn {
 	QUERY_ATTR_IDN_FFU_STATUS		= 0x14,
 	QUERY_ATTR_IDN_PSA_STATE		= 0x15,
 	QUERY_ATTR_IDN_PSA_DATA_SIZE		= 0x16,
+	QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME	= 0x17,
 };
 
 /* Descriptor idn for Query requests */
@@ -530,6 +531,8 @@ struct ufs_dev_info {
 	bool f_power_on_wp_en;
 	/* Keeps information if any of the LU is power on write protected */
 	bool is_lu_power_on_wp;
+	u16 spec_version;
+	u32 clk_gating_wait_us;
 };
 
 #define MAX_MODEL_LEN 16
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c316a07..1ee2187 100644
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
@@ -3357,6 +3360,37 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 				      param_offset, param_read_buf, param_size);
 }
 
+static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
+{
+	int err = 0;
+	u32 gating_wait = UFSHCD_REF_CLK_GATING_WAIT_US;
+
+	if (hba->dev_info.spec_version >= 0x300) {
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
+		/*
+		 * bRefClkGatingWaitTime defines the minimum time for which the
+		 * reference clock is required by device during transition from
+		 * HS-MODE to LS-MODE or HIBERN8 state. Give it more time to be
+		 * on the safe side.
+		 */
+		hba->dev_info.clk_gating_wait_us = gating_wait + 50;
+	}
+
+	return err;
+}
+
 /**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
@@ -6628,6 +6662,10 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
 	dev_desc->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
 				     desc_buf[DEVICE_DESC_PARAM_MANF_ID + 1];
 
+	/* getting Specification Version in big endian format */
+	hba->dev_info.spec_version = desc_buf[DEVICE_DESC_PARAM_SPEC_VER] << 8 |
+				      desc_buf[DEVICE_DESC_PARAM_SPEC_VER + 1];
+
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 	err = ufshcd_read_string_desc(hba, model_index,
 				      &dev_desc->model, SD_ASCII_STD);
@@ -7046,6 +7084,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 
 		/* clear any previous UFS device information */
 		memset(&hba->dev_info, 0, sizeof(hba->dev_info));
+
+		ufshcd_get_ref_clk_gating_wait(hba);
+
 		if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
 				QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
 			hba->dev_info.f_power_on_wp_en = flag;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
