Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E800E1D5168;
	Tue,  5 Nov 2024 11:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730806046; cv=none; b=UE3jCXPD+nDKEYeaC7KsB2o5jgL+4VxPpcc8rt3UWt69G6ICyXOjgqHvNF3W4lPmlIY1EywCgY2ANbS5PFdT/aZ/TzUn1Wh4/SMw7JQ6Y6t5AaHnaLOfrA8txv/MqYz8NstGJELdQemMlOWU9xd1B//REH1L0aFOWZkb/Owuq0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730806046; c=relaxed/simple;
	bh=yih9A/DpwsGPuge0OVJCxywEMnjSkFsoijq+Sj21Vw4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oHxyv4GOh0DlG1P6yXMK3I9dRo6m45jpX+Vvy+WTuKzlrVA7EDSCWG5oHM4S3DLCVufkzFApvXDoCRNgqOfHlObiQIgc0nKb+F+RzeQ6Zg4XNZZdH9v24VdaacrNFQzqROjE0FFLikg9EuNZmp7P1G42B7x+ccc0+gptsBdc8nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KLvfKkx7; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KLvfKkx7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730806044; x=1762342044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yih9A/DpwsGPuge0OVJCxywEMnjSkFsoijq+Sj21Vw4=;
  b=KLvfKkx7IlF8bjIR72RgrP01y+WO5iuGxe/UzeKpgfsW8RhfD6/gdj0T
   EYO+25LKBooiIhiO66OtSqRABMsAArxyV3TjF7Ox55wOgAUgusKSaYa4h
   FPTpZMb/hOorXHNig3E9EWlhR4Y7WgQ4QplSb0dYq905cWsO2/5vxmTOI
   Eh1Akt6HZGBy6OCugjIw8E9AWgVP6OLArT5+0y7c0jXIVDI7WYA+eJlt1
   233c9w1aghhc/ro4PRXCm+crZK/rAbT1lNXeblTMhB4Fmbto8OtG4A9bW
   b44C1BLOWblRHRJpwLSu61YsdKmtOa0s+ExyXIPDeDBjrfBTMxUYq8LDU
   g==;
X-CSE-ConnectionGUID: +qKR/XaHTIyaquCyREfR9w==
X-CSE-MsgGUID: GgjNg5kVSpiuPnNntSzkrQ==
X-IronPort-AV: E=Sophos;i="6.11,260,1725292800"; 
   d="scan'208";a="30658794"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Nov 2024 19:27:24 +0800
IronPort-SDR: 6729f3e7_5iiDfC1K1H3+tRM6/8xfY3sr/4gTSGZArTX6VJPGRLgCRSX
 ka1c7OVj4cFKIOsPYj5m6Ko2FKA1hfQS0fGE9KA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Nov 2024 02:31:03 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Nov 2024 03:27:24 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 2/2] scsi: ufs: core: Introduce a new clock_scaling lock
Date: Tue,  5 Nov 2024 13:25:02 +0200
Message-Id: <20241105112502.710427-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241105112502.710427-1-avri.altman@wdc.com>
References: <20241105112502.710427-1-avri.altman@wdc.com>
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
 drivers/ufs/core/ufshcd.c | 126 +++++++++++++++++---------------------
 include/ufs/ufshcd.h      |  16 +++--
 2 files changed, 65 insertions(+), 77 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 62c0e2323f50..fbc6e3f408af 100644
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
 
@@ -2143,19 +2131,17 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
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
@@ -2171,18 +2157,17 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
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
@@ -2190,7 +2175,6 @@ static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
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

