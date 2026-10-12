Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF9F39FCAE;
	Mon, 12 Oct 2026 18:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791830962; cv=none; b=ZvIqOWBwNpOuBGh94FJ7K3GZP3rDE2v073C2MBMol70l0N3HtJ3XKEQl2DaghZZdbQAKmca5jdDB5IHY47Fvvp11ZFHF/JPRDzBeu6cWyoHmohfGlK78B69uVyGABZ0CYsVmdlEAatGs2e01hLKQHhw9YwFJIR9RdwoIx+MqYW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791830962; c=relaxed/simple;
	bh=MEUVrFAj8R+kakkVojzQVEa/GMRdV43Yd7WGg3lvDvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLBs1x4SsrCQpBw8b5hoBEBNk16iyKYgMiN1y6Xc5QcmPxAVFRu+qa6Nh7rBV5wmH8BeKd1QG3a6FLNGsGwqfGAbWq9rmGiLXCfhNrIRGwLY30cL/LeG9kb40gdN7s/kev6I9FR38l3sdWbhFwiMACzjg/iZS1S+SiMG694j5rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QD0nlTSY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QD0nlTSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2A01F008A1;
	Mon, 12 Oct 2026 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830960;
	bh=z5xYZY9H65OUGpiRPimS/vpQtz07u0fSLV/oQCSpMuo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QD0nlTSYVtj4dNkFEj86CW+geONwlsBOCCxKL4Z5VI8jl9RxNu+ctk47hohFj6Fu9
	 +e008cXUT+5s+dspRdF9mukkJrSjMqJuYauZgZXirZaou0iae6xnrMdwnn3C4LHJLG
	 l+rwIJ0HJm1INbdiZmmkcvWCdZnZWMk/0GxoTFohesUYAMQe2SvdzViSzb6SiInh3b
	 a1Pp+lrht8MKe7fPvZ+Ldk4pbNrpIc4cOAmMFt+Iozcz7DCPZt+GFnFr6m6HOdpKvK
	 eqlLtmiwxsfhYmOgI4guB2j2wveanvpJWWJRM7K/9lsaQnSred/JAbtKnvetwME2C7
	 +846hHAR76X9g==
Date: Mon, 12 Oct 2026 19:48:34 +0100
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
Subject: Re: [PATCH v5 24/38] mm/vma: enforce that mm-managed mappings may
 not set VMA_IO_BIT
Message-ID: <as0qUOfS-FQgRnm4@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-24-923b70125b1e@kernel.org>
 <5d51b6b3-ad58-4827-bedf-f1a79ebd5c86@kernel.org>
 <as0nF53W7dug-Fem@gremlin>
 <5ba7305f-0ad1-44ee-be0b-36752684cdb9@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ba7305f-0ad1-44ee-be0b-36752684cdb9@kernel.org>

On Mon, Oct 12, 2026 at 08:39:35PM +0200, David Hildenbrand (Arm) wrote:
> On 10/12/26 20:35, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Oct 12, 2026 at 08:25:54PM +0200, David Hildenbrand (Arm) wrote:
> >> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> >>> It makes no sense for a mapping whose contents the kernel does not own to
> >>> specify that the range is MMIO.
> >>>
> >>> Prior to this patch, all in-tree drivers which did so have been updated
> >>> such that they are marked as not being mm-managed. The check WARNs and
> >>> fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
> >>> without a kernel mapping.
> >>>
> >>> No functional change intended for in-tree code.
> >>>
> >>> Reviewed-by: Zi Yan <ziy@nvidia.com>
> >>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>> ---
> >>>  mm/vma.c | 6 ++++++
> >>>  1 file changed, 6 insertions(+)
> >>>
> >>> diff --git a/mm/vma.c b/mm/vma.c
> >>> index 4f09fb98a2fd..51bdbe08bb02 100644
> >>> --- a/mm/vma.c
> >>> +++ b/mm/vma.c
> >>> @@ -2796,6 +2796,12 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
> >>>  		return -EINVAL;
> >>>  #endif
> >>>
> >>> +	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
> >>> +		/* mm-managed mappings may not set VMA_IO_BIT. */
> >>> +		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
> >>> +			return -EINVAL;
> >>
> >> We do have a helper (vma_flags_is_mm_managed()) but we're not using it because
> >> of the VM_IO situation ...
> >
> > That gets removed.
> >
> >>
> >> That's confusing ...
> >>
> >> Could we do something like testing vma_flags_is_mm_managed(), but removing the
> >> VM_IO flag from the checked flags?
> >
> > I mean we do that in a subsequent commit, I think even the next one?
> >
> >
> >>
> >> Then we can add a comment about VM_IO in the future getting remove from
> >> vma_flags_is_mm_managed() ...
> >
> > Yeah, but to do that the code would now be something like:
> >
> > 	vma_flags_t masked = flags;
> >
> > 	/*
> > 	  * vma_flags_is_mm_managed() tests VMA_IO_BIT, which will be removed
> > 	 * in the next commit.
> > 	 */
> > 	vma_flags_clear(&flags, VMA_IO_BIT);
> > 	if (!vma_flags_is_mm_managed(masked)) {
> > 		...
> > 	}
> >
> > Is that really worth it?
> >
> > I don't think there's really too much confusion intra-patch about that is there?
>
> I would do it as above (- the comment, as that is the next patch indeed) and
> only remove the vma_flags_clear() in the next patch.
>
> But in any case, you should spell out that this is only temporary in the patch
> description :)

And then there's a 'masked' variable that is unused?

You need to have two vma_flags_t variables to be able both clear VMA_IO_BIT
and use vma_flags_is_mm_managed().

So the change would have to be

+ 	vma_flags_t masked = *flags;
+
+ 	vma_flags_clear(&flags, VMA_IO_BIT);
+ 	if (!vma_flags_is_mm_managed(&masked)) {
+ 		...
+ 	}

Then:

- 	vma_flags_t masked = *flags;
-
- 	vma_flags_clear(&flags, VMA_IO_BIT);
- 	if (!vma_flags_is_mm_managed(&masked)) {
+ 	if (!vma_flags_is_mm_managed(flags)) {
 		...
 	}

Which doesn't really seem worth it for somebody who is confused between two
patches mid-series.

But if you feel strongly I can make the change like that?

--
Cheers, Lorenzo
