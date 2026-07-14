Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E68F4963B8
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 15:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784044359; cv=none; b=fcPziR8oWWI1Iv29tSlS83l6FDj544undhpzQ09vT/dHGMYvdiZAbWZbK6VtM/FZws9Jb3VJ14RxHy+umvOlzDN6VOObwZaE4ak8DjxCELHH/OQaHOGPnzji57s8eirLQPkPbLKhAdgeVjndBWXeCJB4TxkuezU3W7HU399Qp60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784044359; c=relaxed/simple;
	bh=eWLYyF9F1+nSI2CxRQtpD6kDUaJB2pn8oEBq0NQEeMc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iqoalctN7Y0keP6K+npe6K10DH1VSUUESzZCJHo2tFYZY50fb9eLKMtarUAUUU2Kt3ipOuVMl4ypJd4m/23JdjffRb2HAaphVdzh6mj2Ik4ccq4JMOj86Ea1bxs3GmWklcQR3xf98M+/rjvAlx0js4aPMxOTvL4VfWjRBtj+gvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F18V50zw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F18V50zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FDB1F000E9;
	Tue, 14 Jul 2026 15:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784044356;
	bh=VnqsJRm3pd0p8FmoFAFedvO9OiTmVlJrh/K0EUI0eKs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F18V50zwwHX0pPuhrLdNZlYbl7YB/lWa+tSOGaMvT/+CLwiwLAF0mbtWSYfDcw1uU
	 aTZ02AK+zMewm00ZmBoDxAkziE+7XbJCoV6CMngN+h8tz9v+tO0R0rgBFzhMWYovZf
	 J+UjSmLGSRF/32s1hpL+Lgmra5MwNOwo1uswZ2ejpiIDS4WtQPLOh1U77M/5xVOv2u
	 Lh+nfl3UUnEFCMgs/jf5X3iqrwB/SPNXjth5Q+2oZRDWFojsTf9imaCutTAsjIwLKf
	 /hykidGgrTkWOw+JTiASxvp4FujBIHf1hNry410dEQf4HORnw7ahSXI72b9AhDX2O3
	 KSOaeq1iWHmGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 39/56] scsi: qla2xxx: Adjust feature gating in BSG
 paths for 29xx support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-40-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-40-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 15:52:35 +0000
Message-Id: <20260714155236.53FDB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing bounds check on user-supplied count leads to out-of-bo=
unds stack read and information leak to hardware.
- [High] Uninitialized kernel heap memory is leaked to user space in qla2x0=
0_do_dport_diagnostics.
- [High] Modifying a DMA buffer after mapping it for device use causes data=
 corruption on non-coherent architectures.
--

--- Patch [39]: [PATCH v4 39/56] scsi: qla2xxx: Adjust feature gating in BS=
G paths for 29xx support ---
commit 3425e7689599b4f90cb066bb5b9b5a8c81315e6d
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support

Extend qla2xxx BSG command handling to recognize QLA29xx adapters and
align feature availability with hardware capabilities. Allow QLA29xx in
paths previously restricted to QLA27xx/28xx and restrict unsupported
operations. Guard the active image layout logic with explicit checks.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 46eed5df7eefb..9ee56ccd52b01 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2014,7 +2014,7 @@ static int qla2900_bsg_load_mpi(struct bsg_job *bsg=
_job)
>  	bsg_job_done(bsg_job, bsg_reply->result,
>  		     bsg_reply->reply_payload_rcv_len);
> =20
> -	return rval;
> +	return 0;
>  }

[Severity: Critical]
This is a pre-existing issue, but could this lead to an out-of-bounds stack
read?

In the neighboring function qla2x00_update_fru_versions() in qla_bsg.c:

	uint8_t bsg[DMA_POOL_SIZE];
	struct qla_image_version_list *list =3D (void *)bsg;
	...
	image =3D list->version;
	count =3D list->count;

	while (count--) {
		memcpy(sfp, &image->field_info, sizeof(image->field_info));
		rval =3D qla2x00_write_sfp(vha, sfp_dma, sfp, ...);
		...
		image++;
	}

It reads the user-supplied list->count and uses it as a loop condition.
If the count is maliciously large, could this loop iterate past the end of =
the
bsg stack array, reading out-of-bounds stack memory and sending it to the
device via qla2x00_write_sfp()?

[ ... ]

> @@ -2855,7 +2855,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_jo=
b)
>  	struct qla_dport_diag *dd;
> =20
>  	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
> -	    !IS_QLA28XX(vha->hw))
> +	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
>  		return -EPERM;
> =20
>  	dd =3D kmalloc_obj(*dd);

[Severity: High]
This isn't a bug introduced by this patch, but does this allocation leak
uninitialized kernel heap memory?

If a user triggers this BSG request with a payload smaller than
sizeof(struct qla_dport_diag), kmalloc_obj(*dd) leaves the buffer
uninitialized, and sg_copy_to_buffer() only partially overwrites it.

Then qla26xx_dport_diagnostics() memsets only dd->buf. The remaining 62 byt=
es
in dd->unused remain uninitialized before being copied back to userspace via
sg_copy_from_buffer():

	if (rval =3D=3D QLA_SUCCESS) {
		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
		    bsg_job->reply_payload.sg_cnt, dd, sizeof(*dd));
	}

Could we use kzalloc_obj() instead?

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index cec308811d9eb..ce845afe3e16a 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -6566,7 +6566,7 @@ qla26xx_dport_diagnostics(scsi_qla_host_t *vha,
>  	dma_addr_t dd_dma;
> =20
>  	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
> -	    !IS_QLA28XX(vha->hw))
> +	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
>  		return QLA_FUNCTION_FAILED;
> =20
>  	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x119f,

[Severity: High]
This is a pre-existing issue, but does this modify a DMA buffer after mappi=
ng
it for device use?

Looking at qla26xx_dport_diagnostics():

	dd_dma =3D dma_map_single(&vha->hw->pdev->dev,
	    dd_buf, size, DMA_FROM_DEVICE);
	...
	memset(dd_buf, 0, size);

Modifying the buffer after mapping it with DMA_FROM_DEVICE violates the DMA
API, which can cause data corruption on non-coherent architectures when the
CPU writes dirty cache lines over the device's DMA writes.

Should the memset() occur before the dma_map_single() call?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D39
