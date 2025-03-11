Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C11C1E9B0C
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2025 08:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741682587; cv=none; b=gwi9BWbcE2buhbJsbbkz1wzJSJvqiVQEYzFFpMW7fu+sEYWZUfl3hHSKoHq7hNNkW0i1tU79ymNSCwZf4rVX1gLD0cyJZEpVbpB8BcehGrtKY1WjysmNpwGmwsgfDAeJ4ZWnzAigCVJrXCeSZjaMHZDeaXmeiSgmqzuT/W9x3/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741682587; c=relaxed/simple;
	bh=kzB9tO+0OXmfhOn9C4bVbuy6WbMQbW56cHt81QR/310=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eQd4qObB84AaXVUXP4XXcv6e/UI7uf9aVTMfntokoKhmb33PJzmFHi2SrR3dqu75dztWTik7LVoJ9O47Wa8fozbuil7TKQq5Vin6LzmCZiTb8BHbBnb5O7ENB50tva3r/RtQHaUoq5oJftwkYyuTLOUgJlOFjw+RM92boCBlCMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C6ddvb/H; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C6ddvb/H"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-224341bbc1dso64041305ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2025 01:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741682585; x=1742287385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+AtgJ8HcrJjPP7f7tuDlddSnsCCVqpKzG8vCHqgRtUU=;
        b=C6ddvb/HiMZL7XXlvPv4RiL55wX59E3eiCfl9l+eVhNkUTA3EWEmsOWRlX4DOxt9vC
         u4yDH5SSR1+wg+ChJFazNs7suj33bzJ72OTRv3QyP2m3PltF3FD2zf5jI9EDxKOfioZr
         h3AqmVcMTJkKAkgvgOaoNuqmwncFaMVk1BrjdZeUztXEOdFuZZ1aBE0WZdJ4LYBpykuj
         EFHywqLMcKGMSovltCGJPeA8O/x+SlrQ3bg9ULeTbSODf9nwLovU6Gs+1YNzxBzoYmRb
         95I36UT0sdDq1++MEi85CHEr3LgvKUpTajKqzW0HdtPfZxZT3m3gSefVSH5l+bdS8mnu
         Hf1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741682585; x=1742287385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+AtgJ8HcrJjPP7f7tuDlddSnsCCVqpKzG8vCHqgRtUU=;
        b=H0olU5up4/jX4oTn2P/+P9Eh7LEATSh6zjTZFreBVc5kw92ORUvDF6v7vj4OPS5MvW
         VNF0H5vReg/mCzLfkw+JnpcwRmhBdhfGKn1+cpHfanM07T6TBEO6CwnHwP6ON4B9CPbE
         t86aURYizbPEMZmRUsrYdsPLkojCor2vmxeWqO2yJuSb/v2eDyI+QJILDd1C5nU/iRo+
         QthH3Psbwj9+H7J5nLVj3YfVRdRY6/e+QRlNhqkeY8Z78S5VFwpruhMz5wL6gNqsueTV
         XcioQGJ1LwhU/eeS8LBh3U7FHKF7JDoYkiXVtcd7zRmwgo/osZ18Ae89dXAOSBfCxTWj
         83ng==
X-Forwarded-Encrypted: i=1; AJvYcCXdZ6aqACxw+OWRJeal3cWKlpEnKChjjZxh3erPTWvu1mAlr1DGE2+phcvvE7Yl5piVQ9/UX53+UMhr@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzr87/Nhm8h4vef61GzYUOpFQK24pfR8m6yU+wokNAYIlC9Bzm
	cRuhFF6x0L5Ue0D7CkIPyb2aGKBNaS+7pWhq9/L3WfzgsbWF0pZ0kts3XQ==
X-Gm-Gg: ASbGncvjb/FW1n2BIhAhP2NLpNNLrH1BeK/iTxWI4QfYi8s+kt3t7sdMqCYTMx25dy9
	omCpNzRpkwpFTktSOYx7M5nGCyEcDgMs5PqcH6+ukG01iPCYjUS65pchfxHXGQ4lEU2NO/xB8F+
	8CTorlK7wAlKJt23Xp1eLX1jwpNi5L1nD04VODJm+AJgRlXLOj5TpdfEkIMdgbGmYG+RTZmwXsG
	vbvmlYTcrf6oTdAUkpgBqjLRw3rHHmqwNxKVrjRyGQBbDvkb/Hi61aCZYyTCA30fnxIrVRXHln8
	FYx1ZWFIocnHb8vbCywTy/VMyT3omL85Mpq0WKPUK3DU2DGQLi/z4A==
X-Google-Smtp-Source: AGHT+IELZS34AMe+BaFzzEVFDmP8S11mMUnu+gZp+x3yZ4oIZeZoIMU/af1yFYFTerJpYZV9uAvLsg==
X-Received: by 2002:a05:6a21:6493:b0:1f5:5ca4:2744 with SMTP id adf61e73a8af0-1f58cb1bd8fmr4325509637.17.1741682584633;
        Tue, 11 Mar 2025 01:43:04 -0700 (PDT)
Received: from localhost ([107.155.12.245])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736df8db331sm2990278b3a.76.2025.03.11.01.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 01:43:04 -0700 (PDT)
From: "qiwu.chen" <qiwuchen55@gmail.com>
X-Google-Original-From: "qiwu.chen" <qiwu.chen@transsion.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	beanhuo@micron.com
Cc: ahalaney@redhat.com,
	ebiggers@google.com,
	minwoo.im@samsung.com,
	linux-scsi@vger.kernel.org,
	"qiwu.chen" <qiwu.chen@transsion.com>
