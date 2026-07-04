Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCB01D6DA9
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jul 2026 01:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783127828; cv=none; b=EFLnW15uLbQdr48jWzF7SAJ+Zg47E8R7dEYFVmejseZEW6X3LFSVtbanru9UGxdkL3BOlEii6PvaPe43Exdjqm1pdf2jA3bQU7BvCUtYyyhKIMbq4XMLbqtZmRLHehdtZFuHbajE0MxKy+2Ah6JWEEsMeqj2FamK3EoK1NQziXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783127828; c=relaxed/simple;
	bh=ilWFPjnsOrAgXPJlODMkkLtBpBmlZqKoIa39mp21xwU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ppoXw1jWdqb69HZNYPvxLUI9W2W/xHGPTVtLuaYYmUXhsajkKH2EWDal5rw3hCNzKOM1zMvLypi4xxKSnD4FanlJrwUafYxVTU4LUQ0JpKsVF3ZYtI2yf+8M9e21Dae9UvEtk+6UsnV+1z4AEttimfzujDk01IEDyZKC0rkoJek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FiQqwUxI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FiQqwUxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B9E1F000E9;
	Sat,  4 Jul 2026 01:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783127827;
	bh=srVTBYhwJYxTwhWnSAgJWs0FxXbx8/UUhllSNrwFsTM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FiQqwUxIaY7x+9gMJNBX2x+Ic8Jl3lP4Bp1UYkB3cfIoAKM0+bzLGZFF3pmipJKZP
	 JHrn/TouvZh3dUtsVVV84uk2BNXdk3OQUbEdSxothR8/nreDa2jWLzmpcLbjfep9Lk
	 4SHaIVRo18axFWaVHNxlZdw6lhI40y7uArhntlemj+jWvzjor8EQJFU/KOeMB/nv9l
	 LMgtPAnX4s4sq0/GNa8SiJ0UFE478jneuhdxWWBJ+wM9TvM5yF/foNGjjHGxBg01j7
	 i/l/3pvRVbj0HZuL/0oF9146xiCo8jzhA4cQKs67Cds8+KIW8osHJQnLrAX2dADJ3k
	 R18WbIXLD/oyg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: 3w-sas: bound firmware error string parsing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260704010619.81878-1-pengpeng@iscas.ac.cn>
References: <20260704010619.81878-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 04 Jul 2026 01:17:06 +0000
Message-Id: <20260704011707.22B9E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete Security Fix / Missing Bug Fix in Sibling Driver
- [High] Use-After-Free (UAF) in character device ioctl
- [Medium] Teardown Asymmetry breaks all remaining controllers on single de=
vice removal
- [Medium] Incorrect endianness conversion for hardware error code in print=
k statement
- [Low] Missing endianness annotations on hardware structures hides bugs
--

commit 027577f5ce5e60299d84e8b1953276ed554014b3
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

scsi: 3w-sas: bound firmware error string parsing

3w-sas parses two NUL-separated firmware strings from the fixed
err_specific_desc[] field.  The AEN and sense paths locate the second
string with strlen(first) + 1 before guaranteeing that the first
string is terminated inside the array.

Force a terminator in the fixed field before parsing, use strnlen()
for the first and optional second strings, and copy only the bytes
known to reside in err_specific_desc[].

> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index 52dc1aa639f7e..0a5e23819a826 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c

[ ... ]

