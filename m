Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89BD3D902E
	for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2026 12:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786366267; cv=none; b=AXROqYaYqdgyJ3visnksuCXvsu4QgXu528qdhHGfrFxBHSEZ1BLsY1yniH5m3g4PfMZ1NjWCshreXDtbodUWVtYnAhyo2fmeDakwK24bFOGqy56I3XBU8K/NykMI/62qpov1mhE9mK1Z2Msg4WZbg9qaLzCz1MOoxU3WiB9kd9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786366267; c=relaxed/simple;
	bh=1PMkMb3U8Riha8TxHDERiU1uR3As4P6C7MMylGPBW3Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gTrf7d5JZeVRfw67AA/dw9zmG1VRfqPEN9eDZcNEhQoIckZr28XV18+1aHpPg7IxMyDF0JACv+s+Rf0nOclphd2ubyBtQEvMkBkVe+K8X6GTkhQ+VZB7GxOkDTH+eHK6J21cEMahPR6xRdN9KBAIDmvicZ22qPxaaKEOFXSZSNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWb2Exij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWb2Exij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0CB1F00A3A;
	Mon, 10 Aug 2026 12:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786366265;
	bh=xS1qGCgww2xA9MmjZbJZ7TvmlJCJHr55F874mUOWj7w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bWb2ExijJSHzqlGU65isiamPahfYEUC8I4YdTKmgbt6fmLY31RAtpIebLbk/yql0o
	 npb76xw5LuvddclEGS4uiZKOTvjIX1NzWIWihF2BOTM4hp2ro2bTBxxGBsr4yUvBgI
	 oyUVFp5qd3PII1y9Hn6dzQ5ZejBeCMH9iL1rJct6YQHim8K08x2UUSwSMkUQSq2up9
	 hpnfX2Ieg1KpdV3Bad62xpMx1dtCLoM3JQoNuNDXLfDIWqBYg8dnrxcjn5WbDModhH
	 Wu0wXaU3PlhUU5jqsbv0yUwdsSK1n0Qv2AineUme7xnWzKX7ebGzklbPrpxXv01tWf
	 32D389UR88y+A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: elx: efct: Use timer_shutdown_sync() for the
 stats timer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fan Wu" <fanwu01@zju.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260810123443.122397-1-fanwu01@zju.edu.cn>
References: <20260810123443.122397-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 10 Aug 2026 12:51:04 +0000
Message-Id: <20260810125105.4F0CB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The static global workqueue `lio_wq` is re-allocated per-device bu=
t never destroyed, leaking memory and leading to a Use-After-Free when mult=
iple devices are present.
- [High] The timer callback indirectly re-initializes the timer on every ex=
piration by calling timer_setup(), which violates timer API constraints, cr=
eates a data race, and corrupts the lockdep state.
--

--- Patch [1]: [PATCH] scsi: elx: efct: Use timer_shutdown_sync() for the s=
tats timer ---
commit caf9ba0b14580d400c5a8efd53a50eb0210dd8ce
Author: Fan Wu <fanwu01@zju.edu.cn>

scsi: elx: efct: Use timer_shutdown_sync() for the stats timer

This commit replaces timer_delete() with timer_shutdown_sync() for the
statistics timer in the efct driver. This guarantees that running callbacks
finish before the transport is freed or hardware is reset.

Cc: stable@vger.kernel.org # v6.2+

> The statistics timer re-arms itself on every expiry through
> efct_xport_config_stats_timer().

[Severity: High]
This is a pre-existing issue, but does efct_xport_config_stats_timer()
re-initialize the timer instead of just re-arming it?

If the callback calls timer_setup() on every expiration:

drivers/scsi/elx/efct/efct_xport.c:efct_xport_config_stats_timer() {
    ...
    timer_setup(&xport->stats_timer, &efct_xport_stats_timer_cb, 0);
    ...
}

Calling timer_setup() on an active timer overwrites timer->flags without
synchronization.

Does this create a data race with concurrent timer API calls and cause lock=
dep
or debugobjects warnings about initializing an active object?

> diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/e=
fct_xport.c
> index 9dcaef6fc188e..84fa5589e0213 100644
> --- a/drivers/scsi/elx/efct/efct_xport.c
> +++ b/drivers/scsi/elx/efct/efct_xport.c
> @@ -507,8 +507,7 @@ efct_xport_detach(struct efct_xport *xport)
>  	efct_scsi_del_device(efct);

[Severity: High]
This isn't a bug introduced by this patch, but does the teardown process le=
ak
a global workqueue if multiple devices are present?

When multiple EFCT adapters are initialized, efct_scsi_tgt_new_device()
unconditionally overwrites a static global workqueue without destroying the
previous one:

drivers/scsi/elx/efct/efct_lio.c:efct_scsi_tgt_new_device() {
    ...
    lio_wq =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, "efct_lio_work=
er");
    ...
}

During teardown, efct_scsi_tgt_del_device() flushes lio_wq, which now points
only to the latest allocated workqueue.

Will this fail to flush works queued for earlier devices, potentially leadi=
ng
to a use-after-free on efct structures if those works execute concurrently
while the older device is torn down?

Is destroy_workqueue() also completely missing, causing a memory leak of the
workqueue structures themselves?

> =20
>  	/*Shutdown FC Statistics timer*/
> -	if (timer_pending(&xport->stats_timer))
> -		timer_delete(&xport->stats_timer);
> +	timer_shutdown_sync(&xport->stats_timer);
> =20
>  	efct_hw_teardown(&efct->hw);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260810123443.1223=
97-1-fanwu01@zju.edu.cn?part=3D1
