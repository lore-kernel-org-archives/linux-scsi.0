Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793795301;
	b=gES7R+eBVu74ZbkEK0Nl2X7JQcqMhWCxqDSLtjWmgdwC1OHC22qg4icEqa9JbdEdNcI8
	 9/IZXngMoLvNBuz7eMcC43EMbYnKksaDd2cLMCk5NGJuSePeareeZVBOexNLHf/bHmgu9
	 FaB8RtGqd651goJGBMne+fG6QLwWLBSWsxmLGV+9+BAYnzMT/2Dx6sRU/Qe+dixv35+bF
	 0CtNcfnfTwif/FpsmEUnxhVqCfnnmer1MrdyKqWEMDfFPIIsRHRL9Cjkx8d19U3qXCNF3
	 T9KYbP2co92Sv6AbHRVfCjtId7ZsItx8HR0l4ffieiRmcEwPJ4piIqglHkzYBcxL6sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793795301;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Iw/0Xoh5HsfPql5VChFCIXoMpllEhng3VSHlbAEMmPg=;
	b=aYhsKIUSORsiqoLayZpi4FEs9kPiNdjDtkrvJZzRtHt1qSs/aAv4o/BlMD+twLqCtG/X
	 VPR6CyIY3j24zcfHH+f/HgATCvDUL9I1683EwIMoeHUj4HjTq/KUG1pHyqnbLutRCBDCk
	 eX2WTz/1sVoRH1ogv4bsO1wfIhd8woM4xIHkEwr4Jc1DcV0+sruiqLtFm+QqWQ4zqC94w
	 GQqQ/TMSjv6yRFN8YvRPLjAU9LBu7fl2puQ4bpUUQXAj0+mY9rDWJEQn7wAvHPN9s/e8J
	 It4rGkaGYmOh6/mYZoYTBCY68jdqH/CsRBX7zCUZxgjSUEr57zyvc9ctTLqRgau3cyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IhmbpCcJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426E5606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IhmbpCcJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91F91F00919;
	Wed,  4 Nov 2026 12:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793795300;
	bh=Iw/0Xoh5HsfPql5VChFCIXoMpllEhng3VSHlbAEMmPg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=IhmbpCcJvAHTmYUnk21Jc1EfGjtnE34+diOy0EjP0yr9B5SFPBL+oJ3uMx1hGDRE/
	 kMrWk2JOiby6yYtNEkTJ3z1f0LJjrPukUZdcBe8+JRFeG4sIobSQzXJrYpburaXDyn
	 PqXILfkKPqyth2a9e83an33tWEkA7gXVDxXWm+6GF++6epCh15DGqBZBq+OZ7NasL9
	 Uy28tFX2sIt071R0YHORsVsF6oiNTDNVZgbFlh6PGuKExv7xviHwDPeGfN5sCFj1Ba
	 BvEmK0bYn07z8tALnXlOl7xBBqiLKdV3WsO91VjTFr7PjUq4bo67UmLbIle0m2t0m/
	 UMLvAJXFfBcZQ==
Message-ID: <sashiko-outbox-197251@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/21] scsi: mpi3mr: Fix target private data use after
 free in BSG passthrough
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261104120103.503871-15-ranjan.kumar@broadcom.com>
References: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
 <20261104120103.503871-15-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 12:28:20 +0000
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
- [High] scsi: mpi3mr: scsi_target UAF in mpi3mr_tgtdev_block_io_dec() for =
SAS targets
- [High] scsi: mpi3mr: leaked block_io in mpi3mr_tgtdev_block_io_dec() on L=
UN removal
--

commit 5bf2d57a06044ae754274ac7045b1778169812fc
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

scsi: mpi3mr: Fix target private data use after free in BSG passthrough

This commit introduces mpi3mr_tgtdev_block_io_inc() and
mpi3mr_tgtdev_block_io_dec() to update block_io on the SCSI target private
data under mrioc->tgtdev_lock while holding a reference to tgtdev across the
BSG command wait, and moves kfree(starget->hostdata) inside mrioc->tgtdev_l=
ock
in mpi3mr_target_destroy().

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 99928fcc5bd79..e7833b24c5097 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -788,6 +788,58 @@ struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
>  	return tgtdev;
>  }
> =20
> +/**
> + * mpi3mr_tgtdev_block_io_inc - Block I/O on the SCSI target of a tgtdev
> + * @mrioc: Adapter instance reference
> + * @tgtdev: Target device reference, held by the caller
> + *
> + * Increment block_io of the SCSI target private data. The lookup and the
> + * increment are done under tgtdev_lock, which mpi3mr_target_destroy hol=
ds
> + * while it frees the private data.
> + *
> + * Return: The private data that was incremented, only to be handed back=
 to
> + * mpi3mr_tgtdev_block_io_dec. NULL if the tgtdev has no SCSI target.
> + */
> +struct mpi3mr_stgt_priv_data *mpi3mr_tgtdev_block_io_inc(struct mpi3mr_i=
oc *mrioc,
> +							 struct mpi3mr_tgt_dev *tgtdev)
> +{
> +	struct mpi3mr_stgt_priv_data *stgt_priv =3D NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	if (tgtdev->starget && tgtdev->starget->hostdata) {
> +		stgt_priv =3D tgtdev->starget->hostdata;
> +		atomic_inc(&stgt_priv->block_io);
> +	}
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +	return stgt_priv;
> +}
> +
> +/**
> + * mpi3mr_tgtdev_block_io_dec - Undo mpi3mr_tgtdev_block_io_inc
> + * @mrioc: Adapter instance reference
> + * @tgtdev: Target device reference, held by the caller
> + * @stgt_priv: Value returned by mpi3mr_tgtdev_block_io_inc
> + *
> + * Decrement block_io only if the SCSI target still has the same private
> + * data. If the target was removed meanwhile the private data is gone
> + * and there is nothing to undo.
> + */
> +void mpi3mr_tgtdev_block_io_dec(struct mpi3mr_ioc *mrioc,
> +				struct mpi3mr_tgt_dev *tgtdev,
> +				struct mpi3mr_stgt_priv_data *stgt_priv)
> +{
> +	unsigned long flags;
> +
> +	if (!stgt_priv)
> +		return;
> +
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	if (tgtdev->starget && tgtdev->starget->hostdata =3D=3D stgt_priv)
> +		atomic_dec_if_positive(&stgt_priv->block_io);
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +}

