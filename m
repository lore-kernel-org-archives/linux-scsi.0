Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AF11991A5;
	Mon, 18 Nov 2024 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731941046; cv=none; b=qLKo0RTrBzq83aCICAgrWnFosflsgiJoSkHU05cBCcdCTHaZSnEZC+iTptmUjRE+FQCmO+Ez1FV+rVQ5R/4okLNZoDZHBBHQmCteFt9CGErtnzRtZE6tLObtVv+0/jjNrP93jDmb2MI4uBoHskpw0XAQMEKy6Rzd4+1uvJeya0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731941046; c=relaxed/simple;
	bh=BgZZEKQgTvB3T9/Y7JrXTY2XVIN7R2zTzPUYq/mUWUs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sQQ1kt0ECs5xoWSz5OxxIFgCdPQ5nZ2SkgMmd10P3PWOM04d+NGYI/r466D9GyNA1JN+8utREEjMNKFNX9VQ2H2NsUC6pQFulI+hh8Hcu6YYzL0ghBXPvaWDgni0o53oLCovAgsaKKESXnlyebisfNIl/PT3Dl+j+JFFtu90zKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rfqWPOkY; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rfqWPOkY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1731941044; x=1763477044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BgZZEKQgTvB3T9/Y7JrXTY2XVIN7R2zTzPUYq/mUWUs=;
  b=rfqWPOkYJJVR28Fsz2D3IeSennmAdAiC8fhvXPoUQUEDNAthc1Z6p/fM
   xwJD1ylNuxGud2YI26n+QR592C94Lwixuiqs3bRuSuLCCtideTZn4WU5K
   bbdKvTZW9h2WdsSSucAhIaSs/x/FALsZkOcGLed/+BjD1PvhvzK3b0FNk
   0fVnycbQkOQ3hxqLiZJJvZ7IT6qiI/eMgT9sFJ68Sozf2Kr//8q8BEpzh
   RRqgbg43XerNDQGrwkwRUiXJjLsmM0vEH92+aJDldmnia28TfHKe5wY+q
   7OYqCVE+vZcOBLjDNTKVKHhsFflaefg399CY4vjKs1wj5X3Xo/+c53hTS
   Q==;
X-CSE-ConnectionGUID: FEmDar4uSN6Hw7QaST7nSg==
X-CSE-MsgGUID: cVD/vBGyR5iAxhFHN7taJw==
X-IronPort-AV: E=Sophos;i="6.12,164,1728921600"; 
   d="scan'208";a="31114485"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2024 22:43:58 +0800
IronPort-SDR: 673b441d_10nP0zElHGg5hvAUmtJVjYehiYrFqPBG9i7ZG5OC+O+t7ID
 e6lY/31Z45rWhPhGl/vksdHRP1YPtYPcVWbVSkA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2024 05:41:50 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2024 06:43:56 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 3/3] scsi: ufs: core: Introduce a new clock_scaling lock
