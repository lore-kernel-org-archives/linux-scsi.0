Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C7443BDDE;
	Fri,  2 Oct 2026 07:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790927340; cv=none; b=JKVJMKUbXz44jd7CA9lWGwBeOHFupJLHzLTRkmc0Z630WQph3tFTl/fc4lYamFhSXHlEaEEVDY2LdSVHIhHAkeB/5QRV2Hfc6rmBZopreeNuZG3CZV64J1H5z8fsyDD5ez/qngHg8fhr4GuhGz2HQORJtpB/722Fdg4juu4U0sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790927340; c=relaxed/simple;
	bh=vRYMdLYcZqs9ZGif3rlg7KJTTJlkiCi7BTNpC4uiw4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k7HWCXxs4RYksffjp/A9iNqT0813W/sWyxxrfK1SyteRo+2ERsq73vtvtW9WMO+a9yaR/wM1B7ue6WVKs4cvtMRsPwPjM/sXsuKLFjMps2d6u6XEea9vbULiYB0lr30O5evvm2iaMkZxQxLj7E85E1XNxNiUG/68A80B72Ys4VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/ZpHLuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/ZpHLuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7558F1F000FF;
	Fri,  2 Oct 2026 07:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790927338;
	bh=VuJQjhi77ZVm2icnOLnl3Y2tfYl+LAIPkt+sFQXlE00=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m/ZpHLuDFIK1LoopTh4kNdvd7txlk1dEmXGio8sGjgBF+jhPpVEmgrx1I7J3QtPF9
	 mq6SLVvXjHAYq1lJ6wsRrm6oIMjx3WZJY2lu4n7AgTKI3GT+CaHdznS3Ig6YYEZLmH
	 H1mtYHkmiULRFS+3zuKn79OHg+OcKvLwihu2FAVMI9D/28vAGHBcdFtg0fZs8DTCFF
	 eAGYQUtI47QW+yGAHq0lXhwrbj0FJZAA9EbZh1OYmbfcB0giXI/NG0JyYP+MqhL0dp
	 25Y29wbqWeNyF/qf2ecRuYuvdsB1J0NTYKcl3Oo55gqurozPVky3Y3fXR1AyaTf/vd
	 F+V0T+fdyFJBw==
Message-ID: <202033a0-ea65-44de-8119-689e0df0b78e@kernel.org>
Date: Fri, 2 Oct 2026 09:48:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 40/40] mm/vma: introduce and use vma[_flags]_can_gup()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>,
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>,
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Xu Xin <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-40-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-40-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> GUP cannot be used for VMAs which set VMA_IO_BIT - because memory-mapped
> I/O must not be accessed on the user's behalf - or VMA_PFNMAP_BIT - because
> PFN maps have no folios which the kernel is permitted to access.

The interesting thing will be: what if we want to allow gup for COW'ed pages in
PFNMAP. We discussed that already, and it might be a bit harder to squeeze into
the new vma[_flags]_can_gup() checks that are also used elsewhere now.

Because GUP itself mostly already handles the VMA_PFNMAP_BIT, just has to be
taught about vm_normal_page() etc *properly* on all levels. I even have that on
my todo list.

Updating vma[_flags]_can_gup() won't be enough in that case (ignore
VMA_PFNMAP_BIT in cow-mappings), because suddenly we would unlock other code
paths that now depend on this helper.

Also, there is the secretmem thing I comment on below. I think this also belongs
in this helper but other unrelated users don't really want it.

Which makes me wonder whether vma[_flags]_can_gup() is actually the right
abstraction to use in some other cases that you convert below. For the actual
GUP users I think it's the right thing to do. But not for things that are
somewhat related to GUP (but actually different) I think you much rather want a
separate helper.

Long story short: I wonder whether vma[_flags]_can_gup() is the right
abstraction, especially for users that don't actually *use* gup but just want
slightly similar semantics (no VM_IO|VM_PFNMAP).

> 
> Rather than keeping these checks open-coded, abstract them to
> vma_flags_can_gup() and its VMA wrapper vma_can_gup().
> 
> A number of other places make the same check to decide whether a mapping
> can be populated or accessed as GUP would, so update those too.
> 
> While here, drop a reference to 'special' and replace a use of the
> deprecated VMA flags API in vma_dump_size().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  fs/coredump.c      |  4 ++--
>  include/linux/mm.h | 29 +++++++++++++++++++++++++++++
>  mm/gup.c           |  7 +++----
>  mm/hmm.c           |  3 +--
>  mm/memory.c        | 14 ++++++++------
>  mm/mempolicy.c     |  3 ++-
>  6 files changed, 45 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index fb21fb6703dd..9f729c594c47 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -1616,8 +1616,8 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
>  		return 0;
>  	}
>  
> -	/* Do not dump I/O mapped devices or special mappings */
> -	if (vma->vm_flags & VM_IO)
> +	/* Do not dump memory-mapped I/O, which may have side effects on read. */
> +	if (vma_test(vma, VMA_IO_BIT))
>  		return 0;
>  

