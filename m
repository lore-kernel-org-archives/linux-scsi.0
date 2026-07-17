Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BBB36EA84
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303508; cv=none; b=gwpQVNFNT9AbWSfrXUTbxqQOoGwhUKuvPIEmtujGcb7MWGD/vxasborpZJqPA1pSsTLyH90oSecxt2/m6haltLdjcAMvNBPdUCju2nMCGkwb5fv0IH45RsHKdQDg5qNfqQnVL6/wkTbsC1J1sE0r3hQXo3ipKR0fKv4H1fRt9t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303508; c=relaxed/simple;
	bh=1vpdoRgix2oUmSJj+kzxAaO5Ub9VCg5/B9ps7z3DnaQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nqtadrOBIobRn/6Jot0TRIL+yRKgYinAh6frigeihHI/WuHwLSItzCCHHYtzTSn6kKlQdHhzZiqWvQ3loWLQJSmaaOeEqhmNe5cCO/D2Du/6pCj5Vna7jiK2VxgHLzs0hclf4mfzx6Ryn4c/YCSAQC6FEJBABewhJQifMkBhP9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fhaavu3d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fhaavu3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D631F000E9;
	Fri, 17 Jul 2026 15:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784303506;
	bh=c3upxPHw5VIfYqkC/kaNZ43hBswl+ARQ8yPj42nLHsA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fhaavu3dL4t5jdAl7srWybRInXH5nfyiUnSsechzrsB9dWvuzEUJiJYeGHSkyp34U
	 HrSZQRiaJqxptITKbKYmGmbTV5+80HFO9RyJetfdS7vVvvNt4uL85f8uvjspiDHuLq
	 mhL1pfjkuTb/MJLgm5S90W5Ya6BnbImTUOlVNuehaHrJbQSx7JpFrI/8+YgEI27jvv
	 5epGSMI2QUld+ZCswSS/4SPyoOmDnGq7jVp3CGUYFPturxh+1m/DHcOEFbjA2rA0Ig
	 A8YICEVNaCfqBv+NIczFTCFjaiTLQeZYse089cPAtnNXESNaMJQyN0PaZCEpFjocuC
	 l6HnwfT6zGl+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 08/56] scsi: qla2xxx: Add BSG MPI firmware load/dump
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-9-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-9-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 15:51:46 +0000
Message-Id: <20260717155146.75D631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Double completion of BSG job in qla2900_bsg_load_mpi() on error pa=
th.
- [High] The implementations of QL_VND_LOAD_MPI and QL_VND_DUMP_MPI are com=
pletely swapped, breaking API semantics.
--

--- Patch [8]: [PATCH v5 08/56] scsi: qla2xxx: Add BSG MPI firmware load/du=
mp for 29xx ---
commit 90e9d607deb3d4b5831bfa77970f0b380447e7b0
Author: Manish Rangankar <mrangankar@marvell.com>
scsi: qla2xxx: Add BSG MPI firmware load/dump for 29xx

This commit adds BSG vendor commands for loading and dumping MPI firmware
on 29xx adapters. It extends the existing BSG infrastructure with the
necessary mailbox wrappers and flash helpers for MPI operations.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 92a1af81c057f..5dd7e5e969ab0 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
[ ... ]
> +static int qla2900_bsg_dump_mpi(struct bsg_job *bsg_job)
> +{
[ ... ]
> +	mutex_lock(&ha->optrom_mutex);
> +	rval =3D qla29xx_mpi_optrom_setup(bsg_job, vha, dmcmd->mpi_address, 1);

[Severity: High]
Does this function implement the wrong operation? Setting is_update=3D1 here
causes qla29xx_mpi_optrom_setup() to set ha->optrom_state to QLA_SWRITING.

> +	if (rval) {
> +		mutex_unlock(&ha->optrom_mutex);
> +		return rval;
> +	}
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +			  bsg_job->request_payload.sg_cnt, ha->optrom_buffer,
> +			  ha->optrom_region_size);

And this copies data from the host's request_payload, suggesting this is
actually a load (host-to-device) operation rather than a dump.

[ ... ]
> +static int qla2900_bsg_load_mpi(struct bsg_job *bsg_job)
> +{
[ ... ]
> +	mutex_lock(&ha->optrom_mutex);
> +	rval =3D qla29xx_mpi_optrom_setup(bsg_job, vha, lmcmd->mpi_address, 0);

Conversely, this function is meant for loading but passes is_update=3D0, pu=
tting
the optrom into the QLA_SREADING state.

[ ... ]
> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +			    bsg_job->reply_payload.sg_cnt,
> +			    ha->optrom_buffer,
> +			    ha->optrom_region_size);
> +
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
> +}

[Severity: High]
Can this cause a double completion of the bsg_job?

If qla29xx_mpi_optrom_data() fails, rval is set to an error code
(e.g., -EINVAL). The function calls bsg_job_done() directly to complete
the request, but then returns the non-zero rval to the caller.

The caller (qla2x00_process_vendor_specific) passes this non-zero return va=
lue
up to the BSG layer. If a handler returns a non-zero error, the transport
layer's error path will typically call bsg_job_done() a second time on the
same job, which can lead to list corruption or a use-after-free.

Should this return 0 instead of rval, or avoid calling bsg_job_done() when
returning an error? (Note that qla2900_bsg_dump_mpi() safely returns 0).

> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_su=
p.c
> index c30ec9cab7bba..3b0a0cfe361dd 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
[ ... ]
> +		if (op =3D=3D QLA29XX_MPI_OP_DUMP) {
> +			options |=3D (BIT_0);
> +			options |=3D opts;
[ ... ]
> +			memcpy(dcode, fwcode, burst * 4);
> +
> +			rval =3D qla29xx_load_dump_mpi(vha, options, mpi_addr, burst,
> +						     optrom_dma);

[Severity: High]
Does QLA29XX_MPI_OP_DUMP actually perform a load? It copies the host buffer
(fwcode) to the DMA buffer (dcode) before issuing the mailbox command, which
sends data to the device.

> +		} else if (op =3D=3D QLA29XX_MPI_OP_LOAD) {
> +			options |=3D opts;
[ ... ]
> +			rval =3D qla29xx_load_dump_mpi(vha, options, mpi_addr, burst,
> +						     optrom_dma);
[ ... ]
> +			memcpy(fwcode, dcode, burst * 4);
> +		}

And conversely, OP_LOAD issues the mailbox command first and then copies
data from the DMA buffer to the host buffer, which performs a dump from the
device. Should the DUMP and LOAD implementations be swapped?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D8
