Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4226B41CB31
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 09:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377241; cv=none; b=MpiEZZ6nYd76/gm+ZWsARsO11OyB/FEpuP7rwMwHNCGPekHHVUcud/bIjpGINDvtF7lD+WwAV49opQQ7t+717bJCj2DT8LyaCVmdGrb6U/tika5bAUfzDYTmPNnS4N48rFxBA1dV46uqsakIvmjx4gjuSjyFveA0nwcUQ+CQugI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377241; c=relaxed/simple;
	bh=TAul0iKTd+FXLv4DEvmYCWiLcKD/wmSTGXrlHT9DxEA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OVK0ux4hvIxjFpWrYnYJ/WNObXT4Zj5ZvUWYdMvWCNiUmTvSNDbBaoVPBLGkipC+ues8UWHVWY7ea5d0j8VTT4XdKlIbY5bgCxEXo4JPUjZCTCgBiigRvBGwqI4xeyrrzTZwjjSP4E0Csavx+yuwkQGY9P7R8XgvALlnGIqoH20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NDuXKmVZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NDuXKmVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489F01F000FF;
	Mon, 14 Sep 2026 09:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789377237;
	bh=2vlEH28pfBKVP8EnLoaIH6b+9E9CoWeQeVOb3gUuXno=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NDuXKmVZZpOzSkusWk6Xa5HIYOvJs6YYFO0C5OozzhhL0SF723Mrsst1hFSqLKPdC
	 K+XVPY0hBrB6SM+LZwPmFKcs22w9x076scA6ZrMZe8mXxOujitRdSLsPmNUpzqYob2
	 U/jlvqUv7lg28WvqT6eqdWBXHSI5mBNsvrmMj9XxW8Vl1f+PGd6LBvg6IhgbqVd6gk
	 XUiOaRBtB5+WOszmftjaJ7oEG0o+8gnIpNRyJ6p4m1qs3l5C+G+o8FaPEYahpWDeWf
	 fLi+2uY03V4k189aCNXnoO998snjbNCskF+wTz1DB4Fga27TBv+LVGRF7O/9qyiQuY
	 QJ+NBwoPb7U0Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] ufs: serialize AHIT register access between
 sysfs and host driver
Reply-To: sashiko-reviews@lists.linux.dev
To: peter.wang@mediatek.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260914085148.136429-3-peter.wang@mediatek.com>
References: <20260914085148.136429-1-peter.wang@mediatek.com>
 <20260914085148.136429-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 09:13:56 +0000
Message-Id: <20260914091357.489F01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `ufshcd_auto_hibern8_update()` function ignores the return val=
ue of `ufshcd_rpm_get_sync()`. If the runtime PM resume fails, it proceeds =
to unsafely write to the `REG_AUTO_HIBERNATE_IDLE_TIMER` register on a pote=
ntially suspended device.
- [High] Potential NULL pointer dereference in `ufshcd_auto_hibern8_update`=
 if called via sysfs before the device WLUN is fully initialized.
- [High] The UFS core driver registers a shared IRQ (`IRQF_SHARED`) but cal=
ls `disable_irq()` during runtime suspend instead of `synchronize_irq()`, a=
nd fails to verify device activity in its interrupt handler.
--

commit 10d014f6ed545565699c7988448c9337de308b17
Author: Peter Wang <peter.wang@mediatek.com>

ufs: serialize AHIT register access between sysfs and host driver

This commit introduces a mutex and a depth counter to serialize AHIT regist=
er
access between the host driver and sysfs writes. This prevents stale values
from being programmed if a sysfs write races with a gear change.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 2e7a592dbf2f1..1d168eecfd013 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4772,7 +4772,17 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hb=
a, u32 ahit)
>  	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {

[Severity: High]
This isn't a bug introduced by this patch, but can this dereference a
NULL pointer?

Sysfs attributes are exposed in ufshcd_init() via ufs_sysfs_add_nodes()
before hba->ufs_device_wlun is allocated.  The initialization is deferred
to the ufshcd_async_scan worker.

If a user writes to the sysfs node before ufshcd_add_lus() allocates
hba->ufs_device_wlun, can auto_hibern8_store() call
ufshcd_auto_hibern8_update() and locklessly dereference a NULL pointer here?

>  		ufshcd_rpm_get_sync(hba);

[Severity: High]
This is a pre-existing issue, but is it safe to ignore the return value
of ufshcd_rpm_get_sync() here?

If the runtime PM resume fails (e.g., due to a power domain failure or
device removal), pm_runtime_get_sync() returns a negative error code.

Does ignoring this error allow the function to proceed and write to
REG_AUTO_HIBERNATE_IDLE_TIMER on a potentially suspended device, causing a
synchronous external abort?

>  		ufshcd_hold(hba);
> -		ufshcd_configure_auto_hibern8(hba);
> +		/*
> +		 * Serialize with the host driver's AHIT control. Skip the
> +		 * register write while the driver has AHIT forced off; the
> +		 * driver programs hba->ahit back when it re-enables it.
> +		 * Mutex is taken here (not across the rpm calls above) so it
> +		 * never blocks a resume that the driver's path may need.
> +		 */
> +		mutex_lock(&hba->ahit_mutex);
> +		if (!hba->ahit_disable_depth)
> +			ufshcd_configure_auto_hibern8(hba);
> +		mutex_unlock(&hba->ahit_mutex);
>  		ufshcd_release(hba);
>  		ufshcd_rpm_put_sync(hba);
>  	}

[ ... ]

[Severity: High]
This is a pre-existing issue, but does the UFS core driver handle shared
IRQs correctly?

The driver registers its IRQ with IRQF_SHARED. When the UFS controller ente=
rs
runtime suspend, ufshcd_suspend() disables the interrupt line entirely:

drivers/ufs/core/ufshcd.c:ufshcd_suspend() {
    ...
	ufshcd_disable_irq(hba);
    ...
}

Does calling disable_irq() mask interrupts for any other devices sharing the
line? Should this use synchronize_irq() instead?

Additionally, ufshcd_intr() reads the hardware register unconditionally:

drivers/ufs/core/ufshcd.c:ufshcd_intr() {
    ...
	last_intr_status =3D intr_status =3D ufshcd_readl(hba, REG_INTERRUPT_STATU=
S);
    ...
}

Can this access powered-off hardware if the interrupt belongs to another
device on the same shared line? Should this verify the device is actively
powered using pm_runtime_get_if_active() before accessing registers?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914085148.1364=
29-1-peter.wang@mediatek.com?part=3D2
