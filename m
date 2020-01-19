Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4804BC32771
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13ECC2467C
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DBtEdIhY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgASAOG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 19:14:06 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38035 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728708AbgASAOF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 19:14:05 -0500
Received: by mail-wm1-f66.google.com with SMTP id u2so11145034wmc.3;
        Sat, 18 Jan 2020 16:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=41ycnJotq3f2f3WoDrFXzRvGRmTy6PCXJzUIUZ0WMkw=;
        b=DBtEdIhYcglB3fGG9i+O216N4PbLiOWChz8+RsqhYBn35FrB9caSccBauRGN9CL3Cq
         sYpH1RJTtbZS1OdEH3iRD12Qu1GK0EpMmmNbUUB5Hrpcitu+ZVJ4p8lMB4jKbyhrzHUJ
         8xg5lDZgI+/LIwAQ992h6GlTscFZFzr8FEEuNNhHu6RV59eg8llaqm1a5V6WBhs9AH3U
         fVTXWDzLXn1BljMxSjHyQxq+6TG/LY10WY1uYO/yXD6VALrvJmBBQ1NcBljBiqw+wEcR
         dc4qcdzNsGe5H+Zt6WyGZF//hYbjuym8N9tz6vw568CNtWGx/9PZrSlgYuk/K12A3RgX
         W9tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=41ycnJotq3f2f3WoDrFXzRvGRmTy6PCXJzUIUZ0WMkw=;
        b=ByLH9xIL5fEq/eURWH1sVrdbQCdYNVCmaBFNXb4AW9/K0kA5hY1dfuS+Wg0LaFHfl2
         dPtHPU1bfQGMUUqD3eSnWsnlI2w7D7Fd0Oovwm9FS2wa6FvCxgyw4JJAcGzXPhveiOtQ
         XUFQcJB2iKi2tJamkPoA3IoXzJURHAmKEDMpWmKy3kjTf8lE/olcI50CfGpFMBLaBl00
         az566y9eLayfg89bq52De7q1PNppHRWi4sb9r1CYMuwxhw/5mUuK9cYGRr23izMTryBm
         arDiGuTVpM6wJFY7dDGtErP/+NcsOBVslywEq/FgEUXo2zH+qVJW0hIyVsiULS+5F0BY
         iQVA==
X-Gm-Message-State: APjAAAXd1qY5F4Vt5qC+oj3IfE3QoR1reDzkeg1bHgvhNKyc112+BJZw
        u60ktAMqBTCx7MHsaLfXn74=
X-Google-Smtp-Source: APXvYqyX/+jQ6xdYzSNmH1biMdfMfAp2pdkJOU/pdLReTHjL8Egz9a+ohYqqELi9mL8mm45JQ/JRVA==
X-Received: by 2002:a05:600c:d5:: with SMTP id u21mr11807092wmm.85.1579392844256;
        Sat, 18 Jan 2020 16:14:04 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id i8sm42177432wro.47.2020.01.18.16.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 16:14:03 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/8] scsi: ufs: Split ufshcd_probe_hba() based on its called flow
Date:   Sun, 19 Jan 2020 01:13:22 +0100
Message-Id: <20200119001327.29155-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200119001327.29155-1-huobean@gmail.com>
References: <20200119001327.29155-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

This patch has two major non-functionality changes:

1. Take scanning host if-statement out from ufshcd_probe_hba(), and
move into a new added function ufshcd_add_lus().
In this new function ufshcd_add_lus(), the main functionalitis include:
ICC initialization, add well-known LUs, devfreq initialization, UFS
bsg probe and scsi host scan. The reason for this change is that these
functionalities only being called during booting stage flow
ufshcd_init()->ufshcd_async_scan(). In the processes of error handling
and power management ufshcd_suspend(), ufshcd_resume(), ufshcd_probe_hba()
being called, but these functionalitis above metioned are not hit.

2. Move context of initialization of parameters associated with the UFS
device to a new added function ufshcd_init_params().
The reason of this change is that all of these parameters are used by
driver, but only need to be initialized once when booting. Combine them
into an integral function, make them easier maintain.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 167 +++++++++++++++++++++++---------------
 1 file changed, 101 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 58ef45b80cb0..54c127ef360b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -246,7 +246,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
-static int ufshcd_probe_hba(struct ufs_hba *hba);
+static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 				 bool skip_ref_clk);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
@@ -6307,7 +6307,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 		goto out;
 
 	/* Establish the link again and restore the device */
-	err = ufshcd_probe_hba(hba);
+	err = ufshcd_probe_hba(hba, false);
 
 	if (!err && (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL))
 		err = -EIO;
@@ -6935,13 +6935,83 @@ static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
 	return err;
 }
 
