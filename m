Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C7A34B43F
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588030; cv=none; b=uZfWd+rMPSrXkGBIFj7sYfP7SK6xx9TyfffNVfTTSvwVFjZd9BBxppmxuUgeQC5jO/k8ngPbQIn+Lw7vOJN8vUzJm23MQ3k9fwWDgIL+3CEwqjTVC53zHTGkUaECgmbOGTa5JB7kzs8pRkJrXn4xw11SvsdGsn2ZaJdKaVcLcZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588030; c=relaxed/simple;
	bh=moc0EWp1+q2fZJhhA9WDP1OJJzZQG9L+QQpfPWm2tPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEDXIWZF1VdR/1mfFslktQfDMdMM1oHl1yeFiJaLgZxhunskXQdIo51p5YmfxXcHcpoRJ98eValWq5Cua7lKz/VWnwDoWt8JznNrIzGx962JREC2+YJA5Wno1eDS/Vn3rtxyDAixEAfl3ohtMshqP5fsTXULxzbsEQmszYVlTHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JNrDgFhN; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JNrDgFhN"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dt7cD20yDzlfpMC;
	Fri, 16 Jan 2026 18:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768588026; x=1771180027; bh=i08RM
	3PdUaWsJicLGTMgpJOiYbvWzax1cWQqFI8mhZU=; b=JNrDgFhNpmeJwKjjgTiN8
	p8mE4UgUHFoVTI7VLAYirJQq2j78RKUnwNU8wCAJ2FZLiYoqHfZIFPiBdqYb+Ge8
	3OTp17Jjt8vrVL1mBqfH0EPAiUxZBp224nC3V0QKx/NSUUPAZy4sA4FF+fvnPDT5
	cqjWXBtBX7KRlfRZQORhbeIlrLbx4bqbbEZfjgHX0ePdx2OsUEz+sqhXlrpiDyAX
	dFSBx8AcdothcXq8UUINpP9p3yKX1byEBasdYlvKHIpwEuWJwe5UoCIgvgSy+geT
	fhIqJnCnBArdVbWvpkYCHegrfVKizrgEKq93KtQR4Vkf5kTnrVH/V/1/hG0Cb+Up
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id G49A5EMSfA6V; Fri, 16 Jan 2026 18:27:06 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dt7c803zDzlfl7l;
	Fri, 16 Jan 2026 18:27:03 +0000 (UTC)
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
Subject: [PATCH 5/7] ufs: core: Remove unused code and data structures
Date: Fri, 16 Jan 2026 10:26:07 -0800
Message-ID: <20260116182628.3255116-6-bvanassche@acm.org>
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

Remove the code and data structures that are no longer used due to patch
"ufs: core: Switch from clock gating to RPM".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs_trace.h |  27 -------
 drivers/ufs/core/ufshcd.c    | 152 +----------------------------------
 include/ufs/ufshcd.h         |  33 --------
 3 files changed, 4 insertions(+), 208 deletions(-)

diff --git a/drivers/ufs/core/ufs_trace.h b/drivers/ufs/core/ufs_trace.h
index 309ae51b4906..a8395d97ad77 100644
--- a/drivers/ufs/core/ufs_trace.h
+++ b/drivers/ufs/core/ufs_trace.h
@@ -63,7 +63,6 @@
=20
 UFS_LINK_STATES;
 UFS_PWR_MODES;
-UFSCHD_CLK_GATING_STATES;
 UFS_CMD_TRACE_STRINGS
 UFS_CMD_TRACE_TSF_TYPES
=20
@@ -81,27 +80,6 @@ UFS_CMD_TRACE_TSF_TYPES
 #define show_ufs_cmd_trace_tsf(tsf)	\
 				__print_symbolic(tsf, UFS_CMD_TRACE_TSF_TYPES)
