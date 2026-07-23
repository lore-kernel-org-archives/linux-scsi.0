Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB0E40DB23
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 20:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784837807; cv=none; b=mxnw343oTwl22l1JzTMLyqLNFogHOSq/vK73nsu33iQU60dzCY6Zp7rQlPhFHxbFqfxDaA6G+og+gTw8Y2RuRhx1Y9ab8o1tWQjeHfpJmgd4c966+DxScqRW9wusXk0ihJHwa78I1PxiMHDmd3RRxmKF4N7EpTad7Tm1MyUbfGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784837807; c=relaxed/simple;
	bh=c4MNdXD4sMCxWMJYnH+4c19dNwT27RqWQPPmXi5pUC0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BwLd+RHI0eZN+mqarbvFNuNkQgKcakT8BUpJBHPdV33Blb28LsjuBQ/mEN5DdPXukWq/rfx6Gy1Rnun1GteaqOkdv8kVD9BrPiT/uupHYRoMb0ZKWhZkDXhCP5GUVDVvWKLUMAs4nziy0jKzMenSRO1Rklurcl/7ovGMRddPjRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Du0Hj4kc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Du0Hj4kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6162E1F000E9;
	Thu, 23 Jul 2026 20:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784837780;
	bh=MjP424qfW+Oxfbf74K2b4HrhBzRviXH3rO5/JkQN3TU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Du0Hj4kcI4YvjvKNypS6MjWKH/qyoRU7Zxine+a5hJTPXJDiLXIu7o99gL1IX8/Gu
	 DV36s4QPfHDkJXINGTmG10cJW/eIaTc7MX8xHoX8CDn2u4fC0eguJPwiNUJbCStaEj
	 xvZuTl9dVZXPTtwzOgIlvjsSWsAwnbmpNPxdVpMiWt/O5svxf6GgBgV/f3rrSoB+NL
	 yy+rrAhzGIxRmUsGbdYZ0jh5kZ2zJD8bVvkmd4r4++P7mUc3++H9cLeJjWtLFgVym9
	 agcVYyX1U7Vu1+4TguccU5xlIYT4+27iBhTiPM506OsDLX8fY5IYlDumx2Gui1OSyZ
	 gTCV+zeRJhawQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 55/56] scsi: qla2xxx: Bound image count in
 qla2x00_update_fru_versions()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-56-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-56-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 20:16:19 +0000
Message-Id: <20260723201620.6162E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Heap and stack buffer overflows due to unvalidated length in I2C B=
SG handlers.
- [Medium] Missing payload length check against user input in FRU update/re=
ad/write functions.
- [Medium] Uninitialized heap memory leak to device in SFP write operations.
--

--- Patch [55]: [PATCH v6 55/56] scsi: qla2xxx: Bound image count in qla2x0=
0_update_fru_versions() ---
commit cda96c9f52838a031ce5bc0e9a6594ece5956c88
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()

This commit rejects BSG requests in qla2x00_update_fru_versions() where the=
=20
declared count does not fit in the 256-byte stack buffer. This prevents a=20
stack out-of-bounds read that could be sent to the device.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 76c57e574c220..f9b693af8db10 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1991,6 +1991,13 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_jo=
b)
> =20
>  	image =3D list->version;
>  	count =3D list->count;
> +
> +	if (struct_size(list, version, count) > sizeof(bsg)) {
> +		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D
> +		    EXT_STATUS_INVALID_PARAM;
> +		goto dealloc;
> +	}
> +

[Severity: Medium]
This is a pre-existing issue, but does this function also need to validate
the actual request payload length?

If a local user issues a request with a payload smaller than the required
struct sizes, sg_copy_to_buffer() only copies the provided bytes, leaving
the rest of the stack buffer bsg uninitialized:

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_update_fru_versions() {
    ...
    sg_copy_to_buffer(bsg_job->request_payload.sg_list,
        bsg_job->request_payload.sg_cnt, list, sizeof(bsg));
    ...
}

The code then reads from this uninitialized memory (e.g. image->field_info)
and passes it to mailbox commands, leaking kernel stack memory to the
hardware device.

Can similar payload length validation issues occur in
qla2x00_read_fru_status() and qla2x00_write_fru_status() where
sg_copy_to_buffer() is also used?

>  	while (count--) {
>  		memcpy(sfp, &image->field_info, sizeof(image->field_info));

[Severity: Medium]
This isn't a bug introduced by this patch, but can this lead to an
uninitialized heap memory leak?

Earlier in qla2x00_update_fru_versions(), sfp is allocated via
dma_pool_alloc() from a 256-byte pool without zeroing it. Only 36 bytes of
user data are copied into sfp.

If the user sets image->field_address.option to include BIT_0 and sets the
first byte of field_info to 255, this length is overridden in
qla2x00_write_sfp():

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_write_sfp() {
    ...
    if (opt & BIT_0)
        len =3D *sfp;
    ...
}

Will the hardware then read 255 bytes from sfp, leaking 219 bytes of
uninitialized kernel heap memory to the device?

>  		rval =3D qla2x00_write_sfp(vha, sfp_dma, sfp,

[ ... ]

[Severity: High]
This is a pre-existing issue, but do the I2C BSG handlers have unbounded
length checks leading to overflows?

In qla2x00_write_i2c(), an unbounded user-controlled i2c->length is used in
a memcpy:

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_write_i2c() {
    ...
    memcpy(sfp, i2c->buffer, i2c->length);
    ...
}

If i2c->length is set to a large value (up to 65535), can this overflow the
256-byte heap allocation sfp and read out-of-bounds from the kernel stack?

Similarly, in qla2x00_read_i2c(), does passing an unvalidated length to
memcpy() overflow the 256-byte stack array:

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_read_i2c() {
    ...
    memcpy(i2c->buffer, sfp, i2c->length);
    ...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D55
