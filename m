Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3337B4DD3B4;
	Tue, 13 Oct 2026 10:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791889097; cv=none; b=PrNOwEauo6T8WvN1yUTMrs+ZMZOu3aZb8/eP9Hfwx9tm9vhKGWfDJ00e8h98EHLSNOuOW1BHa6zqGyhR2f525UKaQW+ZIbAmFszu1kNInF2xe+AUZxeh0KBsjiEidNKFxIgRR3DXVuXMqinHQag6bsQ87Ht2xoqM7jEZkZVaonU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791889097; c=relaxed/simple;
	bh=6SnVVVmPYxF1OFQX0l7U7uiorQk9/Vabbq3+fH3CB0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iYZQvO3Qy81AhbOuGo/bupz+ZlMuOZkFuF380myyZCWnZ1maRrvwR2M1hoA/RV0Gp25nBklTyKFTNFCRxyr/SJeKEA2kN2xnbejJ6ZmvD/clfCHY5b+/25ranfNULQjkZMNE7jaRftfRNM/tk40Ho2Y9RYHLo6ph4rPgBJSlYQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aR/hDTCH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aR/hDTCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60871F00893;
	Tue, 13 Oct 2026 10:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791889087;
	bh=XqYELHn1Fs10YGv478nR1wyW/4N+kLzgnDGLYZUvs88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aR/hDTCHkpRrD2Q85x6nhy7UfQ/CtL/ivKHNoP/7YmaOf2YtsXzMbVTewABYl+lH2
	 E1ANeprkW0sDIPEXVwMMv8R0Alz/PxPWx9Tls6fHrc59XjGM4kE7oQbFPXbmtT1b26
	 CgYaGJe2w4vRzH4o2iObzguPPcIgDQyWEM+zvsH5mKunbvoiuZazXqSsrrlF7EEQb1
	 hxo4AG70naM9Mdv5S3OChc7VTcBA6PvNoZfqGhd1XdBHFqyWNU172VtIq4TfMG4wVp
	 n2po+hi0bZLT+0+nGnJXrnkRwfPTxiBa+7wNgPjNRVRt5ql/bfPHJ7ItjHN+V6LamS
	 WiV/sW1lCSqeQ==
Date: Tue, 13 Oct 2026 11:57:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH v5 30/38] mm/vma: introduce vma[_flags]_is_mm_backed()
Message-ID: <as4NZeHKJJ822E0L@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-30-923b70125b1e@kernel.org>
 <c79d2d40-0f1c-43ec-bc25-b75ce975f27e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c79d2d40-0f1c-43ec-bc25-b75ce975f27e@kernel.org>

On Mon, Oct 12, 2026 at 08:45:17PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> > Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
> > mappings which are mm-managed and whose contents were placed there by core
> > mm's own fault path - rather than a custom ->fault handler - and which core
> > mm has not reserved the right to discard.
> >
> > Mappings not managed by core mm do not fall into this category, as they are
> > populated by their owner, and nor of course does memory-mapped I/O.
> >
> > We exclude fixed mappings as these have a layout core mm cannot assume
> > ordinary fault semantics over.
> >
> > hugetlb mappings are fixed mappings, but core mm owns them entirely, so
> > they are explicitly carved out as mm-backed, as the MADV_DODUMP check
> > already does.
> >
> > Droppable mappings are excluded as core mm has promised it may discard them
> > at any time.
> >
> > Use this functionality to update the madvise MADV_DODUMP check to test for
> > this rather than open-coding it.
> >
> > This replaces the VM_SPECIAL check which means it no longer checks for
> > VMA_IO_BIT, however this is safe as we have established the invariant that
> > mm-managed mappings may not set VMA_IO_BIT, so we implicitly include
> > these.
> >
> > No functional change intended.
> >
> > Acked-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  mm/madvise.c       |  4 ++--
> >  2 files changed, 52 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 2ce68713e4c3..55320cf2c525 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1738,6 +1738,56 @@ static inline bool vma_can_merge(const struct vm_area_struct *vma)
> >  	return vma_flags_can_merge(&vma->flags);
> >  }
> >
> > +/**
> > + * vma_flags_is_mm_backed() - Do the specified VMA flags imply the mapping is
> > + * backed by core mm?
> > + * @flags: The VMA flags to test.
> > + *
> > + * An mm-backed mapping is one managed by core mm (see
> > + * vma_flags_is_mm_managed()) for which two further things are true:
> > + *
> > + * 1. Everything mapped was placed there by core mm's fault path (no custom
> > + *    ->fault).
> > + * 2. What is mapped stays there until it is zapped or unmapped by the user.
>
> I still dislike squeezing the VMA_DROPPABLE check in here.
>
> It's just weird semantics to squeeze pages that are *managed* by core MM (#1)
> but are simply always lazyfree into this check.
>
> In fact, core-mm manages (zaps) these pages, they are really just just
> permanently lazyfree.
>
> Open-coding "this (DUMP, UFFD, MLOCK) does not make sense for droppable
> mappings" is IMHO the right decision, because there you could say
>
> "dumping something that can get zapped every second does not make any sense"
>
> "placing pages through uffd does not make any sense if it can get zapped any second"
>
> "mlock'ing (and thereby allocating!) droppable mapping does not make any sense
> and could actually break droppable semantics"

Yeah, I am starting to come over to your point of view on this.

It sucks that we have to manually do the droppable check, and I still worry
callers will miss this as a result, but at least the flag has a specific,
non-vague purpose.

Rather than keep on trying to fit droppable into the definition, which should be
as clear as possible, it does seem better to just drop the droppable check.

It's nearly equivalent to the mergeable check, except that it allows hugetlb
(the eternal exception), but that means we can now define mergeability in terms
of mm-backing which is really nice.

It also lets me avoid a case where I check mergeability in a non-merge situation
(can just drop anything like that). As well as the cases you mention.

>
> Not a hill I will die on, but I much rather have the droppable mapping be
> outside or  have it called something nasty like
>
> vma[_flags]_is_mm_backed_or_droppable()

Yeah I think best not, the flag is clearly defined, so we can live with
checking it manually.

My concern was people forgetting to account for it, but I guess we just
have to live with that in general (ugh).

Maybe later we can think of a bright idea as to how to define some
semantics that include it, but that's one for the future anyway.

--
Cheers, Lorenzo
