Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECCF3BCD3F;
	Mon, 14 Sep 2026 19:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789413257; cv=none; b=Hm5mRLwOeUAoYrB+qOyhnsf0grcsgO8kCEqRChdpgUC3FwYVfcNmcl2lbYLsYEsob/Z92QuIFkqt9DhhaWIRWRfNto0RWLcE0GAJVoHG3ynttgeGsPXPd0hiWHHMi9JWDja2WdP+diPssiVxs/B3qicwWGr6Ul7Cnj+eHL5Fs6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789413257; c=relaxed/simple;
	bh=SRFDGk3qpnc8cxJg10D+z8x4vSYb1keyRTEcClt1Qac=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CeveRaekH8d3G8N0ENUqsj5CgI1wVDNyztLje4TngvTJZMyig7SiHQxoH9vmaAKkkS0T3uX1LBAOp6zZM8jpPUqKCJxcAgjWKPisAYZlD3vJC8ONbQK3DhRCwW2ZF/SL7SoQxXd1nP+iExYH7rn2P/+q2K83a+KMjELxOGPS/Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdyOzcNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdyOzcNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601501F000FF;
	Mon, 14 Sep 2026 19:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789413248;
	bh=qqxU0Tn+w3Hq00cDDV6qBR7mESGDkdB5AXWrXBPmMYo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fdyOzcNXteGBR+HJ16HFzmf2Ocq5Jt8sfM5EH6vMJ7T+zPMdR4Dl2pc2jPpc8L+Kh
	 P/KbIo7c59agqkkQ5OZMKCQbzKTfagtUUv2IpxJ29pB6ZOAzWPs4Rmh8frKdylgb5j
	 j6ZcoEgypvV4fpIvRFM9yU2FJAu2Jf4hUzxgUsTBscpmLrq5X1BRYZ3biRuT67UKO6
	 f1uhUuQy20b3kMZF+yxm2/yHksUQoGzX3CbwCZTR7J7onEFAr0TABQnjEF8+Jz1wL3
	 0SEgHEgGUx1j6IKLOUWUlsN22yQB0oUvc0Mn7dv5aSiqh49wd75yuhb28dTQU9MkwJ
	 QxO8+18KURdZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 16/40] mm/vma: only allow mmap to clear
 VMA_MAYWRITE_BIT if kernel-owned
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: bpf@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, kvm@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, selinux@vger.kernel.org, linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-16-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-16-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 19:14:06 +0000
Message-Id: <20260914191407.601501F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] VMA flags and `pgoff` modifications performed by `mmap_action_=
prepare()` are lost in `call_mmap_prepare()`, resulting in missing `VM_MIXE=
DMAP` / `VM_PFNMAP` flags on the final VMA.
--

commit 7ddd38612e8ff73188b344ec633bfe65678e0dce
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT if kernel-owned

For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
the underlying file is itself read-only.

[ ... ]

As all drivers which clear VMA_MAYWRITE_BIT establish kernel-owned
mappings, no functional change is intended.

> diff --git a/mm/vma.c b/mm/vma.c
> index 2648fb0e19959..d71ec51255b18 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2795,6 +2795,11 @@ static int mmap_validate(unsigned long prev_start,
>  	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
>  		return -EINVAL;
> =20
> +	/* Only kernel-owned mappings may clear VMA_MAYWRITE_BIT. */
> +	if (!vma_flags_is_kernel_owned(curr_flags) &&
> +	    WARN_ON_ONCE(was_maywrite && !is_maywrite))
> +		return -EINVAL;
> +
>  	return mmap_validate_vma_flags(curr_flags);
>  }

[Severity: Critical]
This isn't a bug introduced by this patch, but while reviewing mm/vma.c,
I noticed a potential issue in call_mmap_prepare():

mm/vma.c:call_mmap_prepare() {
	/* Update fields permitted to be changed. */
	map->pgoff =3D desc->pgoff;
	if (desc->vm_file !=3D map->vm_file)
		map->vm_file =3D desc->vm_file;
	map->vma_flags =3D desc->vma_flags;
	map->page_prot =3D desc->page_prot;
	/* User-defined fields. */
	map->vm_ops =3D desc->vm_ops;
	map->vm_private_data =3D desc->private_data;

	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
	if (!desc->vm_ops)
		return -EINVAL;

	err =3D call_action_prepare(map, desc);
	if (err)
		return err;
}

Are the VMA flags and pgoff modifications performed by call_action_prepare()
lost here? Since map->vma_flags and map->pgoff are initialized from desc
before calling call_action_prepare(), the updated fields in desc are never
synchronized back to map.

Could this lead to missing VM_MIXEDMAP or VM_PFNMAP flags on the final VMA?

If unprivileged userspace calls mmap() on a driver using remap_pfn_range(),
might the core memory management subsystem treat hardware/PFN mapped pages
as normal anonymous or file-backed RAM pages?=20

This could result in the kernel attempting to manage page reference counts =
on
arbitrary physical I/O memory PFNs when the VMA is later unmapped or
accessed, potentially leading to immediate crashes or silent corruption.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D16
