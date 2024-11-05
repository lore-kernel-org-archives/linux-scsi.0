Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F861D5141;
	Tue,  5 Nov 2024 11:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730806044; cv=none; b=fyDtn/hdwjkpEKVQ1PPaX5TprlyoAhOX+6FdzgM1T/p7o3IBUU3TRcq+1ZHHQBMp/44CV3W2LWXxveIP94nSeREjsxbBQz+pEAYdsF63C3zplRPEtiNMMwXqPs4YQvbWq+yrrsFM6HLTR9dMAkPMXUS8cu9QxmVNyY46dEKmwNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730806044; c=relaxed/simple;
	bh=bEQl20kkXoGg6dX5+DzkHWpV3POYY42axNOgUIrvhSY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WHw8cdHTpQHJ0cxboyd3ivaPGQ6OP5da17NBUt9GN9OhKWy36TBXqKUND2IGBccX23nL0LKjcDMDtfNDiw8IKFMlrVBVFKRjZlP5tbzcKHFaDoOgtED4OiQFHJl2b0fZSTMOzt3Vz6hocQvGePvqiHPAVZEAXZgF7HOjsBTlg/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FTFLQ/OF; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FTFLQ/OF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730806042; x=1762342042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bEQl20kkXoGg6dX5+DzkHWpV3POYY42axNOgUIrvhSY=;
  b=FTFLQ/OF3m06xjqa8OedoEf+dnmLboOMN5djzdBgxtKC7OJKSUSPGU0J
   VxoA6mMyowmBYGGTn9YiUN8EnHvungJvP4caW+8WoDrSI9WIAZwb63UPP
   lZxeJeu0bMwOVzlae8rLwLXpaXAdngYRBI7aCoBelMHEzIQjboxVfhySA
   059yM6rnZKFcnRxdMV1sFayay9gr3gs6SrIC/UKreRl9WAQJQ1jKS+vMY
   n5sJJvOLoeMH10djrMNdeNNIotymMML8aqWebHP+hIOb8rbZR/reyQgR/
   V9Jnk1zbwGsomuq7LbHsO9ieAnN35BuF3N229TEcM+WpIv59ZKEHSxBiJ
   A==;
X-CSE-ConnectionGUID: sa8QJwOdR8OqH7gzA2l0XQ==
X-CSE-MsgGUID: yFUB4IGER2G2hk9reLsvOA==
X-IronPort-AV: E=Sophos;i="6.11,260,1725292800"; 
   d="scan'208";a="30658789"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Nov 2024 19:27:19 +0800
IronPort-SDR: 6729f296_NV7mEq5i6qmMCHIAMz2bZ3vKg4bzwpbsdrDVdHbt4XRoDUB
 pUX2PFcc4c7aFSUqw4WtjSk4d8ItjKxicJMNlgQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Nov 2024 02:25:27 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Nov 2024 03:27:19 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 1/2] scsi: ufs: core: Introduce a new clock_gating lock
Date: Tue,  5 Nov 2024 13:25:01 +0200
Message-Id: <20241105112502.710427-2-avri.altman@wdc.com>
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

Introduce a new clock gating lock to serialize access to some of the
clock gating members instead of the host_lock.

While at it, simplify the code with the guard() macro and co for
automatic cleanup of the new lock. There are some explicit
spin_lock_irqsave/spin_unlock_irqrestore snaking instances I left behind
because I couldn't make heads or tails of it.

Additionally, move the trace_ufshcd_clk_gating() call from inside the
region protected by the lock as it doesn't needs protection.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 93 +++++++++++++++++----------------------
 include/ufs/ufshcd.h      |  8 +++-
 2 files changed, 46 insertions(+), 55 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e338867bc96c..62c0e2323f50 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1811,19 +1811,17 @@ static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
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
+	scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
+	{
+		if (hba->clk_gating.state == CLKS_ON)
+			return;
 	}
 
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_hba_vreg_set_hpm(hba);
 	ufshcd_setup_clocks(hba, true);
 
