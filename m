Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AF838D406;
	Thu, 24 Sep 2026 10:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244251; cv=none; b=Xu6ATFNCvoAx2GDfD3bZ6ZklpHvT4dVaTkscCC4FzeR+fwG9wA3Sim6OT76EO5gC04HdfTfeSjy27RmM0cHZbIfPAIxvcnsTJXSWUuZ61i6JjBxHaA07VXIn7NKvkZXTEaW467lPqGGqS1OK092emfjU7+tWX/0eC5E+bGyyzhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244251; c=relaxed/simple;
	bh=vbbMFj8U5zQ0DLQ+H49dKoTliQh3lrv6oisq4q6G+00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CS9IPY4FtTkjCQDMTbzEQI+R8Zgi9BRXu6IqYUYmAmLXmA6E66nealO4ulPqg5i9fQ8g+pggC5U+EtAEZJCAyxuyibKsuFsmpw3XZIPIMo6rFs4rlDYtETQ3x58/VWCbw1iDdcYxUDUXcRr0LEcYVnqvrJx9fDN1FlFA5rO4Wss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMbxskam; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMbxskam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097291F000FF;
	Thu, 24 Sep 2026 10:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244234;
	bh=Q6qe1GeJ9XQcp2Qtuu+QjoS116ZDPXf6D3ecAVzIRhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DMbxskamLqIuQ517s1qWGAAn1E+xsD1IWLYGPnumbRx6pTv8bCwHJNooLP/0Y9MmF
	 ewyfTQFlrtMHi0vbNbmoGXeP02wTiKXQwMUnfW6BJPnwha3F6zTor4G266x5NCtrLZ
	 UINk2FfnnrWpmI4AgQSRtCEaaer/qXtOU6XcHLmcrADLmAXvRTfOudurStBkH10L0j
	 cHXvTwq8BsOo1ESnuzegeDjHk5jwPxjbI7VL3VpDQNaTCWwI1ExYzT3hhqIHmtSCUY
	 phCcWTevzoeBg5AakjX55gtjhS7DlK4HJYPRuO/TGOEmjyYP86Mnf1i03HAWs2ule+
	 sZHwPnp+ZmfYA==
Date: Thu, 24 Sep 2026 11:03:23 +0100
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
Subject: Re: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <arTvHhdoxZi_LslN@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
 <26EB9785-2909-4D49-A755-09A72BA94BD0@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26EB9785-2909-4D49-A755-09A72BA94BD0@nvidia.com>

On Wed, Sep 23, 2026 at 10:20:43PM -0400, Zi Yan wrote:
> On 17 Sep 2026, at 12:22, Lorenzo Stoakes (ARM) wrote:
>
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
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/internal.h |  1 +
> >  mm/util.c     |  5 +++-
> >  mm/vma.c      | 83 +++++++++++++++++++++++++++++++++++------------------------
> >  mm/vma.h      |  6 +++--
> >  4 files changed, 59 insertions(+), 36 deletions(-)
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
> IIUC, file is never assigned other than MMAP_STATE() and should not
> change after mmap(). Could it be made const to prevent any change?
> I assume mmap_state will not need to handle the nesting issue like
> vm_area_desc, so file can be const.

Oh I had assumed that this couldn't be const and I thought I'd checked that, but
seems not, it can be :)

Will fix that up for v4 thanks!

>
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
>
>
> Best Regards,
> Yan, Zi

--
Cheers, Lorenzo
