Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794460564;
	b=carnfOjTJEpJrA9oyHvJ+bkHsmp0EsS0fHWGXZ7SBnLyqM0M0CHRBTo8RcncfnD94Vbe
	 i4ekfMZ262Zv48LeJTZwJ6VkvFWPen/I9OJXB4jJbuhDGnY04RBnY+aBq3AMQtD00udZm
	 flOZabCHsWcIjxsvb8wAbrPbmUoJrV0FDPVBvsEi93CmCHmgE3UYqRnhWEbrzIrXscVe9
	 FHUN7bDHqvlTu5oqdEZCz3rFyhpr05uHQVT5N7VERFF2WL9LhnREvvhJ8t5cTqaN2k007
	 OeUGWJDcCp+UiIbq/SdQM4vvLofnZqW38K2uSmZynDL/7GBpchvphsuEANzfHo+dHew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794460564;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=eZTsjMBzf7hkzFvFMASrAssmGO8BZ301V6ARC9oE1w8=;
	b=YnvdZnaoVm4PYPgP+CZFlGHXljp0EHM88sSA4V10h2F02USO6MOFCVQSVo3zzutlW8ul
	 yVE8Dq7OadAMaztuVWJ+22yrqmJmxC1E0kYGquvquXjCjJHHp+wzPzxbHhQvvHhvvQjQY
	 RvxJoGMVfKVeICCtm42IkjGmOBUCXL3O9uXmTilM+CI+unIf2lmLKVCl6Zp1mBDxo3HCt
	 bFxDvXFW7b1Qg0QEKDcBdPHhx659xUPLFWs6FvF9g15TTb9ulg0XBLYWLmzcWSsH32fB/
	 D3tbEMhzDGNr2wA/ftKOCVG50IBfB2v+0vAtw/R/9gv4PKPHDyzrL5GLGljtUWGr/mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=heDacrix;
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2F360A3804
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 05:16:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C2F360A3804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=heDacrix
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8b7614e9762so3228323b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 21:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794460563; x=1795065363; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eZTsjMBzf7hkzFvFMASrAssmGO8BZ301V6ARC9oE1w8=;
        b=heDacrixsJXBDLYHZ+Fl+YQe83Nx2MOrhxTs0K7YRX/PRwGKvAb8LvutxthkpkU+pi
         sfI06RpJT0Fxq0F9YMTegQaZDxoDnakrTbMqtHC47SRAEFJHR3Lf9SYVvGdYU1RwzEk0
         4pGQ3ax1GKUqZ9dIZJ2mzOVhdWlX7jc6N9UQsSNFLz7eqpVH2ykVSNL60fJbUlFg4nIt
         r21CvSGk4q6DfokDSGP8gmy3baUQI+8snWD+Nujalgh2SGSbQ4wii/QnZH4m39w6nPoX
         Mg+Yalito5BhUjzDHvOFy0U92jTk1krnrgfi0kRWhJHte3FAI3Mi3Dd6CaiUC+OGnF2k
         v95Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794460563; x=1795065363;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eZTsjMBzf7hkzFvFMASrAssmGO8BZ301V6ARC9oE1w8=;
        b=Xj80UoNwTyKxgaLcRQgTgrej1azPuK1gXpYtDKmJ0pC/rn3ytq+g23+Bfc5mBXuKdI
         rkCukeBRXbofOLnm+OH/q5ZkDSjyGNSZ9iFzkA7btls9zMkdOpbfUWTqe3n9SYNQXJYc
         6g8ox8sL6T6cJwIC1gGjTCzDWstMY0GllbzfI2AYJxXxz1qXuaSNJ8ShY7l9ILU1bi8T
         N6QV4wn+vGiTDbYoyQGiHTidRL3ANCDixyz5WH8FIcbCoW3eevvD+fKCQIJSbz+Lut7Z
         wEWwjf+6axMw6JGy4gZr4KpwmYEDS5jDFH9GFNk54VDh6e+MsEF30JdJBfBW8U1s1zVV
         dAPg==
X-Gm-Message-State: APuU4Z8oRBUQbpJ/LhPhHGAYYGhxho6U/yF8XrOoGWNhfXZhWa2Jeq1U
	Ol2Lzwy0KgRmEIN+FGGa8Yitc2p2zWtThV8GaVltUlFF/B6mRW2NdgYQ6Zc02mdVH1UtZ1xz8Db
	NDno/Ew5hpJAKfb21whAlTyNnxDcOAVkdWG4NUhCrisa4PFP04tBrAFSUKY3990urSQMIcEU5RB
	Yn8BCmzUk+a6YVcYNvtaVg2g1fXbDoc2A2TWkdmJuWPhNADNPR1GrMBQgflDroV4E=
X-Received: from pfbhc1.prod.google.com ([2002:a05:6a00:6501:b0:88b:de0a:27d5])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:8016:b0:88d:3f61:20e9 with SMTP id d2e1a72fcca58-8bc1cd5fb73mr3876295b3a.48.1794460563057;
 Wed, 11 Nov 2026 21:16:03 -0800 (PST)
