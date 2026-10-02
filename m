Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B623749F7;
	Fri,  2 Oct 2026 12:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790944572; cv=none; b=iAfKYjVrIywhOey1SluVdstiT0EifIDBP7/Fy30HPYzOrbxUp/dWq4+128/B7Of6C2qzM9rY8Wx0TqqLf9U0yCa+xvssMfV4bKdTUMtsPGVCrVVbPI1g4D1XqWz/bAqx0lG1QGat/E1Vu2sBiLIDB0PvGfFdX56nd2sTIrF8a50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790944572; c=relaxed/simple;
	bh=zJdGvFnH9239op/29+uvDTEPTaYaAw90S9Cp4ykY2oc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PwojCdSfM2+t5YWTF3D61TJaZbgXcZj1oMeQwXyxfkTfXr2WVui1fWxY2dJJiKUHKkal5cxKVs8T/Yw4OKK+5UI/cLOogOpplqHiTazmbjMlOcNLQk90GH6G078ieuoY4FPx4Q7+Y/NaCBgCLpyg/4lU8USQsHqQNHgcE8/Y0Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y04Ou6XX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y04Ou6XX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D291F000FF;
	Fri,  2 Oct 2026 12:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790944571;
	bh=gHT1eHrCeRGheckcuVuH5tVn5htGR9KNUyLnh8eDOzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y04Ou6XX6SdMWUWTarLUhIsaN9w+3Pqeg8oUs/7OIb31JfWW0vUEVzkHQmEdDgjhX
	 rMOXzqjsfTki350NeAiEQUKi4/Wmdue8la++1bjfwJl0sJt9qPFQ5jP+SuL7Z0VIrT
	 fF/q64PoEK8zQ3Hm3rGDp9dID/9LqdMIt5ul42FGVvVWpLww9nxdUXfWoDIelUsaAq
	 8uHXbsWsAqgQEMs5R7FJEaINNCSu3zIGTrOrgwAyZ/QFIZy9pBQiDvOq7P6XMWUnTW
	 K0nPXJCzRbOceqmLZfwrGmVvzEwYcn9zKQTP/XretUzMvEj70sWs0xCGSfo9UlqM4u
	 t7IisLDZyS3qQ==
Date: Fri, 2 Oct 2026 13:35:42 +0100
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
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
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
Subject: Re: [PATCH v3 32/40] mm/uffd: use predicates for userfaultfd checks
Message-ID: <ar-k7i_hZC-SqCLO@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-32-4583d8a23bca@kernel.org>
 <72bbb616-e84e-4635-9d0a-336916db47e4@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72bbb616-e84e-4635-9d0a-336916db47e4@kernel.org>

On Fri, Oct 02, 2026 at 09:04:17AM +0200, David Hildenbrand (Arm) wrote:
> On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> > Rather than directly checking VMA flags, use the newly introduced
> > vma_is_kernel_owned() and vma_is_persistent() helpers in userfaultfd when
> > assessing VMA suitability for userfaultfd and UFFDIO_MOVE.
> >
> > Update vma_move_compatible() so it's expressed in terms of VMA
> > characteristics rather than arbitrary flags.
> >
> > Additionally, update the use of the deprecated VMA flag API when checking
> > VMA_SHADOW_STACK_BIT.
> >
> > A VMA_IO_BIT check is no longer required but that is fine as a hard
> > invariant has been established that only kernel-owned mappings may set
> > VMA_IO_BIT so the check is now redundant.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/userfaultfd.c | 21 +++++++++++++++------
> >  1 file changed, 15 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 949017e60608..ddf0a4a3d399 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1754,10 +1754,18 @@ static inline bool move_splits_huge_pmd(unsigned long dst_addr,
> >  }
> >  #endif
> >
> > -static inline bool vma_move_compatible(struct vm_area_struct *vma)
> > +static inline bool vma_move_compatible(const struct vm_area_struct *vma)
> >  {
> > -	return !(vma->vm_flags & (VM_PFNMAP | VM_IO |  VM_HUGETLB |
> > -				  VM_MIXEDMAP | VM_SHADOW_STACK));
> > +	/* uffd is generally incompatible with kernel-owned mappings. */
> > +	if (vma_is_kernel_owned(vma))
> > +		return false;
> > +	/* The shadow stack should not be written to by userspace. */
> > +	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> > +		return false;
> > +	/* hugetlb mappings cannot be safely moved. */
> > +	if (vma_is_hugetlb(vma))
> > +		return false;
> > +	return true;
>
> return !vma_is_hugetlb(vma);

Ack, done for v4.

>
> >  }
> >
> >  static int validate_move_areas(struct userfaultfd_ctx *ctx,
> > @@ -2146,10 +2154,11 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
> >  {
> >  	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> >
> > -	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
> > +	/* Non-persistent memory is inherently not controllable by userspace. */
> > +	if (!vma_is_persistent(vma))
> >  		return false;
>
> Completely confusing. Just avoid the helper and open-code this here.

See the other thread on this. I think with this as vma_is_volatile() this is a
lot clearer.

>
> > -
> > -	if (!vma_is_hugetlb(vma) && (vma->vm_flags & VM_SPECIAL))
> > +	/* The shadow stack should not be written to by userspace. */
> > +	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> >  		return false;
> >
> >  	vm_flags &= __VM_UFFD_FLAGS;
> >
>
> Other stuff looks much better to me.

Thanks!

>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo
