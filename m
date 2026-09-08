Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B854B4863;
	Tue,  8 Sep 2026 20:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899919; cv=none; b=P6Zqizum5QQIk4lAPovEGUznyx63KdLgL+lPe3Lr47taYUFzFp5j6RIWuFF/qYjGho2DpExIDoO+IoTLs0CWX2/cMhxU1kjtioLBQwHFaJCyfOf2a92zw4NK39hKUpchOHWQcR/GIhvZ90sDcpwbZisYvW+xB1tkpsfkBE5qvS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899919; c=relaxed/simple;
	bh=ppmARh4Pmn96MNd49lZT/DDe52REhZyU99fBknWw2e0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Bg0qMwHYgx+bkDdql1u30hzou6JhU30G3KfV5lln5DN+n+VUGk0svLlBw9oiRB9/YnTX5cmX3SJ5VSnpK4nYPKQ7FB+/viG6BL1GQmu/TdOG2hIGVYtBuVJjabo9U0JFdNRycdja1Cfzydz3PHKlpwG5WVjI6QwpVqiSsUNiyTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k6phVvwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k6phVvwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C7C1F00A3A;
	Tue,  8 Sep 2026 20:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899918;
	bh=bC+w9KXVcmk/AeVg0oQOtYsspFdleloBnGxxXSPVx28=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k6phVvwpts028nsCxBmHTn1C9SnFPiUTA6JEYxZ/De4o09yhv6LcJTNPGiLVdOrmE
	 AfMoMBmLvfYQAIt8tEx6kbGCkreixnSJWwa5PI3R2jiRjmWsPTB2N1qwA0BeIj6+CD
	 VIT3DZDL1+d0NeTbVAj9NxwfpAHqvNRRTIZ/yqLotwPQsZ+QVZAUPblwTIpLEW7Jhk
	 nkmtSyer6Fdk2nZ8bByZ3atzIfvxqqfMwpWueOLoMatPdyHiRVk2zzkVZyo7UuqARO
	 kB1vFDms8RKAi7kvLofPqN9SPTQoGKb53KcEtD9FnVYk2NoeMqryYS6yne6FNE9jX9
	 8KYXaUjd6kAcQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/39] docs: filesystems: update mmap_prepare docs for
 discontig kernel pgs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, kvmarm@lists.linux.dev, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-8-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-8-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:38:36 +0000
Message-Id: <20260908203837.48C7C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Insufficient Validation of nr_pages (Integer Overflow and Zero-Pag=
e Hang)
--

commit 0017a54bcba2043c3f552b308a32a39be664f463
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm: add mmap action for discontiguous kernel page mapping

The existing kernel page mapping mmap actions allow for partial and full
mapping of an array of struct page pointers.

However some drivers require the mapping of discontiguous ranges. Permit
this by providing discontig_kernel_page_ops which allows a driver to
specify how the operation should begin and how batches of pages should be
retrieved.

> diff --git a/mm/memory.c b/mm/memory.c
> index dc38cad1dcb7e..8c9675451d4ba 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c

[ ... ]

>  int map_kernel_pages_prepare(struct vm_area_desc *desc)
>  {
>  	const struct mmap_action *action =3D &desc->action;
>  	const unsigned long addr =3D action->map_kernel.start;
>  	unsigned long nr_pages, end;
> =20
> -	if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
> -		VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
> -		VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> -		vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> -	}
> +	__map_kernel_pages_prepare(desc);
> =20
>  	nr_pages =3D action->map_kernel.nr_pages;
>  	end =3D addr + PAGE_SIZE * nr_pages;
>  	if (!range_in_vma_desc(desc, addr, end))
>  		return -EFAULT;

[Severity: High]
Can the end calculation overflow here if nr_pages is exceptionally large?

If a driver supplies an overly large nr_pages, PAGE_SIZE * nr_pages
could wrap to a small value. Because range_is_subset() lacks an
inner_start <=3D inner_end validation, this wrapped end value would
incorrectly pass the range_in_vma_desc() bounds check.

This could lead to inserting PTEs far out of VMA bounds and corrupting page
tables.

[ ... ]

> +int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
> +					struct mmap_action *action)
> +{

[ ... ]

> +	do {
> +		unsigned long end, pgoff_end;
> +		unsigned long nr_pages;
> +
> +		/* Default to abort. */
> +		state.action =3D DISCONTIG_KERNEL_PAGE_ABORT;
> +		err =3D ops->get(&state);
> +		if (err || state.action =3D=3D DISCONTIG_KERNEL_PAGE_ABORT)
> +			return err;
> +		nr_pages =3D state.__nr_pages;
> +
> +		end =3D state.addr + PAGE_SIZE * nr_pages;
> +		if (end > vma->vm_end)
> +			return -EINVAL;

[Severity: High]
Does this bounds check handle a huge nr_pages value correctly?

Similar to the check in map_kernel_pages_prepare(), if nr_pages is
huge, end will wrap to a small value. This bypasses the end > vma->vm_end
check, potentially allowing page table corruption.

> +		pgoff_end =3D state.pgoff + nr_pages;
> +
> +		err =3D apply_discontig_action(vma, &state);
> +		if (err)
> +			return err;
> +
> +		state.addr =3D end;
> +		state.pgoff =3D pgoff_end;
> +		state.nr_pages_mapped +=3D nr_pages;
> +		state.nr_pages_remain -=3D nr_pages;
> +	} while (state.addr < vma->vm_end);

[Severity: High]
Could this result in an infinite loop if nr_pages is 0?

If a driver provides 0 pages (for instance, via
discontig_kernel_map_page_range(..., 0)), end will equal state.addr.

state.addr is then updated with a 0 increment, causing the
while (state.addr < vma->vm_end) loop to execute infinitely and hang
the kernel.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D8
