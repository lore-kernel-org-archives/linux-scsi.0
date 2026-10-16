Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E27246784;
	Fri, 16 Oct 2026 12:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792155062; cv=none; b=E/3U80tumwYIi5CYIzyRaBbv0gFHNdJRAvkkkCmK1TpLm3MMAkw/SmvMhwCloq6iWCU0RtlsTBRdIknWPxLhHgjBjWVf7CUoS9I6EDEb+ye+emiBYTH9YlXv9zRq6P8PvpsnXdzpKxI2evxf6VsGZ5JpcEkxBqARNIy/Y+Ev6bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792155062; c=relaxed/simple;
	bh=qh2FU1UfTHBpj7DsOZQR13k9O4NJKziEAHRmOF03pvQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HLDBwwzCfpLALXNEtA//0RTspC82HuF5ukFrjRI+rP1ItXy21Z0XVf/ilWqgCK6AD08Dhe54m/qATJFeA8ndtGZyS2KC1BHqIuJSNVFVFGHEW3Qrk6JnoiqSNa8L5aczJylXGwZ5mFEOJlSl4pgLZDT9KHyeBENv082pMT/gT3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBI57qAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBI57qAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F2F1F000C4;
	Fri, 16 Oct 2026 12:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792155060;
	bh=d+WdJzJtILJkxjVuh+bW292/ECfJKXQbsIGEdKBLmlA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DBI57qAgxy8LfoR8KYk4b/T5IZH0ooR/i2wM/L3Rjw2jqpaKseR28OPC0TH7yd5AR
	 Qb4Y5QlAkngciw5/flllUg9MJ70M0g2ICFq3eVqTGfPzMogqvyJljYP46HOC2EuSk6
	 8Mec7qAVDx1LFzTzOJ/SD8wMC9Mx/ByCWL+fd26CG+fx73ZqZamMqI2CYTZtn2Jhqq
	 T5uNQ2XhYz6AgIjHdJah5++Q15qVIdvNy4i6O8EUW4NDihUMuyV1iZNL1KcbNrVxy0
	 z74MzLqqSRyz/G1xG2XzfWs9k+29KUYG7mfEA5hxo7fKjpOLuc8Bjaxfwii+ClqBWF
	 yOTXc3L8JJ74A==
Message-ID: <sashiko-outbox-174338@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 14/23] scsi: ufs: mediatek: Use the common PHY
 framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261016-mt8196-ufs-v14-14-e8d565e0cd45@collabora.com>
References: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
 <20261016-mt8196-ufs-v14-14-e8d565e0cd45@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 12:50:59 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] ufs/mediatek: PM state machine desync on PHY power-off failure
- [High] scsi: ufs: mediatek: PHY incorrectly powered off during active lin=
k runtime suspend
- [Medium] ufs/mediatek: resource leak of PHY initialization on error path
- [Medium] ufs/mediatek: PHY state desynchronization on regulator disable f=
ailure
--

commit d74957280789302bafd051c97a8d0add4f2d400a
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Use the common PHY framework

This patch transitions the Mediatek UFS driver to use the common PHY framew=
ork
instead of custom OF parsing and manual PHY device power management. It upd=
ates
ufs_mtk_init() to acquire and initialize the PHY via standard APIs and repl=
aces
pm_runtime_get_sync()/put_sync() calls with direct PHY power control.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 41e2e9f867013..808365b880fd7 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
[ ... ]
> @@ -1319,11 +1289,22 @@ static int ufs_mtk_init(struct ufs_hba *hba)
> =20
>  	return 0;
> =20
> +out_phy_exit:
> +	phy_exit(host->mphy);
>  out_variant_clear:
>  	ufshcd_set_variant(hba, NULL);
>  	return err;
>  }

[Severity: Medium]
Does this error path bypass phy_exit() if ufs_mtk_mphy_power_on() fails?

Earlier in ufs_mtk_init(), phy_init(host->mphy) is called successfully. Lat=
er
in the same function, if ufs_mtk_mphy_power_on(hba, true) fails, the code
jumps directly to out_variant_clear:

    err =3D ufs_mtk_mphy_power_on(hba, true);
    if (err)
        goto out_variant_clear;

Since out_variant_clear is physically below out_phy_exit, this skips the
newly introduced phy_exit(host->mphy) call, leaking the PHY initialization.

[ ... ]
> @@ -2533,8 +2477,11 @@ static int ufs_mtk_runtime_suspend(struct device *=
dev)
>  	if (ufs_mtk_is_rtff_mtcmos(hba))
>  		ufs_mtk_mtcmos_ctrl(false, res);
> =20
> -	if (host->phy_dev)
> -		pm_runtime_put_sync(host->phy_dev);
> +	ret =3D ufs_mtk_mphy_power_on(hba, false);
> +	if (ret) {
> +		dev_err(dev, "Failed to power off PHY: %pe\n", ERR_PTR(ret));
> +		return ret;
> +	}
> =20
>  	return 0;
>  }

[Severity: High]
Does returning an error here break the runtime PM contract?

Before reaching this code, ufshcd_runtime_suspend(dev) has already suspended
the UFS controller, and ufs_mtk_dev_vreg_set_lpm() has put regulators into
low-power mode. Returning an error signals failure to the PM core, which
aborts the suspend transition and leaves the device status as RPM_ACTIVE.

Because the underlying hardware is already powered off, subsequent I/O
requests will bypass runtime_resume() and access unpowered hardware. This
can lead to bus timeouts or kernel crashes.

[Severity: High]
Does this unconditional power down break configurations where the UFS link
is meant to remain active during runtime PM?

If the system is configured to keep the link active during runtime suspend,
the host controller can still be suspended once the device WLUN is suspende=
d.
Previously, pm_runtime_put_sync() would not physically power off the PHY
because the Mediatek PHY driver lacks runtime PM ops. Instead, PHY power was
safely managed by ufs_mtk_pwr_ctrl() which explicitly checks the link state
and skips power-down if the link is active.

By replacing this with an unconditional ufs_mtk_mphy_power_on(hba, false),
this function blindly calls phy_power_off() regardless of the link state.
This forces the PHY off while the MAC/SCSI layers expect it to remain activ=
e,
causing UFS access to hang on wake.

[Severity: Medium]
Can this call lead to a state desynchronization if the regulator disable
fails?

Inside the ufs_mtk_mphy_power_on(hba, false) helper function, the code powe=
rs
down the hardware and then disables the regulators:

	} else {
		phy_power_off(mphy);
		ret =3D ufs_mtk_09v_off(host, true);
		if (ret)
			return ret;
	}

	host->mphy_powered_on =3D on;

If ufs_mtk_09v_off() fails, it returns early. This skips the assignment
of host->mphy_powered_on =3D on (which would be false). Software will retain
the belief that the PHY is still powered on.

When the device subsequently resumes, ufs_mtk_mphy_power_on(hba, true) chec=
ks
if (on =3D=3D host->mphy_powered_on) which evaluates to true =3D=3D true, r=
eturning 0
without calling phy_power_on(mphy). This leaves the hardware physically off
while the driver expects it to be on, causing the UFS link to fail.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016-mt8196-ufs=
-v14-0-e8d565e0cd45@collabora.com?part=3D14
