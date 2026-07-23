Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED73371D1F
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826356; cv=none; b=STAw7t9Jj5BU+YWD6iBXOpC34VA2SdPgUep266eVh8Zdq/5QJ1gU9ycUqcbB6oFIOXzdn2Ahui2fh78fr6jom/fIascB+Pyiaym7urJDwZdrih875kmHzOm0LSag3plWn4nYL5+tNhW+Nit2RNWNyepmZYAoMe1Y3OKxj7gONmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826356; c=relaxed/simple;
	bh=iwbPWQw81lXzX9UP3T4IVtzPpmUa0QknFb35cWG3JUY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MR1kK1sci9RLxqEiaTeUrmvafYRueqkpsA2nSlnXWKLfXatVvN12aXWPJUxHTW9f/zKOu5FnI3KMIv6uohXCdCgG3AEhqjgWN5+0N6U3MDLVtGmrIIx7e6CBr5D7PfVVJSsaIvdMGswb2KtTfxwhlnA3p14PpsW+1DX4ekokPXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N1ilHYjq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N1ilHYjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1468A1F000E9;
	Thu, 23 Jul 2026 17:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784826352;
	bh=Hu+9TSbKsUvMJKYMMfp9uhr9sSImCzpaRRGvneHTX9s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N1ilHYjqA9y4JWVK5SaKBlN49paoWaXkQGTQYkKGQK4sm++T04+eODtGeTC7nTW6Y
	 AIK/MkZprGQm8xtuIBjnvccLP891VFNlhJuAVQQhpJJ8xYKQPNev45eNkaoVRkSoHr
	 GTEW+CpTgky6x5r2goH2O4kf4fLBWML669u1DK0IYT0TLHKfN+YAKMCex50SL9FkOe
	 /GDfWxjZnSJAWWeVZf98g3ElN6U0rtLTWtWJEe5nq5gVhuQAG0sqgYclhXO4i5CM2N
	 gV8K0/pb20fyScc6uOYQP6NTVXfWgbKURdjOUDdm7qYhdLJV1tYGEbPG5ubD+Di2FU
	 dG0t2UMk6CPHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 39/56] scsi: qla2xxx: Adjust feature gating in BSG
 paths for 29xx support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-40-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-40-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 17:05:49 +0000
Message-Id: <20260723170552.1468A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Multiple vendor-specific BSG handlers copy user data into an unini=
tialized stack buffer without validating the request payload length, leadin=
g to uninitialized stack variable usage and information leaks.
- [High] The `qla28xx_validate_flash_image` function fails to call `bsg_job=
_done()` on error paths but still returns `QLA_SUCCESS` (0), bypassing comp=
letion mechanisms and hanging the job.
- [High] Information leak via uninitialized kernel heap memory in `qla2x00_=
do_dport_diagnostics`.
- [High] Unaligned DMA mapping of an interior struct member in `qla26xx_dpo=
rt_diagnostics`.
--

--- Patch [39]: [PATCH v6 39/56] scsi: qla2xxx: Adjust feature gating in BS=
G paths for 29xx support ---
commit c26fb874cafb5af2254e6979b56c1d91494f6044
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support

Extend qla2xxx BSG command handling to recognize QLA29xx adapters and
align feature availability with hardware capabilities. Allow QLA29xx in
paths previously restricted to QLA27xx/28xx and restrict unsupported
operations on QLA29xx.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 3187909759a07..f9f9687316b58 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1962,7 +1962,7 @@ static int qla2900_bsg_load_mpi(struct bsg_job *bsg=
_job)
>  	bsg_job_done(bsg_job, bsg_reply->result,
>  		     bsg_reply->reply_payload_rcv_len);
> =20
> -	return rval;
> +	return 0;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does qla2x00_update_fru_vers=
ions
in drivers/scsi/qla2xxx/qla_bsg.c read uninitialized stack values?

Multiple vendor-specific BSG handlers copy user data into an uninitialized
stack buffer without validating the request payload length. For example, if
the payload is short, the count variable can remain uninitialized:

qla2x00_update_fru_versions() {
    ...
    uint8_t bsg[DMA_POOL_SIZE];
    struct qla_image_version_list *list =3D (void *)bsg;
    ...
    sg_copy_to_buffer(bsg_job->request_payload.sg_list,
        bsg_job->request_payload.sg_cnt, list, sizeof(bsg));

    image =3D list->version;
    count =3D list->count;
    ...
    while (count--) {
    ...
}

This could lead to out-of-bounds DMA and hardware writes driven by
uninitialized stack data.

Similarly, in qla2x00_read_fru_status, uninitialized stack memory might be
used as device parameters:

qla2x00_read_fru_status() {
    ...
    rval =3D qla2x00_read_sfp(vha, sfp_dma, sfp,
        sr->field_address.device, sr->field_address.offset,
        sizeof(sr->status_reg), sr->field_address.option);
    ...
}

Can we validate the request payload length to prevent this regression?

[ ... ]

> @@ -2803,7 +2803,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_jo=
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
This is a pre-existing issue, but does this allocation leak uninitialized
kernel heap memory to user-space causing a regression?

If a user issues the dport diagnostics BSG command with a truncated request
payload, kmalloc_obj allocates memory without zeroing it. The unwritten
struct fields and padding could then be copied to the user reply payload:

qla2x00_do_dport_diagnostics() {
    ...
    if (rval =3D=3D QLA_SUCCESS) {
        sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
            bsg_job->reply_payload.sg_cnt, dd, sizeof(*dd));
    }
    ...
}

Could this regression expose sensitive kernel heap contents?

[Severity: High]
This is also a pre-existing issue, but does this unaligned DMA mapping risk
memory corruption?

When the dport diagnostic BSG command is initiated,
qla26xx_dport_diagnostics is called with the dd->buf member:

qla2x00_do_dport_diagnostics() {
    ...
    rval =3D qla26xx_dport_diagnostics(
        vha, dd->buf, sizeof(dd->buf), dd->options);
    ...
}

Inside qla26xx_dport_diagnostics in drivers/scsi/qla2xxx/qla_mbx.c, this
buffer is mapped for DMA:

qla26xx_dport_diagnostics() {
    ...
    dd_dma =3D dma_map_single(&vha->hw->pdev->dev,
        dd_buf, size, DMA_FROM_DEVICE);
    ...
}

Since struct qla_dport_diag is packed, the buf member sits at a 2-byte
offset. Mapping an unaligned struct member could violate DMA constraints,
leading to silent memory corruption during cache flushes on architectures
that are not cache-coherent, or hardware overwrite of adjacent fields.
Can this regression be adjusted?

[ ... ]

> @@ -2929,8 +2929,13 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg=
_job)
>  	struct qla_active_regions regions =3D { };
>  	struct active_regions active_regions =3D { };
> =20
> -	qla27xx_get_active_image(vha, &active_regions);
> -	regions.global_image =3D active_regions.global;
> +	if (IS_QLA29XX(ha))
> +		return -EPERM;
> +
> +	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +		qla27xx_get_active_image(vha, &active_regions);
> +		regions.global_image =3D active_regions.global;
> +	}

[Severity: High]
This is a pre-existing issue, but does qla28xx_validate_flash_image in
drivers/scsi/qla2xxx/qla_bsg.c skip completing the BSG job on error paths?

If the internal validation fails and rval is non-zero, it bypasses the
bsg_job_done call:

qla28xx_validate_flash_image() {
    ...
    if (!rval)
        bsg_job_done(bsg_job, bsg_reply->result,
                     bsg_reply->reply_payload_rcv_len);

    return QLA_SUCCESS;
}

Returning QLA_SUCCESS without completing the job causes the BSG block layer
to wait indefinitely. Could this hang the user-space process and cause a
denial of service regression?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D39