> @@ -250,11 +251,21 @@ static void twl_aen_queue_event(TW_Device_Extension=
 *tw_dev, TW_Command_Apache_H
>  	tw_dev->error_sequence_id++;
> =20
>  	/* Check for embedded error string */
> -	error_str =3D &(header->err_specific_desc[strlen(header->err_specific_d=
esc)+1]);
> -
>  	header->err_specific_desc[sizeof(header->err_specific_desc) - 1] =3D '\=
0';
> -	event->parameter_len =3D strlen(header->err_specific_desc);
> -	memcpy(event->parameter_data, header->err_specific_desc, event->paramet=
er_len + 1 + strlen(error_str));
> +	desc_len =3D strnlen(header->err_specific_desc,
> +			   sizeof(header->err_specific_desc));
> +	error_str =3D "";
> +	error_len =3D 0;
> +	if (desc_len + 1 < sizeof(header->err_specific_desc)) {
> +		error_str =3D &header->err_specific_desc[desc_len + 1];
> +		error_len =3D strnlen(error_str,
> +				    sizeof(header->err_specific_desc) -
> +				    desc_len - 1);
> +	}
> +
> +	event->parameter_len =3D desc_len;
> +	memcpy(event->parameter_data, header->err_specific_desc,
> +	       desc_len + (error_len ? 1 + error_len : 0));

[Severity: High]
This is a pre-existing issue, but the exact same vulnerability patched by=20
this commit in 3w-sas.c appears to be present in the sibling 3w-9xxx.c
driver.

Does twa_aen_queue_event() in drivers/scsi/3w-9xxx.c also need this string
termination fix to prevent a heap buffer overflow when writing to the
event->parameter_data array?

>  	if (event->severity !=3D TW_AEN_SEVERITY_DEBUG)
>  		printk(KERN_WARNING "3w-sas:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n",

[ ... ]

> @@ -862,12 +873,19 @@ static int twl_fill_sense(TW_Device_Extension *tw_d=
ev, int i, int request_id, in
>  	TW_Command_Full *full_command_packet;
>  	unsigned short error;
>  	char *error_str;
> +	size_t desc_len;
> =20
>  	header =3D tw_dev->sense_buffer_virt[i];
>  	full_command_packet =3D tw_dev->command_packet_virt[request_id];
> =20
>  	/* Get embedded firmware error string */
> -	error_str =3D &(header->err_specific_desc[strlen(header->err_specific_d=
esc) + 1]);
> +	header->err_specific_desc[sizeof(header->err_specific_desc) - 1] =3D '\=
0';
> +	desc_len =3D strnlen(header->err_specific_desc,
> +			   sizeof(header->err_specific_desc));
> +	if (desc_len + 1 < sizeof(header->err_specific_desc))
> +		error_str =3D &header->err_specific_desc[desc_len + 1];
> +	else
> +		error_str =3D "";
> =20
>  	/* Don't print error for Logical unit not supported during rollcall */
>  	error =3D le16_to_cpu(header->status_block.error);

[Severity: Medium]
This isn't a bug introduced by this patch, but does the printk statement
immediately following this line log the byte-swapped hardware error code on
big-endian architectures?=20

The code correctly converts the hardware error code to local endianness
using le16_to_cpu(header->status_block.error), but then passes the
unconverted header->status_block.error to %04X instead of using the local
error variable.


While reviewing these changes, I noticed a few other pre-existing issues
in this driver that might be worth looking into:

[Severity: High]
This is a pre-existing issue, but is it possible for a use-after-free to
occur if a user-space process opens /dev/twl and the PCI device is
hot-removed?

In twl_remove(), scsi_host_put() frees the device structure without clearing
the pointer from twl_device_extension_list:

drivers/scsi/3w-sas.c:twl_remove() {
    ...
    scsi_host_put(tw_dev->host);
    pci_disable_device(pdev);
    twl_device_extension_count--;
    ...
}

Could a subsequent ioctl call to twl_chrdev_ioctl() dereference the freed
pointer since it unconditionally fetches it from the global array?

drivers/scsi/3w-sas.c:twl_chrdev_ioctl() {
    ...
    TW_Device_Extension *tw_dev =3D twl_device_extension_list[iminor(inode)=
];
    mutex_lock(&twl_chrdev_mutex);
    if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
    ...
}

[Severity: Medium]
This is a pre-existing issue, but does twl_remove() unconditionally destroy
the management ioctl interface for all active controllers?

If one controller is unbound on a multi-controller system,
unregister_chrdev() is called and twl_major is set to -1, which might break
communication with the remaining controllers:

drivers/scsi/3w-sas.c:twl_remove() {
    ...
    if (twl_major >=3D 0) {
        unregister_chrdev(twl_major, "twl");
        twl_major =3D -1;
    }
    ...
}

[Severity: Low]
This is a pre-existing issue, but should the hardware-defined structures
like TW_Command_Apache_Header use __le16 instead of unsigned short for
fields like error?

drivers/scsi/3w-sas.h:TAG_TW_Command_Apache_Header {
    ...
    unsigned short error;
    ...
}

Using __le16 might help static analysis tools catch endianness regressions
like the printk bug mentioned above.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260704010619.8187=
8-1-pengpeng@iscas.ac.cn?part=3D1
