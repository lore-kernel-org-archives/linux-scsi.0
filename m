Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4FD204F89;
	Tue, 29 Oct 2024 10:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730197922; cv=none; b=EG9IQLXpTDuu/8xFKQaSDJY0iOKPH6n4pfh2yq+zP5fYmZf0ifkZqeo9L7zNiBfUnkR3T5Wp2QhuRHYZ6y+1jtg/TepWp2/TzwRCT5KM/c6SCH0a1dhM/uUWdLiomxQFsZ4bAtiQF4KMpUjO+j9+IE0jdvdMRsqFj9ywYpdsvqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730197922; c=relaxed/simple;
	bh=wa7SSAoDHh4qwkDn6recGCiBpo3N9nVWye+iPsMj69Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TSOetLZi7Hf8q59TDalK+0FpDE/7T+PSk09stEm+lVvUQj0UnlNGoIcUFKSPfb041rsay0Rl/Y04Pr5u7JNpoUS6GttYhtX7ATgavV5D5cL3QZshww2p73b4LYurArJneG9lwe53D5+xwNPN/LQsn5EWr2uzLPRMaZEouxZVkC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KFzzeHSC; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KFzzeHSC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730197919; x=1761733919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wa7SSAoDHh4qwkDn6recGCiBpo3N9nVWye+iPsMj69Y=;
  b=KFzzeHSCvj7x5wHZgsvvRyNC8D9ekGa4iX635ZO3SAr+UfHTQAPSydAJ
   5rH6AE7RsoLjXW+InYvD0OoG6R3Bq0eUtn7tUOwo8dcqv3N5XjWVa+JRJ
   Oip6/Ud51nsKdBxFh9mnvKhc7Wym8rf6U31bUtM3tb7iOagyZuBC1KvmN
   jKBrQbqA9r3tcjGskoGk7fJ8wBFynCIBL6haGI9N76CkTk/eyPPawdZaz
   DAH0VgifN63vA+XkNv3L2K6ju1vko/x6hBqan3zhEV2fQR1YxJCOsSurP
   4iZjgMgc/LJXmy3K1XML4lqV1EGAop47ttBmUaGSSE63Z1xjsRqQP19D6
   A==;
X-CSE-ConnectionGUID: SKAJNaUHTUCDofvu+eXNEQ==
X-CSE-MsgGUID: aMJ9Ku9IT3qXBPOO80xX4Q==
X-IronPort-AV: E=Sophos;i="6.11,241,1725292800"; 
   d="scan'208";a="31231856"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 29 Oct 2024 18:31:59 +0800
IronPort-SDR: 6720ac72_zGv44sNU5ZtZHppZtX4sEu4FSJvcJp6va/VYdyQLpbAa0Lw
 Wtww6/0/3v3E2lotOrQx0hJSBw7NT6E9H7Xt3lg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2024 02:35:46 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2024 03:31:58 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 2/2] scsi: ufs: core: Introduce a new clock_scaling lock
Date: Tue, 29 Oct 2024 12:29:38 +0200
Message-Id: <20241029102938.685835-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241029102938.685835-1-avri.altman@wdc.com>
References: <20241029102938.685835-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new clock scaling lock to serialize access to some of the
clock scaling members instead of the host_lock. here also, simplify the
code with the guard() macro and co.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 126 +++++++++++++++++---------------------
 include/ufs/ufshcd.h      |  16 +++--
 2 files changed, 65 insertions(+), 77 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3373debe7b94..e574910adba5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1447,16 +1447,14 @@ static void ufshcd_clk_scaling_suspend_work(struct work_struct *work)
 {
 	struct ufs_hba *hba = container_of(work, struct ufs_hba,
 					   clk_scaling.suspend_work);
-	unsigned long irq_flags;
 
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
-	if (hba->clk_scaling.active_reqs || hba->clk_scaling.is_suspended) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-		return;
+	scoped_guard(spinlock_irqsave, &hba->clk_scaling.lock) {
+		if (hba->clk_scaling.active_reqs || hba->clk_scaling.is_suspended)
+			return;
+
+		hba->clk_scaling.is_suspended = true;
+		hba->clk_scaling.window_start_t = 0;
 	}
-	hba->clk_scaling.is_suspended = true;
-	hba->clk_scaling.window_start_t = 0;
-	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 
 	devfreq_suspend_device(hba->devfreq);
 }
