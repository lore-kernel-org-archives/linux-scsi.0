Received: from mail-pz2-f18.google.com (mail-pz2-f18.google.com [74.125.228.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03F64A1DFD
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 14:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789484155; cv=none; b=Vse3UxneLpmEnx/I7IgL3mZpa4GBDkQ9x6hpaj9jKC+H5MtgnS7QWuF1YoVbtepdB4SDeXHfmGWiBFwfW7603Jgz4C1BJMybFZ3M8bvFGqCETMW+M5DKaSV0GgCpvUAhJOifN/14BdKtSxYpiSXU/BhgXVZ9Sk2bA8zMoXshc/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789484155; c=relaxed/simple;
	bh=OspN7MKSFmprrrS2PxdNlMmUOibbtdADDRJnLjEgeMQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XA8mnWGFo+OkGkW72r8rei1eZD9T5j63/Rfcym3yAAeUVg6LHmgIMXVA/FWq3PT99mhSa9KHvYrSDUELiurj5HRos6Eqj49W9o6yXTyJT16A1d3DDpbqBbcBcS1QzDd6V0LvLeRFX1nNdeLXGSuJMPgPUtLt20K0nMs6riViDrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TNx/f90D; arc=none smtp.client-ip=74.125.228.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TNx/f90D"
Received: by mail-pz2-f18.google.com with SMTP id 41be03b00d2f7-cc4bdf8abaaso3117274a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 07:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789484143; x=1790088943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dMa7SuymF3JpSxZj/WgqSEvagr3KGVZWyIDh4Tap88k=;
        b=TNx/f90DMqIuNKVKnKHS5oCTbdnZ4W8i0bJGvDq8ggz2+Gariop3eieBTLSL6hQSzb
         QHhaca+RLfM13+VFB8PnRdhxcsGG2sh5XBovXTv5BKS66Qi9hYd+P3PbYYMb92ULN9go
         qydPvcPRJDiJG6OQtgcDrALriBoDSm9y5ODQECRMsPKs9uEXg15z1r6ZNz4JFW126FkI
         oREcQMGlZ22nJsxMSXTTZVFKPEUEYRCpBJhb+z8MHRNtb2gCrFaN9f9edQrXz+e/JjYG
         66Zy070a8h44YznJv7PSWTxxVcBXDK40DTGQ7KLQJVpPEFZtyoAQ/MWyMdYM1WpJqvH3
         bXmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789484143; x=1790088943;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dMa7SuymF3JpSxZj/WgqSEvagr3KGVZWyIDh4Tap88k=;
        b=vTcqB5IZECBY2EMaY13fOX0J37l5ACorZh59Pr8XxIBzUS3nzqqj/IXpMxX02dXRUO
         CipbL0EnxTH1TQ8mygpdqMj/GAJjkDODWFccVvmSoC+BHowrsB6XPnDNNqGwNPffDtcl
         IfJqakKM27IlahY+lZMj4ETLzvlb72mom2MhCyhfWyYTBsXjcd/6AbfnQG4p0eWjZM+U
         H6pGuOhslmhgsC+VCsuFdloTBCISMoJYncvvtyucAaT5CXnB1fQTh8//lGhfk1jaXdQk
         YtH9+kAUI5J26FyL2qJWGtx5enASX5O4/KBUtcQfxm7bh53s9BkA8o49w68FB/OYJ1GA
         7E/w==
X-Gm-Message-State: AFuF++kWJkDTfrXyBRFcd4uGJUDECozZb0SnpGyLyUUVNifMw/6vv9C0
	BVeaWCD0RTtk63IWWnH7sU/ok+RKq+3AXJaZGSSDcpU8FvA0XmLsJvon
X-Gm-Gg: AYBFou2K90+FuXwUhpdrI8Mn4L7RulKHcxB7HkFoJEdNBS0LDQ/0bu+onUYFJAwJ/ek
	P/npz7FF8eWmXED9TlNafv1bQAD2vZLL7s3ws7jfQdqAHOQLABG6FP23s1luO9noqtEstQGFpuy
	Y6LudwuHmBJHVW1kGCmvvCZDBwwG46BFWVISPYHZiv0tiz2oLqGYG6NLK3qdcIbmOrPzYperUm1
	unmWr4fgVkDBpnSgh3K6v+QMRRb4j94LPfzh9DaQdwMeximXsMQ1sstNIbhchKhDnZtdbzfs7V8
	k5jBFUS9CGaVHaXOsGYr9+n1ER+7J6tMWLxvIKsm6LoIMsQWl1kg20cji03jHYAMRyyYhSBSyhb
	D4Fr3NdIpLhwwVHPdTorlV0uGgp1ThUOV/F/FmtTkXxPnxHjOcBmDdyhkEbeP1mCLaAiHQoNIz5
	qH/2nEufsAX99rUP8QrwNbYoaWIMLugBn1FWgPhp+Lhpezqm//m1FaanWLuyk3rVYt8kW9OMxo9
	/z9u3APmP9HPTcTo3IAMZpWCdBA5F07gkyIchTFUdjxzkOiS2r+OypuwUFUmRg7nJFcKsgrcv83
	f0lJyMPEWxgl0Aiug4Os
X-Received: by 2002:a05:6a20:6f07:b0:3b4:7e2d:a3c2 with SMTP id adf61e73a8af0-3db4053d971mr16732114637.18.1789484142880;
        Tue, 15 Sep 2026 07:55:42 -0700 (PDT)
Received: from NV-9MNJ414.tailae2068.ts.net (2001-b011-2005-787e-21e6-43b5-0185-f167.dynamic-ip6.hinet.net. [2001:b011:2005:787e:21e6:43b5:185:f167])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc50ab50d67sm44722a12.6.2026.09.15.07.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 07:55:42 -0700 (PDT)
From: Yiwei Lin <s921975628@gmail.com>
To: alim.akhtar@samsung.com,
	avri.altman@sandisk.com,
	bvanassche@acm.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	robelin <robelin@nvidia.com>,
	Yiwei Lin <s921975628@gmail.com>
Subject: [PATCH v2] ufs: sysfs: fix current_power_mode read without SSU
Date: Tue, 15 Sep 2026 22:55:34 +0800
Message-Id: <20260915145534.8517-1-s921975628@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: robelin <robelin@nvidia.com>

current_power_mode was generated by UFS_ATTRIBUTE(), which calls
ufshcd_rpm_get_sync() before issuing the query.  That resumes the UFS
device WLUN, and ufshcd_wl_runtime_resume() sends START STOP UNIT to
bring the device back to Active.  As a result bCurrentPowerMode always
read back as 0x11 (Active) no matter what state the device was actually
in: the act of reading the attribute woke the device, so Sleep could
never be observed through sysfs.

Per the UFS spec, bCurrentPowerMode is the one attribute the device
must answer in any power mode, so there is no need to wake it.  Give
current_power_mode its own show function that deliberately does not
resume the WLUN.  It only resumes the host controller then reads the
attribute over whatever link state the WLUN suspend left behind:

 - link active: query directly.
 - link in Hibern8: exit Hibern8, query, then re-enter Hibern8 so the
   link is left exactly as rpm_lvl requested.
 - device powered down or link off (rpm_lvl 4/5/6): fail, the device
   cannot answer without a full resume.

Tested on hardware: with the device runtime-suspended (wb_on=0, so the
device actually reaches Sleep instead of being held Active for a WB
flush), reading current_power_mode used to return 0x11; after this
change it returns 0x22 (Sleep), matching the device's real state.

Assisted-by: LLM
Signed-off-by: Yiwei Lin <s921975628@gmail.com>

---
Change-Logs in V2:
- Synchonize the race between WLUN suspend/resume and other contexts
  that change the link power state.
- Restore UFS link if exiting Hibern8 for the query, then re-enter Hibern8 so the link   is left exactly as rpm_lvl requested.

---
 drivers/ufs/core/ufs-sysfs.c   | 74 +++++++++++++++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h | 11 +++++
 drivers/ufs/core/ufshcd.c      | 12 +++---
 include/ufs/ufshcd.h           |  3 ++
 4 files changed, 94 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 63e670d1a9d9e..a500ca697e5d3 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1786,7 +1786,79 @@ out:									\
 static DEVICE_ATTR_RO(_name)
 
 UFS_ATTRIBUTE(boot_lun_enabled, _BOOT_LU_EN);
-UFS_ATTRIBUTE(current_power_mode, _POWER_MODE);
+
+/*
+ * Per UFS spec, bCurrentPowerMode is the only attribute the device must
+ * respond to in any power mode.  Read it without waking the device to
+ * Active.
+ */
+static ssize_t current_power_mode_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	bool exited_h8 = false;
+	u32 value;
+	int ret = 0;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	pm_runtime_get_sync(hba->dev);
+
+	ufshcd_hold(hba);
+	scoped_guard(ufshcd_wl_pm, hba) {
+		if (ufshcd_is_link_off(hba) || ufshcd_is_ufs_dev_poweroff(hba)) {
+			/*
+			 * Device is powered down (rpm_lvl 4/5) or link is off
+			 * (rpm_lvl 5/6): nothing to query until a full resume.
+			 */
+			ret = -EINVAL;
+			break;
+		}
+
+		if (ufshcd_is_link_hibern8(hba)) {
+			ret = ufshcd_uic_hibern8_exit(hba);
+			if (ret) {
+				dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
+					__func__, ret);
+				break;
+			}
+			ufshcd_set_link_active(hba);
+			exited_h8 = true;
+		}
+
+		ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_POWER_MODE, 0, 0, &value);
+
+		if (exited_h8) {
+			int h8_ret = ufshcd_uic_hibern8_enter(hba);
+
+			if (h8_ret) {
+				dev_err(hba->dev, "%s: hibern8 enter failed %d\n",
+					__func__, h8_ret);
+				ret = h8_ret;
+			} else {
+				ufshcd_set_link_hibern8(hba);
+			}
+		}
+	}
+	ufshcd_release(hba);
+	pm_runtime_put_sync(hba->dev);
+
+	if (!ret)
+		ret = sysfs_emit(buf, "0x%08X\n", value);
+	else
+		ret = -EINVAL;
+
+out_unlock:
+	up(&hba->host_sem);
+	return ret;
+}
+static DEVICE_ATTR_RO(current_power_mode);
+
 UFS_ATTRIBUTE(active_icc_level, _ACTIVE_ICC_LVL);
 UFS_ATTRIBUTE(ooo_data_enabled, _OOO_DATA_EN);
 UFS_ATTRIBUTE(bkops_status, _BKOPS_STATUS);
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index e55c2a02c1f50..df61074843f06 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -3,6 +3,7 @@
 #ifndef _UFSHCD_PRIV_H_
 #define _UFSHCD_PRIV_H_
 
