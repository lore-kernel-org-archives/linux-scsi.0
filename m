Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B7D1DEFFE;
	Tue, 29 Oct 2024 10:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730197918; cv=none; b=FR1DY7daviKfiWxseOqVTEFOwcEa7FYGl8eDmY1FzaakHSVq6gOq7FWOajXN0NG2ZJRFnpxI1U0YaCkV131VMSTGf5Car2EDRg4yl8UdZ22RGBY6QQKTdMKBLf9IoKOvi2Vxd7JSesoOQWxwkmHPvTu9XDGqiiFZBibtwN0gya8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730197918; c=relaxed/simple;
	bh=COG3vQBKl+r+2u1Qlh+wN2tCLYwTgHlUpYcLXzaEdk0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CcBEqMeTEVHUidzp4gy/Q08G5266qJnPQQvKOJYMW87KmHgspnfcsEPm6Kgbz1Lh3S6dNtqFu3dK1G1xc6K90WOUgkzq9byMQ32Lu0i9VMEkWFC6Bd0rLBwxeK17s3NVbRrAo5XbET3cAdo4UKxS+yjVjXHaYbLY9eQUCo56oGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pK651qYh; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pK651qYh"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730197915; x=1761733915;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=COG3vQBKl+r+2u1Qlh+wN2tCLYwTgHlUpYcLXzaEdk0=;
  b=pK651qYh/hKi+x2ZFrkSZmpvjfnE7K/eWnB8QEFmABN1WvAYqJad2sZ0
   PhwuQuzTzMGm5I1ZlrZmT6Id9wRhAhjhbcPcrJyMrDmrHe3IfivtBMXH6
   0P0AlD/tlsWcuXntC3PWteFMsEYPzjMB+rR6u1JyEeQuW9x1fk0//1hnn
   ehT2a1H5oat4llPHu/7XMFU4viCHNklV14FNfiHyWD/m+hKlk/ZJ/fnxu
   yJzXQ4ofvHEFIK964SA+XrqwTlQVafB5fhppoJOt8ZJySYjlWOjpKyJ3G
   1fUJHRqMuXhYuFyRq98gBmDJY46x5u/KFcadIueA2nIGzNVN6LSkCFZd+
   g==;
X-CSE-ConnectionGUID: 9Nf2Bw0KRaWZmbTwOT33NQ==
X-CSE-MsgGUID: wZnS/tfgQMmIz08d4aozxA==
X-IronPort-AV: E=Sophos;i="6.11,241,1725292800"; 
   d="scan'208";a="31231848"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 29 Oct 2024 18:31:54 +0800
IronPort-SDR: 6720ac6d_d/F11HBVHcvZ/g4jWo+1KsmpCdAoGaTDoak3bRfcGsqA2uT
 l5rklNI7FAoDRaSq+bWgBbbTlmYTOFC+17cDHeQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2024 02:35:41 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2024 03:31:53 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 1/2] scsi: ufs: core: Introduce a new clock_gating lock
Date: Tue, 29 Oct 2024 12:29:37 +0200
Message-Id: <20241029102938.685835-2-avri.altman@wdc.com>
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

Introduce a new clock gating lock to serialize access to some of the
clock gating members instead of the host_lock.

While at it, simplify the code with the guard() macro and co for
automatic cleanup of the new lock. There are some explicit
spin_lock_irqsave/spin_unlock_irqrestore snaking instances I left behind
because I couldn't make heads or tails of it.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 97 ++++++++++++++++-----------------------
 include/ufs/ufshcd.h      |  8 +++-
 2 files changed, 46 insertions(+), 59 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 099373a25017..3373debe7b94 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1811,19 +1811,16 @@ static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
 static void ufshcd_ungate_work(struct work_struct *work)
 {
 	int ret;
-	unsigned long flags;
 	struct ufs_hba *hba = container_of(work, struct ufs_hba,
 			clk_gating.ungate_work);
 
 	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->clk_gating.state == CLKS_ON) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		return;
