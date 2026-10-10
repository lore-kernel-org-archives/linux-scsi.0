Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DD91A683D;
	Sat, 10 Oct 2026 22:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791669627; cv=none; b=pvoSx4+58RJt/pZ3LW/aDh8aVfcXnvuIsCVf4SMHeUqU03UIF60qOlHr2fBnANy53S5xaYPwrwCaK9vVXDrbYfWO5AZ3riFu3LwKYe/ymIgpa8AJsQtPAcajJPMkUj30jqmLPhKLkSP4AthoXZGWHZoifKuhq5mOzXwjoAht/Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791669627; c=relaxed/simple;
	bh=uTIIgXvNGRKidYtT9y9d/j9O/uWBWM1pGuwQpiO4cmw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=LxMbN4FMd8LTIFjiPea+nzZKCbl9pWue4MSjHuNEHXw8edbBTn5aa++6NGrRpEtSCEfwX13SoWeZ2wNQ3RrWp5xUIhhJ+2XPHi7ITvpMZa1z5TZgNagyttUk0wpBrTgKFuexBZfsUQWi2ziBmDZ6ZWxse3V+cxAJqVpfdWWVHLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ffP+TPLt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ffP+TPLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AADC1F000FF;
	Sat, 10 Oct 2026 22:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791669625;
	bh=N2jYfqmPt2es1xuCkTol8NOahRHgRnTcTOUiwhGzkTU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ffP+TPLt1hBG2zdntJGpA4a6eo1Kktyl63gUdmTPWoDV5PB8j6QZDH7O5pu6DND18
	 83jrFOWryJ2h63yrCPBw+Uh9wavAQ633twrY1q8Eu4fcsINr1B1dFygd9ev9/B+B/N
	 PiED0VbjIV4o5yPrrgsINTWJg6/2ZfXlko4ls4sM=
Date: Sat, 10 Oct 2026 15:00:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dennis Dalessandro
 <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela
 <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya
 Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert
 <dgilbert@interlog.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, Helge Deller
 <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann
 <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan
 Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul
 Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Chris
 Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chengming
 Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, Miklos
 Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org,
 selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, Bert
 Karwatzki <spasswolf@web.de>, Takashi Iwai <tiwai@suse.de>, Emil Tsalapatis
 <emil@etsalapatis.com>
Subject: Re: [PATCH v5 00/38] mm: make VMA flag semantics explicit,
 eliminate VM_SPECIAL
Message-Id: <20261010150020.cbd6ce3038e3b6d72e2c92c9@linux-foundation.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 09 Oct 2026 19:03:54 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> properties:
> 
> * Is this managed by core mm, or by a driver mapping MMIO, kernel-allocated
>   pages, or even ordinary pages itself?
> * Can it be expanded or merged?
> * Is this a 'weird' case like mlock where migration might race and we
>   'have' to set invalid flags to notify?
> * Is it another 'weird' case where we just want to stop GUP from touching
>   it?
> 
> Driver writers have often been confused about this, and who can blame them?
> 
> It also interacts badly with the eternal edgecase known as hugetlb - which
> sets VMA_DONTEXPAND_BIT but doesn't also want to be treated like a
> 'special' flag.
> 
> Another issue is that we cannot make sensible assumptions about flag
> use. It's not possible to assume VMA_IO_BIT means iommu because drivers
> abuse it and mlock abuses it.
> 
> Special is also an overloaded term in mm. VDSO and VVAR mappings are also
> called 'special' but they're special in a... special way.
> 
> Sometimes things are called special that are a subset of
> VMA_SPECIAL_FLAGS (VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT for instance when it
> comes to zapping or vm_normal_folio()).
> 
> There's a specific kind of special for THP too, which considers
> PFN map, mixed map 'special' but DAX not.
> 
> It's all rather a mess.
> 
> This series brings some order to things by both limiting what drivers can
> do with VMA flags and switching to using predicates that describe
> behaviour, not arbitrary flags.

Thanks, I've updated mm-unstable to this version.

For some reason, new versions of this series aren't applying when I
drop the new series in place of the old.  I made the same old bunch of
reject-fixups, so the below interdiff will show if I messed any of them up.

> v5:
> * Applied tags (thanks everybody!)
> * Updated 3/38 to fix a bug in __mmap_new_file_vma() by zapping + closing
>   the VMA before setting vma->vm_file NULL to avoid an i_mmap_writable
>   imbalance. A repro was tested before/after and confirmed fixed.
> * Updated 7/38 to make __map_kernel_pages_prepare() use
>   mmap_assert_write_locked() rather than the weird
>   assert-on-mmap_read_trylock() pattern, as per Suren.
> * Also update vm_insert_page(), vm_insert_pages() to fix the same pattern
>   and to use the new VMA API, and converted a BUG_ON to a
>   VM_WARN_ON_ONCE().

Here's how v5 altered mm.git:

 mm/memory.c                       |   20 +++++++++++---------
 mm/vma.c                          |   16 ++++++++--------
 tools/testing/vma/include/stubs.h |    4 ++++
 3 files changed, 23 insertions(+), 17 deletions(-)

--- a/mm/memory.c~b
+++ a/mm/memory.c
@@ -2611,10 +2611,11 @@ int vm_insert_pages(struct vm_area_struc
 
 	if (!range_in_vma(vma, addr, end))
 		return -EFAULT;
-	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
-		VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
-		vm_flags_set(vma, VM_MIXEDMAP);
+	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
 	}
 	/* Defer page refcount checking till we're about to map that page. */
 	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
@@ -2626,7 +2627,7 @@ static void __map_kernel_pages_prepare(s
 	if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
 		return;
 
-	VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
+	mmap_assert_write_locked(desc->mm);
 	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
 	vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
 }
@@ -2785,10 +2786,11 @@ int vm_insert_page(struct vm_area_struct
 {
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		BUG_ON(mmap_read_trylock(vma->vm_mm));
-		BUG_ON(vma->vm_flags & VM_PFNMAP);
-		vm_flags_set(vma, VM_MIXEDMAP);
+	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
 	}
 	return insert_page(vma, addr, page, vma->vm_page_prot, false);
 }
--- a/mm/vma.c~b
+++ a/mm/vma.c
@@ -2631,21 +2631,21 @@ static int __mmap_new_file_vma(struct mm
 	map->vm_file = vma->vm_file;
 
 	if (error) {
-		struct file *file = vma->vm_file;
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
 
+		if (vma->vm_ops->close) {
+			zap_vma(vma);
+			/* Safe, because VMA zapped. */
+			vma_close(vma);
+		}
+		if (map_same_file(map))
+			fput(map->vm_file);
+
 		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
-		vma->vm_file = file;
-		/* Only safe once unmapped. */
-		vma_close(vma);
-
-		if (map_same_file(map))
-			fput(map->vm_file);
-		vma->vm_file = NULL;
 		return error;
 	}
 
--- a/tools/testing/vma/include/stubs.h~b
+++ a/tools/testing/vma/include/stubs.h
@@ -329,6 +329,10 @@ static inline void vma_close(struct vm_a
 {
 }
 
+static inline void zap_vma(struct vm_area_struct *vma)
+{
+}
+
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
 	return 0;
_

