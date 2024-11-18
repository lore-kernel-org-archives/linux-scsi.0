Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C0F1991A5;
	Mon, 18 Nov 2024 14:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731941035; cv=none; b=oN/sXE51twDAXNjfRPFkY+nzM3budGYGn/YkJ2A3zL8STW1TV3W3BcUbQr19ETn8IEkwW9A1qtSQAnBcOVR6Na7j3vvfBcLn3uXB0FNPNE0i1y4rCQUnQ1qELFz7UQL+7NZulGoHaJ2P7oV5q+OKYJnVS2K8+23hVok+5I7r6uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731941035; c=relaxed/simple;
	bh=PlcCX5o6HUGi7WVYmruL6KxRf/YMFTlckzN9N7oZgvc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N24TG7+FRjhADTMi/TZnCs8HRmnTDMIb2373GFOnsNEdryxO8CjuJkwFMozcK6jNGlWgL3VamEJK5EFDoTMebQyaAWchTig7RTy/1jdFddd1lLvfzu5d9p3kq9sJiH0PYEck8g+9lVTIf9YCgJ0sEXWHEHlSQvOmY+snOvBFmms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=btK/ijAj; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="btK/ijAj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1731941034; x=1763477034;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PlcCX5o6HUGi7WVYmruL6KxRf/YMFTlckzN9N7oZgvc=;
  b=btK/ijAjN5plV8oIMzph5obXEzCqcYWD5aSUnXBiXJDgGyznZu+RPQLh
   X2wAa7nZspZG7ItiH1EqVdDrWSjGVqjpGxxedU7Y1tquiPCVvxpMvuQOt
   c/1wJlzkfI6wfpsdnkFST/Aw/yT7zahAeYZBeuw8PlGj/fwFK/v/O8bgv
   XEEIMjLqE33AYUr+na1/2iK2i8MPM+oYllXFivXqvz+jhJ9YBBstvW1Ll
   tTA5KAZ1aGm4dhdJZZeZa1QHP3MbUa3BYU6yIokcTdnJ6+h4f4xtPXC/L
   MnmKh1901SFVYDkn4kQrVTaDkY5NDcbiQuYu+vjr8vtbXU3qggxQZNya7
   A==;
X-CSE-ConnectionGUID: oxjVV1FVTx2SvX7Zel/ZRw==
X-CSE-MsgGUID: jCi6WiE/TnGB9j/2j3HLtg==
X-IronPort-AV: E=Sophos;i="6.12,164,1728921600"; 
   d="scan'208";a="31826984"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2024 22:43:53 +0800
IronPort-SDR: 673b4418_1vuE5oYtmiQDf4HNiPpYv3UBYsoboRFbDvLgv71NIgL+q+V
 NhqPTWQ2Lu62I5D6kJCY2hMdYGlVad91JTREJEQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2024 05:41:45 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2024 06:43:51 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 2/3] scsi: ufs: core: Introduce a new clock_gating lock
Date: Mon, 18 Nov 2024 16:41:16 +0200
Message-Id: <20241118144117.88483-3-avri.altman@wdc.com>
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
 drivers/ufs/core/ufshcd.c | 109 ++++++++++++++++++++------------------
 include/ufs/ufshcd.h      |   8 ++-
 2 files changed, 62 insertions(+), 55 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index be5fe2407382..638d9c0e2603 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1816,19 +1816,17 @@ static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
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
 
@@ -1863,7 +1861,7 @@ void ufshcd_hold(struct ufs_hba *hba)
 	if (!ufshcd_is_clkgating_allowed(hba) ||
 	    !hba->clk_gating.is_initialized)
 		return;
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_gating.lock, flags);
 	hba->clk_gating.active_reqs++;
 
 start:
@@ -1879,11 +1877,11 @@ void ufshcd_hold(struct ufs_hba *hba)
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
@@ -1912,17 +1910,17 @@ void ufshcd_hold(struct ufs_hba *hba)
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
 
@@ -1933,26 +1931,32 @@ static void ufshcd_gate_work(struct work_struct *work)
 	unsigned long flags;
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
+
+		if (hba->clk_gating.active_reqs)
+			return;
 	}
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (ufshcd_is_ufs_dev_busy(hba) ||
-	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
-	    hba->clk_gating.active_reqs)
-		goto rel_lock;
-
+	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		return;
+	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* put the link into hibern8 mode before turning off clocks */
@@ -1964,7 +1968,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 					__func__, ret);
 			trace_ufshcd_clk_gating(dev_name(hba->dev),
 						hba->clk_gating.state);
-			goto out;
+			return;
 		}
 		ufshcd_set_link_hibern8(hba);
 	}
@@ -1984,32 +1988,37 @@ static void ufshcd_gate_work(struct work_struct *work)
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
 static void __ufshcd_release(struct ufs_hba *hba)
 {
+	unsigned long flags;
+
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
 
 	hba->clk_gating.active_reqs--;
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
-	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
-	    ufshcd_has_pending_tasks(hba) || !hba->clk_gating.is_initialized ||
+	    !hba->clk_gating.is_initialized ||
 	    hba->clk_gating.state == CLKS_OFF)
 		return;
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (ufshcd_has_pending_tasks(hba) ||
+	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	hba->clk_gating.state = REQ_CLKS_OFF;
 	trace_ufshcd_clk_gating(dev_name(hba->dev), hba->clk_gating.state);
 	queue_delayed_work(hba->clk_gating.clk_gating_workq,
@@ -2019,11 +2028,8 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
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
 
@@ -2038,11 +2044,9 @@ static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
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
 
@@ -2070,7 +2074,6 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
-	unsigned long flags;
 	u32 value;
 
 	if (kstrtou32(buf, 0, &value))
@@ -2078,9 +2081,10 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 
 	value = !!value;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	guard(spinlock_irqsave)(&hba->clk_gating.lock);
+
 	if (value == hba->clk_gating.is_enabled)
-		goto out;
+		return count;
 
 	if (value)
 		__ufshcd_release(hba);
@@ -2088,8 +2092,7 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 		hba->clk_gating.active_reqs++;
 
 	hba->clk_gating.is_enabled = value;
-out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	return count;
 }
 
@@ -2131,6 +2134,8 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
 	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
 
+	spin_lock_init(&hba->clk_gating.lock);
+
 	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(
 		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
 		hba->host->host_no);
@@ -9120,7 +9125,6 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 	int ret = 0;
 	struct ufs_clk_info *clki;
 	struct list_head *head = &hba->clk_list_head;
-	unsigned long flags;
 	ktime_t start = ktime_get();
 	bool clk_state_changed = false;
 
@@ -9171,11 +9175,10 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
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

