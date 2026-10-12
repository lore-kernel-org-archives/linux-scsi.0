Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2C94C900C;
	Mon, 12 Oct 2026 18:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791830155; cv=none; b=ohpC7RtcrGiUKr6Rea2DbCsuA2Tg+VcrO+tzYZ+0fHSjmz/j705mVJzpTiEPgN0VwWJoFOi0KE3a75BhUd+yxYV1izXpCQL1wqRS3XmRtQVaZU/jLdlzDoB84v8D12sBvnr9jyVvDsM6iyac4i+CTdwoeOdvxCuseow+sVK9oXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791830155; c=relaxed/simple;
	bh=ABhZkSpkEbDJXMmu2pCjIxoFfKG4Vgkl1TOd/PFAIoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h4WMoG5n9Q4E7viw6X7IAc4LYtlNN1MKGLl0j+iR8+RlJMxksn5abOv9HcqRtUz1eDSkLCMcTxppDdLItWgSdfw+d3G5TR2TKySRxTBcg51/k12iUHquvQUcuCorIM02jHra36IAQ6apzjd3fLdpDzHV4mVfBRZ92F7KS8OhbRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TkoO9qGk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkoO9qGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9F21F0089B;
	Mon, 12 Oct 2026 18:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830153;
	bh=jU1x/84DlGCNGu203wenlbGvVVAo1cCrNfBUl54k+9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TkoO9qGkYGW1FWj2/mgiryBfpjnccwprQC1E7o5f83BDlENqZ8WPD/ofG4UHSiZZJ
	 2vTfSnSa6AfkIRzL17M7Qz3/R8466zAY4o0xL3ERQQ5qospe99h7jGb2E56B+IpTh+
	 d24PWBY7F0GHc5FcjGCh7xfi2y8M1O5anCjwIHtWAObmFhqYcKzxPoXONOOcxQPLwF
	 1BC4mXOJVOwyb8zVOJNG8qTcKgDAS/9MxT6XcESD/Gzwg/+VdpY2WOqwMVOUhDNiXC
	 MWmuJCQgGgWTNDRl4BnHkHTA4wJmP83NrXpTXiIzc3wpmWufJck7EqkStuGgGwvu18
	 ILC0aMgVybhUA==
Date: Mon, 12 Oct 2026 19:35:19 +0100
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
Message-ID: <as0nF53W7dug-Fem@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-24-923b70125b1e@kernel.org>
 <5d51b6b3-ad58-4827-bedf-f1a79ebd5c86@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d51b6b3-ad58-4827-bedf-f1a79ebd5c86@kernel.org>

On Mon, Oct 12, 2026 at 08:25:54PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> > It makes no sense for a mapping whose contents the kernel does not own to
> > specify that the range is MMIO.
> >
> > Prior to this patch, all in-tree drivers which did so have been updated
> > such that they are marked as not being mm-managed. The check WARNs and
> > fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
> > without a kernel mapping.
> >
> > No functional change intended for in-tree code.
> >
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/vma.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 4f09fb98a2fd..51bdbe08bb02 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2796,6 +2796,12 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
> >  		return -EINVAL;
> >  #endif
> >
> > +	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
> > +		/* mm-managed mappings may not set VMA_IO_BIT. */
> > +		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
> > +			return -EINVAL;
>
> We do have a helper (vma_flags_is_mm_managed()) but we're not using it because
> of the VM_IO situation ...

That gets removed.

>
> That's confusing ...
>
> Could we do something like testing vma_flags_is_mm_managed(), but removing the
> VM_IO flag from the checked flags?

I mean we do that in a subsequent commit, I think even the next one?


>
> Then we can add a comment about VM_IO in the future getting remove from
> vma_flags_is_mm_managed() ...

Yeah, but to do that the code would now be something like:

	vma_flags_t masked = flags;

	/*
	  * vma_flags_is_mm_managed() tests VMA_IO_BIT, which will be removed
	 * in the next commit.
	 */
	vma_flags_clear(&flags, VMA_IO_BIT);
	if (!vma_flags_is_mm_managed(masked)) {
		...
	}

Is that really worth it?

I don't think there's really too much confusion intra-patch about that is there?

--
Cheers, Lorenzo
