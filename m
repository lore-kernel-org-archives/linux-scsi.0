Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1D8516162;
	Tue, 13 Oct 2026 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904443; cv=none; b=LXp4yDA38fsTFd6sHU1ylM2/qRCfwAXSK9Yuog1Kl3Q6+I8BQydNORvlEmiwVHqBGxlXA7Co5dNKbFeFC/myZLlSDDJCwbVh4DlqVr8A8N7RMYpzeWvxqak3dXKLxZq3OZZMn4Hl+g7wSXb01ffjIDPPn35q6/9H8LfyQpFwpFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904443; c=relaxed/simple;
	bh=2k7CL5BDCTQMRGPrACd5d5hU5TGkD0PVJs0dITN+1Po=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tITvpz6eaiA6bWQU3AYJb0fGzIsvp69ipzdWa3rsGcPrDe/0tZ0slRaHJIkVZNglV6ZxW2enY3LO9R8FsGcY6/T6f0j2NVIrw9C4HbCX4eBeKwylJsb5QzAriEM7n6gRzk+ZYf06Rg3lqZVOVw8uQC04GbCG3UeJL1Bk6e7A1oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EStLdfZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EStLdfZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139041F00893;
	Tue, 13 Oct 2026 15:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904441;
	bh=iWi4IxfnQiutVrp4mRJQjtOZDBSjGIMVxxtGuyoDWoA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EStLdfZ4K5E6tJVGJyXckKVNKvAC9pImHOjucLTUEe4cD2QIAMiyAP3JqubWVnqOz
	 tn5EHx04+E+T1MV2gnalX9qItGYzrsCUMEq9wnfjprZc2qwgM2FrMss3ugjuJIvr7H
	 M9XD3Kq6cBSEms0yMaPeMdl/3AX5Yv2onNx66d6bzLmdYkVM0/dy2cH2MJfBhOw5zE
	 YhqRVMV016fA68fhVoKPkeJQHbGVcUzxRjNt10VJJLWdmHBU4jEwEhMs97pKgpVNk1
	 gSXpxkeRLYDm99LW4xE386wi+j/RlKV1vamMWpsRMvMt1wAfAYvyKn5YTpXqkjHehe
	 H9HHqBtgISIbA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:55 +0100
Subject: [PATCH v6 15/39] mm/vma: add vma[_flags]_is_mm_managed()
 predicates
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-15-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5470; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2k7CL5BDCTQMRGPrACd5d5hU5TGkD0PVJs0dITN+1Po=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZwMZ1B8nauuatK06r3l9AMnFyoWmPkx7lpRv1/wa
 szm4wWaHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZgI8zFGhmMzare9X/NjW+2j
 t/wewjy2znuvbt64bOv3Mg+T2VN6LPUY/pmt9Qn/tOlwaNWK6Es/uu1+TeTnVM+MF/Z993Khwbk
 2Rg4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Rather than referring to VMA flags with uncertain meaning, add a new
predicate that explicitly describes what absence of the VMA_PFNMAP_BIT and
VMA_MIXEDMAP_BIT flags means, and then refer to that function for
determining VMA mergeability.

If neither of these flags are set, that means the contents of the mapping
are managed by core mm.

Otherwise they are instead owned by some other kernel component, usually a
driver: the memory may be MMIO, kernel-allocated pages or even ordinary
pages the driver maps itself, but core mm must not populate, reclaim,
migrate, copy-on-write or merge the range itself.

We initially also treat VMA_IO_BIT as implying a mapping is not mm-managed,
as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
on ordinary VMAs while locking them, which is addressed later in this
series.)

However the intent is to in future remove this, as no mapping should be
marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.

This forms the basis of further work intended to improve how we express VMA
properties such as this.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 53 ++++++++++++++++++++++++++++++++++++++++-
 tools/testing/vma/include/dup.h | 29 +++++++++++++++++++++-
 2 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 438ab06a4a91..df8a5a1eb9c3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,41 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that the
+ * contents of the VMA are managed by core mm?
+ * @flags: The VMA flags to test.
+ *
+ * Such a mapping is one established by a simple mmap() or brk() with no driver
+ * or other kernel component involved.
+ *
+ * They are rmappable, and core mm services rmap operations including reclaim,
+ * as well as population, CoW and merge/split (if eligible).
+ *
+ * Mappings which fail this test are those where this is not the case -
+ * e.g. MMIO, user-mapped kernel pages, udmabuf (pfnmap shmem), etc.
+ *
+ * Returns: true if the flags indicate an mm-managed mapping.
+ */
+static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				   VMA_IO_BIT);
+}
+
+/**
+ * vma_is_mm_managed() - Are the contents of @vma managed by core mm?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_mm_managed() for a description of this property.
+ *
+ * Returns: true if the VMA is mm-managed.
+ */
+static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_managed(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1620,7 +1655,23 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, mappings which are not mm-managed may have established state
+	 * upon mapping not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (!vma_flags_is_mm_managed(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }
 
 /**
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index a6a8e53c4b38..89c645a6ad60 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1665,7 +1665,34 @@ static inline bool file_is_dev_zero(const struct file *file)
 	return file && file->f_op == &zero_fops;
 }
 
+static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				   VMA_IO_BIT);
+}
+
+static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_managed(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, mappings which are not mm-managed may have established state
+	 * upon mapping not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (!vma_flags_is_mm_managed(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }

-- 
2.55.0

