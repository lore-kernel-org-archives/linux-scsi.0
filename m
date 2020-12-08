Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F1B0C4167B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03F31207AA
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgLHVKg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgLHVKd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:10:33 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229A3C061793;
        Tue,  8 Dec 2020 13:09:53 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id ce23so22887887ejb.8;
        Tue, 08 Dec 2020 13:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PpklWkjP2Yw3YF1XNWucRpoNoqCpa0K9B8TluzWP6kw=;
        b=vIJZ0cQSFNSacfHYzYf5aOaonEIdnV5EOQMb/rf8tH0qbF4UfKZBPl8akgutJ1E3om
         WwNu79rkQHYZgvJRh2tTHRB9HZb7B1wKFfhAKi9sWZDy8wCah4jN4XrLzFwH4QdM6ANY
         P/4b+Np+HI1eScDid+kEZogZ8hRt7VDjyI+I1l0HdRMzGxaXEEyjuFlYiEBsL4v4vcDm
         V9Ij261LIiZMf/BeelQs3R4pICzO2lase7xzYyK54Ax1sc6B04M4ohF1bZTVnioXaJ9Z
         ILHDkivPsA49owRLGAwia3q7pmORuIIfM2g1OIiHag8kwOMWcwEZ6Rk0CPVC3GB8kyBS
         dr4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PpklWkjP2Yw3YF1XNWucRpoNoqCpa0K9B8TluzWP6kw=;
        b=Ra01vr5YJyPZZv9Aob+r2X/6L9Q5N2kemKt2LCXx/yFkLathNgf19EKwlfKgW//zXi
         24Kwcsj3RaYRhD7aIDCs90DnaXGA/rXA1zawMwcgAvoGJW+8CSXzqOtyf4w5aKTncWRN
         P+/7jYNmYscRzmHd8a0pJkO3zSO9Oo0DeWDQVfR032m8hZ6t7arlHj18/eVmisK5YkRU
         iah5R70emqzt7Elb4mg/b7FF9IQGXZPXVmRSF574c/DwwS3vvZIP0jKQ/c9uKAaVxXfF
         WeiNF/E0p/iGtKr5+GThMeLEqyVNeOSSbuuAEIiCsZ+XD7vE9DtBGD4qushIkp8a2ZTB
         AjoA==
X-Gm-Message-State: AOAM5303DV5PqlRAkSYzdDYmeBufN9H3Mv7DQikR83IGUBsvPcJ0/ZrF
        gi001BsmdcLXI9iFOfHWeiQ=
X-Google-Smtp-Source: ABdhPJzmYgytETHjFbjU1qsk8rP7ytzqAh3acRvtyl4TNYVc+gy7OtcNh5Kp1Ypg5yB+mMHNdciM9g==
X-Received: by 2002:a17:906:3a55:: with SMTP id a21mr25104244ejf.516.1607461791875;
        Tue, 08 Dec 2020 13:09:51 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id n22sm17908edr.11.2020.12.08.13.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 13:09:51 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] scsi: ufs: Add "wb_on" sysfs node to control WB on/off
Date:   Tue,  8 Dec 2020 22:09:39 +0100
Message-Id: <20201208210941.2177-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201208210941.2177-1-huobean@gmail.com>
References: <20201208210941.2177-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Currently UFS WriteBooster driver uses clock scaling up/down to set
WB on/off, for the platform which doesn't support UFSHCD_CAP_CLK_SCALING,
WB will be always on. Provide a sysfs attribute to enable/disable WB
during runtime. Write 1/0 to "wb_on" sysfs node to enable/disable UFS WB.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-sysfs.c | 41 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c    |  3 +--
 drivers/scsi/ufs/ufshcd.h    |  2 ++
 3 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 08e72b7eef6a..2b4e9fe935cc 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -189,6 +189,45 @@ static ssize_t auto_hibern8_store(struct device *dev,
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
+		/*
+		 * If the platform supports UFSHCD_CAP_AUTO_BKOPS_SUSPEND,
+		 * turn WB on/off will be done while clock scaling up/down.
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
@@ -196,6 +235,7 @@ static DEVICE_ATTR_RW(spm_lvl);
 static DEVICE_ATTR_RO(spm_target_dev_state);
 static DEVICE_ATTR_RO(spm_target_link_state);
 static DEVICE_ATTR_RW(auto_hibern8);
+static DEVICE_ATTR_RW(wb_on);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -205,6 +245,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_spm_target_dev_state.attr,
 	&dev_attr_spm_target_link_state.attr,
 	&dev_attr_auto_hibern8.attr,
+	&dev_attr_wb_on.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 11a4aad09f3a..f9fefb6c7ddb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -245,7 +245,6 @@ static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
 static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
 static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
@@ -5303,7 +5302,7 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 {
 	int ret;
 	u8 index;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 7a7e056a33a9..ea19d6c77faf 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1073,6 +1073,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op);
 
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
+
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
-- 
2.17.1

