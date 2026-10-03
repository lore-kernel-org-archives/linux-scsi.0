Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A362CCC6;
	Sat,  3 Oct 2026 13:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791033439; cv=none; b=sTSfZ9VX5Pix+m8pt8UasUlJQM70yeu2ROicI4r9bp/20xknINL2wItFWZyEzcZKV6ZkyZOn2TXqcCU6sQcBk5ASiOxNdw0pEz82Fo1i8RXva0RMBL1NMK0E097WxecHTvMvXeHKRSGftTtL+Hc+qLf5ln0JrI0hkbBsQkfwxxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791033439; c=relaxed/simple;
	bh=iETBdhyd8YA5sdOaV2DmrYdJe9iH68XFXxBT/H5DVtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtEbh5KxIeN5abM7wrfCQQ/AgTfKwa1PZyTtJSkEsDeUNSbclHQ5wq4fwvYiSxmlM1OiwU7NcALWy+b03FUazdA+V9ZWoJxCtoKfodtguil87gMhDrGH+01iXlFotOhsaCYSIoW0MyPB3vrckc6JwzP3dUXfjTJ3oR1fUKVcCgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EgLBtik0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EgLBtik0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E6A1F0089B;
	Sat,  3 Oct 2026 13:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791033437;
	bh=/jEE4HcLwsM6TWLGremQKfzztE+rwvfFYJGPZmoq8a8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EgLBtik0WJzJCXWY/9/TI+W7fRx1wIZ9UfQuWfc+RhMCCFMM/xZJ03UyprLnrZDIx
	 +hSP6z4pIAKExuSJlxbZygGALgGCQywzqqoPN2+Boz6NDgyFCoTr0xtw8XwpV2ytvg
	 iOEb69EMyCjSZk8NVHT0gmIKW0rVbZ0F8RMvb9s4VF2Dbo0UftiN8tf9aa6rRRTzuW
	 Fpm1LnU0F8ufx8E3b1Xf3T36YgbMjc4jOyHoaXzj2tW9/dfBgzxbHqld35pMVHgUgN
	 4zsEh/CAz3fCIdmxhWutMDOLIRfajy8aGYLGHSvm01TwlgzafI+V3dGI5soFrbsjYq
	 SFWdbxe9eRGJQ==
Date: Sat, 3 Oct 2026 14:16:46 +0100
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
Subject: Re: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
Message-ID: <asD6cgnNVJhZA98p@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
 <9bbdf4e8-6984-4477-a183-f0b236047381@kernel.org>
 <3557015d-23dd-41ef-9832-78b58587f3f4@kernel.org>
 <81e1e5ae-0aab-4584-81e6-3fc9c2634d07@kernel.org>
 <ar-b_Ug__TBzIZsb@gremlin>
 <2e5a4e6c-8f9c-4050-8998-454b83f4823b@kernel.org>
 <ar-luB9QVCRshtIw@gremlin>
 <3387642b-c39f-4f19-ba0c-267bbd2fe91d@kernel.org>
 <ar-ux41ILjI1Px9S@gremlin>
 <a202523f-a696-4a8e-be77-7170c3913cdf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a202523f-a696-4a8e-be77-7170c3913cdf@kernel.org>

On Fri, Oct 02, 2026 at 11:43:53PM +0200, David Hildenbrand (Arm) wrote:
> On 10/2/26 15:59, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Oct 02, 2026 at 03:11:27PM +0200, David Hildenbrand (Arm) wrote:
> >> I'd be very happy if we could find a clear way to describe "this is what we call
> >> user memory: anon+pagecache", if that could come handy in such a context.
> >
> > Rather than arguing about it, how about shifting things to 'what backs the
> > mapping' and something like:
> >
> > /* big long kdoc... */
> > static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
> > {
> > 	/* hugetlb is a fixed mapping, but the mm owns it entirely. */
> > 	if (vma_flags_is_hugetlb(flags))
> > 		return true;
> >
> > 	/*
> > 	 * Kernel-owned mappings are populated by their owner, and fixed mappings
> > 	 * have a layout the mm cannot assume ordinary fault semantics over.
> > 	 */
> > 	if (vma_flags_is_kernel_owned(flags) ||
> > 	    vma_flags_is_fixed_mapping(flags))
> > 		return false;
> >
> > 	/* The mm has promised it may discard droppable memory at any time. */
> > 	return !vma_flags_test_single_mask(flags, VMA_DROPPABLE);
> > }
>
> In my other mail I was wondering whether we could use vma_is_mm_managed() to
> express !vma_is_kernel_owned(). Maybe vma_is_mm_backed() could fit into that
> picture.