Date: Thu, 12 Nov 2026 13:15:40 +0800
In-Reply-To: <20261112051542.1539779-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261112051542.1539779-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
Message-ID: <20261112051542.1539779-8-stanleyjhu@google.com>
Subject: [PATCH 7/9] scsi: ufs: core: Unwind variant resume in EH when reset fails
From: Stanley Jhu <stanleyjhu@google.com>
To: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>, 
	Peter Wang <peter.wang@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>, 
	Can Guo <quic_cang@quicinc.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Asutosh Das <quic_asutoshd@quicinc.com>, Hongjie Fang <hongjiefang@asrmicro.com>, 
	Praveen Talari <praveen.talari@oss.qualcomm.com>, HOYOUNG SEO <hy50.seo@samsung.com>, 
	Brian Kao <powenkao@google.com>, Jens Axboe <axboe@kernel.dk>, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ufshcd_err_handling_prepare() resumes the host variant with
UFS_SYSTEM_PM or UFS_RUNTIME_PM when hba->is_sys_suspended is true or
the UFS device W-LUN is runtime suspended. When no host reset
succeeds, ufshcd_err_handling_unprepare() does not undo that resume.

Along the runtime PM path:

1. __ufshcd_wl_suspend() suspends the variant, and the W-LUN enters
   RPM_SUSPENDED.
2. A fatal controller error schedules ufshcd_err_handler().
3. ufshcd_err_handling_prepare() calls ufshcd_vops_resume() with
   UFS_RUNTIME_PM.
4. ufshcd_reset_and_restore() fails and sets hba->ufshcd_state to
   UFSHCD_STATE_ERROR.
5. ufshcd_err_handling_unprepare() returns without calling
   ufshcd_vops_suspend(), and the variant stays runtime-resumed on the
   dead host.

Along the system PM path:

1. ufshcd_wl_suspend() suspends the variant and sets
   hba->is_sys_suspended.
2. START STOP UNIT fails on all three attempts in ufshcd_wl_resume().
3. __ufshcd_wl_resume() suspends the variant again and returns -EIO.
4. A fatal controller error schedules ufshcd_err_handler().
5. ufshcd_err_handling_prepare() calls ufshcd_vops_resume() with
   UFS_SYSTEM_PM.
6. ufshcd_reset_and_restore() fails and leaves the variant
   system-resumed on the dead host.

Suspend the variant in ufshcd_err_handling_unprepare() when no host
reset in the error handler run succeeded, so that the variant power
state matches the W-LUN and system power state. Suspending the variant
there needs three more changes.

First, track hba->vops_suspended in ufshcd_vops_suspend() and
ufshcd_vops_resume(). The link is active after a successful host reset,
so ufshcd_err_handling_unprepare() keeps the variant resumed even when
the W-LUN stays RPM_SUSPENDED. hba->vops_suspended then makes the next
__ufshcd_wl_resume() skip the variant resume callback.

Second, set hba->force_reset in ufshcd_err_handler() when
hba->is_sys_suspended is true. A non-fatal UIC error otherwise ends
error handling without a host reset. ufshcd_err_handling_unprepare()
would then suspend the variant before it unquiesces the queues.

Third, keep pm_recovered set once a host reset succeeds. Error recovery
may run several passes. A pass with a successful reset runs
ufshcd_recover_pm_error(), which clears hba->is_sys_suspended and may
activate the W-LUN before a later pass fails to reset the host.

Fixes: c72e79c0ad2b ("scsi: ufs: Recover HBA runtime PM error in error handler")
Cc: stable@vger.kernel.org # 7.3.x
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd-priv.h | 19 +++++++++++----
 drivers/ufs/core/ufshcd.c      | 43 +++++++++++++++++++++++++++-------
 include/ufs/ufshcd.h           |  3 +++
 3 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 99f654b79035..a63f7567017e 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -238,18 +238,29 @@ static inline void ufshcd_vops_fixup_dev_quirks(struct ufs_hba *hba)
 static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op op,
 				enum ufs_notify_change_status status)
 {
+	int ret = 0;
+
 	if (hba->vops && hba->vops->suspend)
-		return hba->vops->suspend(hba, op, status);
+		ret = hba->vops->suspend(hba, op, status);
+	if (!ret && status == POST_CHANGE)
+		hba->vops_suspended = true;
 
-	return 0;
+	return ret;
 }
 
 static inline int ufshcd_vops_resume(struct ufs_hba *hba, enum ufs_pm_op op)
 {
+	int ret = 0;
+
+	if (!hba->vops_suspended)
+		return 0;
+
 	if (hba->vops && hba->vops->resume)
-		return hba->vops->resume(hba, op);
+		ret = hba->vops->resume(hba, op);
+	if (!ret)
+		hba->vops_suspended = false;
 
-	return 0;
+	return ret;
 }
 
 static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7e3f9abc7e7c..286ffb44772d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6907,8 +6907,16 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
 	}
 }
 
