Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793795317;
	b=o1U+74g4GXYOmJvphJwtMUHtZ/mIP2Y09d3RCZLv9AxvZJ3tmGSusmC15n+2irnoPQ5e
	 8C2RjO5WOcyvwCeJO/XgUglzaNZeMhlvFhQDZbwZIWHIpwc1MKklc+H0OdbJgLhWLBAAO
	 c118ssb1exhDlrvLT0ytd/VsyaeiOGqswmgOLvJbVMkRq5fAlkstn6O3ElnJjcdq2iqNl
	 a05F34BUU8zwkHMgdjxA/dKbQ2mzbj+IGzux0R8mRxVmbuY+AHJw/Xn0+9UsjKmxbSkjd
	 mCs+ujAwqISAq5IAshqIolYicSsXz8vPHm/jGlfmvFfPmP0vlgoYTTXyIqMdpZgSdSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793795317;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5v4DTozgqP3R32Jw/5tSc+0RVUjrJFY2m6diOtnoGbE=;
	b=GxFYt62MaetQfBAVN0mfLOocYkKZvFZtGYRNE9GNRWl7g0qDtolkdRULXLIluhJLhQNx
	 J19igJxAmEtXcDpPlz4PhK9KfbysFLwtEsk1JRZqT1il0yMChFKY7drm79GlL/WJLGf7h
	 yBjSvlF6PqVyzwqKBWmhsBFN7mMVW5yMSIJwC2pMDA/1MFNDW1E3TR51YBqo1zBveXaF/
	 FjDzRbp5/oWlypaN73mC8IcBbLp7KPPKoy/BiS026MH1FtRBlboqhJFZzA4vAAbBXQGmn
	 HqKCRRqoGqVw4JVwleQCLrtrAgYJ0tukfxgllhXssJl8cvzMwp5nSfkCdYQtxuUOiig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DL4pKpX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96D2606A328
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DL4pKpX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575341F0093A;
	Wed,  4 Nov 2026 12:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793795316;
	bh=5v4DTozgqP3R32Jw/5tSc+0RVUjrJFY2m6diOtnoGbE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=DL4pKpX56XGj++CXLvDsQf2dAxvACks47w2czgTMH/PfHMW8pMDC+ZRVlke4EFNei
	 SI8ehXLds3relrXBHn03IlAkSjv8e7mZEaEno02+wE8av6z5QIimHIOrt9ya+6q+33
	 kY7r+8lgKFkVhUHSTI34x8WXdqJuH2psyR7JMt1F0IToLQ0h2x1gn0YbK8mB8BNai4
	 wWmYcOlJUBRFaK+sgWbdWFlz7b4BT5DtwNG+9HAHZFubXxM5yP4oinpeb2aaet6rX9
	 daWl63Y2Ha1oPHKJr8TxbhfgbP6NX2AifO0F2NFfaQ9k3AM4+ZBtNZHCUZKNsC/mlb
	 3k8NH01NtBNEA==
Message-ID: <sashiko-outbox-197252@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 15/21] scsi: mpi3mr: Fix block_io accounting when a
 target is re-created during BSG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261104120103.503871-16-ranjan.kumar@broadcom.com>
References: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
 <20261104120103.503871-16-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 12:28:35 +0000
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
- [Medium] scsi: mpi3mr: leaked block_io count in mpi3mr_tgtdev_block_io_de=
c()
- [Low] scsi: mpi3mr: undocumented seq member in struct mpi3mr_stgt_priv_da=
ta
--

commit 23e409e23e8d123d95d4c65a026b00b68a047101
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

scsi: mpi3mr: Fix block_io accounting when a target is re-created during BSG

