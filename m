Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BCB17A2F6
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 04:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782965537; cv=none; b=CtP4XSJNmjehENH/qLq5Q+QwpIejjXUWf2WSj96LCNVmY40Cd8WM2KXUrmK9DNkJlVlCJhVwwl0e28L4HhjpqkIt5tkrqB5CjLlkcUH1a8kVK0F/OlbQX1PKGJiumlLDwAsqtx58iNvjztfwlz68sXb+RPNB/qZ/evCbLeKfDRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782965537; c=relaxed/simple;
	bh=FjgTOXgnM2K3xDeWprQgnzDAJxH78bqWqK3p3GeEckM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PYPOZu49SKSDiUYh9GaR44U2P/gucE8rEvkFsLP3/LXQ/J2lM8fYLvWB5U+VVl7dkEq07OwOLgN39GcwDiw6+EwC7MJJv72QT4rDBOw90ItUC5EIvzeWjLKfF6dRWxP39lkwhkC/TezdMBn8WYVZaHflu4kOdiKdlJxUt37BmHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GXO7HYXL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GXO7HYXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EE31F000E9;
	Thu,  2 Jul 2026 04:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782965536;
	bh=TGluO1vohf5oKGgnwnVYdizqb+xc5MTDuY9zUg9IP1s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GXO7HYXL49nLV/5MRPeI3UXkG+usUzRQUmMvdaznpMk98yXJ9OYku5aLsGrvR23Lf
	 KP+obXxDbWDiJbIt6xVJmrX0YA17HpxQbJCWSCAah8Oq7pQAes3FFfnnx+rlUk3oFh
	 XdVAPh+FNO2T29hGF5o3+kZGVB8nl/wo+fdSvaZPyXTwLEIxR9FdcKLHahzc2w/kqX
	 lVwOrjad0287Lk/DjVYSxgaikywLQv0kxvG4EZJtdNJsT9eYvKHSMWfrp7Pbg7JJYm
	 AWS45GKvujueqHtydsoU6WPGac5xZ4GnWfj6CZ9E+STFj+E5myOb2LIvq3XPuzlb7m
	 IOBa4WqN4F4Jw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: scsi_lib: add spinup_notify callback for
 ASC/ASCQ=0x04/0x11
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260702035724.2059166-2-yangxingui@huawei.com>
References: <20260702035724.2059166-1-yangxingui@huawei.com>
 <20260702035724.2059166-2-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 04:12:15 +0000
Message-Id: <20260702041216.15EE31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The `spinup_notify` API lacks context documentation, risking `sche=
duling while atomic` bugs in hardware drivers.
- [High] Unmitigated concurrent `spinup_notify` invocations could flood LLD=
D hardware queues.
--

commit 171fafeb5fbd92de731525186cc8f26d24a7be8e
Author: Xingui Yang <yangxingui@huawei.com>

scsi: scsi_lib: add spinup_notify callback for ASC/ASCQ=3D0x04/0x11

When a SCSI device returns NOT_READY with ASC/ASCQ =3D 0x04/0x11 ("notify
(enable spinup) required"), the device is in Active_Wait or Idle_Wait power
state. Add an optional spinup_notify callback to struct scsi_host_template
that is invoked before ACTION_DELAYED_RETRY.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index daeb3693fe559..140c41a2fe03b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -905,6 +905,10 @@ static void scsi_io_completion_action(struct scsi_cm=
nd *cmd, int result)
>  				case 0x1a: /* start stop unit in progress */
>  				case 0x1b: /* sanitize in progress */
>  				case 0x1d: /* configuration in progress */
> +					if (sshdr.ascq =3D=3D 0x11 &&
> +					    cmd->device->host->hostt->spinup_notify)
> +						cmd->device->host->hostt->spinup_notify(
> +							cmd->device);

[Severity: High]
Could this cause a regression by flooding hardware queues with concurrent
spinup_notify invocations?

If multiple async commands are in flight when a device goes into a standby
state, they will all fail and return not ready with ascq =3D=3D 0x11 almost
simultaneously.

Since scsi_io_completion_action() invokes spinup_notify unconditionally for
every command, this could cause a thundering herd.

For example, in the subsequent patch for hisi_sas, this triggers concurrent,
unlocked read-modify-write operations on the SL_CONTROL register:

hisi_sas_v3_hw.c:sl_notify_ssp_v3_hw() {
    ...
    sl_control |=3D SL_CONTROL_NOTIFY_EN_MSK;
    hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
    ...
}

>  					action =3D ACTION_DELAYED_RETRY;
>  					break;
>  				case 0x0a: /* ALUA state transition */
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 7e2011830ba4b..500fad5ffab68 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -374,6 +374,15 @@ struct scsi_host_template {
>  #define SCSI_ADAPTER_RESET	1
>  #define SCSI_FIRMWARE_RESET	2
> =20
> +	/*
> +	 * Optional callback invoked when a device returns NOT_READY with
> +	 * ASC/ASCQ =3D 0x04/0x11 ("notify (enable spinup) required").
> +	 * This allows LLDDs to perform controller-specific spinup
> +	 * notification before the mid-layer retries.
> +	 *
> +	 * Status: OPTIONAL
> +	 */
> +	void (*spinup_notify)(struct scsi_device *sdev);

[Severity: High]
Should this document the context constraints to prevent scheduling while
atomic regressions?

Since scsi_io_completion_action() is called from atomic context, any driver
implementing this callback must not sleep.

Without this documentation, it is easy to introduce bugs. For instance, the
subsequent patch in this series calls msleep(1) inside sl_notify_ssp_v3_hw()
via this callback:

hisi_sas_v3_hw.c:sl_notify_ssp_v3_hw() {
    ...
    msleep(1);
    ...
}

> =20
>  	/*
>  	 * Name of proc directory

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702035724.2059=
166-1-yangxingui@huawei.com?part=3D1