+#include <linux/cleanup.h>
 #include <linux/pm_runtime.h>
 #include <ufs/ufshcd.h>
 
@@ -15,6 +16,16 @@ static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
 
 void ufshcd_schedule_eh_work(struct ufs_hba *hba);
 
+DEFINE_LOCK_GUARD_1(ufshcd_wl_pm, struct ufs_hba,
+	({
+		mutex_lock(&_T->lock->wl_pm_mutex);
+		_T->lock->pm_op_in_progress = true;
+	}),
+	({
+		_T->lock->pm_op_in_progress = false;
+		mutex_unlock(&_T->lock->wl_pm_mutex);
+	}))
+
 static inline bool ufshcd_keep_autobkops_enabled_except_suspend(
 							struct ufs_hba *hba)
 {
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac7..7431c0ae9ce74 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10294,7 +10294,8 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	enum ufs_dev_pwr_mode req_dev_pwr_mode;
 	enum uic_link_state req_link_state;
 
-	hba->pm_op_in_progress = true;
+	guard(ufshcd_wl_pm)(hba);
+
 	if (pm_op != UFS_SHUTDOWN_PM) {
 		pm_lvl = pm_op == UFS_RUNTIME_PM ?
 			 hba->rpm_lvl : hba->spm_lvl;
@@ -10467,7 +10468,6 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		hba->clk_gating.is_suspended = false;
 		ufshcd_release(hba);
 	}
-	hba->pm_op_in_progress = false;
 	return ret;
 }
 
