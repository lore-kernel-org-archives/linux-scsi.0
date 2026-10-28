Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793173711;
	b=F3/UT9gndKTjL6Ecm23waefQcdJ7MFcIdahLXeCr2CzzwlopM+XHexwwTchSQwT6ueeU
	 D7/ik0YffWfKNzsoIVdbc6tuXMEHr5k7fZEWyXs+LO/IenDKrixYxJNQBtpCyJtMhH0TI
	 CdvHHPfRIc2KLNIU86lvrVMzNMeLGX/Vf5jR5KIYLlfnPXFH5JoRNJfA7dMw33iYzRD1e
	 nq+f1ajhFLZbgyVI0GH2tXvLppdrJ8HdJuE21CZ5esaoWjMkHB328vdrfbGxTqOQMcp9d
	 KaAjyLVPTsn2bd6tHpKO+DujlOG8FnHdRF1AEOUCKSyag5aZbbHfCpGYEo/AVR5RSzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793173711;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hMxNosNSPHKTbwy+utnLGi1/Q9d5zhtPv/ATgD9Ny6k=;
	b=qMxJLUURk9SWZYx9s89fIIkw8Wt+kRRn9pvjWpfzMLPMOYmBPeAR9jkMZq9NMs4jmSnu
	 vcqOFVtL7zrHEjGCiiBi0XdUm/9UZP3Vw/bgYl92cZtTtBCpzyxLjRNGS4Qd1CFL0pAt7
	 HmCy/bJ4LTF47d8EwL1ITrVJF9wFu6exzJtug+l2+kqmqG5chCIWy19MEV54gInf6gsgS
	 AyaRCDtR5kGkkykN+up4bruSj2/LtC+UeJQR2T4Qd3tPUzIlJz5BhlnAG+Z0UzvPt2iEr
	 ZP9NxTeaNr+9igYjYpAthJGAR55dpiYR7j5FTLAEQG6Q2+qTkov/1Id7LQGI1J0NcBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SxdKlOS7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB82606A31D
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 07:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SxdKlOS7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD3E1F031E2;
	Wed, 28 Oct 2026 07:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793173710;
	bh=hMxNosNSPHKTbwy+utnLGi1/Q9d5zhtPv/ATgD9Ny6k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SxdKlOS7QtMdFMCABmt/wqZWXo9KqJtDJ+ukGDcC6M1xNSVGSuUIlvesu9P+0vs+o
	 ygIgC6kFKqXoQr7bH3Zjja/1SzcdpffTRu/5qL6boNcKYj2m9gUV2GaPItaBmDKWKf
	 7LG/oXV4l/O2jwTonzNWRopNIfF2h0capA7VNZ9dJlZlgIYIBDnpS4lNqZ6txPSKnB
	 vHG802+WZxx3US6Nm0bRLFjRVNtQbMVqvnqUDuCZYZ0Rw//w4HsFqv5qXR1mlZgQB3
	 QpA54C3Sf+umBUToxOWwv2wumsda40prLbJId06pFDI23+fsXwrKoI6pZqn0qGEfZ7
	 WKMMXohH2dEFw==
Message-ID: <sashiko-outbox-187593@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Retry the full device init on fatal
 link loss
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shawn Lin" <shawn.lin@rock-chips.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261028073129.1661829-1-shawn.lin@rock-chips.com>
References: <20261028073129.1661829-1-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 07:48:30 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ufs: core: uncollected eh_work and sticky saved_err in ufshc=
d_init()
- [High] scsi: ufs: core: missing ufshcd_mcq_enable() on retry in ufshcd_in=
it()
--

commit dd93c52494a126db3d5dec49c3f84c857b512392
Author: Shawn Lin <shawn.lin@rock-chips.com>

scsi: ufs: core: Retry the full device init on fatal link loss

This commit adds a retry loop in ufshcd_init() that resets the UFS device
and host controller up to three times with a 100 ms delay if link startup
or device initialization fails during boot.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ee643830a57a2..e75370d1b9501 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -11419,12 +11419,14 @@ int ufshcd_init(struct ufs_hba *hba, void __iom=
em *mmio_base, unsigned int irq)
> =20
>  	/* Initialize hba, detect and initialize UFS device */
>  	ktime_t probe_start =3D ktime_get();
> +	int retries =3D 3;
> =20
> +retry_init:
>  	hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> =20
>  	err =3D ufshcd_link_startup(hba);
>  	if (err)
> -		goto out_release;
> +		goto retry_device_init;
> =20
>  	if (hba->mcq_enabled)
>  		ufshcd_config_mcq(hba);

[Severity: High]
On controllers with MCQ enabled, does retrying after ufshcd_hba_stop() and
ufshcd_hba_enable() leave the hardware in legacy single doorbell mode while
hba->mcq_enabled remains true?

Before the retry_init label in drivers/ufs/core/ufshcd.c:ufshcd_init(),
ufshcd_add_scsi_host() enables MCQ by calling ufshcd_mcq_enable():

