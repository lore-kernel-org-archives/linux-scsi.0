Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB293F7AB4
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 15:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789485322; cv=none; b=qfHIaL+Y8Iomqx4BlVlPdFfZ6G6bzMGAOTVSDI9kx8JV99PVFjTdomdOdPped9X80Igg4s4j1rAtj7lOl/PLLEm6/mvAfH+QH49wpVAtJKhijwOQ6RDiQFSNwq5+AWOx1amOpgO+FsOCo/57ytx4ZyY5JDzwNBOr32qQ2TLcNWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789485322; c=relaxed/simple;
	bh=/WMtNp12Sugnd4zCQNZFMUoZi6Fc764ZdQ+ixeQXlZk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pguiiHw/dQDZ+RW4kXVlIugPR6rzFazIgwpSqr1MPSDlNKUoGNckkzVR1HBprD2rfsdUhgEzDkuM+rMsRZe3wXgziXFxz12VkgzrveSeCwp4LJLGm+ImINT4r5EIPt2NnjbhRAe80Vi7G1hG5eKVoX7eu6mRxvjO1wqwG5ZziEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c29lbK0q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c29lbK0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A48F1F000FF;
	Tue, 15 Sep 2026 15:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789485320;
	bh=2+DK0jrJJzB51mVqq0XzAnFwjtizwsaCBLm6h34cJtQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c29lbK0qDcWC1flTQQt6BcVe5/HHYcTa/25qJJMr+WoPuO339JslD+iF82VNSEFlW
	 hlGGpNQtYEvumAvLljpTN/iBf5i0+JtDtsclcsgqI3l1lbF+z82DpXS8YMs7IqpUxp
	 1z5mSuRhbIxAd+jPnAm4EkH5P4mb56cG+ez66NliotC0OVPfjH8t1vO4vQKIPSSS9P
	 j4ml0tzUqetOiEo6ZluGqdQlRyOUuhmRng47Ux7NdtBb8ZSgulSLhu0vv/SRJIurJr
	 MuHcOeW4nQ0HdfsOYwuaTBpgI5aRhSX3KtMKB3aQm2rM7ixY56VhHWCKTn8p31rFFP
	 6sHzYZtbBlMLg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ufs: sysfs: fix current_power_mode read without SSU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yiwei Lin" <s921975628@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260915145924.9080-1-s921975628@gmail.com>
References: <20260915145924.9080-1-s921975628@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 15:15:19 +0000
Message-Id: <20260915151520.2A48F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] ufs: sysfs: missing check for pm_runtime_get_sync() failure
- [High] ufs: core: sysfs read breaks SCSI error recovery by setting pm_op_=
in_progress
- [High] ufs: core: ufshcd_hold() during WLUN suspend clobbers clk_gating.i=
s_suspended
- [Medium] ufs: cleanup: mixing goto and scoped guards violates subsystem r=
ules
--

commit d0c0842fc07bdb2ba7fa8889f82851b6387be9b5
Author: Yiwei Lin <s921975628@gmail.com>
Subject: ufs: sysfs: fix current_power_mode read without SSU

This patch modifies the current_power_mode sysfs attribute to read the
value without fully resuming the WLUN. It uses Hibern8 exit/enter instead
of waking the device to Active mode.

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
Does this code need to check the return value of pm_runtime_get_sync()?

If it fails, the controller power domain remains off, but the function igno=
res
the error, proceeds to call ufshcd_hold(), and directly accesses hardware
registers via ufshcd_uic_hibern8_exit() and ufshcd_query_attr(), which could
cause a system crash (synchronous external abort) due to accessing unpowered
hardware registers.

> +
> +	ufshcd_hold(hba);

[Severity: High]
Can calling ufshcd_hold() without waking the WLUN clobber the clock gating
state?

If clocks are off, this queues ufshcd_ungate_work(). In ufshcd_ungate_work(=
),
the code unconditionally overwrites hba->clk_gating.is_suspended =3D false =
at
the end of its Hibern8 exit block.

Because the WLUN is actually still suspended, this state corruption causes =
the
subsequent ufshcd_release(hba) to schedule ufshcd_gate_work(), which will t=
hen
attempt to issue Hibern8 commands to a link that may be in DeepSleep (power=
ed
off), resulting in unrecoverable failures.

> +	scoped_guard(ufshcd_wl_pm, hba) {
> +		if (ufshcd_is_link_off(hba) || ufshcd_is_ufs_dev_poweroff(hba)) {

[Severity: Medium]
Does mixing scoped_guard() with the manual goto out_unlock cleanup below
violate the cleanup subsystem architectural rules?=20

The rules state that code should not mix goto-based error handling with
guard()/scoped_guard() declarations in the same function to avoid confusing
ownership semantics.

[Severity: High]
Can holding this scoped_guard() break SCSI error recovery by setting
pm_op_in_progress?

The DEFINE_LOCK_GUARD_1(ufshcd_wl_pm) macro sets
hba->pm_op_in_progress =3D true. If a concurrent background I/O times out w=
hile
this sysfs read holds the guard, ufshcd_eh_timed_out() observes the flag,
bypasses standard aborts/resets to avoid deadlocking with PM, and directly
completes the command. This leaves the hardware permanently hung since no
actual PM recovery operation is taking place.

> +			/*
> +			 * Device is powered down (rpm_lvl 4/5) or link is off
> +			 * (rpm_lvl 5/6): nothing to query until a full resume.
> +			 */
> +			ret =3D -EINVAL;
> +			break;
> +		}
[ ... ]
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
>  	if (pm_op !=3D UFS_SHUTDOWN_PM) {

[Severity: Medium]
Does the use of guard() here mix with the extensive goto state transitions
present later in this function (e.g., goto vops_suspend)?=20

The cleanup.md guidelines explicitly prohibit mixing goto-based error handl=
ing
with guard() declarations in the same function.

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

[Severity: Medium]
Does this mix guard() with goto out cleanup jumps in this function?

The rules state that a function should convert all resources to scope-based
cleanup or none of them.

> =20
>  	/*
>  	 * Call vendor specific resume callback. As these callbacks may access

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915145924.9080=
-1-s921975628@gmail.com?part=3D1
