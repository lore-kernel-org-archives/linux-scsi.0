Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEEABC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FDEC230FF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437903AbhARUM7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437858AbhARULc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:11:32 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43691C061757;
        Mon, 18 Jan 2021 12:10:52 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id p22so18940427edu.11;
        Mon, 18 Jan 2021 12:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qswzafYry+G5B5UE7dVKcDDvMag33fJ8LeQJQxtybQk=;
        b=JtOSolS9NclYRLpUpHvMyLGiJH27+PhY/tBJLEzk78LGNq3niIBA7VpXPeEYbqj0UZ
         aRsozWxIgRQy2kINFEE+oywG8Pv3UrcsQUCPbNenOEg449wOhRWdLx4d5Ec0effzvWbs
         Qk3hmL+3HRJzLD6CSrlkrj6JcKCN9NqjKwKgwHqcBe7EphejSJMIgRE2yy/A6vMshUnA
         BW/P7pZoaj51Q3JXhhdfz9yDCD2rgxcAYHNTSPMwflp9i0yiV8AGJBJ3tOiM1qQvmlZ6
         B48/XNeaSG0ojygeC5ZjTAE/PbDVPbCjz+MyHQEECB6/RlRfEjrKn3b1EkJsvjOwAZjm
         B2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qswzafYry+G5B5UE7dVKcDDvMag33fJ8LeQJQxtybQk=;
        b=Nt+lQsClPOaurinKZ8Vu74HYgc7Wr4DzK0yTcyC1E0NFAA3UkLyPS413feZpogJdzU
         vcXke8ioAXQAiMvoNqbBhmvv/DFgpdAtBl3fflxCZ/JFzLNfUJncN+Ha1EFJE+6KYzSq
         QdHA/G+gOPmsiuYFXekSF2pEMPmX4uicTrHgk3whD8+3aKwNEPTt81AYSKURfB1v+Qr2
         V1hSMi/Hdzf/4rlOmMHxSfXZO0JGcQ9ERvmIu9l+RIQ/WYEuOGMKFIuj/06IWYdBKhF+
         mT0uEIaJA4Gu1Cad4P6cTkv3e46h9lJZpfycjuZO/MSD5lfS95VjxD44BStOyfLiMHfV
         sJqg==
X-Gm-Message-State: AOAM5312w4SJXwuc72B1Jj8L4tdUSDUDW6jVP2V97C5REk/iTpy/dk23
        B7MjRYk2iu3gQqdunM17OOU=
X-Google-Smtp-Source: ABdhPJynLmX+bZFHMlkl+uBTtadEamev70AL6CWzy7J6gz2LvJsDd5xp1UExyaatiPDRjj0GPHO3VA==
X-Received: by 2002:a05:6402:34c3:: with SMTP id w3mr868998edc.3.1611000650870;
        Mon, 18 Jan 2021 12:10:50 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id qh13sm3972543ejb.33.2021.01.18.12.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 12:10:50 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/6] scsi: ufs: Add "wb_on" sysfs node to control WB on/off
Date:   Mon, 18 Jan 2021 21:10:34 +0100
Message-Id: <20210118201039.2398-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210118201039.2398-1-huobean@gmail.com>
References: <20210118201039.2398-1-huobean@gmail.com>
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
 drivers/scsi/ufs/ufs-sysfs.c | 46 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c    |  3 +--
 drivers/scsi/ufs/ufshcd.h    |  2 ++
 3 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index c092f249d6f9..76db8593ca09 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -209,6 +209,50 @@ static ssize_t auto_hibern8_store(struct device *dev,
 	return ret ? ret : count;
 }
 
+static ssize_t wb_on_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", hba->wb_enabled);
+}
+
+static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned int wb_enable;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba) || ufshcd_is_clkscaling_supported(hba)) {
+		/*
+		 * If the platform supports UFSHCD_CAP_CLK_SCALING, turn WB
+		 * on/off will be done while clock scaling up/down.
+		 */
+		dev_warn(dev, "To control WB through wb_on is not allowed!\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (kstrtouint(buf, 0, &wb_enable))
+		return -EINVAL;
+
+	if (wb_enable != 0 && wb_enable != 1)
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res = -EBUSY;
+		goto out;
+	}
+
+	pm_runtime_get_sync(hba->dev);
+	res = ufshcd_wb_ctrl(hba, wb_enable);
+	pm_runtime_put_sync(hba->dev);
+out:
+	up(&hba->host_sem);
+	return res < 0 ? res : count;
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -216,6 +260,7 @@ static DEVICE_ATTR_RW(spm_lvl);
 static DEVICE_ATTR_RO(spm_target_dev_state);
 static DEVICE_ATTR_RO(spm_target_link_state);
 static DEVICE_ATTR_RW(auto_hibern8);
+static DEVICE_ATTR_RW(wb_on);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -225,6 +270,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_spm_target_dev_state.attr,
 	&dev_attr_spm_target_link_state.attr,
 	&dev_attr_auto_hibern8.attr,
+	&dev_attr_wb_on.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5c6ee9394af3..3f2b495b36ee 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -249,7 +249,6 @@ static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
 static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
 static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
@@ -5413,7 +5412,7 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 {
 	int ret;
 	u8 index;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5bbe4715d4e9..ac0f03f69e42 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1089,6 +1089,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op);
 
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
+
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
-- 
2.17.1

