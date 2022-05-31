Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE21FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 03:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243747AbiEaDzA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 23:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238235AbiEaDy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 23:54:58 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C8293996
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 20:54:54 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id n8so11799637plh.1
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 20:54:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zF8qrcDqQ279KTa5ltqYqzj6Sppxl7g4fn1ebimoeUU=;
        b=gJpsXypDG14oGKuDvomBnGnZWRaxFEnqKlnmUj6ZreV64cMICWe5Rx9h4KzYoOsc6U
         33dsA3cfOFVBoJrXb365c5XXQBE0OH3QTFJUrC/jZ/8bmnGQoEUHRRnu13rCtauAd1pq
         yu+nAifZ/Mk14YohhMn/mSQMAy4zSaUvqynx+pMk7emV7qR00xiy1DGWObaZsixTtGUR
         TSwia9Y2Deu3u/6xUMbEWUROS3ONKh0a5dkkVBlm3k8W4OnLDc0SR4odZC5wV0nqKcMW
         dbJibz4pOHLT2pY0FTagwBQdp56x0ewmRdCtCDa+Z728m4jHB4tB9B+AF9BljA0Mfzqx
         OMeA==
X-Gm-Message-State: AOAM5311hKHHIvWgqHOJ+wfW2t0K1CEg+eSJwVZlut57kSOHphw2lrtC
        vNyVlrZ6ABqoQMnttxjAXzY=
X-Google-Smtp-Source: ABdhPJxf8z9omD0ZUanvpSd5pxLwfPsfIZYHoMpvZhGoBvLxyU0aAKFZtVI4e8BBvpVwVuEbrNbuMA==
X-Received: by 2002:a17:902:9b83:b0:164:59e:b189 with SMTP id y3-20020a1709029b8300b00164059eb189mr1287640plp.91.1653969293445;
        Mon, 30 May 2022 20:54:53 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id h28-20020a63211c000000b003fbaae74971sm7378851pgh.72.2022.05.30.20.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 20:54:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Keoseong Park <keosung.park@samsung.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH] scsi: ufs: Split struct ufs_hba
Date:   Mon, 30 May 2022 20:54:32 -0700
Message-Id: <20220531035432.11928-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Improve separation between UFSHCI core and host drivers by splitting
struct ufs_hba. This patch does not change the behavior of the UFS
driver. The conversions between the struct ufs_hba and the struct
ufs_hba_priv pointer types do not introduce any overhead since the
compiler can optimize these out.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Keoseong Park <keosung.park@samsung.com>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-debugfs.c   |   79 +-
 drivers/ufs/core/ufs-hwmon.c     |   42 +-
 drivers/ufs/core/ufs-sysfs.c     |  141 ++-
 drivers/ufs/core/ufs_bsg.c       |   14 +-
 drivers/ufs/core/ufshcd-crypto.c |   49 +-
 drivers/ufs/core/ufshcd-priv.h   |  229 +++-
 drivers/ufs/core/ufshcd.c        | 1782 ++++++++++++++++--------------
 drivers/ufs/core/ufshpb.c        |   40 +-
 include/ufs/ufshcd.h             |  175 +--
 9 files changed, 1409 insertions(+), 1142 deletions(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index e3baed6c70bd..12ff7bdf84aa 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -34,7 +34,8 @@ void ufs_debugfs_exit(void)
 static int ufs_debugfs_stats_show(struct seq_file *s, void *data)
 {
 	struct ufs_hba *hba = hba_from_file(s->file);
-	struct ufs_event_hist *e = hba->ufs_stats.event;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufs_event_hist *e = priv->ufs_stats.event;
 
 #define PRT(fmt, typ) \
 	seq_printf(s, fmt, e[UFS_EVT_ ## typ].cnt)
@@ -60,17 +61,20 @@ DEFINE_SHOW_ATTRIBUTE(ufs_debugfs_stats);
 static int ee_usr_mask_get(void *data, u64 *val)
 {
 	struct ufs_hba *hba = data;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	*val = hba->ee_usr_mask;
+	*val = priv->ee_usr_mask;
 	return 0;
 }
 
 static int ufs_debugfs_get_user_access(struct ufs_hba *hba)
-__acquires(&hba->host_sem)
+	__acquires(&priv->host_sem)
 {
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
-		up(&hba->host_sem);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	down(&priv->host_sem);
+	if (!ufshcd_is_user_access_allowed(priv)) {
+		up(&priv->host_sem);
 		return -EBUSY;
 	}
 	ufshcd_rpm_get_sync(hba);
@@ -78,15 +82,18 @@ __acquires(&hba->host_sem)
 }
 
 static void ufs_debugfs_put_user_access(struct ufs_hba *hba)
-__releases(&hba->host_sem)
+	__releases(&priv->host_sem)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	ufshcd_rpm_put_sync(hba);
-	up(&hba->host_sem);
+	up(&priv->host_sem);
 }
 
 static int ee_usr_mask_set(void *data, u64 val)
 {
 	struct ufs_hba *hba = data;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err;
 
 	if (val & ~(u64)MASK_EE_STATUS)
@@ -94,7 +101,7 @@ static int ee_usr_mask_set(void *data, u64 val)
 	err = ufs_debugfs_get_user_access(hba);
 	if (err)
 		return err;
-	err = ufshcd_update_ee_usr_mask(hba, val, MASK_EE_STATUS);
+	err = ufshcd_update_ee_usr_mask(priv, val, MASK_EE_STATUS);
 	ufs_debugfs_put_user_access(hba);
 	return err;
 }
@@ -103,36 +110,39 @@ DEFINE_DEBUGFS_ATTRIBUTE(ee_usr_mask_fops, ee_usr_mask_get, ee_usr_mask_set, "%#
 
 void ufs_debugfs_exception_event(struct ufs_hba *hba, u16 status)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	bool chgd = false;
 	u16 ee_ctrl_mask;
 	int err = 0;
 
-	if (!hba->debugfs_ee_rate_limit_ms || !status)
+	if (!priv->debugfs_ee_rate_limit_ms || !status)
 		return;
 
-	mutex_lock(&hba->ee_ctrl_mutex);
-	ee_ctrl_mask = hba->ee_drv_mask | (hba->ee_usr_mask & ~status);
-	chgd = ee_ctrl_mask != hba->ee_ctrl_mask;
+	mutex_lock(&priv->ee_ctrl_mutex);
+	ee_ctrl_mask = priv->ee_drv_mask | (priv->ee_usr_mask & ~status);
+	chgd = ee_ctrl_mask != priv->ee_ctrl_mask;
 	if (chgd) {
 		err = __ufshcd_write_ee_control(hba, ee_ctrl_mask);
 		if (err)
 			dev_err(hba->dev, "%s: failed to write ee control %d\n",
 				__func__, err);
 	}
-	mutex_unlock(&hba->ee_ctrl_mutex);
+	mutex_unlock(&priv->ee_ctrl_mutex);
 
 	if (chgd && !err) {
-		unsigned long delay = msecs_to_jiffies(hba->debugfs_ee_rate_limit_ms);
+		unsigned long delay = msecs_to_jiffies(priv->debugfs_ee_rate_limit_ms);
 
-		queue_delayed_work(system_freezable_wq, &hba->debugfs_ee_work, delay);
+		queue_delayed_work(system_freezable_wq, &priv->debugfs_ee_work, delay);
 	}
 }
 
 static void ufs_debugfs_restart_ee(struct work_struct *work)
 {
-	struct ufs_hba *hba = container_of(work, struct ufs_hba, debugfs_ee_work.work);
+	struct ufs_hba_priv *priv = container_of(work, struct ufs_hba_priv,
+						 debugfs_ee_work.work);
+	struct ufs_hba *hba = &priv->hba;
 
-	if (!hba->ee_usr_mask || pm_runtime_suspended(hba->dev) ||
+	if (!priv->ee_usr_mask || pm_runtime_suspended(hba->dev) ||
 	    ufs_debugfs_get_user_access(hba))
 		return;
 	ufshcd_write_ee_control(hba);
@@ -143,12 +153,13 @@ static int ufs_saved_err_show(struct seq_file *s, void *data)
 {
 	struct ufs_debugfs_attr *attr = s->private;
 	struct ufs_hba *hba = hba_from_file(s->file);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	const int *p;
 
 	if (strcmp(attr->name, "saved_err") == 0) {
-		p = &hba->saved_err;
+		p = &priv->saved_err;
 	} else if (strcmp(attr->name, "saved_uic_err") == 0) {
-		p = &hba->saved_uic_err;
+		p = &priv->saved_uic_err;
 	} else {
 		return -ENOENT;
 	}
@@ -162,6 +173,7 @@ static ssize_t ufs_saved_err_write(struct file *file, const char __user *buf,
 {
 	struct ufs_debugfs_attr *attr = file->f_inode->i_private;
 	struct ufs_hba *hba = hba_from_file(file);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	char val_str[16] = { };
 	int val, ret;
 
@@ -173,17 +185,17 @@ static ssize_t ufs_saved_err_write(struct file *file, const char __user *buf,
 	if (ret < 0)
 		return ret;
 
-	spin_lock_irq(hba->host->host_lock);
+	spin_lock_irq(priv->host->host_lock);
 	if (strcmp(attr->name, "saved_err") == 0) {
-		hba->saved_err = val;
+		priv->saved_err = val;
 	} else if (strcmp(attr->name, "saved_uic_err") == 0) {
-		hba->saved_uic_err = val;
+		priv->saved_uic_err = val;
 	} else {
 		ret = -ENOENT;
 	}
 	if (ret == 0)
 		ufshcd_schedule_eh_work(hba);
-	spin_unlock_irq(hba->host->host_lock);
+	spin_unlock_irq(priv->host->host_lock);
 
 	return ret < 0 ? ret : count;
 }
@@ -211,29 +223,32 @@ static const struct ufs_debugfs_attr ufs_attrs[] = {
 
 void ufs_debugfs_hba_init(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	const struct ufs_debugfs_attr *attr;
 	struct dentry *root;
 
 	/* Set default exception event rate limit period to 20ms */
-	hba->debugfs_ee_rate_limit_ms = 20;
-	INIT_DELAYED_WORK(&hba->debugfs_ee_work, ufs_debugfs_restart_ee);
+	priv->debugfs_ee_rate_limit_ms = 20;
+	INIT_DELAYED_WORK(&priv->debugfs_ee_work, ufs_debugfs_restart_ee);
 
 	root = debugfs_create_dir(dev_name(hba->dev), ufs_debugfs_root);
 	if (IS_ERR_OR_NULL(root))
 		return;
-	hba->debugfs_root = root;
+	priv->debugfs_root = root;
 	d_inode(root)->i_private = hba;
 	for (attr = ufs_attrs; attr->name; attr++)
 		debugfs_create_file(attr->name, attr->mode, root, (void *)attr,
 				    attr->fops);
-	debugfs_create_file("exception_event_mask", 0600, hba->debugfs_root,
+	debugfs_create_file("exception_event_mask", 0600, priv->debugfs_root,
 			    hba, &ee_usr_mask_fops);
-	debugfs_create_u32("exception_event_rate_limit_ms", 0600, hba->debugfs_root,
-			   &hba->debugfs_ee_rate_limit_ms);
+	debugfs_create_u32("exception_event_rate_limit_ms", 0600, priv->debugfs_root,
+			   &priv->debugfs_ee_rate_limit_ms);
 }
 
 void ufs_debugfs_hba_exit(struct ufs_hba *hba)
 {
-	debugfs_remove_recursive(hba->debugfs_root);
-	cancel_delayed_work_sync(&hba->debugfs_ee_work);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	debugfs_remove_recursive(priv->debugfs_root);
+	cancel_delayed_work_sync(&priv->debugfs_ee_work);
 }
diff --git a/drivers/ufs/core/ufs-hwmon.c b/drivers/ufs/core/ufs-hwmon.c
index 4c6a872b7a7c..3a6c1ceb9042 100644
--- a/drivers/ufs/core/ufs-hwmon.c
+++ b/drivers/ufs/core/ufs-hwmon.c
@@ -52,12 +52,13 @@ static int ufs_hwmon_read(struct device *dev, enum hwmon_sensor_types type, u32
 {
 	struct ufs_hwmon_data *data = dev_get_drvdata(dev);
 	struct ufs_hba *hba = data->hba;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err;
 
-	down(&hba->host_sem);
+	down(&priv->host_sem);
 
-	if (!ufshcd_is_user_access_allowed(hba)) {
-		up(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(priv)) {
+		up(&priv->host_sem);
 		return -EBUSY;
 	}
 
@@ -88,7 +89,7 @@ static int ufs_hwmon_read(struct device *dev, enum hwmon_sensor_types type, u32
 
 	ufshcd_rpm_put_sync(hba);
 
-	up(&hba->host_sem);
+	up(&priv->host_sem);
 
 	return err;
 }
@@ -98,6 +99,7 @@ static int ufs_hwmon_write(struct device *dev, enum hwmon_sensor_types type, u32
 {
 	struct ufs_hwmon_data *data = dev_get_drvdata(dev);
 	struct ufs_hba *hba = data->hba;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err;
 
 	if (attr != hwmon_temp_enable)
@@ -106,23 +108,23 @@ static int ufs_hwmon_write(struct device *dev, enum hwmon_sensor_types type, u32
 	if (val != 0 && val != 1)
 		return -EINVAL;
 
-	down(&hba->host_sem);
+	down(&priv->host_sem);
 
-	if (!ufshcd_is_user_access_allowed(hba)) {
-		up(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(priv)) {
+		up(&priv->host_sem);
 		return -EBUSY;
 	}
 
 	ufshcd_rpm_get_sync(hba);
 
 	if (val == 1)
-		err = ufshcd_update_ee_usr_mask(hba, MASK_EE_URGENT_TEMP, 0);
+		err = ufshcd_update_ee_usr_mask(priv, MASK_EE_URGENT_TEMP, 0);
 	else
-		err = ufshcd_update_ee_usr_mask(hba, 0, MASK_EE_URGENT_TEMP);
+		err = ufshcd_update_ee_usr_mask(priv, 0, MASK_EE_URGENT_TEMP);
 
 	ufshcd_rpm_put_sync(hba);
 
-	up(&hba->host_sem);
+	up(&priv->host_sem);
 
 	return err;
 }
@@ -164,6 +166,7 @@ static const struct hwmon_chip_info ufs_hwmon_hba_info = {
 
 void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct device *dev = hba->dev;
 	struct ufs_hwmon_data *data;
 	struct device *hwmon;
@@ -182,30 +185,33 @@ void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask)
 		return;
 	}
 
-	hba->hwmon_device = hwmon;
+	priv->hwmon_device = hwmon;
 }
 
 void ufs_hwmon_remove(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufs_hwmon_data *data;
 
-	if (!hba->hwmon_device)
+	if (!priv->hwmon_device)
 		return;
 
-	data = dev_get_drvdata(hba->hwmon_device);
-	hwmon_device_unregister(hba->hwmon_device);
-	hba->hwmon_device = NULL;
+	data = dev_get_drvdata(priv->hwmon_device);
+	hwmon_device_unregister(priv->hwmon_device);
+	priv->hwmon_device = NULL;
 	kfree(data);
 }
 
 void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask)
 {
-	if (!hba->hwmon_device)
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	if (!priv->hwmon_device)
 		return;
 
 	if (ee_mask & MASK_EE_TOO_HIGH_TEMP)
-		hwmon_notify_event(hba->hwmon_device, hwmon_temp, hwmon_temp_max_alarm, 0);
+		hwmon_notify_event(priv->hwmon_device, hwmon_temp, hwmon_temp_max_alarm, 0);
 
 	if (ee_mask & MASK_EE_TOO_LOW_TEMP)
-		hwmon_notify_event(hba->hwmon_device, hwmon_temp, hwmon_temp_min_alarm, 0);
+		hwmon_notify_event(priv->hwmon_device, hwmon_temp, hwmon_temp_min_alarm, 0);
 }
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 0a088b47d557..e38904a3dfba 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -40,6 +40,7 @@ static inline ssize_t ufs_sysfs_pm_lvl_store(struct device *dev,
 					     bool rpm)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	unsigned long flags, value;
 
@@ -54,12 +55,12 @@ static inline ssize_t ufs_sysfs_pm_lvl_store(struct device *dev,
 	     !(dev_info->wspecversion >= 0x310)))
 		return -EINVAL;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	if (rpm)
 		hba->rpm_lvl = value;
 	else
 		hba->spm_lvl = value;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	return count;
 }
 
@@ -157,12 +158,13 @@ static ssize_t auto_hibern8_show(struct device *dev,
 	u32 ahit;
 	int ret;
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
 	if (!ufshcd_is_auto_hibern8_supported(hba))
 		return -EOPNOTSUPP;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
+	down(&priv->host_sem);
+	if (!ufshcd_is_user_access_allowed(priv)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -176,7 +178,7 @@ static ssize_t auto_hibern8_show(struct device *dev,
 	ret = sysfs_emit(buf, "%d\n", ufshcd_ahit_to_us(ahit));
 
 out:
-	up(&hba->host_sem);
+	up(&priv->host_sem);
 	return ret;
 }
 
@@ -185,6 +187,7 @@ static ssize_t auto_hibern8_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned int timer;
 	int ret = 0;
 
@@ -197,8 +200,8 @@ static ssize_t auto_hibern8_store(struct device *dev,
 	if (timer > UFSHCI_AHIBERN8_MAX)
 		return -EINVAL;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
+	down(&priv->host_sem);
+	if (!ufshcd_is_user_access_allowed(priv)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -206,7 +209,7 @@ static ssize_t auto_hibern8_store(struct device *dev,
 	ufshcd_auto_hibern8_update(hba, ufshcd_us_to_ahit(timer));
 
 out:
-	up(&hba->host_sem);
+	up(&priv->host_sem);
 	return ret ? ret : count;
 }
 
@@ -222,6 +225,7 @@ static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned int wb_enable;
 	ssize_t res;
 
@@ -240,8 +244,8 @@ static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
 	if (wb_enable != 0 && wb_enable != 1)
 		return -EINVAL;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
+	down(&priv->host_sem);
+	if (!ufshcd_is_user_access_allowed(priv)) {
 		res = -EBUSY;
 		goto out;
 	}
@@ -250,7 +254,7 @@ static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
 	res = ufshcd_wb_toggle(hba, wb_enable);
 	ufshcd_rpm_put_sync(hba);
 out:
-	up(&hba->host_sem);
+	up(&priv->host_sem);
 	return res < 0 ? res : count;
 }
 
@@ -283,8 +287,9 @@ static ssize_t monitor_enable_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	return sysfs_emit(buf, "%d\n", hba->monitor.enabled);
+	return sysfs_emit(buf, "%d\n", priv->monitor.enabled);
 }
 
 static ssize_t monitor_enable_store(struct device *dev,
@@ -292,25 +297,26 @@ static ssize_t monitor_enable_store(struct device *dev,
 				    const char *buf, size_t count)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long value, flags;
 
 	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	value = !!value;
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (value == hba->monitor.enabled)
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	if (value == priv->monitor.enabled)
 		goto out_unlock;
 
 	if (!value) {
-		memset(&hba->monitor, 0, sizeof(hba->monitor));
+		memset(&priv->monitor, 0, sizeof(priv->monitor));
 	} else {
-		hba->monitor.enabled = true;
-		hba->monitor.enabled_ts = ktime_get();
+		priv->monitor.enabled = true;
+		priv->monitor.enabled_ts = ktime_get();
 	}
 
 out_unlock:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	return count;
 }
 
@@ -318,8 +324,9 @@ static ssize_t monitor_chunk_size_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	return sysfs_emit(buf, "%lu\n", hba->monitor.chunk_size);
+	return sysfs_emit(buf, "%lu\n", priv->monitor.chunk_size);
 }
 
 static ssize_t monitor_chunk_size_store(struct device *dev,
@@ -327,16 +334,17 @@ static ssize_t monitor_chunk_size_store(struct device *dev,
 				    const char *buf, size_t count)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long value, flags;
 
 	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	/* Only allow chunk size change when monitor is disabled */
-	if (!hba->monitor.enabled)
-		hba->monitor.chunk_size = value;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (!priv->monitor.enabled)
+		priv->monitor.chunk_size = value;
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	return count;
 }
 
@@ -344,25 +352,28 @@ static ssize_t read_total_sectors_show(struct device *dev,
 				       struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	return sysfs_emit(buf, "%lu\n", hba->monitor.nr_sec_rw[READ]);
+	return sysfs_emit(buf, "%lu\n", priv->monitor.nr_sec_rw[READ]);
 }
 
 static ssize_t read_total_busy_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
 	return sysfs_emit(buf, "%llu\n",
-			  ktime_to_us(hba->monitor.total_busy[READ]));
+			  ktime_to_us(priv->monitor.total_busy[READ]));
 }
 
 static ssize_t read_nr_requests_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	return sysfs_emit(buf, "%lu\n", hba->monitor.nr_req[READ]);
+	return sysfs_emit(buf, "%lu\n", priv->monitor.nr_req[READ]);
 }
 
 static ssize_t read_req_latency_avg_show(struct device *dev,
@@ -370,7 +381,8 @@ static ssize_t read_req_latency_avg_show(struct device *dev,
 					 char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
-	struct ufs_hba_monitor *m = &hba->monitor;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufs_hba_monitor *m = &priv->monitor;
 
 	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[READ]),
 						 m->nr_req[READ]));
@@ -381,9 +393,10 @@ static ssize_t read_req_latency_max_show(struct device *dev,
 					 char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
 	return sysfs_emit(buf, "%llu\n",
-			  ktime_to_us(hba->monitor.lat_max[READ]));
+			  ktime_to_us(priv->monitor.lat_max[READ]));
 }
 
 static ssize_t read_req_latency_min_show(struct device *dev,
@@ -391,9 +404,10 @@ static ssize_t read_req_latency_min_show(struct device *dev,
 					 char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
 	return sysfs_emit(buf, "%llu\n",
-			  ktime_to_us(hba->monitor.lat_min[READ]));
+			  ktime_to_us(priv->monitor.lat_min[READ]));
 }
 
 static ssize_t read_req_latency_sum_show(struct device *dev,
@@ -401,9 +415,10 @@ static ssize_t read_req_latency_sum_show(struct device *dev,
 					 char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
 	return sysfs_emit(buf, "%llu\n",
-			  ktime_to_us(hba->monitor.lat_sum[READ]));
+			  ktime_to_us(priv->monitor.lat_sum[READ]));
 }
 
 static ssize_t write_total_sectors_show(struct device *dev,
@@ -411,25 +426,28 @@ static ssize_t write_total_sectors_show(struct device *dev,
 					char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	return sysfs_emit(buf, "%lu\n", hba->monitor.nr_sec_rw[WRITE]);
+	return sysfs_emit(buf, "%lu\n", priv->monitor.nr_sec_rw[WRITE]);
 }
 
 static ssize_t write_total_busy_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
 	return sysfs_emit(buf, "%llu\n",
-			  ktime_to_us(hba->monitor.total_busy[WRITE]));
+			  ktime_to_us(priv->monitor.total_busy[WRITE]));
 }
 
 static ssize_t write_nr_requests_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	return sysfs_emit(buf, "%lu\n", hba->monitor.nr_req[WRITE]);
+	return sysfs_emit(buf, "%lu\n", priv->monitor.nr_req[WRITE]);
 }
 
 static ssize_t write_req_latency_avg_show(struct device *dev,
@@ -437,7 +455,8 @@ static ssize_t write_req_latency_avg_show(struct device *dev,
 					  char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
-	struct ufs_hba_monitor *m = &hba->monitor;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufs_hba_monitor *m = &priv->monitor;
 
 	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[WRITE]),
 						 m->nr_req[WRITE]));
@@ -448,9 +467,10 @@ static ssize_t write_req_latency_max_show(struct device *dev,
 					  char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
 	return sysfs_emit(buf, "%llu\n",
-			  ktime_to_us(hba->monitor.lat_max[WRITE]));
+			  ktime_to_us(priv->monitor.lat_max[WRITE]));
 }
 
 static ssize_t write_req_latency_min_show(struct device *dev,
@@ -458,9 +478,10 @@ static ssize_t write_req_latency_min_show(struct device *dev,
 					  char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
 	return sysfs_emit(buf, "%llu\n",
-			  ktime_to_us(hba->monitor.lat_min[WRITE]));
+			  ktime_to_us(priv->monitor.lat_min[WRITE]));
 }
 
 static ssize_t write_req_latency_sum_show(struct device *dev,
@@ -468,9 +489,10 @@ static ssize_t write_req_latency_sum_show(struct device *dev,
 					  char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
 	return sysfs_emit(buf, "%llu\n",
-			  ktime_to_us(hba->monitor.lat_sum[WRITE]));
+			  ktime_to_us(priv->monitor.lat_sum[WRITE]));
 }
 
 static DEVICE_ATTR_RW(monitor_enable);
@@ -522,14 +544,15 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 				  u8 *sysfs_buf,
 				  u8 param_size)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	u8 desc_buf[8] = {0};
 	int ret;
 
 	if (param_size > 8)
 		return -EINVAL;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
+	down(&priv->host_sem);
+	if (!ufshcd_is_user_access_allowed(priv)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -562,7 +585,7 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 	}
 
 out:
-	up(&hba->host_sem);
+	up(&priv->host_sem);
 	return ret;
 }
 
@@ -913,18 +936,19 @@ static ssize_t _name##_show(struct device *dev,				\
 {									\
 	u8 index;							\
 	struct ufs_hba *hba = dev_get_drvdata(dev);			\
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);\
 	int ret;							\
 	int desc_len = QUERY_DESC_MAX_SIZE;				\
 	u8 *desc_buf;							\
 									\
-	down(&hba->host_sem);						\
-	if (!ufshcd_is_user_access_allowed(hba)) {			\
-		up(&hba->host_sem);					\
+	down(&priv->host_sem);						\
+	if (!ufshcd_is_user_access_allowed(priv)) {			\
+		up(&priv->host_sem);					\
 		return -EBUSY;						\
 	}								\
 	desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_ATOMIC);		\
 	if (!desc_buf) {						\
-		up(&hba->host_sem);					\
+		up(&priv->host_sem);					\
 		return -ENOMEM;						\
 	}								\
 	ufshcd_rpm_get_sync(hba);					\
@@ -946,7 +970,7 @@ static ssize_t _name##_show(struct device *dev,				\
 out:									\
 	ufshcd_rpm_put_sync(hba);					\
 	kfree(desc_buf);						\
-	up(&hba->host_sem);						\
+	up(&priv->host_sem);						\
 	return ret;							\
 }									\
 static DEVICE_ATTR_RO(_name)
@@ -985,10 +1009,11 @@ static ssize_t _name##_show(struct device *dev,				\
 	u8 index = 0;							\
 	int ret;							\
 	struct ufs_hba *hba = dev_get_drvdata(dev);			\
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);\
 									\