-static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
+/*
+ * Return true if the W-LUN or the system is suspended and the host variant is
+ * not suspended when this function returns. This includes the case where an
+ * earlier error handler run left the variant resumed and ufshcd_vops_resume()
+ * returns 0 without calling the variant.
+ */
+static bool ufshcd_err_handling_prepare(struct ufs_hba *hba)
 {
+	bool vops_resumed = false;
+
 	/*
 	 * A WLUN resume failure could potentially lead to the HBA being
 	 * runtime suspended, so take an extra reference on hba->dev.
@@ -6934,7 +6942,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		if (!ufshcd_is_clkgating_allowed(hba))
 			ufshcd_setup_clocks(hba, true);
 		pm_op = hba->is_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
-		ufshcd_vops_resume(hba, pm_op);
+		vops_resumed = !ufshcd_vops_resume(hba, pm_op);
 	} else {
 		ufshcd_hold(hba);
 		if (ufshcd_is_clkscaling_supported(hba) &&
@@ -6950,11 +6958,24 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	 */
 	blk_mq_unquiesce_queue(hba->host->pseudo_sdev->request_queue);
 	cancel_work_sync(&hba->eeh_work);
+	return vops_resumed;
 }
 
-static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
+static void ufshcd_err_handling_unprepare(struct ufs_hba *hba,
+					  bool vops_resumed, bool pm_recovered)
 {
 	blk_mq_quiesce_queue_nowait(hba->host->pseudo_sdev->request_queue);
+	/*
+	 * !pm_recovered: no recovery ran, so the W-LUN or system is
+	 * suspended.
+	 */
+	if (vops_resumed && !pm_recovered) {
+		enum ufs_pm_op pm_op = hba->is_sys_suspended ?
+				       UFS_SYSTEM_PM : UFS_RUNTIME_PM;
+
+		ufshcd_vops_suspend(hba, pm_op, PRE_CHANGE);
+		ufshcd_vops_suspend(hba, pm_op, POST_CHANGE);
+	}
 	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
@@ -7116,7 +7137,10 @@ static void ufshcd_err_handler(struct work_struct *work)
 	int retries = MAX_ERR_HANDLER_RETRIES;
 	struct ufs_hba *hba;
 	unsigned long flags;
+	/* Set once a reset succeeds and ufshcd_recover_pm_error() has run. */
+	bool pm_recovered = false;
 	bool needs_restore;
+	bool vops_resumed;
 	bool needs_reset;
 	bool stop;
 	int pmc_err;
@@ -7166,7 +7190,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	ufshcd_set_eh_wlun_fence(hba);
 	spin_unlock_irqrestore(&hba->host->host_lock, flags);
 
-	ufshcd_err_handling_prepare(hba);
+	vops_resumed = ufshcd_err_handling_prepare(hba);
 
 	spin_lock_irqsave(&hba->host->host_lock, flags);
 	ufshcd_set_eh_in_progress(hba);
@@ -7184,7 +7208,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
 		hba->ufshcd_state = UFSHCD_STATE_RESET;
-	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev))
+	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
+	    hba->is_sys_suspended)
 		hba->force_reset = true;
 	/*
 	 * A full reset and restore might have happened after preparation
@@ -7292,11 +7317,13 @@ static void ufshcd_err_handler(struct work_struct *work)
 		hba->force_reset = false;
 		spin_unlock_irqrestore(&hba->host->host_lock, flags);
 		err = ufshcd_reset_and_restore(hba);
-		if (err)
+		if (err) {
 			dev_err(hba->dev, "%s: reset and restore failed with err %d\n",
 					__func__, err);
-		else
+		} else {
+			pm_recovered = true;
 			ufshcd_recover_pm_error(hba);
+		}
 		spin_lock_irqsave(&hba->host->host_lock, flags);
 	}
 
@@ -7318,7 +7345,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	ufshcd_clear_eh_wlun_fence(hba);
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(&hba->host->host_lock, flags);
-	ufshcd_err_handling_unprepare(hba);
+	ufshcd_err_handling_unprepare(hba, vops_resumed, pm_recovered);
 	up(&hba->host_sem);
 
 	dev_info(hba->dev, "%s finished; HBA state %s\n", __func__,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index be62165b785e..df366d11f6ae 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1038,6 +1038,8 @@ enum ufshcd_mcq_opr {
  * @devfreq: frequency scaling information owned by the devfreq core
  * @clk_scaling: frequency scaling information owned by the UFS driver
  * @is_sys_suspended: UFS device has been suspended because of system suspend
+ * @vops_suspended: set by a successful POST_CHANGE ufshcd_vops_suspend(),
+ *  cleared by a successful ufshcd_vops_resume()
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
  *  device is known or not.
@@ -1226,6 +1228,7 @@ struct ufs_hba {
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
 	bool is_sys_suspended;
+	bool vops_suspended;
 
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
-- 
2.56.0.567.gdb80ae8cd5-goog

