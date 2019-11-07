Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5286AC5DF61
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 08:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C9B621D79
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 08:43:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S52WPd4l";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XcX5JIOF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733266AbfKGInI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 03:43:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34062 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbfKGInI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 03:43:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8F4A560AD9; Thu,  7 Nov 2019 08:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573116187;
        bh=dRT2QuVdKpRxlXscy0dHiBBjakwjL18Z31eiqwX9GMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S52WPd4l8YStfiS1v09fiFwq/7/FFh/SwSIYVKigSoIPdtyb4X1kWyyGB94e2YH1V
         gTrxZYoYUavgPHDg5h1/etGrD1+fSih8XyqdEnDwvlJvNMWWTSAvcnnKRQ/R8rOLyM
         iru8aoWmT6Xn6ryCH2dDsUnOpH7ndm8mzl9GJLng=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B8C9E60A24;
        Thu,  7 Nov 2019 08:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573116180;
        bh=dRT2QuVdKpRxlXscy0dHiBBjakwjL18Z31eiqwX9GMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XcX5JIOF7TUXAURtZJyDlPn7vNU5zLurTVxZrHnC8vLxPKVEWTDAErRIszTho4oRT
         bXmIRCl67gmkwzZ+zw0QtrKhD/ftexx7ZCyTC6uQGeK801ZDGazLWAnJC73wAY2F9r
         lbSJqalSc2wpixgsn/ILbBgyEOOiiE2E3XaX9Luw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B8C9E60A24
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 5/6] scsi: ufs: Add dev ref clock gating wait time support
Date:   Thu,  7 Nov 2019 00:42:12 -0800
Message-Id: <1573116140-22408-6-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573116140-22408-1-git-send-email-cang@codeaurora.org>
References: <1573116140-22408-1-git-send-email-cang@codeaurora.org>
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
 drivers/scsi/ufs/ufshcd.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 3327981..d35b5b5 100644
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
+	u16 w_spec_version;
+	u32 clk_gating_wait_us;
 };
 
 #define MAX_MODEL_LEN 16
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4dfd705..9cf5da3 100644
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
@@ -3352,6 +3355,37 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 				      param_offset, param_read_buf, param_size);
 }
 
+static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
+{
+	int err = 0;
+	u32 gating_wait = UFSHCD_REF_CLK_GATING_WAIT_US;
+
+	if (hba->dev_info.w_spec_version >= 0x300) {
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
@@ -6623,6 +6657,10 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
 	dev_desc->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
 				     desc_buf[DEVICE_DESC_PARAM_MANF_ID + 1];
 
+	/* getting Specification Version in big endian format */
+	hba->dev_info.w_spec_version = desc_buf[DEVICE_DESC_PARAM_SPEC_VER] << 8 |
+					desc_buf[DEVICE_DESC_PARAM_SPEC_VER + 1];
+
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 	err = ufshcd_read_string_desc(hba, model_index,
 				      &dev_desc->model, SD_ASCII_STD);
@@ -7041,6 +7079,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 
 		/* clear any previous UFS device information */
 		memset(&hba->dev_info, 0, sizeof(hba->dev_info));
+
+		ufshcd_get_ref_clk_gating_wait(hba);
+
 		if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
 				QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
 			hba->dev_info.f_power_on_wp_en = flag;
@@ -7373,12 +7414,17 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 	struct ufs_clk_info *clki;
 	struct list_head *head = &hba->clk_list_head;
 	unsigned long flags;
+	unsigned long gating_wait;
 	ktime_t start = ktime_get();
 	bool clk_state_changed = false;
 
 	if (list_empty(head))
 		goto out;
 
+	gating_wait = (unsigned long)hba->dev_info.clk_gating_wait_us;
+	if (!on && !skip_ref_clk && !!gating_wait)
+		usleep_range(gating_wait, gating_wait + 10);
+
 	ret = ufshcd_vops_setup_clocks(hba, on, PRE_CHANGE);
 	if (ret)
 		return ret;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

