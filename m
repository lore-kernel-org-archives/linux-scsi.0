Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9EB41F34E;
	Sat, 26 Sep 2026 13:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790428959; cv=none; b=WW3v1fzi7rfj4wLs5OeWwq9Uc7WjZnPP/IPbetj0bvrsa1f+URRYH5z31klatUY0F/C1Iom2i1Zk0vsd3VKr61GzFITsZehMPlEURYtEH3/hCpPAQL6M/ZQW7BGA3bvESH8zvkve1+eDZj6ZE1oRP3VfeCj/02opgeA44qXyslQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790428959; c=relaxed/simple;
	bh=ytgc6Ysa5Go78zHXRVtTHpX/QUpJmBMDXx19p/scRAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A82A1SGCy+DX7VqbBf+MM6daTdJLcwBu61VGloCtV/fbone2163TKqYXLtMuk8ZGf05JdZH07uVnwDv6qdAS2mk9QW3m3sAh0FB6juTcbK2fMFPE2u9Q9V8QCblNhQhIp7Abh68hwdue+mcCW07qAdGzLH9regM4RUODbFg1JG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gn1PEczg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gn1PEczg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B984F1F000FF;
	Sat, 26 Sep 2026 13:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790428957;
	bh=Ho6ODA6dlgcOvdPnhowd9GgmBiom3Zlo2XTvzY/VTW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gn1PEczgsD5J29kex3G7noDS0spUTsU0srsr+zO1nZZFuyKKVJFH88OWSVdctFAta
	 v7+cMia70kZ1YiuCIVpgK+S7YUkcgPcfUscXxMIVNy2T0tNen4vpOI9UIX+1BDQbbc
	 ePRW1SWCr2qEbUMLcslI3kLtHSdkz6HzShrhvUDCAIXM9cTBfN59vnzkvSpAY5sH1A
	 HiO3kEDoHq52UM6A/hwkWmFG1rbuJuaaijRW4+S7BnYNa61yNGGxIUvVs8xVjcKOaU
	 2ZsrOuBc7LttfpdBhGRS97sgpAQW2anj2l9mfgb3mnYHtFFH+/VpzMj5GLRW0f0MCb
	 rDkMkQL9UaUiA==
Date: Sat, 26 Sep 2026 14:22:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
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
	"Kirill A. Shutemov" <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, peterx <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Dave Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S . Miller" <davem@davemloft.net>, 
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
	linux-perf-users@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>, 
	Emil Tsalapatis <emil@etsalapatis.com>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Message-ID: <arfGmNiEngnO3JKm@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
 <areSEI5pWBadkqIe@gremlin>
 <408aef6e-5b0a-482f-8ba8-f8c20ee870e5@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <408aef6e-5b0a-482f-8ba8-f8c20ee870e5@app.fastmail.com>

On Sat, Sep 26, 2026 at 03:06:33PM +0200, Arnd Bergmann wrote:
> On Sat, Sep 26, 2026, at 11:40, Lorenzo Stoakes (ARM) wrote:
> > On Sat, Sep 26, 2026 at 12:06:22AM +0200, Arnd Bergmann wrote:
> >>
> >> mm/vma.c: In function '__mmap_region':
> >> mm/vma.c:3083:1: error: the frame size of 1552 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
> >>
> >> I don't immediately see anything that you did that would have introduced
> >> something bad that wasn't already there, so it's likely just gone from
> >> just below the limit I was using for my testing to just above. The 1536
> >> byte limit is what I use on 64-bit builds with KASAN and otherwise
> >> still has a clean build (with a small number of local fixup patches).
> >
> > Hmm are you specifying this limit manually somehow?
>
> It's a Kconfig setting upstream, but the way I'm doing it is to have
> patch that calculates a sensible default based on other options that
> is a little smaller than the default (currently 2048 bytes) on x86-64
> to catch more cases where something sticks out.

I see.

So this is an early warning more or less :)