Subject: [PATCH] ufs: fix deadlock for the case of pm shutdown during suspend transition to resume
Date: Tue, 11 Mar 2025 16:42:57 +0800
Message-Id: <20250311084257.8989-1-qiwu.chen@transsion.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a deadlock when triggers pm shutdown during suspend-to-idle state transition
to resume. Here are the issue reproduce steps:
1. System enter suspend-to-idle transition and execute suspend callbacks for given devices
in dpm_suspend(). The suspend callback of ufshcd_wl device - ufshcd_wl_suspend() will down
hba->host_sem which is supposed to up in ufshcd_wl_resume(). Here is main call trace:
enter_state
    suspend_devices_and_enter
        dpm_suspend_start
	    dpm_suspend
		device_suspend
		    ufshcd_wl_suspend
			down(&hba->host_sem) //hold host_sem

2. Someone triggers shutdown due to low battery during suspend transition.
The shutdown flow will hold device lock and execute shutdown callback for given devices
in device_shutdown(). The shutdown callback of ufshcd_wl device - ufshcd_wl_shutdown()
will hold ufshcd_wl's device lock and blocked to down hba->host_sem unfortunately.
Here is the blocked trace of shutdown thread:
__switch_to+0x174/0x338
__schedule+0x608/0x9f0
schedule+0x7c/0xe8
schedule_timeout+0x44/0x1c8
__down_common+0xbc/0x238
__down+0x18/0x28
down+0x50/0x54
ufshcd_wl_shutdown+0x28/0xb4   //blocked to down host_sem
device_shutdown+0x1a0/0x254    //get device lock
kernel_power_off+0x3c/0xf0
power_misc_routine_thread+0x814/0x970
kthread+0x104/0x1d4
ret_from_fork+0x10/0x20

3. Meanwhile, the suspend-to-idle transition is aborted by a wakeup source and go to handle
resume works, the resume work will be blocked in holding ufshcd_wl device lock forever.
Here is the blocked trace of resume work:
__switch_to+0x174/0x338
__schedule+0x608/0x9f0
schedule+0x7c/0xe8
schedule_preempt_disabled+0x24/0x40
__mutex_lock+0x408/0xdac
__mutex_lock_slowpath+0x14/0x24
mutex_lock+0x40/0xec
__device_resume+0x50/0x360    //blocked in holding device lock, deadlock!
async_resume+0x24/0x3c
async_run_entry_fn+0x44/0x118
process_one_work+0x1e4/0x43c
worker_thread+0x25c/0x430
kthread+0x104/0x1d4
ret_from_fork+0x10/0x20

Fix the deadlock issue by using atomic operation instead of sleep lock for shutting_down state check.

Signed-off-by: qiwu.chen <qiwu.chen@transsion.com>
---
 drivers/ufs/core/ufshcd-priv.h |  2 +-
 drivers/ufs/core/ufshcd.c      | 21 +++++++++------------
 include/ufs/ufshcd.h           |  2 +-
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 786f20ef2238..76d323de42f9 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -8,7 +8,7 @@
 
 static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
 {
-	return !hba->shutting_down;
+	return !atomic_read(&hba->shutting_down);
 }
 
 void ufshcd_schedule_eh_work(struct ufs_hba *hba);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3094f3c89e82..b0f5152e5b04 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1729,12 +1729,10 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 	if (kstrtou32(buf, 0, &value))
 		return -EINVAL;
 
-	down(&hba->host_sem);
-	if (!ufshcd_is_user_access_allowed(hba)) {
-		err = -EBUSY;
-		goto out;
-	}
+	if (!ufshcd_is_user_access_allowed(hba))
+		return -EBUSY;
 
+	down(&hba->host_sem);
 	value = !!value;
 	if (value == hba->clk_scaling.is_enabled)
 		goto out;
@@ -6416,8 +6414,7 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 
 static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
 {
-	return (!hba->is_powered || hba->shutting_down ||
-		!hba->ufs_device_wlun ||
+	return (!hba->is_powered || !hba->ufs_device_wlun ||
 		hba->ufshcd_state == UFSHCD_STATE_ERROR ||
 		(!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
 		   ufshcd_is_link_broken(hba))));
@@ -6541,10 +6538,13 @@ static void ufshcd_err_handler(struct work_struct *work)
 	dev_info(hba->dev,
 		 "%s started; HBA state %s; powered %d; shutting down %d; saved_err = %d; saved_uic_err = %d; force_reset = %d%s\n",
 		 __func__, ufshcd_state_name[hba->ufshcd_state],
-		 hba->is_powered, hba->shutting_down, hba->saved_err,
+		 hba->is_powered, atomic_read(&hba->shutting_down), hba->saved_err,
 		 hba->saved_uic_err, hba->force_reset,
 		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
 
+	if (!ufshcd_is_user_access_allowed(hba))
+		return;
+
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (ufshcd_err_handling_should_stop(hba)) {
@@ -10194,10 +10194,7 @@ static void ufshcd_wl_shutdown(struct device *dev)
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct ufs_hba *hba = shost_priv(sdev->host);
 
-	down(&hba->host_sem);
-	hba->shutting_down = true;
-	up(&hba->host_sem);
-
+	atomic_set(&hba->shutting_down, 1);
 	/* Turn on everything while shutting down */
 	ufshcd_rpm_get_sync(hba);
 	scsi_device_quiesce(sdev);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 74e5b9960c54..db38141278c7 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1034,7 +1034,7 @@ struct ufs_hba {
 	u16 ee_usr_mask;
 	struct mutex ee_ctrl_mutex;
 	bool is_powered;
-	bool shutting_down;
+	atomic_t shutting_down;
 	struct semaphore host_sem;
 
 	/* Work Queues */
-- 
2.25.1

