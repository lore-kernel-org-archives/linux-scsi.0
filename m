Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F3E502561;
	Tue, 29 Sep 2026 11:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790680339; cv=none; b=PiM1WO/DknW/97aa//ftGdnlxjR9k8iU50WF/aCGKM5djXC/BAh1IeJoWVXfrD97ukg4d0mr/fI6PwdJ4FKx1CzZEhySA45f/2tPTyuEkpCgQQaaI2ynSkJrVJKR6aZT95YlEb+1IfAbucL2GNZHbxgR7DCgOhz1oaiKlooLXF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790680339; c=relaxed/simple;
	bh=Oa+fncOJqLBSPNYLEUbP6b6zgvqPNXaiiMRC+IOlcgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovKic9+gueVbh4fO04M1oX+aAE2S1f3x4oyQpFSc+pRXYnsQClhXX56IaPpKbYuZJtl/Fo632RDoRBuO/SdIYjgNw2zhIxa+qvMYYkNlXqVa+MPhk/CUnxP4J4RBbt1BfbapF3kwdRui/xKuknsdJBVeFx5jFh7AQJRxi14+188=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BV88qyIr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BV88qyIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0241F000FF;
	Tue, 29 Sep 2026 11:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790680337;
	bh=OtKLzSVjKPRZshz2AefRxKxu1viQOmmc/Cl7ueutcPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BV88qyIrUdemgCTc7/Nc1a5HencKOCtUUeQF/4yuDOy+E9lTQJTXaqexwwEa+KENc
	 IHnvm++5OlPA7wQp78zpEfhb13SxfqeGtE8x0Tr4lJuOODJoVnitMUth71d8TyI8FL
	 qF9QPvRMYORpyuleZ9gBZ9acR1tOtNY6T0V0l2wM3DCoWKv97l9wnJfOLBz3QVXNcf
	 zuCeflofP0AyEaKrVdS0ufY5NE8KthdOm5n6A3n0TzkRrDI50QFp3WVuF5iK4VLw/2
	 /u7yd0WDEAicCMf2zjaEZ1eoZuTrAugZMtLq/8C7LYHaANp8hLzVqESeam3NBy6sPL
	 fqbmJ7n5T9GCg==
Date: Tue, 29 Sep 2026 12:11:42 +0100
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
Subject: Re: [PATCH v3 08/40] mm: add mmap action for discontiguous kernel
 page mapping
Message-ID: <aruboNztyLjlrXiG@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-8-4583d8a23bca@kernel.org>
 <CAJuCfpEawD2NUO9EoqKnR6YR59XMdYrtUrj8KEwJVwO8AOk8Lw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEawD2NUO9EoqKnR6YR59XMdYrtUrj8KEwJVwO8AOk8Lw@mail.gmail.com>

On Sun, Sep 27, 2026 at 02:44:18PM -0700, Suren Baghdasaryan wrote:
> On Thu, Sep 17, 2026 at 9:27 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:

> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index a1f2d375cf7d..2a92193ac6a5 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h

> > +static inline void
> > +discontig_kernel_map_page_range(struct discontig_kernel_page_state *state,
> > +                               struct page **page_arr, unsigned long nr_pages)
> > +{
> > +       state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
> > +       state->__page_arr = page_arr;
> > +       state->__nr_pages = nr_pages;
>
> Shouldn't we cap state->__nr_pages at state->nr_pages_remain like you
> do in discontig_kernel_map_page()?

Ack yeah good point, will do!

--
Cheers, Lorenzo
