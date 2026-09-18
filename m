Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE1A2ED16D;
	Fri, 18 Sep 2026 14:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789741824; cv=none; b=Q6/GFD5YBVHoqHR+rgtyeJ6Q/KfqjF5SzXDqRtF5WEjsnC5RFzXOVB9Fckl5N2XeI8/zyQKmnIpPY2G/SaXEqJgL4EFtZN+PyqSeFon3PwYCgpDB9A8JXP1jRcZFjj/UPk8f6YtBS3sfBDvgfDpjThvVPToZyBgeg69+EhI+fQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789741824; c=relaxed/simple;
	bh=5OmomeRB+LD60RpaKuchulaB8gm1HL/uXNHI8PnXFlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nh7QxUIPSD3n3M5khRT+IaAJvQfkjtgQqgGvEPzZSRTOIWBAOxxl/I4S2x8KtGG3pAn3Feczc6jdUnmQeRjyxnTiHmldnrMK15wK1E32mL8qVDl85cU6VIPpoCBOVsu9r7GQBkuU1Vw40YdHh3xBoduKLVSFs0oHBGC0FjWyoy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=clSyf51X; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="clSyf51X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z8DxBDctfQle4qPyCLsPEBU1oRIWLoRdyUpwbsFqYLE=; b=clSyf51XrV8aRcbTvneX3p6wBa
	n2dJgPOcz894gpJOnZdCOcF3UEXESwNBxWownSVKd57lnJYBBwn8UK22mY+Uu9cTVCm4bYkkLdbb9
	zwnoTjkKMM6lYQMFHN/pynLhjEOj2/5EEiCk+CstXFpuvTmB28MRP3Fdyl1b9KhwvkjSzoEaggt5r
	4zu+cgayQfsFLqmqeLGe7kyw0337RIawLytCxdWbLSsC8OhbmfdiwFeLxFGinxIHnQj3tRZJIvubH
	Z5p2yU1Pjs4x4ZBAOVPASiIaB3Jla/kGk5xR5Btk7PaRjSjDUhmPE8iOfBuqPX68vAPFbXjRIpG5J
	q2qapdRg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7Za9-006nCZ-3B;
	Fri, 18 Sep 2026 14:28:54 +0000
Date: Fri, 18 Sep 2026 07:28:33 -0700
From: Breno Leitao <leitao@debian.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
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
Subject: Re: [PATCH v2 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <aq1KeFmXBIEd2YhQ@gmail.com>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-1-7d9781ed5361@kernel.org>
 <aquz9Z9JrK_H_E0g@kernel.org>
 <aq01JFp8hRReyY-O@gmail.com>
 <aq06hcheI4OGi_3A@gremlin>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq06hcheI4OGi_3A@gremlin>
X-Debian-User: leitao

On Fri, Sep 18, 2026 at 02:20:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Sep 18, 2026 at 05:57:51AM -0700, Breno Leitao wrote:
> > On Thu, Sep 17, 2026 at 12:33:41PM +0300, Mike Rapoport wrote:
> > > On Mon, Sep 14, 2026 at 03:57:21PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > The map->file_doesnt_need_get flag is confusing and the existing
> > > > implementation has holes.
> > > >
> > > > Drivers are permitted to change the owning file of a mapping. If they do
> > > > so, they are required to take a reference on that file.
> > > >
> > > > The mmap() operation which ultimately invokes __mmap_region() is guaranteed
> > > > to drop the refcount for the original file the mapping was made under, but
> > > > this is not true for the replaced file.
> > > >
> > > > This has been addressed so far by tracking map->file_doesnt_need_get, which
> > > > is rather poorly named and unfortunately fails to correctly track whether
> > > > or not an additional put were needed in a number of cases.
> > > >
> > > > Make life easier by removing this flag, and instead drop the reference for
> > > > both mmap_prepare and the deprecated mmap callback in a new function
> > > > put_map().
> > > >
> > > > Track whether this needs to be done by aligning mmap_state with
> > > > vm_area_desc and store the original file in the map->file field, keeping
> > > > the updated file in map->vm_file.
> > > >
> > > > In order to have the same behaviour for both types of hooks, only drop the
> > > > reference __mmap_new_file_vma() itself took in its error path, deferring
> > > > the replaced file's reference to put_map().
> > > >
> > > > To make this work correctly, map->vm_file has to be updated before any
> > > > error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
> > > > set this field first.
> > > >
> > > > Also when mmap_prepare() changes the file and is then merged, the reference
> > > > count also must be decremented, so update the logic to call put_map() in
> > > > this case too.
> > > >
> > > > Also update __compat_vma_mmap() to manually perform this step for stacked
> > > > file systems using the compatibility layer, and update
> > > > compat_set_vma_from_desc() to replace vma_set_file() with a correct
> > > > refcount/file update.
> > > >
> > > > No in-tree driver is impacted by the incorrect implementation of this
> > > > currently (no driver that does this is mergeable for one), so this does not
> > > > need to be a fix.
> > >
> > > But the patch iteslf needs to be fixed :)
> > >
> > > It seems to be the change that broke the CI.
> > >
> > > The rest is from LLM, take it with a grain of salt :)
> > >
> > > mm-ci mm-unstable red build - bisect analysis
> > > ==============================================
> > >
> > > Bad commit: 2a937a04babf1 "mm/vma: fix mmap_prepare file handling, remove
> > > file_doesnt_need_get" - first patch of Lorenzo Stoakes' 40-patch series
> > > "mm: make VMA flag semantics explicit, eliminate VM_SPECIAL" (v2).
> > > https://lore.kernel.org/all/20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org
> > >
> > > Symptom: tools/testing/selftests/mm/pfnmap.c triggers
> > > "BUG: Bad page map in process pfnmap" during __zap_vma_range()/vm_normal_page(),
> > > seen on process exit/munmap. CI's run-mm-selftests.sh greps guest dmesg for
> > > BUG|WARNING and fails the job regardless of the test's own exit code.
> >
> > I am seeing something similar here and stress-ng can reproduce it:
> >
> >       WARNING: mm/memory.c:3225 at do_remap_pfn_range+0x9b4/0x9f0, CPU#25: stress-ng-dev/354858
> >       Call trace:
> >        do_remap_pfn_range+0x9b4/0x9f0 (P)
> >        remap_pfn_range_complete+0xac/0xd0
> >        mmap_action_complete+0xcc/0x3d8
> >        mmap_region+0xb54/0x1978
> >        do_mmap+0x588/0xb18
> >        vm_mmap_pgoff+0x1e4/0x320
> >        ksys_mmap_pgoff+0x2d8/0x510
> >        __arm64_sys_mmap+0x100/0x128
> >
> >       BUG: Bad page map in process stress-ng-dev  pte:0160000000000fcf
> >       addr:0000ffe8d9080000 vm_flags:00000071 anon_vma:0000000000000000 mapping:ffff0000a0c4ea98 index:0 (file) ffe8d9080 (anon)
> >       file:mem fault:0x0 mmap:0x0 mmap_prepare: mmap_mem_prepare read_folio:0x0
> >       Call trace:
> >        print_bad_page_map+0x63c/0x740
> >        vm_normal_page+0x228/0x240
> >        __zap_vma_range+0xbe0/0x34a0
> >        unmap_vmas+0x240/0x318
> >        unmap_region+0x12c/0x238
> >        vms_complete_munmap_vmas+0x318/0x958
> >        do_vmi_align_munmap+0x254/0x2f8
> >        do_vmi_munmap+0xc4/0xf8
> >        __vm_munmap+0x174/0x288
> >        __arm64_sys_munmap+0x70/0x90
> 
> Yup I already fixed it and respun the series :)
> 
> https://lore.kernel.org/all/20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org/

Very nice, thanks. I will give it a try!
