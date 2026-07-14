Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBB83D2FF7
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 18:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784053308; cv=none; b=KmEnrC/P0zU8inIAPqxfJnBUUCe1Yhwf0yvUnI818SiQwZ13sKqMY20XFheIBGbj6eZbzFDGq2Tc+nPUn7Uo8CEd+GsE8lewDW+NwgEIvgmFLayyHPA4u7zItZXg/4lJwapx0arjHC7NCu2HAsJHpaiCYLoYD3z5VrUOvrmwJCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784053308; c=relaxed/simple;
	bh=ec+USIxv0vVlzAoliMbweVst8BXxKuzHEwgFU/jMfIc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gsj6Az+A3pN/KLinBhASbvegp8UFAtioRPUPK8ehRuzrjMr4yyXzGF94CD1tHuNFiF3DWFFxRcgPGpFOjqvQ97/ck1qaW7hW3dymhY0N1OHKEYhJSr6StAefnTLxtHL7a+S88Z/wdwF4A+JkpZxmhsIYRROVXWevx7xAmmJYDzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2IIG3nU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2IIG3nU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCBB1F00A3A;
	Tue, 14 Jul 2026 18:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784053305;
	bh=lFLIM704g85dlQ2F7cuWA8PWDD8gBXeYafjIYrxLMa8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L2IIG3nUUgV1mW6ku6tbDF1RVj98fswIJswvp807REh19Gd9nlT6IHkLGjuB9HXcw
	 vOjwIBYorFREzaxEosrwNhgKgUXQQSUEaZBBMNOke9usAbSSXq907XVETZmqDAZ333
	 7L7GmVy/XHgEOsHm+5nhGKPrTkYWUysyg9isGIGdDHEPPpPSBCAdy4PBhQgzB4lEwB
	 t40eN9p152oxtuYfSOg5iyJgvf34yEcp++RWO/OR92j8Pv/3uYI0w+9f01ySW7Bixy
	 irssAgEpE32g1+kDaF8/UxyX20xAt0ayWGR/ZYcExe3Md/k2huiMYkD965NYD588sB
	 AoI1AsklwL7Ow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 55/56] scsi: qla2xxx: Bound image count in
 qla2x00_update_fru_versions()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-56-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-56-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 18:21:45 +0000
Message-Id: <20260714182145.7CCBB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing bounds check on user-controlled `i2c->length` field causes=
 stack and heap buffer overflows.
- [High] Kernel stack memory disclosure to userspace via short payloads.
- [Medium] Uninitialized stack memory sent to device due to unverified payl=
oad length.
- [Medium] Uninitialized DMA pool memory leaked to device via length overri=
de.
--

--- Patch [55]: [PATCH v4 55/56] scsi: qla2xxx: Bound image count in qla2x0=
0_update_fru_versions() ---
commit 57c2acf420006763090ae734727bc12044491697
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()

qla2x00_update_fru_versions() copies the user-supplied BSG request into
a fixed 256-byte stack buffer (bsg[DMA_POOL_SIZE]) and then iterates
list->count times over the qla_image_version array embedded in that
buffer, advancing the image pointer each iteration. count is taken
directly from user input with no upper bound, while only
(DMA_POOL_SIZE - sizeof(list->count)) / sizeof(struct qla_image_version)
=3D 6 entries actually fit. A larger count walks the image pointer off the
end of the stack buffer, reading adjacent kernel stack memory and
sending it to the device via qla2x00_write_sfp().

Reject requests whose declared count does not fit in the buffer.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 2f73c9af418d7..95cfdb020319d 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2043,6 +2043,13 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_jo=
b)
> =20
>  	image =3D list->version;
>  	count =3D list->count;
> +
> +	if (struct_size(list, version, count) > sizeof(bsg)) {

[Severity: Medium]
This isn't a bug introduced by this patch, but does this bounds check verify
the actual user-provided payload length?

sg_copy_to_buffer() only copies the bytes provided by the user payload. Whi=
le
this check verifies count against the bsg buffer capacity, if a short paylo=
ad
is provided, the rest of the bsg array remains uninitialized.

> +		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D
> +		    EXT_STATUS_INVALID_PARAM;
> +		goto dealloc;
> +	}
> +
>  	while (count--) {
>  		memcpy(sfp, &image->field_info, sizeof(image->field_info));

[Severity: Medium]
This isn't a bug introduced by this patch, but can this loop copy uninitial=
ized
portions of the bsg stack array?

If a short request is provided, the bsg array contains uninitialized data
which is then copied into sfp and passed to the device.

[Severity: Medium]
This isn't a bug introduced by this patch, but does the dma_pool_alloc() ca=
ll
earlier in qla2x00_update_fru_versions() leak uninitialized DMA pool memory?

The sfp buffer is allocated via dma_pool_alloc() without GFP_ZERO. Only 36
bytes of user data are copied into this 256-byte buffer.

In qla2x00_write_sfp(), if the user sets BIT_0 in image->field_address.opti=
on:

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_write_sfp()
    if (opt & BIT_0)
        len =3D *sfp;

This overrides the write length with the first byte of user data. A user co=
uld
set this to 255, causing the firmware to DMA-read up to 219 bytes of
uninitialized kernel DMA pool memory and sending it to the device.

[Severity: High]
This isn't a bug introduced by this patch, but could an unchecked i2c->leng=
th
field cause a buffer overflow in qla2x00_write_i2c() and qla2x00_read_i2c()?

In qla2x00_write_i2c():

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_write_i2c()
    memcpy(sfp, i2c->buffer, i2c->length);

The i2c->length field is extracted from the user payload without bounds
checking and executes unconditionally before calling the firmware. Since sfp
is a 256-byte allocation and bsg is a 256-byte stack array, a length > 256
could cause a kernel stack out-of-bounds read and a heap out-of-bounds writ=
e.

Similarly, qla2x00_read_i2c() might suffer a stack out-of-bounds write when
calling memcpy(i2c->buffer, sfp, i2c->length).

[Severity: High]
This isn't a bug introduced by this patch, but can short payloads cause
qla2x00_read_fru_status() and qla2x00_read_i2c() to disclose kernel stack
memory to userspace?

These functions allocate a 256-byte uninitialized stack array and use
sg_copy_to_buffer() to populate it from the user request payload. If the
payload is short, the rest of the struct is left uninitialized.

Upon success, sg_copy_from_buffer() copies the full sizeof(*sr) or
sizeof(*i2c) to the reply payload:

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_read_fru_status()
    sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
        bsg_job->reply_payload.sg_cnt, sr, sizeof(*sr));

Could this directly leak uninitialized kernel stack data to userspace?

>  		rval =3D qla2x00_write_sfp(vha, sfp_dma, sfp,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D55
