Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2139C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 15:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbiDAP4b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 11:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348121AbiDAPRS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 11:17:18 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D080B16E7DF
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 07:58:31 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id f6-20020a1c3806000000b0038e4a0fc5easo1618962wma.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 Apr 2022 07:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gtC9x4ytC3JDkJusbSvfvwpkttX0Il5swFlaQVUSd6c=;
        b=kK1jfQ/KvmctsoV8Tq0dqinBZV+u8tXoMPNhe3nJx+b+MoKfJNH5DCOS/7mnV7dRhk
         q7YGYC7vI4tS09qSlHHi5vYpf2gJQgGEn/kEG8zveAPRv31NwjTAvHxO35H7LqmbArFn
         2hZ4i1umE/adcAO/idQ50Om0Yl8lWDwl6IfGWmEWrB5IpwJig/nA7gDhEV9VDy8qdtou
         gEVysoaVnaGHsMfJKA0Tx3mTsavQEGHggt9MOxnUCdhgp+07onYLi/unPjqxGQcnQKKM
         g7d6FKvax+/9q50tUz1Vz8qjUxPUmkMoS5QxH8Jc31ELRcrr3z16cjH14w6SFy+e55eX
         tS8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gtC9x4ytC3JDkJusbSvfvwpkttX0Il5swFlaQVUSd6c=;
        b=c8sRIlIT80sFoM8I9WjNrUEs16sT/0ZryMQNQvPCnh3z6G5awsV7ML/sZIXEYvGiO+
         c/HZr+Qc+LtAKOM0lMNL9gj9jWBLwampuMwyeuSUfHaLR/GS4RPKaHNBpY3gC3l8B2QM
         nTwZfYTQz8I01lGkrjy8h78syxKhXYcqsgT3KFULGh9Cnedynj68I8y5o9y7fOTlqLnC
         n3nFJu8w460nv2xhdsYsMF67YlWDo24QoSeMH8v1DaYo/QcaYAiqUvRoGpDMB/vdzuzO
         XyuveoxwQguxgUrqB8h8hRdC2XEUFwuJihXrqRPcMWgWwkcAqb07oL8xliXO8n42vQz2
         aVgA==
X-Gm-Message-State: AOAM532u41g6pH3Eb46yZS6NS8wNa0YgZrFQNJxHAUrININLQ+O0tbMo
        sWNY8v3AX6p/cv9iJcK4gu5DkQ==
X-Google-Smtp-Source: ABdhPJwtaWcw36Blxc0IzRLdygI31LgDSHd4FsVTGI0QR6xX+M9Y0j+RkfQerB0BG0DZ9gy7GpF2HA==
X-Received: by 2002:a05:600c:34ce:b0:38c:a579:944a with SMTP id d14-20020a05600c34ce00b0038ca579944amr9037672wmq.113.1648825110300;
        Fri, 01 Apr 2022 07:58:30 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id j8-20020a05600c404800b0038cc9c7670bsm8530722wmm.3.2022.04.01.07.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 07:58:29 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Taniya Das <tdas@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [RFC PATCH 4/4] ufs: set power domain performance state when scaling gears
Date:   Fri,  1 Apr 2022 16:58:20 +0200
Message-Id: <20220401145820.1003826-5-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220401145820.1003826-1-krzysztof.kozlowski@linaro.org>
References: <20220401145820.1003826-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Scaling gears requires not only scaling clocks, but also voltage levels,
e.g. via performance states.

USe the provided OPP table, to set proper OPP frequency which through
required-opps will trigger performance state change.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c |  6 +++++
 drivers/scsi/ufs/ufshcd.c        | 42 +++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h        |  3 +++
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index cca4b2181a81..c8f19b54be92 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -360,6 +360,12 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 		goto dealloc_host;
 	}
 
+	if (devm_pm_opp_of_add_table(dev))
+		dev_dbg(dev, "no OPP table (%d), no performance state control\n",
+			err);
+	else
+		hba->use_pm_opp = true;
+
 	ufshcd_init_lanes_per_dir(hba);
 
 	err = ufshcd_init(hba, mmio_base, irq);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3f9caafa91bf..84912db86da8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1164,11 +1164,16 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 {
 	int ret = 0;
+	struct ufs_clk_info *clki;
+	unsigned long pm_opp_target_rate;
 	struct ufs_pa_layer_attr new_pwr_info;
 
+	clki = list_first_entry(&hba->clk_list_head, struct ufs_clk_info, list);
+
 	if (scale_up) {
 		memcpy(&new_pwr_info, &hba->clk_scaling.saved_pwr_info.info,
 		       sizeof(struct ufs_pa_layer_attr));
+		pm_opp_target_rate = clki->max_freq;
 	} else {
 		memcpy(&new_pwr_info, &hba->pwr_info,
 		       sizeof(struct ufs_pa_layer_attr));
@@ -1184,6 +1189,13 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 			new_pwr_info.gear_tx = hba->clk_scaling.min_gear;
 			new_pwr_info.gear_rx = hba->clk_scaling.min_gear;
 		}
+		pm_opp_target_rate = clki->min_freq;
+	}
+
+	if (hba->use_pm_opp && scale_up) {
+		ret = dev_pm_opp_set_rate(hba->dev, pm_opp_target_rate);
+		if (ret)
+			return ret;
 	}
 
 	/* check if the power mode needs to be changed or not? */
