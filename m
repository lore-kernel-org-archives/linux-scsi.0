Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794235572;
	b=3HVsa5p5gkfYKizNEjigFJn0AxrtjK4OBlXNjO6+gW1CyslunSX+bF/+QsC1G9e67yh1
	 X/5H6lqqIMUeHwlLToNSuP44iQ7fectVAbW7EjRsDdTNkXG7CVzoFDfdKUJmDkXChiKDd
	 wv8GAtECkAQPzRRsmcVBRFydYI9kXIWFfrm2lYm4towBQ1ZtbhrUzrBvhTF2cTXmbE0CZ
	 el6kAA3+NP07X9bh/ZLigS4Oz2YcL4vYQWLWi+nnbP8ZuhUtf1g+ZPluNgBA2mPeO89ht
	 PfzaDEJV7ASkNnsrHgnBVV+Y7iARTh77AKjn4GnGIUa0K9uC0IjBcX6fh70jnyAcWqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794235572;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=U38oIzy9ynukowewNbbmFO6Q973bbaus1qUM3U7jCMc=;
	b=C5LUaflUh4OfOnUHeoNn+V9mxjrm6LbYwNd+c1Mbd6T0jq6W6TUEnbF/y7QDWfuaBfv9
	 4JB29ML/bv/hzPBi4yM6pzUReL2fi62G+OQeRye8oVfp3w3Tz+0ZItt09Aeue85eQXW0I
	 62KgKFj/PyCpHvkcE0F+J5lgTukkF+KDt24GjqXzdpwLLRY0ZBKzQoyLkatrbY5geTfiT
	 m1xWq8fB7xSmFWCtjNmxG4CYUzbHKaQu2Wrzhvj5dF+udEeeP8ex2l3zwass11b94ORKK
	 fDR11HNa8kaKo1tdjIjmSHHwTcRExDVRqF4PH1JZL7wZP9smdeLxj17MTXb2H1PANCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E5B4FYqU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73775606A31C;
	Mon,  9 Nov 2026 14:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E5B4FYqU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8EA1F0089F;
	Mon,  9 Nov 2026 14:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794235572;
	bh=U38oIzy9ynukowewNbbmFO6Q973bbaus1qUM3U7jCMc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=E5B4FYqUVHY7YQk9y4esnIpxkVbSGGOpieAt8gmeiIUW8a1fQzRwwbWw1b1w2Mc3Z
	 Oil32O3MrICQ+QJWVG1+Drdar8/P/XS+VZBLnZTbecR/VeMzFf96GGh5MDz2osIHTO
	 yiqjj49XutUelhwhuaNKYydOR+fs+glaJ9vbaYWqZlWTRb8wYMql1wWhUu08qZU2Ba
	 TrJdhfzQPkryw3UoDRi5JkkeANo4+yLnNIsy2/T+OxTJ2oaZbloJu3TuLJRLfwff3n
	 q3f1AoLDz226B5be5mc/I4eQXZMewXbookq3qSPCptWKmkSAC4D1/FKrVBJZ7iZrRj
	 uNMXH0tliCrsw==
Message-ID: <eb243163db8e99c0c2db72eceb5d1fd9990e7d7d.camel@kernel.org>
Subject: Re: [PATCH v3 2/2] scsi: mpt3sas: Time out delayed not-responding
 device blocks
From: Jeff Layton <jlayton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Date: Mon, 09 Nov 2026 09:46:08 -0500
In-Reply-To: <sashiko-outbox-202261@kernel.org>
References: <20261106-sas-abba-v3-0-571b854594aa@kernel.org>
	 <20261106-sas-abba-v3-2-571b854594aa@kernel.org>
	 <sashiko-outbox-202261@kernel.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Fri, 2026-11-06 at 20:57 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [High] scsi: mpt3sas: use-after-free of sdev->hostdata in unblock