Date: Mon, 18 Nov 2024 16:41:17 +0200
Message-Id: <20241118144117.88483-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241118144117.88483-1-avri.altman@wdc.com>
References: <20241118144117.88483-1-avri.altman@wdc.com>
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

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 132 ++++++++++++++++++--------------------
 include/ufs/ufshcd.h      |  16 +++--
 2 files changed, 71 insertions(+), 77 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 638d9c0e2603..6eb8d7e5d443 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1452,16 +1452,16 @@ static void ufshcd_clk_scaling_suspend_work(struct work_struct *work)
 {
 	struct ufs_hba *hba = container_of(work, struct ufs_hba,
 					   clk_scaling.suspend_work);
-	unsigned long irq_flags;
 
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
-	if (hba->clk_scaling.active_reqs || hba->clk_scaling.is_suspended) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-		return;
+	scoped_guard(spinlock_irqsave, &hba->clk_scaling.lock)
+	{
+		if (hba->clk_scaling.active_reqs ||
+		    hba->clk_scaling.is_suspended)
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
@@ -1470,15 +1470,13 @@ static void ufshcd_clk_scaling_resume_work(struct work_struct *work)
 {
 	struct ufs_hba *hba = container_of(work, struct ufs_hba,
 					   clk_scaling.resume_work);
-	unsigned long irq_flags;
 
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
-	if (!hba->clk_scaling.is_suspended) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-		return;
+	scoped_guard(spinlock_irqsave, &hba->clk_scaling.lock)
+	{
+		if (!hba->clk_scaling.is_suspended)
+			return;
+		hba->clk_scaling.is_suspended = false;
 	}
-	hba->clk_scaling.is_suspended = false;
-	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 
 	devfreq_resume_device(hba->devfreq);
 }
@@ -1492,7 +1490,6 @@ static int ufshcd_devfreq_target(struct device *dev,
 	bool scale_up = false, sched_clk_scaling_suspend_work = false;
 	struct list_head *clk_list = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
-	unsigned long irq_flags;
 
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return -EINVAL;
@@ -1513,43 +1510,38 @@ static int ufshcd_devfreq_target(struct device *dev,
 		*freq =	(unsigned long) clk_round_rate(clki->clk, *freq);
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
-	if (ufshcd_eh_in_progress(hba)) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
-		return 0;
-	}
+	scoped_guard(spinlock_irqsave, &hba->clk_scaling.lock)
+	{
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
@@ -1574,7 +1566,6 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct ufs_clk_scaling *scaling = &hba->clk_scaling;
-	unsigned long flags;
 	ktime_t curr_t;
 
 	if (!ufshcd_is_clkscaling_supported(hba))
@@ -1582,7 +1573,8 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 
 	memset(stat, 0, sizeof(*stat));
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	guard(spinlock_irqsave)(&hba->clk_scaling.lock);
+
 	curr_t = ktime_get();
 	if (!scaling->window_start_t)
 		goto start_window;
@@ -1618,7 +1610,7 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 		scaling->busy_start_t = 0;
 		scaling->is_busy_started = false;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	return 0;
 }
 
@@ -1682,19 +1674,19 @@ static void ufshcd_devfreq_remove(struct ufs_hba *hba)
 
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
+	scoped_guard(spinlock_irqsave, &hba->clk_scaling.lock)
+	{
+		if (!hba->clk_scaling.is_suspended) {
+			suspend = true;
+			hba->clk_scaling.is_suspended = true;
+			hba->clk_scaling.window_start_t = 0;
+		}
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (suspend)
 		devfreq_suspend_device(hba->devfreq);
@@ -1702,15 +1694,15 @@ static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba)
 {
-	unsigned long flags;
 	bool resume = false;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->clk_scaling.is_suspended) {
-		resume = true;
-		hba->clk_scaling.is_suspended = false;
+	scoped_guard(spinlock_irqsave, &hba->clk_scaling.lock)
+	{
+		if (hba->clk_scaling.is_suspended) {
+			resume = true;
+			hba->clk_scaling.is_suspended = false;
+		}
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (resume)
 		devfreq_resume_device(hba->devfreq);
@@ -1796,6 +1788,8 @@ static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
 	INIT_WORK(&hba->clk_scaling.resume_work,
 		  ufshcd_clk_scaling_resume_work);
 
+	spin_lock_init(&hba->clk_scaling.lock);
+
 	hba->clk_scaling.workq = alloc_ordered_workqueue(
 		"ufs_clkscaling_%d", WQ_MEM_RECLAIM, hba->host->host_no);
 
@@ -2165,19 +2159,17 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
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
@@ -2193,18 +2185,17 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
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
@@ -2212,7 +2203,6 @@ static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
 		scaling->busy_start_t = 0;
 		scaling->is_busy_started = false;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 
 static inline int ufshcd_monitor_opcode2dir(u8 opcode)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 8f9997b0dbf9..c449b6cdc1dc 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -435,6 +435,10 @@ struct ufs_clk_gating {
 
 /**
  * struct ufs_clk_scaling - UFS clock scaling related data
+ * @workq: workqueue to schedule devfreq suspend/resume work
+ * @suspend_work: worker to suspend devfreq
+ * @resume_work: worker to resume devfreq
+ * @lock: serialize access to some struct ufs_clk_scaling members
  * @active_reqs: number of requests that are pending. If this is zero when
  * devfreq ->target() function is called then schedule "suspend_work" to
  * suspend devfreq.
@@ -444,9 +448,6 @@ struct ufs_clk_gating {
  * @enable_attr: sysfs attribute to enable/disable clock scaling
  * @saved_pwr_info: UFS power mode may also be changed during scaling and this
  * one keeps track of previous power mode.
- * @workq: workqueue to schedule devfreq suspend/resume work
- * @suspend_work: worker to suspend devfreq
- * @resume_work: worker to resume devfreq
  * @target_freq: frequency requested by devfreq framework
  * @min_gear: lowest HS gear to scale down to
  * @is_enabled: tracks if scaling is currently enabled or not, controlled by
@@ -458,15 +459,18 @@ struct ufs_clk_gating {
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

