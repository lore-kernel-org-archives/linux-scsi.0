Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E5639447C
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 03:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784518645; cv=none; b=MyPQZOD87a1VKbW/u8mLP/uP8ecHBkGT34VY8/PVn1cErgbGFO84A1MMxxIpuZgM2DbJEFIU+JX7LNCx5KTq16KIE0b3sqQzrrUouaimxD863Au01XCsjGISWB1hUr/IVVQ6Q8nupAZ7G6Tl68wvb3e0+lfKI9Jv+DJ7djJtJl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784518645; c=relaxed/simple;
	bh=SRMenYkrKhzntruMh/mPaaCeZmV2FxLDYV7pK45Mo3E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ij96udaROIgbDg7z1YErNkeo6OjJOQTuJBPCzmjENl16a2T1kGgmUjjwAj58AM702v2tC16u+nmUfqZPXnq6tl+pJb80zySW4FtB2t86rjcE49MNtpip7atFCBy8tgzPOCnNH+Wxv9xpmQbkligSnGJXJGOCNzyvX0+xutl1suE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tws9kav+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tws9kav+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BD81F000E9;
	Mon, 20 Jul 2026 03:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784518644;
	bh=gzppGsb5JhX7bO5T7cYPLfxu+gBfWpOIL9GTL/4WrPY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Tws9kav+VXNX1BbhZXaIwpaP0aaREwvqxH0t+vylJ8vF24Hb4BXWf+Biaf15ddEfh
	 Xrvg41bzmqOzYOc4ep/XfvmAwCCvJrpSCBFAUDh8j6XuiDNCzyy93ZyjEeJpC/VMvO
	 ZeUdhce2ewUKU8J5JNukBBITmPjv240dbcimO88DGreYM5vYpVmJwMvFb0W09v6xDB
	 HBfcsWs4oUVDV2gE2WlYe6irIHROwBjEaW85b/MhEm6qDZYAGYaoPL51hcKCY4XnKj
	 rQrzO2J3WY56kAIYDYcMRE3Ryzx7+hmroCYDtiKo0Dimu0gFbd+so68DFDZiB17gfG
	 1lX3gxhNvqCAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: bsg: fix TOCTOU in io_uring passthrough
 command setup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Xiuwei" <yangxiuwei@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260720032338.461681-2-yangxiuwei@kylinos.cn>
References: <20260720032338.461681-1-yangxiuwei@kylinos.cn>
 <20260720032338.461681-2-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 03:37:23 +0000
Message-Id: <20260720033724.24BD81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Kernel memory leak of uninitialized sense buffer bytes to user spa=
ce.
--

--- Patch [1]: [PATCH 1/2] scsi: bsg: fix TOCTOU in io_uring passthrough co=
mmand setup ---
commit bb53b6e06613a855cd8556487582a73b36038ec3
Author: Rahul Chandelkar <rc@rexion.ai>

scsi: bsg: fix TOCTOU in io_uring passthrough command setup

This commit fixes a TOCTOU vulnerability in scsi_bsg_uring_cmd() by snapsho=
tting
SQE fields with READ_ONCE() before validation and reuse. The stable map
arguments are then passed into scsi_bsg_map_user_buffer().

Link: https://lore.kernel.org/r/20260527105931.3950913-1-rc@rexion.ai

> diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
> index e80dec53174ea..c57ce01379de5 100644
> --- a/drivers/scsi/scsi_bsg.c
> +++ b/drivers/scsi/scsi_bsg.c
[ ... ]
> @@ -158,8 +164,14 @@ static int scsi_bsg_uring_cmd(struct request_queue *=
q, struct io_uring_cmd *iouc
>  	scmd->sense_len =3D cmd->max_response_len ?
>  		min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERS=
IZE;
> =20

[Severity: High]
This isn't a bug introduced by this patch, but does overwriting scmd->sense=
_len
with the maximum response size leak uninitialized kernel memory to user spa=
ce?

The SCSI midlayer expects sense_len to hold the actual valid length of the
sense data, but it is overwritten here with the user's max_response_len.

If a command fails, the low-level driver might populate a small amount of s=
ense
data (e.g., 18 bytes) without zeroing the rest of the buffer.

The completion handler in drivers/scsi/scsi_bsg.c retrieves this artificial=
ly
inflated sense_len to determine how many bytes to copy:

scsi_bsg_uring_task_cb() {
    ...
    if (pdu->response_addr)
        sense_len_wr =3D min_t(u8, scmd->sense_len,
                             SCSI_SENSE_BUFFERSIZE);
    ...
    if (copy_to_user(uptr64(pdu->response_addr), scmd->sense_buffer,
                     sense_len_wr))
    ...
}

Could this copy uninitialized trailing bytes from the reused sense_buffer to
user space?

> -	if (cmd->dout_xfer_len || cmd->din_xfer_len) {
> -		ret =3D scsi_bsg_map_user_buffer(req, ioucmd, issue_flags, gfp_mask);
> +	if (dout_xfer_len || din_xfer_len) {
> +		bool is_write =3D dout_xfer_len > 0;
> +		u64 buf_addr =3D is_write ? dout_xferp : din_xferp;
> +		unsigned long buf_len =3D is_write ? dout_xfer_len : din_xfer_len;
> +
> +		ret =3D scsi_bsg_map_user_buffer(req, ioucmd, issue_flags,
> +					       gfp_mask, is_write, buf_addr,
> +					       buf_len);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720032338.4616=
81-1-yangxiuwei@kylinos.cn?part=3D1
