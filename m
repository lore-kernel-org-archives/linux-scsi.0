Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BC4C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 11:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F316964F6A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 11:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhCQLpB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 07:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbhCQLo5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 07:44:57 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC27C06174A;
        Wed, 17 Mar 2021 04:44:56 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so1201297pjv.1;
        Wed, 17 Mar 2021 04:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gIEhr5+I33uCJK4hfiEJOvKhBOp5tgUkDWs4HI7OXXU=;
        b=K8fjDSTVXiwtbGw61wz8suZ8mf8W6yPErEHKhxATHqr856ayYowet0kcJESpL0auTP
         QROUf3LEnwARBy10m3yte/AZrFdrDiDd+bFPku0F3VcSo41/PvBEBoabFvGxpfWN6XOD
         9RDGIIZGNpWRbbrVmbDYmMOWN1K+aP8zh/97ATJfrg9e4YTv6XnmwqaXLI2Y+xHfm4GC
         lZgUkxI65fTERRKfu8lU0EMpiiIHTzxVZ6F2XSHADFNHoNx+nA0JbZ5YnN51XijO5SOU
         JBvJw8kUX5vrG8RyFteUkz29VCIMIG4upv56QzuJHzhl7wCUlLMbwmNGdIgc/HhdkskO
         fzhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gIEhr5+I33uCJK4hfiEJOvKhBOp5tgUkDWs4HI7OXXU=;
        b=PmglNg/jJzbUEhSLe0FiqbQaznc8XLgWs5ekpSXBEeUgRcd3MwrbvKS1hEB3q5kCJA
         TyK2jX40YMIIPDT4YTxvUpqvXB8kFoMasg/scfRpmxsrAmgib0KorKqN0CjuScv31qFM
         sHuvwB+yseFMboMICWRrnQZRjWbG7n4gTEYKJZh7MzfbjZQTf752JtRXD2yp5aVqdxv1
         82p99mw2SVc/l9RyrhJ5xNRKZ40ktsRufjQd6YPnEzi0+6eCpUXE//Xuwpypk2mLLjDO
         ZAQuBGWMY5YNSrM15YXY/rCqCUXTp8blimbD9LcJKrYcTHyt+a20v9APyX/BbtIeZLqB
         UJgA==
X-Gm-Message-State: AOAM5318UFIwPqRPXbw21hu55sAgZlG2HojYL8cWfsww425JpAEijdQ0
        3YSI7Nu9grUI9UWFi1zNsVs=
X-Google-Smtp-Source: ABdhPJysXKEq6p/EviZy/Qo6olsTRVSHLMem5j8jprkNZB2EToUg/c46okGUO6GgdKWyj0Ro1sIPKA==
X-Received: by 2002:a17:90a:c207:: with SMTP id e7mr4168734pjt.188.1615981496467;
        Wed, 17 Mar 2021 04:44:56 -0700 (PDT)
Received: from tj.ccdomain.com ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id j5sm18554790pgl.55.2021.03.17.04.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 04:44:56 -0700 (PDT)
From:   Yue Hu <zbestahu@gmail.com>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, huyue2@yulong.com, zbestahu@163.com
Subject: [PATCH] scsi: ufs: Tidy up WB configuration code
Date:   Wed, 17 Mar 2021 19:44:38 +0800
Message-Id: <20210317114438.1900-1-zbestahu@gmail.com>
X-Mailer: git-send-email 2.29.2.windows.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

There are similar code implemetentions for WB configurations in
ufshcd_wb_{ctrl, toggle_flush_during_h8, toggle_flush}. We can
extract the part to create a new helper with a flag parameter to
reduce code duplication.

Meanwhile, change ufshcd_wb_ctrl() -> ufshcd_wb_toggle() for better
readability.

And remove unnecessary log messages from ufshcd_wb_config() since
relevant toggle function will spew log respectively. Also change
ufshcd_wb_toggle_flush{__during_h8} to void type accordingly.

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 drivers/scsi/ufs/ufs-sysfs.c |  2 +-
 drivers/scsi/ufs/ufshcd.c    | 99 +++++++++++++++++++-------------------------
 drivers/scsi/ufs/ufshcd.h    |  2 +-
 3 files changed, 44 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index acc54f5..d7c3cff 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -246,7 +246,7 @@ static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
 	}
 
 	pm_runtime_get_sync(hba->dev);
-	res = ufshcd_wb_ctrl(hba, wb_enable);
+	res = ufshcd_wb_toggle(hba, wb_enable);
 	pm_runtime_put_sync(hba->dev);
 out:
 	up(&hba->host_sem);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7716175..1368f9e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -247,8 +247,8 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg);
 static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
-static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
-static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
+static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
+static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
 static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
 
@@ -275,20 +275,12 @@ static inline void ufshcd_disable_irq(struct ufs_hba *hba)
 
 static inline void ufshcd_wb_config(struct ufs_hba *hba)
 {
-	int ret;
-
 	if (!ufshcd_is_wb_allowed(hba))
 		return;
 
-	ret = ufshcd_wb_ctrl(hba, true);
-	if (ret)
-		dev_err(hba->dev, "%s: Enable WB failed: %d\n", __func__, ret);
-	else
-		dev_info(hba->dev, "%s: Write Booster Configured\n", __func__);
-	ret = ufshcd_wb_toggle_flush_during_h8(hba, true);
-	if (ret)
-		dev_err(hba->dev, "%s: En WB flush during H8: failed: %d\n",
-			__func__, ret);
+	ufshcd_wb_toggle(hba, true);
+
+	ufshcd_wb_toggle_flush_during_h8(hba, true);
 	if (!(hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL))
 		ufshcd_wb_toggle_flush(hba, true);
 }
@@ -1268,7 +1260,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	/* Enable Write Booster if we have scaled up else disable it */
 	downgrade_write(&hba->clk_scaling_lock);
 	is_writelock = false;
-	ufshcd_wb_ctrl(hba, scale_up);
+	ufshcd_wb_toggle(hba, scale_up);
 
 out_unprepare:
 	ufshcd_clock_scaling_unprepare(hba, is_writelock);
@@ -5432,85 +5424,78 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
-int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
+static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
 {
-	int ret;
+	int val;
 	u8 index;
-	enum query_opcode opcode;
+
+	if (set)
+		val = UPIU_QUERY_OPCODE_SET_FLAG;
+	else
+		val = UPIU_QUERY_OPCODE_CLEAR_FLAG;
+
+	index = ufshcd_wb_get_query_index(hba);
+	return ufshcd_query_flag_retry(hba, val, idn, index, NULL);
+}
+
+int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
+{
+	int ret;
 
 	if (!ufshcd_is_wb_allowed(hba))
 		return 0;
 
 	if (!(enable ^ hba->dev_info.wb_enabled))
 		return 0;
-	if (enable)
-		opcode = UPIU_QUERY_OPCODE_SET_FLAG;
-	else
-		opcode = UPIU_QUERY_OPCODE_CLEAR_FLAG;
 
-	index = ufshcd_wb_get_query_index(hba);
-	ret = ufshcd_query_flag_retry(hba, opcode,
-				      QUERY_FLAG_IDN_WB_EN, index, NULL);
+	ret = __ufshcd_wb_toggle(hba, enable, QUERY_FLAG_IDN_WB_EN);
 	if (ret) {
-		dev_err(hba->dev, "%s write booster %s failed %d\n",
+		dev_err(hba->dev, "%s Write Booster %s failed %d\n",
 			__func__, enable ? "enable" : "disable", ret);
 		return ret;
 	}
 
 	hba->dev_info.wb_enabled = enable;
-	dev_dbg(hba->dev, "%s write booster %s %d\n",
-			__func__, enable ? "enable" : "disable", ret);
+	dev_info(hba->dev, "%s Write Booster %s\n",
+			__func__, enable ? "enabled" : "disabled");
 
 	return ret;
 }
 
-static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
+static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 {
-	int val;
-	u8 index;
-
-	if (set)
-		val =  UPIU_QUERY_OPCODE_SET_FLAG;
-	else
-		val = UPIU_QUERY_OPCODE_CLEAR_FLAG;
+	int ret;
 
-	index = ufshcd_wb_get_query_index(hba);
-	return ufshcd_query_flag_retry(hba, val,
-				QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8,
-				index, NULL);
+	ret = __ufshcd_wb_toggle(hba, set,
+			QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8);
+	if (ret) {
+		dev_err(hba->dev, "%s: WB-Buf Flush during H8 %s failed: %d\n",
+			__func__, set ? "enable" : "disable", ret);
+		return;
+	}
+	dev_dbg(hba->dev, "%s WB-Buf Flush during H8 %s\n",
+			__func__, set ? "enabled" : "disabled");
 }
 
-static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
+static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
 {
 	int ret;
-	u8 index;
-	enum query_opcode opcode;
 
 	if (!ufshcd_is_wb_allowed(hba) ||
 	    hba->dev_info.wb_buf_flush_enabled == enable)
-		return 0;
-
-	if (enable)
-		opcode = UPIU_QUERY_OPCODE_SET_FLAG;
-	else
-		opcode = UPIU_QUERY_OPCODE_CLEAR_FLAG;
+		return;
 
-	index = ufshcd_wb_get_query_index(hba);
-	ret = ufshcd_query_flag_retry(hba, opcode,
-				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, index,
-				      NULL);
+	ret = __ufshcd_wb_toggle(hba, enable, QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN);
 	if (ret) {
 		dev_err(hba->dev, "%s WB-Buf Flush %s failed %d\n", __func__,
 			enable ? "enable" : "disable", ret);
-		goto out;
+		return;
 	}
 
 	hba->dev_info.wb_buf_flush_enabled = enable;
 
-	dev_dbg(hba->dev, "WB-Buf Flush %s\n", enable ? "enabled" : "disabled");
-out:
-	return ret;
-
+	dev_dbg(hba->dev, "%s WB-Buf Flush %s\n",
+			__func__, enable ? "enabled" : "disabled");
 }
 
 static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 18e56c1..eddc819 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1099,7 +1099,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op);
 
-int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
-- 
1.9.1