Yeah, vma_is_mm_backed() = 'and the mm actually keeps it there' in effect :)

>
> Reading above I am still confused why something that expresses "backed" talks
> about "fixed mappings and ownership", sorry :(

I'll rework the kdoc to be clearer - I think with vma_is_mm_managed() the
picture actually becomes clearer.

>
> It's late here, and this is a hard nut to crack.

Yes :)

Thanks for taking the time with this, I know some of it is pretty heavy going.

>
> What we have here is:
>
> 1) Is this an ordinary MM-managed VMA. So far so good, I understand that. (with
>    a twist what I just learned about things that map random allocated pages
>    through -> fault, but so far so good)

Ack yeah. And ack on ->fault.

It feels like we let ->fault be FAR too permissive. In retrospect, arbitrarily
being able to put WHATEVER YOU WANT there was... unwise shall we say.

>
> 2) Is this MM "fixed" that makes expand/merge tricky, except if it's hugetlb
>    where we can still handle it.

Yeah the trickiest bit is the 'don't expand'.

The hugetlb exception is ugh, but hugetlb was engineered terribly,
essentially 'stick something in with total disregard for everything in core
mm and make it an exception you just have to remember for everything'.

I hope we all learn some lessons about what not to do from hugetlb and uffd
:)

>
> I think VM_DONTEXPAND is also rather misnamed :( I assume it really means, using
> sel_mmap_policy_ops() as an example: the MM manages the things that are getting
> mapped in here (->fault), but the pages are not really pagecache/anon, but some
> other shit. So we cannot expand the mapping.

Yeah. And it is terribly named.

>
> Gah, so complicated.
>
> 3) Can the MM drop the pages at any time.
>
>
> I still think that 3) does not quite fit into that picture. Using something like

If you look at what the callers do it makes more sense - mlock pins pages,
ksm merges them, dump writes them out and uffd hands their faults to userspace.

All four need the page behind the mapping to be the mm's own and _still
there the next time they look_.

With that in place it's not stable so it's not right to let such callers
have access, and all the callers have to remember to check that.

>
> "vma_is_mm_backed" to say "this is mm-managed, but all things in there come from
> core-mm and not some other random shit people punch into ->fault" would work for me.

Yeah agreed, I will update the kdoc to be clear about that.

>
> (not sure if there is still some other way how someone could get random pages
> into a VMA ... or how to catch someone not setting the DONTEXPAND flag)

vm_insert_pages() + friends sets VMA_MIXEDMAP_BIT now and
vmf_insert_page_mkwrite() is DAX only (a follow up will make that a thing)
so it's the damn ->fault that's the only thing left now.

Right now I think that everyone that does something weird sets
VMA_DONTEXPAND_BIT.

It needs renaming to something like VMA_CUSTOM_FAULTED_BIT or
something. That's probably a terrible name but you get the idea... :)

>
> God, this is all such a confusing mess with so many ways of getting stuff messed
> up by other parts of the system. Thanks for working on cleaning that up.

No worries :)

The whole point of the series is to stop treating these flags as vague
things (which VM_SPECIAL symbolised the most) so a. we can make sensible
assumptions about flag combinations and b. people can use meaningful
semantic checks rather than guessing (sometimes wrong).

Hopefully the pain here is all worth it :)

Thanks again for reviewing!

I will respin with kdoc changes.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo
