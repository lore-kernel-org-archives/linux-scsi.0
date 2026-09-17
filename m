Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1064B95D5;
	Thu, 17 Sep 2026 09:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789639143; cv=none; b=Oyi/y0Sr5v6QXBuR1r8qnhjQCP8SpfLZmiJy5FCvuG3UaFFoWrkbCC3lxvkIZhb+2hEc0z1L5/nY13FAG56cYembITokTIQyfniXu4Eg7UENAe7Wg0TuRVo+c+4AlGzpTkoTjbvYlBMVMb5LV/vKgUkv7d8WKMG5d8FcOaXXQF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789639143; c=relaxed/simple;
	bh=ccAWjPrqm/+fJH1kwsxIbs7sDP3hDfScO9gKhhxAowc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4bspyK4lNtY4LVh2I3MweyBSgKVimDsg8sp/PFt9NZg+1yMi/yb7SJRHRAJY2BFAHCOjF5MLSS0zRgYtbTcAsIYMMw2HWDrNw7ESCJZcgCTTtm8OMHfOKvo9dMphd4A1+75lYPw5Mpkh8C6EDqKjya78fEyZ/x+dDOWTtRJJfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=isWuVbzY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="isWuVbzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EA31F000FF;
	Thu, 17 Sep 2026 09:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789639111;
	bh=+BDLANgER3p3HCZqlKV0tx0X7HCIS+iB0o+b0askj3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=isWuVbzYwxoFIjftdz46VsdsgIIBJV/b2LFp6yM/02MDef4JKOZ9kOY1TdyIDc/30
	 LACHzBzlm2BZ7ZOfu1upP63i+JmISIZXPneX5AaM6s6sXOqC/ZT3q2tHw6G9TORbm7
	 uyaMxHhO41rX8i22FRkG4N96szBjkfGYtWxPNRGGp83Dz+M2BsVrcKY1QuGp+175a6
	 GdHO1K1vaVn9nk+3axcRLy03cQ50PecCQ3m2wtlKX0jMOaKSdnV/poXR+30OeMTy4R
	 toRwR56CeJ6OD7Yas8T8+ZGTJWFYL2CdfHMF3AuIgVkwuKi/mHFb1uIScsd0fWlS0G
	 GskLPjj+/FY4Q==
Date: Thu, 17 Sep 2026 10:57:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
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
Subject: Re: [PATCH v2 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <aqu5jtMV2gyZFrSe@gremlin>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-1-7d9781ed5361@kernel.org>
 <aquz9Z9JrK_H_E0g@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aquz9Z9JrK_H_E0g@kernel.org>

On Thu, Sep 17, 2026 at 12:33:41PM +0300, Mike Rapoport wrote:
> On Mon, Sep 14, 2026 at 03:57:21PM +0100, Lorenzo Stoakes (ARM) wrote:
> > The map->file_doesnt_need_get flag is confusing and the existing
> > implementation has holes.
> >
> > Drivers are permitted to change the owning file of a mapping. If they do
> > so, they are required to take a reference on that file.
> >
> > The mmap() operation which ultimately invokes __mmap_region() is guaranteed
> > to drop the refcount for the original file the mapping was made under, but
> > this is not true for the replaced file.
> >
> > This has been addressed so far by tracking map->file_doesnt_need_get, which
> > is rather poorly named and unfortunately fails to correctly track whether
> > or not an additional put were needed in a number of cases.
> >
> > Make life easier by removing this flag, and instead drop the reference for
> > both mmap_prepare and the deprecated mmap callback in a new function
> > put_map().
> >
> > Track whether this needs to be done by aligning mmap_state with
> > vm_area_desc and store the original file in the map->file field, keeping
> > the updated file in map->vm_file.
> >
> > In order to have the same behaviour for both types of hooks, only drop the
> > reference __mmap_new_file_vma() itself took in its error path, deferring
> > the replaced file's reference to put_map().
> >
> > To make this work correctly, map->vm_file has to be updated before any
> > error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
> > set this field first.
> >
> > Also when mmap_prepare() changes the file and is then merged, the reference
> > count also must be decremented, so update the logic to call put_map() in
> > this case too.
> >
> > Also update __compat_vma_mmap() to manually perform this step for stacked
> > file systems using the compatibility layer, and update
> > compat_set_vma_from_desc() to replace vma_set_file() with a correct
> > refcount/file update.
> >
> > No in-tree driver is impacted by the incorrect implementation of this
> > currently (no driver that does this is mergeable for one), so this does not
> > need to be a fix.
>
> But the patch iteslf needs to be fixed :)
>
> It seems to be the change that broke the CI.
>
> The rest is from LLM, take it with a grain of salt :)