@@ -1465,15 +1463,12 @@ static void ufshcd_clk_scaling_resume_work(struct work_struct *work)
 {
 	struct ufs_hba *hba = container_of(work, struct ufs_hba,
 					   clk_scaling.resume_work);
-	unsigned long irq_flags;
 
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
-	if (!hba->clk_scaling.is_suspended) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-		return;
+	scoped_guard(spinlock_irqsave, &hba->clk_scaling.lock) {
+		if (!hba->clk_scaling.is_suspended)
+			return;
+		hba->clk_scaling.is_suspended = false;
 	}
-	hba->clk_scaling.is_suspended = false;
-	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 
 	devfreq_resume_device(hba->devfreq);
 }
@@ -1487,7 +1482,6 @@ static int ufshcd_devfreq_target(struct device *dev,
 	bool scale_up = false, sched_clk_scaling_suspend_work = false;
 	struct list_head *clk_list = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
-	unsigned long irq_flags;
 
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return -EINVAL;
@@ -1508,43 +1502,37 @@ static int ufshcd_devfreq_target(struct device *dev,
 		*freq =	(unsigned long) clk_round_rate(clki->clk, *freq);
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
-	if (ufshcd_eh_in_progress(hba)) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-		return 0;
-	}
+	scoped_guard(spinlock_irqsave, &hba->clk_scaling.lock) {
+		if (ufshcd_eh_in_progress(hba))
+			return 0;
 
-	/* Skip scaling clock when clock scaling is suspended */
-	if (hba->clk_scaling.is_suspended) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-		dev_warn(hba->dev, "clock scaling is suspended, skip");
-		return 0;
-	}
+		/* Skip scaling clock when clock scaling is suspended */
+		if (hba->clk_scaling.is_suspended) {
+			dev_warn(hba->dev, "clock scaling is suspended, skip");
+			return 0;
+		}
 
-	if (!hba->clk_scaling.active_reqs)
-		sched_clk_scaling_suspend_work = true;
+		if (!hba->clk_scaling.active_reqs)
+			sched_clk_scaling_suspend_work = true;
 
-	if (list_empty(clk_list)) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-		goto out;
-	}
+		if (list_empty(clk_list))
+			goto out;
 
-	/* Decide based on the target or rounded-off frequency and update */
-	if (hba->use_pm_opp)
-		scale_up = *freq > hba->clk_scaling.target_freq;
-	else
-		scale_up = *freq == clki->max_freq;
+		/* Decide based on the target or rounded-off frequency and update */
+		if (hba->use_pm_opp)
+			scale_up = *freq > hba->clk_scaling.target_freq;
+		else
+			scale_up = *freq == clki->max_freq;
 
-	if (!hba->use_pm_opp && !scale_up)
-		*freq = clki->min_freq;
+		if (!hba->use_pm_opp && !scale_up)
+			*freq = clki->min_freq;
 
-	/* Update the frequency */
-	if (!ufshcd_is_devfreq_scaling_required(hba, *freq, scale_up)) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-		ret = 0;
-		goto out; /* no state change required */
+		/* Update the frequency */
+		if (!ufshcd_is_devfreq_scaling_required(hba, *freq, scale_up)) {
+			ret = 0;
+			goto out; /* no state change required */
+		}
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 
 	start = ktime_get();
 	ret = ufshcd_devfreq_scale(hba, *freq, scale_up);
@@ -1569,7 +1557,6 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct ufs_clk_scaling *scaling = &hba->clk_scaling;
-	unsigned long flags;
 	ktime_t curr_t;
 
 	if (!ufshcd_is_clkscaling_supported(hba))
@@ -1577,7 +1564,8 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 
 	memset(stat, 0, sizeof(*stat));
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	guard(spinlock_irqsave)(&hba->clk_scaling.lock);
+
 	curr_t = ktime_get();
 	if (!scaling->window_start_t)
 		goto start_window;
@@ -1613,7 +1601,7 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 		scaling->busy_start_t = 0;
 		scaling->is_busy_started = false;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	return 0;
 }
 
@@ -1677,19 +1665,18 @@ static void ufshcd_devfreq_remove(struct ufs_hba *hba)
 
 static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 {
-	unsigned long flags;
 	bool suspend = false;
 
 	cancel_work_sync(&hba->clk_scaling.suspend_work);
 	cancel_work_sync(&hba->clk_scaling.resume_work);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (!hba->clk_scaling.is_suspended) {
-		suspend = true;
-		hba->clk_scaling.is_suspended = true;
-		hba->clk_scaling.window_start_t = 0;
+	scoped_guard(spinlock_irqsave, &hba->clk_scaling.lock) {
+		if (!hba->clk_scaling.is_suspended) {
+			suspend = true;
+			hba->clk_scaling.is_suspended = true;
+			hba->clk_scaling.window_start_t = 0;
+		}
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (suspend)
 		devfreq_suspend_device(hba->devfreq);
@@ -1697,15 +1684,14 @@ static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba)
 {
-	unsigned long flags;
 	bool resume = false;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->clk_scaling.is_suspended) {
-		resume = true;
-		hba->clk_scaling.is_suspended = false;
+	scoped_guard(spinlock_irqsave, &hba->clk_scaling.lock) {
+		if (hba->clk_scaling.is_suspended) {
+			resume = true;
+			hba->clk_scaling.is_suspended = false;
+		}
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (resume)
 		devfreq_resume_device(hba->devfreq);
@@ -1791,6 +1777,8 @@ static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
 	INIT_WORK(&hba->clk_scaling.resume_work,
 		  ufshcd_clk_scaling_resume_work);
 
+	spin_lock_init(&hba->clk_scaling.lock);
+
 	hba->clk_scaling.workq = alloc_ordered_workqueue(
 		"ufs_clkscaling_%d", WQ_MEM_RECLAIM, hba->host->host_no);
 
@@ -2139,19 +2127,17 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 {
 	bool queue_resume_work = false;
 	ktime_t curr_t = ktime_get();
-	unsigned long flags;
 
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	guard(spinlock_irqsave)(&hba->clk_scaling.lock);
+
 	if (!hba->clk_scaling.active_reqs++)
 		queue_resume_work = true;
 
-	if (!hba->clk_scaling.is_enabled || hba->pm_op_in_progress) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (!hba->clk_scaling.is_enabled || hba->pm_op_in_progress)
 		return;
-	}
 
 	if (queue_resume_work)
 		queue_work(hba->clk_scaling.workq,
@@ -2167,18 +2153,17 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 		hba->clk_scaling.busy_start_t = curr_t;
 		hba->clk_scaling.is_busy_started = true;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 
 static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
 {
 	struct ufs_clk_scaling *scaling = &hba->clk_scaling;
-	unsigned long flags;
 
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	guard(spinlock_irqsave)(&hba->clk_scaling.lock);
+
 	hba->clk_scaling.active_reqs--;
 	if (!scaling->active_reqs && scaling->is_busy_started) {
 		scaling->tot_busy_t += ktime_to_us(ktime_sub(ktime_get(),
@@ -2186,7 +2171,6 @@ static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
 		scaling->busy_start_t = 0;
 		scaling->is_busy_started = false;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 
 static inline int ufshcd_monitor_opcode2dir(u8 opcode)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 3d42532efbd1..1125b260aef9 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -434,6 +434,10 @@ struct ufs_clk_gating {
 
 /**
  * struct ufs_clk_scaling - UFS clock scaling related data
+ * @workq: workqueue to schedule devfreq suspend/resume work
+ * @suspend_work: worker to suspend devfreq
+ * @resume_work: worker to resume devfreq
+ * @lock: serialize access to some struct ufs_clk_scaling members
  * @active_reqs: number of requests that are pending. If this is zero when
  * devfreq ->target() function is called then schedule "suspend_work" to
  * suspend devfreq.
@@ -443,9 +447,6 @@ struct ufs_clk_gating {
  * @enable_attr: sysfs attribute to enable/disable clock scaling
  * @saved_pwr_info: UFS power mode may also be changed during scaling and this
  * one keeps track of previous power mode.
- * @workq: workqueue to schedule devfreq suspend/resume work
- * @suspend_work: worker to suspend devfreq
- * @resume_work: worker to resume devfreq
  * @target_freq: frequency requested by devfreq framework
  * @min_gear: lowest HS gear to scale down to
  * @is_enabled: tracks if scaling is currently enabled or not, controlled by
@@ -457,15 +458,18 @@ struct ufs_clk_gating {
  * @is_suspended: tracks if devfreq is suspended or not
  */
 struct ufs_clk_scaling {
+	struct workqueue_struct *workq;
+	struct work_struct suspend_work;
+	struct work_struct resume_work;
+
+	spinlock_t lock;
+
 	int active_reqs;
 	unsigned long tot_busy_t;
 	ktime_t window_start_t;
 	ktime_t busy_start_t;
 	struct device_attribute enable_attr;
 	struct ufs_pa_layer_attr saved_pwr_info;
-	struct workqueue_struct *workq;
-	struct work_struct suspend_work;
-	struct work_struct resume_work;
 	unsigned long target_freq;
 	u32 min_gear;
 	bool is_enabled;
-- 
2.25.1

