Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C15C33E360
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787077119; cv=none; b=CDdSL3/aBpFvq1b++bvZb4T9BN1hRSlHpBz41XxL77NDQbMcxzGa3PA8ytctEkpDfOm4oUylOTV/+Qe8ffnbkz1ry4xtiDE6c6xDRuvvNrVB3RLJW8LQ9fbSAgv4VsnZpnB2OjtWqFG1106Fw1YHb8ykdf9lrZVAYi6K1YtHBHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787077119; c=relaxed/simple;
	bh=rLvauFkQ/I708nWv2CZBMW4d2LrAKhVOD1PEjEv4Chk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cat4U/OpUEU2gEbzJ83FroNt3pxgbHj06dbbJ7Vfe/EaQVDQxpTVjAgB5sOF0eesxFRKwZ592T5w8QSeaYGGdV+LyRX6Evlzye8aYP5hlRhJI0iNpJzGC4J3l2On0qyfc0PODm+r+Uqyog0Si0uyC/gNpj4IMTLSD/f9DkBUxG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCrfkHsO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCrfkHsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92C21F00A3A;
	Tue, 18 Aug 2026 18:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787077117;
	bh=PBGmV14Ofo7wvA7vxhjVmdG518TlkZwWKMyGJL7UXbY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VCrfkHsOC3sBH5XAe37hY5DRS4BUH7w53FIWUlX6PUBu/6ufdAUXcDxP7rGsSu/lt
	 X7yjMJBhGwmOVLClikaJVaWcMCLw48G7dtjYQlGNmpuGRzLR5RkL6v8KTGVk5k66ln
	 zr6h3iXGwowW6ryNotOvMtbOlvUODhXU7igidiyZ2a5RQTKGgg3XldsaLjaSZWtehS
	 usr1MOGlsH/vSMosfUiZDaOMUu0rkPZ/6bmn8P2cZ9pyBetc1Pe4KdePzxxGMIVHZ5
	 n/b6MU292NSTMgs0l85M+dkXT40GydA+Sf+zVmtkgH/D4QlTdLS8UBtvNorJrQy9N8
	 +ljnqz6ZEaVEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/17] mpi3mr: Fix target device reference leak in
 device removal handshake
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-10-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-10-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:18:37 +0000
Message-Id: <20260818181837.C92C21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Memory leak of tgt_dev reference in mpi3mr_target_alloc() error pa=
ths.
- [High] Memory leak of tgtdev reference in mpi3mr_get_port_id_by_rphy() wh=
en hba_port is NULL.
- [High] Memory leak of tgtdev reference in mpi3mr_sas_port_add() error pat=
hs.
--

--- Patch [9]: [PATCH 09/17] mpi3mr: Fix target device reference leak in de=
vice removal handshake ---
commit d4f3aa04629aa5ef9b7db8bd5ef68d81cfceef82
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix target device reference leak in device removal handshake

This commit fixes a target device reference leak in the device removal
handshake. It drops the reference acquired by the device lookup once the
state has been updated.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 7ae4b4fad3f4a..b18e7ea873030 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2522,6 +2522,9 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_i=
oc *mrioc, u16 handle,
>  		tgtdev->state =3D MPI3MR_DEV_REMOVE_HS_STARTED;
>  	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> =20
> +	if (tgtdev)
> +		mpi3mr_tgtdev_put(tgtdev);
> +
>  	if (drv_cmd)
>  		goto issue_cmd;

[Severity: High]
This isn't a bug introduced by this patch, but since this commit fixes a
target device reference leak, I noticed a similar pre-existing leak in
mpi3mr_target_alloc() in drivers/scsi/mpi3mr/mpi3mr_os.c.

If the validation checks fail, the function sets retval =3D -ENXIO and exits
without releasing the acquired tgt_dev reference:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_target_alloc() {
    ...
    tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
    if (tgt_dev && !tgt_dev->is_hidden && tgt_dev->non_stl) {
        ...
    } else {
        retval =3D -ENXIO;
    }
    ...
}

Does this cause a permanent memory leak of the target device structure?


[Severity: High]
This is a pre-existing issue, but there appears to be another leak in
mpi3mr_get_port_id_by_rphy() in drivers/scsi/mpi3mr/mpi3mr_transport.c.

The code retrieves the target device and takes a reference, but it only
puts the reference inside the condition block that checks if the device's
hba_port is non-NULL:

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_get_port_id_by_rphy() {
    ...
    tgtdev =3D __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc, ...);
    if (tgtdev && tgtdev->dev_spec.sas_sata_inf.hba_port) {
        ...
        mpi3mr_tgtdev_put(tgtdev);
    }
    ...
}

If a device is found but its hba_port is NULL, the function exits without
releasing the reference. Does this result in a persistent memory leak?


[Severity: High]
This is also a pre-existing issue, but does mpi3mr_sas_port_add() in
drivers/scsi/mpi3mr/mpi3mr_transport.c leak a reference during error paths?

When adding an end device, a reference to the target device is acquired. If
any subsequent setup or allocation fails, the code jumps to the out_fail
label. The cleanup path handles freeing the SAS port structure but seems to
bypass calling mpi3mr_tgtdev_put():

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_sas_port_add() {
    ...
    if (rphy->identify.device_type =3D=3D SAS_END_DEVICE) {
        tgtdev =3D mpi3mr_get_tgtdev_by_addr(...);
    }
    ...
out_fail:
    ...
}

Could this leak the target device reference during port addition failures?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D9
