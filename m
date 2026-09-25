Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0121E3DA7E4;
	Fri, 25 Sep 2026 09:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790330134; cv=none; b=E+5LTsWscHyD+Pq9GzS/Gi5cprSe8Ujqoy6Rj9E30vHdzk0MWfnhOpIJkRTuMvZP3GiS1tVSzh4jvRVI6bx0GIzazO+loQBxryLG6VQAtbKw9ssrNVBmp2K0px7PTNbrrZXsaYrtNkJK6GuaW0lSeu+SLVi7HRMlbD8a6opCPBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790330134; c=relaxed/simple;
	bh=bbikqsSea9vW+pe3Cgq2a9QL95dQasb87hlFKxy08F8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dkV5/EYkCBQn5pyz+cwsaZfrThofldme4FpFbE6QHNrboKZdxAcFm6jzBRqRdGyd7+GP6QhT6/5EGl46uexq9HfCZRa6bzDCITrX9l9/qVru9cxvoYfj1Df6j8SHtB+oZBE0PE7Erij3fXOAXQezL4GvSfw0VAFA0Ph9kP6JW2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HxJQcEvn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HxJQcEvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C76A1F000FF;
	Fri, 25 Sep 2026 09:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790330132;
	bh=wHcL5jPNS47s6Ul8XnEo1uFsA8Y0TKv8vyd/Iuc4jW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HxJQcEvnuhUOHH3Z6mzmWye1CE1PjDtpVrPBVFbcNDGyG6yBkjOShg1wXTRxmQKyc
	 TCJMHEkTxA8Sxw4HyLR7LdXQhRJb+9udY3QgV8ET7cug6AZBPLxgIFx/TdmYGQ8bVU
	 ptEgwP56FVQ2pJrDbYSWaP8xyRORQKPPWrshPWAAjxwWnAwT2YIoJgfyo9wv4EO7c3
	 7ozDd+omlnSWJmwSq3s1563JOKXMeNxa13jAxu5Ee20miDdmPGzcEIeZWGgnBBy5y6
	 eWzAFHQy56s+qgvvgTG8xUGQUmf5tQzyaZcP9CgdenUpWl9R2UycwCgDON1sf75KvU
	 KkanjhxFaUGcw==
Date: Fri, 25 Sep 2026 10:55:01 +0100
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
Subject: Re: [PATCH v3 05/40] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
Message-ID: <arZE4aXD0yIbXVFU@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
 <DLNSM8R8JS9A.1850RMXAG9NSR@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLNSM8R8JS9A.1850RMXAG9NSR@nvidia.com>

On Thu, Sep 24, 2026 at 03:28:10PM -0400, Zi Yan wrote:
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > When a user requests an mmap_action be performed in mmap_prepare, this
> > involves populating the VMA range with data.
> >
> > However, if the VMA is mergeable, it might then mistakenly be merged with
> > another VMA without having populated the range.
> >
> > Every mmap action currently available sets VMA flags such that the VMA
> > cannot be merged.
> >
> > However, to ensure that no future mmap action falls foul of this, assert
> > that this is the case upon mmap_prepare validation.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/vma.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index d6ed10cefc8f..62f2ce1ad5a1 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
> >  int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
> >  			  const struct vm_area_desc *desc)
> >  {
> > +	/*
> > +	 * It is not valid to execute mmap actions for VMAs which can be merged,
>
> Is it better to say "for VMAs ... after mmap_action_prepare()"? When I
> first read this, I wonder why the check is done after
> mmap_action_prepare(), which does some work based on action.type. Then,
> I realize mmap_action_prepare() changes desc->vma_flags and affect its
> mergeablitiy.

Ack, good point will update!

>
> > +	 * as any such merge would leave portions of the mapping incorrectly
> > +	 * unmapped.
> > +	 */
> > +	if (vma_flags_can_merge(&desc->vma_flags) &&
> > +	    WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
> > +		return -EINVAL;
> > +
> >  	return mmap_validate(prev_desc->start, prev_desc->end,
> >  			     desc->start, desc->end,
> >  			     &prev_desc->vma_flags, &desc->vma_flags);
>
>
> Otherwise, LGTM.
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