[Severity: High]
Can mpi3mr_tgtdev_block_io_dec() leak a block_io count and permanently wedge
I/O to the target when the last LUN is removed while a BSG task management
command is in flight?

In mpi3mr_sdev_destroy(), when the last LUN on a target is destroyed,
tgt_dev->starget is cleared even though starget and stgt_priv remain alive:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_sdev_destroy() {
	...
	if (tgt_dev && (!scsi_tgt_priv_data->num_luns))
		tgt_dev->starget =3D NULL;
	...
}

For example, during __scsi_scan_target(), probing LUN 0 can find peripheral
qualifier 1 or 3 and call __scsi_remove_device() on the temporary LUN 0
scsi_device before scanning the remaining LUNs, or the last LUN can be
removed while a concurrent scan holds starget->reap_ref.

If mpi3mr_bsg_process_mpt_cmds() increments stgt_priv->block_io via
mpi3mr_tgtdev_block_io_inc() before mpi3mr_sdev_destroy() sets
tgt_dev->starget =3D NULL, and then completes while tgt_dev->starget is NUL=
L,
mpi3mr_tgtdev_block_io_dec() will see tgtdev->starget =3D=3D NULL and skip
atomic_dec_if_positive(&stgt_priv->block_io) (a regression that remains even
after later commit 23e409e23e8d fixes the separate stgt_priv slab reuse).

When mpi3mr_sdev_init() subsequently initializes another LUN on the same
starget, it reattaches starget without resetting block_io:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_sdev_init() {
	...
	if (tgt_dev) {
		if (tgt_dev->starget =3D=3D NULL)
			tgt_dev->starget =3D starget;
	...
}

Wouldn't that leave stgt_priv->block_io permanently elevated and cause
mpi3mr_qcmd() to reject all subsequent commands with
SCSI_MLQUEUE_DEVICE_BUSY?

[ ... ]

> @@ -4953,10 +5005,9 @@ static void mpi3mr_target_destroy(struct scsi_targ=
et *starget)
>  		mpi3mr_tgtdev_put(tgt_dev);
>  		mpi3mr_tgtdev_put(tgt_dev);
>  	}
> -	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> -
>  	kfree(starget->hostdata);
>  	starget->hostdata =3D NULL;
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
>  }

[Severity: High]
Could mpi3mr_tgtdev_block_io_dec() and mpi3mr_tgtdev_block_io_inc()
dereference a freed struct scsi_target via tgtdev->starget->hostdata for SAS
transport targets?

In mpi3mr_target_alloc(), SAS transport targets (where
mrioc->sas_transport_enabled && !starget->channel) have tgt_dev->starget =3D
starget assigned, but starget->id is assigned by scsi_transport_sas
(rphy->scsi_target_id) rather than tgt_dev->perst_id.

When a SAS device is removed in mpi3mr_remove_device_by_sas_address(), tgtd=
ev
is removed from mrioc->tgtdev_list before mpi3mr_remove_tgtdev_from_host()
runs:

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_remove_device_by_sas_address(=
) {
	...
	if (tgtdev) {
		if (!list_empty(&tgtdev->list)) {
			was_on_tgtdev_list =3D 1;
			if (tgtdev->state =3D=3D MPI3MR_DEV_REMOVE_HS_STARTED) {
				list_del_init(&tgtdev->list);
				mpi3mr_tgtdev_put(tgtdev);
			}
		}
	}
	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
	if (was_on_tgtdev_list) {
		if (tgtdev->host_exposed)
			mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
	...
}

Because tgtdev is no longer on mrioc->tgtdev_list,
__mpi3mr_get_tgtdev_by_addr_and_rphy() in mpi3mr_sdev_destroy() returns NULL
and does not clear tgt_dev->starget (or if target scanning fails before add=
ing
a LUN, mpi3mr_sdev_destroy() never runs).

Then, when scsi_target_destroy() calls mpi3mr_target_destroy(),
tgt_dev->starget is only cleared when tgt_dev->perst_id =3D=3D starget->id:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_target_destroy() {
	...
	tgt_dev =3D __mpi3mr_get_tgtdev_from_tgtpriv(mrioc, scsi_tgt_priv_data);
	if (tgt_dev && (tgt_dev->starget =3D=3D starget) &&
	    (tgt_dev->perst_id =3D=3D starget->id))
		tgt_dev->starget =3D NULL;
	...
}

When tgt_dev->perst_id !=3D starget->id, tgt_dev->starget is left pointing =
to
starget after scsi_target_destroy() drops the final device reference and fr=
ees
starget. While mpi3mr_bsg_process_mpt_cmds() holds its reference to tgtdev
across wait_for_completion_timeout(), won't evaluating
tgtdev->starget->hostdata in mpi3mr_tgtdev_block_io_dec() (or in
mpi3mr_tgtdev_block_io_inc() after a failed target scan) read from the freed
struct scsi_target?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104120103.5038=
71-1-ranjan.kumar@broadcom.com?part=3D14
