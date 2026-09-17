Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9CA5187DE;
	Thu, 17 Sep 2026 17:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667039; cv=none; b=h2GolduLrw3hntJUjHRSHXpOmG6CJH3Z9/bkOdLEn6wtYHMEF8G8/nA8UPkpeYYdx+OguqylfXGfeaVG6+sFHrqosyB0re9aokw+WcWCqQ+v6ToNLM9Gr+rcFo1Zhgnujv0M69j98PGjznn3ODD/BrU0kGwjGu7LtjQim8A/HQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667039; c=relaxed/simple;
	bh=KmRTbX6S07D8ZPAko+Jvxe2yNAmigBFIZPY1QJAiI3s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TXO+gIlp01bJO3HkTTr2mwhd9WUNcYn5mek1Ww1NpLSxd3mqprQsjteAl6ekAcVAyZvXK1/sfh7HYyhDA34m3+lDqYxaGPuTrSkM46JXdXlEELPxQ7QDFfYnjF4OfjYQQ7nPA/UkU/6zpBdNUI+GxfM1M6iLmi+kb7Z0Jv8R8nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxkCfdz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxkCfdz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CDA1F0089A;
	Thu, 17 Sep 2026 17:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789667036;
	bh=6RQTPqSZXfjsmpWYhg439wOmiYGc4Or1rsnakQxHQLQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KxkCfdz4uto//23Owz1P/SNO48SWLaXIcbQJ6lx0Kye0jFp2gWaT3m/PMFfWY+cqB
	 MXS5yDLquSKkB+edrqgD+yLuolvnQOF/vqJPIrlPnoH3Q+oojf5XwpwrvUqxEPb60N
	 mqcSZhD8BvAcUBTzzEXxiUFwGSH+BUG6fO2Ry31y5d/gBqUWkQUxa5DdAj/6ActPYT
	 S16xasXo7UsIf7pdibbf4BofDJoO4Fsr3On7nG/AwJ5YpWWmHbDX6VgCINowv2bvbx
	 Rj3xe00c98ig6LHBWF22ohtXHZiFRArdCX0+cqSQFWQ5bSwb96svPHf4r8yIaeb3Qd
	 17Tg6MFZWUFhw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 24/40] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, selinux@vger.kernel.org, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-24-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-24-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:43:55 +0000
Message-Id: <20260917174356.14CDA1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] mm: build warning from casting bool to void *
--

commit 564510db2f224719d4bea8f1947aae5cc75d3394
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify

This commit eliminates the use of VMA_IO_BIT in mlock/munlock operations
by threading a boolean through the page table walk. It updates VMA lock flag
checks and removes the unnecessary allow_mlock_munlock() wrapper.

> diff --git a/mm/mlock.c b/mm/mlock.c
> --- a/mm/mlock.c
> +++ b/mm/mlock.c

[ ... ]

> @@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct vm_area_st=
ruct *vma,
>  		.pmd_entry =3D mlock_pte_range,
>  		.walk_lock =3D PGWALK_WRLOCK_VERIFY,
>  	};
> +	const bool lock =3D vma_flags_test(new_vma_flags, VMA_LOCKED_BIT);
> +	vma_flags_t walk_flags =3D *new_vma_flags;
> =20
>  	/*
> -	 * There is a slight chance that concurrent page migration,
> -	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
> -	 * will call mlock_vma_folio() and raise page's mlock_count:
> -	 * double counting, leaving the page unevictable indefinitely.
> -	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
> -	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
> -	 * mmap_lock is held in write mode here, so this weird
> -	 * combination should not be visible to other mmap_lock users;
> -	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
> +	 * LOCKONFAULT without LOCKED never otherwise occurs: it marks a walk in
> +	 * progress so that rmap-side callers, which test VMA_LOCKED_BIT, do not
> +	 * count folios, while try_to_unmap_one(), which tests VMA_LOCKED_MASK,
> +	 * still refuses to unmap them.
>  	 */
> -	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
> -		vma_flags_set(new_vma_flags, VMA_IO_BIT);
> +	if (lock) {
> +		vma_flags_clear(&walk_flags, VMA_LOCKED_BIT);
> +		vma_flags_set(&walk_flags, VMA_LOCKONFAULT_BIT);
> +	}
> +
>  	vma_start_write(vma);
> -	vma_flags_reset_once(vma, new_vma_flags);
> +	vma_flags_reset_once(vma, &walk_flags);
> =20
>  	lru_add_drain();
> -	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
> +	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);

[Severity: Low]
Does casting a boolean directly to a pointer trigger a -Wint-to-pointer-cast
compiler warning on 64-bit architectures?=20

While functionally correct since the pointer evaluates to true/false correc=
tly
when assigned back to a bool in mlock_pte_range(), this compiler warning can
break kernel builds when CONFIG_WERROR is enabled due to casting a 1-byte
bool to an 8-byte void pointer.

Casting it via an unsigned long first, such as (void *)(unsigned long)lock,
might avoid this warning.

>  	lru_add_drain();
> =20
> -	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
> -		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
> +	if (lock)
>  		vma_flags_reset_once(vma, new_vma_flags);
> -	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D24