Ack will assess + respin

>
> mm-ci mm-unstable red build - bisect analysis
> ==============================================
>
> Bad commit: 2a937a04babf1 "mm/vma: fix mmap_prepare file handling, remove
> file_doesnt_need_get" - first patch of Lorenzo Stoakes' 40-patch series
> "mm: make VMA flag semantics explicit, eliminate VM_SPECIAL" (v2).
> https://lore.kernel.org/all/20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org
>
> Symptom: tools/testing/selftests/mm/pfnmap.c triggers
> "BUG: Bad page map in process pfnmap" during __zap_vma_range()/vm_normal_page(),
> seen on process exit/munmap. CI's run-mm-selftests.sh greps guest dmesg for
> BUG|WARNING and fails the job regardless of the test's own exit code.
>
> Root cause:
> In call_mmap_prepare() (mm/vma.c), the commit reordered:
>
>     map->vma_flags = desc->vma_flags;
>
> to run BEFORE call_action_prepare(). For PFN-remap mmap_prepare drivers
> (e.g. /dev/mem), VMA_PFNMAP_BIT/VMA_IO_BIT are only added to
> desc->vma_flags inside remap_pfn_range_prepare(), which runs as part of
> call_action_prepare(). Snapshotting vma_flags too early means VM_PFNMAP/
> VM_IO get silently dropped from the resulting VMA, while the PTEs are
> still installed as pte_special (real PFN remap).
>
> vm_normal_page() then sees a pte_special PTE in a VMA lacking
> VM_PFNMAP/VM_MIXEDMAP and calls print_bad_page_map(), producing the
> splat. Confirmed: crash log shows vm_flags:080000d1, missing VM_PFNMAP
> (0x400).
>
> This is a plain ordering bug in this one commit - not a driver-conversion
> or vma_can_gup()/predicate-logic issue.
>
> Bisect method: built/booted via virtme-ng, ran pfnmap selftest directly,
> restricted to range 2a937a04babf1~1..0a80aa0fb08f1 (the 40-commit series;
> tip = mm-unstable-2026-09-17). Pre-series commit: clean. First commit of
> series: already reproduces the bug. All scratch worktrees/branches and
> bisect state removed after; mm-unstable-2026-09-17/mm-new-2026-09-17 and
> mmotm remote untouched.
>
> Diagnosis only - no fix proposed/applied.
>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/internal.h |  1 +
> >  mm/util.c     |  5 +++-
> >  mm/vma.c      | 95 ++++++++++++++++++++++++++++++++++-------------------------
> >  mm/vma.h      |  6 ++--
> >  4 files changed, 64 insertions(+), 43 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 0dca33db068f..fe576d468af4 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -7,6 +7,7 @@
> >  #ifndef __MM_INTERNAL_H
> >  #define __MM_INTERNAL_H
> >
> > +#include <linux/file.h>
> >  #include <linux/fs.h>
> >  #include <linux/khugepaged.h>
> >  #include <linux/mm.h>
> > diff --git a/mm/util.c b/mm/util.c
> > index bf0513d1d3d0..016932780925 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
> >
> >  	/* Perform any preparatory tasks for mmap action. */
> >  	err = mmap_action_prepare(desc);
> > -	if (err)
> > +	if (err) {
> > +		if (desc->vm_file != vma->vm_file)
> > +			fput(desc->vm_file);
> >  		return err;
> > +	}
> >  	/* Update the VMA from the descriptor. */
> >  	compat_set_vma_from_desc(vma, desc);
> >  	/* Complete any specified mmap actions. */
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 55917d097933..a319a9fc2f29 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -24,7 +24,8 @@ struct mmap_state {
> >  		vm_flags_t vm_flags;
> >  		vma_flags_t vma_flags;
> >  	};
> > -	struct file *file;
> > +	struct file *file;	/* mmap()-specified file. */
> > +	struct file *vm_file;	/* May be updated by mmap_prepare. */
> >  	pgprot_t page_prot;
> >
> >  	/* User-defined fields, perhaps updated by .mmap_prepare(). */
> > @@ -43,8 +44,6 @@ struct mmap_state {
> >
> >  	/* Determine if we can check KSM flags early in mmap() logic. */
> >  	bool check_ksm_early :1;
> > -	/* If .mmap_prepare changed the file, we don't need to pin. */
> > -	bool file_doesnt_need_get :1;
> >  };
> >
> >  #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vma_flags_, file_) \
> > @@ -58,6 +57,7 @@ struct mmap_state {
> >  		.pglen = PHYS_PFN(len_),				\
> >  		.vma_flags = vma_flags_,				\
> >  		.file = file_,						\
> > +		.vm_file = file_,					\
> >  		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
> >  	}
> >
> > @@ -70,7 +70,7 @@ struct mmap_state {
> >  		.vma_flags = (map_)->vma_flags,				\
> >  		.pgoff = (map_)->pgoff,					\
> >  		.anon_pgoff = (map_)->anon_pgoff,			\
> > -		.file = (map_)->file,					\
> > +		.file = (map_)->vm_file,				\
> >  		.prev = (map_)->prev,					\
> >  		.middle = vma_,						\
> >  		.next = (vma_) ? NULL : (map_)->next,			\
> > @@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
> >   */
> >  static bool accountable_mapping(struct mmap_state *map)
> >  {
> > -	const struct file *file = map->file;
> > +	const struct file *file = map->vm_file;
> >
> >  	/*
> >  	 * hugetlb has its own accounting separate from the core VM
> > @@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_munmap_struct *vms,
> >
> >  static void update_ksm_flags(struct mmap_state *map)
> >  {
> > -	map->vma_flags = ksm_vma_flags(map->mm, map->file, map->vma_flags);
> > +	map->vma_flags = ksm_vma_flags(map->mm, map->vm_file, map->vma_flags);
> >  }
> >
> >  static void set_desc_from_map(struct vm_area_desc *desc,
> > @@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_desc *desc,
> >  	desc->end = map->end;
> >
> >  	desc->pgoff = map->pgoff;
> > -	desc->vm_file = map->file;
> > +	desc->vm_file = map->vm_file;
> >  	desc->vma_flags = map->vma_flags;
> >  	desc->page_prot = map->page_prot;
> >  }
> > @@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
> >  	return 0;
> >  }
> >
> > +static bool map_same_file(struct mmap_state *map)
> > +{
> > +	return map->vm_file == map->file;
> > +}
> >
> >  static int __mmap_new_file_vma(struct mmap_state *map,
> >  			       struct vm_area_struct *vma)
> > @@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >  	struct vma_iterator *vmi = map->vmi;
> >  	int error;
> >
> > -	vma->vm_file = map->file;
> > -	if (!map->file_doesnt_need_get)
> > -		get_file(map->file);
> > +	vma->vm_file = map->vm_file;
> > +	if (map_same_file(map))
> > +		get_file(map->vm_file);
> >
> > -	if (!map->file->f_op->mmap)
> > +	if (!map->vm_file->f_op->mmap)
> >  		return 0;
> >
> >  	error = mmap_file(vma->vm_file, vma);
> > +	map->vm_file = vma->vm_file;
> > +
> >  	if (error) {
> >  		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
> >  			    map->prev, map->next);
> > -		fput(vma->vm_file);
> > -		vma->vm_file = NULL;
> > +		if (map_same_file(map))
> > +			fput(map->vm_file);
> >
> > +		vma->vm_file = NULL;
> >  		vma_iter_set(vmi, vma->vm_end);
> >  		/* Undo any partial mapping done by a device driver. */
> >  		unmap_region(&unmap);
> > @@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >  			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
> >  			vma_test(vma, VMA_MAYWRITE_BIT));
> >
> > -	map->file = vma->vm_file;
> >  	map->vma_flags = vma->flags;
> >
> >  	return 0;
> > @@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >
> >  static void map_set_anon(struct mmap_state *map)
> >  {
> > -	map->file = NULL;
> > +	map->vm_file = NULL;
> >  	map->vm_ops = NULL;
> >  	map->pgoff = map->addr >> PAGE_SHIFT;
> >  }
> > @@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_state *map)
> >
> >  static bool map_is_anon(const struct mmap_state *map)
> >  {
> > -	return map_is_private(map) && !map->file;
> > +	return map_is_private(map) && !map->vm_file;
> >  }
> >
> >  /*
> > @@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
> >  	}
> >
> >  	/* Invoke callbacks. */
> > -	if (map->file)
> > +	if (map->vm_file)
> >  		error = __mmap_new_file_vma(map, vma);
> >  	else if (!is_anon)
> >  		error = shmem_zero_setup(vma);
> > @@ -2797,36 +2803,34 @@ static int call_mmap_prepare(struct mmap_state *map,
> >  	int err;
> >
> >  	/* Invoke the hook. */
> > -	err = vfs_mmap_prepare(map->file, desc);
> > -	if (err)
> > -		return err;
> > -
> > -	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
> > -	if (!desc->vm_ops)
> > -		return -EINVAL;
> > -
> > -	err = call_action_prepare(map, desc);
> > +	err = vfs_mmap_prepare(map->vm_file, desc);
> >  	if (err)
> >  		return err;
> >
> >  	/* Update fields permitted to be changed. */
> >  	map->pgoff = desc->pgoff;
> > -	if (desc->vm_file != map->file) {
> > -		map->file_doesnt_need_get = true;
> > -		map->file = desc->vm_file;
> > -	}
> > +	if (desc->vm_file != map->vm_file)
> > +		map->vm_file = desc->vm_file;
> >  	map->vma_flags = desc->vma_flags;
> >  	map->page_prot = desc->page_prot;
> >  	/* User-defined fields. */
> >  	map->vm_ops = desc->vm_ops;
> >  	map->vm_private_data = desc->private_data;
> >
> > +	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
> > +	if (!desc->vm_ops)
> > +		return -EINVAL;
> > +
> > +	err = call_action_prepare(map, desc);
> > +	if (err)
> > +		return err;
> > +
> >  	/*
> >  	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
> >  	 * anonymous mappings. Rather than allowing these mappings to be odd
> >  	 * outliers, simply make them truly anonymous.
> >  	 */
> > -	if (map_is_private(map) && file_is_dev_zero(map->file))
> > +	if (map_is_private(map) && file_is_dev_zero(map->vm_file))
> >  		map_set_anon(map);
> >
> >  	return 0;
> > @@ -2845,7 +2849,7 @@ static void set_vma_user_defined_fields(struct vm_area_struct *vma,
> >   */
> >  static bool can_set_ksm_flags_early(struct mmap_state *map)
> >  {
> > -	struct file *file = map->file;
> > +	struct file *file = map->vm_file;
> >
> >  	/* Anonymous mappings have no driver which can change them. */
> >  	if (!file)
> > @@ -2868,6 +2872,20 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
> >  	return false;
> >  }
> >
> > +static void put_map(struct mmap_state *map)
> > +{
> > +	/*
> > +	 * An error occurred or the VMA was merged.
> > +	 *
> > +	 * If the file was changed by the driver (which is required to increment
> > +	 * the replacement file's reference count), drop its reference count.
> > +	 *
> > +	 * On error, the caller always drops the original file regardless.
> > +	 */
> > +	if (map->vm_file && !map_same_file(map))
> > +		fput(map->vm_file);
> > +}
> > +
> >  static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >  		unsigned long len, vma_flags_t vma_flags,
> >  		unsigned long pgoff, struct list_head *uf)
> > @@ -2922,7 +2940,10 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >
> >  	__mmap_complete(&map, vma);
> >
> > -	if (have_mmap_prepare && allocated_new) {
> > +	if (!allocated_new) {
> > +		/* Merged, so need to drop refcount. */
> > +		put_map(&map);
> > +	} else if (have_mmap_prepare) {
> >  		error = mmap_action_complete(vma, &desc.action,
> >  					     /*is_compat=*/false);
> >  		if (error)
> > @@ -2936,13 +2957,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >  	if (map.charged)
> >  		vm_unacct_memory(map.charged);
> >  abort_munmap:
> > -	/*
> > -	 * This indicates that .mmap_prepare has set a new file, differing from
> > -	 * desc->vm_file. But since we're aborting the operation, only the
> > -	 * original file will be cleaned up. Ensure we clean up both.
> > -	 */
> > -	if (map.file_doesnt_need_get)
> > -		fput(map.file);
> > +	put_map(&map);
> >  	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
> >  	return error;
> >  }
> > diff --git a/mm/vma.h b/mm/vma.h
> > index e97bd2dfa786..f15faa83f3d6 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
> >
> >  	/* Mutable fields. Populated with initial state. */
> >  	vma_set_pgoff(vma, desc->pgoff);
> > -	if (desc->vm_file != vma->vm_file)
> > -		vma_set_file(vma, desc->vm_file);
> > +	if (desc->vm_file != vma->vm_file) {
> > +		fput(vma->vm_file);
> > +		vma->vm_file = desc->vm_file;
> > +	}
> >  	vma->flags = desc->vma_flags;
> >  	vma->vm_page_prot = desc->page_prot;
> >
> >
> > --
> > 2.55.0
> >
>
> --
> Sincerely yours,
> Mike.

--
Cheers, Lorenzo
