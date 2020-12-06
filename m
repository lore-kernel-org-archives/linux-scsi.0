Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D504C1B0D8
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 10:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BD852333E
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 10:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgLFKOp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 05:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgLFKOa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 05:14:30 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CA4C0613D1;
        Sun,  6 Dec 2020 02:13:50 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id c7so10486778edv.6;
        Sun, 06 Dec 2020 02:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZdbsWuYcR4owa0ugaVEt1w9R8x4VEIMlOHbG6PqGjpc=;
        b=hdHIUUDQcvGQNdSq3PA6aDJhp4DPSbVBWAvgC8aCdT5QEnP8q5hnW2xeI2Xk5zuQ+7
         XUomhewxichdqZzOd3c7ZwA4HAcXlHHGPUi4EMws+S+Mlgp4kzFMX3eXjtHF/CBH1sa8
         Yx097P5VF16BjtUfZW/oOi5C9hMUixKcpTRlfkyGdFDVCYaebmgWGtJzqbe0VZYvflrD
         RhYEx2g4TdWHznYgg1TRjeLedRqutDV88TcoQy8rdG8Wv0IPizR94fOZ7iUkwCaefVdq
         Cnb1IKYd+ScfjA6jB23LHVFVzYFTCRLuUhXP+K+86G3RtEmCjS1hLeJyJJgKp/5xqBzS
         5aFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZdbsWuYcR4owa0ugaVEt1w9R8x4VEIMlOHbG6PqGjpc=;
        b=tryA+uQB1wEXeiujKKxRPC8p0sdIAG2v0w21yOaOWRBJAFrWCbLTkITdah5W3rc+10
         TGKZFjJyQAH6PJ4eNeyYKWSh4lvBU5TTkblLRiUHYvLlpbRZ/aMrEKgiLeUpWCRiaKu1
         u1xF0GCFGKgO4YlGPnn45yewJ1VECVDGoG+JQBc8tcfbIUDMW1MXiadhzshz27hxopY5
         KIF0I2HfCOLWQ8yNSsBzeRU0EAXC6zkxS+GEUjTneTdGPfa7jYSG1tx1QAGWsT/WaScg
         lrwYK4Zj0hIMawajvE/kKhkxQht+4mNaRa2Djz0AysH6eFvgHA+lDPwH3jp5EGGgY7Nq
         IsGA==
X-Gm-Message-State: AOAM5323kBq1r0aSu+eK5qGd2BA/fVdYNcXsoS30ANqFtzng8nyzSw1o
        hyR7t6En/+xOVchj/k2FHCA=
X-Google-Smtp-Source: ABdhPJx3SeXdhiVUfCBm9wor68PC8LWCPxQ53v/7MtKtk7OouV+WhVR5irFHp52jFlmXmKz69fHi1A==
X-Received: by 2002:a50:b586:: with SMTP id a6mr15354121ede.206.1607249629002;
        Sun, 06 Dec 2020 02:13:49 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id f24sm7701919ejf.117.2020.12.06.02.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 02:13:48 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] scsi: ufs: Add "wb_on" sysfs node to control WB on/off
Date:   Sun,  6 Dec 2020 11:13:33 +0100
Message-Id: <20201206101335.3418-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201206101335.3418-1-huobean@gmail.com>
References: <20201206101335.3418-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Currently UFS WriteBooster driver uses clock scaling up/down to set
WB on/off, for the platform which doesn't support UFSHCD_CAP_CLK_SCALING,
WB will be always on. Provide a sysfs attribute to enable/disable WB
during runtime. Write 1/0 to "wb_on" sysfs node to enable/disable UFS WB.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-sysfs.c | 40 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c    |  3 +--
 drivers/scsi/ufs/ufshcd.h    |  2 ++
 3 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 08e72b7eef6a..b3bf7fca00e5 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -189,6 +189,44 @@ static ssize_t auto_hibern8_store(struct device *dev,
 	return count;
 }
 
+static ssize_t wb_on_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", hba->wb_enabled);
+}
+
+static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned int wb_enable;
+	ssize_t res;
+
+	if (ufshcd_is_clkscaling_supported(hba)) {
+		/* If the platform supports UFSHCD_CAP_AUTO_BKOPS_SUSPEND, turn
+		 * WB on/off will be done while clock scaling up/down.
+		 */
+		dev_warn(dev, "To control WB through wb_on is not allowed!\n");
+		return -EOPNOTSUPP;
+	}
+	if (!ufshcd_is_wb_allowed(hba))
+		return -EOPNOTSUPP;
+
+	if (kstrtouint(buf, 0, &wb_enable))
+		return -EINVAL;
+
+	if (wb_enable != 0 && wb_enable != 1)
+		return -EINVAL;
+
+	pm_runtime_get_sync(hba->dev);
+	res = ufshcd_wb_ctrl(hba, wb_enable);
+	pm_runtime_put_sync(hba->dev);
+
+	return res < 0 ? res : count;
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -196,6 +234,7 @@ static DEVICE_ATTR_RW(spm_lvl);
 static DEVICE_ATTR_RO(spm_target_dev_state);
 static DEVICE_ATTR_RO(spm_target_link_state);
 static DEVICE_ATTR_RW(auto_hibern8);
+static DEVICE_ATTR_RW(wb_on);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -205,6 +244,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_spm_target_dev_state.attr,
 	&dev_attr_spm_target_link_state.attr,
 	&dev_attr_auto_hibern8.attr,
+	&dev_attr_wb_on.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 92d433d5f3ca..30332592e624 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -247,7 +247,6 @@ static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
 static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
 static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
@@ -5307,7 +5306,7 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 {
 	int ret;
 	u8 index;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 61344c49c2cc..c61584dff74a 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1068,6 +1068,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op);
 
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
+
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
-- 
2.17.1

