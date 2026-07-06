Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7493BE635
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 06:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317834; cv=none; b=rUFyyW4NiFknTMWjqiMMsXVXi02cmSccwdhKY3DT1CzLQ1Wk9z/ggAQFFv7FZvIeXYCHd6j3qxT/hjPnEN3kvT3+1Qzp3egD33hyAhZOYVhQ0dXi8QFjRukKyUnXqMLpkAecS+MH7cY6u6ybTgwCebAYo/YY2JJbV49aJoSi0Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317834; c=relaxed/simple;
	bh=Io7IpJtx0ERta6Ra7PIdjHASEaQDpDXotXVtcM/wsqQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eZzkRa0TBf2UYNxhXr65sKK08y90PTAoJwFUYATfCH8T3Hmlji6Zp1QWYzGLIpMe8hgjh/Z3W6TrI7EbPQek3oqo+BYmqQ3i9K/Q5+TY1eLi8nQwCaHpqNdRp7h7kHEIVmIA1+MxLBVyiICwcv5iXG017O5NNpOmmMwMntZkqYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ue+x5fPr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ue+x5fPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619B41F000E9;
	Mon,  6 Jul 2026 06:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783317832;
	bh=NY8IH5aZOhMDaPtLKIkEOwzBmCJFQMBZZpFRlJI8pr8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ue+x5fPryA2JJfr1d/hNcrINFwbPl2nCEHB8l43bbWf5boUh4fv5FwcL4DdQfMRBK
	 TO3l5JVWG7BGLpDUcpk6UAKkCXCZgmPlRevwERw0MqJ1B/YSg+EVAQSNugRmtgutmY
	 wJWytvumYIa4u87zxbhU7YE6hipHGhV2UYfC2ucwmWChOxU8gAxjxli+G+c4vO7ZMm
	 ke62sj6fa502jRwArebFiau8aw3VYv9vF67Yxubf4h3E/v1aWgYZiagG5y2L1baIz5
	 zaNIKJDKznUt64O8rafDgVcsITyNcPPq2VtNed9gSHUtc//EqAwHbTuHsQO9+RoyLw
	 +tCYxpKZJmf2A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ses: bound the page 2 descriptor walk to the page
 2 buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260706-b4-disp-29a05ca3-v1-1-49591f469f60@proton.me>
References: <20260706-b4-disp-29a05ca3-v1-1-49591f469f60@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 06:03:51 +0000
Message-Id: <20260706060352.619B41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 9 potential issue(=
s) to consider:

New issues:
- [Medium] Silent failure when the new bounds check triggers during a devic=
e state update.

Pre-existing issues:
- [Critical] Massive out-of-bounds heap write in `ses_set_page2_descriptor`=
 due to `memset` size underflow.
- [High] Unbounded `type_ptr` walk in descriptor parsing loops allows out-o=
f-bounds heap reads of the `page1` buffer.
- [High] Buffer overread during page 1 enclosure descriptor parsing in `ses=
_intf_add`.
- [High] Page 2 descriptor traversal logic fails to account for overall con=
trol elements, misaligning descriptor selection.
- [High] Use-After-Free via concurrent sysfs callbacks due to premature fre=
eing of enclosure scratch memory.
- [High] Concurrent sysfs accesses to enclosure attributes cause data races=
 on the shared `ses_dev->page2` buffer.
- [High] Buffer overread during page 7 overall descriptor parsing in `ses_e=
nclosure_data_process`.
- [High] Uninitialized heap memory leak via the `ses_show_id` sysfs attribu=
te.
--

commit bd011c721850f5483452d39192c0849e2ce83b34
Author: Bryam Vargas <hexlabsecurity@proton.me>

scsi: ses: bound the page 2 descriptor walk to the page 2 buffer

This commit introduces bounds checking in the page 2 descriptor walk for bo=
th
getting and setting enclosure status. It stops the walk if the next
descriptor would exceed the allocated page 2 diagnostic buffer, preventing
out-of-bounds memory accesses.

Link: https://sashiko.dev

> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 4c348645b04ee..7e9c33809131f 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -184,12 +184,21 @@ static int ses_set_page2_descriptor(struct enclosur=
e_device *edev,
>  	struct ses_device *ses_dev =3D edev->scratch;
>  	unsigned char *type_ptr =3D ses_dev->page1_types;
>  	unsigned char *desc_ptr =3D ses_dev->page2 + 8;
> +	unsigned char *page2_end =3D ses_dev->page2 + ses_dev->page2_len;
> =20
>  	/* Clear everything */
>  	memset(desc_ptr, 0, ses_dev->page2_len - 8);

[Severity: Critical]
This is a pre-existing issue, but does this calculation underflow the size
passed to memset?

If a USB enclosure device reports a page 2 length less than 8,
ses_dev->page2_len - 8 will underflow the size_t argument to memset. Could
this cause a massive out-of-bounds write over the kernel heap when userspace
writes to a sysfs attribute like fault?

[Severity: High]
This is a pre-existing issue, but does this function modify and send the
shared ses_dev->page2 buffer without any locks?

If multiple threads read or write enclosure sysfs attributes concurrently,
could they issue data transfers into, and memset operations upon, the shared
ses_dev->page2 buffer without any serialization locks?

>  	for (i =3D 0; i < ses_dev->page1_num_types; i++, type_ptr +=3D 4) {

[Severity: High]
This is a pre-existing issue, but can type_ptr advance past the bounds of
the page1 buffer?

In ses_intf_add(), the page1_num_types count is calculated without capping
it against the buffer length:

drivers/scsi/ses.c:ses_intf_add() {
    ...
    ses_dev->page1_num_types =3D types;
    ...
}

If a device reports a large number of types, could this loop advance
type_ptr past the bounds of page1 and dereference it, leading to an
out-of-bounds heap read?

>  		for (j =3D 0; j < type_ptr[1]; j++) {
>  			desc_ptr +=3D 4;

[Severity: High]
This is a pre-existing issue, but does this iteration logic fail to skip the
overall control element present for subsequent types?

According to the enclosure specification, page 2 contains a 4-byte overall
control element for each element type, followed by the individual control
elements.

Does incrementing desc_ptr by 4 for each individual element skip the overall
element for the first type, but fail to skip it for subsequent types, causi=
ng
it to treat the overall element as an individual element?

> +			/*
> +			 * The descriptor count comes from page 1 while page 2
> +			 * is a separately sized diagnostic page; a device that
> +			 * reports more descriptors than page 2 can hold would
> +			 * walk desc_ptr past the buffer, so stop here.
> +			 */
> +			if (desc_ptr + 4 > page2_end)
> +				goto out;

[Severity: Medium]
When the new bounds check triggers here and jumps to out, will this silently
return success to userspace?

The function returns the result of ses_send_diag(), which sends the zeroed
buffer. Could this send a diagnostic page with all select bits set to 0,
acting as a hardware no-op, and return success (0) despite ignoring the sta=
te
change? Should this return an error code instead?

[ ... ]

> @@ -214,6 +224,7 @@ static unsigned char *ses_get_page2_descriptor(struct=
 enclosure_device *edev,
>  	struct ses_device *ses_dev =3D edev->scratch;
>  	unsigned char *type_ptr =3D ses_dev->page1_types;
>  	unsigned char *desc_ptr =3D ses_dev->page2 + 8;
> +	unsigned char *page2_end =3D ses_dev->page2 + ses_dev->page2_len;
> =20
>  	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len))
>  		return NULL;

[Severity: High]
This is a pre-existing issue, but is there a use-after-free risk during
device removal?

In ses_intf_remove_enclosure(), the driver frees the ses_dev and its pages
before unregistering the enclosure:

drivers/scsi/ses.c:ses_intf_remove_enclosure() {
    ...
    kfree(ses_dev->page10);
    kfree(ses_dev->page1);
    kfree(ses_dev->page2);
    kfree(ses_dev);

    if (edev->components)
        kfree(edev->component[0].scratch);

    put_device(&edev->edev);
    enclosure_unregister(edev);
}

Since enclosure_unregister() is what disables the sysfs interfaces, could a
concurrent access to a sysfs attribute like fault during device removal
invoke ses_get_page2_descriptor() and dereference the already freed
edev->scratch?

[Severity: High]
This is a pre-existing issue, but does this loop overread the buffer during
page 1 enclosure descriptor parsing?

If a device provides a page 1 diagnostic page where the length allows
entering the loop with fewer than 4 bytes remaining:

drivers/scsi/ses.c:ses_intf_add() {
    ...
    for (i =3D 0; i < num_enclosures && type_ptr < buf + len; i++) {
        types +=3D type_ptr[2];
    ...
}

Does the loop unconditionally access type_ptr[2] and type_ptr[3], reading o=
ut
of bounds?

[Severity: High]
This is a pre-existing issue, but is there a buffer overread during page 7
overall descriptor parsing?

If the device provides a page 7 length smaller than 8 bytes, buf is allocat=
ed
with fewer than 8 bytes:

drivers/scsi/ses.c:ses_enclosure_data_process() {
    ...
    desc_ptr =3D buf + 8;
    len =3D (desc_ptr[2] << 8) + desc_ptr[3];
    ...
}

Does this read desc_ptr[2] out of bounds before any bounds validation takes
place?

[Severity: High]
This is a pre-existing issue, but does ses_show_id() leak uninitialized heap
memory?

The ses_show_id function reads an 8-byte identifier from ses_dev->page1 at
offset 12:

drivers/scsi/ses.c:ses_show_id() {
    ...
    unsigned long long id =3D get_unaligned_be64(ses_dev->page1+8+4);
    ...
}

If the device-provided page 1 is not verified to be at least 20 bytes long,
could a shorter page result in reading out-of-bounds adjacent kernel heap
memory and exposing it via the sysfs output?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706-b4-disp-29=
a05ca3-v1-1-49591f469f60@proton.me?part=3D1