This commit introduces a 64-bit sequence number on struct
mpi3mr_stgt_priv_data so that mpi3mr_tgtdev_block_io_dec() only decrements
block_io if the target private data matches the instance that was
incremented by mpi3mr_tgtdev_block_io_inc() when the BSG task management
command started.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index da47100d895e7..8738fc2ce7e77 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -847,6 +847,7 @@ struct mpi3mr_stgt_priv_data {
>  	u16 perst_id;
>  	u32 num_luns;
>  	atomic_t block_io;
> +	u64 seq;

[Severity: Low]
This isn't a bug, but struct mpi3mr_stgt_priv_data has a kernel-doc comment
block describing all of its members. Should a @seq entry be added there as
well so W=3D1 builds and scripts/kernel-doc do not warn about an undocument=
ed
struct member?

[ ... ]

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index e7833b24c5097..67d41e4a0a0ab 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -788,6 +788,8 @@ struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
>  	return tgtdev;
>  }
> =20
> +static atomic64_t mpi3mr_stgt_seq =3D ATOMIC64_INIT(0);
> +
>  /**
>   * mpi3mr_tgtdev_block_io_inc - Block I/O on the SCSI target of a tgtdev
>   * @mrioc: Adapter instance reference
> @@ -797,46 +799,52 @@ struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
>   * increment are done under tgtdev_lock, which mpi3mr_target_destroy hol=
ds
>   * while it frees the private data.
>   *
> - * Return: The private data that was incremented, only to be handed back=
 to
> - * mpi3mr_tgtdev_block_io_dec. NULL if the tgtdev has no SCSI target.
> + * Return: Sequence number of the private data that was incremented, to =
be
> + * handed back to mpi3mr_tgtdev_block_io_dec. 0 if the tgtdev has no SCSI
> + * target.
>   */
> -struct mpi3mr_stgt_priv_data *mpi3mr_tgtdev_block_io_inc(struct mpi3mr_i=
oc *mrioc,
> -							 struct mpi3mr_tgt_dev *tgtdev)
> +u64 mpi3mr_tgtdev_block_io_inc(struct mpi3mr_ioc *mrioc,
> +			       struct mpi3mr_tgt_dev *tgtdev)
>  {
> -	struct mpi3mr_stgt_priv_data *stgt_priv =3D NULL;
> +	struct mpi3mr_stgt_priv_data *stgt_priv;
>  	unsigned long flags;
> +	u64 seq =3D 0;
> =20
>  	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
>  	if (tgtdev->starget && tgtdev->starget->hostdata) {
>  		stgt_priv =3D tgtdev->starget->hostdata;
>  		atomic_inc(&stgt_priv->block_io);
> +		seq =3D stgt_priv->seq;
>  	}
>  	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> -	return stgt_priv;
> +	return seq;
>  }
> =20
>  /**
>   * mpi3mr_tgtdev_block_io_dec - Undo mpi3mr_tgtdev_block_io_inc
>   * @mrioc: Adapter instance reference
>   * @tgtdev: Target device reference, held by the caller
> - * @stgt_priv: Value returned by mpi3mr_tgtdev_block_io_inc
> + * @seq: Value returned by mpi3mr_tgtdev_block_io_inc
>   *
> - * Decrement block_io only if the SCSI target still has the same private
> - * data. If the target was removed meanwhile the private data is gone
> - * and there is nothing to undo.
> + * Decrement block_io only if the SCSI target still has the private data
> + * that was incremented. A private data allocated later at the same addr=
ess
> + * has a different sequence number and is left alone.
>   */
>  void mpi3mr_tgtdev_block_io_dec(struct mpi3mr_ioc *mrioc,
> -				struct mpi3mr_tgt_dev *tgtdev,
> -				struct mpi3mr_stgt_priv_data *stgt_priv)
> +				struct mpi3mr_tgt_dev *tgtdev, u64 seq)
>  {
> +	struct mpi3mr_stgt_priv_data *stgt_priv;
>  	unsigned long flags;
> =20
> -	if (!stgt_priv)
> +	if (!seq)
>  		return;
> =20
>  	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> -	if (tgtdev->starget && tgtdev->starget->hostdata =3D=3D stgt_priv)
> -		atomic_dec_if_positive(&stgt_priv->block_io);
> +	if (tgtdev->starget && tgtdev->starget->hostdata) {
> +		stgt_priv =3D tgtdev->starget->hostdata;
> +		if (stgt_priv->seq =3D=3D seq)
> +			atomic_dec_if_positive(&stgt_priv->block_io);
> +	}
>  	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
>  }

[Severity: Medium]
Can stgt_priv->block_io remain permanently elevated on a live scsi_target if
a BSG task management request completes while scsi_tgt_priv_data->num_luns
is temporarily zero?

In mpi3mr_sdev_destroy(), tgt_dev->starget is cleared whenever num_luns
reaches zero, even though the scsi_target and its hostdata (stgt_priv)
remain alive while starget->reap_ref is held:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_sdev_destroy() {
	...
	scsi_tgt_priv_data->num_luns--;
	...
	if (tgt_dev && (!scsi_tgt_priv_data->num_luns))
		tgt_dev->starget =3D NULL;
	...
}

And when another LUN is initialized on that same scsi_target,
mpi3mr_sdev_init() sets tgt_dev->starget back to starget:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_sdev_init() {
	...
	if (tgt_dev) {
		if (tgt_dev->starget =3D=3D NULL)
			tgt_dev->starget =3D starget;
	...
}

This happens during __scsi_scan_target() (which holds starget->reap_ref)
when probing LUN 0 in scsi_probe_and_add_lun() returns
SCSI_SCAN_TARGET_PRESENT (such as when LUN 0 has peripheral qualifier 3) and
calls __scsi_remove_device() -> mpi3mr_sdev_destroy() before
scsi_report_lun_scan() or scsi_sequential_lun_scan() adds the remaining LUNs
on the same starget. It can also happen if the last LUN on a target is
removed via scsi_remove_device() while a concurrent __scsi_add_device() has
already acquired starget->reap_ref via scsi_alloc_target() and is waiting on
shost->scan_mutex.

If mpi3mr_bsg_process_mpt_cmds() calls mpi3mr_tgtdev_block_io_inc() while
LUN 0 exists, and then calls mpi3mr_tgtdev_block_io_dec() during the window
where tgt_dev->starget is NULL, mpi3mr_tgtdev_block_io_dec() sees
tgtdev->starget =3D=3D NULL and skips the decrement. Once mpi3mr_sdev_init()
re-attaches tgt_dev->starget to that same starget, wouldn't
stgt_priv->block_io stay elevated and cause mpi3mr_qcmd() to return
SCSI_MLQUEUE_DEVICE_BUSY indefinitely for all commands to that target?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104120103.5038=
71-1-ranjan.kumar@broadcom.com?part=3D15
