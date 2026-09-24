Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAEF389111;
	Thu, 24 Sep 2026 10:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244426; cv=none; b=WAK3f+UPmfhIe+iFYK+N0VyDAIFIMi/8gCuxFyvfjXiahNwaOTR3bW3Pz81Fdklyd7ihKmFDoKBGRIyQj3RlXzhPL204rfWx2jnnHyPuSlFa2FXffAdWbw8COVCOGjzY9tJsgxOqJG7htr2k6L0+h9EjHJaAJ2F9rEkKbMjBL3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244426; c=relaxed/simple;
	bh=3BdFtZaQx/hN1F8B7NWjXGwFzEqYe+EiIIZXC/z69vI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dy7kV6WcyzC+RPhPDp8Z+ppMFtXxCI9seff01cMnschqi0aoK+bc0pA+Q584fgFoyW6W+vCKH7SEyDAPukkjZRkGWVfVYKES6yRzHNPfv7DbRh5eyxaDFBLCI4gMvcC0FgBZxtsy7LmassO1EE8cK1vhQaREznCKooR2knDS/Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLQwBAOG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLQwBAOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C321F00893;
	Thu, 24 Sep 2026 10:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244413;
	bh=Tmln/mtpzj8HRD3oGhB2G+T5+fAuKHxHe9EIDa4XupE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PLQwBAOGo9zDSHvR7HKzryQ/BMyFMtzGN+nCViQmJtAxtR/cVtie3h8+uTfYAAuqI
	 031IL8YiCRbRgN3Lu0GdOWHF3up1c5eAkeUhEPdxuJ9q/SthtjUJM4e5DTQk3971Cv
	 +R/NIvQEe5TAium5bmdEyB/qSUVvrKQ3N2k6WtmzwCU8Hw7KqZ3HuHqonUNceqtFUI
	 gkBAcKeGMzG5vw33mskB8GCIprFrs11XV7eTU1DX4P4aEFuLfxG1bzkZcra4RB+dUr
	 UBz/croW/YGWjUjo9iUnRJL3m1e4m9BS//Qzg5nKK/0JyOftW1GHHLTSp3iQSWnW2G
	 YCgs9xZC0a5iw==
Date: Thu, 24 Sep 2026 11:06:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 04/40] mm: consistently validate VMA state after
 mmap[_prepare] hooks
Message-ID: <arT1xJpWlFlRHUFY@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>
 <DLN7FLRJGS5Y.1T8T274W2NS6L@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLN7FLRJGS5Y.1T8T274W2NS6L@nvidia.com>

On Wed, Sep 23, 2026 at 10:52:06PM -0400, Zi Yan wrote:
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, the
> > driver might have done something crazy that is not permitted by the kernel.
> >
> > Currently we check for three such cases in __mmap_new_file_vma(), but only
> > if the legacy f_op->mmap hook is used:
> >
> > * Did sparc ADI result in invalid flags?
> >
> > * Did the driver alter vma->vm_start?
> >
> > * Did the driver make a file-backed mapping on a read-only file writable?
> >
> > Generalise these checks for both mmap_prepare and mmap and apply to all
> > invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
> > in the core VMA code and the mmap_prepare compatibility layer.
> >
> > Also extend the vm_start check to vm_end also - drivers must not change the
> > VMA range at all.
> >
> > We also WARN_ON_ONCE() on these conditions as they are things that should
> > simply not occur in the kernel and it's important to call it out when it
> > does.
> >
> > We invoke mmap_prepare_validate() after mmap_action_prepare(), as mmap
> > actions often manipulate state in the descriptor thus providing the final
> > state the VMA will be derived from.
> >
> > Also call mmap_validate_vma_flags() in insert_vm_struct() to ensure that
> > special regions which are inserted (such as a VDSO or VVAR) also satisfy
> > the sanity checks.
> >
> > This way every VMA established through an mmap hook, whether via mmap() or
> > the compatibility layer, or inserted via insert_vm_struct(), has been
> > validated. brk() VMAs never pass through a driver hook and so need no such
> > check.
> >
> > While we're here, also fixup a couple disjoint blocks of #ifdef CONFIG_MMU.
> >
> > Finally, update the VMA userland tests to reflect the change.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/internal.h                   |  51 ++++++++++++--------
> >  mm/util.c                       |  19 ++++++--
> >  mm/vma.c                        | 100 ++++++++++++++++++++++++++++++++++------
> >  mm/vma.h                        |  25 ++++++++--
> >  tools/testing/vma/include/dup.h |  10 ++++
> >  5 files changed, 163 insertions(+), 42 deletions(-)
> >
> <snip>
> > +
> > +/* Check to ensure a driver hasn't done something crazy. */
> > +static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
> > +			 unsigned long curr_start, unsigned long curr_end,
> > +			 const vma_flags_t *prev_flags,
> > +			 const vma_flags_t *curr_flags)
> > +{
> > +	bool was_maywrite, is_maywrite;
> > +
> > +	/* Drivers cannot alter the range of the VMA. */
> > +	if (WARN_ON_ONCE(prev_start != curr_start || prev_end != curr_end))
> > +		return -EINVAL;
> > +
> > +	was_maywrite = vma_flags_test(prev_flags, VMA_MAYWRITE_BIT);
> > +	is_maywrite = vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
> > +
> > +	/* A driver may not make a previously unwritable mapping writable. */
> > +	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
>
> Is it driver specific or generally applicable to all mmap(_preppare)
> operations? Is the comment too specific?
>
> During my LLM quiz, making memfd write seals writable via a
> hypothetically wrong shmem_mmap_prepare() implementation is an example
> for this WARN_ON_ONCE. It is not driver related. Let me know if I get it
> wrong.

Driver is taken to mean anything with an mmap or mmap_prepare hook, like a
general term for that.

If we start getting into calling it different if it's a file system or memfd or
something then it becomes quite hard to talk about it.

And yeah I hate that it's not a good name because driver makes you think
something in drivers/* or an OOT one or something but the kernel makes it vague
:)

Naming is hard...

>
> Otherwise, LGTM.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo
