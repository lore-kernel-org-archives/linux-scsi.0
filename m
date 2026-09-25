Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B473C47C10B;
	Fri, 25 Sep 2026 09:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790327603; cv=none; b=ufAi36bI2WKzbCs9M2pYVB9XZy3C7k5gRxmjHgMUAZoiCxXM0/6R84sYnllDGSUq5TzZi3ow5dZK4TSlWNjJdnC5Mk0SL5fVJ0k7VEglVHEt6Vr1ehWFEe8TrWo/+hXFjYHiuxS8Ap3HRe69asyX3WA1BC44T6EPC8mS3N3Muuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790327603; c=relaxed/simple;
	bh=Tk8lnLCIykMhwm4FM62K4d7d7QJOAD1dpQSl1O/g2h4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BMuTZigNeyXY/MMRlXWwpVhOMZOOi8C7EA4/h615K5aeMjPdPGqKPC+T/5cryzp/VTJ9d0VGzrgfBuMgfLPrLYRWHn9B5xbeyD+F14wIWdlIXLTBnsVxYVZFMjgzHcjBtbeSH9e4cj/51QQprRD4r4+8O+qccaR/RWw2zv10Pbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2qi0Whp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2qi0Whp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A0E1F000FF;
	Fri, 25 Sep 2026 09:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790327601;
	bh=yfSL2ku4OKsR1ZwNLU9aq+Cv4BSlDAV3gm6yCuANvXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K2qi0Whp5/6TRdhA6MhlGYRilQhTQ8jPlG08QvTUUmQwkWOHWgmSx5AdhFTFi0qw/
	 r4+3OumzOouGc7txXhbbk80xasHy05dho7/yw8n5cfGkWIhweFLORuSQD6wUTgF3bF
	 dlK10/x8cBD+DlIEYdpY/JpYJifQA5N4twHg7jDXzl6B1XyEXIXzNDQx16+MJsnNtN
	 sTXe6Jh9EmnWLdP4R1YQtEnnOP8lnDSORnscuubhZoG/xGcNI3ROCCX9s0YjPIJIxI
	 MdK5fq25MLwiukRwd6j6BdAO4Z4mjaXg/lCXJQXPIaGguKLjAmtHiggDOa9mUzFR4Z
	 ur0MJU3/gDHOA==
Date: Fri, 25 Sep 2026 10:12:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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
Subject: Re: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <arY3xqkPCgZj3IVD@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
 <qpkcjtl5jbip46zxcpyogsk4phmhetfvrvgftxhsxlbxjhucnn@h3a64dfoxcmj>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qpkcjtl5jbip46zxcpyogsk4phmhetfvrvgftxhsxlbxjhucnn@h3a64dfoxcmj>

(forgive my possibly semi-broken efforts to trim the mail)

On Thu, Sep 24, 2026 at 03:00:44PM -0400, Liam R. Howlett wrote:
> On 26/09/17 05:22PM, Lorenzo Stoakes (ARM) wrote:

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
> > index 55917d097933..fa784f069da4 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -24,7 +24,8 @@ struct mmap_state {
> >  		vm_flags_t vm_flags;
> >  		vma_flags_t vma_flags;
> >  	};
> > -	struct file *file;
> > +	struct file *file;	/* mmap()-specified file. */
>
> I guess renaming file to mmaped_file would be a lot more changes.

Yeah :) and want to keep things sync'd with vm_area_desc.

Can always obviously follow up later with renames sync'd across both.

<snip>

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
>
> You set vma->vm_file to map->vm_file unconditionally above, is this
> necessary?

Yeah, because the mmap hook can change vma->vm_file, and this is necessary
for the correct file refcount accounting.

The accounting is actually very tricky, because the file that was passed
via mmap() is fput() after the operation is done but if its swapped then
you have to make sure everything works out correctly on both error and
success paths.

Which this patch does (with a lot of AI review checking to make sure it's
not broken! FWIW)

<snip>

> > @@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
> >  	}
> >
> >  	/* Invoke callbacks. */
> > -	if (map->file)
> > +	if (map->vm_file)
> >  		error = __mmap_new_file_vma(map, vma);
> >  	else if (!is_anon)
> >  		error = shmem_zero_setup(vma);
> > @@ -2797,11 +2803,15 @@ static int call_mmap_prepare(struct mmap_state *map,
> >  	int err;
> >
> >  	/* Invoke the hook. */
> > -	err = vfs_mmap_prepare(map->file, desc);
> > +	err = vfs_mmap_prepare(map->vm_file, desc);
> >  	if (err)
> >  		return err;
> >
> > -	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
> > +	/* Update first so file refcount tracked correctly. */
> > +	if (desc->vm_file != map->vm_file)
> > +		map->vm_file = desc->vm_file;
> > +
> > +	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
>
> The less rare of prepare ;)

Haha 'It's a rare prepare that would dare' is what I'd LIKE to put here as a
comment but probably can't :P

<snip>

> > +static void put_map(struct mmap_state *map)
>
>
> I like the put_map_file() instead, like Suren suggested.. but maybe
> put_map_vm_file(), especially since it could be read as put to the file
> pointer instead of vm_file.

Ack, and of course to bikeshed it a bit :P maybe map_put_vm_file() so the
'put vm_file' bit is clearer?

<snip>

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
>
> This isn't going to be racy somehow, right?

No, at this point the VMA write lock is held and everything should be
pinned correctly.

The vma_set_file() dance was the problematic bit here as it didn't
handle the file refcount properly.

>
> > +	}
> >  	vma->flags = desc->vma_flags;
> >  	vma->vm_page_prot = desc->page_prot;
> >
> >
> > --
> > 2.55.0
> >

--
Cheers, Lorenzo
