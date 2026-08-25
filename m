Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E4E32E121
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673983; cv=none; b=EOxxVf/w91x+ATsB15jnSS3aR3cnrMENAT7B8oSYkVdz7phrozz/tVg3OkYdDgd2qdgrg4yLATi8b6jATqIICvTX9OBe09ikn7Nz7DfjSzKJrUq+58QENTkpcRk9psED5lmzTLdbkx4zeNGsucE/cEWGMbSeYQWvt9NqTN49M8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673983; c=relaxed/simple;
	bh=RMOy9f7bTwN/zdKcYsZlRtPtxvc0s0g/c/VcYMgz6oE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OJCw8ZpijOBjDrV8zdHNVmTFHM9bPA2c9Sh1vDDqy2STrVYCJ6stScItyGejU1ICSi1jfL94iZWPyHXbWGNDz+2hj59ye7qaxxAo0o/Q9W0oayqsbN304lPkXpDtaOp3Ml910W1hFvYinM9rFbqOs0voa6kjmon0+9mdxsP6+Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2z36OP6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2z36OP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A171F000E9;
	Tue, 25 Aug 2026 16:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673982;
	bh=6O6FVDHkUr4O9PAMFaJLhMFC2fwi+NVCvZD6wAI2Tn8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U2z36OP6VCfx27HJWsNbvOdbNVW9u8K0k3oucPtFVg2tQQqBafz+VTklkF2bIRONO
	 gRl7S71nP3CK/TM2jwS47EuZlcYpbD6nBUApaqiqEOd0/xpKjJ67hH27kX+lYcwjiS
	 qJfXpk/e7YeVAvkPYFvX2xptybKcbPpySX5VILpCcSwm8ntHACnUuyMDvjkGSJeK3O
	 VYT37DIfMwtU2ihwaXBseyv7wxNp9n0ALNAhv0LbzuTW9k1y748lf6xYldyrbGumfI
	 sqz0UekXWDcBEK0KFgNvw2gKWa7vVSw/jBc9GF8Mn+ryU8R4VV5q09HvsMQrVAxRg4
	 F0tZjWSfgNV7Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/17] mpi3mr: Fix out-of-bounds read when copying
 BSG MPI requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-3-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-3-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:06:21 +0000
Message-Id: <20260825160622.28A171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing bounds check on BSG request length enables out-of-bounds h=
eap reads.
- [High] Missing endianness conversions on MPI structures cause corruption =
on big-endian systems.
--

commit ab35632c4adcdd391fb038b2fa77fa3b546f692a
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds read when copying BSG MPI requests

The MPI request is copied out of the caller supplied payload without
first checking that the requested amount is actually present, so the
copy can read past the end of the payload buffer. Check the range
before copying.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 8e5d24793efd0..1cd1c38dcd565 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -2538,6 +2538,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg=
_job *job)
>  				rval =3D -EINVAL;
>  				goto out;
>  			}
> +			if (sgl_iter + mpi_msg_size >
> +			    dout_buf + job->request_payload.payload_len) {
> +				dprint_bsg_err(mrioc, "%s: MPI request buf exceeds dout_buf\n",
> +					       __func__);
> +				mutex_unlock(&mrioc->bsg_cmds.mutex);
> +				rval =3D -EINVAL;
> +				goto out;
> +			}

[Severity: High]
This is a pre-existing issue, but since this patch fixes bounds checks in
this function, is the initial loop bounded correctly against the user
allocation?

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds() {
    ...
    bufcnt =3D karg->buf_entry_list.num_of_entries;
    ...
    buf_entries =3D karg->buf_entry_list.buf_entry;
    ...
    for (count =3D 0; count < bufcnt; count++, buf_entries++, drv_buf_iter+=
+) {
    ...
}

A user-space process submitting an MPI command via mpi3mr_bsg_request could
provide a small request_len but a large, unchecked
karg->buf_entry_list.num_of_entries.

Does this code overflow buf_entries[] by reading from arbitrary adjacent
heap memory?


[Severity: High]
This isn't a bug introduced by this patch, but does this code cause corrupt=
ion
on big-endian systems?

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds() {
    ...
    dev_handle =3D tm_req->dev_handle;
    ...
}

And later in the same function:

drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds() {
    ...
    status_desc->ioc_status =3D mrioc->bsg_cmds.ioc_status;
    status_desc->ioc_log_info =3D mrioc->bsg_cmds.ioc_loginfo;
    ...
}

When an admin issues a SCSI Task Management BSG command, tm_req->dev_handle
(__le16) is directly assigned to dev_handle (u16) without le16_to_cpu(), and
native values are assigned to __le16/__le32 fields without cpu_to_le16/32().

Can this fail the mpi3mr_get_tgtdev_by_handle() lookup and corrupt the
response sent to user-space, bypassing the block_io increment and enabling
unsafe concurrent I/O during target reset?

>  			memcpy(mpi_req, sgl_iter, mpi_msg_size);
>  			break;
>  		default:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D2
