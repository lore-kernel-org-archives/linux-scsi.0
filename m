Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793635565;
	b=WGWkYva5r7Oow9pb9/EqXrUdjG8Ypu/CLQ6/MSJ7HIffdGBiTv7sUt9GTVT7P64nMsdV
	 emjdTac4gxGmMays75nUBC1ZiNWrVzHvVx1iVuISEH7vVbF5/Jip150laySVmmudRLTA8
	 mUeLo36YCj/prC9gQxNd/OxSiUnPiTsX+K6oODcgZHxKz6ZKr038PwxPXYURE6791WJGY
	 jXQlFFmgHv4DsOwwVQivGb3RHeMSipdrh5wwVMhk7Wew7b+AOWsdzMBuA1hZR5JtAk8DC
	 /Ig403sCbmPiDCA3VWaXtMoabD6iVmydqriLy5CMXD/43IiteN6xfnFv9b1MXCjMMEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793635565;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=AhOYjlQ+ItTa4HDpy5SR+jgX0zEyLcULf73eX60sC0w=;
	b=WeI++3t7cvOV6xNhOL/F+bEUT2C47AEPbAoiZEg6R5ySVLyTQjJT+THW2ekYXk38Bo5m
	 KtPGGAhwncBBka+Sot3v/bqnvlAntzQ9+eqHCJ236jRIzVnLWLemUKyReRK5V8GKMDQST
	 RjfeBGApAOmiXOsIk1bS7qbnIbhPpQ+lOm6GJYo85u4BmUCvu970MHu3+I7qPY5OkuaAB
	 Za3A2k+xPMFV6SdGfuVTsBL4NTAUrYPJEXzpcmv/nYloIHQ4cQEyh0/GtJqxDiry1cdG0
	 oa0wACvkxmhLF4aQJ/GXN+oyQoNSeLHCx9HBKaNoXlPgfwHjB3Qf0NzdhSzDF0oao3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M4KMorIJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4B0607BDFE;
	Mon,  2 Nov 2026 16:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M4KMorIJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CA21F00A16;
	Mon,  2 Nov 2026 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793635564;
	bh=AhOYjlQ+ItTa4HDpy5SR+jgX0zEyLcULf73eX60sC0w=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=M4KMorIJicKck+e45rtKiXdoUUXA9DhYUiRDjrrxOKjJasgGjz4SpNVL+5NmUvb31
	 IBGv6etqEAwFXTLcp+yCOFjTOq2+yFxG7P4FYxzdeXpGHXNBkUgw0zABMoSxTFuD4J
	 RpwIlSC/XKmtDiZNAmM71RFI1PBhGMHyhka9ETr+uMiHrwocq8JiH3xARfglhb/olz
	 zrcnmUh6gCXYLD83JIB7XDurCnRoI62wG13Zy1quecd2Z3T363/fSHmnsojfxO1PVp
	 Rad9gIv2uVnQ1peZn3jWHDrBKAJ+/9FaQQ1gGZIUUzqrvVyDObcI6aQSq/r6VscJFJ
	 sluHc5FI0D3kg==
Message-ID: <d3d18271b618b0958c7bbacc659a956a0e178d98.camel@kernel.org>
Subject: Re: [PATCH v2 2/2] scsi: mpt3sas: Time out delayed not-responding
 device blocks
From: Jeff Layton <jlayton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Date: Mon, 02 Nov 2026 11:05:53 -0500
In-Reply-To: <sashiko-outbox-193523@kernel.org>
References: <20261102-sas-abba-v2-0-b3b9ba874b5a@kernel.org>
	 <20261102-sas-abba-v2-2-b3b9ba874b5a@kernel.org>
	 <sashiko-outbox-193523@kernel.org>
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

On Mon, 2026-11-02 at 14:06 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
> - [High] scsi: mpt3sas: race between _scsih_dnr_unblock_work() and unlock=
ed unblock paths
> - [High] scsi: mpt3sas: _scsih_clear_block_deadline() races and misses bl=
ocked sdevs
> - [Medium] scsi: mpt3sas: _scsih_dnr_unblock_work() unblocks devices duri=
ng host recovery
> --
>=20
> commit 3086ca833022a9345fb0fd3cc229d91c87b61323
> Author: Jeff Layton <jlayton@kernel.org>
>=20
> scsi: mpt3sas: Time out delayed not-responding device blocks
>=20
> This commit adds a delayed work item to time out and release device block=
s
> triggered by DELAY_NOT_RESPONDING events if the device missing delay expi=
res
> without a subsequent firmware event unblocking the device. This avoids a
> deadlock where a sysfs SCSI scan holds sas_host->lock while waiting on a
> blocked sdev and prevents the firmware event worker from acquiring
> sas_host->lock.
>=20
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sa=
s/mpt3sas_scsih.c
> > index c7886a12d3088..af2666f9576e5 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>=20
> [ ... ]
>=20
> > @@ -3934,6 +3936,26 @@ _scsih_internal_device_unblock(struct scsi_devic=
e *sdev,
> >  	}
> >  }
> > =20
> > +/**
> > + * _scsih_clear_block_deadline - keep dnr_unblock_work off a blocked s=
dev
> > + * @ioc: per adapter object
> > + * @sas_device_priv_data: per device driver private data
> > + *
> > + * Called by the firmware event worker before it polls a blocked devic=
e
> > + * with TURs.  The worker unblocks the device when polling ends, and
> > + * must not have dnr_unblock_work send I/O to it in the meantime.
> > + */
> > +static void
> > +_scsih_clear_block_deadline(struct MPT3SAS_ADAPTER *ioc,
> > +			    struct MPT3SAS_DEVICE *sas_device_priv_data)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&ioc->block_lock, flags);
> > +	sas_device_priv_data->block_deadline =3D 0;
> > +	spin_unlock_irqrestore(&ioc->block_lock, flags);
> > +}
> > +
> >  /**
> >   * _scsih_ublock_io_all_device - unblock every device
> >   * @ioc: per adapter object
> > @@ -3974,6 +3996,7 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTE=
R *ioc, u8 no_turs)
> >  			continue;
> >  		}
> > =20
> > +		_scsih_clear_block_deadline(ioc, sas_device_priv_data);
> >  		do {
> >  			pcie_device =3D mpt3sas_get_pdev_by_handle(ioc, sas_target->handle)=
;
> >  			if (pcie_device && (!ioc->tm_custom_handling) &&
> > @@ -4089,6 +4112,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPT=
ER *ioc, u64 sas_address,
> >  		if (!sas_device_priv_data->block)
> >  			continue;
> > =20
> > +		_scsih_clear_block_deadline(ioc, sas_device_priv_data);
>=20
> [Severity: High]
> As reported by Sashiko on v1 [1], can _scsih_dnr_unblock_work() still rac=
e
> with the firmware event worker or unblock remaining sdevs while the worke=
r is
> polling devices?
>=20

True. We can fix this by taking the block_lock in more places. I'm
working on a v3. I also have a fix for 1/2 for the problem sashiko
spotted there.

> First, in both _scsih_ublock_io_all_device() and
> _scsih_ublock_io_device_wait(), sdev->hostdata and
> sas_device_priv_data->block are checked without holding ioc->block_lock
> before passing sas_device_priv_data to _scsih_clear_block_deadline(). If
> __scsi_remove_device() -> scsih_sdev_destroy() runs concurrently, it clea=
rs
> sdev->hostdata under ioc->block_lock and frees sas_device_priv_data befor=
e
> _scsih_clear_block_deadline() takes ioc->block_lock and writes to
> sas_device_priv_data->block_deadline. Even if the sdev is not being remov=
ed,
> _scsih_dnr_unblock_sdev() can run between the unlocked
> sas_device_priv_data->block check and _scsih_clear_block_deadline(), leav=
ing
> the worker to poll an already-unblocked running sdev with TURs.
>=20
> Second, _scsih_clear_block_deadline() is called inside the
> shost_for_each_device() loop for one sdev at a time right before
> _scsih_wait_for_device_to_become_ready(), which sleeps across up to
> command_retry_count retries. While the worker sleeps polling the first
> blocked sdev (such as LUN 0 of a multi-LUN target in
> _scsih_ublock_io_device_wait(), or the first blocked device in
> _scsih_ublock_io_all_device()), block_deadline remains active on all subs=
eqent
> blocked sdevs. If their deadline expires during that sleep,
> _scsih_dnr_unblock_work() will unblock those sdevs prematurely and cause =
the
> polling loop to skip them when it later checks sas_device_priv_data->bloc=
k.
>=20
> Third, when _scsih_sas_broadcast_primitive_event() calls
> _scsih_block_io_all_device() to keep all devices blocked during broadcast
> primitive task management, any sdev already blocked by an earlier
> DELAY_NOT_RESPONDING event is skipped without clearing block_deadline:
>=20
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_block_io_all_device()
> 	shost_for_each_device(sdev, ioc->shost) {
> 		sas_device_priv_data =3D sdev->hostdata;
> 		if (!sas_device_priv_data)
> 			continue;
> 		if (sas_device_priv_data->block)
> 			continue;
>=20
> If that earlier deadline expires while _scsih_sas_broadcast_primitive_eve=
nt()
> is still running, wouldn't _scsih_dnr_unblock_work() unblock the device i=
n
> the middle of task management?
>=20
> >  		do {
> >  			host_reset_completion_count =3D 0;
> >  			pcie_device =3D mpt3sas_get_pdev_by_handle(ioc, sas_target->handle)=
;
> > @@ -4225,6 +4249,92 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAPTE=
R *ioc)
> >  	}
> >  }
> > =20
> > +/*
> > + * Margin on top of the firmware's report device missing delay before
> > + * _scsih_dnr_unblock_work() releases a delayed not-responding block.
> > + */
> > +#define MPT3SAS_DNR_BLOCK_SLACK	30
> > +
> > +static unsigned long
> > +_scsih_dnr_block_timeout(struct MPT3SAS_ADAPTER *ioc)
> > +{
> > +	return (max(ioc->device_missing_delay, ioc->pcie_device_missing_delay=
) +
> > +	    MPT3SAS_DNR_BLOCK_SLACK) * HZ;
> > +}
> > +
> > +/**
> > + * _scsih_dnr_unblock_sdev - release an expired delayed not-responding=
 block
> > + * @ioc: per adapter object
> > + * @sdev: scsi device struct
> > + *
> > + * Return: the deadline of an unexpired block on @sdev, or 0 if none.
> > + */
> > +static unsigned long
> > +_scsih_dnr_unblock_sdev(struct MPT3SAS_ADAPTER *ioc, struct scsi_devic=
e *sdev)
> > +{
> > +	struct MPT3SAS_DEVICE *sas_device_priv_data;
> > +	unsigned long flags, deadline =3D 0;
> > +
> > +	spin_lock_irqsave(&ioc->block_lock, flags);
> > +	sas_device_priv_data =3D sdev->hostdata;
> > +	if (!sas_device_priv_data || !sas_device_priv_data->block ||
> > +	    !sas_device_priv_data->block_deadline)
> > +		goto out;
> > +	if (time_before(jiffies, sas_device_priv_data->block_deadline)) {
> > +		deadline =3D sas_device_priv_data->block_deadline;
> > +		goto out;
> > +	}
> > +	sdev_printk(KERN_WARNING, sdev,
> > +	    "delayed not-responding block expired, handle(0x%04x)\n",
> > +	    sas_device_priv_data->sas_target->handle);
> > +	_scsih_internal_device_unblock(sdev, sas_device_priv_data);
> > +out:
> > +	spin_unlock_irqrestore(&ioc->block_lock, flags);
> > +	return deadline;
> > +}
>=20
> [Severity: High]
> Does _scsih_dnr_unblock_sdev() race with the other unblock paths that do =
not
> acquire ioc->block_lock?
>=20
> While _scsih_dnr_unblock_sdev() runs on system_dfl_wq under ioc->block_lo=
ck,
> _scsih_ublock_io_device() (called from interrupt context in
> mpt3sas_scsih_event_callback() -> _scsih_tm_tr_send() on
> MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING and from worker context in
> _scsih_check_device() and _scsih_remove_device()),
> _scsih_ublock_io_all_device(), and _scsih_ublock_io_device_wait() inspect=
 and
