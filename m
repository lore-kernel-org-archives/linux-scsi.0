Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F42134B43F
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588021; cv=none; b=H8cxn5KrIz3cTRRek28He08SUZ25R7vQE9st0rfpm7zHLLmt5VGovc2S/QHmMO0HA8UIFJh3n/o9KQpHUBY2KKNyIPyKVOt0zNHC4edPQIeaoLx3AAptuXWVR+UPVGQ7rHpaLHFe1U7gtP8CjZmQrWm3W+hwgzsreE9imFD8AnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588021; c=relaxed/simple;
	bh=y/XwlRjMeE/CXhk6Anxi3vWP2U6Og8zeNNPBCclZ0lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlSUPBwvHaNl7Mkqwf1CqK52WKYYXYywnXdH0FIfQcANCeqbD40UfuxOW4QY6qQrxFu0HA3Jrr4OfWCAa5f7sRn8Gp/WoJ3LHklbA9SkFdGOOk5xdmw1b2L4fzrYckTHkYlfPRvAfQGOCN5qa2A4BaaFCBWiYbkbbWVrGHer9uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TFCk8ZPZ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TFCk8ZPZ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dt7c3709Pzlfl7l;
	Fri, 16 Jan 2026 18:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768588018; x=1771180019; bh=IrRHR
	c0+L3w/jQcYna6hVYfLWW+JrItRWlnQpr93yC0=; b=TFCk8ZPZzrw8IX0NothAb
	ul1Xt0OxJdru/vJzEWUvXrswvEuApfy7egeQgTxMp95Rp7v+1NJrJA0gBUo1MgUx
	He4lAwkw2qfMK01yUEUbLjLzk8vHjiamkvWR4JY8ffEqHPBMiTptkPKnIwDWxfQ/
	ARcoryT9uSkY4Gwpxl11YkgXaRstvb5l9GMdtoNoFCmSHYyX8K5Us7ZmmrP9StJA
	b21m4aNrVTJ/5jkVM4uJn69RNO5iC0hccoAZu3Z7HKWeAYYAExNoAUrICDcIao/n
	4o54bhLqwwaPPcimotww/T6r/+tWlOGePHWud4QpyCEixtRNZy+JoT3jyN9seExT
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id F9x2WACi4SAx; Fri, 16 Jan 2026 18:26:58 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dt7c01zqLzlgqw4;
	Fri, 16 Jan 2026 18:26:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 4/7] ufs: core: Switch from clock gating to RPM
