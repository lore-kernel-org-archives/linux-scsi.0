Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9804E73C5;
	Wed, 23 Sep 2026 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790183262; cv=none; b=SOwvH2oE3tovfm/f8JEsL/awomwhyiF+QQs3fYAVBrTQxq+zLubAJX99peLQ+NGTqniYri8lwzQOp6zwOpo+A20VisY2vJqn0EJqJVuzfHOchxXHNFE+CsUXql8uvRz2QS0z2BF3K73deKudOhHOYcNPnt5XU8POgAAEnWcwblY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790183262; c=relaxed/simple;
	bh=dY5VEKC+MHSoJK6lwGGGvjwFMDTn23WTI6Yxn6zXOoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ql7lUO1RySwXq0AAwVruFx/wOT5lkzo+sXn5RMPhFhxgTz5qNQm1hdZchA8XiLfjaRqQmQMgSRgGRIeKnoQzui/otgKHBbVAhyds0l3zum+SN+xxlwVPL+yNCqvJ0KXEcISstCqwKlxc65DgG6eNxlSFkp/49OuV465XzfAf+sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i12XGUT+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i12XGUT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370A61F000FF;
	Wed, 23 Sep 2026 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790183260;
	bh=DPNB6bW0x8y7Uu11BgHcG7CSR1tZ//UGOmZllbw9Ljw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i12XGUT+ELGTRJSrycRVzqTit3D2pyM9ZR0ZSTlIa0mojim7gB9yUZwmIu+wgWYZK
	 Ybyv+CV/Yh7wSmglW9QNbCpnx18TWoVPczcRHqo0Q/mnJsqjZQ3eFn2cP25qIt7fM9
	 +POE/rp3vRI+Oxpo8QK9N4EfOTJ5jI0dLtJ432mM7IKfaNA3MKzBEomsWln5bFOqPN
	 PxFbALYbyklQCFhfUINibcEvNCNrhcGgRwqd9F7gXGPywV48eYeWHkrJqezKwBbst0
	 GSXVIWXaPeEYe4X28qZjKKxCsy9Q0ESN1tzaw+iT6CqBpO8zm4Si1SUtWVa2wxKSZ8
	 vegFjunsRBTBA==
Date: Wed, 23 Sep 2026 18:07:07 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
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
Subject: Re: [PATCH v3 02/40] mm/vma: predicate setting mmap_prepare VMA
 fields on new vma alloc
Message-ID: <arQCCzmMARX81-3y@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
 <CAJuCfpEa8tUmYJBjx-cRdAE8y-jcKY0C81kAOa1QZS7F6tKdfQ@mail.gmail.com>
 <arP0oJgrgZlgtrb6@gremlin>
 <CAJuCfpFPPGaK-grNx9qiQOhzAXbxU+SO+95Fht1571TGREx2oQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFPPGaK-grNx9qiQOhzAXbxU+SO+95Fht1571TGREx2oQ@mail.gmail.com>

On Wed, Sep 23, 2026 at 09:09:38AM -0700, Suren Baghdasaryan wrote:
> On Wed, Sep 23, 2026 at 8:54 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Wed, Sep 23, 2026 at 08:32:43AM -0700, Suren Baghdasaryan wrote:
> > > On Thu, Sep 17, 2026 at 9:24 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > >
> > > > It only makes sense to manipulate VMA fields if we allocated a new VMA,
> > > > rather than merged it.
> > > >
> > > > VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> > > > keeps its own, which is also what the legacy f_op->mmap path does since it
> > > > never touches an existing VMA. Previously set_vma_user_defined_fields()
> > > > overwrote the merged VMA's fields with those set for the new mapping. In
> > > > practice these are the same values, with rare exceptions such as shmem
> > > > selecting vm_ops based on whether the file has been unlinked, so no
> > > > user-visible change is expected.
> > > >
> > > > Make this dependency explicit, and additionally constify have_mmap_prepare
> > > > while we're here.
> > >
> > > The fact that we might be overriding attributes of an existing VMA
> > > that we merged with is technically a bug even if we never hit it,
> > > right? If so, should we have:
> > >
> > > Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
> >
> > It's not a bug, it is an in-built assumption that the state used to assess
> > mergeability implies the same properties.
>
> Hmm. What prevents two VMAs with different vm_private_data members to
> be merged? IIUC is_mergeable_vma() does not check vm_private_data. In
> such a case set_vma_user_defined_fields() would override
> vm_private_data of an existing VMA, no?

I think you're right that it should be a fix patch, I'll put it out of the
series and send it as one.

The issue here is more so vm_private_data than vm_ops. And really it's that
vm_ops->mapped() wasn't called so you could have a refcount go to zero and
stay at zero when it shouldn't have been, for instance.

But in general though if you remove mmap_prepare and ask the same question:

What prevents a merge of 2 existing VMAs that were mapped using the
traditional mmap hook which somehow have entirely distinct vm_private_data
and vm_ops but the same file?

The answer is nothing prevents that, but there's an underlying assumption
that this state is fungible for a VMA over a given range given the same
file.

In that case, for anything where an allocation or e.g. refcount change
occurred, then vm_ops->close() will handle the decrement, and the original
VMA's state should suffice.

But here it's a problem because you overwrite it + don't call
vm_ops->mapped()...

>
> >
> > And if it was, it'd need fixing a different way (check the field for instance)
> > and would apply to the legacy mmap hook also.
> >
> > This change is needed for the series though.
> >
> > >
> > > >
> > > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > >
> > > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Thanks!
> >
> > >
> > > > ---
> > > >  mm/vma.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/mm/vma.c b/mm/vma.c
> > > > index fa784f069da4..4b74b48c29b7 100644
> > > > --- a/mm/vma.c
> > > > +++ b/mm/vma.c
> > > > @@ -2894,7 +2894,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> > > >  {
> > > >         struct mm_struct *mm = current->mm;
> > > >         struct vm_area_struct *vma = NULL;
> > > > -       bool have_mmap_prepare = file && file->f_op->mmap_prepare;
> > > > +       const bool have_mmap_prepare = file && file->f_op->mmap_prepare;
> > > >         VMA_ITERATOR(vmi, mm, addr);
> > > >         const pgoff_t anon_pgoff = addr >> PAGE_SHIFT;
> > > >         MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags, file);
> > > > @@ -2937,7 +2937,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> > > >                 allocated_new = true;
> > > >         }
> > > >
> > > > -       if (have_mmap_prepare && !map_is_anon(&map))
> > > > +       if (have_mmap_prepare && allocated_new && !map_is_anon(&map))
> > > >                 set_vma_user_defined_fields(vma, &map);
> > > >
> > > >         __mmap_complete(&map, vma);
> > > >
> > > > --
> > > > 2.55.0
> > > >
> >
> > --
> > Cheers, Lorenzo

--
Cheers, Lorenzo
