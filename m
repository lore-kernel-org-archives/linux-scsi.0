Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3103A494810;
	Mon, 14 Sep 2026 17:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789405428; cv=none; b=ZoeDBGZReyU6AesSm5jh+G0gYhNOiaPV5iciICxr0NwSalJRhh0H4ZZj+nQG5ZDMszVuNf2eS5zOze0YqQwqb4DssmLdChhhIdyK2u825fvhmgG6d/MX7OixZU99EaZJeWc8kFJzXjb4WGhnskKdGHCaUgpn/ky6PUI0ki0vx4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789405428; c=relaxed/simple;
	bh=QuH48MOOeTPbUjuBK2hnIMw+7mXuZpBYtySaJvk0oVQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SK3uHpQA4syJj2TqLtJVm1gtn9n4uiwgNPHDGoNeJgqr/MWyqHe94iFJNafM7GiZqkx8TVlL9mvX1TvUgPxyezJn4j38W1AO0A81QNOVQgl89sHnJVML/NRcjFpquSmOI511Z9KuNRSETktdsreeKDrx5qCL1MK9aRjhw1fw+3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDigJBaW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDigJBaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DB81F00893;
	Mon, 14 Sep 2026 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789405426;
	bh=A87ZZ4ZIXjG25h+E/VgyFT4YOkcYOB31l8j6x/jC1qg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bDigJBaWcUieLj1MdiBerCeiv1ArOtysznjXNFW+qSZ6/N08feViBK/fnj7+7MKYz
	 akB8iJsUGfs/nbcGue7bLaOCToWV0XnqcODHLAgjGqaGI3JJlzz+bj1MA5WVFyFsd/
	 ysCe11s7Al8tVGlYXymoyLcnwYwAYR2HR5mvETK3xbuJuN/pltU9HE+U1bNPkZDtMY
	 qATizpjNC2xHH0z6qQWDh0UYCZkaGCR7uN2SGyRBp6V/pAq8Rzh8tbEHyruTYCxBLX
	 D5j1ST3uHQUEDn+SiDQUQLPK6hm2mgZlFaGKCwoXuJ7eLeTzhPEzyLkH1i1pAsuKPq
	 x9L4W1nGwCfTA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/40] mm: add mmap action for discontiguous kernel
 page mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-s390@vger.kernel.org, bpf@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, dri-devel@lists.freedesktop.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-8-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-8-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 17:03:44 +0000
Message-Id: <20260914170344.B2DB81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] `discontig_kernel_map_page()` silently maps entire compound pages =
instead of single pages and maps incorrect memory when passed a tail page.
- [Medium] API design causes an unavoidable memory leak if a driver allocat=
es state in `ops->init()` and a subsequent failure occurs.
- [Low] Missing NULL check for the `ops` struct before dereferencing it in =
validation code.
--

commit d5639a50ca1090febd85053c26c1f0a170b51deb
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Date:   Mon Sep 14 14:57:28 2026 +0000

    mm: add mmap action for discontiguous kernel page mapping

