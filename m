Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E65362157
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 10:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784026760; cv=none; b=kgyfWAcOQS0ywCAARwWSkTXqwP2ZIuXWqsZTk4cwmptCK/hhyGKMe5tukf/dN4awauhKKWGdqXnWrmZ9bl47ZYnPXzuJSbQbdA8mDm9dG0osjZdUHikbWU3ccmYBI2WZFHyb1zOcIkn5imSKkUdVN0QDFU7E1AXEiueJLqFpsjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784026760; c=relaxed/simple;
	bh=DvSioF67pWhDTlPPaObDwhAs40d07A3sIG+iAAQhQ0w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gWMS+2MTUbNfFjTP6Wt3JX/YfMvMPwFFxzsPvlV3jyq8udH27GWkzryPkrpDzRzLuKkP3BExO2SHap7r1hkTPix6rrM8zjBhsJPA0GhF4PmeMKfhbpH+KzmpoMTPTVQ7VI8igKUJ35n7TpbVZTkj+eJvtJ4HHAI+DhdSrKPcChw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GC4r/RGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GC4r/RGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15471F000E9;
	Tue, 14 Jul 2026 10:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784026758;
	bh=BVEAQLB/fAF2mNfHGAvp/zpxCs4w531HSxloQcGA7B8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GC4r/RGRVdCmyW6vcFCQAvZ2+Z/RTtxrYTId8E4PpOmIYBSGzF7FWzjQPzzqo9W2u
	 6mCOBy0CzB9wkttMgLwg4Wvkj0sfJXsXeqOTdNPt9ca2VnedpfhYCgmW5IRG9gzDni
	 j46dJ3PQOKOYRiVQrl5MA7a95JnXogHvCCEs3BYyUi8F2mTczU5ovactVn92aipHzG
	 FW2QOkDNn/pxMQS/K1HukgI7RB/aESkX1TDniFobPtEk5WXEPXc+nUwc+AWip4Ajsn
	 zBprSjWtOSF53VjAHz+YKPQ4AOk3F6Sw1IELarmSURNc9okV3CxlfgT9aN6qwO3cC5
	 UuF0NJpCEvupg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 08/56] scsi: qla2xxx: Add BSG MPI firmware load/dump
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-9-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-9-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 10:59:17 +0000
Message-Id: <20260714105918.B15471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Returning a non-zero error code from `qla2900_bsg_load_mpi()` afte=
r explicitly calling `bsg_job_done()` leads to a double completion of the b=
lock request.
- [High] The implementations for the LOAD and DUMP MPI commands are perfect=
ly inverted, leading to unintended firmware overwrite or data discard.
--

--- Patch [8]: [PATCH v4 08/56] scsi: qla2xxx: Add BSG MPI firmware load/du=
mp for 29xx ---
commit 472cec56cca22244e315ce21a1660801bbbc160d
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add BSG MPI firmware load/dump for 29xx

This patch adds BSG vendor commands for loading and dumping MPI firmware on
29xx adapters. It extends the existing BSG infrastructure with the necessary
mailbox wrappers and flash helpers for MPI operations.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 92a1af81c057f..5dd7e5e969ab0 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1820,6 +1820,203 @@ static int qla29xx_bsg_flash_block_write(struct b=
sg_job *bsg_job)

[ ... ]

