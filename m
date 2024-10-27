Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AA833993;
	Sun, 27 Oct 2024 08:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730017664; cv=none; b=De+ZyNB81VUtOyshKmCTXHnA76BZVynOZeUsNkWTXj4KIfVrp3M5n7WjaEifgbpplKXci7WetqPq7+CWhImYv1zYrTN7seC/iOOEN1ISenh/6TYBnshwl0OFQDDx7cK9oAg4vwc9sdLpRh0jh7Vv90T88PFkRezpxnjRFU1lYRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730017664; c=relaxed/simple;
	bh=l9hhujw59rfeda7wtIGqeZACyi1A6uOoHmQ6L1d/reE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dVIko0a06e1qbVW8io00d/NLug9kR25nxtvhmgNveemI1gYrvTsLK3s9Jo+ubDkKaCLFjhqj+34h2G3w630vps45YM93QN8HJ0rwVnnJN0sg8xMZPVcbPjGOqQiwp3rtDxHr5SlvJ0V7awSUiCAfACukBoULYiyFMWPVtOWtS34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ltJVkXWM; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ltJVkXWM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730017661; x=1761553661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l9hhujw59rfeda7wtIGqeZACyi1A6uOoHmQ6L1d/reE=;
  b=ltJVkXWMDqvSxrXsg78taDLkp56BeOoZAWv3iTBSpTbhp6y947erGrBV
   fQAmB/diygnFgpNLEvxP7Rzr1DYjJEDl2NWisqEKAtqi9MQYSvI6hLpv0
   mnNKk+RpV0B7F5V5VZyU24pF5bYw1TQt2TyRyZd+jrx6drzdkax1GqyvC
   mTWgykzGQnlVcMY2dHpCOv3lrNuy5K7UkiU+IHkPQqa5Xq29tZbi/dlZO
   JDvSXJCfDX8MZKTxKRSoKhwE2eHw6wNiL6X/uif3bVCvsby1biege5tfv
   CBHvWZakQ+J4zsA6RSQv/si6WB0wUCnFUA7soqh0lb2EmJFNcIA1LsSPQ
   Q==;
X-CSE-ConnectionGUID: +GjJ7cfeSFqZlVNoCgnfSA==
X-CSE-MsgGUID: vxKlmPKZRayqqv01FXSdHA==
X-IronPort-AV: E=Sophos;i="6.11,236,1725292800"; 
   d="scan'208";a="30942560"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2024 16:27:41 +0800
IronPort-SDR: 671deb08_WY5pAi0AdM0+2Ihmk90GDmv0ZGTBvz+6xNulBmYGajCZAFB
 cOGDtBvpld1yQExeIRBJIdqXJLTKzV51mP3qTVw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2024 00:26:00 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2024 01:27:40 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/2] scsi: ufs: core: Introduce a new clock_scaling lock
Date: Sun, 27 Oct 2024 10:25:19 +0200
Message-Id: <20241027082519.576869-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241027082519.576869-1-avri.altman@wdc.com>
References: <20241027082519.576869-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new clock gating lock to seriliaze access to the clock
scaling members instead of the host_lock.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 48 ++++++++++++++++++++-------------------
 include/ufs/ufshcd.h      |  2 ++
 2 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b7c7a7dd327f..fbaee68064c9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1449,14 +1449,14 @@ static void ufshcd_clk_scaling_suspend_work(struct work_struct *work)
 					   clk_scaling.suspend_work);
 	unsigned long irq_flags;
 
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
+	spin_lock_irqsave(&hba->clk_scaling.lock, irq_flags);
 	if (hba->clk_scaling.active_reqs || hba->clk_scaling.is_suspended) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		spin_unlock_irqrestore(&hba->clk_scaling.lock, irq_flags);
 		return;
 	}
 	hba->clk_scaling.is_suspended = true;
 	hba->clk_scaling.window_start_t = 0;
-	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+	spin_unlock_irqrestore(&hba->clk_scaling.lock, irq_flags);
 
 	devfreq_suspend_device(hba->devfreq);
 }
@@ -1467,13 +1467,13 @@ static void ufshcd_clk_scaling_resume_work(struct work_struct *work)
 					   clk_scaling.resume_work);
 	unsigned long irq_flags;
 
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
+	spin_lock_irqsave(&hba->clk_scaling.lock, irq_flags);
 	if (!hba->clk_scaling.is_suspended) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		spin_unlock_irqrestore(&hba->clk_scaling.lock, irq_flags);
 		return;
 	}
 	hba->clk_scaling.is_suspended = false;
-	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+	spin_unlock_irqrestore(&hba->clk_scaling.lock, irq_flags);
 
 	devfreq_resume_device(hba->devfreq);
 }
@@ -1508,15 +1508,15 @@ static int ufshcd_devfreq_target(struct device *dev,
 		*freq =	(unsigned long) clk_round_rate(clki->clk, *freq);
 	}
 
