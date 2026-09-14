Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D7845C701;
	Mon, 14 Sep 2026 16:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789402688; cv=none; b=EGl3geq8bxehDa7B/5atL5uoHMlwpxazu4zo+mqmibl6u0bbwEk1GFgvZdw2W3faywJh5Fz6NrsKkogDyh9IBm6k3dUKHKCO5hDELTT8wmRM7VALZpk6zjqbSvB3Fg6GUvPsOSoWGGuHrtA3HoKxhZfd7SslpzMg19WLZZm4pRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789402688; c=relaxed/simple;
	bh=1owmOdr4P0WV06uy2lm39eCfjnzfe9vtxRt7Pr4+Irc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LZuo9OOVDAFbjhDZEgJhGOkxHMv475e0ZfQG0cWYTXNfIcSaZn9Wy14NwgKtVul9H+x/231wq7RgN4ilDuLU6cu5WijrjO9CUQW2bZIgrXoJ1Xtdm0+ejmrBSBsofiPhZdsGAJXpOpWUn91JUPKyqOWGkKs52XM2y7modPar2/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AzSMaKiH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AzSMaKiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2594A1F000FF;
	Mon, 14 Sep 2026 16:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789402687;
	bh=9od9Up32sF6E9LMweXBSOobe1mrdOP2km13EpNw1aaI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AzSMaKiHvPImX3wB6bWcLxw3ylXaQMX+dybvo62fPF2shgf6NhQAs+k1WCQ5tWo4y
	 ONhgtm+5rmM0ilTwVlkaNoTbsJvo5yP4RJn2/z8P5hkM/4DAeHIExQ/1JSKYrvmm6Q
	 XYW5fxIlIN2hgjWVe/QrjDI9nqIiII5bWdGLuX/+k8yvSRJHKCAfRaFA4CiLx00cf8
	 4i8jzLBhNhfME7yLhgRhoA2/gkFtw0DBRG7skQT3AHrhXN9wK1CQRnIUZWSgQ7mmEj
	 gR94eX8m1v/RyPdglBpSBLb4F03AMeO4z1TfGlGll4K0bBmes6V8p7s6cSvnlKQm6s
	 ZhttbbKt88/Pg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/40] mm: consistently validate VMA state after
 mmap[_prepare] hooks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Heiko
 Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, kvmarm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, linux-rdma@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-4-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-4-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 16:18:05 +0000
Message-Id: <20260914161806.2594A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Premature execution of vma_close() before unmap_region() during va=
lidation failure creates a Use-After-Free race window.
- [High] Restoring vma->vm_start before calling unmap_region() on the valid=
ation error path leaves orphaned PTEs, causing permanent UAF.

Pre-existing issues:
- [High] mmap_validate() fails to check if a driver erroneously sets VMA_WR=
ITE_BIT on a mapping without VMA_MAYWRITE_BIT, allowing read-only files to =
be mapped writable.
- [High] mmap_validate() fails to check if a driver alters vma->vm_end, whi=
ch silently corrupts the maple tree.
--

commit d07b85544000595b057fc1ff43289af0359a7b6c
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm: consistently validate VMA state after mmap[_prepare] hooks

This patch generalizes VMA state validation checks for both mmap_prepare
and legacy mmap hooks. It aims to ensure that drivers do not violate
invariants, such as altering the VMA start address or creating writable
mappings on read-only files, and adds validations for insert_vm_struct().