+	scoped_guard(spinlock_irqsave, &hba->clk_gating.lock) {
+		if (hba->clk_gating.state == CLKS_ON)
+			return;
 	}
 
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_hba_vreg_set_hpm(hba);
 	ufshcd_setup_clocks(hba, true);
 
@@ -1858,7 +1855,7 @@ void ufshcd_hold(struct ufs_hba *hba)
 	if (!ufshcd_is_clkgating_allowed(hba) ||
 	    !hba->clk_gating.is_initialized)
 		return;
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_gating.lock, flags);
 	hba->clk_gating.active_reqs++;
 
 start:
@@ -1874,11 +1871,11 @@ void ufshcd_hold(struct ufs_hba *hba)
 		 */
 		if (ufshcd_can_hibern8_during_gating(hba) &&
 		    ufshcd_is_link_hibern8(hba)) {
-			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
 			flush_result = flush_work(&hba->clk_gating.ungate_work);
 			if (hba->clk_gating.is_suspended && !flush_result)
 				return;
-			spin_lock_irqsave(hba->host->host_lock, flags);
+			spin_lock_irqsave(&hba->clk_gating.lock, flags);
 			goto start;
 		}
 		break;
@@ -1907,17 +1904,17 @@ void ufshcd_hold(struct ufs_hba *hba)
 		 */
 		fallthrough;
 	case REQ_CLKS_ON:
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
 		flush_work(&hba->clk_gating.ungate_work);
 		/* Make sure state is CLKS_ON before returning */
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->clk_gating.lock, flags);
 		goto start;
 	default:
 		dev_err(hba->dev, "%s: clk gating is in invalid state %d\n",
 				__func__, hba->clk_gating.state);
 		break;
 	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
 }
 EXPORT_SYMBOL_GPL(ufshcd_hold);
 