+static int ufshcd_init_params(struct ufs_hba *hba)
+{
+	bool flag;
+	int ret;
+
+	/* Init check for device descriptor sizes */
+	ufshcd_init_desc_sizes(hba);
+
+	/* Check and apply UFS device quirks */
+	ret = ufs_get_device_desc(hba);
+	if (ret) {
+		dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
+			__func__, ret);
+		goto out;
+	}
+
+	ufs_fixup_device_setup(hba);
+
+	/* Clear any previous UFS device information */
+	memset(&hba->dev_info, 0, sizeof(hba->dev_info));
+	if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+			QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
+		hba->dev_info.f_power_on_wp_en = flag;
+
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_add_lus - probe and add UFS logical units
+ * @hba: per-adapter instance
+ */
+static int ufshcd_add_lus(struct ufs_hba *hba)
+{
+	int ret;
+
+	if (!hba->is_init_prefetch)
+		ufshcd_init_icc_levels(hba);
+
+	/* Add required well known logical units to scsi mid layer */
+	ret = ufshcd_scsi_add_wlus(hba);
+	if (ret)
+		goto out;
+
+	/* Initialize devfreq after UFS device is detected */
+	if (ufshcd_is_clkscaling_supported(hba)) {
+		memcpy(&hba->clk_scaling.saved_pwr_info.info,
+			&hba->pwr_info,
+			sizeof(struct ufs_pa_layer_attr));
+		hba->clk_scaling.saved_pwr_info.is_valid = true;
+		if (!hba->devfreq) {
+			ret = ufshcd_devfreq_init(hba);
+			if (ret)
+				goto out;
+		}
+
+		hba->clk_scaling.is_allowed = true;
+	}
+
+	ufs_bsg_probe(hba);
+	scsi_scan_host(hba->host);
+	pm_runtime_put_sync(hba->dev);
+
+	if (!hba->is_init_prefetch)
+		hba->is_init_prefetch = true;
+out:
+	return ret;
+}
+
 /**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
+ * @async: asynchronous execution or not
  *
  * Execute link-startup and verify device initialization
  */
-static int ufshcd_probe_hba(struct ufs_hba *hba)
+static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 {
 	int ret;
 	ktime_t start = ktime_get();
@@ -6960,25 +7030,26 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	/* UniPro link is active now */
 	ufshcd_set_link_active(hba);
 
+	/* Verify device initialization by sending NOP OUT UPIU */
 	ret = ufshcd_verify_dev_init(hba);
 	if (ret)
 		goto out;
 
+	/* Initiate UFS initialization, and waiting until completion */
 	ret = ufshcd_complete_dev_init(hba);
 	if (ret)
 		goto out;
 
-	/* Init check for device descriptor sizes */
-	ufshcd_init_desc_sizes(hba);
-
-	ret = ufs_get_device_desc(hba);
-	if (ret) {
-		dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
-			__func__, ret);
-		goto out;
+	/*
+	 * Initialize UFS device parameters used by driver, these
+	 * parameters are associated with UFS descriptors.
+	 */
+	if (async) {
+		ret = ufshcd_init_params(hba);
+		if (ret)
+			goto out;
 	}
 
-	ufs_fixup_device_setup(hba);
 	ufshcd_tune_unipro_params(hba);
 
 	/* UFS device is also active now */
@@ -7011,60 +7082,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
 
-	/*
-	 * If we are in error handling context or in power management callbacks
-	 * context, no need to scan the host
-	 */
-	if (!ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
-		bool flag;
-
-		/* clear any previous UFS device information */
-		memset(&hba->dev_info, 0, sizeof(hba->dev_info));
-		if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
-				QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
-			hba->dev_info.f_power_on_wp_en = flag;
-
-		if (!hba->is_init_prefetch)
-			ufshcd_init_icc_levels(hba);
-
-		/* Add required well known logical units to scsi mid layer */
-		ret = ufshcd_scsi_add_wlus(hba);
-		if (ret)
-			goto out;
-
-		/* Initialize devfreq after UFS device is detected */
-		if (ufshcd_is_clkscaling_supported(hba)) {
-			memcpy(&hba->clk_scaling.saved_pwr_info.info,
-				&hba->pwr_info,
-				sizeof(struct ufs_pa_layer_attr));
-			hba->clk_scaling.saved_pwr_info.is_valid = true;
-			if (!hba->devfreq) {
-				ret = ufshcd_devfreq_init(hba);
-				if (ret)
-					goto out;
-			}
-			hba->clk_scaling.is_allowed = true;
-		}
-
-		ufs_bsg_probe(hba);
-
-		scsi_scan_host(hba->host);
-		pm_runtime_put_sync(hba->dev);
-	}
-
-	if (!hba->is_init_prefetch)
-		hba->is_init_prefetch = true;
-
 out:
-	/*
-	 * If we failed to initialize the device or the device is not
-	 * present, turn off the power/clocks etc.
-	 */
-	if (ret && !ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
-		pm_runtime_put_sync(hba->dev);
-		ufshcd_exit_clk_scaling(hba);
-		ufshcd_hba_exit(hba);
-	}
 
 	trace_ufshcd_init(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
@@ -7080,8 +7098,25 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 {
 	struct ufs_hba *hba = (struct ufs_hba *)data;
+	int ret;
 
-	ufshcd_probe_hba(hba);
+	/* Initialize hba, detect and initialize UFS device */
+	ret = ufshcd_probe_hba(hba, true);
+	if (ret)
+		goto out;
+
+	/* Probe and add UFS logical units  */
+	ret = ufshcd_add_lus(hba);
+out:
+	/*
+	 * If we failed to initialize the device or the device is not
+	 * present, turn off the power/clocks etc.
+	 */
+	if (ret) {
+		pm_runtime_put_sync(hba->dev);
+		ufshcd_exit_clk_scaling(hba);
+		ufshcd_hba_exit(hba);
+	}
 }
 
 static const struct attribute_group *ufshcd_driver_groups[] = {
-- 
2.17.1