=20
-TRACE_EVENT(ufshcd_clk_gating,
-
-	TP_PROTO(struct ufs_hba *hba, int state),
-
-	TP_ARGS(hba, state),
-
-	TP_STRUCT__entry(
-		__field(struct ufs_hba *, hba)
-		__field(int, state)
-	),
-
-	TP_fast_assign(
-		__entry->hba =3D hba;
-		__entry->state =3D state;
-	),
-
-	TP_printk("%s: gating state changed to %s",
-		dev_name(__entry->hba->dev),
-		__print_symbolic(__entry->state, UFSCHD_CLK_GATING_STATES))
-);
-
 TRACE_EVENT(ufshcd_clk_scaling,
=20
 	TP_PROTO(struct ufs_hba *hba, const char *state, const char *clk,
@@ -180,11 +158,6 @@ DEFINE_EVENT(ufshcd_profiling_template, ufshcd_profi=
le_hibern8,
 		 int err),
 	TP_ARGS(hba, profile_info, time_us, err));
=20
-DEFINE_EVENT(ufshcd_profiling_template, ufshcd_profile_clk_gating,
-	TP_PROTO(struct ufs_hba *hba, const char *profile_info, s64 time_us,
-		 int err),
-	TP_ARGS(hba, profile_info, time_us, err));
-
 DEFINE_EVENT(ufshcd_profiling_template, ufshcd_profile_clk_scaling,
 	TP_PROTO(struct ufs_hba *hba, const char *profile_info, s64 time_us,
 		 int err),
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b3d75152abd9..1189a9fd39ff 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -689,7 +689,6 @@ static void ufshcd_print_host_state(struct ufs_hba *h=
ba)
 		hba->pm_op_in_progress, hba->is_sys_suspended);
 	dev_err(hba->dev, "Auto BKOPS=3D%d, Host self-block=3D%d\n",
 		hba->auto_bkops_enabled, hba->host->host_self_blocked);
-	dev_err(hba->dev, "Clk gate=3D%d\n", hba->clk_gating.state);
 	dev_err(hba->dev,
 		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt=3D%d\n",
 		div_u64(hba->ufs_stats.last_hibern8_exit_tstamp, 1000),
@@ -1895,40 +1894,6 @@ static void ufshcd_exit_clk_scaling(struct ufs_hba=
 *hba)
 	hba->clk_scaling.is_initialized =3D false;
 }
=20
-static void ufshcd_ungate_work(struct work_struct *work)
-{
-	int ret;
-	struct ufs_hba *hba =3D container_of(work, struct ufs_hba,
-			clk_gating.ungate_work);
-
-	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
-
-	scoped_guard(spinlock_irqsave, &hba->clk_gating.lock) {
-		if (hba->clk_gating.state =3D=3D CLKS_ON)
-			return;
-	}
-
-	ufshcd_hba_vreg_set_hpm(hba);
-	ufshcd_setup_clocks(hba, true);
-
-	ufshcd_enable_irq(hba);
-
-	/* Exit from hibern8 */
-	if (ufshcd_can_hibern8_during_gating(hba)) {
-		/* Prevent gating in this path */
-		hba->clk_gating.is_suspended =3D true;
-		if (ufshcd_is_link_hibern8(hba)) {
-			ret =3D ufshcd_uic_hibern8_exit(hba);
-			if (ret)
-				dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
-					__func__, ret);
-			else
-				ufshcd_set_link_active(hba);
-		}
-		hba->clk_gating.is_suspended =3D false;
-	}
-}
-
 /**
  * ufshcd_hold - Enable clocks that were gated earlier due to ufshcd_rel=
ease.
  * Also, exit from hibern8 mode and set the link as active.
@@ -1943,74 +1908,6 @@ void ufshcd_hold(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_hold);
=20
-static void ufshcd_gate_work(struct work_struct *work)
-{
-	struct ufs_hba *hba =3D container_of(work, struct ufs_hba,
-			clk_gating.gate_work.work);
-	int ret;
-
-	scoped_guard(spinlock_irqsave, &hba->clk_gating.lock) {
-		/*
-		 * In case you are here to cancel this work the gating state
-		 * would be marked as REQ_CLKS_ON. In this case save time by
-		 * skipping the gating work and exit after changing the clock
-		 * state to CLKS_ON.
-		 */
-		if (hba->clk_gating.is_suspended ||
-		    hba->clk_gating.state !=3D REQ_CLKS_OFF) {
-			hba->clk_gating.state =3D CLKS_ON;
-			trace_ufshcd_clk_gating(hba,
-						hba->clk_gating.state);
-			return;
-		}
-
-		if (hba->clk_gating.active_reqs)
-			return;
-	}
-
-	scoped_guard(spinlock_irqsave, hba->host->host_lock) {
-		if (ufshcd_is_ufs_dev_busy(hba) ||
-		    hba->ufshcd_state !=3D UFSHCD_STATE_OPERATIONAL)
-			return;
-	}
-
-	/* put the link into hibern8 mode before turning off clocks */
-	if (ufshcd_can_hibern8_during_gating(hba)) {
-		ret =3D ufshcd_uic_hibern8_enter(hba);
-		if (ret) {
-			hba->clk_gating.state =3D CLKS_ON;
-			dev_err(hba->dev, "%s: hibern8 enter failed %d\n",
-					__func__, ret);
-			trace_ufshcd_clk_gating(hba,
-						hba->clk_gating.state);
-			return;
-		}
-		ufshcd_set_link_hibern8(hba);
-	}
-
-	ufshcd_disable_irq(hba);
-
-	ufshcd_setup_clocks(hba, false);
-
-	/* Put the host controller in low power mode if possible */
-	ufshcd_hba_vreg_set_lpm(hba);
-	/*
-	 * In case you are here to cancel this work the gating state
-	 * would be marked as REQ_CLKS_ON. In this case keep the state
-	 * as REQ_CLKS_ON which would anyway imply that clocks are off
-	 * and a request to turn them on is pending. By doing this way,
-	 * we keep the state machine in tact and this would ultimately
-	 * prevent from doing cancel work multiple times when there are
-	 * new requests arriving before the current cancel work is done.
-	 */
-	guard(spinlock_irqsave)(&hba->clk_gating.lock);
-	if (hba->clk_gating.state =3D=3D REQ_CLKS_OFF) {
-		hba->clk_gating.state =3D CLKS_OFF;
-		trace_ufshcd_clk_gating(hba,
-					hba->clk_gating.state);
-	}
-}
-
 void ufshcd_release(struct ufs_hba *hba)
 {
 	/* blk_pm_runtime_init() sets q->dev */
@@ -2127,19 +2024,8 @@ static void ufshcd_init_clk_gating(struct ufs_hba =
*hba)
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
=20
-	hba->clk_gating.state =3D CLKS_ON;
-
-	hba->clk_gating.delay_ms =3D 150;
-	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
-	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
-
-	hba->clk_gating.clk_gating_workq =3D alloc_ordered_workqueue(
-		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
-		hba->host->host_no);
-
 	ufshcd_init_clk_gating_sysfs(hba);
=20
-	hba->clk_gating.is_enabled =3D true;
 	hba->clk_gating.is_initialized =3D true;
 }
