Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C941D86C0
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2025 03:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737691185; cv=none; b=mF7WQyKQ5H5JNkfPA2g/0U+lrJcvk/0ivV6FFVEhNzIGIjc5+NzwcFoAM8z5mkkODBvHgqpsHj264niYcZdpkVBr1XClD3yNBt/2hix5B2lVDHmbZ5ys7e/n/WbyqpRVP8l3NweWUDt0QBOnWDr4UgR5YSrVlmiUbJEwpVBmNQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737691185; c=relaxed/simple;
	bh=GIaDQq4aq+u5KsMm0lV5bL72GvrqZN9a9wvcKgawXD0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=apCkF2pgGW5ewbSXGjr489rLdE9uzXCcriFFUYCWX8ZkYKNtoQj0bU81Tseqsg2PppP2kfGk1pavLKOm9FsSaeZpDzWjjYxRowNu1RmADRpFrRLTegKjrT3wTnGGaGtWmiLFXPYJMpMyJk/zngW/LxXnn+CB+aGj5SF2WCA5GgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YPbcKw5S; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YPbcKw5S"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2166f1e589cso40418145ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2025 19:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737691183; x=1738295983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fSLbYZVKQ7n+PQViw9RsBZGhbuXkq5VzMZdKgoTa9lY=;
        b=YPbcKw5SW2MjmQSfmfYyLZ/vrVIaGs3lmTnUQlsVbRxzzz+qx+IWVA+2Alc+5bbCon
         iTqjQsndxMr+Xlr7LOO+Jh4aD+4e0xl9ng3lncFMbKD6N3UHkra9p2cJJv8H+9G5Vg0K
         XZVn63G+1+Nu+abo3aVGYKLwJ2402270woAVmliJKVNX0VPQPCaR7ushUoCSp4RitCdm
         IVt0Za+IQFgX5V0/fCt4g+Kps84qnzdjbzar7yGZlmEFxxs4ZQzUPJJNrUspNhDvSekz
         3beKxCtrzIEHJ18UPENDwYtSVJ2cjtjGvUgsaSWdwnMTkJ5XrNcFThTLdb954wW3Gce9
         FgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737691183; x=1738295983;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fSLbYZVKQ7n+PQViw9RsBZGhbuXkq5VzMZdKgoTa9lY=;
        b=wrf04w8PSvUCKF1Q8ImZzeqs6z2j2c+cglp8kZngy6oUVwWzaaIF1xitkwH1f8PNl+
         mr928HKgqTDCAxH/MkN9GUZDwdDbHWZi+/3MZdpY6fjIy/AHYuDoexPoV+IwsAqogEcJ
         qQ4ofB7yoHwVMH9VyIn35Zv6HlFvjn6hb6dfJqeNLWoIQhfYMnDHf4c11vTHhXAnDr72
         Qn7JEHhx9CUhCbm29YBQ8YILmUiptZ2Z4uFViVYoxok1FpFNcQ/cdMP0I35BzooUG+VT
         gRdWvedDUH80mFNvvPd+5VVhNUZ4JLAduEpQjcmk8jT20YBvATVZDg8WSfJUNO5W0SWC
         4aZQ==
X-Gm-Message-State: AOJu0Ywg4Wmai5OYSapzptH54WD4iFtp/djjUPFyaKfp+pVsFzbZXJ7X
	Q4z7BxMslY9YPJgrvTh41ypqmlRUydT1+FtMI8C/egXozFLjx2IsGt51AA==
X-Gm-Gg: ASbGncsnfDjGqMXv2zSMOG2DoLvHZ8R+DVQKzIs0Mk4x8uMtw3k+4hpIyRtQ3iD94s+
	HeYHcq4ca3yT5RC4W4RsgXLq7pgM0X1XZhMbislpV+v32WXDrMkktDzGWRLKxfu7QCNR4dGhsln
	lJJWZWVvEpez6JNLYzX+JMLCCql+/OxoSkQOiftdKZptQoKwWsx3LhNU1M2XVtAv3/c3pqw/9UW
	8u/Tge5KVDDts7/l2JqQxIKVQ8pVBcExmuqZrv1Kdxacow8Q5vC1TyM74V/BrFWSuWLnbtfeNnu
	PYmuJ+aDwwEXCpX0Mgfo9z7v
X-Google-Smtp-Source: AGHT+IHjRqhp46YX9p5ANXGVufoZfZuXRbx0c7aXxNPZhegt1r0E2FW+f0DGqtx4gGeoy6Q4KebtOQ==
X-Received: by 2002:a05:6a20:6f8f:b0:1eb:3661:da33 with SMTP id adf61e73a8af0-1eb3661dcf1mr40486461637.30.1737691183371;
        Thu, 23 Jan 2025 19:59:43 -0800 (PST)
Received: from localhost ([107.155.12.245])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b3067sm774702b3a.47.2025.01.23.19.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 19:59:42 -0800 (PST)
From: "qiwu.chen" <qiwuchen55@gmail.com>
X-Google-Original-From: "qiwu.chen" <qiwu.chen@transsion.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	manivannan.sadhasivam@linaro.org
Cc: linux-scsi@vger.kernel.org,
	"qiwu.chen" <qiwu.chen@transsion.com>
Subject: [PATCH] ufs: fix deadlock issue for the race scenario of suspend and shutdown simultaneously
Date: Fri, 24 Jan 2025 11:59:34 +0800
Message-Id: <20250124035934.18217-1-qiwu.chen@transsion.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a deadlock when suspend, shutdown and resume are ocurred almost simultaneously.
Here is the deadlock cause:
1. System enter suspend flow, it will call ufshcd_wl_suspend() to get host_sem, the host_sem
is supposed to up in ufshcd_wl_resume:
pm_suspend
     ufshcd_wl_suspend
          down(&hba->host_sem)

2. Shutdown is happened due to low battery during suspend progress, it will get ufshcd_wl device mutex
and blocked in down host_sem in ufshcd_wl_shutdown() unfortunately.
__switch_to+0x174/0x338
__schedule+0x608/0x9f0
schedule+0x7c/0xe8
schedule_timeout+0x44/0x1c8
__down_common+0xbc/0x238
__down+0x18/0x28
down+0x50/0x54
ufshcd_wl_shutdown+0x28/0xb4
device_shutdown+0x1a0/0x254
kernel_power_off+0x3c/0xf0
power_misc_routine_thread+0x814/0x970 [mt6375_battery]
kthread+0x104/0x1d4
ret_from_fork+0x10/0x20

3. Meanwhile, suspend flow is waked up by a interrupt and go to resume
work, the resume work will be blocked in getting ufshcd_wl device mutex.
__switch_to+0x174/0x338
__schedule+0x608/0x9f0
schedule+0x7c/0xe8
schedule_preempt_disabled+0x24/0x40
__mutex_lock+0x408/0xdac
__mutex_lock_slowpath+0x14/0x24
mutex_lock+0x40/0xec
__device_resume+0x50/0x360
async_resume+0x24/0x3c
async_run_entry_fn+0x44/0x118
process_one_work+0x1e4/0x43c
worker_thread+0x25c/0x430
kthread+0x104/0x1d4
ret_from_fork+0x10/0x20

Fix the deadlock issue by define an atomic value of shutting_down to
check if shutdown has been invoked.

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