> diff --git a/mm/internal.h b/mm/internal.h
> index fe576d468af45..1ed11eaf276a7 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
[ ... ]
> @@ -239,26 +260,16 @@ static inline int mmap_file(struct file *file, stru=
ct vm_area_struct *vma)
>  	 */
>  	if (unlikely(err || !vma->vm_ops))
>  		vma->vm_ops =3D &vma_dummy_vm_ops;
> +	if (unlikely(err))
> +		return err;
> =20
> -	return err;
> -}
> -
> -/*
> - * If the VMA has a close hook then close it, and since closing it might=
 leave
> - * it in an inconsistent state which makes the use of any hooks suspect,=
 clear
> - * them down by installing dummy empty hooks.
> - */
> -static inline void vma_close(struct vm_area_struct *vma)
> -{
> -	if (vma->vm_ops && vma->vm_ops->close) {
> -		vma->vm_ops->close(vma);
> -
> -		/*
> -		 * The mapping is in an inconsistent state, and no further hooks
> -		 * may be invoked upon it.
> -		 */
> -		vma->vm_ops =3D &vma_dummy_vm_ops;
> +	err =3D mmap_hook_validate(prev_start, &prev_flags, vma);
> +	if (unlikely(err)) {
> +		vma->vm_start =3D prev_start;

[Severity: High]
If a driver's legacy mmap hook erroneously decreases vma->vm_start (expandi=
ng
the VMA downwards) and populates PTEs in that expanded range,
mmap_hook_validate() catches the violation. By forcing vma->vm_start back to
prev_start here before __mmap_new_file_vma() invokes unmap_region(), doesn't
that initialize the unmap operation with the smaller, restored address rang=
e?
This would cause unmap_region() to skip the expanded PTEs, leaving them
orphaned and causing a permanent use-after-free since the backing memory ge=
ts
freed. Should the unmap occur before restoring the start address?

> +		vma_close(vma);

[Severity: High]
Is it safe to invoke vma_close() here immediately on validation failure?
If a driver successfully populates page tables (for example, via
remap_pfn_range) but fails the mmap_hook_validate() checks, calling
vma_close() frees driver memory prematurely. Since unmap_region() is not
called until mmap_file() returns to __mmap_new_file_vma(), hardware PTEs
remain populated while the backing resources are freed, creating a
use-after-free race window.

>  	}
> +
> +	return err;
>  }
> =20
>  /* unmap_vmas is in mm/memory.c */
> diff --git a/mm/vma.c b/mm/vma.c
> index dc74b3d721cc5..626a18c08a269 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
[ ... ]
> @@ -2777,6 +2762,76 @@ static void __mmap_complete(struct mmap_state *map=
, struct vm_area_struct *vma)
>  	vma_set_page_prot(vma);
>  }
> =20
> +/* Check to ensure that the VMA flags of a newly mapped VMA are sane. */
> +static int mmap_validate_vma_flags(const vma_flags_t *flags)
> +{
[ ... ]
> +/* Check to ensure a driver hasn't done something crazy. */
> +static int mmap_validate(unsigned long prev_start,
> +			 unsigned long curr_start,
> +			 const vma_flags_t *prev_flags,
> +			 const vma_flags_t *curr_flags)
> +{
> +	bool was_maywrite, is_maywrite;
> +
> +	/* Drivers cannot alter the address of the VMA. */
> +	if (WARN_ON_ONCE(prev_start !=3D curr_start))
> +		return -EINVAL;

[Severity: High]
This isn't a bug introduced by this patch, but since the patch aims to
implement comprehensive VMA state validation after mmap hooks, shouldn't it
also verify that the end address (vma->vm_end) remains unmodified? If a
buggy driver alters vm_end, the VMA object's bounds will mismatch the maple
tree node's pre-allocated bounds. This structural inconsistency corrupts
the maple tree and can lead to kernel panics later.

> +
> +	was_maywrite =3D vma_flags_test(prev_flags, VMA_MAYWRITE_BIT);
> +	is_maywrite =3D vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
> +
> +	/* A driver may not make a previously unwritable mapping writable. */
> +	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
> +		return -EINVAL;

[Severity: High]
This is a pre-existing issue, but this check appears to bypass a critical
condition. It only evaluates VMA_MAYWRITE_BIT. If a malicious or buggy
driver bitwise-ORs VMA_WRITE_BIT into vma->flags in its mmap hook without
setting VMA_MAYWRITE_BIT, wouldn't it bypass this check completely? This
could allow a read-only file mapping to be committed with VM_WRITE set,
granting hardware write permissions and allowing an unprivileged user to
overwrite read-only files.

> +
> +	return mmap_validate_vma_flags(curr_flags);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D4