>
> >> If I sprinkle some 'noinline_for_stack' annotations on functions
> >> called by __mmap_region(), I can get the size down to 1144 in this
> >> config, but that doesn't sound like a great workaround.
> >>
> >> The large stack usage is potentially harmful if this ends up
> >> in call chains that have additional large stack usage (e.g.
> >> kmalloc() leading to reclaim). Any ideas for how to reduce it here?
> >
> > That can never happen :) this call chain is _only_ for an mmap() call.
>
> I mean more functions called /from/ here, something like
>
>   __mmap_region()
>   __mmap_new_vma()
>   vm_area_alloc()
>   kmem_cache_alloc(..., GFP_KERNEL)
>   slab_alloc_node()
>   allocate_slab()
>   alloc_slab_page()
>   __alloc_pages_slowpath()
>   __alloc_pages_direct_reclaim()
>   __perform_reclaim()
>   try_to_free_pages()
>   shrink_zones()
>   shrink_node()
>   lru_gen_shrink_node()
>   shrink_many()
>   shrink_one()
>   try_to_shrink_lruvec()
>   evict_folios()
>   shrink_folio_list()
>   pageout()
>   shmem_writeout()
>   swap_writeout()
>   swap_add_folio()
>   swap_write_submit()
>   nfs_swap_submit_write()
>   nfs_file_direct_write()
>   nfs_direct_extract_pages()
>   nfs_do_recoalesce()
>   __nfs_pageio_add_request()
>   nfs_pageio_doio()
>   pnfs_generic_pg_writepages()
>   pnfs_do_write()
>   pnfs_try_to_write_data()
>   filelayout_write_pagelist()
>   nfs_initiate_pgio()
>   nfs_local_doio()
>   nfs_local_do_write()
>   nfs_local_call_write()
>   ->write_iter()
>   generic_file_write_iter()
>   generic_write_sync()
>   vfs_fsync_range()
>   ->fsync()
>   xfs_file_fsync()
>   file_write_and_wait_range()
>   filemap_fdatawrite_range()
>   filemap_writeback()
>   do_writepages()
>   ->writepages()
>   xfs_vm_writepages()
>   iomap_writepages()
>   iomap_writeback_folio()
>   iomap_writeback_range()
>   ->writeback_range()
>   xfs_zoned_writeback_range()
>   iomap_add_to_ioend()
>   ->writeback_submit()
>   xfs_zoned_writeback_submit()
>   xfs_zone_alloc_and_submit()
>   xfs_submit_zoned_bio()
>   submit_bio()
>   submit_bio_noacct()
>   submit_bio_noacct_nocheck()
>   __submit_bio_noacct()
>   __submit_bio()
>   blk_mq_submit_bio()
>   blk_mq_run_dispatch_ops()
>   blk_mq_try_issue_directly()
>   blk_mq_run_hw_queue()
>   blk_mq_sched_dispatch_requests()
>   blk_mq_do_dispatch_sched()
>   __blk_mq_do_dispatch_sched()
>   blk_mq_dispatch_rq_list()
>   ->queue_rq()
>   scsi_queue_rq()
>   scsi_dispatch_cmd()
>   ->queuecommand()
>   ata_scsi_queuecmd()
>   __ata_scsi_queuecmd()
>   ata_scsi_translate()
>   ata_scsi_qc_issue()
>   ata_qc_issue()
>   qc_issue()
>   ata_sff_qc_issue()
>   ata_sff_queue_pio_task()

Ugh delightful :)

>
> There are many ways the call chain can go of course, but the actual
> stack overflows do tend to follow this pattern where you are at a
> function with high stack usage and call kmalloc() during low memory
> condition and that ends up waiting for a block I/O down the line.
> (you normally don't go through swap and nfs, I was just looking
> for the worst case I could easily see in the code)

You certainly found quite the example haha.

>
> > In general I am absolutely taking this seriously and will find a way to
> > reduce this, but my only question is whether this is actually something
> > that needs to be done in this series?
> >
> > Because it's already huge and I would rather avoid adding yet another patch
> > to it if possible.
> >
> > If I can do it as a follow-up that'd be ideal!
>
> What I was hoping for is that as you are already deep into the
> exact code that caused the warning and you can already see something
> in there that may help.
>
> I don't think it's urgent, I just don't want it to be forgotten.

It won't be, it's now on my TODO and I see it as a relatively high priority
thing to follow up with.

Will likely send a patch for it next cycle (this is about the worst cycle I've
seen workload-size for mm so I don't really want to send anything more this time
around).

>
>      Arnd

--
Cheers, Lorenzo
