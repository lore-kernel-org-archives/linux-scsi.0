Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AC83DDAFB
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 22:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784327374; cv=none; b=S/py99ebvK+1LaK4F/OZmlrZTGwHsy75CLjriwTfBSeoDjxhaPIVg+XlLHr5Cdzv/vYbCLx7wwftDXpyU18XnDyX2qPKcWt9SrDxcG09q3oyzui/Dwc9mUNugmdpTC55aS6Lcf0w4MWuzkyDPxj0FT4eKWualGY+aGJ2Ood3Ozo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784327374; c=relaxed/simple;
	bh=POXgxjZYujj5a3eFqdBZc1Iq5zoCg9oUHimrCCSbf8Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oJps1vK0/d5TJ9MMdVmNb7JTJOE8/7q2yUHzzEGHhrqgzPa9iO2976k5b2FM8I0ie6kNHU87fKktiewTVRyfhLE/seMyz9un5xpcQnRCzIAgmYozqTLuIbXEkjn63pMmIl1qbX05QTi+9H2ZBVkWDg5StZ3s6ct5aWe7MTXkS5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fIn0rY54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fIn0rY54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4EE1F000E9;
	Fri, 17 Jul 2026 22:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784327371;
	bh=b++pkXAS5lfltsaY66hR6RXtmGPq2cDrH4Q+547rm00=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fIn0rY54fG9LbCPLTMvuiQqXoyMSV1ceiAPIWYlDreRT8g2c7JELc3ROaM1zjJ0ud
	 Ng4JfZ4Ol8LkxrGeaEWpM04oJWuW90D5kM+xjhMkt7gG2SL+h1KNlkhxX/aB5wIyJS
	 8te++jtigIDMiPbLc6nRIzFaCeWQfJ4avBEO8RoWpIVFkZQm+LMrIM5xGPdrUUieIL
	 DUlCqnIg5AWJySFRmzye1Q2rzWW1+YWtmhF92FESD+XDpIPWdXnYGERPy59if7Biiq
	 5DA9LeKFn/eRfQccb8iAGMo9Zh2kRbAYQ8vabJIDLaLogA7pG8BQ8YQAfECjF+gQSm
	 lo/O042WhQ3sg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: sd: bound MODE SENSE offset in
 sd_read_app_tag_own()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jay Vadayath" <jay@artiphishell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717221442.57163-1-jay@artiphishell.com>
References: <20260717221442.57163-1-jay@artiphishell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 22:29:31 +0000
Message-Id: <20260717222931.AC4EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] In `cache_type_store()`, an unvalidated `data.block_descriptor=
_length` from the untrusted device causes an integer underflow when computi=
ng the copy length for a stack buffer, resulting in a stack out-of-bounds w=
rite and a kernel memory leak.
- [Critical] In `scsi_cdl_enable()`, an unvalidated `data.block_descriptor_=
length` from the untrusted device causes an integer underflow when computin=
g the length for a stack buffer, resulting in a stack out-of-bounds write a=
nd a kernel memory leak.
- [High] The function `sd_read_io_hints()` calculates a loop boundary `end`=
 using `data.length` directly from the untrusted device response. Since `da=
ta.length` is not clamped to the `SD_BUF_SIZE` (512 bytes) allocation lengt=
h, `end` can point far beyond the buffer, leading to a severe slab out-of-b=
ounds read.
--

--- Patch [1]: [PATCH] scsi: sd: bound MODE SENSE offset in sd_read_app_tag=
_own() ---
commit 78ac99a893d5ecde765f842f2b0590c22510f4a8
Author: Jay Vadayath <jay@artiphishell.com>

scsi: sd: bound MODE SENSE offset in sd_read_app_tag_own()

This patch adds bounds checking to sd_read_app_tag_own() to validate the
block_descriptor_length returned by a MODE SENSE(10) command, preventing
a slab out-of-bounds read.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 599e75f333343..a5d0710fd82b5 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3368,6 +3368,18 @@ static void sd_read_app_tag_own(struct scsi_disk *=
sdkp, unsigned char *buffer)
> =20
>  	offset =3D data.header_length + data.block_descriptor_length;
> =20
> +	/*
> +	 * block_descriptor_length is taken verbatim from the (untrusted)
> +	 * device response and can be as large as 65535, so the computed
> +	 * offset may point well past the SD_BUF_SIZE buffer that only holds
> +	 * the 36 bytes we asked for.  Validate it before dereferencing to
> +	 * avoid a slab out-of-bounds read.
> +	 */
> +	if (offset < 0 || offset + 5 >=3D 36) {
> +		sd_first_printk(KERN_ERR, sdkp, "ATO mode page too long\n");
> +		return;
> +	}
> +

[Severity: High]
This isn't a bug introduced by this patch, but does this same vulnerability
exist in sd_read_io_hints() in drivers/scsi/sd.c?

During device probe (sd_revalidate_disk), sd_read_io_hints() calls
scsi_mode_sense() asking for up to 512 bytes, but data.length is extracted
verbatim from the untrusted device response. Because it is not clamped to t=
he
allocation length, can the loop boundary end exceed the buffer:

drivers/scsi/sd.c:sd_read_io_hints() {
    ...
    end =3D (void *)buffer + ALIGN_DOWN(data.header_length + data.length,
                                      sizeof(*end));
    ...
    for (desc =3D start; desc < end; desc++)
        if (!desc->st_enble || !sd_is_perm_stream(sdkp, desc - start))
            break;
    ...
}

Could this result in an out-of-bounds read when dereferencing desc->st_enble
if a malicious device returns a very large data.length?

[Severity: Critical]
This is a pre-existing issue, but does cache_type_store() in
drivers/scsi/sd.c have a similar underflow issue when using
data.block_descriptor_length?

When the cache_type sysfs attribute is written, it issues a scsi_mode_sense=
()
into a 64-byte stack buffer. If a device returns a large
block_descriptor_length, does the following subtraction underflow:

drivers/scsi/sd.c:cache_type_store() {
    ...
    len =3D min_t(size_t, sizeof(buffer), data.length - data.header_length -
          data.block_descriptor_length);
    buffer_data =3D buffer + data.header_length +
        data.block_descriptor_length;
    buffer_data[2] &=3D ~0x05;
    ...
}

Could this cause buffer_data to point outside the stack buffer, modifying
stack memory out-of-bounds, and then leak that memory to the device when
passed to scsi_mode_select()?

[Severity: Critical]
This isn't a bug introduced by this patch, but is there also a similar
pre-existing underflow in scsi_cdl_enable() in drivers/scsi/scsi.c?

During device scan, scsi_cdl_check() calls scsi_cdl_enable() which issues a
scsi_mode_sense() into a 64-byte stack buffer. If the target returns a large
block_descriptor_length, does the length calculation underflow here as well:

drivers/scsi/scsi.c:scsi_cdl_enable() {
    ...
    len =3D min_t(size_t, sizeof(buf),
                data.length - data.header_length -
                data.block_descriptor_length);
    buf_data =3D buf + data.header_length +
        data.block_descriptor_length;
    ...
    buf_data[4] &=3D ~0x03;
    ...
}

Since this is reachable automatically during probe with a USB storage devic=
e,
could this corrupt kernel stack memory and leak it back to the target?

>  	if ((buffer[offset] & 0x3f) !=3D 0x0a) {
>  		sd_first_printk(KERN_ERR, sdkp, "ATO Got wrong page\n");
>  		return;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717221442.5716=
3-1-jay@artiphishell.com?part=3D1
