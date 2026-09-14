Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A849489FA3;
	Mon, 14 Sep 2026 15:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789398771; cv=none; b=SENgEo7rRBwGz+zCwUHdwBPpLnjsaeaFw3eYyqL2Hh33kuIyxXtr1fKDWsoqj3/OFPEeeOM9Dhp/KhYcbzqsdTFY8n58lW7Pi3CJBywYtA5uWUx5RhW49n6u93lk23nBRFAn2txytYPfhOW6v7SFRNSUtVMaM/5vKaHaj8qsUvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789398771; c=relaxed/simple;
	bh=2GAQjO/s/Bk0fyt5AOQ4Ez3Tt7coS55V2FI+CqksX6E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cUA3ucZUPqd59R/wBBZiBSWkgHe0XRBR1CTQ7cSSpi+UvMLjOq+t1RapwD/6AbIoQjf23cUtZ16MNbxr9HhQXns9iVp5tZiJhBhOO7dm2J7qDKSvWqyn6GEs//NsRaw6egtKVZQaNgWP+o7vb0KiU+jVB6Zd5DhK9vD+eRRkSdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFlaAQin; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFlaAQin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048671F00893;
	Mon, 14 Sep 2026 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398769;
	bh=tN13W6jwJWnvYLjX7TO8ZRd5JDwmaJZiUPNzCgrQU0E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jFlaAQin+oAtoOa1M4DSIw9dAIP1iSZp2pLTn+auqN0GfEe/JXNztKg+WFdsuRXfI
	 OUTf1CRcPeeG0tlNXiyIn+ZRVBA3x7SlMgG8LtvwO5vUMvTfQI4bBiWBDGu07spVOD
	 e7GAN02gmQHUG23bXpH6nR0nzNnP0g/RoYb84GuB3Jk5EPN4xZtGjiUrTZfUrFDUqJ
	 kkuAbhmPIfk9VWrrttWwXpUM5QybzXe5cyFv2kPQ2BVvWg772oGhx4ttklCTr0HF87
	 27T/S546CBgS/61ZqCKpm/cYHyWDlc8cN/7UD4xGKx1IrSSIaGX5F/ymgfh5m8Vujg
	 l+3f9hpvKA0dw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:49 +0100
Subject: [PATCH v2 29/40] mm: drop some redundant checks around hugetlb
 VMAs
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-29-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2730; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2GAQjO/s/Bk0fyt5AOQ4Ez3Tt7coS55V2FI+CqksX6E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG8y9Upv+BalpReh8y7L8R+HfP1fb9OdlmuZmH81p
 en+ufO0o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNZWcTI8ML48+2lyXeydx9e
 6+7IyxZnVHwvST++88aidzfFfmhPX8nI0CY7MX4J7wnG2+f2mn++Ze5/7dKk/PiaX+uq/rOVF1h
 OYgQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Adjust code which inadvertently perform redundant checks on hugetlb VMAs
and clean them up:

* hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
  suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
  the series, once VMA_SPECIAL_FLAGS is removed.)

* hugetlb VMAs unconditionally set vma->vm_ops, so they are never
  anonymous.

* hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundant.

While we're here also drop a VM_BUG_ON() which the simplified check above
makes unreachable, and use the new VMA flag API.

No functional change intended.

Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/kvm/mmu.c         | 4 +---
 drivers/gpu/drm/drm_gpusvm.c | 3 +--
 mm/migrate_device.c          | 4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a7968f8d24bf..3c1240ffc38d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1463,14 +1463,12 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
 {
 	unsigned long pa;
 
-	if (vma_is_hugetlb(vma) && !(vma->vm_flags & VM_PFNMAP))
+	if (vma_is_hugetlb(vma))
 		return huge_page_shift(hstate_vma(vma));
 
 	if (!(vma->vm_flags & VM_PFNMAP))
 		return PAGE_SHIFT;
 
-	VM_BUG_ON(vma_is_hugetlb(vma));
-
 	pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
 
 #ifndef __PAGETABLE_PMD_FOLDED
diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index a1d4989b0b61..fab34fea99c2 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1141,8 +1141,7 @@ drm_gpusvm_range_find_or_insert(struct drm_gpusvm *gpusvm,
 	 * limitations. If/when migrate_vma_* add more support, this logic will
 	 * have to change.
 	 */
-	migrate_devmem = ctx->devmem_possible &&
-		vma_is_anonymous(vas) && !vma_is_hugetlb(vas);
+	migrate_devmem = ctx->devmem_possible && vma_is_anonymous(vas);
 
 	chunk_size = drm_gpusvm_range_chunk_size(gpusvm, notifier, vas,
 						 fault_addr, gpuva_start,
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index c38cbaaef5a4..b9c453c28795 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -743,8 +743,8 @@ int migrate_vma_setup(struct migrate_vma *args)
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_is_hugetlb(args->vma) ||
-	    (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
+	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
+	    vma_is_dax(args->vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;

-- 
2.55.0