@@ -1925,29 +1922,24 @@ static void ufshcd_gate_work(struct work_struct *work)
 {
 	struct ufs_hba *hba = container_of(work, struct ufs_hba,
 			clk_gating.gate_work.work);
-	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	/*
-	 * In case you are here to cancel this work the gating state
-	 * would be marked as REQ_CLKS_ON. In this case save time by
-	 * skipping the gating work and exit after changing the clock
-	 * state to CLKS_ON.
-	 */
-	if (hba->clk_gating.is_suspended ||
-		(hba->clk_gating.state != REQ_CLKS_OFF)) {
-		hba->clk_gating.state = CLKS_ON;
-		trace_ufshcd_clk_gating(dev_name(hba->dev),
-					hba->clk_gating.state);
-		goto rel_lock;
+	scoped_guard(spinlock_irqsave, &hba->clk_gating.lock) {
+		/*
+		 * In case you are here to cancel this work the gating state
+		 * would be marked as REQ_CLKS_ON. In this case save time by
+		 * skipping the gating work and exit after changing the clock
+		 * state to CLKS_ON.
+		 */
+		if (hba->clk_gating.is_suspended || (hba->clk_gating.state != REQ_CLKS_OFF)) {
+			hba->clk_gating.state = CLKS_ON;
+			trace_ufshcd_clk_gating(dev_name(hba->dev), hba->clk_gating.state);
+			return;
+		}
+		if (ufshcd_is_ufs_dev_busy(hba) || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
+			return;
 	}
 
-	if (ufshcd_is_ufs_dev_busy(hba) || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
-		goto rel_lock;
-
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
 	/* put the link into hibern8 mode before turning off clocks */
 	if (ufshcd_can_hibern8_during_gating(hba)) {
 		ret = ufshcd_uic_hibern8_enter(hba);
@@ -1957,7 +1949,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 					__func__, ret);
 			trace_ufshcd_clk_gating(dev_name(hba->dev),
 						hba->clk_gating.state);
-			goto out;
+			return;
 		}
 		ufshcd_set_link_hibern8(hba);
 	}
@@ -1977,16 +1969,12 @@ static void ufshcd_gate_work(struct work_struct *work)
 	 * prevent from doing cancel work multiple times when there are
 	 * new requests arriving before the current cancel work is done.
 	 */
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	guard(spinlock_irqsave)(&hba->clk_gating.lock);
 	if (hba->clk_gating.state == REQ_CLKS_OFF) {
 		hba->clk_gating.state = CLKS_OFF;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
 	}
-rel_lock:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-out:
-	return;
 }
 
 /* host lock must be held before calling this variant */
@@ -2013,11 +2001,9 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 void ufshcd_release(struct ufs_hba *hba)
 {
-	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	guard(spinlock_irqsave)(&hba->clk_gating.lock);
 	__ufshcd_release(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 EXPORT_SYMBOL_GPL(ufshcd_release);
 
@@ -2032,11 +2018,9 @@ static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
 void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
-	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	guard(spinlock_irqsave)(&hba->clk_gating.lock);
 	hba->clk_gating.delay_ms = value;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 EXPORT_SYMBOL_GPL(ufshcd_clkgate_delay_set);
 
@@ -2064,7 +2048,6 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
-	unsigned long flags;
 	u32 value;
 
 	if (kstrtou32(buf, 0, &value))
@@ -2072,18 +2055,18 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 
 	value = !!value;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (value == hba->clk_gating.is_enabled)
-		goto out;
+	scoped_guard(spinlock_irqsave, &hba->clk_gating.lock) {
+		if (value == hba->clk_gating.is_enabled)
+			goto out;
 
-	if (value)
-		__ufshcd_release(hba);
-	else
-		hba->clk_gating.active_reqs++;
+		if (value)
+			__ufshcd_release(hba);
+		else
+			hba->clk_gating.active_reqs++;
 
-	hba->clk_gating.is_enabled = value;
+		hba->clk_gating.is_enabled = value;
+	}
 out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	return count;
 }
 
@@ -2125,6 +2108,8 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
 	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
 
+	spin_lock_init(&hba->clk_gating.lock);
+
 	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(
 		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
 		hba->host->host_no);
@@ -9122,7 +9107,6 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 	int ret = 0;
 	struct ufs_clk_info *clki;
 	struct list_head *head = &hba->clk_list_head;
-	unsigned long flags;
 	ktime_t start = ktime_get();
 	bool clk_state_changed = false;
 
@@ -9173,11 +9157,10 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 				clk_disable_unprepare(clki->clk);
 		}
 	} else if (!ret && on) {
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		hba->clk_gating.state = CLKS_ON;
+		scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
+			hba->clk_gating.state = CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
 	}
 
 	if (clk_state_changed)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9ea2a7411bb5..3d42532efbd1 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -402,6 +402,8 @@ enum clk_gating_state {
  * delay_ms
  * @ungate_work: worker to turn on clocks that will be used in case of
  * interrupt context
+ * @clk_gating_workq: workqueue for clock gating work.
+ * @lock: serialize access to some struct ufs_clk_gating members
  * @state: the current clocks state
  * @delay_ms: gating delay in ms
  * @is_suspended: clk gating is suspended when set to 1 which can be used
@@ -412,11 +414,14 @@ enum clk_gating_state {
  * @is_initialized: Indicates whether clock gating is initialized or not
  * @active_reqs: number of requests that are pending and should be waited for
  * completion before gating clocks.
- * @clk_gating_workq: workqueue for clock gating work.
  */
 struct ufs_clk_gating {
 	struct delayed_work gate_work;
 	struct work_struct ungate_work;
+	struct workqueue_struct *clk_gating_workq;
+
+	spinlock_t lock;
+
 	enum clk_gating_state state;
 	unsigned long delay_ms;
 	bool is_suspended;
@@ -425,7 +430,6 @@ struct ufs_clk_gating {
 	bool is_enabled;
 	bool is_initialized;
 	int active_reqs;
-	struct workqueue_struct *clk_gating_workq;
 };
 
 /**
-- 
2.25.1

