Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C994A4EE8
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 14:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789484050; cv=none; b=IN+FyQPBJ9R6PChMjE9R78ByYr5xfG6OhglB5t2SCvDScSUH/RNdH+X/NFPadCP0uei5J2WUSg9ImsKQhZt1kufTu0wDMWWT1LgKLoVHqaCxovDOJF+PDlXJGBt5RbUFI8eSbUVbnQ7McCbYwaU0osg1eF/gg9Rjo7YyMS5gt0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789484050; c=relaxed/simple;
	bh=OspN7MKSFmprrrS2PxdNlMmUOibbtdADDRJnLjEgeMQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Pr/B6PZCbqTdBSifqqKanJIeGlBM3RlHEPF16rAhHJP0Lqo0Ha8tqqx8wZdi7Y7slKdtylQzX6cwrXqKMk4z4yt5ZzPwzt2R3tjS5hCgh8GOf2ZzhCPko4H7uuO8jqSvlg5ZWlmOCAwPg6TVBWtzW7+uG/R/Me9Qty4gNAa/M98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eP/Gw6sO; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eP/Gw6sO"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ee1f9bso35543235ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 07:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789484048; x=1790088848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dMa7SuymF3JpSxZj/WgqSEvagr3KGVZWyIDh4Tap88k=;
        b=eP/Gw6sO7TcCjNS7FfkEjVNfwIPnx+hYEEZrh7f56v8Z87oHSBODy0vuRo0jWozWpN
         Pje5pd/1ufqGJwx3DkRT0Q1MccNBLYzbVqDHNmlP/8Ky3x4XL4W8kAumgt0+5rj48Uul
         mg5Nmk3Bw+W/Y5FwEFpi3qWfbuSLhZ+W9+Ro8Pq4K2t5AQQ8hnrWihlYhr7Gc0fm7Qg+
         ajSU4/WH9/ZFJmmAkiIxJIIDwdCmtAl0Yyre3RhoNlR9QN8mmYQ2XZ/V6zjfAbS9XNYR
         Eu9PWZSctvhbzHniWuDVw3ukhAEPRgkpbE/q+73dpx6EWwfZ8+q8WDqj7gG38GmJmyaO
         DtDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789484048; x=1790088848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dMa7SuymF3JpSxZj/WgqSEvagr3KGVZWyIDh4Tap88k=;
        b=n9S7FhKgGNBJpL7+FqKl6PKbor27VRPr+ToQ6yOCzq5xHO2i75BR1xTvWE/qs3kpz8
         ltLFP1nryjM6yg209225B7SfdqRGy4P8p+2Lvq86dfZuInGYBwJBb0AsZ1ApUs3GnLMB
         G970CdH77QrtBFmVobZ8tq2Q673S8m3LU4GmQF1J59q8fhSWyptOlFjRAzoxid+W5Aaa
         sS7GZo5MR5pJE0Eo7oUBvFHIU7sW4BOePi6BkMZibrOmfZXm45shs/MxWLXnF6I+OfAz
         kkOLY6IsSMHP+/y84QrHSrwcp0hyiubg9ATeTo0vtKaIUsGUhTf7rndpL3OHagwMWYhK
         xTVQ==
X-Gm-Message-State: AFuF++lOB51u8vA+xECB6DE/AOcwxzcHgJqh0uGQKrA6xUdoJtNmx79g
	/aQ9surbxJTzSHVWVqib+agm2tRt20gCMvxbIRNcqCGkwLnb0TpQiv5r
X-Gm-Gg: AYBFou3oXoiX/8s24biUXj0afNhdPG0PPerzVThHjT98uBMRiF122psbBfw7paGXjBj
	1fiW/r2GDvDQO9noPOkqg1NZBWQ9oE0J8NqyIKCr60FjziFEjF1mVVPLKufNYDElRuwtT/qO7Uq
	AfCoZicAtMiRVULcj5RdXzNJ1Ae55ng3QeXCmnFTN2c2Jout1DBonwIVxD6C3x/bH8skRtMfJ1X
	Ujml1RMrAFpr9d1G6iAnxxXT/MZPxWQN8mHkwvWZucE+colERTQUNH7urnWoeK6lKiF4bFrfeR2
	2cnP0RnTW1uupqhzKUPaDUNDMcpdoS4E9OAS8FB05xyqG2eMCNyjiJ4yPPyZWpFBrZAWda0arhj
	T3XEuwMs8eSEPDbcwsjttWWfn/CUiKRElvjYiflZ3SwAmE9NfN8PP0ycmPBTMfjRBHGzC/E1vga
	PNq9TxqTT7ZanAFwHcLC2ACpbca55dsoAri39XQC7Z9/6fBU+aWHOXaExrQ19wBpuz30frlEKKz
	Yjh5HSobo8siSxa97TEbqHNINXb653E6sauNMA3SkMjfB2qPQgZ42QFWQfJOSY7VTpdb+80AOeX
	nVMETW53JE4kG9QbyGxHyftgIzvh4+4=
X-Received: by 2002:a17:903:240d:b0:2d8:d4cc:be68 with SMTP id d9443c01a7336-2dd6c75858dmr177039915ad.21.1789484047919;
        Tue, 15 Sep 2026 07:54:07 -0700 (PDT)
Received: from NV-9MNJ414.tailae2068.ts.net (2001-b011-2005-787e-21e6-43b5-0185-f167.dynamic-ip6.hinet.net. [2001:b011:2005:787e:21e6:43b5:185:f167])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cff297esm68555405ad.73.2026.09.15.07.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 07:54:06 -0700 (PDT)
From: Yiwei Lin <s921975628@gmail.com>
To: alim.akhtar@samsung.com,
	avri.altman@sandisk.com,
	bvanassche@acm.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	robelin <robelin@nvidia.com>,
	Yiwei Lin <s921975628@gmail.com>
Subject: [PATCH v2] ufs: sysfs: fix current_power_mode read without SSU
Date: Tue, 15 Sep 2026 22:53:54 +0800
Message-Id: <20260915145354.8194-1-s921975628@gmail.com>
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