In the end, we use GUP to lookup the pages through get_dump_page().

I think we should just use the gup helper instead?

>  	/* By default, dump shared memory if mapped from an anonymous file. */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5860a3b4dba9..1249e04d7b98 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1777,6 +1777,35 @@ static inline bool vma_is_persistent(const struct vm_area_struct *vma)
>  	return vma_flags_is_persistent(&vma->flags);
>  }
>  
> +/**
> + * vma_flags_can_gup() - Do the specified VMA flags permit GUP to access the
> + * mapping's pages?
> + * @flags: The VMA flags to test.
> + *
> + * GUP cannot obtain pages from a PFN map (VMA_PFNMAP_BIT), which may have no
> + * struct pages behind it, and must not provide access to memory-mapped I/O
> + * (VMA_IO_BIT).
> + *
> + * Returns: true if GUP may access pages from the mapping, otherwise false.
> + */
> +static inline bool vma_flags_can_gup(const vma_flags_t *flags)
> +{
> +	return !vma_flags_test_any(flags, VMA_IO_BIT, VMA_PFNMAP_BIT);
> +}

This only covers some things though. See check_vma_flags(): vma_is_secretmem()
is another case we universally reject and that is just simply incompatible. In
the future, it be an address space flag which we can have from the VMA. So we'd
want a vma_can_gup() helper but not necessarily a vma_flags_can_gup() helper.

I think this belongs into the vma_can_gup() helper.

Also, we should better clarify in the doc that other GUP flags will decide
whether GUP is actually allowed. the semantics are a bit vague right now "Do the
specified VMA flags permit GUP to access".

[...]

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 2f1e98c6b644..e9569b82a1f0 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -595,8 +595,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  	struct hmm_range *range = hmm_vma_walk->range;
>  	struct vm_area_struct *vma = walk->vma;
>  
> -	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
> -	    vma->vm_flags & VM_READ)
> +	if (vma_can_gup(vma) && vma_test(vma, VMA_READ_BIT))
>  		return 0;

Where do we end up using gup? I don't think we do, because hmm essentially
implements an alternative to KVM-style GUP-fast usage.

So likely this wants a different helper.

>  
>  	/*
> diff --git a/mm/memory.c b/mm/memory.c
> index 6c011979401a..338fce99e711 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2417,11 +2417,11 @@ static bool vm_mixed_zeropage_allowed(struct vm_area_struct *vma)
>  	 * be problematic as soon as the zeropage gets replaced by a different
>  	 * page due to vma->vm_ops->pfn_mkwrite, because what's mapped would
>  	 * now differ to what GUP looked up. FSDAX is incompatible to
> -	 * FOLL_LONGTERM and VM_IO is incompatible to GUP completely (see
> -	 * check_vma_flags).
> +	 * FOLL_LONGTERM and memory-mapped I/O is incompatible to GUP completely
> +	 * (see vma_can_gup()).
>  	 */
>  	return vma->vm_ops && vma->vm_ops->pfn_mkwrite &&
> -	       (vma_is_fsdax(vma) || vma->vm_flags & VM_IO);
> +	       (vma_is_fsdax(vma) || vma_test(vma, VMA_IO_BIT));

This looks a bit misplaces in this patch. Also, not spelled out in the patch
description?

[...]

>  retry:
>  	pgdp = pgd_offset(mm, address);
> @@ -7316,8 +7317,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  			}
>  
>  			/*
> -			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
> -			 * we can access using slightly different code.
> +			 * GUP failed, perhaps because this is a mapping it
> +			 * cannot handle (see vma_can_gup()) - such mappings may
> +			 * provide access via vm_ops->access() instead.
>  			 */
>  			bytes = 0;
>  #ifdef CONFIG_HAVE_IOREMAP_PROT
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 044ffb4f4128..2fd759e348ca 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2013,7 +2013,8 @@ SYSCALL_DEFINE5(get_mempolicy, int __user *, policy,
>  
>  bool vma_migratable(struct vm_area_struct *vma)
>  {
> -	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
> +	/* Pages which GUP cannot obtain cannot be migrated either. */
> +	if (!vma_can_gup(vma))
>  		return false;

It's slightly confusing, because we don't really use GUP (except in one scenario
for lookup_node).

-- 
Cheers,

David