@@ -1858,7 +1856,7 @@ void ufshcd_hold(struct ufs_hba *hba)
 	if (!ufshcd_is_clkgating_allowed(hba) ||
 	    !hba->clk_gating.is_initialized)
 		return;
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_gating.lock, flags);
 	hba->clk_gating.active_reqs++;
 
 start:
@@ -1874,11 +1872,11 @@ void ufshcd_hold(struct ufs_hba *hba)
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
@@ -1907,17 +1905,17 @@ void ufshcd_hold(struct ufs_hba *hba)
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
 
@@ -1925,29 +1923,28 @@ static void ufshcd_gate_work(struct work_struct *work)
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
+	scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
+	{
+		/*
+		 * In case you are here to cancel this work the gating state
+		 * would be marked as REQ_CLKS_ON. In this case save time by
+		 * skipping the gating work and exit after changing the clock
+		 * state to CLKS_ON.
+		 */
+		if (hba->clk_gating.is_suspended ||
+		    hba->clk_gating.state != REQ_CLKS_OFF) {
+			hba->clk_gating.state = CLKS_ON;
+			trace_ufshcd_clk_gating(dev_name(hba->dev),
+						hba->clk_gating.state);
+			return;
+		}
+		if (ufshcd_is_ufs_dev_busy(hba) ||
+		    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
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
@@ -1957,7 +1954,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 					__func__, ret);
 			trace_ufshcd_clk_gating(dev_name(hba->dev),
 						hba->clk_gating.state);
-			goto out;
+			return;
 		}
 		ufshcd_set_link_hibern8(hba);
 	}
@@ -1977,16 +1974,12 @@ static void ufshcd_gate_work(struct work_struct *work)
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
@@ -2013,11 +2006,8 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 void ufshcd_release(struct ufs_hba *hba)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	guard(spinlock_irqsave)(&hba->clk_gating.lock);
 	__ufshcd_release(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 EXPORT_SYMBOL_GPL(ufshcd_release);
 
@@ -2032,11 +2022,9 @@ static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
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
 
@@ -2064,7 +2052,6 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
-	unsigned long flags;
 	u32 value;
 
 	if (kstrtou32(buf, 0, &value))
@@ -2072,9 +2059,10 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 
 	value = !!value;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	guard(spinlock_irqsave)(&hba->clk_gating.lock);
+
 	if (value == hba->clk_gating.is_enabled)
-		goto out;
+		return count;
 
 	if (value)
 		__ufshcd_release(hba);
@@ -2082,8 +2070,7 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 		hba->clk_gating.active_reqs++;
 
 	hba->clk_gating.is_enabled = value;
-out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	return count;
 }
 
@@ -2125,6 +2112,8 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
 	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
 
+	spin_lock_init(&hba->clk_gating.lock);
+
 	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(
 		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
 		hba->host->host_no);
@@ -9112,7 +9101,6 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 	int ret = 0;
 	struct ufs_clk_info *clki;
 	struct list_head *head = &hba->clk_list_head;
-	unsigned long flags;
 	ktime_t start = ktime_get();
 	bool clk_state_changed = false;
 
@@ -9163,11 +9151,10 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
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
index d7aca9e61684..8f9997b0dbf9 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -403,6 +403,8 @@ enum clk_gating_state {
  * delay_ms
  * @ungate_work: worker to turn on clocks that will be used in case of
  * interrupt context
+ * @clk_gating_workq: workqueue for clock gating work.
+ * @lock: serialize access to some struct ufs_clk_gating members
  * @state: the current clocks state
  * @delay_ms: gating delay in ms
  * @is_suspended: clk gating is suspended when set to 1 which can be used
@@ -413,11 +415,14 @@ enum clk_gating_state {
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
@@ -426,7 +431,6 @@ struct ufs_clk_gating {
 	bool is_enabled;
 	bool is_initialized;
 	int active_reqs;
-	struct workqueue_struct *clk_gating_workq;
 };
 
 /**
-- 
2.25.1

