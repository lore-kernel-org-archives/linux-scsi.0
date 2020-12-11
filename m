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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A14CBC2BBCD
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7020924051
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403922AbgLKOBp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395136AbgLKOB3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 09:01:29 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CCAC061793;
        Fri, 11 Dec 2020 06:00:49 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id b9so12509294ejy.0;
        Fri, 11 Dec 2020 06:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qe3W3UutNCxQuteo+hM3T7GHNA4SdG3zmVmMpwoThUk=;
        b=tcDrsORQxIF92mp8OsAgdY3EDdT17lbepFHKyTR8Wixh8UJrzEejFLkWVeWDltWGUJ
         yIPLKubXvElgWGHG/gUBQ65VBt+R4KL4IdShhtOsJ3KxR4ulIoJGileKy6P1X3c7BCS3
         oeIj6m06s9PpcbzDmbJt0sm5fo86QfPgN9tGntnIwfa/vKUhnBgN8lNGBfz7M9MwMuIq
         7ubO8P73Ok+fOzMPWC6pNTQx4R34FP9aUb+8yJa8odAHVJf/RLswdKXYWDxyKwAe7vXD
         DE4DarzDnjCeH69jUmYeODWkFXs1ZRavlByWg0ORGtKNs+U89S78HGzIR+Q9Dh5JIjm0
         wfhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qe3W3UutNCxQuteo+hM3T7GHNA4SdG3zmVmMpwoThUk=;
        b=FXnRggKi+0ljc1xLIYjLGn4NsRec2ONCEQhQwkEhekALyRu0DFls/V3i8JIIHYUnMv
         GJ9V7JDbFl99M5BtrWXOKtRvs2U201pDiXxjaN9GeIIQnZ33WbxgXzsoRuQxho4TeOzz
         8KJLN7kYIHPJgIu5eKzDKifrHNs9DZsy/T7Z4Lb0Pv6EtAlT35XjrzMxQHz2UgFkJqle
         rAv2DedZkCN3RAuQWP9GGjEDdnjzF+OZS3AWGZu/N7DIn1P8tNK/Bzlw04bln+AWWRpD
         MAInF84byGZwE4i5q/iUVn/0YH7Fincyp+T17BlsXZL+/yIUhew+0KsO7/fgHzIC4UJn
         G0bg==
X-Gm-Message-State: AOAM532Dej4QZDnLfyvrCrJUZgARL/TvxemAmrDdoZzVSweR3Ns5YcxS
        10bdPflEsqHzYYwQEYuI0Mk=
X-Google-Smtp-Source: ABdhPJxhepqfpDA43gU+g7EjJtXaRdG8G0X06MdSY89FRKqr+1R4d1ezjDTkjiNpeLeIoTewfsd2tg==
X-Received: by 2002:a17:906:4994:: with SMTP id p20mr10953922eju.391.1607695247710;
        Fri, 11 Dec 2020 06:00:47 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id z24sm7797818edr.9.2020.12.11.06.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:00:46 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/6] scsi: ufs: Add "wb_on" sysfs node to control WB on/off
Date:   Fri, 11 Dec 2020 15:00:30 +0100
Message-Id: <20201211140035.20016-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201211140035.20016-1-huobean@gmail.com>
References: <20201211140035.20016-1-huobean@gmail.com>
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
index e221add25a7e..5e1dcf4de67e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -246,7 +246,6 @@ static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
 static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
 static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
@@ -5351,7 +5350,7 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 {
 	int ret;
 	u8 index;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 9bb5f0ed4124..2a97006a2c93 100644
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

