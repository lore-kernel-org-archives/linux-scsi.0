Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE1A518138;
	Tue, 13 Oct 2026 15:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904914; cv=none; b=EfJKLvcoJkSW4N5QIZQ3AcB6tQnEsMTBojUih+TxSXlCEUvTMkNe83S8CYctG6Wm1+ptLbSvKteDcJRMAZHHEoPBfuUYV/OvxFYLt5HjMg7sf8zySfEOzEX7IP7dETTo6AuoUubFV6Y/bUp2auy4+cv+pyC8b22rogS52HjO0Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904914; c=relaxed/simple;
	bh=ZRR/0F24vpRi5Th6FPXXsoGKuQJZg1XNC+W03wHt7vE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=I12h9zb4KjpHWXnGNx12eLcLlCTEn9yNDWvUS0yBFozi9ukx+adijf0hCcr2rvcyyBkN2eQ/QlWDQQrP6yiN/fX/O5hw0B/1n3N4Qd6q1MHgwtFrZJBuBC+ZN9WzOWEoUG821higt+vvsmGnfSi5wkGtJAimLaf2Lrg4+mGZ9DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlakyKZP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlakyKZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDC51F00893;
	Tue, 13 Oct 2026 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904912;
	bh=zvi0f/x9fmZYE6ONmTuS2JnO4xSTKNre7RTsDSWIiF8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UlakyKZP5ISfZXp7qxWAW6UwPPJY6vMtdls5FLmHPfV1g6cWwL+zoSOA6ZblSTX7b
	 85K2Kx9yx0/gPnHg++Jmxd/1mdXHg6jCGVVPwSwfT4fxKW0NteAiL0cmfP8sII0f5b
	 m1Knxz4XemEkrn3BvrKZyfFSf84Ls9R8fG2W8lCOSpXz41C0CXG5M35XoZALhuu8Lb
	 MZUBMpF2S8IApgYDddYys68Qum/rloYo5tqYJCYBA87W6dgFlpfWzEouFeEvSoPleS
	 hN0pWgvcnVWOqjww0QQe5VEPBQxeUq5GLSM/ykd5YFqm7KiVDzEtsENuvwdqBBcFU1
	 +mYNbwMtoJcZw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:10 +0100
Subject: [PATCH v6 30/39] mm/vma: introduce vma[_flags]_is_mm_backed()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-30-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8850; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ZRR/0F24vpRi5Th6FPXXsoGKuQJZg1XNC+W03wHt7vE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZyZJNlynuuFP+eWv8or3v+bclzNqdzqrPnZt7tOK
 RbozAwO6yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEbMsZGZ6JWis/9T3z8EhJ
 6c4L71e0rNRuk/p0Uf++X1vs/VzeJWKMDLtjTtxxW5W++cSp1w/aXOtDuC9mXu2PvaEwf4742Zi
 QubwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
mappings which are mm-managed and whose contents were placed there by core
mm's own fault path - rather than a custom ->fault handler.

Mappings not managed by core mm do not fall into this category, as they are
populated by their owner, and nor of course does memory-mapped I/O.

We exclude fixed mappings as these have a layout core mm cannot assume
ordinary fault semantics over.

hugetlb mappings are fixed mappings, but core mm owns them entirely, so
they are explicitly carved out as mm-backed, as the MADV_DODUMP check
already does.

Use this functionality to update the madvise MADV_DODUMP check to test for
this rather than open-coding it.

Also update vma_flags_can_merge() so it is written in terms of
vma_flags_is_mm_backed() - all mm-backed mappings can be merged except
hugetlb mappings, whose flags and fields do not completely describe them.

Also update __thp_vma_allowable_orders() to use vma_is_mm_backed() rather
than testing for mergeability, which is irrelevant to this function.

This replaces the VM_SPECIAL check which means it no longer checks for
VMA_IO_BIT, however this is safe as we have established the invariant that
mm-managed mappings may not set VMA_IO_BIT, so we implicitly include
these.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 66 +++++++++++++++++++++++++++++++++++------
 mm/huge_memory.c                |  7 ++---
 mm/madvise.c                    |  7 +++--
 tools/testing/vma/include/dup.h | 44 +++++++++++++++++++++------
 4 files changed, 100 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 70fcb7e18b50..e8d2b0e847b3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1701,6 +1701,54 @@ static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
 	return vma_flags_is_fixed_mapping(&vma->flags);
 }
 
