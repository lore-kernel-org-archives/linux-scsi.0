Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239601;
	b=uHW+uW5dB4fovhKxA4tsV0zn2NMOHjUnzQNkbwaQDCKZ7A2+pI/G1C+/4oEmj/hPZvq7
	 arTlTVjfmpU0Rr7s2mKXhiMCFhbNEC8AiUiA4UePJGBRgOHGtianVliTfphxED+IWWMiw
	 E4u1XjnuldKyrYdzeIu6K0t1Y9qCvVxI3XAM4CjcZJ4K12FcVCM6VF2t9zEGdud/al5R5
	 JiUpU/wwsGT/sjXxS4LAhv95zS6hItiHGMfz6rD3cZTXG0Tn4g2CIBP+VtjCsGIdwAOv9
	 DiBAarbc/6esW7pcScMrokN69/SoZ/Hkswves7eSBUWrnisfpc7IjMWMkuZSBSZtZoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239601;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zv7ViynRg6mNcq4ccWUj2QOJJwdFf4r/Y0mEJQD2GV0=;
	b=oCMwzIQh6c68meV2QKmbpRyFvGwXxAQPcwcuX7PqlGdpFEPBYNRX8Kn5NohoRqwxNimp
	 Vilu1s+GcT7VflG/8igDQ9dUqXZbf72frgjXAO6h08vI21uCk3GuzMCmRT8N25ds0JfjF
	 pTF2pymsPokGFK1KhlqhN3Hu8Id/rj3Ex9yAoiq3zUdlkxDLRED9Uh8b/lZg7VWvo9eIb
	 gxxFns+oZ0eAM5J5H/0V3waLQrEt3+H9yG9jQLHYCamIBwm0HlMZnSrBKpa/oyHbzrmR8
	 4Nb7gdYTVUzVBfLpDo+pl8qvnaNJww2n7rIngR7NTs12RvlD/84CLU5IIAERJIWUjgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="E/FIfTaR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70FA606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 02:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E/FIfTaR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEEB1F01825;
	Thu, 29 Oct 2026 02:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239600;
	bh=zv7ViynRg6mNcq4ccWUj2QOJJwdFf4r/Y0mEJQD2GV0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E/FIfTaRAT4QPvDAl5YzNLU2ubNaN+JysLfgf/V/VmclVXRBGoo1FcyGMqrZODsqT
	 6ZcOXlXL0IV1a+p8wOdHXh3/CCCPlDGzpJW1W7YlrvTeTtFf4MVSjHLvw5x093lSQF
	 XBa0eMDyjwmjrNBQf4xxlCt9gTxIhzz7qmYdtzXkfzrhXfAjcLdnt7t3XbTVUF5ZTR
	 uhSQqbYqEIFg2qrupI7ewLbzxE5+ndDOuVlMJ5I3ahqPGBvt1WVkMPpmZ5psEeATlZ
	 keAhoKl1Mco99aO98rtRDDJjQwBb+Yljvq+jhgVqrWVHWa/bJQITw9dNxVCceqzAVh
	 xyu4kBMuDW3cg==
Message-ID: <sashiko-outbox-188630@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Retry the full device init on
 fatal link loss
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shawn Lin" <shawn.lin@rock-chips.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261029014839.3390579-3-shawn.lin@rock-chips.com>
References: <20261029014839.3390579-1-shawn.lin@rock-chips.com>
 <20261029014839.3390579-3-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 02:06:39 +0000
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
- [High] scsi: ufs: core: broken MCQ reconfiguration order in ufshcd_init()=
 retry
- [High] scsi: ufs: error state cleared before ufshcd_hba_stop() in ufshcd_=
init()
- [High] scsi: ufs: core: missing ufs_hwmon_remove() and EE mask reset on i=
nit retry
- [Low] scsi: ufs: core: pass host_lock pointer to spin_lock_irqsave()
--

commit 23f03ec7ec12e66a1c4114bfb0fbd0cd5e4ff5c9
Author: Shawn Lin <shawn.lin@rock-chips.com>

scsi: ufs: core: Retry the full device init on fatal link loss

This commit retries ufshcd_full_device_init() up to three times in
ufshcd_init() when device initialization fails, resetting the device and
host controller and clearing latched error state between attempts.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index f1e54d7195370..bd82d6755739c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -11468,8 +11468,52 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
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
> +
> +		if (!retries)
> +			break;
> +
> +		dev_warn(hba->dev, "UFS init failed %d, full retry (%d left)\n",
> +			 err, retries);
> +
> +		/*
> +		 * The failed attempt may have latched fatal errors and
> +		 * scheduled the error handler. Stop it and start the retry
> +		 * from a clean state, mirroring ufshcd_reset_and_restore().
> +		 */
> +		cancel_work_sync(&hba->eh_work);
> +		spin_lock_irqsave(hba->host->host_lock, flags);
> +		hba->saved_err =3D 0;
> +		hba->saved_uic_err =3D 0;
> +		hba->force_reset =3D false;
> +		hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);

[Severity: Low]
In include/scsi/scsi_host.h, host_lock in struct Scsi_Host is defined by
value rather than as a pointer:

	spinlock_t		host_lock;

Should spin_lock_irqsave() and spin_unlock_irqrestore() in ufshcd_init()
take &hba->host->host_lock instead of hba->host->host_lock so that
drivers/ufs/core/ufshcd.c compiles?

