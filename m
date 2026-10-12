Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E74D4BC00F;
	Mon, 12 Oct 2026 18:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791829452; cv=none; b=Uq9eD592j8TVkuwk8SkavLbf76bc8lWO/hcvW2GqB6YTLy4OoRt26/JBwH0GKfAtVioTGEe6QxCHYWS/0+y6Vlvags8Jq742nzChuBcH9FLRzaRTiHbpdLqQtX2+6HRqi8z+VQF886i9jttXwpwXEKweap8ANdKddc4+A5aO/MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791829452; c=relaxed/simple;
	bh=BtQocHpdf5dBBWPMZETPGfExdnolUcH9cTuxZg3qeFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kklUJGA9t+75TtU8RD9LUfb0P240K9EVhayu1gyv2yfYwsSb3OaDgDpxEiMgyPvoc0xZKVDU1u/CV9GPgfWACzRTStvf3mFfcNjce8r0FFIMucP74zk6P+d92evS3Myv5lq+nYVsD7ecH8Rar6gPV1V+pwXTcEOn5lQhQ0RUdKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtE+F+Qv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtE+F+Qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB211F008A1;
	Mon, 12 Oct 2026 18:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791829451;
	bh=XFaoCRsSeFrqplzPhC7sYiQbwkNwnjThwg1EUt1kpJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jtE+F+Qv8Id6B6sok4tUXFo/WttdoAtNDsnYx3FOXrAL8cH9okupFlV8UIia7guEU
	 +vucEDeV2orWOn4vncvKjOHxgLpA4z1i7ajNG9MWZWMFVvN4qyIVzuZeKcX/kEyCrH
	 E/taH25MY4+xXS5peaLpSE7R7Iim8QiaiSCBIYGbdI33SdOJfzFvr3BmyPD17L1aAJ
	 U/0dNzP3xhDe22x9gKDa9ilglbfD3cWxl+IMj1eK+ZgOY9uKMvF9rxkAMBdTJx+kaH
	 UEWib9ZdZm5YRBOs8FNN9IM2uvce7gfClsp4wZPpS8lSb0rbCcbaWuL8XwghfAbqY4
	 TscCzNvFkg/Kw==
Date: Mon, 12 Oct 2026 19:23:24 +0100
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
Subject: Re: [PATCH v5 22/38] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
Message-ID: <as0lLP26IkTzbeaz@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-22-923b70125b1e@kernel.org>
 <5027aec2-84c1-461e-9f74-0736e2cc6171@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5027aec2-84c1-461e-9f74-0736e2cc6171@kernel.org>

On Mon, Oct 12, 2026 at 08:19:03PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> > Currently there's a confusing mess around VMA_LOCKED_BIT and
> > VMA_LOCKONFAULT_BIT.
> >
> > It is permitted for drivers to set any flags they like, with the VMA
> > already possessing lock flags.
> >
> > This results in the absurd situation of a VMA possessing both
> > VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.
> >
> > This has resulted in mlock_vma_folio() having a very silly check for this
> > scenario to work around it.
> >
> > There is no need for this - just clear the flags before invoking the hook
> > and reinstate them afterwards if they are required.
> >
> > Nothing relies upon this being set during the mmap operation.
> >
> > mmap_prepare is unaffected by this so requires no fix.
> >
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/internal.h |  9 +--------
> >  mm/vma.c      | 17 +++++++++++++++++
> >  2 files changed, 18 insertions(+), 8 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 557e629db8c5..4ae08fedffff 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -970,14 +970,7 @@ void mlock_folio(struct folio *folio);
> >  static inline void mlock_vma_folio(struct folio *folio,
> >  				struct vm_area_struct *vma)
> >  {
> > -	/*
> > -	 * The VM_SPECIAL check here serves two purposes.
> > -	 * 1) VM_IO check prevents migration from double-counting during mlock.
> > -	 * 2) Although mmap_region() and mlock_fixup() take care that VM_LOCKED
> > -	 *    is never left set on a VM_SPECIAL vma, there is an interval while
> > -	 *    file->f_op->mmap() is using vm_insert_page(s), when VM_LOCKED may
> > -	 *    still be set while VM_SPECIAL bits are added: so ignore it then.
> > -	 */
> > +	/* The VM_IO check prevents migration from double-counting during mlock. */
> >  	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
> >  		mlock_folio(folio);
> >  }
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 39ceb03023e2..4f09fb98a2fd 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2607,6 +2607,11 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >  	if (!map->vm_file->f_op->mmap)
> >  		return 0;
> >
> > +	/*
> > +	 * Driver-specified flags may make the lock flags invalid, so clear
> > +	 * VMA_LOCKED_MASK and reinstate it afterwards if appropriate.
> > +	 */
> > +	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
> >  	error = mmap_file(vma->vm_file, vma);
> >  	map->vm_file = vma->vm_file;
> >
> > @@ -2629,6 +2634,18 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >  		return error;
> >  	}
> >
> > +	/*
> > +	 * If the VMA is still eligible for mlock(), reinstate any original
> > +	 * VMA_LOCKED_BIT and/or VMA_LOCKONFAULT_BIT flags.
> > +	 */
> > +	if (vma_supports_mlock(vma)) {
> > +		const vma_flags_t mask =
> > +			vma_flags_and_mask(&map->vma_flags,
> > +					   VMA_LOCKED_MASK);
>
> I'd just have at least the = vma_flags_and_mask on the same line. It's ok to
> exceed 80 chars.

I've had people yell at me about this before on review :) you can't really win.

Since I'm doing a respin anyway I can put it on one line.

>
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

--
Cheers, Lorenzo
