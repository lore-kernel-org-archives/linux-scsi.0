Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8202E3D0C5;
	Sun, 27 Oct 2024 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730017664; cv=none; b=VAAA8A1LVGp9CARC3Ikq5SGhRncMvNxsUy2SkRCLknaeX7V78/QcCdYgfp94Zv0Onsn/5cuDFPE/MKPLvZx9wx8AH3D9XYq60++r73BDRQB/LT0vLA6Lwaj5xchGwbjKV5iaffuN5tvtWOzX6EC+1zAyeLerqAXE0UrCoH2Jdxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730017664; c=relaxed/simple;
	bh=wRbpG4cnISp2xmDEJr7oJJLS2I8E5ZPQNVDTKD22sxQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lR/BD3QPQKtVEWf4jma4wV28vTiXGxfXJT0VM7yuSZbrPZxaouSz3omXQBz2kBZHAIe9MkqSsQrrFTP/o1QYh4C3X+MvFO+ZuG0yxCUpqs6dCdEJcVu8MfFeaaHFxGikWmTOhpdJvNdRxOCON10nxsDg589It3+ysNb6zpO6IhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QkVr7o9F; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QkVr7o9F"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730017662; x=1761553662;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wRbpG4cnISp2xmDEJr7oJJLS2I8E5ZPQNVDTKD22sxQ=;
  b=QkVr7o9FNphHl4lYRywhm48jASF/7/KnL/cLN1Bgo3zAlgSvO9nKPJmC
   qWJuBdm+7I4Q6Baj1GbU1YNgElyPgtcivzMgT1j0zYxKWB7lycEVAIWfL
   KDRfPWzwwJE7lPSrBsPEnMSs9QQbwkFar+k1gzzns67iNup+Kk3Y2puE0
   /fe2xtWg7QjVGll1cX5HLApDyWD5lRWE6aksmB2mduBZNOLHY88KmrMOF
   6WvDuQkivCvD/b1HkP4vVqBvuGRYm9ArZJngpekyNyGU5F05T9EHT1OnF
   p1IQTQw/F8r9iJJJ7n9xbOywEC4njkLZa0VVcTvdu0ckMnVEGmGpMnCnw
   g==;
X-CSE-ConnectionGUID: b40aNuKRTT+KvvQb16DMtQ==
X-CSE-MsgGUID: D+dF3GcHSbiIIB3mK9luPQ==
X-IronPort-AV: E=Sophos;i="6.11,236,1725292800"; 
   d="scan'208";a="29954872"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2024 16:27:35 +0800
IronPort-SDR: 671deb02_a3VVkHLCy0furoYSlfslss8r33obvI3LhdQ0FzMZBtaf7LL
 Ch9GsV9m9O67MkrgHexEHRoc8IssPVlqwz+Z2lg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2024 00:25:54 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2024 01:27:34 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 1/2] scsi: ufs: core: Introduce a new clock_gating lock
Date: Sun, 27 Oct 2024 10:25:18 +0200
Message-Id: <20241027082519.576869-2-avri.altman@wdc.com>
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
gating members instead of the host_lock.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 44 ++++++++++++++++++++-------------------
 include/ufs/ufshcd.h      |  2 ++
 2 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 099373a25017..b7c7a7dd327f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1817,13 +1817,13 @@ static void ufshcd_ungate_work(struct work_struct *work)
 
 	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_gating.lock, flags);
 	if (hba->clk_gating.state == CLKS_ON) {
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
 		return;
 	}
 
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
 	ufshcd_hba_vreg_set_hpm(hba);
 	ufshcd_setup_clocks(hba, true);
 
@@ -1858,7 +1858,7 @@ void ufshcd_hold(struct ufs_hba *hba)
 	if (!ufshcd_is_clkgating_allowed(hba) ||
 	    !hba->clk_gating.is_initialized)
 		return;
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_gating.lock, flags);
 	hba->clk_gating.active_reqs++;
 
 start:
@@ -1874,11 +1874,11 @@ void ufshcd_hold(struct ufs_hba *hba)
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
@@ -1907,17 +1907,17 @@ void ufshcd_hold(struct ufs_hba *hba)
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
 
@@ -1928,7 +1928,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_gating.lock, flags);
 	/*
 	 * In case you are here to cancel this work the gating state
 	 * would be marked as REQ_CLKS_ON. In this case save time by
@@ -1946,7 +1946,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 	if (ufshcd_is_ufs_dev_busy(hba) || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
 		goto rel_lock;
 
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
 
 	/* put the link into hibern8 mode before turning off clocks */
 	if (ufshcd_can_hibern8_during_gating(hba)) {
@@ -1977,14 +1977,14 @@ static void ufshcd_gate_work(struct work_struct *work)
 	 * prevent from doing cancel work multiple times when there are
 	 * new requests arriving before the current cancel work is done.
 	 */
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_gating.lock, flags);
 	if (hba->clk_gating.state == REQ_CLKS_OFF) {
 		hba->clk_gating.state = CLKS_OFF;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
 	}
 rel_lock:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
 out:
 	return;
 }
@@ -2015,9 +2015,9 @@ void ufshcd_release(struct ufs_hba *hba)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_gating.lock, flags);
 	__ufshcd_release(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
 }
 EXPORT_SYMBOL_GPL(ufshcd_release);
 
@@ -2034,9 +2034,9 @@ void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value)
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_gating.lock, flags);
 	hba->clk_gating.delay_ms = value;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
 }
 EXPORT_SYMBOL_GPL(ufshcd_clkgate_delay_set);
 
@@ -2072,7 +2072,7 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 
 	value = !!value;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->clk_gating.lock, flags);
 	if (value == hba->clk_gating.is_enabled)
 		goto out;
 
@@ -2083,7 +2083,7 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 
 	hba->clk_gating.is_enabled = value;
 out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
 	return count;
 }
 
@@ -2125,6 +2125,8 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
 	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
 
+	spin_lock_init(&hba->clk_gating.lock);
+
 	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(
 		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
 		hba->host->host_no);
@@ -9173,11 +9175,11 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 				clk_disable_unprepare(clki->clk);
 		}
 	} else if (!ret && on) {
-		spin_lock_irqsave(hba->host->host_lock, flags);
+		spin_lock_irqsave(&hba->clk_gating.lock, flags);
 		hba->clk_gating.state = CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
 	}
 
 	if (clk_state_changed)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9ea2a7411bb5..52c822fe2944 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -413,6 +413,7 @@ enum clk_gating_state {
  * @active_reqs: number of requests that are pending and should be waited for
  * completion before gating clocks.
  * @clk_gating_workq: workqueue for clock gating work.
+ * @lock: serielize access to the clk_gating members
  */
 struct ufs_clk_gating {
 	struct delayed_work gate_work;
@@ -426,6 +427,7 @@ struct ufs_clk_gating {
 	bool is_initialized;
 	int active_reqs;
 	struct workqueue_struct *clk_gating_workq;
+	spinlock_t lock;
 };
 
 /**
-- 
2.25.1

