Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793587844;
	b=sg4ub90y107BL2YtUI+5069HD26M1bRcCMdWJQXKGXtFyC9Bt3Y1+cVqe/8PUPKXeklo
	 WTGLIoxBRiOSNsVVNto/ddAmr6rIcZZXLH2FYJa7j0guULG+yLOe0Pj/UEZWzSsXu3uLj
	 Y/W8tr0EPg6dnQxel4qlDBuS4uMrDYbdkWZlyWK5WGxCxThRfMhd3YzvXJcr5zcr7wCWb
	 quum8kohY+Q/OiArnyalOu/ROUIjIukGRxf1Kjp4mOrZ4qa9fRLoJEU+gPBuPARDADS1n
	 WL/NsPs+YZpoHOXt71lwQx4urasn3jXgZeEBug0aGzPi56Nbg4K+sLel9JfO+simtFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793587844;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eoNL6j7DPNEQ2ahLJdYg7mkX6ALRGQM11BhfdTA6UlU=;
	b=KXgmb+Lzt04ehEZiDxFQAeELCpRAgYv6Png1eNtJUSKqZr1bmunb9eKy1sj7XAS9rf4a
	 +BRrgwx+HsdFyi65oWPTB+J2eoytn7Avw0TWa5S+WeADXKQEIg1UZKlLIaDFwmko9QzN+
	 5/Y2cqrdJeC1LSEsd4VK+ss3G2mbBd04ngvbKvMkwvM2MRLmJ2TK5Dzaibo82WjVB+N1d
	 wM32KX8NdnlzOuzmL9bbYeSVnzV32+PeUKozLMZPKQNS1tGE258Iu0waK8d5XZbVf/8Ws
	 CM8w6bstKtIBswJcV4AG9IKIjHqA+b80eVnoH9vYy9uRCOkY+uIWZALxrciv2lE2YJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NyHX6v9w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39252606A324
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 02:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NyHX6v9w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8551B1F000C1;
	Mon,  2 Nov 2026 02:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793587843;
	bh=eoNL6j7DPNEQ2ahLJdYg7mkX6ALRGQM11BhfdTA6UlU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NyHX6v9wu5nMwiiOL1yZmsm+GMADQc5QBbRJdqbL6dtKBG9XZgsmo5/m3vVWdj9Va
	 0g8seLr0HZL1MQUeUEMw5nDZCkUr6APAbIta2QZG0ZxWjyW8X6EQHEKROnOteXZKt1
	 T46MIENZ4xqmr40b5sD+cjWsTQakjXmqKRDJx5t+XPjh66WZKZsnq7jpCt7b5LfIPB
	 RqeZbIBeTR9MHEZsPkT4v6Tw0CGfGERGRJn/SfiXPIcll7H4VKM+ooJ7I/Jzo15QLk
	 2CX4c14npYpscK3jdDA/1v9+C1NoQGpXg5+UEw1DoecnfmuXTymkHKOTbqS6/kuoCf
	 syy+85ZK4USAA==
Message-ID: <sashiko-outbox-192847@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] scsi: ufs: core: Retry the full device init on
 fatal link loss
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shawn Lin" <shawn.lin@rock-chips.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261102022154.3903115-3-shawn.lin@rock-chips.com>
References: <20261102022154.3903115-1-shawn.lin@rock-chips.com>
 <20261102022154.3903115-3-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 02:50:43 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] scsi: ufs: core: unpropagated link loss in ufshcd_device_params_in=
it()
- [High] scsi: ufs: core: stale outstanding_reqs and req_abort_skip across =
init retries
- [Medium] scsi: ufs: core: ufshcd_wb_probe() clears UFSHCD_CAP_WB_EN acros=
s retries
- [Medium] scsi: ufs: core: stale max_pwr_info.is_valid retained across ini=
t retries
--

commit 0c0ce179b92f947250b0dac49db348668ec04bda
Author: Shawn Lin <shawn.lin@rock-chips.com>

scsi: ufs: core: Retry the full device init on fatal link loss

