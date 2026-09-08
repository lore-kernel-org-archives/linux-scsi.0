Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF8C3B442F;
	Tue,  8 Sep 2026 20:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899649; cv=none; b=WKghLl27ARSg7aFzc6CpvANSPmt6S6iJTHTPH5e6R5nULso/Vpk1gLIpW5iWydVlWq7mfEWMzXni0ylJVC2CLupy86nHNrQ5aLS9lUsBHHZVkIW1VEC60p7SK49rtSzbkg+dbnMT3halHRrs8jNSs1D8bhf2Rydn3JGvDqJSsh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899649; c=relaxed/simple;
	bh=1/4TOL0Rxoj8TnV3rf3hSUK856vlgyyeG9NVsoRS4ZY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bYY8cNqT+vZC+JvQaD1oAfD0/8Nww/5gL409ny9jryTny2pLq79NSGswQtr6IaVHNzqb5A+QAMVD7Y2+6LVFeS8tebc8AyBq3F+n9+HUKOTqo2mh4aHD6uRSZtuVD0JsIFHz+IlYRD5dNtONTa3AzDnqFVyNOLS3z4l55Y7DJL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJ30F8NP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJ30F8NP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1DE1F00A3A;
	Tue,  8 Sep 2026 20:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899647;
	bh=mOKhPXd9YQloNgmf2oi41RM18BbFzj4CqtHxWVXwmjc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NJ30F8NPxj1y7QKpADTsXk5C46hyD23abj6BuzYlhZK4BlB/GfcOCWDpUZsjJPsxr
	 bFjv+eJAkMyxudhVwpzxl1MeMvD6lJPhTgYm0ncBe58WZaPyzDbIgrMo4xg6lqTTj3
	 4C9HzMsm9krC7mImyV6tAOvAFnqSDF6l2yYdpbjQ7migMDpYXdHxO8j9NVcp/vWutp
	 hlh4pAowB9JzivA7MOn9f2lPI/Z94FizkYx7p1RH14wCdIPeKqf2H4XaqE+ia4i9BU
	 cx4d1PWfBF8oV3F4RV0E8Tq+kYdeMOt/lcjdEzDesG5ImaUBq++gyXbx4JEdmN5D7T
	 eHxc3TOaZTI4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/39] mm: add mmap action for discontiguous kernel page
 mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, selinux@vger.kernel.org, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-7-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-7-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:34:06 +0000
Message-Id: <20260908203406.AA1DE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The userland VMA testing header `dup.h` was not fully updated; the =
`map_kernel_discontig` field is missing from `struct mmap_action`.
--

commit 0017a54bcba2043c3f552b308a32a39be664f463
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm: add mmap action for discontiguous kernel page mapping

This commit introduces a new mmap action, MMAP_DISCONTIG_KERNEL_PAGES, to
allow drivers to map discontiguous ranges of struct page pointers. It provi=
des
discontig_kernel_page_ops for drivers to specify how page batches should be
retrieved, and updates the core mm and VMA test headers accordingly.

> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 9ca2ea3664bc1..0cb4f96039568 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h

[ ... ]

> @@ -844,6 +880,10 @@ struct mmap_action {
>  			unsigned long nr_pages;
>  			pgoff_t pgoff;
>  		} map_kernel;
> +		struct {
> +			void *init_private;
> +			const struct discontig_kernel_page_ops *ops;
> +		} map_kernel_discontig;
>  	};
>  	enum mmap_action_type type;

[ ... ]

> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 1098655a5f4a3..52eee05e6c322 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -457,8 +457,9 @@ enum mmap_action_type {
>  	MMAP_NOTHING,
>  	MMAP_REMAP_PFN,
>  	MMAP_IO_REMAP_PFN,
> -	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
> -	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
> +	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
> +	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
> +	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
>  };
> =20
>  /*

[Severity: Low]
Does struct mmap_action in this userland VMA testing header also need
to be updated?

The map_kernel_discontig field was added to the kernel's mm_types.h, but
it appears to be missing from the corresponding struct mmap_action defined
in tools/testing/vma/include/dup.h.=20

If a selftest attempts to access the map_kernel_discontig union member of=20
struct mmap_action for MMAP_DISCONTIG_KERNEL_PAGES, it will fail to compile.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D7
