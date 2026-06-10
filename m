Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6063624DE
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 11:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781089417; cv=none; b=drVFKxcl5421jWm00fb25ns3xYWTQ22gjfDUEsvxD7cJCONGhPGdWeKJw1pvpo0ltqZv2CtvwXexl0lkkyF3TyiftyCjfkdsS0XcALxFNi9PNWhgWl5FMp8VzTPnPnE+4MlYhKudK3BQVDJ33AjVByQeOrbocHK++7/znnkWhVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781089417; c=relaxed/simple;
	bh=cpvojbR4NEgiFApUpxBtxeqWkAXd4uiayxPXu24BtJ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tCrwF03c8c9UCsRoLurShVLtEGsFmbqNpHI3ngY2qhMxWTsW1KUDbEhtYIABbuVVtTDRYsOBOB0xhyBvM0h8keTU273m9j3kvBs+w7XgGCXenrx1milHlixgfDtG2yiU1Hkaai7d5vuxMaCQyL3Ha/koBXYE3GN5nQLMtu9bITI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGtQRORS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGtQRORS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0211F00893;
	Wed, 10 Jun 2026 11:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781089407;
	bh=tIdRrHLfy0IMLrlE/pYlks6ZyDvrLaXSoJFnPWfYaB4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PGtQRORS5pNpwsCAcd3vagN4Ygb3963xpsQImk11eXoqhpYKOTEKx8Ou/Ep2bRou0
	 lUpcPbU1hkpgHWk9TJWI4l5sLDEkMNW+1DJ7Zs2IRfx0Z51L0WJRVg+ajSF5vTv+sU
	 yvTjy39fgUj3X5czjHRY+Iy/9bqBq8FfSS1Qs3G77NPjTYcSCXTQUTZ8PkFKqyLvLc
	 mg7O6miJVos7UbdWuQHSil+GXfTtMSoHCO+0QCyykZsTdlJ5fp7rk27pdUzGQZkfQ/
	 HBAzkIGaeBTP5+DeFTOU/qmm3tzUG0iXTwq6mmH5h4ad72FovLVUPZjOev/jPE6s82
	 W0QL0uTTKVgVw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi_error: send device reset if asynchronous abort
 failed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hannes Reinecke" <hare@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260610105119.30903-1-hare@kernel.org>
References: <20260610105119.30903-1-hare@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 10 Jun 2026 11:03:26 +0000
Message-Id: <20260610110326.CE0211F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] Calling `eh_device_reset_handler` asynchronously outside the SCSI =
EH thread violates midlayer concurrency guarantees and breaks low-level dri=
vers (LLDDs).
- [High] Lockless modification of bitfields in `__scsi_report_device_reset(=
)` causes data races that silently corrupt `struct scsi_device` state.
- [High] Concurrent command timeouts on the same device trigger an unbounde=
d cascade of redundant, sequential Bus Device Resets (BDRs).
- [High] Premature escalation to Target Reset due to improper handling of t=
he `SCSI_EH_RESET_SCHEDULED` flag.
- [Medium] Missing Test Unit Ready (TUR) verification after asynchronous de=
vice reset leads to immediate I/O failures.
- [Medium] Asynchronous device reset bypasses post-recovery cleanup, leavin=
g removable media physically unlocked but logically locked.
--

commit ba182d2d6163ba8d4c3c38885f49aacbb5f4c7fe
Author: Hannes Reinecke <hare@kernel.org>
Subject: scsi_error: send device reset if asynchronous abort failed

This commit allows a device reset to be issued directly from
scmd_eh_abort_handler() if a command abort fails. The change aims to prevent
noticeable I/O stalls on other devices sharing the same host by avoiding
the wait for all outstanding commands to finish before entering the error
handler.

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 147127fb4db9c..23dc50332f582 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c

[ ... ]

> @@ -170,7 +171,16 @@ scmd_eh_abort_handler(struct work_struct *work)
>  				    "cmd abort %s\n",
>  				    (rtn =3D=3D FAST_IO_FAIL) ?
>  				    "not send" : "failed"));
> -		goto out;
> +		if (scsi_host_eh_past_deadline(shost))
> +			goto out;
> +		rtn =3D scsi_try_bus_device_reset(scmd);

[Severity: High]
This invokes the device reset asynchronously from the abort workqueue, while
the host is still in the active SHOST_RUNNING state.

