Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905904D37B3;
	Mon, 12 Oct 2026 19:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791832324; cv=none; b=SmJ4/klyXVJvnXRNACJv51OPrSHbPxyo7xhvDCPIUcO2n+CJbw/hEWpgAGm2xzkk+UtFFVcEggOh+JfjVW0kxbFFi0ANADDJi4Hvu80Wht6C6fc2wqJD8cFJr4t8pHSJn5GPxZcd0h1jopEa/h7BHOhISv0PYM+vAW34dhFkk0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791832324; c=relaxed/simple;
	bh=FdkP+D43EN+xQd/ndnjr780pUFvJoTrEDYoQqVAKW9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0UQiJo/+lDQDa5CJ9dKoqj/m51mCTrh3Sx6jpn1CoJKCwTk1aBgCJTTPutRND9ZIt/o43Oc4InVsPyeofAztQJZD8ih39/qeGtvXFKngLN2FM19E10q0DeZ4N/KuJegboSEoC0SZnFkvlhTGVPQ7ZqQ19zsS8yKEjO5T9yEnv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BEu0ArYB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BEu0ArYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B361F0089B;
	Mon, 12 Oct 2026 19:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791832322;
	bh=t5mO4SpyqVviWjSaaEv8n4NUJ8+LaAHDu09XG7kSbFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BEu0ArYB5XZKL/22X+idpyNhILy00Ml5Fj2jTZ7Fk/4tKlvNrtbcuHyIbatS1i6+H
	 EgraXbynE/kQHml4oxd8zg6gA+C0hu9dN4/bgco2QE++oQB5bH8DxThhNACrQfpLo5
	 XjczelQ46llI8hh5qdyeZlOGyGOojXJ0MYtBFM6yqvzpX+4jdT2meUTVQWDtflbCXM
	 6iF5pmWBFtkh91Se1FhzLeFVS17tfaVz+ddcjoVeEnKq4qW/b4a4Az4vnWO1vg7GEy
	 PxJnHj6TKtLcX2c2xZZNIY6SbIQi0/ch6peXKK7YGg1Kjv6Q5wlicS2sXtSXi+SohG
	 UEkXkdb5KImtQ==
Date: Mon, 12 Oct 2026 20:11:27 +0100
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
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>, 
	Emil Tsalapatis <emil@etsalapatis.com>
Subject: Re: [PATCH v5 13/38] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
Message-ID: <as0uGOcxjg74Xw7_@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-13-923b70125b1e@kernel.org>
 <5b8ef0ce-7429-4d74-b4da-a0561c59b1e2@kernel.org>
 <as0Buhi_-VCC7xLZ@gremlin>
 <4124106e-c51e-4476-bd67-63e4641bf14a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4124106e-c51e-4476-bd67-63e4641bf14a@kernel.org>

On Mon, Oct 12, 2026 at 08:56:23PM +0200, David Hildenbrand (Arm) wrote:
> On 10/12/26 17:55, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Oct 12, 2026 at 05:08:09PM +0200, David Hildenbrand (Arm) wrote:
> >> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> >
> >>> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> >>> index 7b6847200b43..b69fe5e34339 100644
> >>> --- a/kernel/bpf/arena.c
> >>> +++ b/kernel/bpf/arena.c
> >>> @@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
> >>>  	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
> >>>  	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
> >>>  	 * being copied into the child process on fork.
> >>> +	 * This is a kernel page so set VM_MIXEDMAP.
> >>>  	 */
> >>> -	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
> >>> +	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
> >>>  	vma->vm_ops = &arena_vm_ops;
> >>>  	return 0;
> >>>  }
> >>>
> >>
> >> Historically, VM_MIXEDMAP really just means: can contain refcounted and
> >> non-refcounted things. Everything with a struct page is refcounted.
> >>
> >> I think we are now changing the semantics to mean "maps kernel pages". I think
> >
> > Yes.
> >
> > It was sort of implicit before given insert_page() etc. but still really meaning
> > that it _might_ be both.
>
> Yeah, it's in the name. Mixed: pfn and/or ordinary.

Well the name is confusing as a great many users never mix anything, and it's
far from obvious you need to set one.

Anyway, one for later. Maybe a mask like VMA_NON_MM_MANAGED_MASK or something
better than that...

>
> >
> >> this is fine, but we really have to update the documentation (and possibly
> >> rename this thing to something more expressive?)
> >
> > Yeah I completely agree.
> >
> > I will rename it, but I think that's best for 7.5 obviously! :)
>
> Yes.
>
> VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
> 			  reasonably reconstructed on page fault.
>
> the description is already pretty clear. just not that kernel-mapped pages
> *must* use one of these.

I think mixed map could do with a rename because it implies it _is_ mixed rather
than could be.

But again one for the future!

>
> (again, the ->fault thing returning allcoated kernel memory is nasty)

Yeah added to my todo to fix that. Hateful.

--
Cheers, Lorenzo
