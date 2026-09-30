Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C06C30C147;
	Wed, 30 Sep 2026 09:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790760761; cv=none; b=Kf9Zr2uNjv45FwLGm/pDi1s5K2fOqWiFNkJULWX0rtrHJR2A2ylYuyTTb6Y6CNrBQsxkHIzSVOLDvh1Wl1jHIMaDPkjhtJGP530xZog4U5RaDZ5MftPSguEzABYKK+nl4CKzV3ZyZm2VikY0kM9frmh5EZYnmgWPqK9zzcQien8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790760761; c=relaxed/simple;
	bh=TlzHEJQt+34xYjujqXxuq3JcjM0wYp8ZviYUagsVkog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=garWEN3pTPZ7+NgDU1WHoJtjfajbeOywY3CMAhthbp1Wn6S/ZR7JDL1COPGG16xzzNMad5wxSVwPmmJwNRV0wutckgUP6s9N+LHPXG14nlYHw3+dWd5gAqMX8XpHnmCS89rzNhvWXYrh3iR4CfWqOLZv34HFKanSM5TiA59WRWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/WFPBAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/WFPBAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD21A1F000FF;
	Wed, 30 Sep 2026 09:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790760760;
	bh=GUhUebTYwdNTDsFDAgKX2XUga1p/xniYtUmuBOcAkD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A/WFPBAH7Qma+9hcX287RuSKWlORpntiWFjFLaPigU8Y75ISxg3KEjLTfteawEyBe
	 2g/cYh4OEqr71nkWwJpVQnorMprUQRkz1eix+QLOCr/CPst8lLD0ChCfFd8YGM4jfy
	 Fksx04sLagSxxR88vp09QnJZCikrL8s15UEcYtyj8cHuNrsfav7blbRqRE5dyxX7SB
	 IKNdTpYGGoAU9JjY6jjqMsEYQfRaLoK1HI3j102H2WUj2d2AjX7kJd1tm0yEuZtXim
	 rxv3PmM3a58m4CHKDbt2tmNwqyH0M2+G0zuIAT/AqLpxmsAoL5566Xt1IaKFXihiLq
	 k8Bhh/EDc3Mrg==
Date: Wed, 30 Sep 2026 10:32:09 +0100
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
Subject: Re: [PATCH v3 34/40] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
Message-ID: <arzXDWOaouPMGtxL@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-34-4583d8a23bca@kernel.org>
 <DLSAZ4ZQY8Q3.3OKOCCOQAFVCC@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLSAZ4ZQY8Q3.3OKOCCOQAFVCC@nvidia.com>

On Tue, Sep 29, 2026 at 10:42:00PM -0400, Zi Yan wrote:
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > It is now an invariant that VMA_IO_BIT is not set except by kernel-owned
> > mappings, so each existing VMA_SPECIAL_FLAGS test need only test for
> > VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.
> >
> > This is precisely a test for a kernel-owned or fixed mapping.
> >
> > Update a number of callsites which already explicitly handle hugetlb
> > mappings.
> >
> > vma_supports_mlock() and ksm_compatible() also explicitly bail on droppable
> > mappings - detecting kernel-owned, fixed or droppable mappings is handled
> > by vma_is_persistent(), so in these cases use this predicate.
> >
> > should_skip_vma() tests for locked, kernel-owned or fixed memory (having
> > already excluded hugetlb mappings) so simply test for those there.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/internal.h | 4 +---
> >  mm/ksm.c      | 4 +---
> >  mm/vmscan.c   | 3 ++-
> >  3 files changed, 4 insertions(+), 7 deletions(-)
> >
>
> <snip>
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 12ed3388ee41..09ff20c3df5b 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3477,7 +3477,8 @@ static int should_skip_vma(unsigned long start, unsigned long end, struct mm_wal
> >  	if (!vma_has_recency(vma))
> >  		return true;
> >
> > -	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
> > +	if (vma_test(vma, VMA_LOCKED_BIT) || vma_is_kernel_owned(vma) ||
>
> At this point, mmap_lock is held, there is no mlock WIP, so
> VMA_LOCKED_BIT is enough.

Yes indeed :)

>
> > +	    vma_is_fixed_mapping(vma))
> >  		return true;
> >
> >  	if (vma == get_gate_vma(vma->vm_mm))
>
> LGTM.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo
