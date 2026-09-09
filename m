Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE7D3002B9;
	Wed,  9 Sep 2026 07:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788939485; cv=none; b=LPpDvO14P9dvovPn8DBpbgZboEWgWseOh56r4Yl3HRsELiuo6wI5iGUvzvwyG7C2cybqA2tGiUKe2XyOvDNn17v21zvSMlnoP/DWtW19w+kjr4mq8hfcJYaeIMQkZuEmjQKtYsjAJRIVumrnWTQ1eFr4PDHQJUlqspWXIOWdwrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788939485; c=relaxed/simple;
	bh=nTAm35845aAqmOQtS6HyRYHkKn+bOdSMAV3QF5uJvY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZdQmzFnen4pGM4M62lN7CkOLWz1/1MCEJEt2hgKO7FlRi4xKC9STZLFtV+TYQNNzy6w4guOP7Nnf0JOeDgs+Fl7UJqdo2lV+8wa+WPR92q+n7cn+23HaVocVKLhTHI0KyyiHyqIHIp0yxOlO+SUikaYa/YdguoVldsNeaQK4tos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMvwOMtK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMvwOMtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8484C1F00A3A;
	Wed,  9 Sep 2026 07:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788939483;
	bh=z7WoiQ3kTHyw/Ii8U53W3jB43VLKD3M/+zE0Et0v4Dk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fMvwOMtKjnQJHWqbGOBFRkxLXNBsibipPgj2Q6P064WQJWMW7wfdq4gqVuVvBLOBi
	 mw2LdSGq7nWqdIa6eYDVqIpvJUSLUA2zonOikKUX6K36rwbteoOJo/Gwa7LLNDfbhI
	 EHt9w7bjV4yHdhIGfrHtCRftSsoS+o6rrCDY1usY=
Date: Wed, 9 Sep 2026 09:37:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>,
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org,
	selinux@vger.kernel.org, linux-sound@vger.kernel.org,
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH 09/39] drivers/usb/mon: update to use mmap_prepare + map
 kernel pages
Message-ID: <2026090947-daycare-gentleman-9796@gregkh>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-9-dacf19cce22b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-9-dacf19cce22b@kernel.org>

On Tue, Sep 08, 2026 at 09:01:13PM +0100, Lorenzo Stoakes (ARM) wrote:
> Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
> part of this change, additionally take the approach of mapping pages upon
> mmap rather than providing a fault handler.
> 
> The page span cannot be mutated when an mmap mapping is in place, so this
> is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
> -EBUSY if it's attempted, gated by the rp->mmap_active reference count).
> 
> Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to do
> this, which allows for iteration over pages in mon_bin_discontig_get().
> 
> mon_bin_discontig_init() increments the rp->mmap_active reference count to
> stabilise page spans. Should an error arise the core unmaps the VMA and
> mon_bin_vma_close() drops the reference again.
> 
> The vm_ops->close hook implemented in mon_bin_vma_close() will ensure
> correct reference count arithmetic upon unmap (with mon_bin_vma_open()
> accounting for splitting).
> 
> The existing semantics are all retained, including not mapping past the
> range of available pages, with a SIGBUS being raised in a userland process
> that attempts to access past this point.
> 
> Ultimately insert_page() is invoked to insert each page, which increments
> the reference count on each mapped page. This mimics what was being done
> previously, only we pre-map the entire range rather than doing so on
> demand.
> 
> The existing fault handler did nothing that required demand paging, and was
> presumably implemented this way due for historic reasons.
> 
> One behavioural difference: pages are no longer faulted in on demand, so a
> page discarded with MADV_DONTNEED is not repopulated and a subsequent
> access raises SIGBUS, as with other pre-populated kernel mappings.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