-	spin_lock_irqsave(hba->host->host_lock, irq_flags);
+	spin_lock_irqsave(&hba->clk_scaling.lock, irq_flags);
 	if (ufshcd_eh_in_progress(hba)) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		spin_unlock_irqrestore(&hba->clk_scaling.lock, irq_flags);
 		return 0;
 	}
 
 	/* Skip scaling clock when clock scaling is suspended */
 	if (hba->clk_scaling.is_suspended) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		spin_unlock_irqrestore(&hba->clk_scaling.lock, irq_flags);
 		dev_warn(hba->dev, "clock scaling is suspended, skip");
 		return 0;
 	}
@@ -1525,7 +1525,7 @@ static int ufshcd_devfreq_target(struct device *dev,
 		sched_clk_scaling_suspend_work = true;
 
 	if (list_empty(clk_list)) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		spin_unlock_irqrestore(&hba->clk_scaling.lock, irq_flags);
 		goto out;
 	}
 
@@ -1540,11 +1540,11 @@ static int ufshcd_devfreq_target(struct device *dev,
 
 	/* Update the frequency */
 	if (!ufshcd_is_devfreq_scaling_required(hba, *freq, scale_up)) {
-		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		spin_unlock_irqrestore(&hba->clk_scaling.lock, irq_flags);
 		ret = 0;
 		goto out; /* no state change required */
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+	spin_unlock_irqrestore(&hba->clk_scaling.lock, irq_flags);
 
 	start = ktime_get();
 	ret = ufshcd_devfreq_scale(hba, *freq, scale_up);
@@ -1577,7 +1577,7 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 
 	memset(stat, 0, sizeof(*stat));
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&scaling->lock, flags);
 	curr_t = ktime_get();
 	if (!scaling->window_start_t)
 		goto start_window;
@@ -1613,7 +1613,7 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 		scaling->busy_start_t = 0;
 		scaling->is_busy_started = false;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&scaling->lock, flags);
 	return 0;
 }
 
@@ -1683,13 +1683,13 @@ static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 	cancel_work_sync(&hba->clk_scaling.suspend_work);
 	cancel_work_sync(&hba->clk_scaling.resume_work);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_scaling.lock, flags);
 	if (!hba->clk_scaling.is_suspended) {
 		suspend = true;
 		hba->clk_scaling.is_suspended = true;
 		hba->clk_scaling.window_start_t = 0;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->clk_scaling.lock, flags);
 
 	if (suspend)
 		devfreq_suspend_device(hba->devfreq);
@@ -1700,12 +1700,12 @@ static void ufshcd_resume_clkscaling(struct ufs_hba *hba)
 	unsigned long flags;
 	bool resume = false;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_scaling.lock, flags);
 	if (hba->clk_scaling.is_suspended) {
 		resume = true;
 		hba->clk_scaling.is_suspended = false;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->clk_scaling.lock, flags);
 
 	if (resume)
 		devfreq_resume_device(hba->devfreq);
@@ -1791,6 +1791,8 @@ static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
 	INIT_WORK(&hba->clk_scaling.resume_work,
 		  ufshcd_clk_scaling_resume_work);
 
+	spin_lock_init(&hba->clk_scaling.lock);
+
 	hba->clk_scaling.workq = alloc_ordered_workqueue(
 		"ufs_clkscaling_%d", WQ_MEM_RECLAIM, hba->host->host_no);
 
@@ -2161,12 +2163,12 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_scaling.lock, flags);
 	if (!hba->clk_scaling.active_reqs++)
 		queue_resume_work = true;
 
 	if (!hba->clk_scaling.is_enabled || hba->pm_op_in_progress) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->clk_scaling.lock, flags);
 		return;
 	}
 
@@ -2184,7 +2186,7 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 		hba->clk_scaling.busy_start_t = curr_t;
 		hba->clk_scaling.is_busy_started = true;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->clk_scaling.lock, flags);
 }
 
 static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
@@ -2195,7 +2197,7 @@ static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_scaling.lock, flags);
 	hba->clk_scaling.active_reqs--;
 	if (!scaling->active_reqs && scaling->is_busy_started) {
 		scaling->tot_busy_t += ktime_to_us(ktime_sub(ktime_get(),
@@ -2203,7 +2205,7 @@ static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
 		scaling->busy_start_t = 0;
 		scaling->is_busy_started = false;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->clk_scaling.lock, flags);
 }
 
 static inline int ufshcd_monitor_opcode2dir(u8 opcode)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 52c822fe2944..058d27bc1e86 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -453,6 +453,7 @@ struct ufs_clk_gating {
  * @is_initialized: Indicates whether clock scaling is initialized or not
  * @is_busy_started: tracks if busy period has started or not
  * @is_suspended: tracks if devfreq is suspended or not
+ * @lock: seriliaze access to the clock_scaling members
  */
 struct ufs_clk_scaling {
 	int active_reqs;
@@ -472,6 +473,7 @@ struct ufs_clk_scaling {
 	bool is_busy_started;
 	bool is_suspended;
 	bool suspend_on_no_request;
+	spinlock_t lock;
 };
 
 #define UFS_EVENT_HIST_LENGTH 8
-- 
2.25.1

