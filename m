Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E803468C22;
	Wed, 23 Sep 2026 08:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790151254; cv=none; b=QkkydmTFgWKAv42om4OWOTP2WXvd+NDzpqIbfBr2bbIQB/StloH9myvyumT1py3C5kxnJMf7DgQA4YfbdXf3dn6W8Fx1t/qvt0Bq2V3E0futs8NLiGhSsiuaL5B0D5i08i0ES9psdiyw84kHOie5pMk3Y+zcvsi0JNyfjboKJns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790151254; c=relaxed/simple;
	bh=aN2ZWo/23w37qNKgpNUnQ0H6NGD03WPhBvg03+MG/94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HR064HOt5Vnx77PFMZX0U1VDnIMihgT7audwW0G9+h8lBGhW6m4zH+0Zu06olSrHZnuTsQH47N4NPhfOE/ee1UP8ci5iG6uHAU/yt2ufBcMHAmqs71yOo97b1iHdkL1yvuM0CZ8JXayl+R78fG8Bce5Xkd7XBoxGrFXU7BRYeQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCJlfOwt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCJlfOwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376301F000FF;
	Wed, 23 Sep 2026 08:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790151252;
	bh=4asDkf1r4nhSOrT7R8hAyZcEQKKYrXhZ/zPFbXlZHas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mCJlfOwtX67y203buKELQIT2TJkfDrkJVRWjviTUThii3FIl01hNmt/2/N5niDJsO
	 pMfVhn9hKYcyv1hPNTj3q8nO0Pds6VFO+rGQe1AtibuYmlGhfEvG5fzsVNd5VZj00d
	 fkgcgDIaUfRNs16fD4U8B+bk8I0EVqFfud76K+T15hPjY5Wnzx7h17G1IEpBvKdbdT
	 fwOMBpLGIgd0Nxsna3HHhcpWKXrmzcnrf1IYhuJaw4NDIion+IMG6MmbJbYDpOjNxG
	 ds54K/vBGhy978o0s9QlAtQmkuOq1eOy+SdadnN3yilV4MeGzEJApyN21XCzbDlSMz
	 y5uiJtnDQNScw==
Date: Wed, 23 Sep 2026 09:13:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Message-ID: <arOCPN02xB7mykju@gremlin>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org>
 <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org>
 <CAJuCfpFBichJH4OcmSHTb1rOuQBT6k5pXeua9_KgpWjDBKvsYw@mail.gmail.com>
 <aq6kzpK7wPl3iFGe@gremlin>
 <aq6lW9FvL69QeA9H@gremlin>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aq6lW9FvL69QeA9H@gremlin>

On Sat, Sep 19, 2026 at 04:09:13PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Sat, Sep 19, 2026 at 04:05:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Sep 18, 2026 at 01:31:24PM -0700, Suren Baghdasaryan wrote:
> > > On Fri, Sep 18, 2026 at 1:21 PM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > > >
> > > > On 9/15/26 03:08, Andrew Morton wrote:
> > > > > On Mon, 14 Sep 2026 15:57:20 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> > > > >
> > > > >> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> > > > >> properties:
> > > > >>
> > > > >> ...
> > > > >>
> > > > >> It's all rather a mess.
> > > > >>
> > > > >> This series brings some order to things by both limiting what drivers can
> > > > >> do with VMA flags and switching to using predicates that describe
> > > > >> behaviour, not arbitrary flags.
> > > > >
> > > > > That's a lot of patches.
> > > > >
> > > > > Review is thin and I expect this won't improve a lot.  Lots of "no
> > > > > functional changes" changes.
> > > >
> > > > I'll expect to go through all of them. Might just take a bit ;)
> > >
> > > ditto
> >
> > Thanks guys!
>
> Note v3 has been posted to fix a stupid bug in 1/40 + attack some very trivial
> sashiko stuff
>
> https://lore.kernel.org/linux-mm/20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org/

Just a gentle nudge on this :)

If you guys or anybody else has some time it'd be appreciated! (obv. the v3 as
linked above not this v2!)

I know the series seems intimidating but most of the commits are very small and
it's been in -next for a while.

>
> >
> > >
> > > >
> > > > --
> > > > Cheers,
> > > >
> > > > David
> >
> > --
> > Cheers, Lorenzo
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo
