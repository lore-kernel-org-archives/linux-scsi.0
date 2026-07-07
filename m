Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8533342087A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405289; cv=none; b=fGXP1JRPIGUnpCqst+jHf3oe8MgwLw0CrMIM5XLZQFb7Crtuxz2w5y+rc1IRrn5bUK3vEDw5/JctHtau53i3xSfnUOmk8naFNIaF8ZM3A0x9FlSSiHIWt4jEWTDnhESRwHxAcR2Hnf6SKmDjr1upXTVGWPU2EyaYOLSD1JeeILk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405289; c=relaxed/simple;
	bh=mrs1rN6CPvhajqt8Q1cbvGVN1EeUv1jsqJcctf2IMvQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cWizmKXqgB/tgiuvw7RixVddogE6L8gTBXx+e/XYz/1Vv0pjnnP4QzRUgc71Sn5OQ2p2f//S+IfnTjEeJHsn4Q+DT3wIgVte4pizTmc38TyxKPwgmCWhe+ZEHRbaqzAwtOQ3uGRF+zLPMj7I/iF3oKB9eJBtkkl79233YhdtZ1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GsTacilj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GsTacilj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F7D1F000E9;
	Tue,  7 Jul 2026 06:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783405288;
	bh=Zk+9iKoEd0WB/4L+IF5bzEILKd6pxAqzqWb8lT5B65A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GsTaciljlRNhHutSRb1gnSJeIUcNYFVxA9JHFu7SpucLDguwlL2qFs0tGuN5eDh5t
	 MI6pzdq4aSZA8YShZmpMc1QW2UBv/8QUBx3Yu84eyHCD/B5tOPVLdVd+idH3ec0i5+
	 FPcRe/+Y5GnA2lZoEnBTST6epmEGKGEssIHZYXUMBLrj37u+6a4HlfvaRh86JZ9B+0
	 +WqwKhG1eQWs42GA8Kt+cmyQWDsIXbZCStgREv1K/BNQ1kVDCWM4IAjALcXOYMJipj
	 6Hn88zaBGIB4F/g24IwC6gfCGHq7qZOpgXEtL2yNbRuEeDAWxD/KtTgnp0WaXs5avv
	 ysOgqFKzJe6Fg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/88] scsi: qla2xxx: Add flash block read/write BSG
 support for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-8-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-8-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:21:27 +0000
Message-Id: <20260707062128.08F7D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Region-relative flash offset is incorrectly validated against the =
total flash size.
--

--- Patch [7]: [PATCH v3 07/88] scsi: qla2xxx: Add flash block read/write B=
SG support for 29xx ---
commit 31fdf59e3896b2b2cd9a7fe0c5b72367e33df679
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add flash block read/write BSG support for 29xx

Introduce QL_VND_READ_FLASH_BLOCK and QL_VND_WRITE_FLASH_BLOCK
BSG vendor commands so that userspace tools can perform flash
block-level operations on 29xx adapters via the isp_ops
interface.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 5e910b5ca670d..ff7421f3535dc 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c

[ ... ]

> @@ -1431,42 +1422,79 @@ qla2x00_optrom_setup(struct bsg_job *bsg_job, scs=
i_qla_host_t *vha,
>  	}
> =20
>  	ha->optrom_region_start =3D start;
> +
> +	if (IS_QLA29XX(ha)) {
> +		if (start > ha->optrom_size) {
> +			ql_log(ql_log_warn, vha, 0x7055,
> +			    "start %d > optrom_size %d.\n", start,
> +			    ha->optrom_size);
>  			return -EINVAL;
>  		}
> =20
> +		if (is_update) {
> +			ha->optrom_region_size =3D start +
> +			    bsg_job->request_payload.payload_len >
> +			    ha->optrom_size ?
> +			    ha->optrom_size - start :
> +			    bsg_job->request_payload.payload_len;

[Severity: High]
Does this allow out-of-bounds cross-region flash operations?

For QLA29XX block operations, start is populated with a region-relative
offset, but it is being validated and clamped against the entire adapter
flash size (ha->optrom_size).

If a user specifies a valid region but provides a region-relative offset
and length that exceeds the specific region's actual boundaries, wouldn't
this code bypass region isolation and allow reading or writing outside the
intended region?

[ ... ]

> +static int qla29xx_bsg_flash_block_write(struct bsg_job *bsg_job)
> +{

[ ... ]

> +	bwcmd =3D
> +	   (struct qla_block_rw *)&bsg_req->rqst_data.h_vendor.vendor_cmd[2];

[ ... ]

> +	mutex_lock(&ha->optrom_mutex);
> +	rval =3D qla2x00_optrom_setup(bsg_job, vha, bwcmd->region_offset, 1);

[Severity: High]
This is where the user-provided region-relative offset is passed to
qla2x00_optrom_setup().

After the incorrect global size clamping is applied, the offset is dispatch=
ed
to the firmware via write_optrom_region() without any further region bounda=
ry
checks.

Could this allow users to overwrite critical areas of flash and potentially
damage the hardware adapter?

> +	if (rval) {
> +		mutex_unlock(&ha->optrom_mutex);
> +		return rval;
> +	}
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +			bsg_job->request_payload.sg_cnt, ha->optrom_buffer,
> +			ha->optrom_region_size);

[ ... ]

> +	rval =3D ha->isp_ops->write_optrom_region(vha, bwcmd->region, opts,
> +				ha->optrom_buffer, ha->optrom_region_start,
> +				ha->optrom_region_size);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D7