=20
@@ -2154,8 +2040,6 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *=
hba)
 	ufshcd_hold(hba);
 	hba->clk_gating.is_initialized =3D false;
 	ufshcd_release(hba);
-
-	destroy_workqueue(hba->clk_gating.clk_gating_workq);
 }
=20
 static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
@@ -8407,8 +8291,7 @@ static void ufshcd_rtc_work(struct work_struct *wor=
k)
=20
 	 /* Update RTC only when there are no requests in progress and UFSHCI i=
s operational */
 	if (!ufshcd_is_ufs_dev_busy(hba) &&
-	    hba->ufshcd_state =3D=3D UFSHCD_STATE_OPERATIONAL &&
-	    !hba->clk_gating.active_reqs)
+	    hba->ufshcd_state =3D=3D UFSHCD_STATE_OPERATIONAL)
 		ufshcd_update_rtc(hba);
=20
 	if (ufshcd_is_ufs_dev_active(hba) && hba->dev_info.rtc_update_period)
@@ -9420,7 +9303,6 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba,=
 bool on)
 	int ret =3D 0;
 	struct ufs_clk_info *clki;
 	struct list_head *head =3D &hba->clk_list_head;
-	ktime_t start =3D ktime_get();
 	bool clk_state_changed =3D false;
=20
 	if (list_empty(head))
@@ -9469,17 +9351,8 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba=
, bool on)
 			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
 				clk_disable_unprepare(clki->clk);
 		}
-	} else if (!ret && on && hba->clk_gating.is_initialized) {
-		scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
-			hba->clk_gating.state =3D CLKS_ON;
-		trace_ufshcd_clk_gating(hba,
-					hba->clk_gating.state);
 	}