Date: Fri, 16 Jan 2026 10:26:06 -0800
Message-ID: <20260116182628.3255116-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260116182628.3255116-1-bvanassche@acm.org>
References: <20260116182628.3255116-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make ufshcd_hold() and ufshcd_release() call RPM functions instead of
controlling clock gating directly. This patch does not change the power
consumption of systems with UFS devices: both clock gating and RPM
switch to the same low power state if the UFS device is not in use.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 103 +++-----------------------------------
 1 file changed, 8 insertions(+), 95 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 900b945444d1..b3d75152abd9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1936,72 +1936,10 @@ static void ufshcd_ungate_work(struct work_struct=
 *work)
  */
 void ufshcd_hold(struct ufs_hba *hba)
 {
-	bool flush_result;
-	unsigned long flags;
-
-	if (!ufshcd_is_clkgating_allowed(hba) ||
-	    !hba->clk_gating.is_initialized)
-		return;
-	spin_lock_irqsave(&hba->clk_gating.lock, flags);
-	hba->clk_gating.active_reqs++;
-
-start:
-	switch (hba->clk_gating.state) {
-	case CLKS_ON:
-		/*
-		 * Wait for the ungate work to complete if in progress.
-		 * Though the clocks may be in ON state, the link could
-		 * still be in hibner8 state if hibern8 is allowed
-		 * during clock gating.
-		 * Make sure we exit hibern8 state also in addition to
-		 * clocks being ON.
-		 */
-		if (ufshcd_can_hibern8_during_gating(hba) &&
-		    ufshcd_is_link_hibern8(hba)) {
-			spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
-			flush_result =3D flush_work(&hba->clk_gating.ungate_work);
-			if (hba->clk_gating.is_suspended && !flush_result)
-				return;
-			spin_lock_irqsave(&hba->clk_gating.lock, flags);
-			goto start;
-		}
-		break;
-	case REQ_CLKS_OFF:
-		if (cancel_delayed_work(&hba->clk_gating.gate_work)) {
-			hba->clk_gating.state =3D CLKS_ON;
-			trace_ufshcd_clk_gating(hba,
-						hba->clk_gating.state);
-			break;
-		}
-		/*
-		 * If we are here, it means gating work is either done or
-		 * currently running. Hence, fall through to cancel gating
-		 * work and to enable clocks.
-		 */
-		fallthrough;
-	case CLKS_OFF:
-		hba->clk_gating.state =3D REQ_CLKS_ON;
-		trace_ufshcd_clk_gating(hba,
-					hba->clk_gating.state);
-		queue_work(hba->clk_gating.clk_gating_workq,
-			   &hba->clk_gating.ungate_work);
-		/*
-		 * fall through to check if we should wait for this
-		 * work to be done or not.
-		 */
-		fallthrough;
-	case REQ_CLKS_ON:
-		spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
-		flush_work(&hba->clk_gating.ungate_work);
-		/* Make sure state is CLKS_ON before returning */
-		spin_lock_irqsave(&hba->clk_gating.lock, flags);
-		goto start;
-	default:
-		dev_err(hba->dev, "%s: clk gating is in invalid state %d\n",
-				__func__, hba->clk_gating.state);
-		break;
-	}
-	spin_unlock_irqrestore(&hba->clk_gating.lock, flags);
+	/* blk_pm_runtime_init() sets q->dev */
+	if (hba->ufs_device_wlun && hba->ufs_device_wlun->request_queue->dev &&
+	    !hba->pm_op_in_progress)
+		ufshcd_rpm_get_sync(hba);
 }
 EXPORT_SYMBOL_GPL(ufshcd_hold);
=20
@@ -2073,37 +2011,12 @@ static void ufshcd_gate_work(struct work_struct *=
work)
 	}
 }
=20
-static void __ufshcd_release(struct ufs_hba *hba)
-{
-	lockdep_assert_held(&hba->clk_gating.lock);
-
-	if (!ufshcd_is_clkgating_allowed(hba))
-		return;
-
-	hba->clk_gating.active_reqs--;
-
-	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
-	    !hba->clk_gating.is_initialized ||
-	    hba->clk_gating.state =3D=3D CLKS_OFF)
-		return;
-
-	scoped_guard(spinlock_irqsave, hba->host->host_lock) {
-		if (ufshcd_has_pending_tasks(hba) ||
-		    hba->ufshcd_state !=3D UFSHCD_STATE_OPERATIONAL)
-			return;
-	}
-
-	hba->clk_gating.state =3D REQ_CLKS_OFF;
-	trace_ufshcd_clk_gating(hba, hba->clk_gating.state);
-	queue_delayed_work(hba->clk_gating.clk_gating_workq,
-			   &hba->clk_gating.gate_work,
-			   msecs_to_jiffies(hba->clk_gating.delay_ms));
-}
-
 void ufshcd_release(struct ufs_hba *hba)
 {
-	guard(spinlock_irqsave)(&hba->clk_gating.lock);
-	__ufshcd_release(hba);
+	/* blk_pm_runtime_init() sets q->dev */
+	if (hba->ufs_device_wlun && hba->ufs_device_wlun->request_queue->dev &&
+	    !hba->pm_op_in_progress)
+		ufshcd_rpm_put(hba);
 }
 EXPORT_SYMBOL_GPL(ufshcd_release);
=20
