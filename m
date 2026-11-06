Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793998660;
	b=wnSwFkBrSM3uMWQakMAytGW0tsz7jyVSvmuehJRLmsQgWSs46JsysQttvflyKHADM29C
	 T67BrnypTJuka3DrTuVXaUDSsW6fhoNUR6DpKSxs56/hmAlGL117hGAt2xnci9CpY2HwA
	 EjPt5szfLIfMUqyrgsJNKhHuFeFdSYKcu1retL/Kiiam8BuV3Jvf0GwaJArApTWelDwno
	 0ct29KTEfIp0W1MwhWrwUPSszlx33+PnrDRR9ytXYxlz1uWo2X24cp3JWxyBMox/HuMqJ
	 BBNCwZmBQJOnJNGxSHsWIbz0pGlt+f+lQ3uDxXQjfYrrTE7Cx4Bk+URj6a+3EbMpjZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793998660;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uzNJh4xzbLQhnLZB/iqsaePvPCruCIgzW2R1EL5YIWk=;
	b=pWQOqHz7mEDMZDzq80dSmmouxTzMMoG5KbnVAeR3qIluIrwy85iiTti0DbhRBRYeMtc6
	 Bv6xA+HsgJUrO0dlkS9n8I2yBnVFQcULBPEbAfhet2niym0dWp73hokO8kFZY/bAPTfWM
	 FEw998wb8xLSMkyBsOYSWg1FCHfxSIIHDarprRBhLgzGfkC858+AIj8YOjSe9JO18H7hx
	 1fagz58XRRwfgxEgAg9NY/q5SPkD9DkjGFJFs9GxXliNNdMk/v5MF24caX9JS3vZkMaUK
	 5m4zzbuu8u2oBGdDEINGMAZGEwvYdNcF8do/MUjziHD+/4wlpZlvcJxC7csTmTG/oig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkkCKGRA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B8C606A329
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 20:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkkCKGRA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7410A1F0089F;
	Fri,  6 Nov 2026 20:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793998659;
	bh=uzNJh4xzbLQhnLZB/iqsaePvPCruCIgzW2R1EL5YIWk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jkkCKGRA6ci2r47+YSXI8AFwta2BGbzD8bVdFF1ksAHZDRU/pFRn0pY/Tc0FF+wre
	 Kreb2gUtEg0Fxq18nX1tzwdhwbCgPeYns12p77bFDTjeyWxO/yhHVi4OdPDsDw+2P9
	 Jn2tX99vQZ+sfhLeciFmj20n+Cg1io+No610SopRoKBH79v+91lgSDjfHi8LEZe2ns
	 tEGWy62dS2jQXBubTEF/BfqZoeGaoG3niIKjvbnuJce2U4xirmwNrgAIDismOXSU7o
	 UKkfK7eISh+LE+KEIu+Q+4PhASUaa5jY6DoCc9HGzVojLui2Bmef+u534Z4pNo9bbC
	 5MC0cKSeR1I4w==
Message-ID: <sashiko-outbox-202261@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] scsi: mpt3sas: Time out delayed not-responding
 device blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jeff Layton" <jlayton@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261106-sas-abba-v3-2-571b854594aa@kernel.org>
References: <20261106-sas-abba-v3-0-571b854594aa@kernel.org>
 <20261106-sas-abba-v3-2-571b854594aa@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 20:57:39 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] scsi: mpt3sas: use-after-free of sdev->hostdata in unblock
  helpers
- [Medium] scsi: mpt3sas: race setting SDEV_OFFLINE outside block_lock
  on unblock failure
- [Medium] scsi: mpt3sas: _scsih_block_io_all_device() leaves sdevs
  blocked without deadline
--

commit ba9687a8025a542963a3bc4d91c8e8b094a21e74
Author: Jeff Layton <jlayton@kernel.org>

scsi: mpt3sas: Time out delayed not-responding device blocks

This commit adds a delayed work item and per-device deadline to release
delayed not-responding sdev blocks after the firmware's device missing
delay plus 30 seconds, preventing scans from deadlocking on sas_host->lock.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 60c9cf679a8a7..acdeece20140f 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c

