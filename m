Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA7B5038F4;
	Thu, 17 Sep 2026 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662212; cv=none; b=lBIPzn4KKPJm/2DsWr2fWli7hnTuPqh7TKh/ymqWEaDqOf9iJhjsBrPlqltHQpGuipxdOXmyfZWXfrIFIsGjeXO0qhIaQeuszy1IFq1Uyoed9jFkjMKsn+PgqFBdqjQuSs+Ij1e+dFtDg/v2+YTU+QZhVhywaflCRhSzd9bQDi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662212; c=relaxed/simple;
	bh=A0IyrSZT4xnoXVzOPotdns/NyqNeSYOa+4KuZUrtgdE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LpIz4ia37caCrko5Iarr+uBJcVOs+ylr5EZi+Vm3Dnq6C6Z3KgSTckdZFrp611vLkSkVfn30tRPitKFmbgN2LfQUwROpSRRDR5NOl0qFLvHB8t3QeJd/NH/7pTbK7AXd0GYCZ20eiSiYBcEzrGk61P/fprP55hD9uIitEWElcBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAup0rG7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAup0rG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A481F00898;
	Thu, 17 Sep 2026 16:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662210;
	bh=26MzU6NoaYyq9AMWr/zmjirslmDFnQt57HQ0MnE5VMI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QAup0rG7XAXGXUl21fNI3EXukJ1aaBwX4QS1oW5nveyt5csz8DzhZZN8oP78dJB0l
	 lj1to33pPjh48GeCKQ6LLBeMJxsFlzUyhCUPwiS+n6lfSlYa1JwZiXBrj1WiHJe0Qv
	 azbjDwTRnyU2k7TuWBhmgoX1bWAmc4whsdfn0koF+NH6DNNcfke0llX2MR8LdlYTh5
	 uGv8YYv2xeVas9g7K1/HB/0Xq+FtHk3ar0uB+whuX3v1EH8RtSXHOLjWZiOi/oJRIZ
	 N50hBt/HZe2LiGrMZsiCyHmimrHEQ6PiAZr8j2BeiowjUIE+qFJ9NOyzkgwnIt2CmQ
	 rDTRKVgYCu1mQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:10 +0100
Subject: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11235; i=ljs@kernel.org;
 h=from:subject:message-id; bh=A0IyrSZT4xnoXVzOPotdns/NyqNeSYOa+4KuZUrtgdE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCO+Ljc2v2rPl5sbD77uD8nburvh5K21/Ebf2/cLJ8
 oe+cRnbdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiy88xMvyq9BQu/yIw6b6W
 g2j38R79B2w+7fVagqu1ajWLdWOPfWdk2Dy5XcTNe5dYdPkhmeLyXWLiW29M/e2jsSXn6cKyPeE
 8fAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

The map->file_doesnt_need_get flag is confusing and the existing
implementation has holes.

Drivers are permitted to change the owning file of a mapping. If they do
so, they are required to take a reference on that file.

The mmap() operation which ultimately invokes __mmap_region() is guaranteed
to drop the refcount for the original file the mapping was made under, but
this is not true for the replaced file.

This has been addressed so far by tracking map->file_doesnt_need_get, which
is rather poorly named and unfortunately fails to correctly track whether
or not an additional put were needed in a number of cases.

Make life easier by removing this flag, and instead drop the reference for
both mmap_prepare and the deprecated mmap callback in a new function
put_map().

Track whether this needs to be done by aligning mmap_state with
vm_area_desc and store the original file in the map->file field, keeping
the updated file in map->vm_file.

In order to have the same behaviour for both types of hooks, only drop the
reference __mmap_new_file_vma() itself took in its error path, deferring
the replaced file's reference to put_map().

To make this work correctly, map->vm_file has to be updated before any
error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
set this field first.

Also when mmap_prepare() changes the file and is then merged, the reference
count also must be decremented, so update the logic to call put_map() in
this case too.

Also update __compat_vma_mmap() to manually perform this step for stacked
file systems using the compatibility layer, and update
compat_set_vma_from_desc() to replace vma_set_file() with a correct
refcount/file update.