@@ -1194,6 +1206,11 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 			hba->pwr_info.gear_tx, hba->pwr_info.gear_rx,
 			new_pwr_info.gear_tx, new_pwr_info.gear_rx);
 
+	if (ret && hba->use_pm_opp && scale_up)
+		dev_pm_opp_set_rate(hba->dev, hba->devfreq->previous_freq);
+	else if (hba->use_pm_opp && !scale_up)
+		ret = dev_pm_opp_set_rate(hba->dev, pm_opp_target_rate);
+
 	return ret;
 }
 
@@ -1435,9 +1452,11 @@ static int ufshcd_devfreq_init(struct ufs_hba *hba)
 	if (list_empty(clk_list))
 		return 0;
 
-	clki = list_first_entry(clk_list, struct ufs_clk_info, list);
-	dev_pm_opp_add(hba->dev, clki->min_freq, 0);
-	dev_pm_opp_add(hba->dev, clki->max_freq, 0);
+	if (!hba->use_pm_opp) {
+		clki = list_first_entry(clk_list, struct ufs_clk_info, list);
+		dev_pm_opp_add(hba->dev, clki->min_freq, 0);
+		dev_pm_opp_add(hba->dev, clki->max_freq, 0);
+	}
 
 	ufshcd_vops_config_scaling_param(hba, &hba->vps->devfreq_profile,
 					 &hba->vps->ondemand_data);
@@ -1449,8 +1468,10 @@ static int ufshcd_devfreq_init(struct ufs_hba *hba)
 		ret = PTR_ERR(devfreq);
 		dev_err(hba->dev, "Unable to register with devfreq %d\n", ret);
 
-		dev_pm_opp_remove(hba->dev, clki->min_freq);
-		dev_pm_opp_remove(hba->dev, clki->max_freq);
+		if (!hba->use_pm_opp) {
+			dev_pm_opp_remove(hba->dev, clki->min_freq);
+			dev_pm_opp_remove(hba->dev, clki->max_freq);
+		}
 		return ret;
 	}
 
@@ -1462,7 +1483,6 @@ static int ufshcd_devfreq_init(struct ufs_hba *hba)
 static void ufshcd_devfreq_remove(struct ufs_hba *hba)
 {
 	struct list_head *clk_list = &hba->clk_list_head;
-	struct ufs_clk_info *clki;
 
 	if (!hba->devfreq)
 		return;
@@ -1470,9 +1490,13 @@ static void ufshcd_devfreq_remove(struct ufs_hba *hba)
 	devfreq_remove_device(hba->devfreq);
 	hba->devfreq = NULL;
 
-	clki = list_first_entry(clk_list, struct ufs_clk_info, list);
-	dev_pm_opp_remove(hba->dev, clki->min_freq);
-	dev_pm_opp_remove(hba->dev, clki->max_freq);
+	if (!hba->use_pm_opp) {
+		struct ufs_clk_info *clki;
+
+		clki = list_first_entry(clk_list, struct ufs_clk_info, list);
+		dev_pm_opp_remove(hba->dev, clki->min_freq);
+		dev_pm_opp_remove(hba->dev, clki->max_freq);
+	}
 }
 
 static void __ufshcd_suspend_clkscaling(struct ufs_hba *hba)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 88c20f3608c2..3bd02095897f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -776,6 +776,8 @@ struct ufs_hba_monitor {
  * @auto_bkops_enabled: to track whether bkops is enabled in device
  * @vreg_info: UFS device voltage regulator information
  * @clk_list_head: UFS host controller clocks list node head
+ * @use_pm_opp: whether OPP table is provided and scaling gears should trigger
+ *              setting OPP
  * @pwr_info: holds current power mode
  * @max_pwr_info: keeps the device max valid pwm
  * @clk_scaling_lock: used to serialize device commands and clock scaling
@@ -894,6 +896,7 @@ struct ufs_hba {
 	bool auto_bkops_enabled;
 	struct ufs_vreg_info vreg_info;
 	struct list_head clk_list_head;
+	bool use_pm_opp;
 
 	/* Number of requests aborts */
 	int req_abort_count;
-- 
2.32.0