> clear sas_device_priv_data->block and call _scsih_internal_device_unblock=
()
> or scsi_internal_device_unblock_nowait() without holding ioc->block_lock:
>=20
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_ublock_io_device()
> 	shost_for_each_device(sdev, ioc->shost) {
> 		...
> 		if (sas_device_priv_data->block)
> 			_scsih_internal_device_unblock(sdev,
> 				sas_device_priv_data);
> 	}
>=20
> If _scsih_dnr_unblock_sdev() and _scsih_ublock_io_device() (or
> _scsih_ublock_io_all_device()) both see sas_device_priv_data->block =3D=
=3D 1 and
> call _scsih_internal_device_unblock() concurrently, the first call transi=
tions
> sdev->sdev_state from SDEV_BLOCK to SDEV_RUNNING (or from SDEV_CREATED_BL=
OCK
> to SDEV_CREATED). The second caller's scsi_internal_device_unblock_nowait=
()
> then returns -EINVAL and enters the fallback path in
> _scsih_internal_device_unblock():
>=20
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_internal_device_unblock()
> 	r =3D scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
> 	if (r =3D=3D -EINVAL) {
> 		...
> 		sas_device_priv_data->block =3D 1;
> 		r =3D scsi_internal_device_block_nowait(sdev);
> 		...
> 		sas_device_priv_data->block =3D 0;
> 		r =3D scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
> 	}
>=20
> That re-blocks the already-unblocked sdev, and if the sdev was in
> SDEV_CREATED during a scan, scsi_internal_device_block_nowait() puts it b=
ack
> into SDEV_CREATED_BLOCK where the subsequent unblock transitions it only =
to
> SDEV_CREATED, racing with scsi_sysfs_add_sdev().
>=20
> In addition, when _scsih_ublock_io_device(), _scsih_ublock_io_all_device(=
), or
> _scsih_ublock_io_device_wait() clears sas_device_priv_data->block =3D 0 w=
ithout
> holding ioc->block_lock before calling scsi_internal_device_unblock_nowai=
t(),
> a concurrent DELAY_NOT_RESPONDING interrupt in _scsih_block_io_device() c=
an
> take ioc->block_lock, observe block =3D=3D 0, set block =3D 1 and block_d=
eadline,
> and call scsi_internal_device_block_nowait(). The unblocking thread then =
runs
> scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING), leaving sdev in
> SDEV_RUNNING with its request queue started while sas_device_priv_data->b=
lock
> is still 1 (causing scsih_qcmd() to return SCSI_MLQUEUE_DEVICE_BUSY for a=
ll
> commands).
>=20
> Should all unblock paths synchronize using ioc->block_lock?
>=20