No in-tree driver is impacted by the incorrect implementation of this
currently (no driver that does this is mergeable for one), so this does not
need to be a fix.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h |  1 +
 mm/util.c     |  5 +++-
 mm/vma.c      | 83 +++++++++++++++++++++++++++++++++++------------------------
 mm/vma.h      |  6 +++--
 4 files changed, 59 insertions(+), 36 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 0dca33db068f..fe576d468af4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -7,6 +7,7 @@
 #ifndef __MM_INTERNAL_H
 #define __MM_INTERNAL_H
 
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/khugepaged.h>
 #include <linux/mm.h>
diff --git a/mm/util.c b/mm/util.c
index bf0513d1d3d0..016932780925 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
 
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
-	if (err)
+	if (err) {
+		if (desc->vm_file != vma->vm_file)
+			fput(desc->vm_file);
 		return err;
+	}
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
diff --git a/mm/vma.c b/mm/vma.c
index 55917d097933..fa784f069da4 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -24,7 +24,8 @@ struct mmap_state {
 		vm_flags_t vm_flags;
 		vma_flags_t vma_flags;
 	};
-	struct file *file;
+	struct file *file;	/* mmap()-specified file. */
+	struct file *vm_file;	/* May be updated by mmap_prepare. */
 	pgprot_t page_prot;
 
 	/* User-defined fields, perhaps updated by .mmap_prepare(). */
@@ -43,8 +44,6 @@ struct mmap_state {
 
 	/* Determine if we can check KSM flags early in mmap() logic. */
 	bool check_ksm_early :1;
-	/* If .mmap_prepare changed the file, we don't need to pin. */
-	bool file_doesnt_need_get :1;
 };
 
 #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vma_flags_, file_) \
@@ -58,6 +57,7 @@ struct mmap_state {
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
+		.vm_file = file_,					\
 		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
 	}
 