drivers/ufs/core/ufs-mcq.c:ufshcd_mcq_enable() {
	ufshcd_rmwl(hba, MCQ_MODE_SELECT, MCQ_MODE_SELECT, REG_UFS_MEM_CFG);
	hba->mcq_enabled =3D true;
}

When initialization fails and enters retry_device_init, calling
ufshcd_hba_stop() and ufshcd_hba_enable() toggles REG_CONTROLLER_ENABLE,
which resets the host controller registers including MCQ_MODE_SELECT in
REG_UFS_MEM_CFG while hba->mcq_enabled stays true.

When jumping back to retry_init, ufshcd_init() calls ufshcd_config_mcq(hba)
without calling ufshcd_mcq_enable(hba), unlike ufshcd_device_init() on
subsequent resets:

drivers/ufs/core/ufshcd.c:ufshcd_device_init() {
	/* Reconfigure MCQ upon reset */
	if (hba->mcq_enabled && !init_dev_params) {
		ufshcd_config_mcq(hba);
		ufshcd_mcq_enable(hba);
	}
}

Without re-enabling MCQ_MODE_SELECT in REG_UFS_MEM_CFG, won't subsequent
device management commands (starting with NOP OUT in
ufshcd_verify_dev_init()) be posted to the MCQ submission queues while the
hardware ignores them and times out?

[ ... ]

> @@ -11468,6 +11470,25 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
>  	ufshcd_pm_qos_init(hba);
>  	return 0;
> =20
> +retry_device_init:
> +	if (retries--) {
> +		dev_warn(hba->dev, "UFS init failed %d, full retry (%d left)\n",
> +			 err, retries);
> +
> +		ufshcd_device_reset(hba);
> +		ufs_put_device_desc(hba);
> +		ufshcd_hba_stop(hba);
> +		if (ufshcd_hba_enable(hba)) {
> +			dev_err(hba->dev, "Host controller enable failed\n");
> +			ufshcd_print_evt_hist(hba);
> +			ufshcd_print_host_state(hba);
> +			goto out_release;
> +		}
> +
> +		msleep(100);
> +		goto retry_init;
> +	}

[Severity: High]
What happens to the scheduled hba->eh_work and the latched error bits in
hba->saved_err and hba->saved_uic_err when retry_device_init loops back to
retry_init after a fatal error interrupt?

When DEVICE_FATAL_ERROR | UIC_LINK_LOST (0x880) fires during the failed
attempt, ufshcd_check_errors() latches the error into hba->saved_err and
hba->saved_uic_err, sets hba->ufshcd_state to
UFSHCD_STATE_EH_SCHEDULED_FATAL, and queues hba->eh_work:

drivers/ufs/core/ufshcd.c:ufshcd_check_errors() {
		hba->saved_err |=3D hba->errors;
		hba->saved_uic_err |=3D hba->uic_error;
		...
		ufshcd_schedule_eh_work(hba);
}

Because hba->ufs_device_wlun is still NULL during ufshcd_init() (until
ufshcd_async_scan() runs later), ufshcd_err_handling_should_stop(hba)
returns true when ufshcd_err_handler() executes:

drivers/ufs/core/ufshcd.c:ufshcd_err_handler() {
	down(&hba->host_sem);
	spin_lock_irqsave(&hba->host->host_lock, flags);
	if (ufshcd_err_handling_should_stop(hba)) {
		if (hba->ufshcd_state !=3D UFSHCD_STATE_ERROR)
			hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
		spin_unlock_irqrestore(&hba->host->host_lock, flags);
		up(&hba->host_sem);
		return;
	}
}

Since retry_device_init does not flush hba->eh_work or clear hba->saved_err,
hba->saved_uic_err, and hba->force_reset under hba->host->host_lock (as
ufshcd_reset_and_restore() does), two issues appear possible:

1. If hba->eh_work runs concurrently with the retry, ufshcd_err_handler()
can overwrite hba->ufshcd_state with UFSHCD_STATE_OPERATIONAL after
retry_init sets it to UFSHCD_STATE_RESET.

2. Even after a retry succeeds, hba->saved_err retains the sticky
DEVICE_FATAL_ERROR | UIC_LINK_LOST bits. On any later non-fatal UIC event
(such as a line reset during power mode configuration in
ufshcd_post_device_init() or during normal runtime),
ufshcd_check_errors() checks ufshcd_is_saved_err_fatal(hba), misclassifies
the event as a fatal error, and either leaves hba->ufshcd_state in
UFSHCD_STATE_EH_SCHEDULED_FATAL across ufshcd_process_probe_result() or
triggers an unnecessary full reset once hba->ufs_device_wlun is added.

Should retry_device_init flush hba->eh_work and clear hba->saved_err,
hba->saved_uic_err, and hba->force_reset under host_lock before retrying?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028073129.1661=
829-1-shawn.lin@rock-chips.com?part=3D1