The SCSI midlayer documentation explicitly guarantees to low-level drivers
that strategy routines like eh_device_reset_handler() are executed exclusiv=
ely
in the kernel EH thread. This ensures the host is in SHOST_RECOVERY where no
normal I/O is dispatched and no other commands are queued.

Will concurrent queuecommand() calls execute alongside the reset handler he=
re?

Does this expose drivers to data races and hardware state corruption,
as their reset callbacks assume a quiescent state?

[Severity: Medium]
When a SCSI device is reset, removable media devices typically drop their
medium removal prevention state, physically unlocking the door.

The standard EH thread handles this by calling scsi_restart_operations()
post-recovery, which checks sdev->was_reset and sdev->locked to re-issue
ALLOW_MEDIUM_REMOVAL.

Because this async device reset never enters SHOST_RECOVERY, does it bypass
the scsi_restart_operations() cleanup entirely?

Could this leave the physical device unlocked while the kernel still consid=
ers
it locked, allowing users to unexpectedly eject mounted media?

> +		if (rtn !=3D SUCCESS) {
> +			scmd_printk(KERN_INFO, scmd,
> +				    "device reset %s\n",
> +				    (rtn =3D=3D FAST_IO_FAIL) ?
> +				    "not send" : "failed");
> +			goto out;
> +		}
>  	}
>  	set_host_byte(scmd, DID_TIME_OUT);
>  	if (scsi_host_eh_past_deadline(shost)) {

[Severity: Medium]
In the standard EH thread, a successful device reset is followed by sending
a Test Unit Ready (TUR) command via scsi_eh_tur() to ensure the device has
fully recovered.

This code proceeds to complete or retry the command immediately after a
successful reset without invoking scsi_eh_tur().

Could re-issuing commands or allowing new I/O immediately after a reset
without verifying device readiness lead to unpredictable device behavior or
immediate failures?

[ ... ]

> @@ -1013,6 +1023,11 @@ static enum scsi_disposition scsi_try_bus_device_r=
eset(struct scsi_cmnd *scmd)
>  	if (!hostt->eh_device_reset_handler)
>  		return FAILED;
> =20
> +	/* Device reset had already been issued, escalate to next level */
> +	if (scmd->eh_eflags & SCSI_EH_RESET_SCHEDULED)
> +		return FAILED;
> +
> +	scmd->eh_eflags |=3D SCSI_EH_RESET_SCHEDULED;

[Severity: High]
When multiple commands time out concurrently on the same device, each
schedules its own abort_work. If their aborts fail, they each independently
call scsi_try_bus_device_reset().

The deduplication flag SCSI_EH_RESET_SCHEDULED introduced here is tracked
per-command (scmd->eh_eflags), not per-device.

Does this fail to prevent BDR cascades?

Would every single timed-out command on the device sequentially trigger a f=
ull
Bus Device Reset, severely delaying recovery?

[Severity: High]
If the asynchronous scsi_try_bus_device_reset() fails, it marks the command
with SCSI_EH_RESET_SCHEDULED and delegates it to the main EH thread.

When the main EH thread attempts recovery via scsi_eh_bus_device_reset(), it
picks the first command for the device. If it picks this previously poisoned
command, it will hit the check above and immediately return FAILED.

Will this completely bypass the driver reset callback in the fully quiescent
EH thread, depriving the device of a valid reset attempt and prematurely
escalating to a Target Reset?

>  	rtn =3D hostt->eh_device_reset_handler(scmd);
>  	if (rtn =3D=3D SUCCESS)
>  		__scsi_report_device_reset(scmd->device, NULL);

[Severity: High]
A successful asynchronous device reset calls __scsi_report_device_reset(),
which modifies bitfields on struct scsi_device:

scsi_error.c:__scsi_report_device_reset() {
	sdev->was_reset =3D 1;
	sdev->expecting_cc_ua =3D 1;
}

In C, bitfield assignments are non-atomic Read-Modify-Write (RMW) operation=
s.
Because this executes outside of the serialized SHOST_RECOVERY state, normal
I/O completions can continue to process concurrently.

Can concurrent softirq paths, such as scsi_check_sense() clearing
expecting_cc_ua =3D 0, modify adjacent bitfields in the same machine word a=
nd
result in a data race that silently clobbers critical device flags?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260610105119.3090=
3-1-hare@kernel.org?part=3D1
