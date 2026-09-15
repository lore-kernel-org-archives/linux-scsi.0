Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450E93E0C5C
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 15:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789485125; cv=none; b=Hl3/S4SLb/VXzF3mw61Ir89sECUfUicZ15BdIRIT/rR/zKbr3mSrl/fFH37dvQAWnu9TdVJHZEILYaA6GzqK9FbABLew4BQnrYATGWXaeJPoctuQxc/9qgn034cwWmlO01xFxOPKfac+OSaa9Vc8qm2SOHEL2cFwk7WEHnijVNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789485125; c=relaxed/simple;
	bh=5P1T2xHlzGn5dDC2I4LDleKpwwDNnNDNtVh2/yd3VNI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CtETMWNUUe5YQfDHbvtzhDwELVGquSDWj25kcMe++iCwvIVzXv5KtmZMLyruJfJCQi7CGVIXt8bzub9QL0vu4WA4bYUAr2L2ElAB65h6mnCqNDpv37BP02Ost8cHUleXbDohZaDkzCyVFY1hONRxPz600F6pAe6HJ3T7ddG8ZQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9rjR8E+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9rjR8E+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6D61F000FF;
	Tue, 15 Sep 2026 15:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789485122;
	bh=0H32m1FIhMOhMZNPGLyKALMsTl21fR7xRYyxmvXN7KU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h9rjR8E+c8G9sw5Y9X1M5keLxyN7tqWlNkXMdyx11veN1cqMfA1eElwkji91ggFaV
	 2HDD3cjykSlxzhc2Flbxr5qn/g/dGfaIAkaTE0DqD67guj7GtGq/GqtfxYJXWJP3ng
	 StexUp1lbekkX7qICfhoUEpS0sVm+4kDaCAWBuO0HDterlS5gtNDhyuuA1lTdkWyRq
	 cbwRAwW36NCoiU1T3jp/B/Xo5lbui/JkZAyYAq+Nl7fGdWRiSRnFh5oNfm+m70pu1y
	 V2rG9JZ1BwUz8j9S23xJx1vCQBlWqmts0480mWbhsgOhtR+UojHQc5rbKgA1HgVQls
	 PcHlURb27gPQw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ufs: sysfs: fix current_power_mode read without SSU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yiwei Lin" <s921975628@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260915145534.8517-1-s921975628@gmail.com>
References: <20260915145534.8517-1-s921975628@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 15:12:02 +0000
Message-Id: <20260915151202.AF6D61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] ufs: missing error recovery when hibern8_enter fails leaves link a=
ctive
- [Low] cleanup: mixing goto-based error handling and scope-based cleanup
--

commit 7f21a836a7974ab0a73d76e4107550f8d10d5c90
Author: robelin <robelin@nvidia.com>

ufs: sysfs: fix current_power_mode read without SSU

This commit introduces a dedicated sysfs show function for current_power_mo=
de
to query the power mode attribute without fully resuming the UFS device to
the Active state. It handles exiting and re-entering the Hibern8 state
directly to avoid sending START STOP UNIT commands that would wake the devi=
ce.

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
> +
> +	ufshcd_hold(hba);
> +	scoped_guard(ufshcd_wl_pm, hba) {

[Severity: Low]
Is it intentional to mix goto-based error handling (like the goto out_unlock
above) and scope-based cleanup helpers (scoped_guard) in the same function?

The subsystem guidelines for cleanup functions recommend either converting =
all
resources that need a cleanup to scope-based cleanup, or converting none of
them, to avoid confusing ownership semantics.

> +		if (ufshcd_is_link_off(hba) || ufshcd_is_ufs_dev_poweroff(hba)) {
> +			/*
> +			 * Device is powered down (rpm_lvl 4/5) or link is off
> +			 * (rpm_lvl 5/6): nothing to query until a full resume.
> +			 */
> +			ret =3D -EINVAL;
> +			break;
> +		}
> +
> +		if (ufshcd_is_link_hibern8(hba)) {
> +			ret =3D ufshcd_uic_hibern8_exit(hba);
> +			if (ret) {
> +				dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
> +					__func__, ret);
> +				break;
> +			}
> +			ufshcd_set_link_active(hba);
> +			exited_h8 =3D true;
> +		}
> +
> +		ret =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			QUERY_ATTR_IDN_POWER_MODE, 0, 0, &value);
> +
> +		if (exited_h8) {
> +			int h8_ret =3D ufshcd_uic_hibern8_enter(hba);
> +
> +			if (h8_ret) {
> +				dev_err(hba->dev, "%s: hibern8 enter failed %d\n",
> +					__func__, h8_ret);
> +				ret =3D h8_ret;
> +			} else {
> +				ufshcd_set_link_hibern8(hba);
> +			}

[Severity: High]
Does this code leave the UFS link in UIC_LINK_ACTIVE_STATE if
ufshcd_uic_hibern8_enter() fails?

If h8_ret is an error, this path returns the error without restoring the
link state or triggering error recovery. Since the WLUN remains suspended,
this can lead to the host controller runtime suspending and blindly turning=
 off
the host clocks while the UFS link is still active. This violates hardware
constraints and guarantees a 10s command timeout on the next I/O.

> +		}
> +	}
> +	ufshcd_release(hba);
> +	pm_runtime_put_sync(hba->dev);
> +
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
> +
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

[Severity: Low]
Does this introduce scope-based cleanup into __ufshcd_wl_suspend(), a funct=
ion
that heavily relies on goto labels for error handling?

__ufshcd_wl_suspend() has multiple error paths using goto vops_suspend,
goto enable_scaling, and goto out. Mixing goto-based error handling and
scope-based cleanup helpers in the same function can lead to confusing
ownership semantics and is generally discouraged by the subsystem guideline=
s.

>  	if (pm_op !=3D UFS_SHUTDOWN_PM) {
>  		pm_lvl =3D pm_op =3D=3D UFS_RUNTIME_PM ?
>  			 hba->rpm_lvl : hba->spm_lvl;
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
> =20
> -	hba->pm_op_in_progress =3D true;
> +	old_link_state =3D hba->uic_link_state;

[Severity: Low]
Similar to __ufshcd_wl_suspend(), does this mix scope-based cleanup with
existing goto-based error jumps in __ufshcd_wl_resume()?

> =20
>  	/*
>  	 * Call vendor specific resume callback. As these callbacks may access

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915145534.8517=
-1-s921975628@gmail.com?part=3D1
