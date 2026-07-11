Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00589287247
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2026 15:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783783495; cv=none; b=pBq4eQyxivmpDV8QgQnsyTMrF3ZeL3dop4I/Ldl7PH0KG45EpyiB5HEmHLbo8Bjb9XJ966+OuZw4sCmGkoqIhEOiDbzOC2cTF4+CXwJJ+UbofRHpaCfje5t5vt8aC+YI5teWguRs1NBdNA/Opvrrx1X3FxxlrgLQ+5wuZV7rDbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783783495; c=relaxed/simple;
	bh=Tkl5jx0+OUs/vYITNcrJ49a8tbOye5m55RutD8Il+Bg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pD9yHhZGv8hj9TWPLPrVTiHxPCIVE7lRUHLHmPCq/MwNECuBfzBtypOoqbidfryHMEg+YOnHikzCdlTbN0m16//bfpU69GhTARStx9uAQOYV6xa5iuFP+jt3kKEulicP9fBtxa5+ZXa9sN+rIAXWiMj6xkTDTbnj8fHjIRTkgeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSb3IlfQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSb3IlfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19B41F000E9;
	Sat, 11 Jul 2026 15:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783783493;
	bh=8Cl4wMZgX64YPY4Gzuf5SxjqoLPswzi3NIKrz/aD1n0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mSb3IlfQqio7ZBq+KEq7qR0d3uNEbzUnMwdbopqgAPZQsaNuhsvP0S2ttmi5nM0cw
	 Q/386hnw5xUcUEyDqIMPs9Uy7WUAJxIv2x2fG2wuDf8JEqWzY16zkiXyDlmkvhyW7W
	 XGo28tAyuoCdtSZwIGlbM0Sg9IRquqRDKB589pdGFOnw2Vrui15/HhTandUFnVlWOL
	 ML/8JGSRUbfinM3rJ35VBAeVTfZtCsSjzL2sFNzklL726dgHxCiODI+99u3BYOhnos
	 BIMzjgV/Dy22b6zJD8eBOJ777wWt/OmbH0Ut3IYjN0Z67f6n7v2zJouNRKLSY+HuhG
	 TpLjSfYIBdROw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: sd: bound the IO hints descriptor walk to the
 buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Bommarito" <michael.bommarito@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260711150736.2917641-1-michael.bommarito@gmail.com>
References: <20260711150736.2917641-1-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 11 Jul 2026 15:24:53 +0000
Message-Id: <20260711152453.B19B41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The stack-allocated `buf` in `sd_is_perm_stream()` is not zero-ini=
tialized, and its residual length is not checked after `scsi_execute_cmd()`=
, leading to a use of uninitialized stack memory.
- [Medium] The loop bounds calculation double-counts the mode header length=
 and relies on an unaligned ALIGN_DOWN relative to the buffer, causing the =
loop to evaluate a truncated descriptor that overhangs the allocated buffer=
, and generate an out-of-bounds pointer (Undefined Behavior).
--

--- Patch [1]: [PATCH] scsi: sd: bound the IO hints descriptor walk to the =
buffer ---
commit 536deb268b96e3b10a547fc2087216469f8c3827
Author: Michael Bommarito <michael.bommarito@gmail.com>

scsi: sd: bound the IO hints descriptor walk to the buffer

This commit attempts to fix an out-of-bounds read in sd_read_io_hints() by
clamping the device-reported mode data length to SD_BUF_SIZE. This prevents
the descriptor walk from reading past the buffer when parsing permanent-str=
eam
IO hints.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 599e75f333343..eec383cbc39f1 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3304,6 +3304,7 @@ static void sd_read_io_hints(struct scsi_disk *sdkp=
, unsigned char *buffer)
>  	struct scsi_sense_hdr sshdr;
>  	struct scsi_mode_data data;
>  	int res;
> +	u32 len;
> =20
>  	if (sdp->sdev_bflags & BLIST_SKIP_IO_HINTS)
>  		return;
> @@ -3313,9 +3314,17 @@ static void sd_read_io_hints(struct scsi_disk *sdk=
p, unsigned char *buffer)
>  			      sdkp->max_retries, &data, &sshdr);
>  	if (res < 0)
>  		return;
> +	/*
> +	 * The device-reported mode data length can exceed the buffer that
> +	 * was actually transferred; clamp it so the descriptor walk stays
> +	 * within buffer[SD_BUF_SIZE].
> +	 */
> +	if (data.length > SD_BUF_SIZE - data.header_length)
> +		len =3D SD_BUF_SIZE;
> +	else
> +		len =3D data.header_length + data.length;
>  	start =3D (void *)buffer + data.header_length + 16;
> -	end =3D (void *)buffer + ALIGN_DOWN(data.header_length + data.length,
> -					  sizeof(*end));
> +	end =3D (void *)buffer + ALIGN_DOWN(len, sizeof(*end));

[Severity: Medium]
This isn't a bug introduced by this patch, but does this calculation
double-count the mode header length and result in an overhanging pointer?

Looking at scsi_mode_sense(), it populates data.length with the total length
of the mode parameter list, which already includes the header. Computing
len =3D data.header_length + data.length overestimates the valid data size =
by
8 bytes.

Additionally, if len is clamped to SD_BUF_SIZE (512) and start is at offset
24, the descriptors (16 bytes each) fall at offsets 24, 40, ..., 504. Becau=
se
end is calculated as buffer + ALIGN_DOWN(len, sizeof(*end)), end will be
buffer + 512.

The loop condition desc < end will evaluate to true for the descriptor at
offset 504 (since 504 < 512). This descriptor spans bytes 504-519,
overhanging the 512-byte buffer limit. The loop evaluation of desc++ will
also produce a pointer past the end of the buffer.

>  	/*
>  	 * From "SBC-5 Constrained Streams with Data Lifetimes": Device severs
>  	 * should assign the lowest numbered stream identifiers to permanent
>  	 * streams.
>  	 */
>  	for (desc =3D start; desc < end; desc++)
>  		if (!desc->st_enble || !sd_is_perm_stream(sdkp, desc - start))

[Severity: High]
This is a pre-existing issue, but does sd_is_perm_stream() use uninitialized
stack memory if the device returns a short transfer?

Looking at sd_is_perm_stream():

drivers/scsi/sd.c:sd_is_perm_stream() {
...
	struct {
		struct scsi_stream_status_header h;
		struct scsi_stream_status s;
	} buf;
...
	res =3D scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, &buf, sizeof(buf),
			       SD_TIMEOUT, sdkp->max_retries, &exec_args);
...
	if (get_unaligned_be32(&buf.h.len) < sizeof(struct scsi_stream_status))
		return false;
	return buf.s.perm;
}

The stack-allocated buf is not zero-initialized. If a device completes the
command with a GOOD status but transfers fewer bytes than requested (for
example, only the 8-byte header), scsi_execute_cmd() does not check the
residual length here.

If the device-controlled buf.h.len field is large enough to pass the check,
the function will evaluate and return buf.s.perm, leaking uninitialized
kernel stack memory into the disk's permanent stream configuration.

>  			break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260711150736.2917=
641-1-michael.bommarito@gmail.com?part=3D1