This commit introduces a new mmap action allowing drivers to map discontigu=
ous=20
kernel pages. It adds discontig_kernel_page_ops for defining the mapping=20
operation, including initialization and page retrieval logic. Helpers are=20
provided to map single pages, ranges, or compound pages.

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a1f2d375cf7d8..2a92193ac6a5e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
[ ... ]
> @@ -4647,10 +4647,55 @@ static inline void mmap_action_map_kernel_pages_f=
ull(struct vm_area_desc *desc,
> +static inline void
> +discontig_kernel_map_page(struct discontig_kernel_page_state *state,
> +			  struct page *page)
> +{
> +	struct folio *folio =3D page_folio(page);
> +
> +	if (folio_test_large(folio)) {
> +		VM_WARN_ON_ONCE(page !=3D folio_page(folio, 0));
> +		state->action =3D DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE;
> +		state->__folio =3D folio;
> +		state->__nr_pages =3D min(state->nr_pages_remain,
> +					folio_nr_pages(folio));

[Severity: High]
If a driver passes a tail page here intending to map just that specific pag=
e,=20
does this unintentionally escalate the mapping to the entire compound page?

The API discards the specific page pointer and sets up a folio mapping
instead. Even though there is a warning when passing a tail page, the code
proceeds to map starting from the head page in apply_discontig_action(),
which could expose unrequested kernel memory to userspace.

> diff --git a/mm/memory.c b/mm/memory.c
> index 448342883e9da..42f0845172471 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
[ ... ]
> +int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc)
> +{
> +	const struct mmap_action *action =3D &desc->action;
> +	const struct discontig_kernel_page_ops *ops =3D
> +		action->map_kernel_discontig.ops;
> +
> +	/* At minimum need to be able to get pages. */
> +	if (WARN_ON_ONCE(!ops->get))

[Severity: Low]
Is it possible for the ops pointer to be NULL here?

If a driver erroneously sets up a discontiguous mapping action but passes a
NULL ops pointer, dereferencing ops->get will cause a panic before the
intended validation warning can trigger.

> +		return -EINVAL;
> +
> +	__map_kernel_pages_prepare(desc);
> +	return 0;
> +}
> +
> +static int apply_discontig_action(struct vm_area_struct *vma,
> +				  struct discontig_kernel_page_state *state)
> +{
> +	unsigned long nr_pages =3D state->__nr_pages;
> +	unsigned long addr =3D state->addr;
> +	unsigned long i;
[ ... ]
> +	/* Compound folio - have to iterate through each page. */
> +	for (i =3D 0; i < nr_pages; i++, addr +=3D PAGE_SIZE) {
> +		struct page *page =3D folio_page(state->__folio, i);

[Severity: High]
As mentioned above, if a tail page was passed to discontig_kernel_map_page(=
),
this loop always starts mapping from the head page (i =3D 0) of the folio.

Could this map the wrong memory into userspace if the caller specifically
requested a tail page?

> +		int err;
> +
> +		err =3D insert_page(vma, addr, page, vma->vm_page_prot,
> +				  /*mkwrite=3D*/false);
> +		if (err)
> +			return err;
> +	}
> +	return 0;
> +}
> +
> +int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
> +					struct mmap_action *action)
> +{
> +	const struct discontig_kernel_page_ops *ops =3D
> +		action->map_kernel_discontig.ops;
> +	struct discontig_kernel_page_state state =3D {
> +		.start =3D vma->vm_start,
> +		.end =3D vma->vm_end,
> +		.addr =3D vma->vm_start,
> +		.pgoff =3D vma->vm_pgoff,
> +		.nr_pages_mapped =3D 0,
> +		.nr_pages_remain =3D vma_pages(vma),
> +		.vm_private_data =3D vma->vm_private_data,
> +		.private =3D action->map_kernel_discontig.init_private,
> +	};
> +	int err =3D 0;
> +
> +	if (ops->init)
> +		err =3D ops->init(vma->vm_private_data, &state.private);
> +	if (err)
> +		return err;
> +
> +	do {
> +		unsigned long end, pgoff_end;
> +		unsigned long nr_pages;
> +
> +		/* Default to abort. */
> +		state.action =3D DISCONTIG_KERNEL_PAGE_ABORT;
> +		err =3D ops->get(&state);
> +		if (err || state.action =3D=3D DISCONTIG_KERNEL_PAGE_ABORT)
> +			return err;

[Severity: Medium]
Does this error path leak memory if a driver allocated state in ops->init()?

The commit message mentions that any state established by ops->init() is
released in vm_ops->close. However, if an error occurs here (or below in
apply_discontig_action), the function returns immediately.

Since state is a local variable on the stack, and the driver's close callba=
ck
only receives the vma (which has no access to state.private), it appears any
memory assigned to *private would be permanently leaked.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D8