>   helpers
> - [Medium] scsi: mpt3sas: race setting SDEV_OFFLINE outside block_lock
>   on unblock failure
> - [Medium] scsi: mpt3sas: _scsih_block_io_all_device() leaves sdevs
>   blocked without deadline
> --
>=20
> commit ba9687a8025a542963a3bc4d91c8e8b094a21e74
> Author: Jeff Layton <jlayton@kernel.org>
>=20
> scsi: mpt3sas: Time out delayed not-responding device blocks
>=20
> This commit adds a delayed work item and per-device deadline to release
> delayed not-responding sdev blocks after the firmware's device missing
> delay plus 30 seconds, preventing scans from deadlocking on sas_host->loc=
k.
>=20
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sa=
s/mpt3sas_scsih.c
> > index 60c9cf679a8a7..acdeece20140f 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>=20
> [ ... ]
>=20
> > @@ -3958,7 +3989,20 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPT=
ER *ioc, u8 no_turs)
> >  	int count =3D 0;
> >  	u8 tr_method =3D 0;
> >  	u8 tr_timeout =3D 30;
> > +	unsigned long flags;
> > =20
> > +	/* polling one device can outlast another's deadline */
> > +	if (!no_turs && issue_scsi_cmd_to_bringup_drive) {
> > +		shost_for_each_device(sdev, ioc->shost) {
> > +			spin_lock_irqsave(&ioc->block_lock, flags);
> > +			sas_device_priv_data =3D sdev->hostdata;
> > +			if (sas_device_priv_data &&
> > +			    sas_device_priv_data->sas_target &&
> > +			    !sas_device_priv_data->sas_target->deleted)
> > +				sas_device_priv_data->block_deadline =3D 0;
> > +			spin_unlock_irqrestore(&ioc->block_lock, flags);
> > +		}
> > +	}
> > =20
> >  	shost_for_each_device(sdev, ioc->shost) {
> >  		sas_device_priv_data =3D sdev->hostdata;
> > @@ -3975,10 +4019,18 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAP=
TER *ioc, u8 no_turs)
> >  		if ((no_turs) || (!issue_scsi_cmd_to_bringup_drive)) {
> >  			sdev_printk(KERN_WARNING, sdev, "device_unblocked handle(0x%04x)\n"=
,
> >  				sas_device_priv_data->sas_target->handle);
> > -			_scsih_internal_device_unblock(sdev, sas_device_priv_data);
> > +			spin_lock_irqsave(&ioc->block_lock, flags);
> > +			/* dnr_unblock_work may have released it */
> > +			if (sas_device_priv_data->block)
> > +				_scsih_internal_device_unblock(sdev,
> > +				    sas_device_priv_data);
> > +			spin_unlock_irqrestore(&ioc->block_lock, flags);
> >  			continue;
> >  		}
> > =20
> > +		/* may have been blocked since the first pass */
> > +		if (!_scsih_claim_block(ioc, sdev))
> > +			continue;
> >  		do {
> >  			pcie_device =3D mpt3sas_get_pdev_by_handle(ioc, sas_target->handle)=
;
> >  			if (pcie_device && (!ioc->tm_custom_handling) &&
> > @@ -3997,11 +4049,13 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAP=
TER *ioc, u8 no_turs)
> >  		} while ((rc =3D=3D DEVICE_RETRY || rc =3D=3D DEVICE_START_UNIT ||
> >  		    rc =3D=3D DEVICE_STOP_UNIT || rc =3D=3D DEVICE_RETRY_UA)
> >  			&& count++ < command_retry_count);
> > +		spin_lock_irqsave(&ioc->block_lock, flags);
> >  		sas_device_priv_data->block =3D 0;
> >  		if (rc !=3D DEVICE_READY)
> >  			sas_device_priv_data->deleted =3D 1;
> > =20
> >  		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
> > +		spin_unlock_irqrestore(&ioc->block_lock, flags);
> > =20
> >  		if (rc !=3D DEVICE_READY) {
> >  			sdev_printk(KERN_WARNING, sdev, "%s: device_offlined,\n"
>=20
> [Severity: High]
> Can _scsih_ublock_io_all_device() and _scsih_ublock_io_device_wait() caus=
e a
> use-after-free on sas_device_priv_data and sas_target?
>=20
> shost_for_each_device() only holds a reference on sdev, not sdev->hostdat=
a.
> When _scsih_dnr_unblock_work() unblocks an sdev that was blocked during a
> concurrent sysfs scan and its probe fails in scsi_probe_and_add_lun(), or
> when a device is removed via sysfs, __scsi_remove_device() calls
> scsih_sdev_destroy(), which clears sdev->hostdata under ioc->block_lock a=
nd
> frees sas_device_priv_data:
>=20
> CPU0 (firmware_event_thread)      CPU1 (scan / device removal)
> _scsih_ublock_io_all_device()
>   sas_device_priv_data =3D
>     sdev->hostdata;
>   _scsih_claim_block(ioc, sdev)
>   _scsih_wait_for_device_...()
>                                   __scsi_remove_device(sdev)
>                                     scsih_sdev_destroy(sdev)
>                                       spin_lock_irqsave(&ioc->block_lock)
>                                       sdev->hostdata =3D NULL;
>                                       spin_unlock_irqrestore(&ioc->block_=
lock)
>                                       kfree(sas_device_priv_data);
>   spin_lock_irqsave(&ioc->block_lock)
>   sas_device_priv_data->block =3D 0;  <-- use-after-free
>=20
> Both functions also read sdev->hostdata and dereference
> sas_device_priv_data->sas_target at the top of their second
> shost_for_each_device() loops without holding ioc->block_lock, and in the
> no_turs branch _scsih_ublock_io_all_device() takes ioc->block_lock and
> accesses the cached sas_device_priv_data pointer without re-checking
> sdev->hostdata.  Re-fetching sdev->hostdata (and sas_target) under
> ioc->block_lock before each access and after the polling loop would avoid
> touching freed hostdata.
>=20

Real issue. Still, worth fixing while we're in here.

> > @@ -4060,24 +4114,30 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADA=
PTER *ioc, u64 sas_address,
> >  	u8 tr_timeout =3D 30;
> >  	u8 tr_method =3D 0;
> >  	int count =3D 0;
> > +	unsigned long flags;
> > =20
> >  	/* moving devices from SDEV_OFFLINE to SDEV_BLOCK */
> >  	shost_for_each_device(sdev, ioc->shost) {
> > +		spin_lock_irqsave(&ioc->block_lock, flags);
> >  		sas_device_priv_data =3D sdev->hostdata;
> >  		if (!sas_device_priv_data)
> > -			continue;
> > +			goto next;
> >  		sas_target =3D sas_device_priv_data->sas_target;
> >  		if (!sas_target)
> > -			continue;
> > +			goto next;
> >  		if (sas_target->sas_address !=3D sas_address ||
> >  		    sas_target->port !=3D port)
> > -			continue;
> > +			goto next;
> > +		/* polling one device can outlast another's deadline */
> > +		sas_device_priv_data->block_deadline =3D 0;
> >  		if (sdev->sdev_state =3D=3D SDEV_OFFLINE) {
> >  			sas_device_priv_data->block =3D 1;
> >  			sas_device_priv_data->deleted =3D 0;
> >  			scsi_device_set_state(sdev, SDEV_RUNNING);
> >  			scsi_internal_device_block_nowait(sdev);
> >  		}
> > +next:
> > +		spin_unlock_irqrestore(&ioc->block_lock, flags);
> >  	}
> > =20
> >  	/* moving devices from SDEV_BLOCK to SDEV_RUNNING state */
> > @@ -4091,7 +4151,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPT=
ER *ioc, u64 sas_address,
> >  		if (sas_target->sas_address !=3D sas_address ||
> >  		    sas_target->port !=3D port)
> >  			continue;
> > -		if (!sas_device_priv_data->block)
> > +		if (!_scsih_claim_block(ioc, sdev))
> >  			continue;
> > =20
> >  		do {
> > @@ -4129,10 +4189,12 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADA=
PTER *ioc, u64 sas_address,
> >  		    rc =3D=3D DEVICE_STOP_UNIT || rc =3D=3D DEVICE_RETRY_UA)
> >  			&& count++ <=3D command_retry_count);
> > =20
> > +		spin_lock_irqsave(&ioc->block_lock, flags);
> >  		sas_device_priv_data->block =3D 0;
> >  		if (rc !=3D DEVICE_READY)
> >  			sas_device_priv_data->deleted =3D 1;
> >  		scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
> > +		spin_unlock_irqrestore(&ioc->block_lock, flags);
> > =20
> >  		if (rc !=3D DEVICE_READY) {
> >  			sdev_printk(KERN_WARNING, sdev,
>=20
> [Severity: Medium]
> When rc !=3D DEVICE_READY in _scsih_ublock_io_device_wait() (and in
> _scsih_ublock_io_all_device()), can dropping ioc->block_lock before calli=
ng
> scsi_device_set_state(sdev, SDEV_OFFLINE) race with _scsih_block_io_devic=
e()?
>=20
> CPU0 (firmware_event_thread)      CPU1 (<hardirq>)
> _scsih_ublock_io_device_wait()
>   spin_lock_irqsave(&ioc->block_lock)
>   sas_device_priv_data->block =3D 0;
>   scsi_internal_device_unblock_nowait(
>     sdev, SDEV_RUNNING)
>   spin_unlock_irqrestore(&ioc->block_lock)
>                                   _scsih_block_io_device()
>                                     spin_lock_irqsave(&ioc->block_lock)
>                                     /* sdev_state is SDEV_RUNNING */
>                                     _scsih_internal_device_block(sdev, ..=
.)
>                                     sas_device_priv_data->block_deadline =
=3D ...;
>                                     spin_unlock_irqrestore(&ioc->block_lo=
ck)
>   ...
>   scsi_device_set_state(sdev,
>     SDEV_OFFLINE)  <-- overwrites SDEV_BLOCK; queue stays stopped
>=20
> Because sdev->sdev_state is SDEV_RUNNING while ioc->block_lock is dropped=
,
> _scsih_block_io_device() does not see SDEV_OFFLINE and stops the request
> queue, sets block =3D 1, and arms block_deadline.  CPU0 then sets
> sdev->sdev_state to SDEV_OFFLINE with the queue still stopped (so
> scsi_queue_rq() cannot fail queued I/O with BLK_STS_IOERR) and an active
> block_deadline that will later transition the offline device back to
> SDEV_RUNNING without a TUR check.  Setting SDEV_OFFLINE before releasing
> ioc->block_lock would close this window.
>=20
> [ ... ]
>=20

There's a real race window here, but I think the claimed result is
wrong. Still, this is simple to fix.

> > @@ -4213,21 +4279,119 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAP=
TER *ioc)
> >  {
> >  	struct MPT3SAS_DEVICE *sas_device_priv_data;
> >  	struct scsi_device *sdev;
> > +	unsigned long flags;
> > =20
> >  	shost_for_each_device(sdev, ioc->shost) {
> > +		spin_lock_irqsave(&ioc->block_lock, flags);
> >  		sas_device_priv_data =3D sdev->hostdata;
> >  		if (!sas_device_priv_data)
> > -			continue;
> > -		if (sas_device_priv_data->block)
> > -			continue;
> > +			goto next;
> > +		if (sas_device_priv_data->block) {
> > +			/* the caller unblocks it; dnr_unblock_work must not */
> > +			sas_device_priv_data->block_deadline =3D 0;
> > +			goto next;
> > +		}
> >  		if (sas_device_priv_data->ignore_delay_remove) {
> >  			sdev_printk(KERN_INFO, sdev,
> >  			"%s skip device_block for SES handle(0x%04x)\n",
> >  			__func__, sas_device_priv_data->sas_target->handle);
> > -			continue;
> > +			goto next;
> >  		}
> >  		_scsih_internal_device_block(sdev, sas_device_priv_data);
> > +next:
> > +		spin_unlock_irqrestore(&ioc->block_lock, flags);
> >  	}
> > +}
>=20
> [Severity: Medium]
> Can _scsih_block_io_all_device() leave devices blocked with
> block_deadline =3D=3D 0 so that neither the caller nor _scsih_dnr_unblock=
_work()
> unblocks them before device removal?
>=20
> _scsih_block_io_all_device() blocks every sdev (or clears its
> block_deadline) without checking sas_target->deleted, whereas its paired
> _scsih_ublock_io_all_device() skips targets with sas_target->deleted set.
> In addition, its caller _scsih_sas_broadcast_primitive_event() skips
> _scsih_ublock_io_all_device() altogether when host recovery starts:
>=20
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_sas_broadcast_primitive_event=
() {
>     ...
> 	ioc->broadcast_aen_busy =3D 0;
> 	if (!ioc->shost_recovery)
> 		_scsih_ublock_io_all_device(ioc, 1);
> 	mutex_unlock(&ioc->tm_cmds.mutex);
> }
>=20
> After host reset, _scsih_remove_unresponding_devices() runs on
> firmware_event_thread and removes unresponding devices (taking
> sas_host->lock and shost->scan_mutex) before it reaches
> _scsih_ublock_io_all_device(ioc, 0).  If a concurrent sysfs scan holds
> sas_host->lock and waits on I/O to one of these sdevs whose block_deadlin=
e
> was cleared to 0, _scsih_dnr_unblock_work() will not unblock it and the s=
can
> deadlock recurs.

Real issue, but this predates the set AFAICT. Still it's also worth
fixing.

There's also another issue here, I think where repeated DNRs can extend
the block indefinitely and still cause a hang. We should just bound the
timeout instead.

I'll send a v4.
--=20
Jeff Layton <jlayton@kernel.org>
