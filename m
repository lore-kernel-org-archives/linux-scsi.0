Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F569C63777
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 18:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3496B20789
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 18:13:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K5DC6hbL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbgK3SMl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 13:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgK3SMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 13:12:40 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD9AC0613D3;
        Mon, 30 Nov 2020 10:11:59 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id m16so17459648edr.3;
        Mon, 30 Nov 2020 10:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n06aOaaswcvHv9YXcpBXnaA2YB8ead4UQgsIUm+d5Xs=;
        b=K5DC6hbLguoOxB+dEFNEeZ49CAYEs1jAx2f3mgGzJIIAJ5eDKz7VUL8gxbV53rRSe4
         q1Dl8UrS3M8Q4rXui2N0da6hdt4iySXUoZxFVO2PfbNxJ7wY7Kd9C6FYkwKDSgS2BOfN
         kJlxhrEHsxosgXQWIHLVyB6Qoea9IaNv0gN3ujSWmBWMSfFSD9gJI8s8QmE8lidKlGMp
         /mMlW4rieBL2YEt1VYoV758jEr7BKXg3eOOV2RX7Cv7u+3tKUIoSiYNv+zXuTvS++uDa
         dz4YbqeJLCNzaFHgSRWaULmdP48jprv26lAu4uq71ZrkPIJdfvV1w/2eCs2ttMWFl/Qb
         lqGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n06aOaaswcvHv9YXcpBXnaA2YB8ead4UQgsIUm+d5Xs=;
        b=HX5/e2FLiMjDbCwd51VtGAuvneH5II4keMGdni8Km4yZG156bpmFgJ2j48VSpF4ypG
         34yPUF0Yv1DKyJTCEz7EbI4vuCA3Ii77hWOa4c+NV3QTWl+fOVifeGt+MFY0I+QVzZnd
         bGEQ+C+o456wsxb5SX1B7HWevsG8Q0cUQs8Rc4m2kYhae2M1+BDw3CqsN27nlHM8wGZM
         NsbnCMtR8KBjC+PpBKTnl8vqzi1zFjGSDHNtu8myvnX0JgeBxY5bErq8/ha6aIU6trW4
         8gB9M9SnOQR2aNh8B8reOK92VtWHts7lha1eMW7lrV7CZLjdqLsSkIY5tANW2nLrhUbQ
         iKgQ==
X-Gm-Message-State: AOAM533PNhfh2G9+nkw0vCxt52KZhueZxQcZ5agPlNw6MtpUumuDdz3M
        i8bvFMTPd8kwrumSbd4Q+6s=
X-Google-Smtp-Source: ABdhPJzFztZG2ZHTVVyYgg0W7IBdWYXRc9zl0ILWIBK6gIXW+w0lXeruoXkwuR75EyH4Sdz9HjuhVQ==
X-Received: by 2002:a05:6402:19b4:: with SMTP id o20mr23107551edz.103.1606759918403;
        Mon, 30 Nov 2020 10:11:58 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id d14sm2702899edn.31.2020.11.30.10.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:11:57 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] scsi: ufs: Add "wb_on" sysfs node to control WB on/off
Date:   Mon, 30 Nov 2020 19:11:41 +0100
Message-Id: <20201130181143.5739-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201130181143.5739-1-huobean@gmail.com>
References: <20201130181143.5739-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Currently we let UFS WriteBooster driver use clock scaling
up/down to set WB on/off, for the platform which doesn't
support UFSHCD_CAP_CLK_SCALING, WB will be always on. Provide
a sysfs attribute to enable/disable WB during runtime.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-sysfs.c | 33 +++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c    |  3 +--
 drivers/scsi/ufs/ufshcd.h    |  2 ++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 08e72b7eef6a..e41d8eb779ec 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -189,6 +189,37 @@ static ssize_t auto_hibern8_store(struct device *dev,
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
@@ -196,6 +227,7 @@ static DEVICE_ATTR_RW(spm_lvl);
 static DEVICE_ATTR_RO(spm_target_dev_state);
 static DEVICE_ATTR_RO(spm_target_link_state);
 static DEVICE_ATTR_RW(auto_hibern8);
+static DEVICE_ATTR_RW(wb_on);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -205,6 +237,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_spm_target_dev_state.attr,
 	&dev_attr_spm_target_link_state.attr,
 	&dev_attr_auto_hibern8.attr,
+	&dev_attr_wb_on.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d169db41ee16..639ba9d1ccbb 100644
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
@@ -5299,7 +5298,7 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 {
 	int ret;
 	u8 index;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index d0b68df07eef..c7bb61a4e484 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1067,6 +1067,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op);
 
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
+
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
-- 
2.17.1

