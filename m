Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89084385D6C
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2026 09:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761709; cv=none; b=jWheG5pM3g5BJ6jml5GTi9tys3RukCqG7jwSCuV1J5bCpJRaS7SKCtOYBUM+IygWFmSK9r/N42wIZOP8mI4bIdBHX7W8tJsrsfXOSaqkp0HlAXrShAclF68AzX3KgNDkff9LhL1ecpyalH3Hsvy0CGl3BjSFi8h5HYLYZ7jbaps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761709; c=relaxed/simple;
	bh=94D/UKm4FRfjLoPMGoPYAJl6DRH5VVAc6CRTRZ3vwGs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RMNJCbybz/1LxI5I1pBFpKEkY6FWIUolF3rp9dA7G5BTBnMSDt+Ol/VGUZVqB9W+epUgQ51ixDNu9f33ihhskrERE3fL62zh5YV1p46rzpgiW2pmH8rQXYMVNuE5L+ABHq7iYJmj+y2dnIjWEW8Pvs/UhaMlItz37LMQK5Sg6v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XcmOvZby; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcmOvZby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90291F000E9;
	Sat, 11 Jul 2026 09:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783761706;
	bh=05fIE9gWXN0XU5nK/rJWWSF3LsvEm+mjPAdBOohOs3c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XcmOvZbyxT91ciz9x5tpHO3b4NAgS3XX5skq8ArjXuzMDg8sz7I9Wvsg8OsaWX1Tg
	 SsgNlx2SWc8rB189mek2Dq20GYDx8hwPocBbyXPP1rWIYvl/v6Ycv0oyOWqJlqV1U9
	 7b17mObh/uQmBcZrRHayyClCdM1xB6PFh8qIO2yzMaiWa3nci7H6Vi61I43dhbg+Om
	 ShgSLN1hGRS72qECs0iSsJTFjtv+G/FzI5QNJIGmW1RHWPb7P3VXgsrWvZB9/fuXbx
	 QarCNpKgIu8TA0at+4Jy2eBURd4MSnvIikwJ13TUoTggq8fgVPdVC+h0AggcUkVSpO
	 TXTvTSNG6nZbQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: ses: validate the page 1 geometry before
 walking it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260711-b4-disp-414d08d4-v2-1-784a01e8e2dd@proton.me>
References: <20260711-b4-disp-414d08d4-v2-1-784a01e8e2dd@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 11 Jul 2026 09:21:45 +0000
Message-Id: <20260711092145.D90291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Diagnostic Page 2 Length Vulnerabilities: Missing bounds checks an=
d signed integer overflows lead to massive out-of-bounds reads and writes.
- [High] Missing minimum length check for the page 7 buffer leads to an out=
-of-bounds read when skipping the overall descriptor.
- [High] The enclosure device is exposed to sysfs and other subsystems befo=
re its driver-private data is initialized, leading to a NULL pointer derefe=
rence.
- [High] The enclosure private data is freed before the device is unregiste=
red, causing a Use-After-Free or NULL pointer dereference for concurrent us=
ers.
- [Medium] Concurrent disk probes trigger simultaneous, lockless modificati=
ons to a shared diagnostic buffer, causing data corruption.
--

--- Patch [1]: [PATCH v2] scsi: ses: validate the page 1 geometry before wa=
lking it ---
commit 622571462ff0a680551a5fb090d8b288e0c78b7c
Author: Bryam Vargas <hexlabsecurity@proton.me>

scsi: ses: validate the page 1 geometry before walking it

This patch bounds the skip loop to a whole descriptor and validates the pag=
e 1
geometry once where it is parsed. It rejects pages that are too short for
their logical id, type arrays that run past the buffer, or counts larger
than the array holds. This prevents out-of-bounds reads during the enclosure
descriptor skip loop.

> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 4c348645b04ee..907bb489252ad 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -742,11 +742,28 @@ static int ses_intf_add(struct device *cdev)
>  	/* begin at the enclosure descriptor */
>  	type_ptr =3D buf + 8;
>  	/* skip all the enclosure descriptors */
> -	for (i =3D 0; i < num_enclosures && type_ptr < buf + len; i++) {
> +	for (i =3D 0; i < num_enclosures && type_ptr + 4 <=3D buf + len; i++) {
>  		types +=3D type_ptr[2];
>  		type_ptr +=3D type_ptr[3] + 4;
>  	}
> =20
> +	/*
> +	 * Validate the device-reported page 1 geometry before the accessors
> +	 * walk it.  page1_types and page1_num_types come straight from the
> +	 * enclosure; the page 2 descriptor walks (ses_get_page2_descriptor(),
> +	 * ses_set_page2_descriptor()), ses_enclosure_data_process() and the
> +	 * logical-id read in ses_show_id() all trust them.  Reject a page 1
> +	 * shorter than its logical id, one whose descriptors ran past the end,
> +	 * or one declaring more type descriptors than it carries.  Bounding the
> +	 * count before it is stored also keeps it within its short.
> +	 */
> +	if (len < 8 + 4 + (int)sizeof(u64) ||
> +	    type_ptr > buf + len ||
> +	    types > (buf + len - type_ptr) / 4) {
> +		err =3D -EINVAL;
> +		goto err_free;
> +	}
> +
>  	ses_dev->page1_types =3D type_ptr;
>  	ses_dev->page1_num_types =3D types;
> =20

[Severity: High]
This is a pre-existing issue, but does this code leave the page 2 length
unvalidated?

In drivers/scsi/ses.c:ses_intf_add(), the length is initialized directly
from the device's diagnostic page:

    len =3D (hdr_buf[2] << 8) + hdr_buf[3] + 4;
    // ...
    ses_dev->page2_len =3D len;

Since struct ses_device declares short page2_len, a length greater than
32767 overflows into a negative value, and a length less than 8 causes
underflows.

Can this result in a massive out-of-bounds write via
memset(desc_ptr, 0, ses_dev->page2_len - 8) in ses_set_page2_descriptor(),
and subsequent out-of-bounds accesses when advancing pointers in
ses_get_page2_descriptor()?

[Severity: High]
This isn't a bug introduced by this patch, but is there a missing minimum
length check for the page 7 buffer?

Looking at drivers/scsi/ses.c:ses_enclosure_data_process(), if the device
returns a page 7 length less than 8 (e.g., indicating 0 bytes of payload),
kzalloc() allocates a 5-byte buffer:

    page7_len =3D len =3D (hdr_buf[2] << 8) + hdr_buf[3] + 4;
    buf =3D kzalloc(len + 1, GFP_KERNEL);
    // ...
    } else {
        desc_ptr =3D buf + 8;
        len =3D (desc_ptr[2] << 8) + desc_ptr[3];

Does the unconditional desc_ptr =3D buf + 8 lead to a slab out-of-bounds re=
ad
when checking desc_ptr[2]?

[Severity: High]
This is a pre-existing issue, but is the enclosure device exposed before its
private data is initialized?

In drivers/scsi/ses.c:ses_intf_add(), the device is registered before the
scratch payload is attached:

    edev =3D enclosure_register(...);
    // ...
    edev->scratch =3D ses_dev;

If a user process reads the sysfs id file or an asynchronous scsi probe
matches the enclosure before edev->scratch is set, could this trigger a null
pointer dereference?

For example, in drivers/scsi/ses.c:ses_show_id():

    struct ses_device *ses_dev =3D edev->scratch;
    unsigned long long id =3D get_unaligned_be64(ses_dev->page1+8+4);

Will this unconditionally dereference a null edev->scratch?

[Severity: High]
This isn't a bug introduced by this patch, but does the teardown sequence
cause a use-after-free or null pointer dereference?

In drivers/scsi/ses.c:ses_intf_remove_enclosure(), the private data is freed
before the device is unregistered:

    ses_dev =3D edev->scratch;
    edev->scratch =3D NULL;

    kfree(ses_dev->page10);
    kfree(ses_dev->page1);
    kfree(ses_dev->page2);
    kfree(ses_dev);
    // ...
    enclosure_unregister(edev);

Can concurrent sysfs reads or asynchronous scsi probes operating on the
device during this window dereference the cleared edev->scratch, resulting
in a crash?

[Severity: Medium]
This is a pre-existing issue, but do concurrent disk probes trigger
data races on the shared diagnostic buffer?

In drivers/scsi/ses.c:ses_enclosure_data_process():

    /* re-read page 10 */
    if (ses_dev->page10)
        ses_recv_diag(sdev, 10, ses_dev->page10, ses_dev->page10_len);

If multiple scsi devices probe concurrently, does this unconditionally
issue ses_recv_diag() without locking, causing simultaneous hardware dma
writes and parser reads on the exact same buffer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260711-b4-disp-41=
4d08d4-v2-1-784a01e8e2dd@proton.me?part=3D1
