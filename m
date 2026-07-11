Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288A92D3220
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2026 07:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783756427; cv=none; b=oBo/YYM/C0VgVgitlOQZyukYHpCkCPpjzUw1JcTiPylQjbqtTfuVVVICZNVCNQYe9JMdLmhQY3UMd9Hwn1QuMr5xVO2opV4b5MT7jXxZ1Ik18iFZHURWOt9RIDPS2W3l6ld6VZDhBVf0CuFV7wH0jui0QjewH3V44BOALZjbOfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783756427; c=relaxed/simple;
	bh=PilE8UjyDgU5iKS5ING8k9365gyYlbMbhfkyM/mo7AY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q//kLQ0YpE4MSJl/cjgvw/+6CNcORLF6YTqhmo5hLjwEEOJDNXtKi95WMtO97BPqUf9x61G/oupS3Bz3B4DXDHvutFhOZpNWYHhU95LJ7aJtf3QTJmsjv8yDqsNgrMXhMt5FwhMupO2IQ7X9k9jv944LJC4OSbxSbaWW69tZwAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQdhnAIm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQdhnAIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9191F1F000E9;
	Sat, 11 Jul 2026 07:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783756425;
	bh=Vm1GRx9b6/Drh8j0UrR64E6nQKCXJqHOw+AG/eAapLw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EQdhnAImwOGEbRoJ1XwmVHvVT3gHKPQEQxttlden/lGRcXitKUjDAGNkLivOIULKH
	 5ODByFC/JFM/8o6j0QE4X6oDgic74YDhlMm0+VxBCVWlkijLwHp9Tkc8Y2QkoF+CAZ
	 yPY2gQjh/Q+fQDIgd8D7mdsya1tgRgggXRVsy8Y9P+NVXPZJ6NK30OH6eW1/dZ3/Ba
	 Qkeift1ahBzrZhmNmcSiRJwq3gYPz3v8hwcEfAK6s+1Zx5ysJvf5o7QJ9R45MGC0u5
	 KlOejZvjD6DLH4mD8VkF7Er7TjXi6g1yRSGCf5ejU+qhTtGA2XEImw/FnfDwTVl9Fa
	 K0srFT6ZAwQjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ses: validate the page 1 geometry before walking
 it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260711-b4-disp-26cc3226-v1-1-e04c11c88996@proton.me>
References: <20260711-b4-disp-26cc3226-v1-1-e04c11c88996@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 11 Jul 2026 07:53:45 +0000
Message-Id: <20260711075345.9191F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] An integer truncation when storing the descriptor type count allow=
s bypassing the new page 1 geometry validation, leading to an out-of-bounds=
 read.

Pre-existing issues:
- [Critical] Diagnostic page 2 lacks length validation, leading to an integ=
er underflow and massive out-of-bounds write in `ses_set_page2_descriptor`.
- [Critical] The page 2 descriptor iterations can access memory out of boun=
ds if page 2 is smaller than the required size computed from page 1.
- [High] The newly added page 1 geometry validation is placed after the ini=
tial enclosure descriptor parsing loop, leaving the loop vulnerable to out-=
of-bounds reads.
- [High] The enclosure device is exposed to userspace before its private da=
ta (`edev->scratch`) is initialized, creating a race condition that leads t=
o a NULL pointer dereference.
- [High] Diagnostic page 7 is parsed without adequate length validation, al=
lowing out-of-bounds reads during device initialization.
--

--- Patch [1]: [PATCH] scsi: ses: validate the page 1 geometry before walki=
ng it ---
commit df60f2b0ae545a4bc27de56a34c9f4c56a73eb55
Author: Bryam Vargas <hexlabsecurity@proton.me>
Subject: scsi: ses: validate the page 1 geometry before walking it

This commit adds validation to the SCSI Enclosure Services (SES) driver to
verify the geometry of diagnostic page 1 before parsing it. It ensures the
page is long enough for its logical ID and bounds the number of type
descriptors to prevent out-of-bounds reads.

Link: https://sashiko.dev/#/patchset/20260706-b4-disp-29a05ca3-v1-1-49591f4=
69f60@proton.me?part=3D1

> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 4c348645b04ee..bbd8ff13cb2a5 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -750,6 +750,22 @@ static int ses_intf_add(struct device *cdev)
>  	ses_dev->page1_types =3D type_ptr;
>  	ses_dev->page1_num_types =3D types;

[Severity: High]
This is a pre-existing issue, but the loop just above this context:

	/* begin at the enclosure descriptor */
	type_ptr =3D buf + 8;
	/* skip all the enclosure descriptors */
	for (i =3D 0; i < num_enclosures && type_ptr < buf + len; i++) {
		types +=3D type_ptr[2];
		type_ptr +=3D type_ptr[3] + 4;
	}

iterates and reads type_ptr[2] and type_ptr[3] before the newly added valid=
ation
check. Is it possible for this to cause an out-of-bounds read if the buffer=
 is
smaller than 12 bytes?

> +	/*
> +	 * Validate the device-reported page 1 geometry once, here, before the
> +	 * accessors walk it.  page1_types and page1_num_types come straight fr=
om
> +	 * the enclosure, and the page 2 descriptor walks (ses_get_page2_descri=
ptor(),
> +	 * ses_set_page2_descriptor()), ses_enclosure_data_process() and the
> +	 * logical-id read in ses_show_id() all trust them.  A page 1 shorter t=
han
> +	 * its logical-id field, or one that declares more type descriptors tha=
n it
> +	 * carries, would make those reads run past the page 1 buffer.
> +	 */
> +	if (len < 8 + 4 + (int)sizeof(u64) ||
> +	    ses_dev->page1_types > buf + len ||
> +	    ses_dev->page1_num_types > (buf + len - ses_dev->page1_types) / 4) {

[Severity: High]
Can assigning the integer types to ses_dev->page1_num_types (which is a sho=
rt)
cause a truncation? If a malicious device reports up to 256 enclosures and =
255
types per enclosure, types could reach 65,280. When assigned to page1_num_t=
ypes,
it truncates to a negative number (e.g., -256).

This would cause the ses_dev->page1_num_types > ... check to evaluate as fa=
lse,
bypassing the validation and potentially allowing an out-of-bounds read in =
the
subsequent loop.

> +		err =3D -EINVAL;
> +		goto err_free;
> +	}
> +
>  	for (i =3D 0; i < types && type_ptr < buf + len; i++, type_ptr +=3D 4) {
>  		if (type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_DEVICE ||
>  		    type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_ARRAY_DEVICE)

[Severity: High]
This is a pre-existing issue, but looking further down in ses_intf_add():

	edev =3D enclosure_register(cdev->parent, dev_name(&sdev->sdev_gendev),
				  components, &ses_enclosure_callbacks);
	if (IS_ERR(edev)) {
		err =3D PTR_ERR(edev);
		goto err_free;
	}

	kfree(hdr_buf);

	edev->scratch =3D ses_dev;

Are we exposing the device to userspace before initializing its private data
(edev->scratch)? It looks like this creates a race window where userspace
could immediately read the sysfs attributes (like id), and the ses_show_id()
callback might dereference a NULL edev->scratch.


[Severity: High]
This isn't a bug introduced by this patch, but looking at ses_enclosure_dat=
a_process():

	} else {
		desc_ptr =3D buf + 8;
		len =3D (desc_ptr[2] << 8) + desc_ptr[3];
		/* skip past overall descriptor */
		desc_ptr +=3D len + 4;
	}

We seem to parse diagnostic page 7 without adequate length validation here.
If the device provides a short page (e.g., length of 0, making the allocated
buffer 5 bytes), desc_ptr is advanced past the allocated buffer and
unconditionally dereferenced. Could this lead to out-of-bounds reads during
device initialization?


[Severity: Critical]
This is a pre-existing issue, but looking at ses_set_page2_descriptor():

	unsigned char *desc_ptr =3D ses_dev->page2 + 8;

	/* Clear everything */
	memset(desc_ptr, 0, ses_dev->page2_len - 8);

What happens if page2_len is less than 8? The subtraction would underflow
and cause memset to overwrite a massive amount of kernel memory. Should the=
re
be length validation for diagnostic page 2 before this memset?


[Severity: Critical]
This is a pre-existing issue, but also in ses_set_page2_descriptor():

	for (i =3D 0; i < ses_dev->page1_num_types; i++, type_ptr +=3D 4) {
		for (j =3D 0; j < type_ptr[1]; j++) {
			desc_ptr +=3D 4;

It appears desc_ptr is unconditionally advanced based on page1_num_types
without bounds checking against page2_len. If a device reports a large numb=
er
of types in page 1 but returns a truncated page 2, could this iterate out of
bounds and cause slab corruption during a subsequent memcpy?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260711-b4-disp-26=
cc3226-v1-1-e04c11c88996@proton.me?part=3D1
