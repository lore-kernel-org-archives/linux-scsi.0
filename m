Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044723BA24F
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 04:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783313126; cv=none; b=tYaHxn/l5ly6BkyPmrBBe4wulsjTRX7KIRs17zzBt5O/bjJLhBuAHiuVUq7odkrK7aXq/cuby7WnLDuiTcZayg8RNWtJ/nFLuIwMp8MTFQe3kmvQNAJknF4G+sRJBK9HVD9Hh2hh9hOhMwvMG02LHIR3F5efKyD+svy7wDBwEhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783313126; c=relaxed/simple;
	bh=ERa+7hkucw11oJL/ba6AAo+M0lxYMSdGpiynEJ64zHA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PoerNMbaCKeU5ve7ypEM86g6+5P/fJyo+HN3MwLahmcKBV3zYdmCd0BWu4gszZY029+I5HSNZqNG0xGvb3IDBjXNvEhNmlgFRkXsWi7ILqeIgMapSJAyxxK7fodLTOxiuOJwkZBQHgH3Nrxd/Uaph9ReoXgxJUWGIaWyoc3JruQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zj7lhSK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zj7lhSK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161AF1F000E9;
	Mon,  6 Jul 2026 04:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783313124;
	bh=AlkGeT6mBj49P2nTtKB5g6ltioO8nYa4bqL5Iti+dzY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zj7lhSK2/WQURWyTeaZqMJlAAgkIuy93ZRHjU0Jnl0TmUMdG7cFSimb/cFdqCZntn
	 UKxfTH73XDD6ekvcOup/sWgMFLpOb8azpv2NfLPU6bT42GxDQ2su6fcttAEhBkoFO2
	 /K71r1IYVOvVDuLQf0tSpV3NznWMoSoBiSVGeU4zNgkbX/soFPJ0UeUwjdbQjlWvDl
	 r4xwiR9llU8ytAr/KP/lML9E3rZVQX/9tOyogT8J2ckUShJHOdU+ZK9PDfPqQRK8Z8
	 fB0liLzquNTZglCavUlXopY1YjxN6zrmEiJbApJiJtMjAGYPA5RL695oaxUKt5zFw5
	 dAZOf1RECIkEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ses: skip an enclosure status page shorter than
 its header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260705-b4-disp-e1aca452-v1-1-1dab8448608c@proton.me>
References: <20260705-b4-disp-e1aca452-v1-1-1dab8448608c@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 04:45:23 +0000
Message-Id: <20260706044524.161AF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch prevents a `memset` length underflow by skipping Page 2 =
processing if `len < 8`, but fails to ensure that `page2` is large enough t=
o hold all component descriptors defined in Page 1, leaving out-of-bounds r=
eads and writes unpatched.
- [High] Missing length validation for Page 1 leads to out-of-bounds reads =
during descriptor parsing, leading to artificially large component counts.
- [High] Missing bounds check on Page 7 length leads to an unconditional ou=
t-of-bounds read.
- [High] Reading the `id` sysfs attribute leaks up to 8 bytes of uninitiali=
zed or adjacent kernel heap memory to user-space.
--

commit 30f64f6103a88369da925d5a9a969b26cc05a865
Author: Bryam Vargas <hexlabsecurity@proton.me>

scsi: ses: skip an enclosure status page shorter than its header

This commit prevents a heap out-of-bounds write by ensuring that the diagno=
stic
page 2 length is at least 8 bytes. It skips the page if the length is short=
er
than its header.

> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 4c348645b04ee..f77054695e125 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -766,6 +766,9 @@ static int ses_intf_add(struct device *cdev)
>  		goto page2_not_supported;
> =20
>  	len =3D (hdr_buf[2] << 8) + hdr_buf[3] + 4;
> +	/* a status page too short for its 8-byte header carries no page 2 */
> +	if (len < 8)
> +		goto page2_not_supported;

[Severity: High]
This is a pre-existing issue, but does this check go far enough to prevent
out-of-bounds accesses for page 2?

While this ensures the buffer is at least 8 bytes, it doesn't guarantee it =
is
large enough to hold all component descriptors defined in page 1.

In both ses_set_page2_descriptor() and ses_get_page2_descriptor(), the loops
advance desc_ptr based on page 1 element counts:

drivers/scsi/ses.c:ses_set_page2_descriptor() {
    ...
				memcpy(desc_ptr, desc, 4);
				/* set select */
				desc_ptr[0] |=3D 0x80;
    ...
}

If page2_len is 8, but page 1 defined multiple components, could these loops
still read or write past the end of the page 2 allocation?

[Severity: High]
This is a pre-existing issue, but does page 1 also suffer from missing leng=
th
validation that can lead to out-of-bounds reads?

When parsing page 1 elements earlier in ses_intf_add(), the loop condition =
only
checks the pointer address:

	for (i =3D 0; i < num_enclosures && type_ptr < buf + len; i++) {
		types +=3D type_ptr[2];
		type_ptr +=3D type_ptr[3] + 4;
	}

If len is short (e.g., 9 bytes), the loop body unconditionally accesses
type_ptr[2] and type_ptr[3], reading past the end of the allocation.

This could populate page1_num_types (the types variable) with untrusted heap
data.

Later in ses_enclosure_data_process(), the code iterates using this untrust=
ed
types count without verifying against page1_len:

	for (i =3D 0; i < types; i++, type_ptr +=3D 4) {
		for (j =3D 0; j < type_ptr[1]; j++) {

Could this lead to further out-of-bounds memory accesses?

[Severity: High]
This is a pre-existing issue, but is there a similar missing bounds check on
page 7?

In ses_enclosure_data_process(), the page 7 length is derived from its head=
er.

If the device returns a length smaller than 8, the buffer is allocated too
small, but the code still unconditionally reads offsets 10 and 11:

		desc_ptr =3D buf + 8;
		len =3D (desc_ptr[2] << 8) + desc_ptr[3];

Could this lead to an unconditional out-of-bounds read if the page 7 buffer=
 is
smaller than 12 bytes?

[Severity: High]
This is a pre-existing issue, but can ses_show_id() leak adjacent kernel he=
ap
memory to user-space?

If a device returns a page 1 shorter than 20 bytes, ses_intf_add() will all=
ocate
a small buffer.

However, ses_show_id() unconditionally reads 8 bytes from offset 12:

	unsigned long long id =3D get_unaligned_be64(ses_dev->page1+8+4);

	return sprintf(buf, "%#llx\n", id);

If page1_len is not validated, could this expose uninitialized or adjacent
heap memory via the id sysfs attribute?

>  	buf =3D kzalloc(len, GFP_KERNEL);
>  	if (!buf)
>  		goto err_free;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260705-b4-disp-e1=
aca452-v1-1-1dab8448608c@proton.me?part=3D1