@@ -10475,9 +10475,11 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int ret;
-	enum uic_link_state old_link_state = hba->uic_link_state;
+	enum uic_link_state old_link_state;
+
+	guard(ufshcd_wl_pm)(hba);
 
-	hba->pm_op_in_progress = true;
+	old_link_state = hba->uic_link_state;
 
 	/*
 	 * Call vendor specific resume callback. As these callbacks may access
@@ -10568,7 +10570,6 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
 	hba->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
-	hba->pm_op_in_progress = false;
 	return ret;
 }
 
@@ -11256,6 +11257,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
 
 	sema_init(&hba->host_sem, 1);
+	mutex_init(&hba->wl_pm_mutex);
 
 	/* Initialize UIC command mutex */
 	mutex_init(&hba->uic_cmd_mutex);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dfd302f2dc7c1..ac7da4bd260cb 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1010,6 +1010,8 @@ enum ufshcd_mcq_opr {
  * @is_powered: flag to check if HBA is powered
  * @shutting_down: flag to check if shutdown has been invoked
  * @host_sem: semaphore used to serialize concurrent contexts
+ * @wl_pm_mutex: serializes WLUN suspend/resume against other contexts that
+ *	change the link power state while the WLUN may be suspended
  * @eh_wq: Workqueue that eh_work works on
  * @eh_work: Worker to handle UFS errors that require s/w attention
  * @eeh_work: Worker to handle exception events
@@ -1176,6 +1178,7 @@ struct ufs_hba {
 	bool is_powered;
 	bool shutting_down;
 	struct semaphore host_sem;
+	struct mutex wl_pm_mutex;
 
 	/* Work Queues */
 	struct workqueue_struct *eh_wq;
-- 
2.34.1