+/**
+ * vma_flags_is_mm_backed() - Do the specified VMA flags imply the mapping is
+ * backed by core mm?
+ * @flags: The VMA flags to test.
+ *
+ * An mm-backed mapping is one managed by core mm (see
+ * vma_flags_is_mm_managed()) whose contents are established by core mm's own
+ * fault path rather than a custom ->fault handler.
+ *
+ * Mappings not managed by core mm are populated by their owner, and fixed
+ * mappings may be mm-managed but have their contents established by a custom
+ * ->fault handler, so neither are mm-backed. hugetlb mappings are fixed, but
+ * core mm owns them entirely, so they are.
+ *
+ * These are the only mappings which can sensibly be merged, locked, dumped or
+ * be subject to uffd faulting, as all of these assume core mm and core mm
+ * alone manages their contents.
+ *
+ * Returns: true if the flags imply an mm-backed mapping, otherwise false.
+ */
+static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
+{
+	/* hugetlb is a fixed mapping, but core mm owns it entirely. */
+	if (vma_flags_is_hugetlb(flags))
+		return true;
+	/*
+	 * Mappings not managed by core mm are populated by their owner.
+	 *
+	 * Fixed mappings may be mm-managed, but their contents are established
+	 * by a custom ->fault handler, so core mm cannot assume ordinary fault
+	 * semantics over them.
+	 */
+	return vma_flags_is_mm_managed(flags) && !vma_flags_is_fixed_mapping(flags);
+}
+
+/**
+ * vma_is_mm_backed() - Is @vma backed by core mm?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_mm_backed() for details.
+ *
+ * Returns: true if the VMA is mm-backed, otherwise false.
+ */
+static inline bool vma_is_mm_backed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_backed(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1711,21 +1759,21 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
 	/*
 	 * VMA merging assumes that a VMA's flags and fields completely describe
-	 * its state.
+	 * its state, which is only the case for mm-backed mappings.
 	 *
-	 * However, mappings which are not mm-managed may have established state
-	 * upon mapping not embodied in any attribute of the VMA.
+	 * Mappings which are not mm-managed may have established state upon
+	 * mapping not embodied in any attribute of the VMA.
 	 *
 	 * Additionally, private (CoW) PFN maps encode the source PFN of the
 	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
 	 */
-	if (!vma_flags_is_mm_managed(flags))
-		return false;
-	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_is_fixed_mapping(flags))
+	if (!vma_flags_is_mm_backed(flags))
 		return false;
-
-	return true;
+	/*
+	 * hugetlb mappings contain per-VMA state, so their flags and fields do
+	 * not completely describe them.
+	 */
+	return !vma_flags_is_hugetlb(flags);
 }
 
 /**
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 83dd63b04568..5b295a7979cd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -215,11 +215,10 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	 * khugepaged moves data from VMAs once collapsed, after they have been
 	 * faulted in, relying on refaulting for file-backed memory.
 	 *
-	 * Mappings not managed by core mm cannot be reliably reconstructed from
-	 * page faults, and fixed mappings (including hugetlb) may well be
-	 * mm-managed - precisely the mappings which cannot be merged.
+	 * Only mm-backed mappings can be reliably reconstructed from page
+	 * faults, and hugetlb mappings cannot be collapsed.
 	 */
-	if (!in_pf && !smaps && !vma_can_merge(vma))
+	if (!in_pf && !smaps && (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma)))
 		return 0;
 
 	/*
diff --git a/mm/madvise.c b/mm/madvise.c
index 467601a8525b..3d25202db5cc 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1578,8 +1578,11 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTDUMP;
 		break;
 	case MADV_DODUMP:
-		if ((!vma_is_hugetlb(vma) && (new_flags & VM_SPECIAL)) ||
-		    (new_flags & VM_DROPPABLE))
+		/* Only mm-backed memory can be meaningfully dumped. */
+		if (!vma_is_mm_backed(vma))
+			return -EINVAL;
+		/* Core mm may discard droppable memory at any time. */
+		if (new_flags & VM_DROPPABLE)
 			return -EINVAL;
 		new_flags &= ~VM_DONTDUMP;
 		break;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 94bf818ad0e1..19ce10faa9f3 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1689,23 +1689,49 @@ static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
 	return vma_flags_is_fixed_mapping(&vma->flags);
 }
 
+static inline bool vma_flags_is_hugetlb(const vma_flags_t *flags)
+{
+	return IS_ENABLED(CONFIG_HUGETLB_PAGE) &&
+	       vma_flags_test(flags, VMA_HUGETLB_BIT);
+}
+
+static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
+{
+	/* hugetlb is a fixed mapping, but core mm owns it entirely. */
+	if (vma_flags_is_hugetlb(flags))
+		return true;
+	/*
+	 * Mappings not managed by core mm are populated by their owner.
+	 *
+	 * Fixed mappings may be mm-managed, but their contents are established
+	 * by a custom ->fault handler, so core mm cannot assume ordinary fault
+	 * semantics over them.
+	 */
+	return vma_flags_is_mm_managed(flags) && !vma_flags_is_fixed_mapping(flags);
+}
+
+static inline bool vma_is_mm_backed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_backed(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
 	/*
 	 * VMA merging assumes that a VMA's flags and fields completely describe
-	 * its state.
+	 * its state, which is only the case for mm-backed mappings.
 	 *
-	 * However, mappings which are not mm-managed may have established state
-	 * upon mapping not embodied in any attribute of the VMA.
+	 * Mappings which are not mm-managed may have established state upon
+	 * mapping not embodied in any attribute of the VMA.
 	 *
 	 * Additionally, private (CoW) PFN maps encode the source PFN of the
 	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
 	 */
-	if (!vma_flags_is_mm_managed(flags))
-		return false;
-	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_is_fixed_mapping(flags))
+	if (!vma_flags_is_mm_backed(flags))
 		return false;
-
-	return true;
+	/*
+	 * hugetlb mappings contain per-VMA state, so their flags and fields do
+	 * not completely describe them.
+	 */
+	return !vma_flags_is_hugetlb(flags);
 }

-- 
2.55.0