> +
> +		ufshcd_device_reset(hba);
> +		ufs_put_device_desc(hba);
> +		ufshcd_hba_stop(hba);

[Severity: High]
What happens if an error or link-loss interrupt fires while the host
controller is still active during ufshcd_device_reset(), before
ufshcd_hba_stop() disables the controller?

Because cancel_work_sync(&hba->eh_work) and the clearing of hba->saved_err,
hba->saved_uic_err, and hba->ufshcd_state happen before ufshcd_hba_stop(),
resetting the attached device while controller interrupts are enabled can
trigger ufshcd_intr() -> ufshcd_check_errors():

	hba->saved_err |=3D hba->errors;
	hba->saved_uic_err |=3D hba->uic_error;
	...
	ufshcd_schedule_eh_work(hba);

Since hba->ufs_device_wlun is not set yet and hba->host_sem is not held
during ufshcd_init(), ufshcd_err_handler() can then run concurrently on
hba->eh_wq:

	down(&hba->host_sem);
	spin_lock_irqsave(&hba->host->host_lock, flags);
	if (ufshcd_err_handling_should_stop(hba)) {
		if (hba->ufshcd_state !=3D UFSHCD_STATE_ERROR)
			hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
		spin_unlock_irqrestore(&hba->host->host_lock, flags);
		up(&hba->host_sem);
		return;
	}

Could this overwrite hba->ufshcd_state and leave hba->saved_err and
hba->saved_uic_err latched during the retry? Should ufshcd_hba_stop(hba) be
called before cancelling hba->eh_work, clearing the error state, and
resetting the device?

[Severity: High]
Can this retry path also leak the hwmon device and struct ufs_hwmon_data if
ufshcd_full_device_init() fails in ufshcd_post_device_init() after
ufshcd_device_params_init() has already succeeded?

During ufshcd_full_device_init(), the call chain is:

	ufshcd_device_params_init()
	  ufs_get_device_desc()
	    ufshcd_temp_notif_probe()
	      ufshcd_enable_ee(hba, mask);
	      ufs_hwmon_probe(hba, mask);
	ufshcd_post_device_init()
	  ufshcd_config_pwr_mode()

If ufshcd_post_device_init() fails, ufs_put_device_desc() only frees
dev_info->model and dev_info->device_id. On the next iteration,
ufs_hwmon_probe() in drivers/ufs/core/ufs-hwmon.c allocates a new
struct ufs_hwmon_data, registers a second hwmon device, and overwrites
hba->hwmon_device:

	data =3D kzalloc_obj(*data);
	if (!data)
		return;
	...
	hwmon =3D hwmon_device_register_with_info(dev, "ufs", data, &ufs_hwmon_hba=
_info, NULL);
	...
	hba->hwmon_device =3D hwmon;

In addition, hba->ee_ctrl_mask and hba->ee_drv_mask retain the bits set by
ufshcd_enable_ee() before ufshcd_device_reset() reset the device, which
causes ufshcd_update_ee_control() on the next attempt to see an unchanged
mask and skip writing the exception event control attribute to the device.
Should the retry cleanup call ufs_hwmon_remove(hba) and clear the exception
event masks?

> +		if (ufshcd_hba_enable(hba)) {
> +			dev_err(hba->dev, "Host controller enable failed\n");
> +			ufshcd_print_evt_hist(hba);
> +			ufshcd_print_host_state(hba);
> +			goto out_release;
> +		}
> +
> +		/* Reconfigure MCQ upon controller re-enable */
> +		if (hba->mcq_enabled) {
> +			ufshcd_config_mcq(hba);
> +			ufshcd_mcq_enable(hba);
> +		}

[Severity: High]
Is the ordering of ufshcd_config_mcq(hba) and ufshcd_mcq_enable(hba) here
intended?

On the initial probe path, ufshcd_add_scsi_host() calls ufshcd_mcq_enable()
first, and ufshcd_full_device_init() calls ufshcd_config_mcq() only after
ufshcd_link_startup() completes:

	err =3D ufshcd_link_startup(hba);
	if (err)
		return err;

	if (hba->mcq_enabled)
		ufshcd_config_mcq(hba);

In the retry path of ufshcd_init(), calling ufshcd_config_mcq(hba) before
ufshcd_mcq_enable(hba) configures the queues and enables them in
ufshcd_mcq_make_queues_operational() before ufshcd_mcq_enable() selects
multi-circular queue mode in REG_UFS_MEM_CFG and before the next attempt's
ufshcd_link_startup(hba). Then, when ufshcd_full_device_init() runs on the
next iteration, it calls ufshcd_config_mcq(hba) a second time while the
hardware queues are already enabled.

Furthermore, if ufshcd_link_startup() encounters an error on its own retry
and calls ufshcd_hba_enable(hba), the controller reset will clear
REG_UFS_MEM_CFG again without ufshcd_mcq_enable(hba) being re-applied before
ufshcd_config_mcq(hba). Should the retry path only call
ufshcd_mcq_enable(hba) (or should ufshcd_mcq_enable(hba) be called right
before ufshcd_config_mcq(hba) inside ufshcd_full_device_init())?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029014839.3390=
579-1-shawn.lin@rock-chips.com?part=3D2
