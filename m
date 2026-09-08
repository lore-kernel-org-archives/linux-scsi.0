Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0853B71A5;
	Tue,  8 Sep 2026 20:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899996; cv=none; b=U1NyawUW6AnqlJyOAT0UUkbnGW0MNFOEagLrc2ZjRap4VTTQ1eesfuLqdTW8jz1evjbx3F52OOqGdcliZCY8ZFKgb6ZS5bK3XzTQsyXePXUHUdKbZqal3bFu0cBMZXmpZ3fxP0PFYgWF8FPsVyOKmap9/0xwxuDao3Aad7MyADM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899996; c=relaxed/simple;
	bh=RZAqAh0KcoOYwfJJg3T/gWNuSmqEb8yGxluKle4/q6o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Vyz+18HXrIeL05+2goSM1jieqX+ULKKMW4eHec7thsr1MSVIpwtib14RJwnDzVvwf94V5m9SRzYNlFRUhBVwDaRC/ER9skVb+x6NX2N61pXawRte4EBikrQW0RITkH7Z9tpDKHeUPUYIIpjRr7JbG+hWRWS1+93fv+rTZpUgomU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSPf0ROu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSPf0ROu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08E61F00A3A;
	Tue,  8 Sep 2026 20:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899994;
	bh=+SEM3hwrzWq3mSCFdua4tIVPxVP/retHRbMIyziJQIU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GSPf0ROuoxv6AIUXZlyAPE+erQ9K/8DmEYgX/+fSgPEIhGhynCfR1AUewkUDnI5wL
	 owrBlAtq5wFAXD9vWDV31CqzPtPWs0d+ns+T3+aMQVn5qGaXxZg/sVjxZFMstb8OvV
	 gVaUIz2zqwuQhcG1KQjzgK7h99P0Cy34181jjLq4EeNtzRKCsJq5TlN1/tWqpBBAhM
	 Dw1hE7r5T24qOz2hElGC9DmNQNhm+uMwUW5skmeWVdO9gO0EGb7cAO6oinaT08e75m
	 uzGmOgj6a51jTIl/qL+obbPIBsJ8X18Nwok9jc8ONjV7duHsYgkCWOBpeXSzC8Okf0
	 aRJ5A5quWx3VQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 18/39] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO,
 add VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, bpf@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, kvm@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-18-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-18-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:39:53 +0000
Message-Id: <20260908203953.B08E61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unchecked return value of fb_deferred_io_init() in ssd1307fb_probe=
() leads to a NULL pointer dereference in fb_deferred_io_mmap().
--

commit 20b4c9f03621ce152d836b82e0b4d3c3cda114ce
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>
fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add VM_MIXEDMAP

This commit updates defio drivers to assert the FBINFO_VIRTFB flag, drops
the VM_IO flag, and sets VM_MIXEDMAP since kernel-allocated memory is mappe=
d.
It also ensures the ssd1307fb driver sets FBINFO_VIRTFB during its probe.

> diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/co=
re/fb_defio.c
> index fd00b86e1ae60..fb359ecc39661 100644
> --- a/drivers/video/fbdev/core/fb_defio.c
> +++ b/drivers/video/fbdev/core/fb_defio.c
> @@ -366,13 +366,13 @@ int fb_deferred_io_mmap(struct fb_info *info, struc=
t vm_area_struct *vma)
>  {
>  	vma->vm_page_prot =3D pgprot_decrypted(vma->vm_page_prot);
> =20
> +	if (WARN_ON_ONCE(!(info->flags & FBINFO_VIRTFB)))
> +		return -EINVAL;
>  	if (!try_module_get(THIS_MODULE))
>  		return -EINVAL;
> =20
>  	vma->vm_ops =3D &fb_deferred_io_vm_ops;
> -	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
> -	if (!(info->flags & FBINFO_VIRTFB))
> -		vm_flags_set(vma, VM_IO);
> +	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP);
>  	vma->vm_private_data =3D info->fbdefio_state;
> =20
>  	fb_deferred_io_state_get(info->fbdefio_state); /* released in vma->vm_o=
ps->close() */

[Severity: High]
This isn't a bug introduced by this patch, but could this lead to a NULL
pointer dereference if fb_deferred_io_init() previously failed?

If memory allocation fails during fb_deferred_io_init() in the driver probe,
it returns an error code and leaves info->fbdefio_state as NULL. When a
userspace program maps the framebuffer, fb_deferred_io_mmap() unconditional=
ly
passes the NULL info->fbdefio_state to fb_deferred_io_state_get(), which wi=
ll
subsequently dereference it via kref_get().

[ ... ]

> diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd130=
7fb.c
> index c4fdecafd8560..958514a354338 100644
> --- a/drivers/video/fbdev/ssd1307fb.c
> +++ b/drivers/video/fbdev/ssd1307fb.c
> @@ -763,6 +763,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
>  	info->fix.smem_start =3D __pa(vmem);
>  	info->fix.smem_len =3D vmem_size;
> =20
> +	info->flags =3D FBINFO_VIRTFB;
> +
>  	fb_deferred_io_init(info);

[Severity: High]
This is a pre-existing issue, but the return value of fb_deferred_io_init()
is ignored here in ssd1307fb_probe().

Should we check the return value of fb_deferred_io_init() and handle the
potential allocation failure so we don't proceed with a NULL
info->fbdefio_state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D18