> +static int qla2900_bsg_dump_mpi(struct bsg_job *bsg_job)
> +{
> +	struct fc_bsg_request *bsg_req =3D bsg_job->request;
> +	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
> +	struct Scsi_Host *host =3D fc_bsg_to_shost(bsg_job);
> +	scsi_qla_host_t *vha =3D shost_priv(host);
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct qla_load_dump_mpi *dmcmd;
> +	uint16_t opts =3D 0;
> +	int rval =3D 0;
> +
> +	if (bsg_job->request_len < sizeof(struct fc_bsg_request) +
> +	    2 * sizeof(uint32_t) + sizeof(struct qla_load_dump_mpi))
> +		return -EINVAL;
> +
> +	if (!IS_QLA29XX(ha)) {
> +		ql_log(ql_log_warn, vha, 0x706c,
> +		       "%s: MPI dump not supported on this adapter.\n",
> +		       __func__);
> +		return -EINVAL;
> +	}
> +
> +	dmcmd =3D
> +	(struct qla_load_dump_mpi *)&bsg_req->rqst_data.h_vendor.vendor_cmd[2];
> +
> +	ql_log(ql_log_info, vha, 0xffff,
> +	       "%s: mpi_address 0x%x mpi options 0x%x length 0x%x\n",
> +		__func__, dmcmd->mpi_address, dmcmd->options, dmcmd->length);
> +
> +	mutex_lock(&ha->optrom_mutex);
> +	rval =3D qla29xx_mpi_optrom_setup(bsg_job, vha, dmcmd->mpi_address, 1);
> +	if (rval) {
> +		mutex_unlock(&ha->optrom_mutex);
> +		return rval;
> +	}
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +			  bsg_job->request_payload.sg_cnt, ha->optrom_buffer,
> +			  ha->optrom_region_size);

[Severity: High]
Are the implementations for the DUMP and LOAD MPI commands inverted here?

In drivers/scsi/qla2xxx/qla_bsg.c:qla2900_bsg_dump_mpi(), this path configu=
res
the operation as a write (is_update=3D1) and takes data from the user's
request_payload. This matches the behavior of a firmware load, which could
inadvertently write uninitialized or incorrect data to the device when a us=
er
is attempting to dump the firmware.

[ ... ]

> +static int qla2900_bsg_load_mpi(struct bsg_job *bsg_job)
> +{
> +	struct fc_bsg_request *bsg_req =3D bsg_job->request;
> +	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
> +	struct Scsi_Host *host =3D fc_bsg_to_shost(bsg_job);
> +	scsi_qla_host_t *vha =3D shost_priv(host);
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct qla_load_dump_mpi *lmcmd;
> +	uint16_t opts =3D 0;
> +	int rval =3D 0;
> +
> +	if (bsg_job->request_len < sizeof(struct fc_bsg_request) +
> +	    2 * sizeof(uint32_t) + sizeof(struct qla_load_dump_mpi))
> +		return -EINVAL;
> +
> +	if (!IS_QLA29XX(ha)) {
> +		ql_log(ql_log_warn, vha, 0x706d,
> +		       "%s: MPI load not supported on this adapter.\n",
> +		       __func__);
> +		return -EINVAL;
> +	}
> +
> +	lmcmd =3D
> +	(struct qla_load_dump_mpi *)&bsg_req->rqst_data.h_vendor.vendor_cmd[2];
> +
> +	ql_log(ql_log_info, vha, 0xffff,
> +	       "%s: mpi_address 0x%x mpi options 0x%x length 0x%x\n",
> +		__func__, lmcmd->mpi_address, lmcmd->options, lmcmd->length);
> +
> +	mutex_lock(&ha->optrom_mutex);
> +	rval =3D qla29xx_mpi_optrom_setup(bsg_job, vha, lmcmd->mpi_address, 0);
> +	if (rval) {
> +		mutex_unlock(&ha->optrom_mutex);
> +		return rval;
> +	}
> +
> +	check_and_set_mbc_bits(lmcmd->options, opts, QLA_LDM_SECURE_ENABLE,
> +			       BIT_3);

[Severity: High]
Does this execute a read/dump flow during a load command?

In drivers/scsi/qla2xxx/qla_bsg.c:qla2900_bsg_load_mpi(), the function
configures the operation as a read (is_update=3D0) and later copies data to
the user's reply_payload. This behaves like a dump instead of a load, causi=
ng
the firmware image provided by the user to be discarded rather than written=
 to
the device.

[ ... ]

> +	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);
> +
> +	return rval;
> +}

[Severity: High]
Does this code risk a double completion of the block request?

If qla29xx_mpi_optrom_data() fails and sets an error code in rval, this path
calls bsg_job_done() and then returns the non-zero rval.

When a BSG vendor-specific request handler returns a non-zero value, the SC=
SI
FC transport layer (fc_bsg_host_dispatch) assumes the driver rejected the
request and falls back to completing the job itself. Since bsg_job_done() w=
as
already called, this could complete the same block request twice, which cou=
ld
lead to a use-after-free or list corruption.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D8
