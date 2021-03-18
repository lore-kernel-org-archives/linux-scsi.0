Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E60C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 01:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10D7264E89
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 01:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhCRBql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 21:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhCRBp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 21:45:59 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7564FC06174A;
        Wed, 17 Mar 2021 18:45:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y200so2375887pfb.5;
        Wed, 17 Mar 2021 18:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+4QecddGm1oCsJmGxj3sjZrZwCNdElev9/Z68880k9o=;
        b=LdcsIqd9dPam2t/DikWSH5CErzKpmaYGOBIpfEL5EzVZDu5yzoY3mOSz1DHK5jxchi
         EDeb4GpObdTm077SgzHmHs0WbqjMxyac+TZfhP1u53SgC/uwHTxzxw68CCbOyMQ53nAJ
         JqsaiDd6qIay9I2FGn4CwZxEF6J8mNoF9iY4bWJ+jXc1+IcwOTBXlwWnIe0f+XKJX+js
         rf6Mq8yqf42hpko5/XS4KvKlWCDIhqhoQv93A0ARV6WJB5A3GkEAZWi4TVwgiz+y03cu
         HOXO+cP7z57CSPJD5Jjl1D3slJbZx9KhmT4UOZY5PVBWE6qYzyHkPvR9dfZSkGYsXHtw
         emSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+4QecddGm1oCsJmGxj3sjZrZwCNdElev9/Z68880k9o=;
        b=uWjwQHZ4mGSFKwUl8o4BFTGuhwoBjM/VI0HFO7+Of75Bof8NU0CMTviDBKOKr/Ed90
         4vBJBYziT0P/PjFa99PP4RYYt88pnaJdR6klnZdzhDh0SaFSFmP4mNZv/NrBUYaeTJIU
         krxXHKuGcsDk5KaPNcfcHwNMf6w+lESYNPtKJhYZcHA61OLG9AMl6uBmIYtJRTuwYmZq
         /GLf8IcfYFeLqrc/o3h3BzhRB+valDrbQ4ox7CVFA/iZQYgXQqMkN4doFoIeFknnpcQ1
         3xG7gnGz4RwNr4IQJz0GzEtGicWchhT9U72h+THWgE46lJAP5xm1+Pu2g0wsobSm3EmZ
         QZdQ==
X-Gm-Message-State: AOAM531XnTZ1xxS60wY20ROH3D0NgOVk6hwDPd1KxGw2QdcG6y4kPswh
        XtOpnMgQHRDl2rJSgkuqBao=
X-Google-Smtp-Source: ABdhPJxzyvnPfSJXe8U+4QTRPuzkMHohyukraGikm4vsySqCLuUBN0GwSR4Eh1CSvOmJzSj/kemfDw==
X-Received: by 2002:a63:d94d:: with SMTP id e13mr5022822pgj.160.1616031958856;
        Wed, 17 Mar 2021 18:45:58 -0700 (PDT)
Received: from tj.ccdomain.com ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id r186sm309320pfr.124.2021.03.17.18.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 18:45:58 -0700 (PDT)
From:   Yue Hu <zbestahu@gmail.com>
To:     avri.altman@wdc.com, alim.akhtar@samsung.com,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, huyue2@yulong.com, zbestahu@163.com
Subject: [PATCH v2] scsi: ufs: Tidy up WB configuration code
Date:   Thu, 18 Mar 2021 09:45:44 +0800
Message-Id: <20210318014544.1976-1-zbestahu@gmail.com>
X-Mailer: git-send-email 2.29.2.windows.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

There are similar code implementations for WB configuration in
ufshcd_wb_{ctrl, toggle_flush_during_h8, toggle_flush}. We can
extract the part to create a new helper with a flag parameter to
reduce code duplication.

Meanwhile, rename ufshcd_wb_ctrl() to ufshcd_wb_toggle() for better
readability.

And remove unnecessary log messages from ufshcd_wb_config() since
relevant toggle function will spew log respectively. Also change
ufshcd_wb_toggle_flush{__during_h8} to void type accordingly.

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
v2: use opcode instead of val, update minor log words

 drivers/scsi/ufs/ufs-sysfs.c |  2 +-
 drivers/scsi/ufs/ufshcd.c    | 97 +++++++++++++++++++-------------------------
 drivers/scsi/ufs/ufshcd.h    |  2 +-
 3 files changed, 43 insertions(+), 58 deletions(-)

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
index 7716175..866e73b 100644
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
 	u8 index;
 	enum query_opcode opcode;
 
+	if (set)
+		opcode = UPIU_QUERY_OPCODE_SET_FLAG;
+	else
+		opcode = UPIU_QUERY_OPCODE_CLEAR_FLAG;
+
+	index = ufshcd_wb_get_query_index(hba);
+	return ufshcd_query_flag_retry(hba, opcode, idn, index, NULL);
+}
+
+int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
+{
+	int ret;
+
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