[ ... ]

> @@ -3958,7 +3989,20 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER=
 *ioc, u8 no_turs)
>  	int count =3D 0;
>  	u8 tr_method =3D 0;
>  	u8 tr_timeout =3D 30;
> +	unsigned long flags;
> =20
> +	/* polling one device can outlast another's deadline */
> +	if (!no_turs && issue_scsi_cmd_to_bringup_drive) {
> +		shost_for_each_device(sdev, ioc->shost) {
> +			spin_lock_irqsave(&ioc->block_lock, flags);
> +			sas_device_priv_data =3D sdev->hostdata;
> +			if (sas_device_priv_data &&
> +			    sas_device_priv_data->sas_target &&
> +			    !sas_device_priv_data->sas_target->deleted)
> +				sas_device_priv_data->block_deadline =3D 0;
> +			spin_unlock_irqrestore(&ioc->block_lock, flags);
> +		}
> +	}
> =20
>  	shost_for_each_device(sdev, ioc->shost) {
>  		sas_device_priv_data =3D sdev->hostdata;
> @@ -3975,10 +4019,18 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTE=
R *ioc, u8 no_turs)
>  		if ((no_turs) || (!issue_scsi_cmd_to_bringup_drive)) {
>  			sdev_printk(KERN_WARNING, sdev, "device_unblocked handle(0x%04x)\n",
>  				sas_device_priv_data->sas_target->handle);
> -			_scsih_internal_device_unblock(sdev, sas_device_priv_data);
> +			spin_lock_irqsave(&ioc->block_lock, flags);
> +			/* dnr_unblock_work may have released it */
> +			if (sas_device_priv_data->block)
> +				_scsih_internal_device_unblock(sdev,
> +				    sas_device_priv_data);
> +			spin_unlock_irqrestore(&ioc->block_lock, flags);
>  			continue;
>  		}
> =20
> +		/* may have been blocked since the first pass */
> +		if (!_scsih_claim_block(ioc, sdev))
> +			continue;
>  		do {
>  			pcie_device =3D mpt3sas_get_pdev_by_handle(ioc, sas_target->handle);
>  			if (pcie_device && (!ioc->tm_custom_handling) &&
> @@ -3997,11 +4049,13 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTE=
R *ioc, u8 no_turs)
>  		} while ((rc =3D=3D DEVICE_RETRY || rc =3D=3D DEVICE_START_UNIT ||
>  		    rc =3D=3D DEVICE_STOP_UNIT || rc =3D=3D DEVICE_RETRY_UA)
>  			&& count++ < command_retry_count);
> +		spin_lock_irqsave(&ioc->block_lock, flags);
>  		sas_device_priv_data->block =3D 0;
>  		if (rc !=3D DEVICE_READY)
>  			sas_device_priv_data->deleted =3D 1;
> =20
>  		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
> +		spin_unlock_irqrestore(&ioc->block_lock, flags);
> =20
>  		if (rc !=3D DEVICE_READY) {
>  			sdev_printk(KERN_WARNING, sdev, "%s: device_offlined,\n"

[Severity: High]
Can _scsih_ublock_io_all_device() and _scsih_ublock_io_device_wait() cause a
use-after-free on sas_device_priv_data and sas_target?

shost_for_each_device() only holds a reference on sdev, not sdev->hostdata.
When _scsih_dnr_unblock_work() unblocks an sdev that was blocked during a
concurrent sysfs scan and its probe fails in scsi_probe_and_add_lun(), or
when a device is removed via sysfs, __scsi_remove_device() calls
scsih_sdev_destroy(), which clears sdev->hostdata under ioc->block_lock and
frees sas_device_priv_data:

CPU0 (firmware_event_thread)      CPU1 (scan / device removal)
_scsih_ublock_io_all_device()
  sas_device_priv_data =3D
    sdev->hostdata;
  _scsih_claim_block(ioc, sdev)
  _scsih_wait_for_device_...()
                                  __scsi_remove_device(sdev)
                                    scsih_sdev_destroy(sdev)
                                      spin_lock_irqsave(&ioc->block_lock)
                                      sdev->hostdata =3D NULL;
                                      spin_unlock_irqrestore(&ioc->block_lo=
ck)
                                      kfree(sas_device_priv_data);
  spin_lock_irqsave(&ioc->block_lock)
  sas_device_priv_data->block =3D 0;  <-- use-after-free

Both functions also read sdev->hostdata and dereference
sas_device_priv_data->sas_target at the top of their second
shost_for_each_device() loops without holding ioc->block_lock, and in the
no_turs branch _scsih_ublock_io_all_device() takes ioc->block_lock and
accesses the cached sas_device_priv_data pointer without re-checking
sdev->hostdata.  Re-fetching sdev->hostdata (and sas_target) under
ioc->block_lock before each access and after the polling loop would avoid
touching freed hostdata.

> @@ -4060,24 +4114,30 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPT=
ER *ioc, u64 sas_address,
>  	u8 tr_timeout =3D 30;
>  	u8 tr_method =3D 0;
>  	int count =3D 0;
> +	unsigned long flags;
> =20
>  	/* moving devices from SDEV_OFFLINE to SDEV_BLOCK */
>  	shost_for_each_device(sdev, ioc->shost) {
> +		spin_lock_irqsave(&ioc->block_lock, flags);
>  		sas_device_priv_data =3D sdev->hostdata;
>  		if (!sas_device_priv_data)
> -			continue;
> +			goto next;
>  		sas_target =3D sas_device_priv_data->sas_target;
>  		if (!sas_target)
> -			continue;
> +			goto next;
>  		if (sas_target->sas_address !=3D sas_address ||
>  		    sas_target->port !=3D port)
> -			continue;
> +			goto next;
> +		/* polling one device can outlast another's deadline */
> +		sas_device_priv_data->block_deadline =3D 0;
>  		if (sdev->sdev_state =3D=3D SDEV_OFFLINE) {
>  			sas_device_priv_data->block =3D 1;
>  			sas_device_priv_data->deleted =3D 0;
>  			scsi_device_set_state(sdev, SDEV_RUNNING);
>  			scsi_internal_device_block_nowait(sdev);
>  		}
> +next:
> +		spin_unlock_irqrestore(&ioc->block_lock, flags);
>  	}
> =20
>  	/* moving devices from SDEV_BLOCK to SDEV_RUNNING state */
> @@ -4091,7 +4151,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER=
 *ioc, u64 sas_address,
>  		if (sas_target->sas_address !=3D sas_address ||
>  		    sas_target->port !=3D port)
>  			continue;
> -		if (!sas_device_priv_data->block)
> +		if (!_scsih_claim_block(ioc, sdev))
>  			continue;
> =20
>  		do {
> @@ -4129,10 +4189,12 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPT=
ER *ioc, u64 sas_address,
>  		    rc =3D=3D DEVICE_STOP_UNIT || rc =3D=3D DEVICE_RETRY_UA)
>  			&& count++ <=3D command_retry_count);
> =20
> +		spin_lock_irqsave(&ioc->block_lock, flags);
>  		sas_device_priv_data->block =3D 0;
>  		if (rc !=3D DEVICE_READY)
>  			sas_device_priv_data->deleted =3D 1;
>  		scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
> +		spin_unlock_irqrestore(&ioc->block_lock, flags);
> =20
>  		if (rc !=3D DEVICE_READY) {
>  			sdev_printk(KERN_WARNING, sdev,

[Severity: Medium]
When rc !=3D DEVICE_READY in _scsih_ublock_io_device_wait() (and in
_scsih_ublock_io_all_device()), can dropping ioc->block_lock before calling
scsi_device_set_state(sdev, SDEV_OFFLINE) race with _scsih_block_io_device(=
)?

CPU0 (firmware_event_thread)      CPU1 (<hardirq>)
_scsih_ublock_io_device_wait()
  spin_lock_irqsave(&ioc->block_lock)
  sas_device_priv_data->block =3D 0;
  scsi_internal_device_unblock_nowait(
    sdev, SDEV_RUNNING)
  spin_unlock_irqrestore(&ioc->block_lock)
                                  _scsih_block_io_device()
                                    spin_lock_irqsave(&ioc->block_lock)
                                    /* sdev_state is SDEV_RUNNING */
                                    _scsih_internal_device_block(sdev, ...)
                                    sas_device_priv_data->block_deadline =
=3D ...;
                                    spin_unlock_irqrestore(&ioc->block_lock)
  ...
  scsi_device_set_state(sdev,
    SDEV_OFFLINE)  <-- overwrites SDEV_BLOCK; queue stays stopped

Because sdev->sdev_state is SDEV_RUNNING while ioc->block_lock is dropped,
_scsih_block_io_device() does not see SDEV_OFFLINE and stops the request
queue, sets block =3D 1, and arms block_deadline.  CPU0 then sets
sdev->sdev_state to SDEV_OFFLINE with the queue still stopped (so
scsi_queue_rq() cannot fail queued I/O with BLK_STS_IOERR) and an active
block_deadline that will later transition the offline device back to
SDEV_RUNNING without a TUR check.  Setting SDEV_OFFLINE before releasing
ioc->block_lock would close this window.

[ ... ]

> @@ -4213,21 +4279,119 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAPTE=
R *ioc)
>  {
>  	struct MPT3SAS_DEVICE *sas_device_priv_data;
>  	struct scsi_device *sdev;
> +	unsigned long flags;
> =20
>  	shost_for_each_device(sdev, ioc->shost) {
> +		spin_lock_irqsave(&ioc->block_lock, flags);
>  		sas_device_priv_data =3D sdev->hostdata;
>  		if (!sas_device_priv_data)
> -			continue;
> -		if (sas_device_priv_data->block)
> -			continue;
> +			goto next;
> +		if (sas_device_priv_data->block) {
> +			/* the caller unblocks it; dnr_unblock_work must not */
> +			sas_device_priv_data->block_deadline =3D 0;
> +			goto next;
> +		}
>  		if (sas_device_priv_data->ignore_delay_remove) {
>  			sdev_printk(KERN_INFO, sdev,
>  			"%s skip device_block for SES handle(0x%04x)\n",
>  			__func__, sas_device_priv_data->sas_target->handle);
> -			continue;
> +			goto next;
>  		}
>  		_scsih_internal_device_block(sdev, sas_device_priv_data);
> +next:
> +		spin_unlock_irqrestore(&ioc->block_lock, flags);
>  	}
> +}

[Severity: Medium]
Can _scsih_block_io_all_device() leave devices blocked with
block_deadline =3D=3D 0 so that neither the caller nor _scsih_dnr_unblock_w=
ork()
unblocks them before device removal?

_scsih_block_io_all_device() blocks every sdev (or clears its
block_deadline) without checking sas_target->deleted, whereas its paired
_scsih_ublock_io_all_device() skips targets with sas_target->deleted set.
In addition, its caller _scsih_sas_broadcast_primitive_event() skips
_scsih_ublock_io_all_device() altogether when host recovery starts:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_sas_broadcast_primitive_event()=
 {
    ...
	ioc->broadcast_aen_busy =3D 0;
	if (!ioc->shost_recovery)
		_scsih_ublock_io_all_device(ioc, 1);
	mutex_unlock(&ioc->tm_cmds.mutex);
}

After host reset, _scsih_remove_unresponding_devices() runs on
firmware_event_thread and removes unresponding devices (taking
sas_host->lock and shost->scan_mutex) before it reaches
_scsih_ublock_io_all_device(ioc, 0).  If a concurrent sysfs scan holds
sas_host->lock and waits on I/O to one of these sdevs whose block_deadline
was cleared to 0, _scsih_dnr_unblock_work() will not unblock it and the scan
deadlock recurs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-sas-abba-v=
3-0-571b854594aa@kernel.org?part=3D2
