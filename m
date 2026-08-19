Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5916223909C
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 03:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787110521; cv=none; b=lu7XzqIFAXY4tvbmNvvImv1AKXyugfjX7nn4phYAEo526Mo3L1C4rJYQFrUewO1ca1tRtk867n7hVV0OgSsCkPzKiwUSNIPVCUilpl/PfTLbL2yMhFyVmRXhpmHCOnPxyJKC2hhYkpfi8T2vEOTZuBmQ7Ow/LExMv0iZAzV1HhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787110521; c=relaxed/simple;
	bh=ByKzBr+vWx4mWj6XQCpl01zbFxDmZyMxYl4AbZP3Vc8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AdXCrLsUJH3mSvZpPfvTuuAEVbGeyfEJ+EW/tNFXw9zHG+imUA2pa2uAHTOdLDJgw6WVcxAEmG+euEwqE0JFA1fW87akkzUIYC8JLYfywpDkOUyb4RgB9EEwRUqA7IByIkNGiWhtBOxs4sEqYlTjKehBAMw0Am2IpK1R7POnPMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFRApcMy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFRApcMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDC81F000E9;
	Wed, 19 Aug 2026 03:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787110520;
	bh=9XSExiAFeLvUv8uMm2RNUSiniT6XDZ3DlYGHoG06ePc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BFRApcMyzPiwxgRbzAyilV1Ne+WnpsFFELhQh8bDbi1Ai40A0oiEeiUvT/iuxuWAN
	 FzsPdHgeFp5btikEUDe1F1+qUqYJpxmNpnAbXPrCdkJb/mxvAxFuXyEj9d+8uhB4ty
	 9Yhd5/nzveIFw8Qw8wE8HBTw9ON0FKEQBc7ac9JKfOW/OIl79326xloI44YDdKeXLz
	 j65hhX3iXPJywgHjDeyfCJoMLF8YtauyBu5ksIXWSeqnAGhVANbV8FJxQ8H0ORki8u
	 KLDMoB7gSxMvmzw0KNNLHyDalcD6jqUKG1qn1td6Yql7eYLf6AfWTjhSE/gtG7N0XA
	 dlfy7NeFd7F9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: bound VPD identifier formatting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Amirkan" <markdamirkan@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260819-pscsi-vpd-ident-bounds-v1-1-ba28dcb0af08@gmail.com>
References: <20260819-pscsi-vpd-ident-bounds-v1-1-ba28dcb0af08@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 03:35:19 +0000
Message-Id: <20260819033519.DEDC81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] pscsi_get_inquiry_vpd_device_ident() lacks bounds checking against=
 the allocated buffer size when parsing VPD Identification descriptors.
- [High] Leaked bios in pscsi_execute_cmd() error path.
- [Medium] Missing NUL-termination enforcement in pscsi_get_inquiry_vpd_ser=
ial() leads to an out-of-bounds read via unbounded snprintf().
--

--- Patch [1]: [PATCH] scsi: target: bound VPD identifier formatting ---
commit 63526716e874620c72b9c2ea7622a0eea0ce5c5e
Author: Mark Amirkan <markdamirkan@gmail.com>

scsi: target: bound VPD identifier formatting

This patch adds bounds checking to transport_set_vpd_ident() when
formatting device-provided VPD page 0x83 identifiers into the fixed-size
t10_vpd::device_identifier array. It rejects binary, ASCII, and UTF-8
identifiers that exceed the allocation limits to avoid writing past the
296-byte boundary.

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
> index dcfe945949167..26a0bb66c2530 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1335,6 +1335,14 @@ transport_set_vpd_ident(struct t10_vpd *vpd, unsig=
ned char *page_83)
>  	vpd->device_identifier_code_set =3D (page_83[0] & 0x0f);
>  	switch (vpd->device_identifier_code_set) {
>  	case 0x01: /* Binary */
> +		/*
> +		 * Reserve one character for the type and one for the NUL;
> +		 * each binary byte expands to two hex characters.
> +		 */
> +		if (page_83[3] >
> +		    (sizeof(vpd->device_identifier) - 2) / 2)
> +			return -EINVAL;
> +
>  		vpd->device_identifier[j++] =3D
>  				hex_str[vpd->device_identifier_type];
>  		while (i < (4 + page_83[3])) {
> @@ -1344,11 +1352,16 @@ transport_set_vpd_ident(struct t10_vpd *vpd, unsi=
gned char *page_83)
>  				hex_str[page_83[i] & 0x0f];
>  			i++;
>  		}

[Severity: High]
This isn't a bug introduced by this patch, but does the caller pass a prope=
rly
bounded page_83 pointer into this function?

Looking at pscsi_get_inquiry_vpd_device_ident() in target_core_pscsi.c, the=
 loop
blindly advances the buffer offset using unvalidated lengths from the devic=
e:

drivers/target/target_core_pscsi.c:pscsi_get_inquiry_vpd_device_ident() {
    ...
    page_len =3D get_unaligned_be16(&buf[2]);
    while (page_len > 0) {
        page_83 =3D &buf[off];
        ident_len =3D page_83[3];
    ...
}

If page_len or ident_len exceed the 254-byte allocation limit for buf, coul=
dn't
the while loop here in transport_set_vpd_ident() read out-of-bounds heap
memory when accessing page_83[i]?

[ ... ]

While reviewing the VPD handling, I also noticed a couple of other pre-exis=
ting
issues in the related target_core_pscsi.c code:

[Severity: Medium]
This is a pre-existing issue, but is there a risk of an out-of-bounds read
in pscsi_get_inquiry_vpd_serial() when parsing an untrusted buffer?

drivers/target/target_core_pscsi.c:pscsi_get_inquiry_vpd_serial() {
    ...
    snprintf(&wwn->unit_serial[0], INQUIRY_VPD_SERIAL_LEN, "%s", &buf[4]);
    ...
}

If a device returns 254 bytes of non-NUL characters for the INQUIRY respons=
e,
won't the %s format specifier cause snprintf() to read past the end of the
254-byte buf allocation up to the INQUIRY_VPD_SERIAL_LEN limit?

[Severity: High]
This is also a pre-existing issue, but does the error path in
pscsi_execute_cmd() leak bio structures?

drivers/target/target_core_pscsi.c:pscsi_execute_cmd() {
    ...
    if (scmd->cmd_len > sizeof(scmd->cmnd)) {
        ret =3D TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
        goto fail_put_request;
    }
    ...
fail_put_request:
    blk_mq_free_request(req);
    return ret;
}

If pscsi_map_sg() successfully maps the scatterlist and allocates bios via
bio_kmalloc() attached to req->bio, and then the subsequent CDB length check
fails, doesn't blk_mq_free_request() free the request state without freeing=
 the
attached bios? Could an unprivileged remote initiator repeatedly send
variable-length CDBs greater than 32 bytes to trigger this path and exhaust
memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819-pscsi-vpd-=
ident-bounds-v1-1-ba28dcb0af08@gmail.com?part=3D1