-	down(&hba->host_sem);						\
-	if (!ufshcd_is_user_access_allowed(hba)) {			\
-		up(&hba->host_sem);					\
+	down(&priv->host_sem);						\
+	if (!ufshcd_is_user_access_allowed(priv)) {			\
+		up(&priv->host_sem);					\
 		return -EBUSY;						\
 	}								\
 	if (ufshcd_is_wb_flags(QUERY_FLAG_IDN##_uname))			\
@@ -1003,7 +1028,7 @@ static ssize_t _name##_show(struct device *dev,				\
 	}								\
 	ret = sysfs_emit(buf, "%s\n", flag ? "true" : "false");		\
 out:									\
-	up(&hba->host_sem);						\
+	up(&priv->host_sem);						\
 	return ret;							\
 }									\
 static DEVICE_ATTR_RO(_name)
@@ -1053,13 +1078,14 @@ static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
 {									\
 	struct ufs_hba *hba = dev_get_drvdata(dev);			\
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);\
 	u32 value;							\
 	int ret;							\
 	u8 index = 0;							\
 									\
-	down(&hba->host_sem);						\
-	if (!ufshcd_is_user_access_allowed(hba)) {			\
-		up(&hba->host_sem);					\
+	down(&priv->host_sem);						\
+	if (!ufshcd_is_user_access_allowed(priv)) {			\
+		up(&priv->host_sem);					\
 		return -EBUSY;						\
 	}								\
 	if (ufshcd_is_wb_attrs(QUERY_ATTR_IDN##_uname))			\
@@ -1074,7 +1100,7 @@ static ssize_t _name##_show(struct device *dev,				\
 	}								\
 	ret = sysfs_emit(buf, "0x%08X\n", value);			\
 out:									\
-	up(&hba->host_sem);						\
+	up(&priv->host_sem);						\
 	return ret;							\
 }									\
 static DEVICE_ATTR_RO(_name)
@@ -1152,7 +1178,9 @@ static ssize_t _pname##_show(struct device *dev,			\
 {									\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
 	struct ufs_hba *hba = shost_priv(sdev->host);			\
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);\
 	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);			\
+									\
 	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun,		\
 				_duname##_DESC_PARAM##_puname))		\
 		return -EINVAL;						\
@@ -1216,11 +1244,12 @@ static ssize_t dyn_cap_needed_attribute_show(struct device *dev,
 	u32 value;
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct ufs_hba *hba = shost_priv(sdev->host);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);
 	int ret;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
+	down(&priv->host_sem);
+	if (!ufshcd_is_user_access_allowed(priv)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -1237,7 +1266,7 @@ static ssize_t dyn_cap_needed_attribute_show(struct device *dev,
 	ret = sysfs_emit(buf, "0x%08X\n", value);
 
 out:
-	up(&hba->host_sem);
+	up(&priv->host_sem);
 	return ret;
 }
 static DEVICE_ATTR_RO(dyn_cap_needed_attribute);
diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index b99e3f3dc4ef..abfc4a827c31 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -175,12 +175,13 @@ static int ufs_bsg_request(struct bsg_job *job)
  */
 void ufs_bsg_remove(struct ufs_hba *hba)
 {
-	struct device *bsg_dev = &hba->bsg_dev;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct device *bsg_dev = &priv->bsg_dev;
 
-	if (!hba->bsg_queue)
+	if (!priv->bsg_queue)
 		return;
 
-	bsg_remove_queue(hba->bsg_queue);
+	bsg_remove_queue(priv->bsg_queue);
 
 	device_del(bsg_dev);
 	put_device(bsg_dev);
@@ -199,8 +200,9 @@ static inline void ufs_bsg_node_release(struct device *dev)
  */
 int ufs_bsg_probe(struct ufs_hba *hba)
 {
-	struct device *bsg_dev = &hba->bsg_dev;
-	struct Scsi_Host *shost = hba->host;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct device *bsg_dev = &priv->bsg_dev;
+	struct Scsi_Host *shost = priv->host;
 	struct device *parent = &shost->shost_gendev;
 	struct request_queue *q;
 	int ret;
@@ -222,7 +224,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 		goto out;
 	}
 
-	hba->bsg_queue = q;
+	priv->bsg_queue = q;
 
 	return 0;
 
diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index 198360fe5e8e..2658e213f05a 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -20,8 +20,9 @@ static const struct ufs_crypto_alg_entry {
 static int ufshcd_program_key(struct ufs_hba *hba,
 			      const union ufs_crypto_cfg_entry *cfg, int slot)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int i;
-	u32 slot_offset = hba->crypto_cfg_register + slot * sizeof(*cfg);
+	u32 slot_offset = priv->crypto_cfg_register + slot * sizeof(*cfg);
 	int err = 0;
 
 	ufshcd_hold(hba, false);
@@ -52,8 +53,9 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 					 const struct blk_crypto_key *key,
 					 unsigned int slot)
 {
-	struct ufs_hba *hba =
-		container_of(profile, struct ufs_hba, crypto_profile);
+	struct ufs_hba_priv *priv =
+		container_of(profile, struct ufs_hba_priv, crypto_profile);
+	struct ufs_hba *hba = &priv->hba;
 	const union ufs_crypto_cap_entry *ccap_array = hba->crypto_cap_array;
 	const struct ufs_crypto_alg_entry *alg =
 			&ufs_crypto_algs[key->crypto_cfg.crypto_mode];
@@ -64,7 +66,7 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 	int err;
 
 	BUILD_BUG_ON(UFS_CRYPTO_KEY_SIZE_INVALID != 0);
-	for (i = 0; i < hba->crypto_capabilities.num_crypto_cap; i++) {
+	for (i = 0; i < priv->crypto_capabilities.num_crypto_cap; i++) {
 		if (ccap_array[i].algorithm_id == alg->ufs_alg &&
 		    ccap_array[i].key_size == alg->ufs_key_size &&
 		    (ccap_array[i].sdus_mask & data_unit_mask)) {
@@ -110,19 +112,22 @@ static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
 				       const struct blk_crypto_key *key,
 				       unsigned int slot)
 {
-	struct ufs_hba *hba =
-		container_of(profile, struct ufs_hba, crypto_profile);
+	struct ufs_hba_priv *priv =
+		container_of(profile, struct ufs_hba_priv, crypto_profile);
+	struct ufs_hba *hba = &priv->hba;
 
 	return ufshcd_clear_keyslot(hba, slot);
 }
 
 bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	if (!(hba->caps & UFSHCD_CAP_CRYPTO))
 		return false;
 
 	/* Reset might clear all keys, so reprogram all the keys. */
-	blk_crypto_reprogram_all_keys(&hba->crypto_profile);
+	blk_crypto_reprogram_all_keys(&priv->crypto_profile);
 	return true;
 }
 
@@ -155,6 +160,7 @@ ufshcd_find_blk_crypto_mode(union ufs_crypto_cap_entry cap)
  */
 int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int cap_idx;
 	int err = 0;
 	enum blk_crypto_mode_num blk_mode_num;
@@ -168,12 +174,12 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 	    !(hba->caps & UFSHCD_CAP_CRYPTO))
 		goto out;
 
-	hba->crypto_capabilities.reg_val =
+	priv->crypto_capabilities.reg_val =
 			cpu_to_le32(ufshcd_readl(hba, REG_UFS_CCAP));
-	hba->crypto_cfg_register =
-		(u32)hba->crypto_capabilities.config_array_ptr * 0x100;
+	priv->crypto_cfg_register =
+		(u32)priv->crypto_capabilities.config_array_ptr * 0x100;
 	hba->crypto_cap_array =
-		devm_kcalloc(hba->dev, hba->crypto_capabilities.num_crypto_cap,
+		devm_kcalloc(hba->dev, priv->crypto_capabilities.num_crypto_cap,
 			     sizeof(hba->crypto_cap_array[0]), GFP_KERNEL);
 	if (!hba->crypto_cap_array) {
 		err = -ENOMEM;
@@ -182,21 +188,21 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 
 	/* The actual number of configurations supported is (CFGC+1) */
 	err = devm_blk_crypto_profile_init(
-			hba->dev, &hba->crypto_profile,
-			hba->crypto_capabilities.config_count + 1);
+			hba->dev, &priv->crypto_profile,
+			priv->crypto_capabilities.config_count + 1);
 	if (err)
 		goto out;
 
-	hba->crypto_profile.ll_ops = ufshcd_crypto_ops;
+	priv->crypto_profile.ll_ops = ufshcd_crypto_ops;
 	/* UFS only supports 8 bytes for any DUN */
-	hba->crypto_profile.max_dun_bytes_supported = 8;
-	hba->crypto_profile.dev = hba->dev;
+	priv->crypto_profile.max_dun_bytes_supported = 8;
+	priv->crypto_profile.dev = hba->dev;
 
 	/*
 	 * Cache all the UFS crypto capabilities and advertise the supported
 	 * crypto modes and data unit sizes to the block layer.
 	 */
-	for (cap_idx = 0; cap_idx < hba->crypto_capabilities.num_crypto_cap;
+	for (cap_idx = 0; cap_idx < priv->crypto_capabilities.num_crypto_cap;
 	     cap_idx++) {
 		hba->crypto_cap_array[cap_idx].reg_val =
 			cpu_to_le32(ufshcd_readl(hba,
@@ -205,7 +211,7 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 		blk_mode_num = ufshcd_find_blk_crypto_mode(
 						hba->crypto_cap_array[cap_idx]);
 		if (blk_mode_num != BLK_ENCRYPTION_MODE_INVALID)
-			hba->crypto_profile.modes_supported[blk_mode_num] |=
+			priv->crypto_profile.modes_supported[blk_mode_num] |=
 				hba->crypto_cap_array[cap_idx].sdus_mask * 512;
 	}
 
@@ -223,18 +229,21 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
  */
 void ufshcd_init_crypto(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int slot;
 
 	if (!(hba->caps & UFSHCD_CAP_CRYPTO))
 		return;
 
 	/* Clear all keyslots - the number of keyslots is (CFGC + 1) */
-	for (slot = 0; slot < hba->crypto_capabilities.config_count + 1; slot++)
+	for (slot = 0; slot < priv->crypto_capabilities.config_count + 1; slot++)
 		ufshcd_clear_keyslot(hba, slot);
 }
 
 void ufshcd_crypto_register(struct ufs_hba *hba, struct request_queue *q)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	if (hba->caps & UFSHCD_CAP_CRYPTO)
-		blk_crypto_register(&hba->crypto_profile, q);
+		blk_crypto_register(&priv->crypto_profile, q);
 }
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index ffb01fc6de75..e49cae32043f 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -6,9 +6,198 @@
 #include <linux/pm_runtime.h>
 #include <ufs/ufshcd.h>
 
-static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
+/**
+ * struct ufs_hba_priv - Host controller data private to the UFS core driver
+ * @hba: HBA information shared between UFS core and UFS drivers.
+ * @ucdl_base_addr: UFS Command Descriptor base address
+ * @utrdl_base_addr: UTP Transfer Request Descriptor base address
+ * @utmrdl_base_addr: UTP Task Management Descriptor base address
+ * @ucdl_dma_addr: UFS Command Descriptor DMA address
+ * @utrdl_dma_addr: UTRDL DMA address
+ * @utmrdl_dma_addr: UTMRDL DMA address
+ * @host: Scsi_Host instance of the driver
+ * @dev: device handle
+ * @ufs_device_wlun: WLUN that controls the entire UFS device.
+ * @hwmon_device: device instance registered with the hwmon core.
+ * @pm_op_in_progress: whether or not a PM operation is in progress.
+ * @lrb: local reference block
+ * @outstanding_tasks: Bits representing outstanding task requests
+ * @outstanding_lock: Protects @outstanding_reqs.
+ * @outstanding_reqs: Bits representing outstanding transfer requests
+ * @reserved_slot: Used to submit device commands. Protected by @dev_cmd.lock.
+ * @dev_ref_clk_freq: reference clock frequency
+ * @tmf_tag_set: TMF tag set.
+ * @tmf_queue: Used to allocate TMF tags.
+ * @tmf_rqs: array with pointers to TMF requests while these are in progress.
+ * @active_uic_cmd: handle of active UIC command
+ * @uic_cmd_mutex: mutex for UIC command
+ * @uic_async_done: completion used during UIC processing
+ * @ufshcd_state: UFSHCD state
+ * @eh_flags: Error handling flags
+ * @intr_mask: Interrupt Mask Bits
+ * @ee_ctrl_mask: Exception event control mask
+ * @ee_drv_mask: Exception event mask for driver
+ * @ee_usr_mask: Exception event mask for user (set via debugfs)
+ * @ee_ctrl_mutex: Used to serialize exception event information.
+ * @is_powered: flag to check if HBA is powered
+ * @shutting_down: flag to check if shutdown has been invoked
+ * @host_sem: semaphore used to serialize concurrent contexts
+ * @eh_wq: Workqueue that eh_work works on
+ * @eh_work: Worker to handle UFS errors that require s/w attention
+ * @eeh_work: Worker to handle exception events
+ * @errors: HBA errors
+ * @uic_error: UFS interconnect layer error status
+ * @saved_err: sticky error mask
+ * @saved_uic_err: sticky UIC error mask
+ * @ufs_stats: various error counters
+ * @force_reset: flag to force eh_work perform a full reset
+ * @force_pmc: flag to force a power mode change
+ * @silence_err_logs: flag to silence error logs
+ * @dev_cmd: ufs device management command information
+ * @last_dme_cmd_tstamp: time stamp of the last completed DME command
+ * @auto_bkops_enabled: to track whether bkops is enabled in device
+ * @clk_gating: information related to clock gating
+ * @devfreq: frequency scaling information owned by the devfreq core
+ * @clk_scaling: frequency scaling information owned by the UFS driver
+ * @is_sys_suspended: whether or not the entire system has been suspended
+ * @urgent_bkops_lvl: keeps track of urgent bkops level for device
+ * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
+ *  device is known or not.
+ * @clk_scaling_lock: used to serialize device commands and clock scaling
+ * @desc_size: descriptor sizes reported by device
+ * @scsi_block_reqs_cnt: reference counting for scsi block requests
+ * @bsg_dev: struct device associated with the BSG queue
+ * @bsg_queue: BSG queue associated with the UFS controller
+ * @rpm_dev_flush_recheck_work: used to suspend from RPM (runtime power
+ *	management) after the UFS device has finished a WriteBooster buffer
+ *	flush or auto BKOP.
+ * @hpb_dev: information related to HPB (Host Performance Booster).
+ * @monitor: statistics about UFS commands
+ * @crypto_capabilities: Content of crypto capabilities register (0x100)
+ * @crypto_cfg_register: Start of the crypto cfg array
+ * @crypto_profile: the crypto profile of this hba (if applicable)
+ * @debugfs_root: UFS controller debugfs root directory
+ * @debugfs_ee_work: used to restore ee_ctrl_mask after a delay
+ * @debugfs_ee_rate_limit_ms: user configurable delay after which to restore
+ *	ee_ctrl_mask
+ * @luns_avail: number of regular and well known LUNs supported by the UFS
+ *	device
+ * @complete_put: whether or not to call ufshcd_rpm_put() from inside
+ *	ufshcd_resume_complete()
+ */
+struct ufs_hba_priv {
+	struct ufs_hba hba;
+
+	/* Virtual memory reference */
+	struct utp_transfer_cmd_desc *ucdl_base_addr;
+	struct utp_transfer_req_desc *utrdl_base_addr;
+	struct utp_task_req_desc *utmrdl_base_addr;
+
+	/* DMA memory reference */
+	dma_addr_t ucdl_dma_addr;
+	dma_addr_t utrdl_dma_addr;
+	dma_addr_t utmrdl_dma_addr;
+
+	struct Scsi_Host *host;
+	struct scsi_device *ufs_device_wlun;
+
+#ifdef CONFIG_SCSI_UFS_HWMON
+	struct device *hwmon_device;
+#endif
+
+	int pm_op_in_progress;
+
+	struct ufshcd_lrb *lrb;
+
+	unsigned long outstanding_tasks;
+	spinlock_t outstanding_lock;
+	unsigned long outstanding_reqs;
+
+	u32 reserved_slot;
+
+	enum ufs_ref_clk_freq dev_ref_clk_freq;
+
+	struct blk_mq_tag_set tmf_tag_set;
+	struct request_queue *tmf_queue;
+	struct request **tmf_rqs;
+
+	struct uic_command *active_uic_cmd;
+	struct mutex uic_cmd_mutex;
+	struct completion *uic_async_done;
+
+	enum ufshcd_state ufshcd_state;
+	u32 eh_flags;
+	u32 intr_mask;
+	u16 ee_ctrl_mask;
+	u16 ee_drv_mask;
+	u16 ee_usr_mask;
+	struct mutex ee_ctrl_mutex;
+	bool is_powered;
+	bool shutting_down;
+	struct semaphore host_sem;
+
+	/* Work Queues */
+	struct workqueue_struct *eh_wq;
+	struct work_struct eh_work;
+	struct work_struct eeh_work;
+
+	/* HBA Errors */
+	u32 errors;
+	u32 uic_error;
+	u32 saved_err;
+	u32 saved_uic_err;
+	struct ufs_stats ufs_stats;
+	bool force_reset;
+	bool force_pmc;
+	bool silence_err_logs;
+
+	/* Device management request data */
+	struct ufs_dev_cmd dev_cmd;
+	ktime_t last_dme_cmd_tstamp;
+
+	bool auto_bkops_enabled;
+
+	struct ufs_clk_gating clk_gating;
+
+	struct devfreq *devfreq;
+	struct ufs_clk_scaling clk_scaling;
+
+	bool is_sys_suspended;
+
+	enum bkops_status urgent_bkops_lvl;
+	bool is_urgent_bkops_lvl_checked;
+
+	struct rw_semaphore clk_scaling_lock;
+	unsigned char desc_size[QUERY_DESC_IDN_MAX];
+	atomic_t scsi_block_reqs_cnt;
+
+	struct device		bsg_dev;
+	struct request_queue	*bsg_queue;
+	struct delayed_work rpm_dev_flush_recheck_work;
+
+#ifdef CONFIG_SCSI_UFS_HPB
+	struct ufshpb_dev_info hpb_dev;
+#endif
+
+	struct ufs_hba_monitor	monitor;
+
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+	union ufs_crypto_capabilities crypto_capabilities;
+	u32 crypto_cfg_register;
+	struct blk_crypto_profile crypto_profile;
+#endif
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs_root;
+	struct delayed_work debugfs_ee_work;
+	u32 debugfs_ee_rate_limit_ms;
+#endif
+	u32 luns_avail;
+	bool complete_put;
+};
+
+static inline bool ufshcd_is_user_access_allowed(struct ufs_hba_priv *priv)
 {
-	return !hba->shutting_down;
+	return !priv->shutting_down;
 }
 
 void ufshcd_schedule_eh_work(struct ufs_hba *hba);
@@ -234,46 +423,56 @@ static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun)
 
 int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask);
 int ufshcd_write_ee_control(struct ufs_hba *hba);
-int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask, u16 *other_mask,
-			     u16 set, u16 clr);
+int ufshcd_update_ee_control(struct ufs_hba_priv *priv, u16 *mask,
+			     u16 *other_mask, u16 set, u16 clr);
 
-static inline int ufshcd_update_ee_drv_mask(struct ufs_hba *hba,
+static inline int ufshcd_update_ee_drv_mask(struct ufs_hba_priv *priv,
 					    u16 set, u16 clr)
 {
-	return ufshcd_update_ee_control(hba, &hba->ee_drv_mask,
-					&hba->ee_usr_mask, set, clr);
+	return ufshcd_update_ee_control(priv, &priv->ee_drv_mask,
+					&priv->ee_usr_mask, set, clr);
 }
 
-static inline int ufshcd_update_ee_usr_mask(struct ufs_hba *hba,
+static inline int ufshcd_update_ee_usr_mask(struct ufs_hba_priv *priv,
 					    u16 set, u16 clr)
 {
-	return ufshcd_update_ee_control(hba, &hba->ee_usr_mask,
-					&hba->ee_drv_mask, set, clr);
+	return ufshcd_update_ee_control(priv, &priv->ee_usr_mask,
+					&priv->ee_drv_mask, set, clr);
 }
 
 static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba)
 {
-	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	return pm_runtime_get_sync(&priv->ufs_device_wlun->sdev_gendev);
 }
 
 static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba)
 {
-	return pm_runtime_put_sync(&hba->ufs_device_wlun->sdev_gendev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	return pm_runtime_put_sync(&priv->ufs_device_wlun->sdev_gendev);
 }
 
 static inline void ufshcd_rpm_get_noresume(struct ufs_hba *hba)
 {
-	pm_runtime_get_noresume(&hba->ufs_device_wlun->sdev_gendev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	pm_runtime_get_noresume(&priv->ufs_device_wlun->sdev_gendev);
 }
 
 static inline int ufshcd_rpm_resume(struct ufs_hba *hba)
 {
-	return pm_runtime_resume(&hba->ufs_device_wlun->sdev_gendev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	return pm_runtime_resume(&priv->ufs_device_wlun->sdev_gendev);
 }
 
 static inline int ufshcd_rpm_put(struct ufs_hba *hba)
 {
-	return pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	return pm_runtime_put(&priv->ufs_device_wlun->sdev_gendev);
 }
 
 /**
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 01fb4bad86be..8c8b72111df6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -303,20 +303,25 @@ static inline void ufshcd_wb_config(struct ufs_hba *hba)
 
 static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
 {
-	if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
-		scsi_unblock_requests(hba->host);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	if (atomic_dec_and_test(&priv->scsi_block_reqs_cnt))
+		scsi_unblock_requests(priv->host);
 }
 
 static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
 {
-	if (atomic_inc_return(&hba->scsi_block_reqs_cnt) == 1)
-		scsi_block_requests(hba->host);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	if (atomic_inc_return(&priv->scsi_block_reqs_cnt) == 1)
+		scsi_block_requests(priv->host);
 }
 
 static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 				      enum ufs_trace_str_t str_t)
 {
-	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct utp_upiu_req *rq = priv->lrb[tag].ucd_req_ptr;
 	struct utp_upiu_header *header;
 
 	if (!trace_ufshcd_upiu_enabled())
@@ -325,7 +330,7 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 	if (str_t == UFS_CMD_SEND)
 		header = &rq->header;
 	else
-		header = &hba->lrb[tag].ucd_rsp_ptr->header;
+		header = &priv->lrb[tag].ucd_rsp_ptr->header;
 
 	trace_ufshcd_upiu(dev_name(hba->dev), str_t, header, &rq->sc.cdb,
 			  UFS_TSF_CDB);
@@ -345,7 +350,8 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 				     enum ufs_trace_str_t str_t)
 {
-	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[tag];
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct utp_task_req_desc *descp = &priv->utmrdl_base_addr[tag];
 
 	if (!trace_ufshcd_upiu_enabled())
 		return;
@@ -388,7 +394,8 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	u64 lba = 0;
 	u8 opcode = 0, group_id = 0;
 	u32 intr, doorbell;
-	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufshcd_lrb *lrbp = &priv->lrb[tag];
 	struct scsi_cmnd *cmd = lrbp->cmd;
 	struct request *rq = scsi_cmd_to_rq(cmd);
 	int transfer_len = -1;
@@ -445,6 +452,7 @@ static void ufshcd_print_clk_freqs(struct ufs_hba *hba)
 static void ufshcd_print_evt(struct ufs_hba *hba, u32 id,
 			     char *err_name)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int i;
 	bool found = false;
 	struct ufs_event_hist *e;
@@ -452,7 +460,7 @@ static void ufshcd_print_evt(struct ufs_hba *hba, u32 id,
 	if (id >= UFS_EVT_CNT)
 		return;
 
-	e = &hba->ufs_stats.event[id];
+	e = &priv->ufs_stats.event[id];
 
 	for (i = 0; i < UFS_EVENT_HIST_LENGTH; i++) {
 		int p = (i + e->pos) % UFS_EVENT_HIST_LENGTH;
@@ -497,12 +505,13 @@ static void ufshcd_print_evt_hist(struct ufs_hba *hba)
 static
 void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufshcd_lrb *lrbp;
 	int prdt_length;
 	int tag;
 
 	for_each_set_bit(tag, &bitmap, hba->nutrs) {
-		lrbp = &hba->lrb[tag];
+		lrbp = &priv->lrb[tag];
 
 		dev_err(hba->dev, "UPIU[%d] - issue time %lld us\n",
 				tag, ktime_to_us(lrbp->issue_time_stamp));
@@ -541,10 +550,11 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 
 static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int tag;
 
 	for_each_set_bit(tag, &bitmap, hba->nutmrs) {
-		struct utp_task_req_desc *tmrdp = &hba->utmrdl_base_addr[tag];
+		struct utp_task_req_desc *tmrdp = &priv->utmrdl_base_addr[tag];
 
 		dev_err(hba->dev, "TM[%d] - Task Management Header\n", tag);
 		ufshcd_hex_dump("", tmrdp, sizeof(*tmrdp));
@@ -553,29 +563,30 @@ static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
 
 static void ufshcd_print_host_state(struct ufs_hba *hba)
 {
-	struct scsi_device *sdev_ufs = hba->ufs_device_wlun;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct scsi_device *sdev_ufs = priv->ufs_device_wlun;
 
-	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
+	dev_err(hba->dev, "UFS Host state=%d\n", priv->ufshcd_state);
 	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
-		hba->outstanding_reqs, hba->outstanding_tasks);
+		priv->outstanding_reqs, priv->outstanding_tasks);
 	dev_err(hba->dev, "saved_err=0x%x, saved_uic_err=0x%x\n",
-		hba->saved_err, hba->saved_uic_err);
+		priv->saved_err, priv->saved_uic_err);
 	dev_err(hba->dev, "Device power mode=%d, UIC link state=%d\n",
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	dev_err(hba->dev, "PM in progress=%d, sys. suspended=%d\n",
-		hba->pm_op_in_progress, hba->is_sys_suspended);
+		priv->pm_op_in_progress, priv->is_sys_suspended);
 	dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
-		hba->auto_bkops_enabled, hba->host->host_self_blocked);
-	dev_err(hba->dev, "Clk gate=%d\n", hba->clk_gating.state);
+		priv->auto_bkops_enabled, priv->host->host_self_blocked);
+	dev_err(hba->dev, "Clk gate=%d\n", priv->clk_gating.state);
 	dev_err(hba->dev,
 		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt=%d\n",
-		ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
-		hba->ufs_stats.hibern8_exit_cnt);
+		ktime_to_us(priv->ufs_stats.last_hibern8_exit_tstamp),
+		priv->ufs_stats.hibern8_exit_cnt);
 	dev_err(hba->dev, "last intr at %lld us, last intr status=0x%x\n",
-		ktime_to_us(hba->ufs_stats.last_intr_ts),
-		hba->ufs_stats.last_intr_status);
+		ktime_to_us(priv->ufs_stats.last_intr_ts),
+		priv->ufs_stats.last_intr_status);
 	dev_err(hba->dev, "error handling flags=0x%x, req. abort count=%d\n",
-		hba->eh_flags, hba->req_abort_count);
+		priv->eh_flags, hba->req_abort_count);
 	dev_err(hba->dev, "hba->ufs_version=0x%x, Host capabilities=0x%x, caps=0x%x\n",
 		hba->ufs_version, hba->capabilities, hba->caps);
 	dev_err(hba->dev, "quirks=0x%x, dev. quirks=0x%x\n", hba->quirks,
@@ -1098,11 +1109,12 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
  */
 static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct scsi_device *sdev;
 	u32 pending = 0;
 
-	lockdep_assert_held(hba->host->host_lock);
-	__shost_for_each_device(sdev, hba->host)
+	lockdep_assert_held(priv->host->host_lock);
+	__shost_for_each_device(sdev, priv->host)
 		pending += sbitmap_weight(&sdev->budget_map);
 
 	return pending;
@@ -1111,6 +1123,7 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 					u64 wait_timeout_us)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long flags;
 	int ret = 0;
 	u32 tm_doorbell;
@@ -1119,14 +1132,14 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 	ktime_t start;
 
 	ufshcd_hold(hba, false);
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	/*
 	 * Wait for all the outstanding tasks/transfer requests.
 	 * Verify by checking the doorbell registers are clear.
 	 */
 	start = ktime_get();
 	do {
-		if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
+		if (priv->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
 			ret = -EBUSY;
 			goto out;
 		}
@@ -1140,7 +1153,7 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			break;
 		}
 
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 		schedule();
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
@@ -1152,7 +1165,7 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			 */
 			do_last_check = true;
 		}
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(priv->host->host_lock, flags);
 	} while (tm_doorbell || tr_pending);
 
 	if (timeout) {
@@ -1162,7 +1175,7 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 		ret = -EBUSY;
 	}
 out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	ufshcd_release(hba);
 	return ret;
 }
@@ -1178,26 +1191,27 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
  */
 static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret = 0;
 	struct ufs_pa_layer_attr new_pwr_info;
 
 	if (scale_up) {
-		memcpy(&new_pwr_info, &hba->clk_scaling.saved_pwr_info.info,
+		memcpy(&new_pwr_info, &priv->clk_scaling.saved_pwr_info.info,
 		       sizeof(struct ufs_pa_layer_attr));
 	} else {
 		memcpy(&new_pwr_info, &hba->pwr_info,
 		       sizeof(struct ufs_pa_layer_attr));
 
-		if (hba->pwr_info.gear_tx > hba->clk_scaling.min_gear ||
-		    hba->pwr_info.gear_rx > hba->clk_scaling.min_gear) {
+		if (hba->pwr_info.gear_tx > priv->clk_scaling.min_gear ||
+		    hba->pwr_info.gear_rx > priv->clk_scaling.min_gear) {
 			/* save the current power mode */
-			memcpy(&hba->clk_scaling.saved_pwr_info.info,
+			memcpy(&priv->clk_scaling.saved_pwr_info.info,
 				&hba->pwr_info,
 				sizeof(struct ufs_pa_layer_attr));
 
 			/* scale down gear */
-			new_pwr_info.gear_tx = hba->clk_scaling.min_gear;
-			new_pwr_info.gear_rx = hba->clk_scaling.min_gear;
+			new_pwr_info.gear_tx = priv->clk_scaling.min_gear;
+			new_pwr_info.gear_rx = priv->clk_scaling.min_gear;
 		}
 	}
 
@@ -1215,18 +1229,19 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 {
 	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret = 0;
 	/*
 	 * make sure that there are no outstanding requests when
 	 * clock scaling is in progress
 	 */
 	ufshcd_scsi_block_requests(hba);
-	down_write(&hba->clk_scaling_lock);
+	down_write(&priv->clk_scaling_lock);
 
-	if (!hba->clk_scaling.is_allowed ||
+	if (!priv->clk_scaling.is_allowed ||
 	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
 		ret = -EBUSY;
-		up_write(&hba->clk_scaling_lock);
+		up_write(&priv->clk_scaling_lock);
 		ufshcd_scsi_unblock_requests(hba);
 		goto out;
 	}
@@ -1240,10 +1255,12 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	if (writelock)
-		up_write(&hba->clk_scaling_lock);
+		up_write(&priv->clk_scaling_lock);
 	else
-		up_read(&hba->clk_scaling_lock);
+		up_read(&priv->clk_scaling_lock);
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 }
@@ -1259,6 +1276,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
  */
 static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret = 0;
 	bool is_writelock = true;
 
@@ -1290,7 +1308,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	}
 
 	/* Enable Write Booster if we have scaled up else disable it */
-	downgrade_write(&hba->clk_scaling_lock);
+	downgrade_write(&priv->clk_scaling_lock);
 	is_writelock = false;
 	ufshcd_wb_toggle(hba, scale_up);
 
@@ -1301,36 +1319,37 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 
 static void ufshcd_clk_scaling_suspend_work(struct work_struct *work)
 {
-	struct ufs_hba *hba = container_of(work, struct ufs_hba,
+	struct ufs_hba_priv *priv = container_of(work, struct ufs_hba_priv,
 					   clk_scaling.suspend_work);
+	struct ufs_hba *hba = &priv->hba;
 	unsigned long irq_flags;
 
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
-	if (hba->clk_scaling.active_reqs || hba->clk_scaling.is_suspended) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+	spin_lock_irqsave(priv->host->host_lock, irq_flags);
+	if (priv->clk_scaling.active_reqs || priv->clk_scaling.is_suspended) {
+		spin_unlock_irqrestore(priv->host->host_lock, irq_flags);
 		return;
 	}
-	hba->clk_scaling.is_suspended = true;
-	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+	priv->clk_scaling.is_suspended = true;
+	spin_unlock_irqrestore(priv->host->host_lock, irq_flags);
 
 	__ufshcd_suspend_clkscaling(hba);
 }
 
 static void ufshcd_clk_scaling_resume_work(struct work_struct *work)
 {
-	struct ufs_hba *hba = container_of(work, struct ufs_hba,
+	struct ufs_hba_priv *priv = container_of(work, struct ufs_hba_priv,
 					   clk_scaling.resume_work);
 	unsigned long irq_flags;
 
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
-	if (!hba->clk_scaling.is_suspended) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+	spin_lock_irqsave(priv->host->host_lock, irq_flags);
+	if (!priv->clk_scaling.is_suspended) {
+		spin_unlock_irqrestore(priv->host->host_lock, irq_flags);
 		return;
 	}
-	hba->clk_scaling.is_suspended = false;
-	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+	priv->clk_scaling.is_suspended = false;
+	spin_unlock_irqrestore(priv->host->host_lock, irq_flags);
 
-	devfreq_resume_device(hba->devfreq);
+	devfreq_resume_device(priv->devfreq);
 }
 
 static int ufshcd_devfreq_target(struct device *dev,
@@ -1338,6 +1357,7 @@ static int ufshcd_devfreq_target(struct device *dev,
 {
 	int ret = 0;
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	ktime_t start;
 	bool scale_up, sched_clk_scaling_suspend_work = false;
 	struct list_head *clk_list = &hba->clk_list_head;
@@ -1350,17 +1370,17 @@ static int ufshcd_devfreq_target(struct device *dev,
 	clki = list_first_entry(&hba->clk_list_head, struct ufs_clk_info, list);
 	/* Override with the closest supported frequency */
 	*freq = (unsigned long) clk_round_rate(clki->clk, *freq);
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
-	if (ufshcd_eh_in_progress(hba)) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+	spin_lock_irqsave(priv->host->host_lock, irq_flags);
+	if (ufshcd_eh_in_progress(priv)) {
+		spin_unlock_irqrestore(priv->host->host_lock, irq_flags);
 		return 0;
 	}
 
-	if (!hba->clk_scaling.active_reqs)
+	if (!priv->clk_scaling.active_reqs)
 		sched_clk_scaling_suspend_work = true;
 
 	if (list_empty(clk_list)) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		spin_unlock_irqrestore(priv->host->host_lock, irq_flags);
 		goto out;
 	}
 
@@ -1370,11 +1390,11 @@ static int ufshcd_devfreq_target(struct device *dev,
 		*freq = clki->min_freq;
 	/* Update the frequency */
 	if (!ufshcd_is_devfreq_scaling_required(hba, scale_up)) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		spin_unlock_irqrestore(priv->host->host_lock, irq_flags);
 		ret = 0;
 		goto out; /* no state change required */
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+	spin_unlock_irqrestore(priv->host->host_lock, irq_flags);
 
 	start = ktime_get();
 	ret = ufshcd_devfreq_scale(hba, scale_up);
@@ -1385,8 +1405,8 @@ static int ufshcd_devfreq_target(struct device *dev,
 
 out:
 	if (sched_clk_scaling_suspend_work)
-		queue_work(hba->clk_scaling.workq,
-			   &hba->clk_scaling.suspend_work);
+		queue_work(priv->clk_scaling.workq,
+			   &priv->clk_scaling.suspend_work);
 
 	return ret;
 }
@@ -1395,7 +1415,8 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 		struct devfreq_dev_status *stat)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
-	struct ufs_clk_scaling *scaling = &hba->clk_scaling;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufs_clk_scaling *scaling = &priv->clk_scaling;
 	unsigned long flags;
 	struct list_head *clk_list = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
@@ -1406,7 +1427,7 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 
 	memset(stat, 0, sizeof(*stat));
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	curr_t = ktime_get();
 	if (!scaling->window_start_t)
 		goto start_window;
@@ -1428,19 +1449,20 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 	scaling->window_start_t = curr_t;
 	scaling->tot_busy_t = 0;
 
-	if (hba->outstanding_reqs) {
+	if (priv->outstanding_reqs) {
 		scaling->busy_start_t = curr_t;
 		scaling->is_busy_started = true;
 	} else {
 		scaling->busy_start_t = 0;
 		scaling->is_busy_started = false;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	return 0;
 }
 
 static int ufshcd_devfreq_init(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct list_head *clk_list = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
 	struct devfreq *devfreq;
@@ -1469,21 +1491,22 @@ static int ufshcd_devfreq_init(struct ufs_hba *hba)
 		return ret;
 	}
 
-	hba->devfreq = devfreq;
+	priv->devfreq = devfreq;
 
 	return 0;
 }
 
 static void ufshcd_devfreq_remove(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct list_head *clk_list = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
 
-	if (!hba->devfreq)
+	if (!priv->devfreq)
 		return;
 
-	devfreq_remove_device(hba->devfreq);
-	hba->devfreq = NULL;
+	devfreq_remove_device(priv->devfreq);
+	priv->devfreq = NULL;
 
 	clki = list_first_entry(clk_list, struct ufs_clk_info, list);
 	dev_pm_opp_remove(hba->dev, clki->min_freq);
@@ -1492,28 +1515,30 @@ static void ufshcd_devfreq_remove(struct ufs_hba *hba)
 
 static void __ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long flags;
 
-	devfreq_suspend_device(hba->devfreq);
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->clk_scaling.window_start_t = 0;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	devfreq_suspend_device(priv->devfreq);
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	priv->clk_scaling.window_start_t = 0;
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 }
 
 static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long flags;
 	bool suspend = false;
 
-	cancel_work_sync(&hba->clk_scaling.suspend_work);
-	cancel_work_sync(&hba->clk_scaling.resume_work);
+	cancel_work_sync(&priv->clk_scaling.suspend_work);
+	cancel_work_sync(&priv->clk_scaling.resume_work);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (!hba->clk_scaling.is_suspended) {
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	if (!priv->clk_scaling.is_suspended) {
 		suspend = true;
-		hba->clk_scaling.is_suspended = true;
+		priv->clk_scaling.is_suspended = true;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	if (suspend)
 		__ufshcd_suspend_clkscaling(hba);
@@ -1521,52 +1546,55 @@ static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long flags;
 	bool resume = false;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->clk_scaling.is_suspended) {
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	if (priv->clk_scaling.is_suspended) {
 		resume = true;
-		hba->clk_scaling.is_suspended = false;
+		priv->clk_scaling.is_suspended = false;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	if (resume)
-		devfreq_resume_device(hba->devfreq);
+		devfreq_resume_device(priv->devfreq);
 }
 
 static ssize_t ufshcd_clkscale_enable_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	return sysfs_emit(buf, "%d\n", hba->clk_scaling.is_enabled);
+	return sysfs_emit(buf, "%d\n", priv->clk_scaling.is_enabled);
 }
 
 static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	u32 value;
 	int err = 0;
 
 	if (kstrtou32(buf, 0, &value))
 		return -EINVAL;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
+	down(&priv->host_sem);
+	if (!ufshcd_is_user_access_allowed(priv)) {
 		err = -EBUSY;
 		goto out;
 	}
 
 	value = !!value;
-	if (value == hba->clk_scaling.is_enabled)
+	if (value == priv->clk_scaling.is_enabled)
 		goto out;
 
 	ufshcd_rpm_get_sync(hba);
 	ufshcd_hold(hba, false);
 
-	hba->clk_scaling.is_enabled = value;
+	priv->clk_scaling.is_enabled = value;
 
 	if (value) {
 		ufshcd_resume_clkscaling(hba);
@@ -1581,76 +1609,84 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 	ufshcd_release(hba);
 	ufshcd_rpm_put_sync(hba);
 out:
-	up(&hba->host_sem);
+	up(&priv->host_sem);
 	return err ? err : count;
 }
 
 static void ufshcd_init_clk_scaling_sysfs(struct ufs_hba *hba)
 {
-	hba->clk_scaling.enable_attr.show = ufshcd_clkscale_enable_show;
-	hba->clk_scaling.enable_attr.store = ufshcd_clkscale_enable_store;
-	sysfs_attr_init(&hba->clk_scaling.enable_attr.attr);
-	hba->clk_scaling.enable_attr.attr.name = "clkscale_enable";
-	hba->clk_scaling.enable_attr.attr.mode = 0644;
-	if (device_create_file(hba->dev, &hba->clk_scaling.enable_attr))
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	priv->clk_scaling.enable_attr.show = ufshcd_clkscale_enable_show;
+	priv->clk_scaling.enable_attr.store = ufshcd_clkscale_enable_store;
+	sysfs_attr_init(&priv->clk_scaling.enable_attr.attr);
+	priv->clk_scaling.enable_attr.attr.name = "clkscale_enable";
+	priv->clk_scaling.enable_attr.attr.mode = 0644;
+	if (device_create_file(hba->dev, &priv->clk_scaling.enable_attr))
 		dev_err(hba->dev, "Failed to create sysfs for clkscale_enable\n");
 }
 
 static void ufshcd_remove_clk_scaling_sysfs(struct ufs_hba *hba)
 {
-	if (hba->clk_scaling.enable_attr.attr.name)
-		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	if (priv->clk_scaling.enable_attr.attr.name)
+		device_remove_file(hba->dev, &priv->clk_scaling.enable_attr);
 }
 
 static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	char wq_name[sizeof("ufs_clkscaling_00")];
 
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
-	if (!hba->clk_scaling.min_gear)
-		hba->clk_scaling.min_gear = UFS_HS_G1;
+	if (!priv->clk_scaling.min_gear)
+		priv->clk_scaling.min_gear = UFS_HS_G1;
 
-	INIT_WORK(&hba->clk_scaling.suspend_work,
+	INIT_WORK(&priv->clk_scaling.suspend_work,
 		  ufshcd_clk_scaling_suspend_work);
-	INIT_WORK(&hba->clk_scaling.resume_work,
+	INIT_WORK(&priv->clk_scaling.resume_work,
 		  ufshcd_clk_scaling_resume_work);
 
 	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
-		 hba->host->host_no);
-	hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
+		 priv->host->host_no);
+	priv->clk_scaling.workq = create_singlethread_workqueue(wq_name);
 
-	hba->clk_scaling.is_initialized = true;
+	priv->clk_scaling.is_initialized = true;
 }
 
 static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
 {
-	if (!hba->clk_scaling.is_initialized)
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	if (!priv->clk_scaling.is_initialized)
 		return;
 
 	ufshcd_remove_clk_scaling_sysfs(hba);
-	destroy_workqueue(hba->clk_scaling.workq);
+	destroy_workqueue(priv->clk_scaling.workq);
 	ufshcd_devfreq_remove(hba);
-	hba->clk_scaling.is_initialized = false;
+	priv->clk_scaling.is_initialized = false;
 }
 
 static void ufshcd_ungate_work(struct work_struct *work)
 {
 	int ret;
 	unsigned long flags;
-	struct ufs_hba *hba = container_of(work, struct ufs_hba,
+	struct ufs_hba_priv *priv = container_of(work, struct ufs_hba_priv,
 			clk_gating.ungate_work);
+	struct ufs_hba *hba = &priv->hba;
 
-	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
+	cancel_delayed_work_sync(&priv->clk_gating.gate_work);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->clk_gating.state == CLKS_ON) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	if (priv->clk_gating.state == CLKS_ON) {
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 		goto unblock_reqs;
 	}
 
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	ufshcd_hba_vreg_set_hpm(hba);
 	ufshcd_setup_clocks(hba, true);
 
@@ -1659,7 +1695,7 @@ static void ufshcd_ungate_work(struct work_struct *work)
 	/* Exit from hibern8 */
 	if (ufshcd_can_hibern8_during_gating(hba)) {
 		/* Prevent gating in this path */
-		hba->clk_gating.is_suspended = true;
+		priv->clk_gating.is_suspended = true;
 		if (ufshcd_is_link_hibern8(hba)) {
 			ret = ufshcd_uic_hibern8_exit(hba);
 			if (ret)
@@ -1668,7 +1704,7 @@ static void ufshcd_ungate_work(struct work_struct *work)
 			else
 				ufshcd_set_link_active(hba);
 		}
-		hba->clk_gating.is_suspended = false;
+		priv->clk_gating.is_suspended = false;
 	}
 unblock_reqs:
 	ufshcd_scsi_unblock_requests(hba);
@@ -1682,18 +1718,19 @@ static void ufshcd_ungate_work(struct work_struct *work)
  */
 int ufshcd_hold(struct ufs_hba *hba, bool async)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int rc = 0;
 	bool flush_result;
 	unsigned long flags;
 
 	if (!ufshcd_is_clkgating_allowed(hba) ||
-	    !hba->clk_gating.is_initialized)
+	    !priv->clk_gating.is_initialized)
 		goto out;
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->clk_gating.active_reqs++;
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	priv->clk_gating.active_reqs++;
 
 start:
-	switch (hba->clk_gating.state) {
+	switch (priv->clk_gating.state) {
 	case CLKS_ON:
 		/*
 		 * Wait for the ungate work to complete if in progress.
@@ -1707,22 +1744,22 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		    ufshcd_is_link_hibern8(hba)) {
 			if (async) {
 				rc = -EAGAIN;
-				hba->clk_gating.active_reqs--;
+				priv->clk_gating.active_reqs--;
 				break;
 			}
-			spin_unlock_irqrestore(hba->host->host_lock, flags);
-			flush_result = flush_work(&hba->clk_gating.ungate_work);
-			if (hba->clk_gating.is_suspended && !flush_result)
+			spin_unlock_irqrestore(priv->host->host_lock, flags);
+			flush_result = flush_work(&priv->clk_gating.ungate_work);
+			if (priv->clk_gating.is_suspended && !flush_result)
 				goto out;
-			spin_lock_irqsave(hba->host->host_lock, flags);
+			spin_lock_irqsave(priv->host->host_lock, flags);
 			goto start;
 		}
 		break;
 	case REQ_CLKS_OFF:
-		if (cancel_delayed_work(&hba->clk_gating.gate_work)) {
-			hba->clk_gating.state = CLKS_ON;
+		if (cancel_delayed_work(&priv->clk_gating.gate_work)) {
+			priv->clk_gating.state = CLKS_ON;
 			trace_ufshcd_clk_gating(dev_name(hba->dev),
-						hba->clk_gating.state);
+						priv->clk_gating.state);
 			break;
 		}
 		/*
@@ -1732,11 +1769,11 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 */
 		fallthrough;
 	case CLKS_OFF:
-		hba->clk_gating.state = REQ_CLKS_ON;
+		priv->clk_gating.state = REQ_CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
-					hba->clk_gating.state);
-		if (queue_work(hba->clk_gating.clk_gating_workq,
-			       &hba->clk_gating.ungate_work))
+					priv->clk_gating.state);
+		if (queue_work(priv->clk_gating.clk_gating_workq,
+			       &priv->clk_gating.ungate_work))
 			ufshcd_scsi_block_requests(hba);
 		/*
 		 * fall through to check if we should wait for this
@@ -1746,21 +1783,21 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 	case REQ_CLKS_ON:
 		if (async) {
 			rc = -EAGAIN;
-			hba->clk_gating.active_reqs--;
+			priv->clk_gating.active_reqs--;
 			break;
 		}
 
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		flush_work(&hba->clk_gating.ungate_work);
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
+		flush_work(&priv->clk_gating.ungate_work);
 		/* Make sure state is CLKS_ON before returning */
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(priv->host->host_lock, flags);
 		goto start;
 	default:
 		dev_err(hba->dev, "%s: clk gating is in invalid state %d\n",
-				__func__, hba->clk_gating.state);
+				__func__, priv->clk_gating.state);
 		break;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 out:
 	return rc;
 }
@@ -1768,43 +1805,44 @@ EXPORT_SYMBOL_GPL(ufshcd_hold);
 
 static void ufshcd_gate_work(struct work_struct *work)
 {
-	struct ufs_hba *hba = container_of(work, struct ufs_hba,
+	struct ufs_hba_priv *priv = container_of(work, struct ufs_hba_priv,
 			clk_gating.gate_work.work);
+	struct ufs_hba *hba = &priv->hba;
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	/*
 	 * In case you are here to cancel this work the gating state
 	 * would be marked as REQ_CLKS_ON. In this case save time by
 	 * skipping the gating work and exit after changing the clock
 	 * state to CLKS_ON.
 	 */
-	if (hba->clk_gating.is_suspended ||
-		(hba->clk_gating.state != REQ_CLKS_OFF)) {
-		hba->clk_gating.state = CLKS_ON;
+	if (priv->clk_gating.is_suspended ||
+		(priv->clk_gating.state != REQ_CLKS_OFF)) {
+		priv->clk_gating.state = CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
-					hba->clk_gating.state);
+					priv->clk_gating.state);
 		goto rel_lock;
 	}
 
-	if (hba->clk_gating.active_reqs
-		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
-		|| hba->outstanding_reqs || hba->outstanding_tasks
-		|| hba->active_uic_cmd || hba->uic_async_done)
+	if (priv->clk_gating.active_reqs
+		|| priv->ufshcd_state != UFSHCD_STATE_OPERATIONAL
+		|| priv->outstanding_reqs || priv->outstanding_tasks
+		|| priv->active_uic_cmd || priv->uic_async_done)
 		goto rel_lock;
 
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	/* put the link into hibern8 mode before turning off clocks */
 	if (ufshcd_can_hibern8_during_gating(hba)) {
 		ret = ufshcd_uic_hibern8_enter(hba);
 		if (ret) {
-			hba->clk_gating.state = CLKS_ON;
+			priv->clk_gating.state = CLKS_ON;
 			dev_err(hba->dev, "%s: hibern8 enter failed %d\n",
 					__func__, ret);
 			trace_ufshcd_clk_gating(dev_name(hba->dev),
-						hba->clk_gating.state);
+						priv->clk_gating.state);
 			goto out;
 		}
 		ufshcd_set_link_hibern8(hba);
@@ -1825,14 +1863,14 @@ static void ufshcd_gate_work(struct work_struct *work)
 	 * prevent from doing cancel work multiple times when there are
 	 * new requests arriving before the current cancel work is done.
 	 */
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->clk_gating.state == REQ_CLKS_OFF) {
-		hba->clk_gating.state = CLKS_OFF;
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	if (priv->clk_gating.state == REQ_CLKS_OFF) {
+		priv->clk_gating.state = CLKS_OFF;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
-					hba->clk_gating.state);
+					priv->clk_gating.state);
 	}
 rel_lock:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 out:
 	return;
 }
@@ -1840,32 +1878,35 @@ static void ufshcd_gate_work(struct work_struct *work)
 /* host lock must be held before calling this variant */
 static void __ufshcd_release(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
 
-	hba->clk_gating.active_reqs--;
+	priv->clk_gating.active_reqs--;
 
-	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
-	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
-	    hba->outstanding_tasks || !hba->clk_gating.is_initialized ||
-	    hba->active_uic_cmd || hba->uic_async_done ||
-	    hba->clk_gating.state == CLKS_OFF)
+	if (priv->clk_gating.active_reqs || priv->clk_gating.is_suspended ||
+	    priv->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
+	    priv->outstanding_tasks || !priv->clk_gating.is_initialized ||
+	    priv->active_uic_cmd || priv->uic_async_done ||
+	    priv->clk_gating.state == CLKS_OFF)
 		return;
 
-	hba->clk_gating.state = REQ_CLKS_OFF;
-	trace_ufshcd_clk_gating(dev_name(hba->dev), hba->clk_gating.state);
-	queue_delayed_work(hba->clk_gating.clk_gating_workq,
-			   &hba->clk_gating.gate_work,
-			   msecs_to_jiffies(hba->clk_gating.delay_ms));
+	priv->clk_gating.state = REQ_CLKS_OFF;
+	trace_ufshcd_clk_gating(dev_name(hba->dev), priv->clk_gating.state);
+	queue_delayed_work(priv->clk_gating.clk_gating_workq,
+			   &priv->clk_gating.gate_work,
+			   msecs_to_jiffies(priv->clk_gating.delay_ms));
 }
 
 void ufshcd_release(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	__ufshcd_release(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 }
 EXPORT_SYMBOL_GPL(ufshcd_release);
 
@@ -1873,18 +1914,20 @@ static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	return sysfs_emit(buf, "%lu\n", hba->clk_gating.delay_ms);
+	return sysfs_emit(buf, "%lu\n", priv->clk_gating.delay_ms);
 }
 
 void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->clk_gating.delay_ms = value;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	priv->clk_gating.delay_ms = value;
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 }
 EXPORT_SYMBOL_GPL(ufshcd_clkgate_delay_set);
 
@@ -1904,14 +1947,16 @@ static ssize_t ufshcd_clkgate_enable_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	return sysfs_emit(buf, "%d\n", hba->clk_gating.is_enabled);
+	return sysfs_emit(buf, "%d\n", priv->clk_gating.is_enabled);
 }
 
 static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long flags;
 	u32 value;
 
@@ -1920,90 +1965,98 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 
 	value = !!value;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (value == hba->clk_gating.is_enabled)
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	if (value == priv->clk_gating.is_enabled)
 		goto out;
 
 	if (value)
 		__ufshcd_release(hba);
 	else
-		hba->clk_gating.active_reqs++;
+		priv->clk_gating.active_reqs++;
 
-	hba->clk_gating.is_enabled = value;
+	priv->clk_gating.is_enabled = value;
 out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	return count;
 }
 
 static void ufshcd_init_clk_gating_sysfs(struct ufs_hba *hba)
 {
-	hba->clk_gating.delay_attr.show = ufshcd_clkgate_delay_show;
-	hba->clk_gating.delay_attr.store = ufshcd_clkgate_delay_store;
-	sysfs_attr_init(&hba->clk_gating.delay_attr.attr);
-	hba->clk_gating.delay_attr.attr.name = "clkgate_delay_ms";
-	hba->clk_gating.delay_attr.attr.mode = 0644;
-	if (device_create_file(hba->dev, &hba->clk_gating.delay_attr))
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	priv->clk_gating.delay_attr.show = ufshcd_clkgate_delay_show;
+	priv->clk_gating.delay_attr.store = ufshcd_clkgate_delay_store;
+	sysfs_attr_init(&priv->clk_gating.delay_attr.attr);
+	priv->clk_gating.delay_attr.attr.name = "clkgate_delay_ms";
+	priv->clk_gating.delay_attr.attr.mode = 0644;
+	if (device_create_file(hba->dev, &priv->clk_gating.delay_attr))
 		dev_err(hba->dev, "Failed to create sysfs for clkgate_delay\n");
 
-	hba->clk_gating.enable_attr.show = ufshcd_clkgate_enable_show;
-	hba->clk_gating.enable_attr.store = ufshcd_clkgate_enable_store;
-	sysfs_attr_init(&hba->clk_gating.enable_attr.attr);
-	hba->clk_gating.enable_attr.attr.name = "clkgate_enable";
-	hba->clk_gating.enable_attr.attr.mode = 0644;
-	if (device_create_file(hba->dev, &hba->clk_gating.enable_attr))
+	priv->clk_gating.enable_attr.show = ufshcd_clkgate_enable_show;
+	priv->clk_gating.enable_attr.store = ufshcd_clkgate_enable_store;
+	sysfs_attr_init(&priv->clk_gating.enable_attr.attr);
+	priv->clk_gating.enable_attr.attr.name = "clkgate_enable";
+	priv->clk_gating.enable_attr.attr.mode = 0644;
+	if (device_create_file(hba->dev, &priv->clk_gating.enable_attr))
 		dev_err(hba->dev, "Failed to create sysfs for clkgate_enable\n");
 }
 
 static void ufshcd_remove_clk_gating_sysfs(struct ufs_hba *hba)
 {
-	if (hba->clk_gating.delay_attr.attr.name)
-		device_remove_file(hba->dev, &hba->clk_gating.delay_attr);
-	if (hba->clk_gating.enable_attr.attr.name)
-		device_remove_file(hba->dev, &hba->clk_gating.enable_attr);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	if (priv->clk_gating.delay_attr.attr.name)
+		device_remove_file(hba->dev, &priv->clk_gating.delay_attr);
+	if (priv->clk_gating.enable_attr.attr.name)
+		device_remove_file(hba->dev, &priv->clk_gating.enable_attr);
 }
 
 static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	char wq_name[sizeof("ufs_clk_gating_00")];
 
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
 
-	hba->clk_gating.state = CLKS_ON;
+	priv->clk_gating.state = CLKS_ON;
 
-	hba->clk_gating.delay_ms = 150;
-	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
-	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
+	priv->clk_gating.delay_ms = 150;
+	INIT_DELAYED_WORK(&priv->clk_gating.gate_work, ufshcd_gate_work);
+	INIT_WORK(&priv->clk_gating.ungate_work, ufshcd_ungate_work);
 
 	snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clk_gating_%d",
-		 hba->host->host_no);
-	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(wq_name,
+		 priv->host->host_no);
+	priv->clk_gating.clk_gating_workq = alloc_ordered_workqueue(wq_name,
 					WQ_MEM_RECLAIM | WQ_HIGHPRI);
 
 	ufshcd_init_clk_gating_sysfs(hba);
 
-	hba->clk_gating.is_enabled = true;
-	hba->clk_gating.is_initialized = true;
+	priv->clk_gating.is_enabled = true;
+	priv->clk_gating.is_initialized = true;
 }
 
 static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 {
-	if (!hba->clk_gating.is_initialized)
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	if (!priv->clk_gating.is_initialized)
 		return;
 
 	ufshcd_remove_clk_gating_sysfs(hba);
 
 	/* Ungate the clock if necessary. */
 	ufshcd_hold(hba, false);
-	hba->clk_gating.is_initialized = false;
+	priv->clk_gating.is_initialized = false;
 	ufshcd_release(hba);
 
-	destroy_workqueue(hba->clk_gating.clk_gating_workq);
+	destroy_workqueue(priv->clk_gating.clk_gating_workq);
 }
 
 /* Must be called with host lock acquired */
 static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	bool queue_resume_work = false;
 	ktime_t curr_t = ktime_get();
 	unsigned long flags;
@@ -2011,49 +2064,50 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (!hba->clk_scaling.active_reqs++)
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	if (!priv->clk_scaling.active_reqs++)
 		queue_resume_work = true;
 
-	if (!hba->clk_scaling.is_enabled || hba->pm_op_in_progress) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (!priv->clk_scaling.is_enabled || priv->pm_op_in_progress) {
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 		return;
 	}
 
 	if (queue_resume_work)
-		queue_work(hba->clk_scaling.workq,
-			   &hba->clk_scaling.resume_work);
+		queue_work(priv->clk_scaling.workq,
+			   &priv->clk_scaling.resume_work);
 
-	if (!hba->clk_scaling.window_start_t) {
-		hba->clk_scaling.window_start_t = curr_t;
-		hba->clk_scaling.tot_busy_t = 0;
-		hba->clk_scaling.is_busy_started = false;
+	if (!priv->clk_scaling.window_start_t) {
+		priv->clk_scaling.window_start_t = curr_t;
+		priv->clk_scaling.tot_busy_t = 0;
+		priv->clk_scaling.is_busy_started = false;
 	}
 
-	if (!hba->clk_scaling.is_busy_started) {
-		hba->clk_scaling.busy_start_t = curr_t;
-		hba->clk_scaling.is_busy_started = true;
+	if (!priv->clk_scaling.is_busy_started) {
+		priv->clk_scaling.busy_start_t = curr_t;
+		priv->clk_scaling.is_busy_started = true;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 }
 
 static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
 {
-	struct ufs_clk_scaling *scaling = &hba->clk_scaling;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufs_clk_scaling *scaling = &priv->clk_scaling;
 	unsigned long flags;
 
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->clk_scaling.active_reqs--;
-	if (!hba->outstanding_reqs && scaling->is_busy_started) {
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	priv->clk_scaling.active_reqs--;
+	if (!priv->outstanding_reqs && scaling->is_busy_started) {
 		scaling->tot_busy_t += ktime_to_us(ktime_sub(ktime_get(),
 					scaling->busy_start_t));
 		scaling->busy_start_t = 0;
 		scaling->is_busy_started = false;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 }
 
 static inline int ufshcd_monitor_opcode2dir(u8 opcode)
@@ -2069,33 +2123,36 @@ static inline int ufshcd_monitor_opcode2dir(u8 opcode)
 static inline bool ufshcd_should_inform_monitor(struct ufs_hba *hba,
 						struct ufshcd_lrb *lrbp)
 {
-	struct ufs_hba_monitor *m = &hba->monitor;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufs_hba_monitor *m = &priv->monitor;
 
 	return (m->enabled && lrbp && lrbp->cmd &&
 		(!m->chunk_size || m->chunk_size == lrbp->cmd->sdb.length) &&
-		ktime_before(hba->monitor.enabled_ts, lrbp->issue_time_stamp));
+		ktime_before(m->enabled_ts, lrbp->issue_time_stamp));
 }
 
 static void ufshcd_start_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (dir >= 0 && hba->monitor.nr_queued[dir]++ == 0)
-		hba->monitor.busy_start_ts[dir] = ktime_get();
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	if (dir >= 0 && priv->monitor.nr_queued[dir]++ == 0)
+		priv->monitor.busy_start_ts[dir] = ktime_get();
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 }
 
 static void ufshcd_update_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	if (dir >= 0 && priv->monitor.nr_queued[dir] > 0) {
 		struct request *req = scsi_cmd_to_rq(lrbp->cmd);
-		struct ufs_hba_monitor *m = &hba->monitor;
+		struct ufs_hba_monitor *m = &priv->monitor;
 		ktime_t now, inc, lat;
 
 		now = lrbp->compl_time_stamp;
@@ -2116,7 +2173,7 @@ static void ufshcd_update_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		/* Push forward the busy start of monitor */
 		m->busy_start_ts[dir] = now;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 }
 
 /**
@@ -2127,7 +2184,8 @@ static void ufshcd_update_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 static inline
 void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
-	struct ufshcd_lrb *lrbp = &hba->lrb[task_tag];
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufshcd_lrb *lrbp = &priv->lrb[task_tag];
 	unsigned long flags;
 
 	lrbp->issue_time_stamp = ktime_get();
@@ -2137,12 +2195,12 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
 
-	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	spin_lock_irqsave(&priv->outstanding_lock, flags);
 	if (hba->vops && hba->vops->setup_xfer_req)
 		hba->vops->setup_xfer_req(hba, task_tag, !!lrbp->cmd);
-	__set_bit(task_tag, &hba->outstanding_reqs);
+	__set_bit(task_tag, &priv->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+	spin_unlock_irqrestore(&priv->outstanding_lock, flags);
 }
 
 /**
@@ -2175,12 +2233,13 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 static
 int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
-	struct ufs_query_res *query_res = &hba->dev_cmd.query.response;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufs_query_res *query_res = &priv->dev_cmd.query.response;
 
 	memcpy(&query_res->upiu_res, &lrbp->ucd_rsp_ptr->qr, QUERY_OSF_SIZE);
 
 	/* Get the descriptor */
-	if (hba->dev_cmd.query.descriptor &&
+	if (priv->dev_cmd.query.descriptor &&
 	    lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
 		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr +
 				GENERAL_UPIU_REQUEST_SIZE;
@@ -2191,9 +2250,9 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		resp_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) &
 						MASK_QUERY_DATA_SEG_LEN;
 		buf_len = be16_to_cpu(
-				hba->dev_cmd.query.request.upiu_req.length);
+				priv->dev_cmd.query.request.upiu_req.length);
 		if (likely(buf_len >= resp_len)) {
-			memcpy(hba->dev_cmd.query.descriptor, descp, resp_len);
+			memcpy(priv->dev_cmd.query.descriptor, descp, resp_len);
 		} else {
 			dev_warn(hba->dev,
 				 "%s: rsp size %d is bigger than buffer size %d",
@@ -2213,6 +2272,7 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
  */
 static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err;
 
 	hba->capabilities = ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
@@ -2221,7 +2281,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
 	hba->nutmrs =
 	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
-	hba->reserved_slot = hba->nutrs - 1;
+	priv->reserved_slot = hba->nutrs - 1;
 
 	/* Read crypto capabilities */
 	err = ufshcd_hba_init_crypto_capabilities(hba);
@@ -2262,11 +2322,13 @@ static inline u8 ufshcd_get_upmcrs(struct ufs_hba *hba)
 static inline void
 ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
-	lockdep_assert_held(&hba->uic_cmd_mutex);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	WARN_ON(hba->active_uic_cmd);
+	lockdep_assert_held(&priv->uic_cmd_mutex);
 
-	hba->active_uic_cmd = uic_cmd;
+	WARN_ON(priv->active_uic_cmd);
+
+	priv->active_uic_cmd = uic_cmd;
 
 	/* Write Args */
 	ufshcd_writel(hba, uic_cmd->argument1, REG_UIC_COMMAND_ARG_1);
@@ -2290,10 +2352,11 @@ ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 static int
 ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret;
 	unsigned long flags;
 
-	lockdep_assert_held(&hba->uic_cmd_mutex);
+	lockdep_assert_held(&priv->uic_cmd_mutex);
 
 	if (wait_for_completion_timeout(&uic_cmd->done,
 					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
@@ -2311,9 +2374,9 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 		}
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->active_uic_cmd = NULL;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	priv->active_uic_cmd = NULL;
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	return ret;
 }
@@ -2330,8 +2393,10 @@ static int
 __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
 		      bool completion)
 {
-	lockdep_assert_held(&hba->uic_cmd_mutex);
-	lockdep_assert_held(hba->host->host_lock);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	lockdep_assert_held(&priv->uic_cmd_mutex);
+	lockdep_assert_held(priv->host->host_lock);
 
 	if (!ufshcd_ready_for_uic_cmd(hba)) {
 		dev_err(hba->dev,
@@ -2357,6 +2422,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
  */
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret;
 	unsigned long flags;
 
@@ -2364,16 +2430,16 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 		return 0;
 
 	ufshcd_hold(hba, false);
-	mutex_lock(&hba->uic_cmd_mutex);
+	mutex_lock(&priv->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	ret = __ufshcd_send_uic_cmd(hba, uic_cmd, true);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	if (!ret)
 		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
 
-	mutex_unlock(&hba->uic_cmd_mutex);
+	mutex_unlock(&priv->uic_cmd_mutex);
 
 	ufshcd_release(hba);
 	return ret;
@@ -2569,7 +2635,8 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 				struct ufshcd_lrb *lrbp, u8 upiu_flags)
 {
 	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
-	struct ufs_query *query = &hba->dev_cmd.query;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufs_query *query = &priv->dev_cmd.query;
 	u16 len = be16_to_cpu(query->request.upiu_req.length);
 
 	/* Query request header */
@@ -2623,6 +2690,7 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
 				      struct ufshcd_lrb *lrbp)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	u8 upiu_flags;
 	int ret = 0;
 
@@ -2632,9 +2700,9 @@ static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
 		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
 
 	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
-	if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
+	if (priv->dev_cmd.type == DEV_CMD_TYPE_QUERY)
 		ufshcd_prepare_utp_query_req_upiu(hba, lrbp, upiu_flags);
-	else if (hba->dev_cmd.type == DEV_CMD_TYPE_NOP)
+	else if (priv->dev_cmd.type == DEV_CMD_TYPE_NOP)
 		ufshcd_prepare_utp_nop_upiu(lrbp);
 	else
 		ret = -EINVAL;
@@ -2718,16 +2786,17 @@ static int ufshcd_map_queues(struct Scsi_Host *shost)
 
 static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 {
-	struct utp_transfer_cmd_desc *cmd_descp = hba->ucdl_base_addr;
-	struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
-	dma_addr_t cmd_desc_element_addr = hba->ucdl_dma_addr +
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct utp_transfer_cmd_desc *cmd_descp = priv->ucdl_base_addr;
+	struct utp_transfer_req_desc *utrdlp = priv->utrdl_base_addr;
+	dma_addr_t cmd_desc_element_addr = priv->ucdl_dma_addr +
 		i * sizeof(struct utp_transfer_cmd_desc);
 	u16 response_offset = offsetof(struct utp_transfer_cmd_desc,
 				       response_upiu);
 	u16 prdt_offset = offsetof(struct utp_transfer_cmd_desc, prd_table);
 
 	lrb->utr_descriptor_ptr = utrdlp + i;
-	lrb->utrd_dma_addr = hba->utrdl_dma_addr +
+	lrb->utrd_dma_addr = priv->utrdl_dma_addr +
 		i * sizeof(struct utp_transfer_req_desc);
 	lrb->ucd_req_ptr = (struct utp_upiu_req *)(cmd_descp + i);
 	lrb->ucd_req_dma_addr = cmd_desc_element_addr;
@@ -2747,6 +2816,7 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
 	struct ufs_hba *hba = shost_priv(host);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int tag = scsi_cmd_to_rq(cmd)->tag;
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
@@ -2759,7 +2829,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	 */
 	rcu_read_lock();
 
-	switch (hba->ufshcd_state) {
+	switch (priv->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
 		break;
 	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
@@ -2770,7 +2840,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		 * UFSHCD_STATE_EH_SCHEDULED_NON_FATAL. Prevent requests
 		 * being issued in that case.
 		 */
-		if (ufshcd_eh_in_progress(hba)) {
+		if (ufshcd_eh_in_progress(priv)) {
 			err = SCSI_MLQUEUE_HOST_BUSY;
 			goto out;
 		}
@@ -2786,8 +2856,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		 * err handler blocked for too long. So, just fail the scsi cmd
 		 * sent from PM ops, err handler can recover PM error anyways.
 		 */
-		if (hba->pm_op_in_progress) {
-			hba->force_reset = true;
+		if (priv->pm_op_in_progress) {
+			priv->force_reset = true;
 			set_host_byte(cmd, DID_BAD_TARGET);
 			scsi_done(cmd);
 			goto out;
@@ -2810,9 +2880,9 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto out;
 	}
 	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
-		(hba->clk_gating.state != CLKS_ON));
+		(priv->clk_gating.state != CLKS_ON));
 
-	lrbp = &hba->lrb[tag];
+	lrbp = &priv->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
 	lrbp->task_tag = tag;
@@ -2842,9 +2912,9 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (ufs_trigger_eh()) {
 		unsigned long flags;
 
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(priv->host->host_lock, flags);
 		ufshcd_schedule_eh_work(hba);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 	}
 
 	return err;
@@ -2853,12 +2923,14 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, enum dev_cmd_type cmd_type, int tag)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	lrbp->cmd = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
 	ufshcd_prepare_lrbp_crypto(NULL, lrbp);
-	hba->dev_cmd.type = cmd_type;
+	priv->dev_cmd.type = cmd_type;
 
 	return ufshcd_compose_devman_upiu(hba, lrbp);
 }
@@ -2866,14 +2938,15 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 static int
 ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err = 0;
 	unsigned long flags;
 	u32 mask = 1 << tag;
 
 	/* clear outstanding transaction before retry */
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	ufshcd_utrl_clear(hba, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	/*
 	 * wait for h/w to clear corresponding bit in door-bell.
@@ -2889,7 +2962,8 @@ ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
 static int
 ufshcd_check_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
-	struct ufs_query_res *query_res = &hba->dev_cmd.query.response;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufs_query_res *query_res = &priv->dev_cmd.query.response;
 
 	/* Get the UPIU response */
 	query_res->response = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr) >>
@@ -2905,15 +2979,16 @@ ufshcd_check_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 static int
 ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int resp;
 	int err = 0;
 
-	hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
+	priv->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
 	resp = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
 
 	switch (resp) {
 	case UPIU_TRANSACTION_NOP_IN:
-		if (hba->dev_cmd.type != DEV_CMD_TYPE_NOP) {
+		if (priv->dev_cmd.type != DEV_CMD_TYPE_NOP) {
 			err = -EINVAL;
 			dev_err(hba->dev, "%s: unexpected response %x\n",
 					__func__, resp);
@@ -2943,21 +3018,22 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, int max_timeout)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err = 0;
 	unsigned long time_left;
 	unsigned long flags;
 
-	time_left = wait_for_completion_timeout(hba->dev_cmd.complete,
+	time_left = wait_for_completion_timeout(priv->dev_cmd.complete,
 			msecs_to_jiffies(max_timeout));
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->dev_cmd.complete = NULL;
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	priv->dev_cmd.complete = NULL;
 	if (likely(time_left)) {
 		err = ufshcd_get_tr_ocs(lrbp);
 		if (!err)
 			err = ufshcd_dev_cmd_completion(hba, lrbp);
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	if (!time_left) {
 		err = -ETIMEDOUT;
@@ -2971,9 +3047,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		 * we also need to clear the outstanding_request
 		 * field in hba
 		 */
-		spin_lock_irqsave(&hba->outstanding_lock, flags);
-		__clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
-		spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+		spin_lock_irqsave(&priv->outstanding_lock, flags);
+		__clear_bit(lrbp->task_tag, &priv->outstanding_reqs);
+		spin_unlock_irqrestore(&priv->outstanding_lock, flags);
 	}
 
 	return err;
@@ -2986,28 +3062,29 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
  * @timeout: timeout in milliseconds
  *
  * NOTE: Since there is only one available tag for device management commands,
- * it is expected you hold the hba->dev_cmd.lock mutex.
+ * the caller must hold the priv->dev_cmd.lock mutex.
  */
 static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		enum dev_cmd_type cmd_type, int timeout)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	DECLARE_COMPLETION_ONSTACK(wait);
-	const u32 tag = hba->reserved_slot;
+	const u32 tag = priv->reserved_slot;
 	struct ufshcd_lrb *lrbp;
 	int err;
 
-	/* Protects use of hba->reserved_slot. */
-	lockdep_assert_held(&hba->dev_cmd.lock);
+	/* Protects use of priv->reserved_slot. */
+	lockdep_assert_held(&priv->dev_cmd.lock);
 
-	down_read(&hba->clk_scaling_lock);
+	down_read(&priv->clk_scaling_lock);
 
-	lrbp = &hba->lrb[tag];
+	lrbp = &priv->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
 	if (unlikely(err))
 		goto out;
 
-	hba->dev_cmd.complete = &wait;
+	priv->dev_cmd.complete = &wait;
 
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
 
@@ -3017,7 +3094,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
 out:
-	up_read(&hba->clk_scaling_lock);
+	up_read(&priv->clk_scaling_lock);
 	return err;
 }
 
@@ -3035,8 +3112,10 @@ static inline void ufshcd_init_query(struct ufs_hba *hba,
 		struct ufs_query_req **request, struct ufs_query_res **response,
 		enum query_opcode opcode, u8 idn, u8 index, u8 selector)
 {
-	*request = &hba->dev_cmd.query.request;
-	*response = &hba->dev_cmd.query.response;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	*request = &priv->dev_cmd.query.request;
+	*response = &priv->dev_cmd.query.response;
 	memset(*request, 0, sizeof(struct ufs_query_req));
 	memset(*response, 0, sizeof(struct ufs_query_res));
 	(*request)->upiu_req.opcode = opcode;
@@ -3081,6 +3160,7 @@ static int ufshcd_query_flag_retry(struct ufs_hba *hba,
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 			enum flag_idn idn, u8 index, bool *flag_res)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufs_query_req *request = NULL;
 	struct ufs_query_res *response = NULL;
 	int err, selector = 0;
@@ -3089,7 +3169,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	BUG_ON(!hba);
 
 	ufshcd_hold(hba, false);
-	mutex_lock(&hba->dev_cmd.lock);
+	mutex_lock(&priv->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
 
@@ -3131,7 +3211,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 				MASK_QUERY_UPIU_FLAG_LOC) & 0x1;
 
 out_unlock:
-	mutex_unlock(&hba->dev_cmd.lock);
+	mutex_unlock(&priv->dev_cmd.lock);
 	ufshcd_release(hba);
 	return err;
 }
@@ -3150,6 +3230,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufs_query_req *request = NULL;
 	struct ufs_query_res *response = NULL;
 	int err;
@@ -3164,7 +3245,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 
 	ufshcd_hold(hba, false);
 
-	mutex_lock(&hba->dev_cmd.lock);
+	mutex_lock(&priv->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
 
@@ -3194,7 +3275,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 	*attr_val = be32_to_cpu(response->upiu_res.value);
 
 out_unlock:
-	mutex_unlock(&hba->dev_cmd.lock);
+	mutex_unlock(&priv->dev_cmd.lock);
 	ufshcd_release(hba);
 	return err;
 }
@@ -3240,6 +3321,7 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 			enum query_opcode opcode, enum desc_idn idn, u8 index,
 			u8 selector, u8 *desc_buf, int *buf_len)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufs_query_req *request = NULL;
 	struct ufs_query_res *response = NULL;
 	int err;
@@ -3260,10 +3342,10 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 
 	ufshcd_hold(hba, false);
 
-	mutex_lock(&hba->dev_cmd.lock);
+	mutex_lock(&priv->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
-	hba->dev_cmd.query.descriptor = desc_buf;
+	priv->dev_cmd.query.descriptor = desc_buf;
 	request->upiu_req.length = cpu_to_be16(*buf_len);
 
 	switch (opcode) {
@@ -3292,8 +3374,8 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 	*buf_len = be16_to_cpu(response->upiu_res.length);
 
 out_unlock:
-	hba->dev_cmd.query.descriptor = NULL;
-	mutex_unlock(&hba->dev_cmd.lock);
+	priv->dev_cmd.query.descriptor = NULL;
+	mutex_unlock(&priv->dev_cmd.lock);
 	ufshcd_release(hba);
 	return err;
 }
@@ -3340,11 +3422,13 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 				  int *desc_len)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	if (desc_id >= QUERY_DESC_IDN_MAX || desc_id == QUERY_DESC_IDN_RFU_0 ||
 	    desc_id == QUERY_DESC_IDN_RFU_1)
 		*desc_len = 0;
 	else
-		*desc_len = hba->desc_size[desc_id];
+		*desc_len = priv->desc_size[desc_id];
 }
 EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
 
@@ -3352,14 +3436,16 @@ static void ufshcd_update_desc_length(struct ufs_hba *hba,
 				      enum desc_idn desc_id, int desc_index,
 				      unsigned char desc_len)
 {
-	if (hba->desc_size[desc_id] == QUERY_DESC_MAX_SIZE &&
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	if (priv->desc_size[desc_id] == QUERY_DESC_MAX_SIZE &&
 	    desc_id != QUERY_DESC_IDN_STRING && desc_index != UFS_RPMB_UNIT)
 		/* For UFS 3.1, the normal unit descriptor is 10 bytes larger
 		 * than the RPMB unit, however, both descriptors share the same
 		 * desc_idn, to cover both unit descriptors with one length, we
 		 * choose the normal unit descriptor length by desc_index.
 		 */
-		hba->desc_size[desc_id] = desc_len;
+		priv->desc_size[desc_id] = desc_len;
 }
 
 /**
@@ -3618,23 +3704,22 @@ static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
  */
 static int ufshcd_memory_alloc(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	size_t utmrdl_size, utrdl_size, ucdl_size;
 
 	/* Allocate memory for UTP command descriptors */
 	ucdl_size = (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
-	hba->ucdl_base_addr = dmam_alloc_coherent(hba->dev,
-						  ucdl_size,
-						  &hba->ucdl_dma_addr,
-						  GFP_KERNEL);
+	priv->ucdl_base_addr = dmam_alloc_coherent(hba->dev, ucdl_size,
+					&priv->ucdl_dma_addr, GFP_KERNEL);
 
 	/*
 	 * UFSHCI requires UTP command descriptor to be 128 byte aligned.
-	 * make sure hba->ucdl_dma_addr is aligned to PAGE_SIZE
-	 * if hba->ucdl_dma_addr is aligned to PAGE_SIZE, then it will
+	 * make sure priv->ucdl_dma_addr is aligned to PAGE_SIZE
+	 * if priv->ucdl_dma_addr is aligned to PAGE_SIZE, then it will
 	 * be aligned to 128 bytes as well
 	 */
-	if (!hba->ucdl_base_addr ||
-	    WARN_ON(hba->ucdl_dma_addr & (PAGE_SIZE - 1))) {
+	if (!priv->ucdl_base_addr ||
+	    WARN_ON(priv->ucdl_dma_addr & (PAGE_SIZE - 1))) {
 		dev_err(hba->dev,
 			"Command Descriptor Memory allocation failed\n");
 		goto out;
@@ -3645,12 +3730,10 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 * UFSHCI requires 1024 byte alignment of UTRD
 	 */
 	utrdl_size = (sizeof(struct utp_transfer_req_desc) * hba->nutrs);
-	hba->utrdl_base_addr = dmam_alloc_coherent(hba->dev,
-						   utrdl_size,
-						   &hba->utrdl_dma_addr,
-						   GFP_KERNEL);
-	if (!hba->utrdl_base_addr ||
-	    WARN_ON(hba->utrdl_dma_addr & (PAGE_SIZE - 1))) {
+	priv->utrdl_base_addr = dmam_alloc_coherent(hba->dev, utrdl_size,
+					&priv->utrdl_dma_addr, GFP_KERNEL);
+	if (!priv->utrdl_base_addr ||
+	    WARN_ON(priv->utrdl_dma_addr & (PAGE_SIZE - 1))) {
 		dev_err(hba->dev,
 			"Transfer Descriptor Memory allocation failed\n");
 		goto out;
@@ -3661,22 +3744,19 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 * UFSHCI requires 1024 byte alignment of UTMRD
 	 */
 	utmrdl_size = sizeof(struct utp_task_req_desc) * hba->nutmrs;
-	hba->utmrdl_base_addr = dmam_alloc_coherent(hba->dev,
-						    utmrdl_size,
-						    &hba->utmrdl_dma_addr,
-						    GFP_KERNEL);
-	if (!hba->utmrdl_base_addr ||
-	    WARN_ON(hba->utmrdl_dma_addr & (PAGE_SIZE - 1))) {
+	priv->utmrdl_base_addr = dmam_alloc_coherent(hba->dev, utmrdl_size,
+					&priv->utmrdl_dma_addr, GFP_KERNEL);
+	if (!priv->utmrdl_base_addr ||
+	    WARN_ON(priv->utmrdl_dma_addr & (PAGE_SIZE - 1))) {
 		dev_err(hba->dev,
 		"Task Management Descriptor Memory allocation failed\n");
 		goto out;
 	}
 
 	/* Allocate memory for local reference block */
-	hba->lrb = devm_kcalloc(hba->dev,
-				hba->nutrs, sizeof(struct ufshcd_lrb),
-				GFP_KERNEL);
-	if (!hba->lrb) {
+	priv->lrb = devm_kcalloc(hba->dev, hba->nutrs,
+				 sizeof(struct ufshcd_lrb), GFP_KERNEL);
+	if (!priv->lrb) {
 		dev_err(hba->dev, "LRB Memory allocation failed\n");
 		goto out;
 	}
@@ -3700,6 +3780,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
  */
 static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct utp_transfer_req_desc *utrdlp;
 	dma_addr_t cmd_desc_dma_addr;
 	dma_addr_t cmd_desc_element_addr;
@@ -3708,7 +3789,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 	int cmd_desc_size;
 	int i;
 
-	utrdlp = hba->utrdl_base_addr;
+	utrdlp = priv->utrdl_base_addr;
 
 	response_offset =
 		offsetof(struct utp_transfer_cmd_desc, response_upiu);
@@ -3716,7 +3797,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 		offsetof(struct utp_transfer_cmd_desc, prd_table);
 
 	cmd_desc_size = sizeof(struct utp_transfer_cmd_desc);
-	cmd_desc_dma_addr = hba->ucdl_dma_addr;
+	cmd_desc_dma_addr = priv->ucdl_dma_addr;
 
 	for (i = 0; i < hba->nutrs; i++) {
 		/* Configure UTRD with command descriptor base address */
@@ -3744,7 +3825,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 		}
 
-		ufshcd_init_lrb(hba, &hba->lrb[i], i);
+		ufshcd_init_lrb(hba, &priv->lrb[i], i);
 	}
 }
 
@@ -3837,6 +3918,7 @@ static int ufshcd_dme_enable(struct ufs_hba *hba)
 
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	#define MIN_DELAY_BEFORE_DME_CMDS_US	1000
 	unsigned long min_sleep_time_us;
 
@@ -3847,13 +3929,13 @@ static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
 	 * last_dme_cmd_tstamp will be 0 only for 1st call to
 	 * this function
 	 */
-	if (unlikely(!ktime_to_us(hba->last_dme_cmd_tstamp))) {
+	if (unlikely(!ktime_to_us(priv->last_dme_cmd_tstamp))) {
 		min_sleep_time_us = MIN_DELAY_BEFORE_DME_CMDS_US;
 	} else {
 		unsigned long delta =
 			(unsigned long) ktime_to_us(
 				ktime_sub(ktime_get(),
-				hba->last_dme_cmd_tstamp));
+				priv->last_dme_cmd_tstamp));
 
 		if (delta < MIN_DELAY_BEFORE_DME_CMDS_US)
 			min_sleep_time_us =
@@ -4003,21 +4085,22 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
  */
 static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	DECLARE_COMPLETION_ONSTACK(uic_async_done);
 	unsigned long flags;
 	u8 status;
 	int ret;
 	bool reenable_intr = false;
 
-	mutex_lock(&hba->uic_cmd_mutex);
+	mutex_lock(&priv->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	if (ufshcd_is_link_broken(hba)) {
 		ret = -ENOLINK;
 		goto out_unlock;
 	}
-	hba->uic_async_done = &uic_async_done;
+	priv->uic_async_done = &uic_async_done;
 	if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
 		ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
 		/*
@@ -4028,7 +4111,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		reenable_intr = true;
 	}
 	ret = __ufshcd_send_uic_cmd(hba, cmd, false);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	if (ret) {
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
@@ -4036,7 +4119,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		goto out;
 	}
 
-	if (!wait_for_completion_timeout(hba->uic_async_done,
+	if (!wait_for_completion_timeout(priv->uic_async_done,
 					 msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
@@ -4067,9 +4150,9 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		ufshcd_print_evt_hist(hba);
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->active_uic_cmd = NULL;
-	hba->uic_async_done = NULL;
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	priv->active_uic_cmd = NULL;
+	priv->uic_async_done = NULL;
 	if (reenable_intr)
 		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
 	if (ret) {
@@ -4077,8 +4160,8 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		ufshcd_schedule_eh_work(hba);
 	}
 out_unlock:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	mutex_unlock(&hba->uic_cmd_mutex);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
+	mutex_unlock(&priv->uic_cmd_mutex);
 
 	return ret;
 }
@@ -4119,24 +4202,25 @@ static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 
 int ufshcd_link_recovery(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret;
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->ufshcd_state = UFSHCD_STATE_RESET;
-	ufshcd_set_eh_in_progress(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	priv->ufshcd_state = UFSHCD_STATE_RESET;
+	ufshcd_set_eh_in_progress(priv);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	/* Reset the attached device */
 	ufshcd_device_reset(hba);
 
 	ret = ufshcd_host_reset_and_restore(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	if (ret)
-		hba->ufshcd_state = UFSHCD_STATE_ERROR;
-	ufshcd_clear_eh_in_progress(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+		priv->ufshcd_state = UFSHCD_STATE_ERROR;
+	ufshcd_clear_eh_in_progress(priv);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	if (ret)
 		dev_err(hba->dev, "%s: link recovery failed, err %d",
@@ -4172,6 +4256,7 @@ EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_enter);
 
 int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct uic_command uic_cmd = {0};
 	int ret;
 	ktime_t start = ktime_get();
@@ -4189,8 +4274,8 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	} else {
 		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT,
 								POST_CHANGE);
-		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_get();
-		hba->ufs_stats.hibern8_exit_cnt++;
+		priv->ufs_stats.last_hibern8_exit_tstamp = ktime_get();
+		priv->ufs_stats.hibern8_exit_cnt++;
 	}
 
 	return ret;
@@ -4199,21 +4284,22 @@ EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
 
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long flags;
 	bool update = false;
 
 	if (!ufshcd_is_auto_hibern8_supported(hba))
 		return;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	if (hba->ahit != ahit) {
 		hba->ahit = ahit;
 		update = true;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	if (update &&
-	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
+	    !pm_runtime_suspended(&priv->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba, false);
 		ufshcd_auto_hibern8_enable(hba);
@@ -4313,10 +4399,11 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret;
 
 	/* if already configured to the requested pwr_mode */
-	if (!hba->force_pmc &&
+	if (!priv->force_pmc &&
 	    pwr_mode->gear_rx == hba->pwr_info.gear_rx &&
 	    pwr_mode->gear_tx == hba->pwr_info.gear_tx &&
 	    pwr_mode->lane_rx == hba->pwr_info.lane_rx &&
@@ -4480,6 +4567,7 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
  */
 int ufshcd_make_hba_operational(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err = 0;
 	u32 reg;
 
@@ -4493,13 +4581,13 @@ int ufshcd_make_hba_operational(struct ufs_hba *hba)
 		ufshcd_disable_intr_aggr(hba);
 
 	/* Configure UTRL and UTMRL base address registers */
-	ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
+	ufshcd_writel(hba, lower_32_bits(priv->utrdl_dma_addr),
 			REG_UTP_TRANSFER_REQ_LIST_BASE_L);
-	ufshcd_writel(hba, upper_32_bits(hba->utrdl_dma_addr),
+	ufshcd_writel(hba, upper_32_bits(priv->utrdl_dma_addr),
 			REG_UTP_TRANSFER_REQ_LIST_BASE_H);
-	ufshcd_writel(hba, lower_32_bits(hba->utmrdl_dma_addr),
+	ufshcd_writel(hba, lower_32_bits(priv->utmrdl_dma_addr),
 			REG_UTP_TASK_REQ_LIST_BASE_L);
-	ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
+	ufshcd_writel(hba, upper_32_bits(priv->utmrdl_dma_addr),
 			REG_UTP_TASK_REQ_LIST_BASE_H);
 
 	/*
@@ -4530,6 +4618,7 @@ EXPORT_SYMBOL_GPL(ufshcd_make_hba_operational);
  */
 void ufshcd_hba_stop(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long flags;
 	int err;
 
@@ -4537,9 +4626,9 @@ void ufshcd_hba_stop(struct ufs_hba *hba)
 	 * Obtain the host lock to prevent that the controller is disabled
 	 * while the UFS interrupt handler is active on another CPU.
 	 */
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	err = ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE,
 					CONTROLLER_ENABLE, CONTROLLER_DISABLE,
@@ -4679,12 +4768,13 @@ static inline int ufshcd_disable_device_tx_lcc(struct ufs_hba *hba)
 
 void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufs_event_hist *e;
 
 	if (id >= UFS_EVT_CNT)
 		return;
 
-	e = &hba->ufs_stats.event[id];
+	e = &priv->ufs_stats.event[id];
 	e->val[e->pos] = val;
 	e->tstamp[e->pos] = ktime_get();
 	e->cnt += 1;
@@ -4796,11 +4886,12 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
  */
 static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err = 0;
 	int retries;
 
 	ufshcd_hold(hba, false);
-	mutex_lock(&hba->dev_cmd.lock);
+	mutex_lock(&priv->dev_cmd.lock);
 	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
 		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
 					  hba->nop_out_timeout);
@@ -4810,7 +4901,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 
 		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
 	}
-	mutex_unlock(&hba->dev_cmd.lock);
+	mutex_unlock(&priv->dev_cmd.lock);
 	ufshcd_release(hba);
 
 	if (err)
@@ -4919,24 +5010,25 @@ static inline void ufshcd_get_lu_power_on_wp_status(struct ufs_hba *hba,
  */
 static void ufshcd_setup_links(struct ufs_hba *hba, struct scsi_device *sdev)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct device_link *link;
 
 	/*
 	 * Device wlun is the supplier & rest of the luns are consumers.
 	 * This ensures that device wlun suspends after all other luns.
 	 */
-	if (hba->ufs_device_wlun) {
+	if (priv->ufs_device_wlun) {
 		link = device_link_add(&sdev->sdev_gendev,
-				       &hba->ufs_device_wlun->sdev_gendev,
+				       &priv->ufs_device_wlun->sdev_gendev,
 				       DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE);
 		if (!link) {
 			dev_err(&sdev->sdev_gendev, "Failed establishing link - %s\n",
-				dev_name(&hba->ufs_device_wlun->sdev_gendev));
+				dev_name(&priv->ufs_device_wlun->sdev_gendev));
 			return;
 		}
-		hba->luns_avail--;
+		priv->luns_avail--;
 		/* Ignore REPORT_LUN wlun probing */
-		if (hba->luns_avail == 1) {
+		if (priv->luns_avail == 1) {
 			ufshcd_rpm_put(hba);
 			return;
 		}
@@ -4945,7 +5037,7 @@ static void ufshcd_setup_links(struct ufs_hba *hba, struct scsi_device *sdev)
 		 * Device wlun is probed. The assumption is that WLUNs are
 		 * scanned before other LUNs.
 		 */
-		hba->luns_avail--;
+		priv->luns_avail--;
 	}
 }
 
@@ -5057,28 +5149,27 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
  */
 static void ufshcd_slave_destroy(struct scsi_device *sdev)
 {
-	struct ufs_hba *hba;
+	struct ufs_hba *hba = shost_priv(sdev->host);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long flags;
 
-	hba = shost_priv(sdev->host);
-
 	ufshcd_hpb_destroy(hba, sdev);
 
 	/* Drop the reference as it won't be needed anymore */
 	if (ufshcd_scsi_to_upiu_lun(sdev->lun) == UFS_UPIU_UFS_DEVICE_WLUN) {
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		hba->ufs_device_wlun = NULL;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-	} else if (hba->ufs_device_wlun) {
+		spin_lock_irqsave(priv->host->host_lock, flags);
+		priv->ufs_device_wlun = NULL;
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
+	} else if (priv->ufs_device_wlun) {
 		struct device *supplier = NULL;
 
 		/* Ensure UFS Device WLUN exists and does not disappear */
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		if (hba->ufs_device_wlun) {
-			supplier = &hba->ufs_device_wlun->sdev_gendev;
+		spin_lock_irqsave(priv->host->host_lock, flags);
+		if (priv->ufs_device_wlun) {
+			supplier = &priv->ufs_device_wlun->sdev_gendev;
 			get_device(supplier);
 		}
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 		if (supplier) {
 			/*
@@ -5135,6 +5226,7 @@ ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
 static inline int
 ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int result = 0;
 	int scsi_status;
 	enum utp_ocs ocs;
@@ -5151,7 +5243,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	switch (ocs) {
 	case OCS_SUCCESS:
 		result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
-		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
+		priv->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
 		switch (result) {
 		case UPIU_TRANSACTION_RESPONSE:
 			/*
@@ -5179,11 +5271,11 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			 * solution could be to abort the system suspend if
 			 * UFS device needs urgent BKOPs.
 			 */
-			if (!hba->pm_op_in_progress &&
-			    !ufshcd_eh_in_progress(hba) &&
+			if (!priv->pm_op_in_progress &&
+			    !ufshcd_eh_in_progress(priv) &&
 			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr))
 				/* Flushed in suspend */
-				schedule_work(&hba->eeh_work);
+				schedule_work(&priv->eeh_work);
 
 			if (scsi_status == SAM_STAT_GOOD)
 				ufshpb_rsp_upiu(hba, lrbp);
@@ -5228,7 +5320,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	} /* end of switch */
 
 	if ((host_byte(result) != DID_OK) &&
-	    (host_byte(result) != DID_REQUEUE) && !hba->silence_err_logs)
+	    (host_byte(result) != DID_REQUEUE) && !priv->silence_err_logs)
 		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
 	return result;
 }
@@ -5236,6 +5328,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 static bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba,
 					 u32 intr_mask)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	if (!ufshcd_is_auto_hibern8_supported(hba) ||
 	    !ufshcd_is_auto_hibern8_enabled(hba))
 		return false;
@@ -5243,9 +5337,9 @@ static bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba,
 	if (!(intr_mask & UFSHCD_UIC_HIBERN8_MASK))
 		return false;
 
-	if (hba->active_uic_cmd &&
-	    (hba->active_uic_cmd->command == UIC_CMD_DME_HIBER_ENTER ||
-	    hba->active_uic_cmd->command == UIC_CMD_DME_HIBER_EXIT))
+	if (priv->active_uic_cmd &&
+	    (priv->active_uic_cmd->command == UIC_CMD_DME_HIBER_ENTER ||
+	    priv->active_uic_cmd->command == UIC_CMD_DME_HIBER_EXIT))
 		return false;
 
 	return true;
@@ -5262,33 +5356,34 @@ static bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba,
  */
 static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	irqreturn_t retval = IRQ_NONE;
 
-	spin_lock(hba->host->host_lock);
+	spin_lock(priv->host->host_lock);
 	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
-		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
+		priv->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
 
-	if ((intr_status & UIC_COMMAND_COMPL) && hba->active_uic_cmd) {
-		hba->active_uic_cmd->argument2 |=
+	if ((intr_status & UIC_COMMAND_COMPL) && priv->active_uic_cmd) {
+		priv->active_uic_cmd->argument2 |=
 			ufshcd_get_uic_cmd_result(hba);
-		hba->active_uic_cmd->argument3 =
+		priv->active_uic_cmd->argument3 =
 			ufshcd_get_dme_attr_val(hba);
-		if (!hba->uic_async_done)
-			hba->active_uic_cmd->cmd_active = 0;
-		complete(&hba->active_uic_cmd->done);
+		if (!priv->uic_async_done)
+			priv->active_uic_cmd->cmd_active = 0;
+		complete(&priv->active_uic_cmd->done);
 		retval = IRQ_HANDLED;
 	}
 
-	if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
-		hba->active_uic_cmd->cmd_active = 0;
-		complete(hba->uic_async_done);
+	if ((intr_status & UFSHCD_UIC_PWR_MASK) && priv->uic_async_done) {
+		priv->active_uic_cmd->cmd_active = 0;
+		complete(priv->uic_async_done);
 		retval = IRQ_HANDLED;
 	}
 
 	if (retval == IRQ_HANDLED)
-		ufshcd_add_uic_command_trace(hba, hba->active_uic_cmd,
+		ufshcd_add_uic_command_trace(hba, priv->active_uic_cmd,
 					     UFS_CMD_COMP);
-	spin_unlock(hba->host->host_lock);
+	spin_unlock(priv->host->host_lock);
 	return retval;
 }
 
@@ -5312,12 +5407,13 @@ static void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
 static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 					unsigned long completed_reqs)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
 	int index;
 
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
-		lrbp = &hba->lrb[index];
+		lrbp = &priv->lrb[index];
 		lrbp->compl_time_stamp = ktime_get();
 		cmd = lrbp->cmd;
 		if (cmd) {
@@ -5330,10 +5426,10 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			scsi_done(cmd);
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
 			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
-			if (hba->dev_cmd.complete) {
+			if (priv->dev_cmd.complete) {
 				ufshcd_add_command_trace(hba, index,
 							 UFS_DEV_COMP);
-				complete(hba->dev_cmd.complete);
+				complete(priv->dev_cmd.complete);
 				ufshcd_clk_scaling_update_busy(hba);
 			}
 		}
@@ -5347,17 +5443,18 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 {
 	struct ufs_hba *hba = shost_priv(shost);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long completed_reqs, flags;
 	u32 tr_doorbell;
 
-	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	spin_lock_irqsave(&priv->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
+	completed_reqs = ~tr_doorbell & priv->outstanding_reqs;
+	WARN_ONCE(completed_reqs & ~priv->outstanding_reqs,
 		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
-		  hba->outstanding_reqs);
-	hba->outstanding_reqs &= ~completed_reqs;
-	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+		  priv->outstanding_reqs);
+	priv->outstanding_reqs &= ~completed_reqs;
+	spin_unlock_irqrestore(&priv->outstanding_lock, flags);
 
 	if (completed_reqs)
 		__ufshcd_transfer_req_compl(hba, completed_reqs);
@@ -5375,6 +5472,8 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
  */
 static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
 	 * In order to prevent other interrupts starvation the DB is read once
@@ -5393,7 +5492,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * Ignore the ufshcd_poll() return value and return IRQ_HANDLED since we
 	 * do not want polling to trigger spurious interrupt complaints.
 	 */
-	ufshcd_poll(hba->host, 0);
+	ufshcd_poll(priv->host, 0);
 
 	return IRQ_HANDLED;
 }
@@ -5407,40 +5506,42 @@ int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask)
 
 int ufshcd_write_ee_control(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err;
 
-	mutex_lock(&hba->ee_ctrl_mutex);
-	err = __ufshcd_write_ee_control(hba, hba->ee_ctrl_mask);
-	mutex_unlock(&hba->ee_ctrl_mutex);
+	mutex_lock(&priv->ee_ctrl_mutex);
+	err = __ufshcd_write_ee_control(hba, priv->ee_ctrl_mask);
+	mutex_unlock(&priv->ee_ctrl_mutex);
 	if (err)
 		dev_err(hba->dev, "%s: failed to write ee control %d\n",
 			__func__, err);
 	return err;
 }
 
-int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask, u16 *other_mask,
-			     u16 set, u16 clr)
+int ufshcd_update_ee_control(struct ufs_hba_priv *priv, u16 *mask,
+			     u16 *other_mask, u16 set, u16 clr)
 {
+	struct ufs_hba *hba = &priv->hba;
 	u16 new_mask, ee_ctrl_mask;
 	int err = 0;
 
-	mutex_lock(&hba->ee_ctrl_mutex);
+	mutex_lock(&priv->ee_ctrl_mutex);
 	new_mask = (*mask & ~clr) | set;
 	ee_ctrl_mask = new_mask | *other_mask;
-	if (ee_ctrl_mask != hba->ee_ctrl_mask)
+	if (ee_ctrl_mask != priv->ee_ctrl_mask)
 		err = __ufshcd_write_ee_control(hba, ee_ctrl_mask);
 	/* Still need to update 'mask' even if 'ee_ctrl_mask' was unchanged */
 	if (!err) {
-		hba->ee_ctrl_mask = ee_ctrl_mask;
+		priv->ee_ctrl_mask = ee_ctrl_mask;
 		*mask = new_mask;
 	}
-	mutex_unlock(&hba->ee_ctrl_mutex);
+	mutex_unlock(&priv->ee_ctrl_mutex);
 	return err;
 }
 
 /**
  * ufshcd_disable_ee - disable exception event
- * @hba: per-adapter instance
+ * @priv: per-adapter instance
  * @mask: exception event to disable
  *
  * Disables exception event in the device so that the EVENT_ALERT
@@ -5448,14 +5549,14 @@ int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask, u16 *other_mask,
  *
  * Returns zero on success, non-zero error value on failure.
  */
-static inline int ufshcd_disable_ee(struct ufs_hba *hba, u16 mask)
+static int ufshcd_disable_ee(struct ufs_hba_priv *priv, u16 mask)
 {
-	return ufshcd_update_ee_drv_mask(hba, 0, mask);
+	return ufshcd_update_ee_drv_mask(priv, 0, mask);
 }
 
 /**
  * ufshcd_enable_ee - enable exception event
- * @hba: per-adapter instance
+ * @priv: per-adapter instance
  * @mask: exception event to enable
  *
  * Enable corresponding exception event in the device to allow
@@ -5463,9 +5564,9 @@ static inline int ufshcd_disable_ee(struct ufs_hba *hba, u16 mask)
  *
  * Returns zero on success, non-zero error value on failure.
  */
-static inline int ufshcd_enable_ee(struct ufs_hba *hba, u16 mask)
+static int ufshcd_enable_ee(struct ufs_hba_priv *priv, u16 mask)
 {
-	return ufshcd_update_ee_drv_mask(hba, mask, 0);
+	return ufshcd_update_ee_drv_mask(priv, mask, 0);
 }
 
 /**
@@ -5481,9 +5582,10 @@ static inline int ufshcd_enable_ee(struct ufs_hba *hba, u16 mask)
  */
 static int ufshcd_enable_auto_bkops(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err = 0;
 
-	if (hba->auto_bkops_enabled)
+	if (priv->auto_bkops_enabled)
 		goto out;
 
 	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
@@ -5494,11 +5596,11 @@ static int ufshcd_enable_auto_bkops(struct ufs_hba *hba)
 		goto out;
 	}
 
-	hba->auto_bkops_enabled = true;
+	priv->auto_bkops_enabled = true;
 	trace_ufshcd_auto_bkops_state(dev_name(hba->dev), "Enabled");
 
 	/* No need of URGENT_BKOPS exception from the device */
-	err = ufshcd_disable_ee(hba, MASK_EE_URGENT_BKOPS);
+	err = ufshcd_disable_ee(priv, MASK_EE_URGENT_BKOPS);
 	if (err)
 		dev_err(hba->dev, "%s: failed to disable exception event %d\n",
 				__func__, err);
@@ -5520,16 +5622,17 @@ static int ufshcd_enable_auto_bkops(struct ufs_hba *hba)
  */
 static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err = 0;
 
-	if (!hba->auto_bkops_enabled)
+	if (!priv->auto_bkops_enabled)
 		goto out;
 
 	/*
 	 * If host assisted BKOPs is to be enabled, make sure
 	 * urgent bkops exception is allowed.
 	 */
-	err = ufshcd_enable_ee(hba, MASK_EE_URGENT_BKOPS);
+	err = ufshcd_enable_ee(priv, MASK_EE_URGENT_BKOPS);
 	if (err) {
 		dev_err(hba->dev, "%s: failed to enable exception event %d\n",
 				__func__, err);
@@ -5541,13 +5644,13 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 	if (err) {
 		dev_err(hba->dev, "%s: failed to disable bkops %d\n",
 				__func__, err);
-		ufshcd_disable_ee(hba, MASK_EE_URGENT_BKOPS);
+		ufshcd_disable_ee(priv, MASK_EE_URGENT_BKOPS);
 		goto out;
 	}
 
-	hba->auto_bkops_enabled = false;
+	priv->auto_bkops_enabled = false;
 	trace_ufshcd_auto_bkops_state(dev_name(hba->dev), "Disabled");
-	hba->is_urgent_bkops_lvl_checked = false;
+	priv->is_urgent_bkops_lvl_checked = false;
 out:
 	return err;
 }
@@ -5563,17 +5666,19 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
  */
 static void ufshcd_force_reset_auto_bkops(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	if (ufshcd_keep_autobkops_enabled_except_suspend(hba)) {
-		hba->auto_bkops_enabled = false;
-		hba->ee_ctrl_mask |= MASK_EE_URGENT_BKOPS;
+		priv->auto_bkops_enabled = false;
+		priv->ee_ctrl_mask |= MASK_EE_URGENT_BKOPS;
 		ufshcd_enable_auto_bkops(hba);
 	} else {
-		hba->auto_bkops_enabled = true;
-		hba->ee_ctrl_mask &= ~MASK_EE_URGENT_BKOPS;
+		priv->auto_bkops_enabled = true;
+		priv->ee_ctrl_mask &= ~MASK_EE_URGENT_BKOPS;
 		ufshcd_disable_auto_bkops(hba);
 	}
-	hba->urgent_bkops_lvl = BKOPS_STATUS_PERF_IMPACT;
-	hba->is_urgent_bkops_lvl_checked = false;
+	priv->urgent_bkops_lvl = BKOPS_STATUS_PERF_IMPACT;
+	priv->is_urgent_bkops_lvl_checked = false;
 }
 
 static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32 *status)
@@ -5594,7 +5699,7 @@ static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32 *status)
  *
  * Returns 0 for success, non-zero in case of failure.
  *
- * NOTE: Caller of this function can check the "hba->auto_bkops_enabled" flag
+ * NOTE: Caller of this function can check the "priv->auto_bkops_enabled" flag
  * to know whether auto bkops is enabled or disabled after this function
  * returns control to it.
  */
@@ -5636,7 +5741,9 @@ static int ufshcd_bkops_ctrl(struct ufs_hba *hba,
  */
 static int ufshcd_urgent_bkops(struct ufs_hba *hba)
 {
-	return ufshcd_bkops_ctrl(hba, hba->urgent_bkops_lvl);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	return ufshcd_bkops_ctrl(hba, priv->urgent_bkops_lvl);
 }
 
 static inline int ufshcd_get_ee_status(struct ufs_hba *hba, u32 *status)
@@ -5647,10 +5754,11 @@ static inline int ufshcd_get_ee_status(struct ufs_hba *hba, u32 *status)
 
 static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err;
 	u32 curr_status = 0;
 
-	if (hba->is_urgent_bkops_lvl_checked)
+	if (priv->is_urgent_bkops_lvl_checked)
 		goto enable_auto_bkops;
 
 	err = ufshcd_get_bkops_status(hba, &curr_status);
@@ -5670,8 +5778,8 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 		dev_err(hba->dev, "%s: device raised urgent BKOPS exception for bkops status %d\n",
 				__func__, curr_status);
 		/* update the current status as the urgent bkops level */
-		hba->urgent_bkops_lvl = curr_status;
-		hba->is_urgent_bkops_lvl_checked = true;
+		priv->urgent_bkops_lvl = curr_status;
+		priv->is_urgent_bkops_lvl_checked = true;
 	}
 
 enable_auto_bkops:
@@ -5880,9 +5988,11 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 
 static void ufshcd_rpm_dev_flush_recheck_work(struct work_struct *work)
 {
-	struct ufs_hba *hba = container_of(to_delayed_work(work),
-					   struct ufs_hba,
-					   rpm_dev_flush_recheck_work);
+	struct ufs_hba_priv *priv = container_of(to_delayed_work(work),
+						 struct ufs_hba_priv,
+						 rpm_dev_flush_recheck_work);
+	struct ufs_hba *hba = &priv->hba;
+
 	/*
 	 * To prevent unnecessary VCC power drain after device finishes
 	 * WriteBooster buffer flush or Auto BKOPs, force runtime resume
@@ -5902,10 +6012,10 @@ static void ufshcd_rpm_dev_flush_recheck_work(struct work_struct *work)
  */
 static void ufshcd_exception_event_handler(struct work_struct *work)
 {
-	struct ufs_hba *hba;
+	struct ufs_hba_priv *priv = container_of(work, struct ufs_hba_priv, eeh_work);
+	struct ufs_hba *hba = &priv->hba;
 	int err;
 	u32 status = 0;
-	hba = container_of(work, struct ufs_hba, eeh_work);
 
 	ufshcd_scsi_block_requests(hba);
 	err = ufshcd_get_ee_status(hba, &status);
@@ -5917,10 +6027,10 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 
 	trace_ufshcd_exception_event(dev_name(hba->dev), status);
 
-	if (status & hba->ee_drv_mask & MASK_EE_URGENT_BKOPS)
+	if (status & priv->ee_drv_mask & MASK_EE_URGENT_BKOPS)
 		ufshcd_bkops_exception_event_handler(hba);
 
-	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
+	if (status & priv->ee_drv_mask & MASK_EE_URGENT_TEMP)
 		ufshcd_temp_exception_event_handler(hba, status);
 
 	ufs_debugfs_exception_event(hba, status);
@@ -5944,39 +6054,40 @@ static void ufshcd_complete_requests(struct ufs_hba *hba)
  */
 static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long flags;
 	bool err_handling = true;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	/*
 	 * UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS only workaround the
 	 * device fatal error and/or DL NAC & REPLAY timeout errors.
 	 */
-	if (hba->saved_err & (CONTROLLER_FATAL_ERROR | SYSTEM_BUS_FATAL_ERROR))
+	if (priv->saved_err & (CONTROLLER_FATAL_ERROR | SYSTEM_BUS_FATAL_ERROR))
 		goto out;
 
-	if ((hba->saved_err & DEVICE_FATAL_ERROR) ||
-	    ((hba->saved_err & UIC_ERROR) &&
-	     (hba->saved_uic_err & UFSHCD_UIC_DL_TCx_REPLAY_ERROR)))
+	if ((priv->saved_err & DEVICE_FATAL_ERROR) ||
+	    ((priv->saved_err & UIC_ERROR) &&
+	     (priv->saved_uic_err & UFSHCD_UIC_DL_TCx_REPLAY_ERROR)))
 		goto out;
 
-	if ((hba->saved_err & UIC_ERROR) &&
-	    (hba->saved_uic_err & UFSHCD_UIC_DL_NAC_RECEIVED_ERROR)) {
+	if ((priv->saved_err & UIC_ERROR) &&
+	    (priv->saved_uic_err & UFSHCD_UIC_DL_NAC_RECEIVED_ERROR)) {
 		int err;
 		/*
 		 * wait for 50ms to see if we can get any other errors or not.
 		 */
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 		msleep(50);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(priv->host->host_lock, flags);
 
 		/*
 		 * now check if we have got any other severe errors other than
 		 * DL NAC error?
 		 */
-		if ((hba->saved_err & INT_FATAL_ERRORS) ||
-		    ((hba->saved_err & UIC_ERROR) &&
-		    (hba->saved_uic_err & ~UFSHCD_UIC_DL_NAC_RECEIVED_ERROR)))
+		if ((priv->saved_err & INT_FATAL_ERRORS) ||
+		    ((priv->saved_err & UIC_ERROR) &&
+		    (priv->saved_uic_err & ~UFSHCD_UIC_DL_NAC_RECEIVED_ERROR)))
 			goto out;
 
 		/*
@@ -5986,73 +6097,83 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 		 *   - If we get response then clear the DL NAC error bit.
 		 */
 
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 		err = ufshcd_verify_dev_init(hba);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(priv->host->host_lock, flags);
 
 		if (err)
 			goto out;
 
 		/* Link seems to be alive hence ignore the DL NAC errors */
-		if (hba->saved_uic_err == UFSHCD_UIC_DL_NAC_RECEIVED_ERROR)
-			hba->saved_err &= ~UIC_ERROR;
+		if (priv->saved_uic_err == UFSHCD_UIC_DL_NAC_RECEIVED_ERROR)
+			priv->saved_err &= ~UIC_ERROR;
 		/* clear NAC error */
-		hba->saved_uic_err &= ~UFSHCD_UIC_DL_NAC_RECEIVED_ERROR;
-		if (!hba->saved_uic_err)
+		priv->saved_uic_err &= ~UFSHCD_UIC_DL_NAC_RECEIVED_ERROR;
+		if (!priv->saved_uic_err)
 			err_handling = false;
 	}
 out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	return err_handling;
 }
 
 /* host lock must be held before calling this func */
 static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
 {
-	return (hba->saved_uic_err & UFSHCD_UIC_DL_PA_INIT_ERROR) ||
-	       (hba->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK));
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	return (priv->saved_uic_err & UFSHCD_UIC_DL_PA_INIT_ERROR) ||
+	       (priv->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK));
 }
 
 void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 {
-	lockdep_assert_held(hba->host->host_lock);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	lockdep_assert_held(priv->host->host_lock);
 
 	/* handle fatal errors only when link is not in error state */
-	if (hba->ufshcd_state != UFSHCD_STATE_ERROR) {
-		if (hba->force_reset || ufshcd_is_link_broken(hba) ||
+	if (priv->ufshcd_state != UFSHCD_STATE_ERROR) {
+		if (priv->force_reset || ufshcd_is_link_broken(hba) ||
 		    ufshcd_is_saved_err_fatal(hba))
-			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
+			priv->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
 		else
-			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
-		queue_work(hba->eh_wq, &hba->eh_work);
+			priv->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
+		queue_work(priv->eh_wq, &priv->eh_work);
 	}
 }
 
 static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
 {
-	down_write(&hba->clk_scaling_lock);
-	hba->clk_scaling.is_allowed = allow;
-	up_write(&hba->clk_scaling_lock);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	down_write(&priv->clk_scaling_lock);
+	priv->clk_scaling.is_allowed = allow;
+	up_write(&priv->clk_scaling_lock);
 }
 
 static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	if (suspend) {
-		if (hba->clk_scaling.is_enabled)
+		if (priv->clk_scaling.is_enabled)
 			ufshcd_suspend_clkscaling(hba);
 		ufshcd_clk_scaling_allow(hba, false);
 	} else {
 		ufshcd_clk_scaling_allow(hba, true);
-		if (hba->clk_scaling.is_enabled)
+		if (priv->clk_scaling.is_enabled)
 			ufshcd_resume_clkscaling(hba);
 	}
 }
 
 static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	ufshcd_rpm_get_sync(hba);
-	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
-	    hba->is_sys_suspended) {
+	if (pm_runtime_status_suspended(&priv->ufs_device_wlun->sdev_gendev) ||
+	    priv->is_sys_suspended) {
 		enum ufs_pm_op pm_op;
 
 		/*
@@ -6069,19 +6190,19 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		if (!ufshcd_is_clkgating_allowed(hba))
 			ufshcd_setup_clocks(hba, true);
 		ufshcd_release(hba);
-		pm_op = hba->is_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
+		pm_op = priv->is_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
 		ufshcd_vops_resume(hba, pm_op);
 	} else {
 		ufshcd_hold(hba, false);
 		if (ufshcd_is_clkscaling_supported(hba) &&
-		    hba->clk_scaling.is_enabled)
+		    priv->clk_scaling.is_enabled)
 			ufshcd_suspend_clkscaling(hba);
 		ufshcd_clk_scaling_allow(hba, false);
 	}
 	ufshcd_scsi_block_requests(hba);
 	/* Drain ufshcd_queuecommand() */
 	synchronize_rcu();
-	cancel_work_sync(&hba->eeh_work);
+	cancel_work_sync(&priv->eeh_work);
 }
 
 static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
@@ -6095,27 +6216,30 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 
 static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
 {
-	return (!hba->is_powered || hba->shutting_down ||
-		!hba->ufs_device_wlun ||
-		hba->ufshcd_state == UFSHCD_STATE_ERROR ||
-		(!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	return (!priv->is_powered || priv->shutting_down ||
+		!priv->ufs_device_wlun ||
+		priv->ufshcd_state == UFSHCD_STATE_ERROR ||
+		(!(priv->saved_err || priv->saved_uic_err || priv->force_reset ||
 		   ufshcd_is_link_broken(hba))));
 }
 
 #ifdef CONFIG_PM
 static void ufshcd_recover_pm_error(struct ufs_hba *hba)
 {
-	struct Scsi_Host *shost = hba->host;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct Scsi_Host *shost = priv->host;
 	struct scsi_device *sdev;
 	struct request_queue *q;
 	int ret;
 
-	hba->is_sys_suspended = false;
+	priv->is_sys_suspended = false;
 	/*
 	 * Set RPM status of wlun device to RPM_ACTIVE,
 	 * this also clears its runtime error.
 	 */
-	ret = pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev);
+	ret = pm_runtime_set_active(&priv->ufs_device_wlun->sdev_gendev);
 
 	/* hba device might have a runtime error otherwise */
 	if (ret)
@@ -6164,7 +6288,8 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
 static void ufshcd_err_handler(struct work_struct *work)
 {
 	int retries = MAX_ERR_HANDLER_RETRIES;
-	struct ufs_hba *hba;
+	struct ufs_hba_priv *priv = container_of(work, struct ufs_hba_priv, eh_work);
+	struct ufs_hba *hba = &priv->hba;
 	unsigned long flags;
 	bool needs_restore;
 	bool needs_reset;
@@ -6173,38 +6298,36 @@ static void ufshcd_err_handler(struct work_struct *work)
 	int pmc_err;
 	int tag;
 
-	hba = container_of(work, struct ufs_hba, eh_work);
-
 	dev_info(hba->dev,
 		 "%s started; HBA state %s; powered %d; shutting down %d; saved_err = %d; saved_uic_err = %d; force_reset = %d%s\n",
-		 __func__, ufshcd_state_name[hba->ufshcd_state],
-		 hba->is_powered, hba->shutting_down, hba->saved_err,
-		 hba->saved_uic_err, hba->force_reset,
+		 __func__, ufshcd_state_name[priv->ufshcd_state],
+		 priv->is_powered, priv->shutting_down, priv->saved_err,
+		 priv->saved_uic_err, priv->force_reset,
 		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
 
-	down(&hba->host_sem);
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	down(&priv->host_sem);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	if (ufshcd_err_handling_should_stop(hba)) {
-		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
-			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		up(&hba->host_sem);
+		if (priv->ufshcd_state != UFSHCD_STATE_ERROR)
+			priv->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
+		up(&priv->host_sem);
 		return;
 	}
-	ufshcd_set_eh_in_progress(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ufshcd_set_eh_in_progress(priv);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	ufshcd_err_handling_prepare(hba);
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba);
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 again:
 	needs_restore = false;
 	needs_reset = false;
 	err_xfer = false;
 	err_tm = false;
 
-	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
-		hba->ufshcd_state = UFSHCD_STATE_RESET;
+	if (priv->ufshcd_state != UFSHCD_STATE_ERROR)
+		priv->ufshcd_state = UFSHCD_STATE_RESET;
 	/*
 	 * A full reset and restore might have happened after preparation
 	 * is finished, double check whether we should stop.
@@ -6215,26 +6338,26 @@ static void ufshcd_err_handler(struct work_struct *work)
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
 		bool ret;
 
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 		/* release the lock as ufshcd_quirk_dl_nac_errors() may sleep */
 		ret = ufshcd_quirk_dl_nac_errors(hba);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(priv->host->host_lock, flags);
 		if (!ret && ufshcd_err_handling_should_stop(hba))
 			goto skip_err_handling;
 	}
 
-	if ((hba->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK)) ||
-	    (hba->saved_uic_err &&
-	     (hba->saved_uic_err != UFSHCD_UIC_PA_GENERIC_ERROR))) {
-		bool pr_prdt = !!(hba->saved_err & SYSTEM_BUS_FATAL_ERROR);
+	if ((priv->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK)) ||
+	    (priv->saved_uic_err &&
+	     (priv->saved_uic_err != UFSHCD_UIC_PA_GENERIC_ERROR))) {
+		bool pr_prdt = !!(priv->saved_err & SYSTEM_BUS_FATAL_ERROR);
 
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 		ufshcd_print_host_state(hba);
 		ufshcd_print_pwr_info(hba);
 		ufshcd_print_evt_hist(hba);
-		ufshcd_print_tmrs(hba, hba->outstanding_tasks);
-		ufshcd_print_trs(hba, hba->outstanding_reqs, pr_prdt);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		ufshcd_print_tmrs(hba, priv->outstanding_tasks);
+		ufshcd_print_trs(hba, priv->outstanding_reqs, pr_prdt);
+		spin_lock_irqsave(priv->host->host_lock, flags);
 	}
 
 	/*
@@ -6242,10 +6365,10 @@ static void ufshcd_err_handler(struct work_struct *work)
 	 * transfers forcefully because they will get cleared during
 	 * host reset and restore
 	 */
-	if (hba->force_reset || ufshcd_is_link_broken(hba) ||
+	if (priv->force_reset || ufshcd_is_link_broken(hba) ||
 	    ufshcd_is_saved_err_fatal(hba) ||
-	    ((hba->saved_err & UIC_ERROR) &&
-	     (hba->saved_uic_err & (UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
+	    ((priv->saved_err & UIC_ERROR) &&
+	     (priv->saved_uic_err & (UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
 				    UFSHCD_UIC_DL_TCx_REPLAY_ERROR)))) {
 		needs_reset = true;
 		goto do_reset;
@@ -6255,33 +6378,33 @@ static void ufshcd_err_handler(struct work_struct *work)
 	 * If LINERESET was caught, UFS might have been put to PWM mode,
 	 * check if power mode restore is needed.
 	 */
-	if (hba->saved_uic_err & UFSHCD_UIC_PA_GENERIC_ERROR) {
-		hba->saved_uic_err &= ~UFSHCD_UIC_PA_GENERIC_ERROR;
-		if (!hba->saved_uic_err)
-			hba->saved_err &= ~UIC_ERROR;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (priv->saved_uic_err & UFSHCD_UIC_PA_GENERIC_ERROR) {
+		priv->saved_uic_err &= ~UFSHCD_UIC_PA_GENERIC_ERROR;
+		if (!priv->saved_uic_err)
+			priv->saved_err &= ~UIC_ERROR;
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 		if (ufshcd_is_pwr_mode_restore_needed(hba))
 			needs_restore = true;
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		if (!hba->saved_err && !needs_restore)
+		spin_lock_irqsave(priv->host->host_lock, flags);
+		if (!priv->saved_err && !needs_restore)
 			goto skip_err_handling;
 	}
 
-	hba->silence_err_logs = true;
+	priv->silence_err_logs = true;
 	/* release lock as clear command might sleep */
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	/* Clear pending transfer requests */
-	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
+	for_each_set_bit(tag, &priv->outstanding_reqs, hba->nutrs) {
 		if (ufshcd_try_to_abort_task(hba, tag)) {
 			err_xfer = true;
 			goto lock_skip_pending_xfer_clear;
 		}
 		dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
-			hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
+			priv->lrb[tag].cmd ? priv->lrb[tag].cmd->cmnd[0] : -1);
 	}
 
 	/* Clear pending task management requests */
-	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
+	for_each_set_bit(tag, &priv->outstanding_tasks, hba->nutmrs) {
 		if (ufshcd_clear_tm_cmd(hba, tag)) {
 			err_tm = true;
 			goto lock_skip_pending_xfer_clear;
@@ -6292,8 +6415,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	/* Complete the requests that are cleared by s/w */
 	ufshcd_complete_requests(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->silence_err_logs = false;
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	priv->silence_err_logs = false;
 	if (err_xfer || err_tm) {
 		needs_reset = true;
 		goto do_reset;
@@ -6304,23 +6427,23 @@ static void ufshcd_err_handler(struct work_struct *work)
 	 * now it is safe to retore power mode.
 	 */
 	if (needs_restore) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 		/*
 		 * Hold the scaling lock just in case dev cmds
 		 * are sent via bsg and/or sysfs.
 		 */
-		down_write(&hba->clk_scaling_lock);
-		hba->force_pmc = true;
+		down_write(&priv->clk_scaling_lock);
+		priv->force_pmc = true;
 		pmc_err = ufshcd_config_pwr_mode(hba, &(hba->pwr_info));
 		if (pmc_err) {
 			needs_reset = true;
 			dev_err(hba->dev, "%s: Failed to restore power mode, err = %d\n",
 					__func__, pmc_err);
 		}
-		hba->force_pmc = false;
+		priv->force_pmc = false;
 		ufshcd_print_pwr_info(hba);
-		up_write(&hba->clk_scaling_lock);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		up_write(&priv->clk_scaling_lock);
+		spin_lock_irqsave(priv->host->host_lock, flags);
 	}
 
 do_reset:
@@ -6328,39 +6451,39 @@ static void ufshcd_err_handler(struct work_struct *work)
 	if (needs_reset) {
 		int err;
 
-		hba->force_reset = false;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		priv->force_reset = false;
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 		err = ufshcd_reset_and_restore(hba);
 		if (err)
 			dev_err(hba->dev, "%s: reset and restore failed with err %d\n",
 					__func__, err);
 		else
 			ufshcd_recover_pm_error(hba);
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(priv->host->host_lock, flags);
 	}
 
 skip_err_handling:
 	if (!needs_reset) {
-		if (hba->ufshcd_state == UFSHCD_STATE_RESET)
-			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
-		if (hba->saved_err || hba->saved_uic_err)
+		if (priv->ufshcd_state == UFSHCD_STATE_RESET)
+			priv->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+		if (priv->saved_err || priv->saved_uic_err)
 			dev_err_ratelimited(hba->dev, "%s: exit: saved_err 0x%x saved_uic_err 0x%x",
-			    __func__, hba->saved_err, hba->saved_uic_err);
+			    __func__, priv->saved_err, priv->saved_uic_err);
 	}
 	/* Exit in an operational state or dead */
-	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL &&
-	    hba->ufshcd_state != UFSHCD_STATE_ERROR) {
+	if (priv->ufshcd_state != UFSHCD_STATE_OPERATIONAL &&
+	    priv->ufshcd_state != UFSHCD_STATE_ERROR) {
 		if (--retries)
 			goto again;
-		hba->ufshcd_state = UFSHCD_STATE_ERROR;
+		priv->ufshcd_state = UFSHCD_STATE_ERROR;
 	}
-	ufshcd_clear_eh_in_progress(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ufshcd_clear_eh_in_progress(priv);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 	ufshcd_err_handling_unprepare(hba);
-	up(&hba->host_sem);
+	up(&priv->host_sem);
 
 	dev_info(hba->dev, "%s finished; HBA state %s\n", __func__,
-		 ufshcd_state_name[hba->ufshcd_state]);
+		 ufshcd_state_name[priv->ufshcd_state]);
 }
 
 /**
@@ -6373,6 +6496,7 @@ static void ufshcd_err_handler(struct work_struct *work)
  */
 static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	u32 reg;
 	irqreturn_t retval = IRQ_NONE;
 
@@ -6393,15 +6517,15 @@ static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
 		if (reg & UIC_PHY_ADAPTER_LAYER_GENERIC_ERROR) {
 			struct uic_command *cmd = NULL;
 
-			hba->uic_error |= UFSHCD_UIC_PA_GENERIC_ERROR;
-			if (hba->uic_async_done && hba->active_uic_cmd)
-				cmd = hba->active_uic_cmd;
+			priv->uic_error |= UFSHCD_UIC_PA_GENERIC_ERROR;
+			if (priv->uic_async_done && priv->active_uic_cmd)
+				cmd = priv->active_uic_cmd;
 			/*
 			 * Ignore the LINERESET during power mode change
 			 * operation via DME_SET command.
 			 */
 			if (cmd && (cmd->command == UIC_CMD_DME_SET))
-				hba->uic_error &= ~UFSHCD_UIC_PA_GENERIC_ERROR;
+				priv->uic_error &= ~UFSHCD_UIC_PA_GENERIC_ERROR;
 		}
 		retval |= IRQ_HANDLED;
 	}
@@ -6413,14 +6537,14 @@ static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
 		ufshcd_update_evt_hist(hba, UFS_EVT_DL_ERR, reg);
 
 		if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
-			hba->uic_error |= UFSHCD_UIC_DL_PA_INIT_ERROR;
+			priv->uic_error |= UFSHCD_UIC_DL_PA_INIT_ERROR;
 		else if (hba->dev_quirks &
 				UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
 			if (reg & UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED)
-				hba->uic_error |=
+				priv->uic_error |=
 					UFSHCD_UIC_DL_NAC_RECEIVED_ERROR;
 			else if (reg & UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT)
-				hba->uic_error |= UFSHCD_UIC_DL_TCx_REPLAY_ERROR;
+				priv->uic_error |= UFSHCD_UIC_DL_TCx_REPLAY_ERROR;
 		}
 		retval |= IRQ_HANDLED;
 	}
@@ -6430,7 +6554,7 @@ static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
 	if ((reg & UIC_NETWORK_LAYER_ERROR) &&
 	    (reg & UIC_NETWORK_LAYER_ERROR_CODE_MASK)) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_NL_ERR, reg);
-		hba->uic_error |= UFSHCD_UIC_NL_ERROR;
+		priv->uic_error |= UFSHCD_UIC_NL_ERROR;
 		retval |= IRQ_HANDLED;
 	}
 
@@ -6438,7 +6562,7 @@ static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
 	if ((reg & UIC_TRANSPORT_LAYER_ERROR) &&
 	    (reg & UIC_TRANSPORT_LAYER_ERROR_CODE_MASK)) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_TL_ERR, reg);
-		hba->uic_error |= UFSHCD_UIC_TL_ERROR;
+		priv->uic_error |= UFSHCD_UIC_TL_ERROR;
 		retval |= IRQ_HANDLED;
 	}
 
@@ -6446,12 +6570,12 @@ static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
 	if ((reg & UIC_DME_ERROR) &&
 	    (reg & UIC_DME_ERROR_CODE_MASK)) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_DME_ERR, reg);
-		hba->uic_error |= UFSHCD_UIC_DME_ERROR;
+		priv->uic_error |= UFSHCD_UIC_DME_ERROR;
 		retval |= IRQ_HANDLED;
 	}
 
 	dev_dbg(hba->dev, "%s: UIC error flags = 0x%08x\n",
-			__func__, hba->uic_error);
+			__func__, priv->uic_error);
 	return retval;
 }
 
@@ -6466,33 +6590,33 @@ static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
  */
 static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	bool queue_eh_work = false;
 	irqreturn_t retval = IRQ_NONE;
 
-	spin_lock(hba->host->host_lock);
-	hba->errors |= UFSHCD_ERROR_MASK & intr_status;
+	spin_lock(priv->host->host_lock);
+	priv->errors |= UFSHCD_ERROR_MASK & intr_status;
 
-	if (hba->errors & INT_FATAL_ERRORS) {
-		ufshcd_update_evt_hist(hba, UFS_EVT_FATAL_ERR,
-				       hba->errors);
+	if (priv->errors & INT_FATAL_ERRORS) {
+		ufshcd_update_evt_hist(hba, UFS_EVT_FATAL_ERR, priv->errors);
 		queue_eh_work = true;
 	}
 
-	if (hba->errors & UIC_ERROR) {
-		hba->uic_error = 0;
+	if (priv->errors & UIC_ERROR) {
+		priv->uic_error = 0;
 		retval = ufshcd_update_uic_error(hba);
-		if (hba->uic_error)
+		if (priv->uic_error)
 			queue_eh_work = true;
 	}
 
-	if (hba->errors & UFSHCD_UIC_HIBERN8_MASK) {
+	if (priv->errors & UFSHCD_UIC_HIBERN8_MASK) {
 		dev_err(hba->dev,
 			"%s: Auto Hibern8 %s failed - status: 0x%08x, upmcrs: 0x%08x\n",
-			__func__, (hba->errors & UIC_HIBERNATE_ENTER) ?
+			__func__, priv->errors & UIC_HIBERNATE_ENTER ?
 			"Enter" : "Exit",
-			hba->errors, ufshcd_get_upmcrs(hba));
+			priv->errors, ufshcd_get_upmcrs(hba));
 		ufshcd_update_evt_hist(hba, UFS_EVT_AUTO_HIBERN8_ERR,
-				       hba->errors);
+				       priv->errors);
 		ufshcd_set_link_broken(hba);
 		queue_eh_work = true;
 	}
@@ -6502,17 +6626,17 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 		 * update the transfer error masks to sticky bits, let's do this
 		 * irrespective of current ufshcd_state.
 		 */
-		hba->saved_err |= hba->errors;
-		hba->saved_uic_err |= hba->uic_error;
+		priv->saved_err |= priv->errors;
+		priv->saved_uic_err |= priv->uic_error;
 
 		/* dump controller state before resetting */
-		if ((hba->saved_err &
+		if ((priv->saved_err &
 		     (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK)) ||
-		    (hba->saved_uic_err &&
-		     (hba->saved_uic_err != UFSHCD_UIC_PA_GENERIC_ERROR))) {
+		    (priv->saved_uic_err &&
+		     (priv->saved_uic_err != UFSHCD_UIC_PA_GENERIC_ERROR))) {
 			dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
-					__func__, hba->saved_err,
-					hba->saved_uic_err);
+					__func__, priv->saved_err,
+					priv->saved_uic_err);
 			ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE,
 					 "host_regs: ");
 			ufshcd_print_pwr_info(hba);
@@ -6526,9 +6650,9 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 	 * itself without s/w intervention or errors that will be
 	 * handled by the SCSI core layer.
 	 */
-	hba->errors = 0;
-	hba->uic_error = 0;
-	spin_unlock(hba->host->host_lock);
+	priv->errors = 0;
+	priv->uic_error = 0;
+	spin_unlock(priv->host->host_lock);
 	return retval;
 }
 
@@ -6542,21 +6666,22 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
  */
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long flags, pending, issued;
 	irqreturn_t ret = IRQ_NONE;
 	int tag;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-	issued = hba->outstanding_tasks & ~pending;
+	issued = priv->outstanding_tasks & ~pending;
 	for_each_set_bit(tag, &issued, hba->nutmrs) {
-		struct request *req = hba->tmf_rqs[tag];
+		struct request *req = priv->tmf_rqs[tag];
 		struct completion *c = req->end_io_data;
 
 		complete(c);
 		ret = IRQ_HANDLED;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	return ret;
 }
@@ -6572,12 +6697,13 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
  */
 static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	irqreturn_t retval = IRQ_NONE;
 
 	if (intr_status & UFSHCD_UIC_MASK)
 		retval |= ufshcd_uic_cmd_compl(hba, intr_status);
 
-	if (intr_status & UFSHCD_ERROR_MASK || hba->errors)
+	if (intr_status & UFSHCD_ERROR_MASK || priv->errors)
 		retval |= ufshcd_check_errors(hba, intr_status);
 
 	if (intr_status & UTP_TASK_REQ_COMPL)
@@ -6603,11 +6729,12 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	u32 intr_status, enabled_intr_status = 0;
 	irqreturn_t retval = IRQ_NONE;
 	struct ufs_hba *hba = __hba;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int retries = hba->nutrs;
 
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-	hba->ufs_stats.last_intr_status = intr_status;
-	hba->ufs_stats.last_intr_ts = ktime_get();
+	priv->ufs_stats.last_intr_status = intr_status;
+	priv->ufs_stats.last_intr_ts = ktime_get();
 
 	/*
 	 * There could be max of hba->nutrs reqs in flight and in worst case
@@ -6627,11 +6754,11 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 
 	if (enabled_intr_status && retval == IRQ_NONE &&
 	    (!(enabled_intr_status & UTP_TRANSFER_REQ_COMPL) ||
-	     hba->outstanding_reqs) && !ufshcd_eh_in_progress(hba)) {
+	     priv->outstanding_reqs) && !ufshcd_eh_in_progress(priv)) {
 		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x (0x%08x, 0x%08x)\n",
 					__func__,
 					intr_status,
-					hba->ufs_stats.last_intr_status,
+					priv->ufs_stats.last_intr_status,
 					enabled_intr_status);
 		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
 	}
@@ -6641,16 +6768,17 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err = 0;
 	u32 mask = 1 << tag;
 	unsigned long flags;
 
-	if (!test_bit(tag, &hba->outstanding_tasks))
+	if (!test_bit(tag, &priv->outstanding_tasks))
 		goto out;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	ufshcd_utmrl_clear(hba, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	/* poll for max. 1 sec to clear door bell register by h/w */
 	err = ufshcd_wait_for_register(hba,
@@ -6667,8 +6795,9 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		struct utp_task_req_desc *treq, u8 tm_function)
 {
-	struct request_queue *q = hba->tmf_queue;
-	struct Scsi_Host *host = hba->host;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct request_queue *q = priv->tmf_queue;
+	struct Scsi_Host *host = priv->host;
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request *req;
 	unsigned long flags;
@@ -6689,14 +6818,14 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	task_tag = req->tag;
 	WARN_ONCE(task_tag < 0 || task_tag >= hba->nutmrs, "Invalid tag %d\n",
 		  task_tag);
-	hba->tmf_rqs[req->tag] = req;
+	priv->tmf_rqs[req->tag] = req;
 	treq->upiu_req.req_header.dword_0 |= cpu_to_be32(task_tag);
 
-	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
+	memcpy(priv->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
 	ufshcd_vops_setup_task_mgmt(hba, task_tag, tm_function);
 
 	/* send command to the controller */
-	__set_bit(task_tag, &hba->outstanding_tasks);
+	__set_bit(task_tag, &priv->outstanding_tasks);
 
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
@@ -6719,15 +6848,15 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		err = -ETIMEDOUT;
 	} else {
 		err = 0;
-		memcpy(treq, hba->utmrdl_base_addr + task_tag, sizeof(*treq));
+		memcpy(treq, priv->utmrdl_base_addr + task_tag, sizeof(*treq));
 
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_COMP);
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->tmf_rqs[req->tag] = NULL;
-	__clear_bit(task_tag, &hba->outstanding_tasks);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	priv->tmf_rqs[req->tag] = NULL;
+	__clear_bit(task_tag, &priv->outstanding_tasks);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	ufshcd_release(hba);
 	blk_mq_free_request(req);
@@ -6797,7 +6926,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
  * tasks work queues.
  *
  * Since there is only one available tag for device management commands,
- * the caller is expected to hold the hba->dev_cmd.lock mutex.
+ * the caller must hold the priv->dev_cmd.lock mutex.
  */
 static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 					struct utp_upiu_req *req_upiu,
@@ -6806,25 +6935,26 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 					enum dev_cmd_type cmd_type,
 					enum query_opcode desc_op)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	DECLARE_COMPLETION_ONSTACK(wait);
-	const u32 tag = hba->reserved_slot;
+	const u32 tag = priv->reserved_slot;
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
 	u8 upiu_flags;
 
-	/* Protects use of hba->reserved_slot. */
-	lockdep_assert_held(&hba->dev_cmd.lock);
+	/* Protects use of priv->reserved_slot. */
+	lockdep_assert_held(&priv->dev_cmd.lock);
 
-	down_read(&hba->clk_scaling_lock);
+	down_read(&priv->clk_scaling_lock);
 
-	lrbp = &hba->lrb[tag];
+	lrbp = &priv->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0;
 	lrbp->intr_cmd = true;
 	ufshcd_prepare_lrbp_crypto(NULL, lrbp);
-	hba->dev_cmd.type = cmd_type;
+	priv->dev_cmd.type = cmd_type;
 
 	if (hba->ufs_version <= ufshci_version(1, 1))
 		lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
@@ -6849,7 +6979,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
 
-	hba->dev_cmd.complete = &wait;
+	priv->dev_cmd.complete = &wait;
 
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
 
@@ -6882,7 +7012,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
-	up_read(&hba->clk_scaling_lock);
+	up_read(&priv->clk_scaling_lock);
 	return err;
 }
 
@@ -6908,6 +7038,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err;
 	enum dev_cmd_type cmd_type = DEV_CMD_TYPE_QUERY;
 	struct utp_task_req_desc treq = { { 0 }, };
@@ -6920,11 +7051,11 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 		fallthrough;
 	case UPIU_TRANSACTION_QUERY_REQ:
 		ufshcd_hold(hba, false);
-		mutex_lock(&hba->dev_cmd.lock);
+		mutex_lock(&priv->dev_cmd.lock);
 		err = ufshcd_issue_devman_upiu_cmd(hba, req_upiu, rsp_upiu,
 						   desc_buff, buff_len,
 						   cmd_type, desc_op);
-		mutex_unlock(&hba->dev_cmd.lock);
+		mutex_unlock(&priv->dev_cmd.lock);
 		ufshcd_release(hba);
 
 		break;
@@ -6966,15 +7097,13 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
  */
 static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
-	struct Scsi_Host *host;
-	struct ufs_hba *hba;
+	struct Scsi_Host *host = cmd->device->host;
+	struct ufs_hba *hba = shost_priv(host);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	u32 pos;
 	int err;
 	u8 resp = 0xF, lun;
 
-	host = cmd->device->host;
-	hba = shost_priv(host);
-
 	lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	err = ufshcd_issue_tm_cmd(hba, lun, 0, UFS_LOGICAL_RESET, &resp);
 	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
@@ -6984,8 +7113,8 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	}
 
 	/* clear the commands that were pending for corresponding LUN */
-	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
-		if (hba->lrb[pos].lun == lun) {
+	for_each_set_bit(pos, &priv->outstanding_reqs, hba->nutrs) {
+		if (priv->lrb[pos].lun == lun) {
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
@@ -7007,11 +7136,12 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
 static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufshcd_lrb *lrbp;
 	int tag;
 
 	for_each_set_bit(tag, &bitmap, hba->nutrs) {
-		lrbp = &hba->lrb[tag];
+		lrbp = &priv->lrb[tag];
 		lrbp->req_abort_skip = true;
 	}
 }
@@ -7031,7 +7161,8 @@ static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
  */
 static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
 {
-	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufshcd_lrb *lrbp = &priv->lrb[tag];
 	int err = 0;
 	int poll_cnt;
 	u8 resp = 0xF;
@@ -7107,8 +7238,9 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct ufs_hba *hba = shost_priv(host);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int tag = scsi_cmd_to_rq(cmd)->tag;
-	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
+	struct ufshcd_lrb *lrbp = &priv->lrb[tag];
 	unsigned long flags;
 	int err = FAILED;
 	bool outstanding;
@@ -7119,10 +7251,10 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	ufshcd_hold(hba, false);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* If command is already aborted/completed, return FAILED. */
-	if (!(test_bit(tag, &hba->outstanding_reqs))) {
+	if (!(test_bit(tag, &priv->outstanding_reqs))) {
 		dev_err(hba->dev,
 			"%s: cmd at tag %d already completed, outstanding=0x%lx, doorbell=0x%x\n",
-			__func__, tag, hba->outstanding_reqs, reg);
+			__func__, tag, priv->outstanding_reqs, reg);
 		goto release;
 	}
 
@@ -7168,7 +7300,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		ufshcd_update_evt_hist(hba, UFS_EVT_ABORT, lrbp->lun);
 
 		spin_lock_irqsave(host->host_lock, flags);
-		hba->force_reset = true;
+		priv->force_reset = true;
 		ufshcd_schedule_eh_work(hba);
 		spin_unlock_irqrestore(host->host_lock, flags);
 		goto release;
@@ -7177,14 +7309,14 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	/* Skip task abort in case previous aborts failed and report failure */
 	if (lrbp->req_abort_skip) {
 		dev_err(hba->dev, "%s: skipping abort\n", __func__);
-		ufshcd_set_req_abort_skip(hba, hba->outstanding_reqs);
+		ufshcd_set_req_abort_skip(hba, priv->outstanding_reqs);
 		goto release;
 	}
 
 	err = ufshcd_try_to_abort_task(hba, tag);
 	if (err) {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
-		ufshcd_set_req_abort_skip(hba, hba->outstanding_reqs);
+		ufshcd_set_req_abort_skip(hba, priv->outstanding_reqs);
 		err = FAILED;
 		goto release;
 	}
@@ -7193,9 +7325,9 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * Clear the corresponding bit from outstanding_reqs since the command
 	 * has been aborted successfully.
 	 */
-	spin_lock_irqsave(&hba->outstanding_lock, flags);
-	outstanding = __test_and_clear_bit(tag, &hba->outstanding_reqs);
-	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+	spin_lock_irqsave(&priv->outstanding_lock, flags);
+	outstanding = __test_and_clear_bit(tag, &priv->outstanding_reqs);
+	spin_unlock_irqrestore(&priv->outstanding_lock, flags);
 
 	if (outstanding)
 		ufshcd_release_scsi_cmd(hba, lrbp);
@@ -7220,6 +7352,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
  */
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err;
 
 	/*
@@ -7228,9 +7361,9 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	 */
 	ufshpb_toggle_state(hba, HPB_PRESENT, HPB_RESET);
 	ufshcd_hba_stop(hba);
-	hba->silence_err_logs = true;
+	priv->silence_err_logs = true;
 	ufshcd_complete_requests(hba);
-	hba->silence_err_logs = false;
+	priv->silence_err_logs = false;
 
 	/* scale up clocks to max frequency before full reinitialization */
 	ufshcd_set_clk_freq(hba, true);
@@ -7258,38 +7391,39 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
  */
 static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	u32 saved_err = 0;
 	u32 saved_uic_err = 0;
 	int err = 0;
 	unsigned long flags;
 	int retries = MAX_HOST_RESET_RETRIES;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	do {
 		/*
 		 * This is a fresh start, cache and clear saved error first,
 		 * in case new error generated during reset and restore.
 		 */
-		saved_err |= hba->saved_err;
-		saved_uic_err |= hba->saved_uic_err;
-		hba->saved_err = 0;
-		hba->saved_uic_err = 0;
-		hba->force_reset = false;
-		hba->ufshcd_state = UFSHCD_STATE_RESET;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		saved_err |= priv->saved_err;
+		saved_uic_err |= priv->saved_uic_err;
+		priv->saved_err = 0;
+		priv->saved_uic_err = 0;
+		priv->force_reset = false;
+		priv->ufshcd_state = UFSHCD_STATE_RESET;
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 		/* Reset the attached device */
 		ufshcd_device_reset(hba);
 
 		err = ufshcd_host_reset_and_restore(hba);
 
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(priv->host->host_lock, flags);
 		if (err)
 			continue;
 		/* Do not exit unless operational or dead */
-		if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL &&
-		    hba->ufshcd_state != UFSHCD_STATE_ERROR &&
-		    hba->ufshcd_state != UFSHCD_STATE_EH_SCHEDULED_NON_FATAL)
+		if (priv->ufshcd_state != UFSHCD_STATE_OPERATIONAL &&
+		    priv->ufshcd_state != UFSHCD_STATE_ERROR &&
+		    priv->ufshcd_state != UFSHCD_STATE_EH_SCHEDULED_NON_FATAL)
 			err = -EAGAIN;
 	} while (err && --retries);
 
@@ -7297,13 +7431,13 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 	 * Inform scsi mid-layer that we did reset and allow to handle
 	 * Unit Attention properly.
 	 */
-	scsi_report_bus_reset(hba->host, 0);
+	scsi_report_bus_reset(priv->host, 0);
 	if (err) {
-		hba->ufshcd_state = UFSHCD_STATE_ERROR;
-		hba->saved_err |= saved_err;
-		hba->saved_uic_err |= saved_uic_err;
+		priv->ufshcd_state = UFSHCD_STATE_ERROR;
+		priv->saved_err |= saved_err;
+		priv->saved_uic_err |= saved_uic_err;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	return err;
 }
@@ -7318,22 +7452,21 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
 	int err = SUCCESS;
 	unsigned long flags;
-	struct ufs_hba *hba;
-
-	hba = shost_priv(cmd->device->host);
+	struct ufs_hba *hba = shost_priv(cmd->device->host);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->force_reset = true;
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	priv->force_reset = true;
 	ufshcd_schedule_eh_work(hba);
 	dev_err(hba->dev, "%s: reset in progress - 1\n", __func__);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
-	flush_work(&hba->eh_work);
+	flush_work(&priv->eh_work);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ufshcd_state == UFSHCD_STATE_ERROR)
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	if (priv->ufshcd_state == UFSHCD_STATE_ERROR)
 		err = FAILED;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	return err;
 }
@@ -7434,8 +7567,9 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 
 static void ufshcd_set_active_icc_lvl(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret;
-	int buff_len = hba->desc_size[QUERY_DESC_IDN_POWER];
+	int buff_len = priv->desc_size[QUERY_DESC_IDN_POWER];
 	u8 *desc_buf;
 	u32 icc_level;
 
@@ -7506,19 +7640,20 @@ static inline void ufshcd_blk_pm_runtime_init(struct scsi_device *sdev)
  */
 static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret = 0;
 	struct scsi_device *sdev_boot, *sdev_rpmb;
 
-	hba->ufs_device_wlun = __scsi_add_device(hba->host, 0, 0,
+	priv->ufs_device_wlun = __scsi_add_device(priv->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN), NULL);
-	if (IS_ERR(hba->ufs_device_wlun)) {
-		ret = PTR_ERR(hba->ufs_device_wlun);
-		hba->ufs_device_wlun = NULL;
+	if (IS_ERR(priv->ufs_device_wlun)) {
+		ret = PTR_ERR(priv->ufs_device_wlun);
+		priv->ufs_device_wlun = NULL;
 		goto out;
 	}
-	scsi_device_put(hba->ufs_device_wlun);
+	scsi_device_put(priv->ufs_device_wlun);
 
-	sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
+	sdev_rpmb = __scsi_add_device(priv->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
 	if (IS_ERR(sdev_rpmb)) {
 		ret = PTR_ERR(sdev_rpmb);
@@ -7527,7 +7662,7 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 	ufshcd_blk_pm_runtime_init(sdev_rpmb);
 	scsi_device_put(sdev_rpmb);
 
-	sdev_boot = __scsi_add_device(hba->host, 0, 0,
+	sdev_boot = __scsi_add_device(priv->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
 	if (IS_ERR(sdev_boot)) {
 		dev_err(hba->dev, "%s: BOOT WLUN not found\n", __func__);
@@ -7538,13 +7673,14 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 	goto out;
 
 remove_ufs_device_wlun:
-	scsi_remove_device(hba->ufs_device_wlun);
+	scsi_remove_device(priv->ufs_device_wlun);
 out:
 	return ret;
 }
 
 static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u8 lun;
 	u32 d_lu_wb_buf_alloc;
@@ -7563,7 +7699,7 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	     (hba->dev_quirks & UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES)))
 		goto wb_disabled;
 
-	if (hba->desc_size[QUERY_DESC_IDN_DEVICE] <
+	if (priv->desc_size[QUERY_DESC_IDN_DEVICE] <
 	    DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
 		goto wb_disabled;
 
@@ -7616,6 +7752,7 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 
 static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u32 ext_ufs_feature;
 	u8 mask = 0;
@@ -7632,7 +7769,7 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
 		mask |= MASK_EE_TOO_HIGH_TEMP;
 
 	if (mask) {
-		ufshcd_enable_ee(hba, mask);
+		ufshcd_enable_ee(priv, mask);
 		ufs_hwmon_probe(hba, mask);
 	}
 }
@@ -7668,6 +7805,7 @@ static void ufs_fixup_device_setup(struct ufs_hba *hba)
 
 static int ufs_get_device_desc(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err;
 	u8 model_index;
 	u8 b_ufs_feature_sup;
@@ -7681,7 +7819,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	}
 
 	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_DEVICE, 0, 0, desc_buf,
-				     hba->desc_size[QUERY_DESC_IDN_DEVICE]);
+				     priv->desc_size[QUERY_DESC_IDN_DEVICE]);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
 			__func__, err);
@@ -7726,7 +7864,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 		goto out;
 	}
 
-	hba->luns_avail = desc_buf[DEVICE_DESC_PARAM_NUM_LU] +
+	priv->luns_avail = desc_buf[DEVICE_DESC_PARAM_NUM_LU] +
 		desc_buf[DEVICE_DESC_PARAM_NUM_WLU];
 
 	ufs_fixup_device_setup(hba);
@@ -7920,18 +8058,21 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 
 static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
 {
-	hba->ufs_stats.hibern8_exit_cnt = 0;
-	hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	priv->ufs_stats.hibern8_exit_cnt = 0;
+	priv->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
 	hba->req_abort_count = 0;
 }
 
 static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err;
 	size_t buff_len;
 	u8 *desc_buf;
 
-	buff_len = hba->desc_size[QUERY_DESC_IDN_GEOMETRY];
+	buff_len = priv->desc_size[QUERY_DESC_IDN_GEOMETRY];
 	desc_buf = kmalloc(buff_len, GFP_KERNEL);
 	if (!desc_buf) {
 		err = -ENOMEM;
@@ -7951,7 +8092,7 @@ static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
 	else if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 0)
 		hba->dev_info.max_lu_supported = 8;
 
-	if (hba->desc_size[QUERY_DESC_IDN_GEOMETRY] >=
+	if (priv->desc_size[QUERY_DESC_IDN_GEOMETRY] >=
 		GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGS)
 		ufshpb_get_geo_info(hba, desc_buf);
 
@@ -7987,14 +8128,14 @@ ufs_get_bref_clk_from_hz(unsigned long freq)
 
 void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba, struct clk *refclk)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned long freq;
 
 	freq = clk_get_rate(refclk);
 
-	hba->dev_ref_clk_freq =
-		ufs_get_bref_clk_from_hz(freq);
+	priv->dev_ref_clk_freq = ufs_get_bref_clk_from_hz(freq);
 
-	if (hba->dev_ref_clk_freq == REF_CLK_FREQ_INVAL)
+	if (priv->dev_ref_clk_freq == REF_CLK_FREQ_INVAL)
 		dev_err(hba->dev,
 		"invalid ref_clk setting = %ld\n", freq);
 }
@@ -8003,7 +8144,8 @@ static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
 {
 	int err;
 	u32 ref_clk;
-	u32 freq = hba->dev_ref_clk_freq;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	u32 freq = priv->dev_ref_clk_freq;
 
 	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 			QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &ref_clk);
@@ -8035,12 +8177,13 @@ static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
 
 static int ufshcd_device_params_init(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	bool flag;
 	int ret, i;
 
 	 /* Init device descriptor sizes */
 	for (i = 0; i < QUERY_DESC_IDN_MAX; i++)
-		hba->desc_size[i] = QUERY_DESC_MAX_SIZE;
+		priv->desc_size[i] = QUERY_DESC_MAX_SIZE;
 
 	/* Init UFS geometry descriptor related parameters */
 	ret = ufshcd_device_geo_params_init(hba);
@@ -8076,6 +8219,7 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
  */
 static int ufshcd_add_lus(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret;
 
 	/* Add required well known logical units to scsi mid layer */
@@ -8085,23 +8229,23 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 
 	/* Initialize devfreq after UFS device is detected */
 	if (ufshcd_is_clkscaling_supported(hba)) {
-		memcpy(&hba->clk_scaling.saved_pwr_info.info,
+		memcpy(&priv->clk_scaling.saved_pwr_info.info,
 			&hba->pwr_info,
 			sizeof(struct ufs_pa_layer_attr));
-		hba->clk_scaling.saved_pwr_info.is_valid = true;
-		hba->clk_scaling.is_allowed = true;
+		priv->clk_scaling.saved_pwr_info.is_valid = true;
+		priv->clk_scaling.is_allowed = true;
 
 		ret = ufshcd_devfreq_init(hba);
 		if (ret)
 			goto out;
 
-		hba->clk_scaling.is_enabled = true;
+		priv->clk_scaling.is_enabled = true;
 		ufshcd_init_clk_scaling_sysfs(hba);
 	}
 
 	ufs_bsg_probe(hba);
 	ufshpb_init(hba);
-	scsi_scan_host(hba->host);
+	scsi_scan_host(priv->host);
 	pm_runtime_put_sync(hba->dev);
 
 out:
@@ -8117,11 +8261,12 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
  */
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret;
 	unsigned long flags;
 	ktime_t start = ktime_get();
 
-	hba->ufshcd_state = UFSHCD_STATE_RESET;
+	priv->ufshcd_state = UFSHCD_STATE_RESET;
 
 	ret = ufshcd_link_startup(hba);
 	if (ret)
@@ -8168,7 +8313,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 		 * Set the right value to bRefClkFreq before attempting to
 		 * switch to HS gears.
 		 */
-		if (hba->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
+		if (priv->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
 			ufshcd_set_dev_ref_clk(hba);
 		ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
 		if (ret) {
@@ -8188,19 +8333,19 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 	ufshcd_set_active_icc_lvl(hba);
 
 	ufshcd_wb_config(hba);
-	if (hba->ee_usr_mask)
+	if (priv->ee_usr_mask)
 		ufshcd_write_ee_control(hba);
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
 
 	ufshpb_toggle_state(hba, HPB_RESET, HPB_PRESENT);
 out:
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(priv->host->host_lock, flags);
 	if (ret)
-		hba->ufshcd_state = UFSHCD_STATE_ERROR;
-	else if (hba->ufshcd_state == UFSHCD_STATE_RESET)
-		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+		priv->ufshcd_state = UFSHCD_STATE_ERROR;
+	else if (priv->ufshcd_state == UFSHCD_STATE_RESET)
+		priv->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	trace_ufshcd_init(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
@@ -8216,12 +8361,13 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 {
 	struct ufs_hba *hba = (struct ufs_hba *)data;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret;
 
-	down(&hba->host_sem);
+	down(&priv->host_sem);
 	/* Initialize hba, detect and initialize UFS device */
 	ret = ufshcd_probe_hba(hba, true);
-	up(&hba->host_sem);
+	up(&priv->host_sem);
 	if (ret)
 		goto out;
 
@@ -8450,6 +8596,7 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
 
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret = 0;
 	struct ufs_clk_info *clki;
 	struct list_head *head = &hba->clk_list_head;
@@ -8502,11 +8649,11 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 				clk_disable_unprepare(clki->clk);
 		}
 	} else if (!ret && on) {
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		hba->clk_gating.state = CLKS_ON;
+		spin_lock_irqsave(priv->host->host_lock, flags);
+		priv->clk_gating.state = CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
-					hba->clk_gating.state);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+					priv->clk_gating.state);
+		spin_unlock_irqrestore(priv->host->host_lock, flags);
 	}
 
 	if (clk_state_changed)
@@ -8588,6 +8735,7 @@ static void ufshcd_variant_hba_exit(struct ufs_hba *hba)
 
 static int ufshcd_hba_init(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err;
 
 	/*
@@ -8627,7 +8775,7 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 
 	ufs_debugfs_hba_init(hba);
 
-	hba->is_powered = true;
+	priv->is_powered = true;
 	goto out;
 
 out_disable_vreg:
@@ -8642,17 +8790,19 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 
 static void ufshcd_hba_exit(struct ufs_hba *hba)
 {
-	if (hba->is_powered) {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	if (priv->is_powered) {
 		ufshcd_exit_clk_scaling(hba);
 		ufshcd_exit_clk_gating(hba);
-		if (hba->eh_wq)
-			destroy_workqueue(hba->eh_wq);
+		if (priv->eh_wq)
+			destroy_workqueue(priv->eh_wq);
 		ufs_debugfs_hba_exit(hba);
 		ufshcd_variant_hba_exit(hba);
 		ufshcd_setup_vreg(hba, false);
 		ufshcd_setup_clocks(hba, false);
 		ufshcd_setup_hba_vreg(hba, false);
-		hba->is_powered = false;
+		priv->is_powered = false;
 		ufs_put_device_desc(hba);
 	}
 }
@@ -8669,14 +8819,15 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 				     enum ufs_dev_pwr_mode pwr_mode)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	unsigned char cmd[6] = { START_STOP };
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
 	int ret, retries;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	sdp = hba->ufs_device_wlun;
+	spin_lock_irqsave(priv->host->host_lock, flags);
+	sdp = priv->ufs_device_wlun;
 	if (sdp) {
 		ret = scsi_device_get(sdp);
 		if (!ret && !scsi_device_online(sdp)) {
@@ -8686,7 +8837,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	} else {
 		ret = -ENODEV;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(priv->host->host_lock, flags);
 
 	if (ret)
 		return ret;
@@ -8697,7 +8848,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * we are functional while we are here, skip host resume in error
 	 * handling context.
 	 */
-	hba->host->eh_noresume = 1;
+	priv->host->eh_noresume = 1;
 
 	cmd[4] = pwr_mode << 4;
 
@@ -8729,7 +8880,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		hba->curr_dev_pwr_mode = pwr_mode;
 
 	scsi_device_put(sdp);
-	hba->host->eh_noresume = 0;
+	priv->host->eh_noresume = 0;
 	return ret;
 }
 
@@ -8737,6 +8888,7 @@ static int ufshcd_link_state_transition(struct ufs_hba *hba,
 					enum uic_link_state req_link_state,
 					int check_for_bkops)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret = 0;
 
 	if (req_link_state == hba->uic_link_state)
@@ -8758,7 +8910,7 @@ static int ufshcd_link_state_transition(struct ufs_hba *hba,
 	 * case of DeepSleep where the device is expected to remain powered.
 	 */
 	else if ((req_link_state == UIC_LINK_OFF_STATE) &&
-		 (!check_for_bkops || !hba->auto_bkops_enabled)) {
+		 (!check_for_bkops || !priv->auto_bkops_enabled)) {
 		/*
 		 * Let's make sure that link is in low power mode, we are doing
 		 * this currently by putting the link in Hibern8. Otherway to
@@ -8885,13 +9037,14 @@ static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba)
 
 static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret = 0;
 	int check_for_bkops;
 	enum ufs_pm_level pm_lvl;
 	enum ufs_dev_pwr_mode req_dev_pwr_mode;
 	enum uic_link_state req_link_state;
 
-	hba->pm_op_in_progress = true;
+	priv->pm_op_in_progress = true;
 	if (pm_op != UFS_SHUTDOWN_PM) {
 		pm_lvl = pm_op == UFS_RUNTIME_PM ?
 			 hba->rpm_lvl : hba->spm_lvl;
@@ -8909,7 +9062,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 * just gate the clocks.
 	 */
 	ufshcd_hold(hba, false);
-	hba->clk_gating.is_suspended = true;
+	priv->clk_gating.is_suspended = true;
 
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, true);
@@ -8949,14 +9102,14 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		 * and VCC supply.
 		 */
 		hba->dev_info.b_rpm_dev_flush_capable =
-			hba->auto_bkops_enabled ||
+			priv->auto_bkops_enabled ||
 			(((req_link_state == UIC_LINK_HIBERN8_STATE) ||
 			((req_link_state == UIC_LINK_ACTIVE_STATE) &&
 			ufshcd_is_auto_hibern8_enabled(hba))) &&
 			ufshcd_wb_need_flush(hba));
 	}
 
-	flush_work(&hba->eeh_work);
+	flush_work(&priv->eeh_work);
 
 	ret = ufshcd_vops_suspend(hba, pm_op, PRE_CHANGE);
 	if (ret)
@@ -9023,27 +9176,28 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->dev_info.b_rpm_dev_flush_capable = false;
 out:
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
-		schedule_delayed_work(&hba->rpm_dev_flush_recheck_work,
+		schedule_delayed_work(&priv->rpm_dev_flush_recheck_work,
 			msecs_to_jiffies(RPM_DEV_FLUSH_RECHECK_WORK_DELAY_MS));
 	}
 
 	if (ret) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_WL_SUSP_ERR, (u32)ret);
-		hba->clk_gating.is_suspended = false;
+		priv->clk_gating.is_suspended = false;
 		ufshcd_release(hba);
 		ufshpb_resume(hba);
 	}
-	hba->pm_op_in_progress = false;
+	priv->pm_op_in_progress = false;
 	return ret;
 }
 
 #ifdef CONFIG_PM
 static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret;
 	enum uic_link_state old_link_state = hba->uic_link_state;
 
-	hba->pm_op_in_progress = true;
+	priv->pm_op_in_progress = true;
 
 	/*
 	 * Call vendor specific resume callback. As these callbacks may access
@@ -9097,7 +9251,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		 */
 		ufshcd_urgent_bkops(hba);
 
-	if (hba->ee_usr_mask)
+	if (priv->ee_usr_mask)
 		ufshcd_write_ee_control(hba);
 
 	if (ufshcd_is_clkscaling_supported(hba))
@@ -9105,7 +9259,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
 		hba->dev_info.b_rpm_dev_flush_capable = false;
-		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
+		cancel_delayed_work(&priv->rpm_dev_flush_recheck_work);
 	}
 
 	/* Enable Auto-Hibernate if configured */
@@ -9122,9 +9276,9 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 out:
 	if (ret)
 		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
-	hba->clk_gating.is_suspended = false;
+	priv->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
-	hba->pm_op_in_progress = false;
+	priv->pm_op_in_progress = false;
 	return ret;
 }
 
@@ -9173,12 +9327,12 @@ static int ufshcd_wl_runtime_resume(struct device *dev)
 static int ufshcd_wl_suspend(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ufs_hba *hba;
+	struct ufs_hba *hba = shost_priv(sdev->host);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	hba = shost_priv(sdev->host);
-	down(&hba->host_sem);
+	down(&priv->host_sem);
 
 	if (pm_runtime_suspended(dev))
 		goto out;
@@ -9186,12 +9340,12 @@ static int ufshcd_wl_suspend(struct device *dev)
 	ret = __ufshcd_wl_suspend(hba, UFS_SYSTEM_PM);
 	if (ret) {
 		dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__,  ret);
-		up(&hba->host_sem);
+		up(&priv->host_sem);
 	}
 
 out:
 	if (!ret)
-		hba->is_sys_suspended = true;
+		priv->is_sys_suspended = true;
 	trace_ufshcd_wl_suspend(dev_name(dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
@@ -9202,12 +9356,11 @@ static int ufshcd_wl_suspend(struct device *dev)
 static int ufshcd_wl_resume(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ufs_hba *hba;
+	struct ufs_hba *hba = shost_priv(sdev->host);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	hba = shost_priv(sdev->host);
-
 	if (pm_runtime_suspended(dev))
 		goto out;
 
@@ -9219,8 +9372,8 @@ static int ufshcd_wl_resume(struct device *dev)
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
-		hba->is_sys_suspended = false;
-	up(&hba->host_sem);
+		priv->is_sys_suspended = false;
+	up(&priv->host_sem);
 	return ret;
 }
 #endif
@@ -9228,19 +9381,18 @@ static int ufshcd_wl_resume(struct device *dev)
 static void ufshcd_wl_shutdown(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ufs_hba *hba;
-
-	hba = shost_priv(sdev->host);
+	struct ufs_hba *hba = shost_priv(sdev->host);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	down(&hba->host_sem);
-	hba->shutting_down = true;
-	up(&hba->host_sem);
+	down(&priv->host_sem);
+	priv->shutting_down = true;
+	up(&priv->host_sem);
 
 	/* Turn on everything while shutting down */
 	ufshcd_rpm_get_sync(hba);
 	scsi_device_quiesce(sdev);
-	shost_for_each_device(sdev, hba->host) {
-		if (sdev == hba->ufs_device_wlun)
+	shost_for_each_device(sdev, priv->host) {
+		if (sdev == priv->ufs_device_wlun)
 			continue;
 		scsi_device_quiesce(sdev);
 	}
@@ -9256,9 +9408,10 @@ static void ufshcd_wl_shutdown(struct device *dev)
  */
 static int ufshcd_suspend(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret;
 
-	if (!hba->is_powered)
+	if (!priv->is_powered)
 		return 0;
 	/*
 	 * Disable the host irq as host controller as there won't be any
@@ -9271,9 +9424,9 @@ static int ufshcd_suspend(struct ufs_hba *hba)
 		return ret;
 	}
 	if (ufshcd_is_clkgating_allowed(hba)) {
-		hba->clk_gating.state = CLKS_OFF;
+		priv->clk_gating.state = CLKS_OFF;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
-					hba->clk_gating.state);
+					priv->clk_gating.state);
 	}
 
 	ufshcd_vreg_set_lpm(hba);
@@ -9294,9 +9447,10 @@ static int ufshcd_suspend(struct ufs_hba *hba)
  */
 static int ufshcd_resume(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret;
 
-	if (!hba->is_powered)
+	if (!priv->is_powered)
 		return 0;
 
 	ufshcd_hba_vreg_set_hpm(hba);
@@ -9441,6 +9595,8 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
  */
 int ufshcd_shutdown(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
 	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
 		goto out;
 
@@ -9448,7 +9604,7 @@ int ufshcd_shutdown(struct ufs_hba *hba)
 
 	ufshcd_suspend(hba);
 out:
-	hba->is_powered = false;
+	priv->is_powered = false;
 	/* allow force shutdown even in case of errors */
 	return 0;
 }
@@ -9461,17 +9617,19 @@ EXPORT_SYMBOL(ufshcd_shutdown);
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
-	if (hba->ufs_device_wlun)
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	if (priv->ufs_device_wlun)
 		ufshcd_rpm_get_sync(hba);
 	ufs_hwmon_remove(hba);
 	ufs_bsg_remove(hba);
 	ufshpb_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
-	blk_cleanup_queue(hba->tmf_queue);
-	blk_mq_free_tag_set(&hba->tmf_tag_set);
-	scsi_remove_host(hba->host);
+	blk_cleanup_queue(priv->tmf_queue);
+	blk_mq_free_tag_set(&priv->tmf_tag_set);
+	scsi_remove_host(priv->host);
 	/* disable interrupts */
-	ufshcd_disable_intr(hba, hba->intr_mask);
+	ufshcd_disable_intr(hba, priv->intr_mask);
 	ufshcd_hba_stop(hba);
 	ufshcd_hba_exit(hba);
 }
@@ -9483,7 +9641,9 @@ EXPORT_SYMBOL_GPL(ufshcd_remove);
  */
 void ufshcd_dealloc_host(struct ufs_hba *hba)
 {
-	scsi_host_put(hba->host);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	scsi_host_put(priv->host);
 }
 EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
 
@@ -9513,6 +9673,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 {
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
+	struct ufs_hba_priv *priv;
 	int err = 0;
 
 	if (!dev) {
@@ -9523,7 +9684,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	}
 
 	host = scsi_host_alloc(&ufshcd_driver_template,
-				sizeof(struct ufs_hba));
+				sizeof(struct ufs_hba_priv));
 	if (!host) {
 		dev_err(dev, "scsi_host_alloc failed\n");
 		err = -ENOMEM;
@@ -9531,12 +9692,13 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	}
 	host->nr_maps = HCTX_TYPE_POLL + 1;
 	hba = shost_priv(host);
-	hba->host = host;
+	priv = container_of(hba, typeof(*priv), hba);
+	priv->host = host;
 	hba->dev = dev;
-	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
+	priv->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
 	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
 	INIT_LIST_HEAD(&hba->clk_list_head);
-	spin_lock_init(&hba->outstanding_lock);
+	spin_lock_init(&priv->outstanding_lock);
 
 	*hba_handle = hba;
 
@@ -9566,8 +9728,9 @@ static const struct blk_mq_ops ufshcd_tmf_ops = {
  */
 int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int err;
-	struct Scsi_Host *host = hba->host;
+	struct Scsi_Host *host = priv->host;
 	struct device *dev = hba->dev;
 	char eh_wq_name[sizeof("ufs_eh_wq_00")];
 
@@ -9602,7 +9765,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->ufs_version = ufshcd_get_ufs_version(hba);
 
 	/* Get Interrupt bit mask per version */
-	hba->intr_mask = ufshcd_get_intr_mask(hba);
+	priv->intr_mask = ufshcd_get_intr_mask(hba);
 
 	err = ufshcd_set_dma_mask(hba);
 	if (err) {
@@ -9632,29 +9795,29 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	/* Initialize work queues */
 	snprintf(eh_wq_name, sizeof(eh_wq_name), "ufs_eh_wq_%d",
-		 hba->host->host_no);
-	hba->eh_wq = create_singlethread_workqueue(eh_wq_name);
-	if (!hba->eh_wq) {
+		 priv->host->host_no);
+	priv->eh_wq = create_singlethread_workqueue(eh_wq_name);
+	if (!priv->eh_wq) {
 		dev_err(hba->dev, "%s: failed to create eh workqueue\n",
 			__func__);
 		err = -ENOMEM;
 		goto out_disable;
 	}
-	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
-	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
+	INIT_WORK(&priv->eh_work, ufshcd_err_handler);
+	INIT_WORK(&priv->eeh_work, ufshcd_exception_event_handler);
 
-	sema_init(&hba->host_sem, 1);
+	sema_init(&priv->host_sem, 1);
 
 	/* Initialize UIC command mutex */
-	mutex_init(&hba->uic_cmd_mutex);
+	mutex_init(&priv->uic_cmd_mutex);
 
 	/* Initialize mutex for device management commands */
-	mutex_init(&hba->dev_cmd.lock);
+	mutex_init(&priv->dev_cmd.lock);
 
 	/* Initialize mutex for exception event control */
-	mutex_init(&hba->ee_ctrl_mutex);
+	mutex_init(&priv->ee_ctrl_mutex);
 
-	init_rwsem(&hba->clk_scaling_lock);
+	init_rwsem(&priv->clk_scaling_lock);
 
 	ufshcd_init_clk_gating(hba);
 
@@ -9689,23 +9852,23 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto out_disable;
 	}
 
-	hba->tmf_tag_set = (struct blk_mq_tag_set) {
+	priv->tmf_tag_set = (struct blk_mq_tag_set) {
 		.nr_hw_queues	= 1,
 		.queue_depth	= hba->nutmrs,
 		.ops		= &ufshcd_tmf_ops,
 		.flags		= BLK_MQ_F_NO_SCHED,
 	};
-	err = blk_mq_alloc_tag_set(&hba->tmf_tag_set);
+	err = blk_mq_alloc_tag_set(&priv->tmf_tag_set);
 	if (err < 0)
 		goto out_remove_scsi_host;
-	hba->tmf_queue = blk_mq_init_queue(&hba->tmf_tag_set);
-	if (IS_ERR(hba->tmf_queue)) {
-		err = PTR_ERR(hba->tmf_queue);
+	priv->tmf_queue = blk_mq_init_queue(&priv->tmf_tag_set);
+	if (IS_ERR(priv->tmf_queue)) {
+		err = PTR_ERR(priv->tmf_queue);
 		goto free_tmf_tag_set;
 	}
-	hba->tmf_rqs = devm_kcalloc(hba->dev, hba->nutmrs,
-				    sizeof(*hba->tmf_rqs), GFP_KERNEL);
-	if (!hba->tmf_rqs) {
+	priv->tmf_rqs = devm_kcalloc(hba->dev, hba->nutmrs,
+				    sizeof(*priv->tmf_rqs), GFP_KERNEL);
+	if (!priv->tmf_rqs) {
 		err = -ENOMEM;
 		goto free_tmf_queue;
 	}
@@ -9736,7 +9899,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
 
-	INIT_DELAYED_WORK(&hba->rpm_dev_flush_recheck_work,
+	INIT_DELAYED_WORK(&priv->rpm_dev_flush_recheck_work,
 			  ufshcd_rpm_dev_flush_recheck_work);
 
 	/* Set the default auto-hiberate idle timer value to 150 ms */
@@ -9747,7 +9910,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
-	atomic_set(&hba->scsi_block_reqs_cnt, 0);
+	atomic_set(&priv->scsi_block_reqs_cnt, 0);
 	/*
 	 * We are assuming that device wasn't put in sleep/power-down
 	 * state exclusively during the boot stage before kernel.
@@ -9763,11 +9926,11 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	return 0;
 
 free_tmf_queue:
-	blk_cleanup_queue(hba->tmf_queue);
+	blk_cleanup_queue(priv->tmf_queue);
 free_tmf_tag_set:
-	blk_mq_free_tag_set(&hba->tmf_tag_set);
+	blk_mq_free_tag_set(&priv->tmf_tag_set);
 out_remove_scsi_host:
-	scsi_remove_host(hba->host);
+	scsi_remove_host(priv->host);
 out_disable:
 	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
@@ -9779,17 +9942,19 @@ EXPORT_SYMBOL_GPL(ufshcd_init);
 void ufshcd_resume_complete(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 
-	if (hba->complete_put) {
+	if (priv->complete_put) {
 		ufshcd_rpm_put(hba);
-		hba->complete_put = false;
+		priv->complete_put = false;
 	}
 }
 EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
 
 static bool ufshcd_rpm_ok_for_spm(struct ufs_hba *hba)
 {
-	struct device *dev = &hba->ufs_device_wlun->sdev_gendev;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct device *dev = &priv->ufs_device_wlun->sdev_gendev;
 	enum ufs_dev_pwr_mode dev_pwr_mode;
 	enum uic_link_state link_state;
 	unsigned long flags;
@@ -9810,6 +9975,7 @@ static bool ufshcd_rpm_ok_for_spm(struct ufs_hba *hba)
 int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int ret;
 
 	/*
@@ -9818,7 +9984,7 @@ int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm)
 	 * if it's runtime suspended. But ufs doesn't follow that.
 	 * Refer ufshcd_resume_complete()
 	 */
-	if (hba->ufs_device_wlun) {
+	if (priv->ufs_device_wlun) {
 		/* Prevent runtime suspend */
 		ufshcd_rpm_get_noresume(hba);
 		/*
@@ -9833,7 +9999,7 @@ int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm)
 				return ret;
 			}
 		}
-		hba->complete_put = true;
+		priv->complete_put = true;
 	}
 	return 0;
 }
diff --git a/drivers/ufs/core/ufshpb.c b/drivers/ufs/core/ufshpb.c
index aee0ec4cee70..298f88c89b21 100644
--- a/drivers/ufs/core/ufshpb.c
+++ b/drivers/ufs/core/ufshpb.c
@@ -40,13 +40,17 @@ static void ufshpb_update_active_info(struct ufshpb_lu *hpb, int rgn_idx,
 
 bool ufshpb_is_allowed(struct ufs_hba *hba)
 {
-	return !(hba->ufshpb_dev.hpb_disabled);
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	return !priv->hpb_dev.hpb_disabled;
 }
 
 /* HPB version 1.0 is called as legacy version. */
 bool ufshpb_is_legacy(struct ufs_hba *hba)
 {
-	return hba->ufshpb_dev.is_legacy;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+
+	return priv->hpb_dev.is_legacy;
 }
 
 static struct ufshpb_lu *ufshpb_get_hpb_data(struct scsi_device *sdev)
@@ -1260,10 +1264,11 @@ static void ufshpb_set_regions_update(struct ufshpb_lu *hpb)
 
 static void ufshpb_dev_reset_handler(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct scsi_device *sdev;
 	struct ufshpb_lu *hpb;
 
-	__shost_for_each_device(sdev, hba->host) {
+	__shost_for_each_device(sdev, priv->host) {
 		hpb = ufshpb_get_hpb_data(sdev);
 		if (!hpb)
 			continue;
@@ -1300,6 +1305,7 @@ static void ufshpb_dev_reset_handler(struct ufs_hba *hba)
  */
 void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(lrbp->cmd->device);
 	struct utp_hpb_rsp *rsp_field = &lrbp->ucd_rsp_ptr->hr;
 	int data_seg_len;
@@ -1308,7 +1314,7 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		struct scsi_device *sdev;
 		bool found = false;
 
-		__shost_for_each_device(sdev, hba->host) {
+		__shost_for_each_device(sdev, priv->host) {
 			hpb = ufshpb_get_hpb_data(sdev);
 
 			if (!hpb)
@@ -2325,10 +2331,11 @@ static bool ufshpb_check_hpb_reset_query(struct ufs_hba *hba)
  */
 void ufshpb_toggle_state(struct ufs_hba *hba, enum UFSHPB_STATE src, enum UFSHPB_STATE dest)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufshpb_lu *hpb;
 	struct scsi_device *sdev;
 
-	shost_for_each_device(sdev, hba->host) {
+	shost_for_each_device(sdev, priv->host) {
 		hpb = ufshpb_get_hpb_data(sdev);
 
 		if (!hpb || ufshpb_get_state(hpb) != src)
@@ -2344,10 +2351,11 @@ void ufshpb_toggle_state(struct ufs_hba *hba, enum UFSHPB_STATE src, enum UFSHPB
 
 void ufshpb_suspend(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufshpb_lu *hpb;
 	struct scsi_device *sdev;
 
-	shost_for_each_device(sdev, hba->host) {
+	shost_for_each_device(sdev, priv->host) {
 		hpb = ufshpb_get_hpb_data(sdev);
 		if (!hpb || ufshpb_get_state(hpb) != HPB_PRESENT)
 			continue;
@@ -2359,10 +2367,11 @@ void ufshpb_suspend(struct ufs_hba *hba)
 
 void ufshpb_resume(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufshpb_lu *hpb;
 	struct scsi_device *sdev;
 
-	shost_for_each_device(sdev, hba->host) {
+	shost_for_each_device(sdev, priv->host) {
 		hpb = ufshpb_get_hpb_data(sdev);
 		if (!hpb || ufshpb_get_state(hpb) != HPB_SUSPEND)
 			continue;
@@ -2451,6 +2460,7 @@ void ufshpb_destroy_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 
 static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	int pool_size;
 	struct ufshpb_lu *hpb;
 	struct scsi_device *sdev;
@@ -2469,7 +2479,7 @@ static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba)
 		mempool_resize(ufshpb_page_pool, tot_active_srgn_pages);
 	}
 
-	shost_for_each_device(sdev, hba->host) {
+	shost_for_each_device(sdev, priv->host) {
 		hpb = ufshpb_get_hpb_data(sdev);
 		if (!hpb)
 			continue;
@@ -2490,6 +2500,7 @@ static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba)
 
 void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 {
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
 	struct ufshpb_lu *hpb;
 	int ret;
 	struct ufshpb_lu_info hpb_lu_info = { 0 };
@@ -2502,7 +2513,7 @@ void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 	if (ret)
 		goto out;
 
-	hpb = ufshpb_alloc_hpb_lu(hba, sdev, &hba->ufshpb_dev,
+	hpb = ufshpb_alloc_hpb_lu(hba, sdev, &priv->hpb_dev,
 				  &hpb_lu_info);
 	if (!hpb)
 		goto out;
@@ -2512,7 +2523,7 @@ void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 
 out:
 	/* All LUs are initialized */
-	if (atomic_dec_and_test(&hba->ufshpb_dev.slave_conf_cnt))
+	if (atomic_dec_and_test(&priv->hpb_dev.slave_conf_cnt))
 		ufshpb_hpb_lu_prepared(hba);
 }
 
@@ -2569,7 +2580,8 @@ static int ufshpb_init_mem_wq(struct ufs_hba *hba)
 
 void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf)
 {
-	struct ufshpb_dev_info *hpb_info = &hba->ufshpb_dev;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufshpb_dev_info *hpb_info = &priv->hpb_dev;
 	int max_active_rgns = 0;
 	int hpb_num_lu;
 
@@ -2595,7 +2607,8 @@ void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf)
 
 void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 {
-	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufshpb_dev_info *hpb_dev_info = &priv->hpb_dev;
 	int version, ret;
 	int max_single_cmd;
 
@@ -2633,7 +2646,8 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 
 void ufshpb_init(struct ufs_hba *hba)
 {
-	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
+	struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
+	struct ufshpb_dev_info *hpb_dev_info = &priv->hpb_dev;
 	int try;
 	int ret;
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a92271421718..c90220fa7bcd 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -702,73 +702,27 @@ struct ufs_hba_monitor {
 };
 
 /**
- * struct ufs_hba - per adapter private structure
+ * struct ufs_hba - Host controller data shared between core and drivers
  * @mmio_base: UFSHCI base register address
- * @ucdl_base_addr: UFS Command Descriptor base address
- * @utrdl_base_addr: UTP Transfer Request Descriptor base address
- * @utmrdl_base_addr: UTP Task Management Descriptor base address
- * @ucdl_dma_addr: UFS Command Descriptor DMA address
- * @utrdl_dma_addr: UTRDL DMA address
- * @utmrdl_dma_addr: UTMRDL DMA address
- * @host: Scsi_Host instance of the driver
  * @dev: device handle
- * @ufs_device_wlun: WLUN that controls the entire UFS device.
- * @hwmon_device: device instance registered with the hwmon core.
  * @curr_dev_pwr_mode: active UFS device power mode.
  * @uic_link_state: active state of the link to the UFS device.
  * @rpm_lvl: desired UFS power management level during runtime PM.
  * @spm_lvl: desired UFS power management level during system PM.
- * @pm_op_in_progress: whether or not a PM operation is in progress.
  * @ahit: value of Auto-Hibernate Idle Timer register.
- * @lrb: local reference block
- * @outstanding_tasks: Bits representing outstanding task requests
- * @outstanding_lock: Protects @outstanding_reqs.
- * @outstanding_reqs: Bits representing outstanding transfer requests
  * @capabilities: UFS Controller Capabilities
  * @nutrs: Transfer Request Queue depth supported by controller
  * @nutmrs: Task Management Queue depth supported by controller
- * @reserved_slot: Used to submit device commands. Protected by @dev_cmd.lock.
  * @ufs_version: UFS Version to which controller complies
  * @vops: pointer to variant specific operations
  * @vps: pointer to variant specific parameters
  * @priv: pointer to variant specific private data
  * @irq: Irq number of the controller
  * @is_irq_enabled: whether or not the UFS controller interrupt is enabled.
- * @dev_ref_clk_freq: reference clock frequency
  * @quirks: bitmask with information about deviations from the UFSHCI standard.
  * @dev_quirks: bitmask with information about deviations from the UFS standard.
- * @tmf_tag_set: TMF tag set.
- * @tmf_queue: Used to allocate TMF tags.
- * @tmf_rqs: array with pointers to TMF requests while these are in progress.
- * @active_uic_cmd: handle of active UIC command
- * @uic_cmd_mutex: mutex for UIC command
- * @uic_async_done: completion used during UIC processing
- * @ufshcd_state: UFSHCD state
- * @eh_flags: Error handling flags
- * @intr_mask: Interrupt Mask Bits
- * @ee_ctrl_mask: Exception event control mask
- * @ee_drv_mask: Exception event mask for driver
- * @ee_usr_mask: Exception event mask for user (set via debugfs)
- * @ee_ctrl_mutex: Used to serialize exception event information.
- * @is_powered: flag to check if HBA is powered
- * @shutting_down: flag to check if shutdown has been invoked
- * @host_sem: semaphore used to serialize concurrent contexts
- * @eh_wq: Workqueue that eh_work works on
- * @eh_work: Worker to handle UFS errors that require s/w attention
- * @eeh_work: Worker to handle exception events
- * @errors: HBA errors
- * @uic_error: UFS interconnect layer error status
- * @saved_err: sticky error mask
- * @saved_uic_err: sticky UIC error mask
- * @ufs_stats: various error counters
- * @force_reset: flag to force eh_work perform a full reset
- * @force_pmc: flag to force a power mode change
- * @silence_err_logs: flag to silence error logs
- * @dev_cmd: ufs device management command information
- * @last_dme_cmd_tstamp: time stamp of the last completed DME command
  * @nop_out_timeout: NOP OUT timeout value
  * @dev_info: information about the UFS device
- * @auto_bkops_enabled: to track whether bkops is enabled in device
  * @vreg_info: UFS device voltage regulator information
  * @clk_list_head: UFS host controller clocks list node head
  * @req_abort_count: number of times ufshcd_abort() has been called
@@ -776,134 +730,41 @@ struct ufs_hba_monitor {
  *	controller and the UFS device.
  * @pwr_info: holds current power mode
  * @max_pwr_info: keeps the device max valid pwm
- * @clk_gating: information related to clock gating
  * @caps: bitmask with information about UFS controller capabilities
- * @devfreq: frequency scaling information owned by the devfreq core
- * @clk_scaling: frequency scaling information owned by the UFS driver
- * @is_sys_suspended: whether or not the entire system has been suspended
- * @urgent_bkops_lvl: keeps track of urgent bkops level for device
- * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
- *  device is known or not.
- * @clk_scaling_lock: used to serialize device commands and clock scaling
- * @desc_size: descriptor sizes reported by device
- * @scsi_block_reqs_cnt: reference counting for scsi block requests
- * @bsg_dev: struct device associated with the BSG queue
- * @bsg_queue: BSG queue associated with the UFS controller
- * @rpm_dev_flush_recheck_work: used to suspend from RPM (runtime power
- *	management) after the UFS device has finished a WriteBooster buffer
- *	flush or auto BKOP.
- * @ufshpb_dev: information related to HPB (Host Performance Booster).
- * @monitor: statistics about UFS commands
- * @crypto_capabilities: Content of crypto capabilities register (0x100)
  * @crypto_cap_array: Array of crypto capabilities
- * @crypto_cfg_register: Start of the crypto cfg array
- * @crypto_profile: the crypto profile of this hba (if applicable)
- * @debugfs_root: UFS controller debugfs root directory
- * @debugfs_ee_work: used to restore ee_ctrl_mask after a delay
- * @debugfs_ee_rate_limit_ms: user configurable delay after which to restore
- *	ee_ctrl_mask
- * @luns_avail: number of regular and well known LUNs supported by the UFS
- *	device
- * @complete_put: whether or not to call ufshcd_rpm_put() from inside
- *	ufshcd_resume_complete()
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
 
-	/* Virtual memory reference */
-	struct utp_transfer_cmd_desc *ucdl_base_addr;
-	struct utp_transfer_req_desc *utrdl_base_addr;
-	struct utp_task_req_desc *utmrdl_base_addr;
-
-	/* DMA memory reference */
-	dma_addr_t ucdl_dma_addr;
-	dma_addr_t utrdl_dma_addr;
-	dma_addr_t utmrdl_dma_addr;
-
-	struct Scsi_Host *host;
 	struct device *dev;
-	struct scsi_device *ufs_device_wlun;
-
-#ifdef CONFIG_SCSI_UFS_HWMON
-	struct device *hwmon_device;
-#endif
 
 	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
 	enum uic_link_state uic_link_state;
-	/* Desired UFS power management level during runtime PM */
 	enum ufs_pm_level rpm_lvl;
-	/* Desired UFS power management level during system PM */
 	enum ufs_pm_level spm_lvl;
-	int pm_op_in_progress;
 
 	/* Auto-Hibernate Idle Timer register value */
 	u32 ahit;
 
-	struct ufshcd_lrb *lrb;
-
-	unsigned long outstanding_tasks;
-	spinlock_t outstanding_lock;
-	unsigned long outstanding_reqs;
-
 	u32 capabilities;
 	int nutrs;
 	int nutmrs;
-	u32 reserved_slot;
 	u32 ufs_version;
 	const struct ufs_hba_variant_ops *vops;
 	struct ufs_hba_variant_params *vps;
 	void *priv;
 	unsigned int irq;
 	bool is_irq_enabled;
-	enum ufs_ref_clk_freq dev_ref_clk_freq;
 
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	/* Device deviations from standard UFS device spec. */
 	unsigned int dev_quirks;
 
-	struct blk_mq_tag_set tmf_tag_set;
-	struct request_queue *tmf_queue;
-	struct request **tmf_rqs;
-
-	struct uic_command *active_uic_cmd;
-	struct mutex uic_cmd_mutex;
-	struct completion *uic_async_done;
-
-	enum ufshcd_state ufshcd_state;
-	u32 eh_flags;
-	u32 intr_mask;
-	u16 ee_ctrl_mask;
-	u16 ee_drv_mask;
-	u16 ee_usr_mask;
-	struct mutex ee_ctrl_mutex;
-	bool is_powered;
-	bool shutting_down;
-	struct semaphore host_sem;
-
-	/* Work Queues */
-	struct workqueue_struct *eh_wq;
-	struct work_struct eh_work;
-	struct work_struct eeh_work;
-
-	/* HBA Errors */
-	u32 errors;
-	u32 uic_error;
-	u32 saved_err;
-	u32 saved_uic_err;
-	struct ufs_stats ufs_stats;
-	bool force_reset;
-	bool force_pmc;
-	bool silence_err_logs;
-
-	/* Device management request data */
-	struct ufs_dev_cmd dev_cmd;
-	ktime_t last_dme_cmd_tstamp;
 	int nop_out_timeout;
 
 	/* Keeps information of the UFS device connected to this host */
 	struct ufs_dev_info dev_info;
-	bool auto_bkops_enabled;
 	struct ufs_vreg_info vreg_info;
 	struct list_head clk_list_head;
 
@@ -915,44 +776,12 @@ struct ufs_hba {
 	struct ufs_pa_layer_attr pwr_info;
 	struct ufs_pwr_mode_info max_pwr_info;
 
-	struct ufs_clk_gating clk_gating;
 	/* Control to enable/disable host capabilities */
 	u32 caps;
 
-	struct devfreq *devfreq;
-	struct ufs_clk_scaling clk_scaling;
-	bool is_sys_suspended;
-
-	enum bkops_status urgent_bkops_lvl;
-	bool is_urgent_bkops_lvl_checked;
-
-	struct rw_semaphore clk_scaling_lock;
-	unsigned char desc_size[QUERY_DESC_IDN_MAX];
-	atomic_t scsi_block_reqs_cnt;
-
-	struct device		bsg_dev;
-	struct request_queue	*bsg_queue;
-	struct delayed_work rpm_dev_flush_recheck_work;
-
-#ifdef CONFIG_SCSI_UFS_HPB
-	struct ufshpb_dev_info ufshpb_dev;
-#endif
-
-	struct ufs_hba_monitor	monitor;
-
 #ifdef CONFIG_SCSI_UFS_CRYPTO
-	union ufs_crypto_capabilities crypto_capabilities;
 	union ufs_crypto_cap_entry *crypto_cap_array;
-	u32 crypto_cfg_register;
-	struct blk_crypto_profile crypto_profile;
-#endif
-#ifdef CONFIG_DEBUG_FS
-	struct dentry *debugfs_root;
-	struct delayed_work debugfs_ee_work;
-	u32 debugfs_ee_rate_limit_ms;
 #endif
-	u32 luns_avail;
-	bool complete_put;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
@@ -1224,7 +1053,5 @@ int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 
 int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask);
 int ufshcd_write_ee_control(struct ufs_hba *hba);
-int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask, u16 *other_mask,
-			     u16 set, u16 clr);
 
 #endif /* End of Header */
