Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1A53DB62E
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789484757; cv=none; b=htbsUByI2zrerRyqtN8WGNQ9zmJA3AJ9InlPX5D7uIJY6hRIaDFlr4WwtnJEwMCi7iXaYBbOhQ+7g4hywniHBOSX5WHNJd5Msoyj3laa69xC0AgMfEu5NjiNKXv33C5WtCT49U1IrhNAnyDszlPshMx9nK15Z721Vs9sT7FWA10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789484757; c=relaxed/simple;
	bh=X25j0QtsnC5sADVL/J8AtkcLE+QJp9i26+Xb1cM9HwQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=svNf/lqUMkGlMv4iZe22l6n2m5zvYfwwE1ue907xtUjl+VpJ0uBNYIHxdfwE61ZeAoIXhAcBjfYTcwqeMln9dfy77neQqQ4UxTo+5uVY3kf+gf6bSgdTVmaycccH9huU/vTC8nxojStb084tkHg8L2fseohNFtjOneAzh7LnuV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPiERSEf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPiERSEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E82F1F000FF;
	Tue, 15 Sep 2026 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789484755;
	bh=glPdwMujE1Gu8oRz1ZkycFL1BcRxENa/zmgK+Hda40M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OPiERSEfTmZoCjnPTYisACBk12J6LW8owy6uTAR+8evIEI8kCfDPZIjvYhAiSdm8p
	 z0ny4COL5iCvSf3AuLqZXYMY3bwUanT4OwHlTS9yDBKzsy/NYpFGuRLhwpE3atQDSK
	 QPJBAglO9sS6NzHP86AnYlsaGxrohuJhrUyIhkD34C4E6/nHQftNlMIzAl8WqsAMD/
	 uZleG+rHXTwnoVmQbzM+JWF9ptbMNsy1AdAhgAU2USBbleU6o/Hp4p+Ufrv+SK4XKP
	 A73qzxRETk9P6fathY1v0QR/lzk7kaGeKLMNsyH11Ayv7/MdX7I0hInfB7Pv+wmZZR
	 j/QLVBVHBoGzQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ufs: sysfs: fix current_power_mode read without SSU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yiwei Lin" <s921975628@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260915145354.8194-1-s921975628@gmail.com>
References: <20260915145354.8194-1-s921975628@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 15:05:54 +0000
Message-Id: <20260915150555.3E82F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] pm: unchecked pm_runtime_get_sync() return value leads to hardware=
 access crash
- [Medium] cleanup: mixing goto-based cleanup with guard()/scoped_guard() i=
n the same function
--

commit 5c7e45d8ae7aae3212b7ac69373b91780e44ec84
Author: robelin <robelin@nvidia.com>

ufs: sysfs: fix current_power_mode read without SSU

This commit gives current_power_mode its own show function that deliberately
does not resume the WLUN. It also introduces WLUN suspend/resume
synchronization against contexts changing the link power state.

> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index cf49ad0258e14..2d1ed2ca0dfa4 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
[ ... ]
> @@ -1786,7 +1786,79 @@ out:									\
>  static DEVICE_ATTR_RO(_name)
> =20
>  UFS_ATTRIBUTE(boot_lun_enabled, _BOOT_LU_EN);
> -UFS_ATTRIBUTE(current_power_mode, _POWER_MODE);
> +
> +/*
> + * Per UFS spec, bCurrentPowerMode is the only attribute the device must
> + * respond to in any power mode.  Read it without waking the device to
> + * Active.
> + */
> +static ssize_t current_power_mode_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +	bool exited_h8 =3D false;
> +	u32 value;
> +	int ret =3D 0;
> +
> +	down(&hba->host_sem);
> +	if (!ufshcd_is_user_access_allowed(hba)) {
> +		ret =3D -EBUSY;
> +		goto out_unlock;
> +	}
> +
> +	pm_runtime_get_sync(hba->dev);

[Severity: High]
Does this need a return value check? If pm_runtime_get_sync() fails (for
example, due to a power domain or regulator failure), the device and its
clocks might not be enabled. Proceeding to access its memory-mapped
registers via ufshcd_uic_hibern8_exit() or ufshcd_query_attr() below could
trigger a synchronous external abort and crash the system.

> +
> +	ufshcd_hold(hba);
> +	scoped_guard(ufshcd_wl_pm, hba) {

[Severity: Medium]
Is it intended to mix scope-based cleanup with goto-based error handling in
this function? According to subsystem guidelines, functions should either
convert all resources to scope-based cleanup or use none. Mixing them can
create confusing ownership semantics and risk resource leak bugs.

> +		if (ufshcd_is_link_off(hba) || ufshcd_is_ufs_dev_poweroff(hba)) {
[ ... ]
> +	if (!ret)
> +		ret =3D sysfs_emit(buf, "0x%08X\n", value);
> +	else
> +		ret =3D -EINVAL;
> +
> +out_unlock:
> +	up(&hba->host_sem);
> +	return ret;
> +}
> +static DEVICE_ATTR_RO(current_power_mode);
[ ... ]
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 234e18b5078f2..462749b850b13 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10319,7 +10319,8 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hb=
a, enum ufs_pm_op pm_op)
>  	enum ufs_dev_pwr_mode req_dev_pwr_mode;
>  	enum uic_link_state req_link_state;
> =20
> -	hba->pm_op_in_progress =3D true;
> +	guard(ufshcd_wl_pm)(hba);
> +

[Severity: Medium]
Does introducing guard() here conflict with the cleanup guidelines against
mixing scope-based and goto-based cleanup? This function heavily uses
goto-based error handling, which could create confusing ownership semantics
and risks double-free or resource leak bugs.

>  	if (pm_op !=3D UFS_SHUTDOWN_PM) {
>  		pm_lvl =3D pm_op =3D=3D UFS_RUNTIME_PM ?
[ ... ]
> @@ -10500,9 +10500,11 @@ static int __ufshcd_wl_suspend(struct ufs_hba *h=
ba, enum ufs_pm_op pm_op)
>  static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  {
>  	int ret;
> -	enum uic_link_state old_link_state =3D hba->uic_link_state;
> +	enum uic_link_state old_link_state;
> +
> +	guard(ufshcd_wl_pm)(hba);

[Severity: Medium]
Similarly, does using guard() here conflict with the goto statements and
manual cleanup present in this function?

> =20
> -	hba->pm_op_in_progress =3D true;
> +	old_link_state =3D hba->uic_link_state;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915145354.8194=
-1-s921975628@gmail.com?part=3D1
