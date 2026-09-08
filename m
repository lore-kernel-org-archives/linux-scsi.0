Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461723ACEE1;
	Tue,  8 Sep 2026 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788898835; cv=none; b=U7OhI0sn9m/yuqiKGTY2szBOwEjR1fNlBBvrjBY46qj42L+PYgd7xfjiWsvidE1lZpuB6lmr/+lumPa/lXqxJXmfnMJyW8lIyTUZP8KL7X2XZJcKRwk+xjaC/WFLJxi4LkqtwC62L/UN3npQrRSVXQ0YpTW+72Cj4BO0BGSOG/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788898835; c=relaxed/simple;
	bh=eRGK0143iN6Vv+TT1St3Vl71ux9hqcMzpEC9J57eqcY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s54k7d9xNBJSTlHncI73U0Xej6VBSbAB8tYePlvXGV0khc3Ri3+UHp1YKof/fUuyuaCdGNBGg/vrnsBKPnCFWDb1/D/CNHCedavu0+RKOuun3L6KCQjefTwONcJ9xNGaLA7EiI7EPdT0YQzWWdtDp76kXHqKMbobzyBhNJp8p8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eteeMNKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eteeMNKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D361F00A3A;
	Tue,  8 Sep 2026 20:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898834;
	bh=6Y+9oL/ecFCyRQAjQwMJw2Dhtd7MvaAf0ZcM9wqOIa0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eteeMNKc3bw5QkqTCjME8KE/Uo8s2RLyCENbyObJd2//uesYBzeHpd/cO37Et3mhn
	 thzmodv6/i2aGrGFSbw89amq+CWgseY/mmVtI0zmwvdreMnFrCbwqLNlue7sPdj1R7
	 Z34dWA2QwPoLDzixr3Eiz6+B4srecPcGlaJqf9wWYAfMosuMrbyKnTPTVnpq2XrCWo
	 bRGY31fGM141IHku+T4a34VBQe4FOHg1Rnf/hbwasgK2dPjZk3Ny60O/wZyZiUoop5
	 UeUj7G663kAFRujAPTaMXvmzB0Beg6DqPVIImfITZf6U8YRqwZGceyJzNvetmoKRbr
	 ul2q/MJvHIHkg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:42 +0100
Subject: [PATCH 38/39] mm/huge_memory: remove vma_is_special_huge()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-38-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
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
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
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
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2897; i=ljs@kernel.org;
 h=from:subject:message-id; bh=eRGK0143iN6Vv+TT1St3Vl71ux9hqcMzpEC9J57eqcY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG7XWRi9RuG+pETo53V7Fhdk3mF2NtrLvDrokHWNq
 NkU90eLOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRroMM//0Lq+dITJUQzZ7w
 8MIdjYzvs/MkOc1yJn7osrnqlWQ/153hn4Ly5Es+Rp7THqc8Xm6hUqr3uH2hKr/mvG1pfRI7V7w
 J5AYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is a kernel-owned mapping),
but with a DAX carve-out.

DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no longer
required.

Therefore test for vma_is_kernel_owned() instead and also drop the
VMA_IO_BIT check, as it is now redundant since it is enforced that only
kernel-owned mappings can set this flag.

This also eliminates another overloaded use of 'special' within mm.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index cf6c50e531f5..1ec1cd970ce6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -110,14 +110,6 @@ static inline bool file_thp_enabled(const struct vm_area_struct *vma)
 	return S_ISREG(inode->i_mode);
 }
 
-/* If returns true, we are unable to access the VMA's folios. */
-static bool vma_is_special_huge(const struct vm_area_struct *vma)
-{
-	if (vma_is_dax(vma))
-		return false;
-	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
-}
-
 static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
 		enum tva_type type)
 {
@@ -192,7 +184,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
 		supported_orders = THP_ORDERS_ALL_ANON;
-	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
+	else if (vma_is_dax(vma) || vma_is_kernel_owned(vma))
 		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
@@ -3065,7 +3057,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (vma_is_special_huge(vma)) {
+	if (vma_is_kernel_owned(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -3221,7 +3213,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (vma_is_special_huge(vma))
+		if (vma_is_kernel_owned(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4750,9 +4742,7 @@ static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
 {
 	if (vma_is_dax(vma))
 		return true;
-	if (vma_is_special_huge(vma))
-		return true;
-	if (vma_test(vma, VMA_IO_BIT))
+	if (vma_is_kernel_owned(vma))
 		return true;
 	if (vma_is_hugetlb(vma))
 		return true;

-- 
2.55.0

