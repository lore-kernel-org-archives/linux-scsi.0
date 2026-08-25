Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5BF34E761
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674842; cv=none; b=cDB4Qcv6xME0zx6jhY2PIpc9JDdYCXDlyDnFZAkNF0LGGnTVlihLuekirGYl9/Nl1Pg2AuYtAqTCPK0DjScZTTT5Nry+NDw0vM/8t4dZEZxoIrYM3p1VpNBU5xNFEBABi5950M6Nw9o/zU7yZZl6royKibn6tHkn8jzhJDc5zYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674842; c=relaxed/simple;
	bh=5T1/eD8jKMaVe6oD7iSIjUaaaDkcwkcYdJ8rjqpc+2o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KdNAJ8q6awRV2/V5kGO26Xryuvhwkv+sV6qWV7IP0X3QmiF4EZAsuWVuNCaaLEAn/9ijzSv2SpqZUBwKQPJ3EAgzVL6POJIMEHAWyJclZQq4Q27IDCrdHAOw9GcsDIldWtNuMdiv5brcdV2WguHn+xGIQlvmjqpwFv4sGnfwagE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G2fI+mWs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G2fI+mWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417FE1F000E9;
	Tue, 25 Aug 2026 16:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674841;
	bh=bXgWCwz7ETgp2ZeU+SS30AEcLSYEkw34BfSqk/XsYQY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G2fI+mWsWTej8TBoVcMoSvEOvqboFRhSbDSVGnSPMcF7f/RkX3azlzPwFALyLzikY
	 jH8cAWVuD6qOtauM08d8e1hKu2iTKcShbfBBrTu+XOepUyRwb0d0gDfDq+2YgVnIPK
	 MO0aXJbP7i3TobuAQ42orhgAFwbGMOCDsscFLMN6T6HBm9wFvbZFnoDm4wUGz1fGOH
	 SsK2ARsqqATrpy9ZLhAHvCPWzyu0iwnYtzTis4o7QRu9TLEwaqAURNIDEwSZJq/42E
	 y9RIaTNyXRzso3smQEpP3cYeXNZp7EesvvCb3OzbUIkTZdfxsUm7iG3Yg+aiyrb+dr
	 2DRu2fjvJPyIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/17] mpi3mr: Fix target device reference leak in
 device removal handshake
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-10-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-10-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:20:40 +0000
Message-Id: <20260825162041.417FE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Medium] Target device reference count leak on `mpi3mr_target_alloc` fail=
ure paths.
- [Medium] Silent failure and wedged hardware state machine when device rem=
oval handshake TM allocation fails.
--

commit e0b0b39b67b7199d7920836b376fd3080aa21730
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix target device reference leak in device removal handshake

The device removal handshake looks up the target device to update its
state but never drops the reference that the lookup takes.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 2a35f146fe69b..9aeec6146acbb 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2536,6 +2536,9 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_i=
oc *mrioc, u16 handle,
>  		tgtdev->state =3D MPI3MR_DEV_REMOVE_HS_STARTED;
>  	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> =20
> +	if (tgtdev)
> +		mpi3mr_tgtdev_put(tgtdev);
> +
>  	if (drv_cmd)
>  		goto issue_cmd;
>  	do {

[Severity: Medium]
This isn't a bug introduced by this patch, but further down in
mpi3mr_dev_rmhs_send_tm(), if the pre-allocated command slots are exhausted,
the code falls back to allocating a delayed_dev_rmhs node:

    delayed_dev_rmhs =3D kzalloc_obj(*delayed_dev_rmhs, GFP_ATOMIC);
    if (!delayed_dev_rmhs)
        return;

If this GFP_ATOMIC allocation fails, the function returns without schedulin=
g a
retry or rolling back the device state (MPI3MR_DEV_REMOVE_HS_STARTED).

Can this silent failure leave the hardware state machine permanently wedged,
waiting for the host to send this TM request?

[Severity: Medium]
This is a pre-existing issue, but looking at mpi3mr_target_alloc() in the s=
ame
file, there appears to be a reference count leak on the error paths.

If __mpi3mr_get_tgtdev_by_perst_id() or
__mpi3mr_get_tgtdev_by_addr_and_rphy() successfully finds a target device,
but the device doesn't satisfy the conditional checks for PCIe devices:

    if (tgt_dev && !tgt_dev->is_hidden && tgt_dev->non_stl) {
        ...
    } else
        retval =3D -ENXIO;

Or for SAS/SATA devices:

    if (tgt_dev && !tgt_dev->is_hidden && !tgt_dev->non_stl &&
        (tgt_dev->dev_type =3D=3D MPI3_DEVICE_DEVFORM_SAS_SATA)) {
        ...
    } else
        retval =3D -ENXIO;

In both cases, the code returns -ENXIO without dropping the reference count
via mpi3mr_tgtdev_put(tgt_dev), and without assigning it to
scsi_tgt_priv_data->tgt_dev for later cleanup.

Would this leak the mpi3mr_tgt_dev memory structures during device scanning
if hidden or non-standard devices are present?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D9
