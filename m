Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4A7284B4F
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 14:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788531126; cv=none; b=QfoD2+em+Wpn3ezs9bydf/gAPsPDIKtN6XyxHIRIJtJRdWlDh0vKnr0zsHyBBOzFBXktS63EKxmcruQi6a+8whZPFwwIwMiAuB5CxqFKjbhul77gPi7DEfPHm08ViDWRQ42kksJeHaxRWVLXUzPNVce0MzNOdWHECh40GvcGAkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788531126; c=relaxed/simple;
	bh=sVIiJUsV4gUnj10zvLr0oSo5mHecwTSXOOuD/ednUaA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HllSy359SgV8j1XXnJMCRDOmbzBaCvOdkn1tgbialekppMvYfj7s/rJ0Vvs8XQk0p/GAaaRsxX2s9OIaTY1Z15N0cMi0wF4dyyv2q2sv9L1SaSo9JZ46ufniNZ6IXKftaudS5XimMmg/qtgaytz4N1bk6haNG8gJVWKVPmWqRZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TP8e1F6K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TP8e1F6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2C81F00A3E;
	Fri,  4 Sep 2026 14:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788531124;
	bh=9Hl5fyuf4miK2tyycryA3NuE6wny37dyg09g4NLb0CU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TP8e1F6KOykEUUK0YcYKSz0sv9gf7YhrDQrJSn7bHVbmqhch7U6y8GFIJPJ5o1Nd6
	 kRcz9TvyiUCSvtp3cgNZj/tfwIWxzOnGutP6njgRXzWpKSq8mLk2KWc5AeOFDDMxxU
	 qRQ2MeqrxpbFkC6rnEzB4awVGAM00vkDncP/8izB3/IOFFszYgwkUFqHNuGykeXuuW
	 MV0CpylNDs8hzzSJEOln1tHkYldRwuVI8B2wDnnQJSQiL5a5SfOB/QpcuxSC85QgRQ
	 G5NsMGlVrpaSKcK11Koge9aTsd2lyFclw7db1FHxNv2YPfaQlVng+bxd1XH2LBfwVj
	 pjqgVDhrcofLw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: core: Validate MODE SENSE lengths in
 scsi_cdl_enable()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alberto Carboneri" <acarboneri@drivesec.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260904135410.360314-1-acarboneri@drivesec.com>
References: <20260904135410.360314-1-acarboneri@drivesec.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 14:12:03 +0000
Message-Id: <20260904141204.7F2C81F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Stack out-of-bounds write and information leak in cache_type_s=
tore() due to unsigned subtraction wrap and missing bounds checks on MODE S=
ENSE length fields.
- [High] scsi_cdl_enable() sends a malformed MODE SELECT command if the dev=
ice returns a non-zero block descriptor length.
- [High] Heap out-of-bounds read in sd_read_app_tag_own() due to unvalidate=
d block descriptor length.
- [High] Massive heap out-of-bounds read in sd_read_io_hints() due to unval=
idated MODE SENSE length.
--

commit 6d4bd3fe431e6d359b82e4420cd2b054307e0a8c
Author: Alberto Carboneri <acarboneri@drivesec.com>

scsi: core: Validate MODE SENSE lengths in scsi_cdl_enable()

This patch attempts to fix a stack out-of-bounds vulnerability in
scsi_cdl_enable() by verifying lengths and bounding them to the stack
buffer size. It correctly caps the buffer size and ensures the mode
header and block descriptor lengths fit within the available buffer.

Link: https://lore.kernel.org/linux-scsi/20260717192313.93D791F000E9@smtp.k=
ernel.org/
Link: https://lore.kernel.org/linux-scsi/20260717222931.AC4EE1F000E9@smtp.k=
ernel.org/
Link: https://lore.kernel.org/linux-scsi/df13ec87ac9b28e3b0a2d9eb26477e276f=
f0278a.camel@HansenPartnership.com/

> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 76cdad063f7bc..f285521d9de6d 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -735,11 +736,24 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool =
enable)
[ ... ]
> -		len =3D min_t(size_t, sizeof(buf),
> -			    data.length - data.header_length -
> -			    data.block_descriptor_length);
> -		buf_data =3D buf + data.header_length +
> -			data.block_descriptor_length;
> +		avail =3D min_t(size_t, data.length, sizeof(buf));
> +		if (data.header_length > avail)
> +			return -EINVAL;
> +
> +		offset =3D data.header_length;
> +		avail -=3D data.header_length;
> +
> +		if (data.block_descriptor_length > avail)
> +			return -EINVAL;
> +
> +		offset +=3D data.block_descriptor_length;
> +		avail -=3D data.block_descriptor_length;
> +
> +		if (avail < 5)
> +			return -EINVAL;
> +
> +		buf_data =3D buf + offset;
> +		len =3D avail;
> =20
>  		/*
>  		 * If we want to enable CDL and CDL is already enabled on the

While reviewing this patch, a few related pre-existing regressions
were found in the surrounding mode sense handling code.

In drivers/scsi/scsi.c:scsi_cdl_enable():

> 		if (enable) {
> 			if ((buf_data[4] & 0x03) =3D=3D 0x02)
> 				goto out;
> 			buf_data[4] &=3D ~0x03;
> 			buf_data[4] |=3D 0x02;
> 		} else {
> 			if ((buf_data[4] & 0x03) =3D=3D 0x00)
> 				goto out;
> 			buf_data[4] &=3D ~0x03;
> 		}
>=20
> 		ret =3D scsi_mode_select(sdev, 1, 0, buf_data, len, 5 * HZ, 3,
> 				       &data, &sshdr);

[Severity: High]
This isn't a bug introduced by this patch, but does this regression
still allow a malformed mode select command to be sent if the device
returns a non-zero block descriptor length?

If the target returns a mode page with data.block_descriptor_length > 0,
the command constructed by scsi_mode_select() will have a header
claiming block descriptors exist, but the payload will be the mode page
itself.

Can the target misinterpret the mode page as a block descriptor,
potentially modifying sector size or disk formatting?


In drivers/scsi/sd.c:cache_type_store():

> 	if (scsi_mode_sense(sdp, 0x08, 8, 0, buffer, sizeof(buffer), SD_TIMEOUT,
> 			    sdkp->max_retries, &data, NULL))
> 		return -EINVAL;
> 	len =3D min_t(size_t, sizeof(buffer), data.length - data.header_length -
> 		  data.block_descriptor_length);
> 	buffer_data =3D buffer + data.header_length +
> 		data.block_descriptor_length;
> 	buffer_data[2] &=3D ~0x05;

[Severity: Critical]
This is a pre-existing issue, but can this regression cause a stack
out-of-bounds write and information leak?

If a device returns a short data.length (e.g., 0) and a large
block_descriptor_length (e.g., 255) during cache_type_store(), the
unsigned subtraction data.length - data.header_length -
data.block_descriptor_length underflows to a huge value.

While len is clamped to sizeof(buffer) (64), buffer_data is advanced
by up to 259 bytes.

Does this cause buffer_data to point outside the 64-byte stack buffer,
modifying buffer_data[2] out of bounds, and allowing scsi_mode_select()
to leak the stack memory?


In drivers/scsi/sd.c:sd_read_app_tag_own():

> 	res =3D scsi_mode_sense(sdp, 1, 0x0a, 0, buffer, 36, SD_TIMEOUT,
> 			      sdkp->max_retries, &data, &sshdr);
>=20
> 	if (res < 0 || !data.header_length ||
> 	    data.length < 6) {
[ ... ]
> 		return;
> 	}
>=20
> 	offset =3D data.header_length + data.block_descriptor_length;
>=20
> 	if ((buffer[offset] & 0x3f) !=3D 0x0a) {

[Severity: High]
This isn't a bug introduced by this patch, but does this regression
lead to a heap out-of-bounds read?

During disk enumeration, sd_revalidate_disk() calls
sd_read_app_tag_own() on a device returning a malformed mode sense
response.

If sdev->use_10_for_ms is set, the device can return a 10-byte mode
sense response with a block_descriptor_length up to 65535, making the
offset reach up to 65543.

Since the buffer passed by sd_revalidate_disk() is only 512 bytes,
will accessing buffer[offset] read far outside the heap allocation?


In drivers/scsi/sd.c:sd_read_io_hints():

> 	res =3D scsi_mode_sense(sdp, /*dbd=3D*/0x8, /*modepage=3D*/0x0a,
> 			      /*subpage=3D*/0x05, buffer, SD_BUF_SIZE, SD_TIMEOUT,
> 			      sdkp->max_retries, &data, &sshdr);
> 	if (res < 0)
> 		return;
> 	start =3D (void *)buffer + data.header_length + 16;
> 	end =3D (void *)buffer + ALIGN_DOWN(data.header_length + data.length,
> 					  sizeof(*end));
[ ... ]
> 	for (desc =3D start; desc < end; desc++)
> 		if (!desc->st_enble || !sd_is_perm_stream(sdkp, desc - start))

[Severity: High]
This is a pre-existing issue, but could this regression cause a
massive heap out-of-bounds read?

scsi_mode_sense() is called with a 512-byte buffer (SD_BUF_SIZE),
which unconditionally forces use_10_for_ms =3D 1 since it exceeds 255
bytes.

The device can thus return a data.length up to 65537, causing the end
pointer to be calculated using this unvalidated length.

Does this cause the end pointer to point up to 65KB past the end of
the 512-byte heap buffer, which is then dereferenced during the loop
iteration?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904135410.3603=
14-1-acarboneri@drivesec.com?part=3D1
