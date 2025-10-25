Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBC33043D4;
	Sat, 25 Oct 2025 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409141; cv=none; b=i5HR2x83YZK1fK0kg9Fn71wpDJb4zu/dKZDOBO5GyYycGokn8G9lr3wZjWeAM5Whi+LUvfCER1vpLd9zky823O+huG/4sjdbb3rF2ssgqgYWUCaEHxWSdOgOtPBrGDgyhDq6QzerjpWUlgOHeBI4PmWjI+0A/T/7cdQEDJMzgZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409141; c=relaxed/simple;
	bh=ed28bBdQA5ykm/RPiIaaitqo0+JNP8JIrkeHbGhDazY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lVXvF37adG9PIDn3mgxOOOIoA+DQhzW2SWy5mNd6AYWGdazxcWtYyXcmu1jmP50vfoRUbh5OKROP9seZQn6QwZlzB8fro9cqXiw2bkhfRprcQFePMUXrEOxOeKNJOVJ4qK7ZxVKLlR2X2xNTDzWBaw1CNQ/5SpR8D6P+PQm286k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJ1/uYDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJ1/uYDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A0FC4CEF5;
	Sat, 25 Oct 2025 16:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409141;
	bh=ed28bBdQA5ykm/RPiIaaitqo0+JNP8JIrkeHbGhDazY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJ1/uYDUPFngu/aVK6/hg3nv4yGQp5KDTS5vS+WyewH1x1d4RR6ZsLDfXcYnl1X5/
	 jelBaruVU8rpnHnUlAdvsJtp+R3FXQ/NPn5K0PXDlDj4rMC9oLm4WO8Rry9EhxgdbJ
	 I72NlW+H1wM8FU1n31vdf1lBeA03kDsy7g50cWwbXH5veK/FN43DiGVb/O0WenbtWF
	 KJ75e985e0mgDpGIij/aOuHDqPC3F1f/YcZ9CrpitGjT1VX+oCF4wxBvqj3/2VKH6i
	 nTv8Fnt+f3JqQq68fDZlVdF59drdkdY3ln7265tPBmjXALHFDjEk6jmcCFUU1uPOV5
	 AbBdC2+VLIuRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	avri.altman@sandisk.com,
	beanhuo@micron.com,
	alexandre.f.demers@gmail.com,
	adrian.hunter@intel.com,
	quic_cang@quicinc.com,
	ebiggers@kernel.org,
	quic_nitirawa@quicinc.com,
	neil.armstrong@linaro.org,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.6] scsi: ufs: host: mediatek: Enhance recovery on hibernation exit failure
Date: Sat, 25 Oct 2025 11:57:25 -0400
Message-ID: <20251025160905.3857885-214-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit faac32d4ece30609f1a0930ca0ae951cf6dc1786 ]

Improve the recovery process for hibernation exit failures. Trigger the
error handler and break the suspend operation to ensure effective
recovery from hibernation errors. Activate the error handling mechanism
by ufshcd_force_error_recovery and scheduling the error handler work.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real bug that affects users: previously, a failure to exit
  hibernation (H8) during suspend was only warned about and suspend
  continued, risking a stuck/broken UFS link and subsequent I/O hangs.
  The patch turns this into a recoverable path by triggering the error
  handler and aborting suspend.
- Small, contained change with clear intent:
  - Makes the core helper available to host drivers by de-static’ing and
    exporting `ufshcd_force_error_recovery()` and declaring it in the
    UFS header:
    - `drivers/ufs/core/ufshcd.c:6471` acquires `host_lock`, sets
      `hba->force_reset = true`, invokes `ufshcd_schedule_eh_work()`,
      and is exported via
      `EXPORT_SYMBOL_GPL(ufshcd_force_error_recovery)`.
    - `include/ufs/ufshcd.h:1489` adds `void
      ufshcd_force_error_recovery(struct ufs_hba *hba);`
  - Uses that helper in the MediaTek host driver to recover from H8 exit
    failures and to abort suspend:
    - `drivers/ufs/host/ufs-mediatek.c:1436` changes
      `ufs_mtk_auto_hibern8_disable()` to return `int` and to return an
      error on failure.
    - `drivers/ufs/host/ufs-mediatek.c:1454` calls
      `ufshcd_force_error_recovery(hba)` when
      `ufs_mtk_wait_link_state(..., VS_LINK_UP, ...)` fails, then sets
      `ret = -EBUSY` to break suspend.
    - `drivers/ufs/host/ufs-mediatek.c:1750` propagates the PRE_CHANGE
      failure by `return ufs_mtk_auto_hibern8_disable(hba);` in
      `ufs_mtk_suspend()`.
- Correct integration with the core suspend flow: the UFS core checks
  vendor PRE_CHANGE return and aborts on error:
  - `drivers/ufs/core/ufshcd.c:9899` calls `ufshcd_vops_suspend(hba,
    pm_op, PRE_CHANGE)` and if `ret` is non-zero it aborts the suspend
    path, re-enables scaling, and unwinds cleanly.
- Error handling sequencing is robust:
  - `drivers/ufs/core/ufshcd.c:6456` `ufshcd_schedule_eh_work()` sets
    `ufshcd_state` to `UFSHCD_STATE_EH_SCHEDULED_FATAL` if `force_reset`
    or fatal conditions are detected and queues `eh_work`, ensuring the
    error handler runs promptly.
- Scope and risk:
  - No architectural changes; it’s a targeted behavioral fix in the
    MediaTek UFS suspend path plus a symbol export in the UFS core for
    in-tree drivers.
  - Only triggers additional actions on an existing error path (H8 exit
    failure). Normal suspend paths are unchanged.
  - Storage reliability fix in a critical subsystem, but contained to
    UFS/Mediatek host and UFS core error handling.
- Stable tree criteria alignment:
  - Fixes an important reliability bug (avoids continuing suspend with a
    broken link and prevents I/O hang).
  - Minimal, surgical changes, no new features.
  - No broad side effects; the exported helper is internal API used by
    in-tree code.
  - No major refactoring or dependency churn.

Given the above, this is a strong candidate for stable backporting.

 drivers/ufs/core/ufshcd.c       |  3 ++-
 drivers/ufs/host/ufs-mediatek.c | 14 +++++++++++---
 include/ufs/ufshcd.h            |  1 +
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 465e66dbe08e8..78d3f0ee16d84 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6462,13 +6462,14 @@ void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 	}
 }
 
-static void ufshcd_force_error_recovery(struct ufs_hba *hba)
+void ufshcd_force_error_recovery(struct ufs_hba *hba)
 {
 	spin_lock_irq(hba->host->host_lock);
 	hba->force_reset = true;
 	ufshcd_schedule_eh_work(hba);
 	spin_unlock_irq(hba->host->host_lock);
 }
+EXPORT_SYMBOL_GPL(ufshcd_force_error_recovery);
 
 static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
 {
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 055b24758ca3d..6bdbbee1f0708 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1646,7 +1646,7 @@ static void ufs_mtk_dev_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 	}
 }
 
-static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
+static int ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 {
 	int ret;
 
@@ -1657,8 +1657,16 @@ static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 	ufs_mtk_wait_idle_state(hba, 5);
 
 	ret = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
-	if (ret)
+	if (ret) {
 		dev_warn(hba->dev, "exit h8 state fail, ret=%d\n", ret);
+
+		ufshcd_force_error_recovery(hba);
+
+		/* trigger error handler and break suspend */
+		ret = -EBUSY;
+	}
+
+	return ret;
 }
 
 static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
@@ -1669,7 +1677,7 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 
 	if (status == PRE_CHANGE) {
 		if (ufshcd_is_auto_hibern8_supported(hba))
-			ufs_mtk_auto_hibern8_disable(hba);
+			return ufs_mtk_auto_hibern8_disable(hba);
 		return 0;
 	}
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a3fa98540d184..a4eb5bde46e88 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1511,5 +1511,6 @@ int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask);
 int ufshcd_write_ee_control(struct ufs_hba *hba);
 int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask,
 			     const u16 *other_mask, u16 set, u16 clr);
+void ufshcd_force_error_recovery(struct ufs_hba *hba);
 
 #endif /* End of Header */
-- 
2.51.0