These are preexisting bugs, and the timeout should help mitigate them.
Putting everything under the block_lock properly is a larger rework
that I'd rather not take on at the moment.


> > +
> > +/**
> > + * _scsih_dnr_unblock_work - release expired delayed not-responding bl=
ocks
> > + * @work: the dnr_unblock_work of the adapter
> > + *
> > + * Within the device missing delay, the firmware either reports the de=
vice
> > + * as not responding, and the event callback unblocks it, or the devic=
e
> > + * comes back, and only the firmware event worker unblocks it.  The wo=
rker
> > + * may first need shost->scan_mutex or the SAS transport's host lock, =
and
> > + * a scan holding those can have a command queued on the blocked sdev.
> > + * Past the delay the block has no further use, so release it here.
> > + */
> > +static void
> > +_scsih_dnr_unblock_work(struct work_struct *work)
> > +{
> > +	struct MPT3SAS_ADAPTER *ioc =3D container_of(to_delayed_work(work),
> > +	    struct MPT3SAS_ADAPTER, dnr_unblock_work);
> > +	struct scsi_device *sdev;
> > +	unsigned long deadline, next =3D 0;
> > +
> > +	if (ioc->remove_host)
> > +		return;
> > +	if (ioc->shost_recovery || ioc->pci_error_recovery) {
> > +		queue_delayed_work(system_dfl_wq, &ioc->dnr_unblock_work, HZ);
> > +		return;
> > +	}
>=20
> [Severity: Medium]
> Should _scsih_dnr_unblock_work() also check scsi_host_in_recovery(ioc->sh=
ost)
> and avoid unblocking targets marked sas_target->deleted, and use
> mod_delayed_work() here?
>=20
> When a host reset finishes in mpt3sas_base_hard_reset_handler(),
> mpt3sas_scsih_reset_done_handler() marks unresponding targets with
> sas_target->deleted =3D 1 and queues MPT3SAS_REMOVE_UNRESPONDING_DEVICES,=
 and
> ioc->shost_recovery is cleared to 0 while scsi_host_in_recovery(ioc->shos=
t)
> can remain true until SCSI EH finishes. During SHOST_RECOVERY, scsih_qcmd=
()
> relies on sas_device_priv_data->block remaining set so TEST_UNIT_READY
> commands complete immediately with UNIT_ATTENTION / I_T_NEXUS_LOSS_OCCURR=
ED,
> which is why _mpt3sas_fw_work() waits for both scsi_host_in_recovery() an=
d
> ioc->shost_recovery before running _scsih_remove_unresponding_devices():
>=20
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:_mpt3sas_fw_work()
> 	case MPT3SAS_REMOVE_UNRESPONDING_DEVICES:
> 		while (scsi_host_in_recovery(ioc->shost) ||
> 					 ioc->shost_recovery) {
> 			if (ioc->remove_host || ioc->fw_events_cleanup)
> 				goto out;
> 			ssleep(1);
> 		}
> 		_scsih_remove_unresponding_devices(ioc);
>=20
> Because _scsih_dnr_unblock_work() only checks ioc->shost_recovery and
> _scsih_dnr_unblock_sdev() does not check sas_target->deleted (unlike
> _scsih_ublock_io_all_device()), a block deadline expiring after
> ioc->shost_recovery clears can unblock pre-reset or deleted devices while
> SHOST_RECOVERY or post-reset device removal is still pending.
>=20
> Also, if _scsih_block_io_device() queues dnr_unblock_work with a full tim=
eout
> at the same time _scsih_dnr_unblock_work() enters the recovery deferral
> branch, queue_delayed_work(..., HZ) will be a no-op because the work item=
 is
> already pending, pushing the 1-second retry out to the full timeout unles=
s
> mod_delayed_work() is used.
>=20
> [1] https://lore.kernel.org/r/20261030-sas-abba-v1-1-b8cdd714a37c@kernel.=
org

I've added a scsi_host_in_recovery() to the deferral condition for v3,
and fixed up the mod_delayed_work() issue.

I declined to skip sas_target->deleted entries, as it could cause us to
hit the deadlock that this series fixes again. Unblocking a deleted
target is harmless anyway, so it's best to avoid doing that, I think.
--=20
Jeff Layton <jlayton@kernel.org>
