Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC45037E5CB
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784106018; cv=none; b=oaDj+usvRVonoDH/TfCVcjZ3DKXTg2xeMO2dN5OT03y6RtjozVySwoGe3+++QV0+qr+AH+LAeybaV066GcKOFX5C4wNWmKZmrcdLqTlbzq4SVJ0F1qkNtAbi9w0MHz82qnZsvjPSks4Sye+AN7g0PW6u5ZaIfyOVF2leI7H0Sls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784106018; c=relaxed/simple;
	bh=uoG56waQ8o6608eV8pKV1LNLFO9CEqlPYOydoyvqvcI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C3eeIhl+uRVIyVI2+MkQEcZf+7Na8Tyj2UArmsfo+S/MKRoLJqEA23tu70wSPZkMP+1WA0ejcu9MyJbFwDBotAqXOo4RFhudW8wsQqvvxQvm0DToTqdu7lCwutmqsnCpYGo+XgIYBAqXyWs7PetGhFQdzPTMt5VobGwfE/y8cZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSqRYOzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSqRYOzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FD11F000E9;
	Wed, 15 Jul 2026 09:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784106015;
	bh=z7tTZkeaxWo/++P3j/aNlCZPGPSjO5VezH08ZmTH5yM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MSqRYOzhnCn9HIQnBTgQo/M8JoR83xr6UjgaO4bJpucZZccNUZbaKkJERq8bvawzX
	 knj60ow9tfF45HSJLaXhb+hxpc3i5HYtluDSDxvQfoPAgCj3wRGHrzeMh//qugx6iY
	 d6HQp93qnPFtuk1hC4YicpzHv4is6H2gkcxeP9eYt2qAlPB/RHLwqOk+2arVxKDaWU
	 QdF5XMfp1frSigYLcduTP+bpi41dV5+zayuDajGTZwlD1QfdkG0P8W3WMMEschxHZe
	 pPQp4eQ+0xgOJn3ebCuY3aQSmqTOYzEqY+lltOlBSkpC9ey9d0ENhv58Xp7A4tM36O
	 uDKoY1lkhikAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: libfc: validate FCP response payload length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260715084548.45278-1-pengpeng@iscas.ac.cn>
References: <20260715084548.45278-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 09:00:14 +0000
Message-Id: <20260715090015.76FD11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Processing of FCP_SNS_LEN_VAL and FCP_RESID_UNDER blindly assu=
mes fsp->cmd is valid, leading to a NULL pointer dereference during malform=
ed Task Management Function (TMF) responses.
--

--- Patch [1]: [PATCH] scsi: libfc: validate FCP response payload length ---
commit 62a5c62c9541198f09e35c7317ed519450b54ee2
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

scsi: libfc: validate FCP response payload length

This commit adds bounds checking for FCP response payloads. It ensures
that the response-info and sense lengths declared by the device do not
exceed the current frame length, preventing out-of-bounds memory accesses.

> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> index 5121272f28fd8..7e4c3c152f5d2 100644
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c

[ ... ]

> @@ -869,6 +872,8 @@ static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struc=
t fc_frame *fp)
>  			if (flags & FCP_SNS_LEN_VAL) {
>  				snsl =3D ntohl(rp_ex->fr_sns_len);
>  				if (snsl > SCSI_SENSE_BUFFERSIZE)
>  					snsl =3D SCSI_SENSE_BUFFERSIZE;
> +				if (plen < sizeof(*fc_rp) + sizeof(*rp_ex) + respl + snsl)
> +					goto len_err;
>  				memcpy(fsp->cmd->sense_buffer,
>  				       (char *)fc_rp_info + respl, snsl);

[Severity: Critical]
This is a pre-existing issue, but does this code lead to a null pointer
dereference if a malformed Task Management Function response is received?

When fc_eh_device_reset() allocates an fsp for a LUN reset, it leaves
fsp->cmd as NULL and sets fsp->wait_for_comp =3D 1.

If a target responds with a frame where FCP_SNS_LEN_VAL is set but
FCP_RSP_LEN_VAL is clear, the early return for TMF completions is bypassed
and execution falls through to process sense data.

Because fsp->cmd is NULL in this path, will the memcpy() above crash when
attempting to access fsp->cmd->sense_buffer?

>  			}
>  		}
>  		if (flags & (FCP_RESID_UNDER | FCP_RESID_OVER)) {
>  			if (plen < sizeof(*fc_rp) + sizeof(rp_ex->fr_resid))
>  				goto len_err;
>  			if (flags & FCP_RESID_UNDER) {
>  				fsp->scsi_resid =3D ntohl(rp_ex->fr_resid);
>  				/*
>  				 * The cmnd->underflow is the minimum number of
>  				 * bytes that must be transferred for this
>  				 * command.  Provided a sense condition is not
>  				 * present, make sure the actual amount
>  				 * transferred is at least the underflow value
>  				 * or fail.
>  				 */
>  				if (!(flags & FCP_SNS_LEN_VAL) &&
>  				    (fc_rp->fr_status =3D=3D 0) &&
>  				    (scsi_bufflen(fsp->cmd) -
>  				     fsp->scsi_resid) < fsp->cmd->underflow)

[Severity: Critical]
This is a pre-existing issue, but similarly, if the response has
FCP_RESID_UNDER set but FCP_RSP_LEN_VAL clear, will checking
scsi_bufflen(fsp->cmd) and fsp->cmd->underflow also crash when fsp->cmd
is NULL?

>  					goto err;
>  				expected_len -=3D fsp->scsi_resid;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715084548.4527=
8-1-pengpeng@iscas.ac.cn?part=3D1
