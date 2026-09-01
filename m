Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E9548124E;
	Tue,  1 Sep 2026 16:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788280386; cv=none; b=o205QyeEY7qn68E610Z2BMgOq9tLTBADxncc2Jrt1nT6dbRCNfbaxfdWmFYCNGdJbwevsjp9j3tqrDL+GY7gJxMsV02jm4TtFXPHPC9d/yhkW3JRmogkoY9vuuQIDTe/XNkjAOGH4UTGOOgYLMpFnhlb2qT2l1sfsSV8HXaKaCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788280386; c=relaxed/simple;
	bh=GxO6TxUuUy0vtN0rYZD1huC+39hD0vWWQF52HK3/5Jo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JXdv2AHO4hRnDidkhd/HGaRRL7tQ9rMJltwvLDEf4gVOSoOgkYo4X88QQjZVyv0VeY7Ij5UNNKXsAOhC6L4nVJ+ohqLirID4g2xEvytEz2tE3gqVlB2Jtbufhf5WpzGldI1mmhVC8miTzyaVOg1pK2yY4uDLvXPxKFeTPW8SL/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dwz3dSFU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dwz3dSFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8841F000E9;
	Tue,  1 Sep 2026 16:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788280384;
	bh=YJz8BbL1/lzpe86MseU3HV4c3Tlb2GBXlla8B3STk6E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dwz3dSFUTdbRNrChSM+WsLO1oh0ND20nFVKk7cgOmzW4m4it5LUcIn2LynWsVSMUT
	 4Po+kO3m34cG4NCpmuB6clIKEVlsdVGHx6bbmWFtAJVHrt53BHdqvlFhHRXJOeVTRX
	 ZSlIMKX90VijLCUsG7ZTDjmtUA+3CBqUpmO+oOIHBQ/8iO6Nodndkj5NAZ233lFO3Q
	 WuHSIKu2cU8Ok4CeCOst5G1EQJXhshwoekaFLez1XX1oqI+v9vJXct6BUSaqHd9RW3
	 hOt9CI4QgFeDoj1JLGUQo7Bj84U5DiZfruNPgxlUdSdrCpnUAmlFCodgbQtxxEndVE
	 AQBIeA9wDJ9pA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 21/24] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: robh@kernel.org, devicetree@vger.kernel.org, linux-phy@lists.infradead.org, vkoul@kernel.org, linux-scsi@vger.kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com, conor+dt@kernel.org
In-Reply-To: <20260901-mt8196-ufs-v11-21-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-21-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 16:33:03 +0000
Message-Id: <20260901163304.6D8841F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A failed power mode change will permanently disable the auto-hiber=
n8 timer due to brittle backup/restore logic.
- [High] Concurrent sysfs write to `auto_hibern8` races with power mode cha=
nges, circumventing hardware constraints and losing user configuration.
--

commit dec217a616e37a6d6c6074f353ace1fc743596e2
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Back up idle timer in per-instance struct

The MediaTek UFS driver uses a function-scope static variable to back up
a hardware register across a power change in the
ufs_mtk_pwr_change_notify function. This is dangerous, as it's only
correct if only ever one instance of the driver is loaded, which isn't
true if there's more than one device on a SoC that needs it, or it
otherwise gets loaded a second time.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index f405f511f41fd..4782fdf54866b 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1441,27 +1441,24 @@ static int ufs_mtk_pwr_change_notify(struct ufs_h=
ba *hba,
>  				enum ufs_notify_change_status stage,
>  				struct ufs_pa_layer_attr *dev_req_params)
>  {
> -	int ret =3D 0;
> -	static u32 reg;
> +	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> =20
>  	switch (stage) {
>  	case PRE_CHANGE:
>  		if (ufshcd_is_auto_hibern8_supported(hba)) {
> -			reg =3D ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +			host->ahit =3D ufshcd_readl(
> +				hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
>  			ufs_mtk_auto_hibern8_disable(hba);
>  		}

[Severity: High]
This isn't a bug introduced by this patch, but does this brittle caching lo=
gic
risk permanently disabling the auto-hibernate feature?

In ufshcd_change_power_mode(), PRE_CHANGE is called first, which reads the
hardware timer value and disables it. If the subsequent
ufshcd_dme_change_power_mode() fails (e.g., due to a UIC command timeout),
POST_CHANGE is bypassed.

This leaves the hardware timer physically disabled (0).

On the next power mode change attempt, PRE_CHANGE reads the now-disabled
value (0) and overwrites host->ahit with 0. When POST_CHANGE eventually
succeeds, it restores 0, permanently disabling the feature until a reboot.

Could we instead restore from the core driver's hba->ahit, which reliably
tracks the configured value, rather than caching the physical hardware state
here?

> -		ret =3D ufs_mtk_pre_pwr_change(hba, dev_req_params);
> -		break;
> +		return ufs_mtk_pre_pwr_change(hba, dev_req_params);
>  	case POST_CHANGE:
>  		if (ufshcd_is_auto_hibern8_supported(hba))
> -			ufshcd_writel(hba, reg, REG_AUTO_HIBERNATE_IDLE_TIMER);
> -		break;
> -	default:
> -		ret =3D -EINVAL;
> -		break;
> +			ufshcd_writel(hba, host->ahit,
> +				      REG_AUTO_HIBERNATE_IDLE_TIMER);

[Severity: High]
This is a pre-existing issue, but does blindly restoring this cached value =
risk
losing user configuration and violating hardware constraints during a race
with sysfs?

When ufshcd_devfreq_scale() changes power modes, it holds clk_scaling_lock =
and
scan_mutex, but does not acquire hba->host_sem. Concurrently, a sysfs write=
 to
the auto_hibern8 node invokes auto_hibern8_store(), which updates the hardw=
are
register under hba->host_sem but without holding clk_scaling_lock.

If a sysfs write occurs immediately after PRE_CHANGE disabled the
auto-hibernate timer, the timer is re-enabled during
ufshcd_dme_change_power_mode(), violating the constraint this function is
trying to enforce.

Furthermore, when POST_CHANGE executes, it overwrites the register with the
stale host->ahit value, completely undoing the user's sysfs configuration.

> +		return 0;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D21
