Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78AB53161B;
	Tue, 13 Oct 2026 15:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904717; cv=none; b=nEuCn4d/GTeDSMfcCl4nH5pdaLDQ2G+FE8Fo3/BrPSnYRfcyofK6v2eMOAHltI835AqgYT0kZChhYHvPQ0GwrkPrc2zXDEuF1QI5EoyzyLTk+DL9lznDLT3quG0D2PjVXrq/ByJGvbQdVUZ1UzQosknINOde5pa2nNfK3xIOnck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904717; c=relaxed/simple;
	bh=Qa7/d9iVmEdKPUMRKDQqPwxH1YhZ/W/SAQvnlJMlU2c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JPV+fWlTaini9NNJR+5GLuvfZJBg3Z3SFo9uLoQ9u5rfVo3SO/mnMtznNAItWXpsh8kv7lYfoGTp8F7WqRcMK0f7M1CUDB4h6VsP7VnDt6hTFTu3xb6yxpdRUqsxpJWybKFFWeEUmlOCrvj4Rfd7jGGwWU0xmI/+8oYxnv4KjDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FdT2gUkY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FdT2gUkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0931F000FF;
	Tue, 13 Oct 2026 15:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904715;
	bh=mV+bZBkayRN5eP4bfWthEjcGHHBfXPBDQgkgo001cBw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FdT2gUkYitiwqYESIsMzJ1KqSprPcg/NK7iNvZ0fuRv6VojDC08HNQymSyiW0CNS7
	 002TZSezcWbmeuSnrKeS6I9tiW6xAsH8S6oLqzBs6Ai8tiDe9ncigf6rlbplQgokXp
	 /s43loq0hUwgH0f9sB68E/C0HRm/NGuyK0qpKuCtgXwcV1VW5C3Gbd9McIPX4Dn/30
	 cvixNFSdANC34yY1hTFwE/9jh/5ObG2/yxfk1VI4i4r5AI6ChNyJNAa3CsqYvWGpJy
	 H9cEZOn3vFvFa3+yDSqdxDW0vTx1hvczxhPBQ/i9n4nBSuf0uZPVfAJg2X4iqxgLtI
	 1ePfwtt0f6o1Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:04 +0100
Subject: [PATCH v6 24/39] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-24-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Xu Xin <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8395; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Qa7/d9iVmEdKPUMRKDQqPwxH1YhZ/W/SAQvnlJMlU2c=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZzOtfuZKuq5MPhjU+EugfjMum1cJRcPzFXjOvhwg
 fC+e5/CO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRR1UM/xR+rLyeVJr5+vmx
 f42KD0P2/P/Bq9mZzdJdHKYSx/vAfjPD/1znDvlq1cSEP5Ncn9+f2vH00NZ+rxanKKXej8G3vm3
 k4wAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
solely to fix a race with migration which might otherwise double-count
mlock VMAs.

This is unnecessary - at the point of applying folio mlock state, whether
setting or clearing PG_mlocked, we know whether or not we are locking.

Solve this in two ways - thread a boolean through the page table walk
indicating whether a lock or unlock is being performed, and run a locking
walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.

This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
VMA_LOCKED_BIT. These are also always cleared together.

Then, update folio_add_lru_vma() and mlock_folio() to check only for
VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_MASK
instead.

Also remove the useless invocation of allow_mlock_munlock() which simply
returns true if unlocking and instead rename it to allow_mlock() and only
call it when locking.

With the other mlock abuse of VMA_IO_BIT addressed, update
mlock_vma_folio() and folio_add_lru_vma() to simply test for
VMA_LOCKED_BIT.

The munlock_vma_folio() function tests VMA_LOCKED_MASK instead, as an
unmap racing with the locking walk must still munlock folios the walk has
already counted.

Additionally, in order to ensure a racing unmap/migration releases the
reference munlock_folio() took (whose put was batched), check
VMA_LOCKED_MASK before calling mlock_drain_local() in try_to_unmap_one()
and try_to_migrate_one().

While here, also replace some deprecated VMA flag predicates.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/folio.c    |  2 +-
 mm/internal.h | 10 +++++++---
 mm/mlock.c    | 51 +++++++++++++++++++--------------------------------
 mm/rmap.c     |  8 +++++---
 4 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 47a437e0f7fd..35e242b48870 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
 {
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_new_folio(folio);
 	else
 		folio_add_lru(folio);
diff --git a/mm/internal.h b/mm/internal.h
index 4ae08fedffff..ea8fa94ebe1b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -970,8 +970,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/* The VM_IO check prevents migration from double-counting during mlock. */
-	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_folio(folio);
 }
 
@@ -988,7 +987,12 @@ static inline void munlock_vma_folio(struct folio *folio,
 	 * always munlock the folio and page reclaim will correct it
 	 * if it's wrong.
 	 */
-	if (unlikely(vma->vm_flags & VM_LOCKED))
+	/*
+	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+	 * mlock_vma_pages_range(). An unmap racing with the walk must still
+	 * munlock folios the walk has already counted.
+	 */
+	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
 		munlock_folio(folio);
 }
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 39215a3eab1f..4235a1518fc9 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -316,22 +316,10 @@ static inline unsigned int folio_mlock_step(struct folio *folio,
 	return folio_pte_batch(folio, pte, ptent, count);
 }
 
-static inline bool allow_mlock_munlock(struct folio *folio,
+static inline bool allow_mlock(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, unsigned int step)
 {
-	/*
-	 * For unlock, allow munlock large folio which is partially
-	 * mapped to VMA. As it's possible that large folio is
-	 * mlocked and VMA is split later.
-	 *
-	 * During memory pressure, such kind of large folio can
-	 * be split. And the pages are not in VM_LOCKed VMA
-	 * can be reclaimed.
-	 */
-	if (!vma_test(vma, VMA_LOCKED_BIT))
-		return true;
-
 	/* folio_within_range() cannot take KSM, but any small folio is OK */
 	if (!folio_test_large(folio))
 		return true;
@@ -352,6 +340,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 
 {
 	struct vm_area_struct *vma = walk->vma;
+	const bool lock = walk->private;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte;
 	pte_t ptent;
@@ -368,7 +357,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 		folio = pmd_folio(*pmd);
 		if (folio_is_zone_device(folio))
 			goto out;
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -390,10 +379,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 			continue;
 
 		step = folio_mlock_step(folio, pte, addr, end);
-		if (!allow_mlock_munlock(folio, vma, start, end, step))
+		if (lock && !allow_mlock(folio, vma, start, end, step))
 			goto next_entry;
 
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 		.pmd_entry = mlock_pte_range,
 		.walk_lock = PGWALK_WRLOCK_VERIFY,
 	};
+	const bool lock = vma_flags_test(new_vma_flags, VMA_LOCKED_BIT);
+	vma_flags_t walk_flags = *new_vma_flags;
 
 	/*
-	 * There is a slight chance that concurrent page migration,
-	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
-	 * will call mlock_vma_folio() and raise page's mlock_count:
-	 * double counting, leaving the page unevictable indefinitely.
-	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
-	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
-	 * mmap_lock is held in write mode here, so this weird
-	 * combination should not be visible to other mmap_lock users;
-	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
+	 * LOCKONFAULT without LOCKED never otherwise occurs: it marks a walk in
+	 * progress so that rmap-side callers, which test VMA_LOCKED_BIT, do not
+	 * count folios, while try_to_unmap_one(), which tests VMA_LOCKED_MASK,
+	 * still refuses to unmap them.
 	 */
-	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
-		vma_flags_set(new_vma_flags, VMA_IO_BIT);
+	if (lock) {
+		vma_flags_clear(&walk_flags, VMA_LOCKED_BIT);
+		vma_flags_set(&walk_flags, VMA_LOCKONFAULT_BIT);
+	}
+
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, new_vma_flags);
+	vma_flags_reset_once(vma, &walk_flags);
 
 	lru_add_drain();
-	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
 	lru_add_drain();
 
-	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
-		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
+	if (lock)
 		vma_flags_reset_once(vma, new_vma_flags);
-	}
 }
 
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index 5332c52909be..b4a4b3929044 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2239,9 +2239,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
+		 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+		 * mlock_vma_pages_range().
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
-		    (vma->vm_flags & VM_LOCKED)) {
+		    vma_test_any_mask(vma, VMA_LOCKED_MASK)) {
 			ptes++;
 
 			/*
@@ -2395,7 +2397,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 finish_unmap:
 		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
 
@@ -2770,7 +2772,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			hugetlb_remove_rmap(folio);
 		else
 			folio_remove_rmap_pte(folio, subpage, vma);
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();
 		folio_put(folio);
 	}

-- 
2.55.0