This commit retries the full UFS device initialization sequence up to three
times in ufshcd_init() when initialization fails due to fatal link loss at
boot. Between retries, it stops the controller, cancels the error handler,
resets the device and controller state, and waits 100 ms before trying
again.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 8a8083a8f024e..12ada46d2b7e1 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -11476,8 +11476,65 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
> =20
>  	/* Initialize hba, detect and initialize UFS device */
>  	ktime_t probe_start =3D ktime_get();
> +	int retries =3D 3;
> =20
> -	err =3D ufshcd_full_device_init(hba);
> +	while (retries--) {
> +		unsigned long flags;
> +
> +		err =3D ufshcd_full_device_init(hba);
> +		if (!err)
> +			break;

[Severity: High]
Can ufshcd_full_device_init() return 0 even when DEVICE_FATAL_ERROR |
UIC_LINK_LOST is latched and the following UIC query fails with -EIO,
causing this loop to break out on the first attempt without retrying?

In ufshcd_full_device_init() -> ufshcd_device_params_init(), once
ufshcd_device_geo_params_init() and the initial descriptor reads in
ufs_get_device_desc() succeed, the remaining queries in ufs_get_device_desc=
()
(such as ufshcd_wb_probe(), ufshcd_temp_notif_probe(), ufshcd_enable_ee(),
ufs_init_rtc(), and ufshcd_device_lvl_exception_probe()) and in
ufshcd_device_params_init() (ufshcd_set_rtt(),
ufshcd_get_ref_clk_gating_wait(), and QUERY_FLAG_IDN_PWR_ON_WPE) ignore err=
ors.

If DEVICE_FATAL_ERROR | UIC_LINK_LOST is latched during that window,
ufshcd_check_errors() latches hba->saved_err and hba->saved_uic_err, and the
first UIC DME_GET query in ufshcd_get_max_pwr_mode() fails with -EIO.
However, ufshcd_device_params_init() ignores the failure of
ufshcd_get_max_pwr_mode() and still returns 0:

drivers/ufs/core/ufshcd.c:ufshcd_device_params_init() {
	...
	/* Probe maximum power mode co-supported by both UFS host and device */
	if (ufshcd_get_max_pwr_mode(hba))
		dev_err(hba->dev,
			"%s: Failed getting max supported power mode\n",
			__func__);

	return 0;
}

Then ufshcd_post_device_init() sees that hba->max_pwr_info.is_valid is false
and also returns 0 without calling ufshcd_config_pwr_mode():

drivers/ufs/core/ufshcd.c:ufshcd_post_device_init() {
	...
	if (!hba->max_pwr_info.is_valid)
		return 0;
	...
}

Should ufshcd_device_params_init() propagate the error from
ufshcd_get_max_pwr_mode(), or should the retry check also inspect
hba->saved_err, hba->saved_uic_err, or ufshcd_is_link_broken(hba)?

> +
> +		if (!retries)
> +			break;
> +
> +		dev_warn(hba->dev, "UFS init failed %d, full retry (%d left)\n",
> +			 err, retries);
> +
> +		/*
> +		 * The failed attempt may have latched fatal errors and
> +		 * scheduled the error handler. Stop the controller first
> +		 * so that no interrupt can interfere with the cleanup,
> +		 * then drain the error handler and start the retry from a
> +		 * clean state.
> +		 */
> +		ufshcd_hba_stop(hba);
> +		cancel_work_sync(&hba->eh_work);
> +		spin_lock_irqsave(&hba->host->host_lock, flags);
> +		hba->saved_err =3D 0;
> +		hba->saved_uic_err =3D 0;
> +		hba->force_reset =3D false;
> +		hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> +		spin_unlock_irqrestore(&hba->host->host_lock, flags);

[Severity: High]
If a device management command (NOP OUT or Query) times out on a wedged
controller during ufshcd_full_device_init(), can stale state in
hba->outstanding_reqs and lrbp->req_abort_skip survive into the next retry?

When blk_execute_rq() times out in ufshcd_exec_dev_cmd() ->
ufshcd_issue_dev_cmd(), scsi_timeout() calls ufshcd_eh_timed_out() ->
ufshcd_abort(). If ufshcd_clear_cmd() times out because the controller is
wedged, ufshcd_abort() sets lrbp->req_abort_skip on the reserved command sl=
ot
and leaves BIT(tag) set in hba->outstanding_reqs:

drivers/ufs/core/ufshcd.c:ufshcd_abort() {
	...
	if (blk_mq_is_reserved_rq(rq))
		err =3D ufshcd_clear_cmd(hba, tag);
	else
		err =3D ufshcd_try_to_abort_task(hba, tag);
	if (err) {
		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
		ufshcd_set_req_abort_skip(hba, hba->outstanding_reqs);
		err =3D FAILED;
		goto release;
	}
	...
}

SCSI EH then invokes ufshcd_eh_host_reset_handler(), which schedules and
flushes hba->eh_work. However, because hba->ufs_device_wlun is still NULL
during ufshcd_init(), ufshcd_err_handling_should_stop() returns true:

drivers/ufs/core/ufshcd.c:ufshcd_err_handling_should_stop() {
	return (!hba->is_powered || hba->shutting_down ||
		!hba->ufs_device_wlun ||
		...
}

As a result, ufshcd_err_handler() exits early without calling
ufshcd_complete_requests() or clearing hba->outstanding_reqs, while
ufshcd_eh_host_reset_handler() sees UFSHCD_STATE_OPERATIONAL and completes =
the
timed-out request.

When the retry loop then stops and re-enables the controller (clearing the
hardware doorbell register) without clearing hba->outstanding_reqs or
resetting lrbp->req_abort_skip (which ufshcd_setup_dev_cmd() does not clear=
),
won't ufshcd_poll() on the next retry observe the cleared doorbell bit agai=
nst
the stale bit in hba->outstanding_reqs and trigger a spurious or premature
completion on the reserved slot?

> +
> +		ufshcd_device_reset(hba);
> +		ufs_put_device_desc(hba);

[Severity: Medium]
Does the retry cleanup also need to reset hba->max_pwr_info.is_valid and
restore UFSHCD_CAP_WB_EN in hba->caps?

First, if a failed attempt reaches ufshcd_get_max_pwr_mode(), it sets
hba->max_pwr_info.is_valid =3D true before ufshcd_post_device_init() ->
ufshcd_config_pwr_mode() fails (or if a link error mid-way through
ufshcd_get_max_pwr_mode() causes a partial fallback in hba->max_pwr_info.in=
fo).
On the next retry, ufshcd_get_max_pwr_mode() will see:

drivers/ufs/core/ufshcd.c:ufshcd_get_max_pwr_mode() {
	...
	if (hba->max_pwr_info.is_valid)
		return 0;
	...
}

and skip probing the negotiated power mode parameters after the reset.

Second, if a query fails inside ufshcd_wb_probe() during a failed attempt
(such as ufshcd_read_unit_desc_param() or
ufshcd_is_wb_buf_lifetime_available()), it jumps to wb_disabled and clears
UFSHCD_CAP_WB_EN:

drivers/ufs/core/ufshcd.c:ufshcd_wb_probe() {
	...
wb_disabled:
	hba->caps &=3D ~UFSHCD_CAP_WB_EN;
}

On subsequent retries, ufshcd_is_wb_allowed(hba) will be false and WriteBoo=
ster
will remain permanently disabled even if the retry succeeds.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102022154.3903=
115-1-shawn.lin@rock-chips.com?part=3D2
