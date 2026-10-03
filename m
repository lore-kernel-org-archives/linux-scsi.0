Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE43306498;
	Sat,  3 Oct 2026 16:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045528; cv=none; b=oVIqEQmuHG/9WXP8l+J8EicUdeS4OykktW6k0diKAGh7wzMnVDvLZfhva14Nx+C8R5WiC2C+hplaR78gEIamnpeCfSwqKBEi0YbBAnvZYHAHaYOGQ7ydT0/mNGZkcQIjZ1ZZvLJpYta2bUkj3G184PvJBShtbUNjO6ZCm4IClPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045528; c=relaxed/simple;
	bh=mOnnFrkUWaUS1n4H4Gk7r71SXXuSIa1mWd+M4luJGNU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hQM0+mOr6nNTR6xjpPumHsioG9oLMaVa6oafCsrDUPkDk7KU7TYknSnPH8wZc1m/ke3JUoYZnj3mV8B1TwQVPZ6bJs+yjje1URnb1ySXfqQUN2ax1rJyXhCbQhUvejpTNfKqk/ElRlplt4PAZNtiJmctipWOky8vM8Wf9vFU+8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GqM3Oq5f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GqM3Oq5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2AD1F0089C;
	Sat,  3 Oct 2026 16:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045526;
	bh=UUbFGITjWY59hwibK517Un6q5CvbsJ/CBzqc0O6PG0w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GqM3Oq5fa0ezEW3LjsY1RBhCjn/Yktg5sCHb3YEQ0nPZWTtOTuR9ZhMSpDothl5L1
	 X45HTJwoTW5V3IqVwY6gptEBdNpXxzdwwCdh6r1tVAbs6DK9zeDHlav5jUzARUpGNI
	 P1UMc/+3PpP4daru4o7+L3REL2byleapWh1Wdoskrny5j/Z8GLiwh0CPGmlcy9mtNW
	 ZSfFG2PdtglfFXhzbTK3Mk3dAcZpKDMtKMqspNOSWhMsxBDMyzhNhq2AS/unDTZnYb
	 U5hHI8VX+7wlSQDEyGOiO4ckDSdnzZVWnnpF+LLpwpeney546MyYcVWjrMVWoN9R5j
	 12GOTcuZYiyQg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:47 +0100
Subject: [PATCH v4 16/38] mm/vma: add and use vma_[flags]_is_fixed_mapping
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-16-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6553; i=ljs@kernel.org;
 h=from:subject:message-id; bh=mOnnFrkUWaUS1n4H4Gk7r71SXXuSIa1mWd+M4luJGNU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mmmTV6ayK+2rTIuWHj32Z6vX/xL668YXGDfxP53n
 pVaflVzRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACayYh/DP3v1nPAHsq7P38l/
 Ztl47mX4t9OCb4u/nJGSMvhcMnnFupsM/7SE6y/fOPTD8spkycUBjW1fS2+msjc277w85VS4Mdf
 Tx1wA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

This determines whether a VMA cannot be expanded or merged because what
they mapped was determined to be a set size at mmap time.

This typically refers to mappings not managed by core mm, however
VMA_DONTEXPAND_BIT
is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
must explicitly test for this for now.

We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not be
set for VMA_PFNMAP_BIT's despite the one implying the other.

Use this predicate in vma_flags_can_merge() and in check_prep_vma() in the
mremap logic testing to see if mremap() can expand the VMA. The criteria
for khugepaged and MADV_COLLAPSE eligibility in
__thp_vma_allowable_orders() are precisely those for mergeability, so use
vma_can_merge() there (with an expanded comment).

This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.

Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
VMA_DONTEXPAND_BIT.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 39 +++++++++++++++++++++++++++++++++++----
 mm/huge_memory.c                | 11 +++++++----
 mm/mremap.c                     |  5 ++---
 tools/testing/vma/include/dup.h | 16 +++++++++++++++-
 4 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 83953757735a..6b5f06cd174a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -600,9 +600,6 @@ enum {
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 
-/* This mask prevents VMA from being scanned with khugepaged */
-#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
-
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
 
@@ -1647,6 +1644,40 @@ static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
 	return vma_flags_is_mm_managed(&vma->flags);
 }
 
+/**
+ * vma_flags_is_fixed_mapping() - Do the specified VMA flags indicate that this
+ * is a fixed mapping that cannot be expanded or merged?
+ * @flags: The VMA flags to test.
+ *
+ * Fixed mappings are those whose size is set at the point of mmap (for
+ * instance, a mapping of a fixed range of memory established by a driver),
+ * and thus cannot be expanded or merged.
+ *
+ * Returns: true if the flags indicate a fixed mapping.
+ */
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+/**
+ * vma_is_fixed_mapping() - Is this VMA a fixed mapping that cannot be
+ * expanded or merged?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_fixed_mapping() for a description of this property.
+ *
+ * Returns: true if the VMA maps a fixed mapping.
+ */
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1668,7 +1699,7 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 	if (!vma_flags_is_mm_managed(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4cd917f77f3f..87e8bf8029ab 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -212,11 +212,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 		return in_pf ? orders : 0;
 
 	/*
-	 * khugepaged special VMA and hugetlb VMA.
-	 * Must be checked after dax since some dax mappings may have
-	 * VM_MIXEDMAP set.
+	 * khugepaged moves data from VMAs once collapsed, after they have been
+	 * faulted in, relying on refaulting for file-backed memory.
+	 *
+	 * Mappings not managed by core mm cannot be reliably reconstructed from
+	 * page faults, and fixed mappings (including hugetlb) may well be
+	 * mm-managed - precisely the mappings which cannot be merged.
 	 */
-	if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
+	if (!in_pf && !smaps && !vma_can_merge(vma))
 		return 0;
 
 	/*
diff --git a/mm/mremap.c b/mm/mremap.c
index 7c368440fafe..ed19b47c2caf 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1788,8 +1788,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 		return -EINVAL;
 	}
 
-	if ((vrm->flags & MREMAP_DONTUNMAP) &&
-	    vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if ((vrm->flags & MREMAP_DONTUNMAP) && vma_is_fixed_mapping(vma))
 		return -EINVAL;
 
 	/*
@@ -1827,7 +1826,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
 		return -EINVAL;
 
-	if (vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if (vma_is_fixed_mapping(vma))
 		return -EFAULT;
 
 	if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delta))
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 89c645a6ad60..442ea9eb098d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1676,6 +1676,20 @@ static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
 	return vma_flags_is_mm_managed(&vma->flags);
 }
 
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
 	/*
@@ -1691,7 +1705,7 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 	if (!vma_flags_is_mm_managed(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;

-- 
2.55.0