=20
-	if (clk_state_changed)
-		trace_ufshcd_profile_clk_gating(hba,
-			(on ? "on" : "off"),
-			ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 	return ret;
 }
=20
@@ -9913,9 +9786,6 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba,=
 enum ufs_pm_op pm_op)
 	 * If we can't transition into any of the low power modes
 	 * just gate the clocks.
 	 */
-	ufshcd_hold(hba);
-	hba->clk_gating.is_suspended =3D true;
-
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, true);
=20
@@ -10063,11 +9933,9 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hb=
a, enum ufs_pm_op pm_op)
 			msecs_to_jiffies(RPM_DEV_FLUSH_RECHECK_WORK_DELAY_MS));
 	}
=20
-	if (ret) {
+	if (ret)
 		ufshcd_update_evt_hist(hba, UFS_EVT_WL_SUSP_ERR, (u32)ret);
-		hba->clk_gating.is_suspended =3D false;
-		ufshcd_release(hba);
-	}
+
 	hba->pm_op_in_progress =3D false;
 	return ret;
 }
@@ -10158,8 +10026,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba=
, enum ufs_pm_op pm_op)
 out:
 	if (ret)
 		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
-	hba->clk_gating.is_suspended =3D false;
-	ufshcd_release(hba);
+
 	hba->pm_op_in_progress =3D false;
 	return ret;
 }
@@ -10288,11 +10155,6 @@ static int ufshcd_suspend(struct ufs_hba *hba)
 		ufshcd_enable_irq(hba);
 		return ret;
 	}
-	if (ufshcd_is_clkgating_allowed(hba)) {
-		hba->clk_gating.state =3D CLKS_OFF;
-		trace_ufshcd_clk_gating(hba,
-					hba->clk_gating.state);
-	}
=20
 	ufshcd_vreg_set_lpm(hba);
 	/* Put the host controller in low power mode if possible */
@@ -10751,12 +10613,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	hba->irq =3D irq;
 	hba->vps =3D &ufs_hba_vps;
=20
-	/*
-	 * Initialize clk_gating.lock early since it is being used in
-	 * ufshcd_setup_clocks()
-	 */
-	spin_lock_init(&hba->clk_gating.lock);
-
 	/* Initialize mutex for PM QoS request synchronization */
 	mutex_init(&hba->pm_qos_mutex);
=20
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dac07a5cd998..69e86185e652 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -382,49 +382,16 @@ struct ufs_hba_variant_ops {
 	u32	(*freq_to_gear_speed)(struct ufs_hba *hba, unsigned long freq);
 };
=20
-/* clock gating state  */
-enum clk_gating_state {
-	CLKS_OFF,
-	CLKS_ON,
-	REQ_CLKS_OFF,
-	REQ_CLKS_ON,
-};
-
 /**
  * struct ufs_clk_gating - UFS clock gating related info
- * @gate_work: worker to turn off clocks after some delay as specified i=
n
- * delay_ms
- * @ungate_work: worker to turn on clocks that will be used in case of
- * interrupt context
- * @clk_gating_workq: workqueue for clock gating work.
- * @lock: serialize access to some struct ufs_clk_gating members. An out=
er lock
- * relative to the host lock
- * @state: the current clocks state
- * @delay_ms: gating delay in ms
- * @is_suspended: clk gating is suspended when set to 1 which can be use=
d
- * during suspend/resume
  * @delay_attr: sysfs attribute to control delay_attr
  * @enable_attr: sysfs attribute to enable/disable clock gating
- * @is_enabled: Indicates the current status of clock gating
  * @is_initialized: Indicates whether clock gating is initialized or not
- * @active_reqs: number of requests that are pending and should be waite=
d for
- * completion before gating clocks.
  */
 struct ufs_clk_gating {
-	struct delayed_work gate_work;
-	struct work_struct ungate_work;
-	struct workqueue_struct *clk_gating_workq;
-
-	spinlock_t lock;
-
-	enum clk_gating_state state;
-	unsigned long delay_ms;
-	bool is_suspended;
 	struct device_attribute delay_attr;
 	struct device_attribute enable_attr;
-	bool is_enabled;
 	bool is_initialized;
-	int active_reqs;
 };
=20
 /**
