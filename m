Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D663AAF54;
	Fri,  2 Oct 2026 14:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790952995; cv=none; b=qfewKNWBllHv4Z5W3o+gaPBimGHrU349i4loD0QnHpuiVuIv/KRyrcVfYvktbgO2TbIhenvq0rP0SbeH0W8tBlr4d3PuzaBoaV5FlY/mdlUH6XFAsFClEXvKnBfkGbNxMCBSPe0L2T6sdLyJn0khb+x5G0SlQKgzLQ8TuiyWBCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790952995; c=relaxed/simple;
	bh=vNF3N3IxUFgjfHwaXFhoUUdmxvTVJaq2s8vGsZwJrtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tDRRoMZwwKDWQFbkBmzzMF7TsPkbSNJfobuF/S+vlifaw7wbrlV3WadnqzQAOyb51aIXuu/XCcsIroOluRnldBWMDT4bS3ZuQk2lL7RCspcvlfDZ1WaqEpYH9NlMKucJZof1YEOVwmtGfHlMak2n4FEl3J8z1e17T68P9P2dMWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdVzgh8v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdVzgh8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88791F00893;
	Fri,  2 Oct 2026 14:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790952993;
	bh=jQuiTsuvfiP4TjKhygdb17Hd1K9/CkYZDyLUI1EBmwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fdVzgh8vzUmdaKUlZe0VUNAIbLSN/FNhbQHH4wzlHFvv+hwCHSicNk7KjrZHYj3Yu
	 iQlLhsYS9ojqwSku1HQOXWnmdKoCu8CHMkE9A7LZ/DH6hiJQldb++n4ez57oVgBl0V
	 So8/jwrVJl3CEjbngowiXAkkkl3yvYCSfnXRCFedPo61Fs2XbO15rdcGoISGxqRB8K
	 jXU4TLmv22BTp6yPLlF2Jpru5HvWTRYFQZfFHeldR1afhWGGXDAezdVopQG8Ave8bR
	 CZFLT49VpC5WBX0wYA8iUka0IczATo+lcmXmrk2MeXbxiJX2meYd90/doZTa6tYh/0
	 hugq9t44NIjiw==
Date: Fri, 2 Oct 2026 15:56:04 +0100
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
Subject: Re: [PATCH v3 15/40] mm/vma: add vma[_flags]_is_kernel_owned()
 predicates
Message-ID: <ar_CYfkR5Pfb7J9b@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-15-4583d8a23bca@kernel.org>
 <0623ee06-00e5-421e-a24a-ed605abb559b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0623ee06-00e5-421e-a24a-ed605abb559b@kernel.org>

On Thu, Oct 01, 2026 at 02:36:40PM +0200, David Hildenbrand (Arm) wrote:
> On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> > Rather than referring to VMA flags with uncertain meaning, add a new
> > predicate that explicitly describes what possession of the VMA_PFNMAP_BIT
> > or VMA_MIXEDMAP_BIT flags mean, and then refer to that function for
> > determining VMA mergeability.
> >
> > Either flag means the contents of the mapping are owned by the kernel,
> > usually a driver, rather than by the core mm: the memory may be MMIO,
> > kernel-allocated pages or even ordinary pages the driver maps itself, but
> > the core must not populate, reclaim, migrate, copy-on-write or merge the
> > range on its own initiative.
> >
> > We initially also include VMA_IO_BIT here, as by implication, these must be
> > kernel-owned. (mlock() also sets VMA_IO_BIT transiently on ordinary VMAs
> > while locking them, which is addressed later in this series.)
> >
> > However the intent is to in future remove this, as no mapping should be
> > marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.
> >
> > This forms the basis of further work intended to improve how we express VMA
> > properties such as this.
> >
> > Also update the VMA userland tests to reflect the change.
> >
> > No functional change intended.
>
> Of course I have to bitch about the naming :)

Yup :)

>
> Intuitively: kernel owned vs ... user owned?
>
> No, it's kernel owned vs core-mm owned.

I would say somebody who does:

	ptr = malloc(4096);

Would think of that memory as 'owned' by them in the sense that they
control the lifetime, they established its attributes, etc.

So indeed, vs. user-owned.

>
> Which implies core-mm is not part of the kernel?
>
> Yes, this is confusing. ;)

I think what you're missing here is what _creates_ or _establishes_ the mapping.

Intuitively, if I do:

	ptr = kmalloc(GFP_KERNEL);

I, whether I am in the core kernel, or a driver, or whatever own it in any
meaningful sense of the word.

I think the issue here is you're confusing this with other things like the
rmap and refcounting, etc.


>
> I assume you're coming from "map_kernel_pages*", but that's rather "kernel
> memory" and not "kernel owned".
>
> Usually we say "driver owned" when not talking about pagecache/anon. Or user vs.
> kernel memory.

I think it would only add confusion:

VDSO/VVAR, perf ring buffers, shmem mapped via PFN map, uprobes, etc. are
all in this category and I doubt people would consider those driver-owned.

>
> So is it really all about "is this (excluding CoW) no ordinary user memory that
> we would track through the rmap" ?

VMA_MIXEDMAP_BIT mappings can be refcounted and rmapped so that's not a
correct description.

The distinction is - who put them there and who's allowed to change them
and who owns the lifecycle.

>
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h              | 56 ++++++++++++++++++++++++++++++++++++++++-
> >  tools/testing/vma/include/dup.h | 29 ++++++++++++++++++++-
> >  2 files changed, 83 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 2a92193ac6a5..cab29d6e15c1 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1612,6 +1612,44 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
> >  	return is_shared_maywrite(&vma->flags);
> >  }
> >
> > +/**
> > + * vma_flags_is_kernel_owned() - Do the specified VMA flags indicate that the
> > + * contents of the VMA are owned by the kernel rather than the core mm?
> > + * @flags: The VMA flags to test.
> > + *
> > + * A kernel-owned mapping is one whose contents are established and controlled
> > + * by the kernel, typically a driver, rather than by the core mm's fault and
> > + * rmap machinery.
> > + *
> > + * The mapping may be memory-mapped I/O, kernel-allocated pages or ordinary
> > + * pages the owner has chosen to map itself (shmem via a PFN map, for instance).
> > + *
> > + * In all cases the core mm must not populate, reclaim, migrate, copy-on-write
> > + * or merge it of its own accord.
> > + *
> > + * Pages mapped this way are not necessarily reference counted or map counted.
> > + *
> > + * Returns: true if the flags indicate a kernel-owned mapping.
> > + */
> > +static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
> > +{
> > +	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
> > +				  VMA_IO_BIT);
>
> I thought we have cases where we drivers insert pages and neither set
> VMA_PFNMAP_BIT nor VMA_MIXEDMAP_BIT.

There were 4 - defio, cmt_speech, uprobes and the bpf arena, and I fixed
all of them :)

Other than the DAX-only case below of course.

It's not correct behaviour and part of the point of this series is to
structurally _forbid_ illegal behaviour by drivers.

>
> I assume vmf_insert_page_mkwrite() is fine because it is DAX doing it (should we
> limit this interface to DAX?).

That is a DAX-only thing and DAX is precisely a case that should not be
kernel-owned (and isn't!)

This series actually fixes the FUSE case too, restricting this interface to
DAX only seems like a sensible follow up as well.

I could also add a patch to this series to do that too if you wanted?

--
Cheers, Lorenzo
