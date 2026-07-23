Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254B2318BB8
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 07:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791456; cv=none; b=D5q4cHjFGIS+eK+2AKjIDaWyNIJopWDUsdfe6/23KtRExdyI5U+9GCdl55vw+q10CJCT1v6MKZxQTKAjmslrQeNnnriPWxF/5WGPVyWz+IAXVX+uhKSvK+PH7DSUfz8d7YTI3NmuboirzksUWE1E3a6bZB/JTEnYXr5fUg4vEEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791456; c=relaxed/simple;
	bh=L3kJ/Ca4p7UfKmRd9Py4xrNre00nBjmI4/nwcaoCiiQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WYupfQ6Y0G6hMmXylO/D4mbyHSruTdZDrvFxLIPxwaM+0SAy7NiJKHM4RvTC6H4bsq8q33aSkWZl9I7KISmb6sPaG/bVNg8ZlGP0dnZidaT/g4myFwuaK0d3MA8bM5lSZYUmrp0GGnvxR65dv7CaAj8UvraIBui36xvZ5exv1vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imyPhXZF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imyPhXZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917A81F000E9;
	Thu, 23 Jul 2026 07:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784791454;
	bh=5czVuDmFIgYP5zSNAEbBLymDqLMCXLkzCsw8qWsrssk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=imyPhXZF9uXoTE/J6mtlaGcLVvAtvE+X6jvXCapPvNMYaE+cfoTJC3S3dKU2dRGuP
	 CBcDX0gTuNAZ7KlDomlHVz3QLv8f16//qS0faU1a2+TkFJaNIkYCQMx373JAEOw2iX
	 FXZ1qoEVU9m8Bgq19zzNeFDBChz2FalbLr9pMiRj0caGU6iRLdXh0GCMgG5Ie3Geji
	 bQ2OGBVdTRwCC61/N+XDc/OE+vVHgrvsowxhjmGakCedVpO/lIbR9lHRW9+71slNir
	 D0U9Q2GvvdgNxXSVLSWhVzFD1CsXyaOF8+vuh/yyns4FXDSdkl2tdyiPN14wVF5OH7
	 Y/xMo3fueZUzg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 08/56] scsi: qla2xxx: Add BSG MPI firmware load/dump
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-9-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-9-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 07:24:14 +0000
Message-Id: <20260723072414.917A81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Double completion of a BSG job resulting in use-after-free in the =
block layer.
- [High] Swapped semantics between LOAD and DUMP operations for MPI firmwar=
e.
--

--- Patch [8]: [PATCH v6 08/56] scsi: qla2xxx: Add BSG MPI firmware load/du=
mp for 29xx ---
commit cd4037683fe65a034825a9797719d6d2dd2a6eb6
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add BSG MPI firmware load/dump for 29xx

This commit adds BSG vendor commands for loading and dumping MPI firmware
on 29xx adapters. It extends the existing BSG infrastructure by providing
necessary mailbox wrappers and flash helpers for MPI operations.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index b0ba927c54d71..8cad9a046ad9b 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
[ ... ]
> @@ -1768,6 +1768,203 @@ static int qla29xx_bsg_flash_block_write(struct b=
sg_job *bsg_job)
[ ... ]
> +static int qla2900_bsg_dump_mpi(struct bsg_job *bsg_job)
> +{
[ ... ]
> +	mutex_lock(&ha->optrom_mutex);
> +	rval =3D qla29xx_mpi_optrom_setup(bsg_job, vha, dmcmd->mpi_address, 1);

[Severity: High]
Are the semantics for DUMP and LOAD swapped in these functions?

It looks like the dump function sets is_update to 1 here, which reads from =
the
request payload and writes to the adapter.

> +	if (rval) {
> +		mutex_unlock(&ha->optrom_mutex);
> +		return rval;
> +	}
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +			  bsg_job->request_payload.sg_cnt, ha->optrom_buffer,
> +			  ha->optrom_region_size);
[ ... ]
> +	rval =3D qla29xx_mpi_optrom_data(vha, opts, ha->optrom_buffer,
> +				       ha->optrom_region_start,
> +				       ha->optrom_region_size,
> +				       QLA29XX_MPI_OP_DUMP);
[ ... ]
> +static int qla2900_bsg_load_mpi(struct bsg_job *bsg_job)
> +{
[ ... ]
> +	mutex_lock(&ha->optrom_mutex);
> +	rval =3D qla29xx_mpi_optrom_setup(bsg_job, vha, lmcmd->mpi_address, 0);

[Severity: High]
Conversely, the load function sets is_update to 0 here, reading from the
adapter into the reply payload.

Could this accidentally overwrite the adapter firmware when a user merely
attempts to dump it?

> +	if (rval) {
> +		mutex_unlock(&ha->optrom_mutex);
> +		return rval;
> +	}
[ ... ]
> +	bsg_reply->reply_payload_rcv_len =3D ha->optrom_region_size;
> +	vfree(ha->optrom_buffer);
> +	ha->optrom_buffer =3D NULL;
> +	ha->optrom_state =3D QLA_SWAITING;
> +	mutex_unlock(&ha->optrom_mutex);
> +	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);
> +
> +	return rval;

[Severity: High]
Does returning a non-zero rval here cause a double completion?

If qla29xx_mpi_optrom_data() fails, rval is returned as an error code.
Since bsg_job_done() was already called above, the BSG caller
(fc_bsg_host_dispatch) might see the non-zero return value, treat it as a
dispatch failure, and call bsg_job_done() a second time on the same job.

Could this lead to a use-after-free in the block layer?

> +}
[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_su=
p.c
> index ee7562bf8d383..2e5fde403442f 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
[ ... ]
> @@ -541,6 +541,123 @@ qla29xx_read_optrom_data(struct scsi_qla_host *vha,=
 uint16_t reg_code,
[ ... ]
> +int
> +qla29xx_mpi_optrom_data(struct scsi_qla_host *vha, uint16_t opts, void *=
buf,
> +		       uint32_t offset, uint32_t length, enum qla29xx_mpi_optrom_op op)
> +{
[ ... ]
> +		if (op =3D=3D QLA29XX_MPI_OP_DUMP) {
> +			options |=3D (BIT_0);
> +			options |=3D opts;
> +
> +			ql_log(ql_log_info, vha, 0x008b,
> +				"-> %s (DUMP): %#x <-(%#x words) (0x%x options) chunk (0x%x, 0x%x)\n=
",
> +				__func__, mpi_addr, burst, options, chunk_count,
> +				total_chunks);
> +
> +			memcpy(dcode, fwcode, burst * 4);
> +
> +			rval =3D qla29xx_load_dump_mpi(vha, options, mpi_addr, burst,
> +						     optrom_dma);

[Severity: High]
And similarly in qla29xx_mpi_optrom_data(), OP_DUMP maps to a device write =
by
setting BIT_0 and copying the host buffer to the DMA buffer before calling
qla29xx_load_dump_mpi().

Should this be OP_LOAD instead?

> +			if (rval) {
> +				ql_log(ql_log_fatal, vha, 0x0098,
> +					"Failed dump mpi firmware.\n");
> +				goto free_buf;
> +			}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D8