@@ -70,7 +70,7 @@ struct mmap_state {
 		.vma_flags = (map_)->vma_flags,				\
 		.pgoff = (map_)->pgoff,					\
 		.anon_pgoff = (map_)->anon_pgoff,			\
-		.file = (map_)->file,					\
+		.file = (map_)->vm_file,				\
 		.prev = (map_)->prev,					\
 		.middle = vma_,						\
 		.next = (vma_) ? NULL : (map_)->next,			\
@@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
  */
 static bool accountable_mapping(struct mmap_state *map)
 {
-	const struct file *file = map->file;
+	const struct file *file = map->vm_file;
 
 	/*
 	 * hugetlb has its own accounting separate from the core VM
@@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_munmap_struct *vms,
 
 static void update_ksm_flags(struct mmap_state *map)
 {
-	map->vma_flags = ksm_vma_flags(map->mm, map->file, map->vma_flags);
+	map->vma_flags = ksm_vma_flags(map->mm, map->vm_file, map->vma_flags);
 }
 
 static void set_desc_from_map(struct vm_area_desc *desc,
@@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_desc *desc,
 	desc->end = map->end;
 
 	desc->pgoff = map->pgoff;
-	desc->vm_file = map->file;
+	desc->vm_file = map->vm_file;
 	desc->vma_flags = map->vma_flags;
 	desc->page_prot = map->page_prot;
 }
@@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 	return 0;
 }
 
+static bool map_same_file(struct mmap_state *map)
+{
+	return map->vm_file == map->file;
+}
 
 static int __mmap_new_file_vma(struct mmap_state *map,
 			       struct vm_area_struct *vma)
@@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	struct vma_iterator *vmi = map->vmi;
 	int error;
 
-	vma->vm_file = map->file;
-	if (!map->file_doesnt_need_get)
-		get_file(map->file);
+	vma->vm_file = map->vm_file;
+	if (map_same_file(map))
+		get_file(map->vm_file);
 
-	if (!map->file->f_op->mmap)
+	if (!map->vm_file->f_op->mmap)
 		return 0;
 
 	error = mmap_file(vma->vm_file, vma);
+	map->vm_file = vma->vm_file;
+
 	if (error) {
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
-		fput(vma->vm_file);
-		vma->vm_file = NULL;
+		if (map_same_file(map))
+			fput(map->vm_file);
 
+		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
@@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
 			vma_test(vma, VMA_MAYWRITE_BIT));
 
-	map->file = vma->vm_file;
 	map->vma_flags = vma->flags;
 
 	return 0;
@@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 
 static void map_set_anon(struct mmap_state *map)
 {
-	map->file = NULL;
+	map->vm_file = NULL;
 	map->vm_ops = NULL;
 	map->pgoff = map->addr >> PAGE_SHIFT;
 }
@@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_state *map)
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	return map_is_private(map) && !map->file;
+	return map_is_private(map) && !map->vm_file;
 }
 
 /*
@@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	}
 
 	/* Invoke callbacks. */
-	if (map->file)
+	if (map->vm_file)
 		error = __mmap_new_file_vma(map, vma);
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
@@ -2797,11 +2803,15 @@ static int call_mmap_prepare(struct mmap_state *map,
 	int err;
 
 	/* Invoke the hook. */
-	err = vfs_mmap_prepare(map->file, desc);
+	err = vfs_mmap_prepare(map->vm_file, desc);
 	if (err)
 		return err;
 
-	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
+	/* Update first so file refcount tracked correctly. */
+	if (desc->vm_file != map->vm_file)
+		map->vm_file = desc->vm_file;
+
+	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
 	if (!desc->vm_ops)
 		return -EINVAL;
 
@@ -2811,10 +2821,6 @@ static int call_mmap_prepare(struct mmap_state *map,
 
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
-	if (desc->vm_file != map->file) {
-		map->file_doesnt_need_get = true;
-		map->file = desc->vm_file;
-	}
 	map->vma_flags = desc->vma_flags;
 	map->page_prot = desc->page_prot;
 	/* User-defined fields. */
@@ -2826,7 +2832,7 @@ static int call_mmap_prepare(struct mmap_state *map,
 	 * anonymous mappings. Rather than allowing these mappings to be odd
 	 * outliers, simply make them truly anonymous.
 	 */
-	if (map_is_private(map) && file_is_dev_zero(map->file))
+	if (map_is_private(map) && file_is_dev_zero(map->vm_file))
 		map_set_anon(map);
 
 	return 0;
@@ -2845,7 +2851,7 @@ static void set_vma_user_defined_fields(struct vm_area_struct *vma,
  */
 static bool can_set_ksm_flags_early(struct mmap_state *map)
 {
-	struct file *file = map->file;
+	struct file *file = map->vm_file;
 
 	/* Anonymous mappings have no driver which can change them. */
 	if (!file)
@@ -2868,6 +2874,20 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
 	return false;
 }
 
+static void put_map(struct mmap_state *map)
+{
+	/*
+	 * An error occurred or the VMA was merged.
+	 *
+	 * If the file was changed by the driver (which is required to increment
+	 * the replacement file's reference count), drop its reference count.
+	 *
+	 * On error, the caller always drops the original file regardless.
+	 */
+	if (map->vm_file && !map_same_file(map))
+		fput(map->vm_file);
+}
+
 static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vma_flags_t vma_flags,
 		unsigned long pgoff, struct list_head *uf)
@@ -2922,7 +2942,10 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 
 	__mmap_complete(&map, vma);
 
-	if (have_mmap_prepare && allocated_new) {
+	if (!allocated_new) {
+		/* Merged, so need to drop refcount. */
+		put_map(&map);
+	} else if (have_mmap_prepare) {
 		error = mmap_action_complete(vma, &desc.action,
 					     /*is_compat=*/false);
 		if (error)
@@ -2936,13 +2959,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	if (map.charged)
 		vm_unacct_memory(map.charged);
 abort_munmap:
-	/*
-	 * This indicates that .mmap_prepare has set a new file, differing from
-	 * desc->vm_file. But since we're aborting the operation, only the
-	 * original file will be cleaned up. Ensure we clean up both.
-	 */
-	if (map.file_doesnt_need_get)
-		fput(map.file);
+	put_map(&map);
 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
 	return error;
 }
diff --git a/mm/vma.h b/mm/vma.h
index e97bd2dfa786..f15faa83f3d6 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
 
 	/* Mutable fields. Populated with initial state. */
 	vma_set_pgoff(vma, desc->pgoff);
-	if (desc->vm_file != vma->vm_file)
-		vma_set_file(vma, desc->vm_file);
+	if (desc->vm_file != vma->vm_file) {
+		fput(vma->vm_file);
+		vma->vm_file = desc->vm_file;
+	}
 	vma->flags = desc->vma_flags;
 	vma->vm_page_prot = desc->page_prot;
 

-- 
2.55.0

