Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A61A339377;
	Sat,  3 Oct 2026 16:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045210; cv=none; b=LhglIFLJm+XvpZxT08COlbayuxzSNVF9ESNzSfh60ciAu9C+bgu6U7AbaglVqgxlqgciZuP0/2n93m6WdMddsLNEjV5xGAhA+3mPSAdk6QzM8/jpIegJrjwmMKH8DHrx997pskuuW2nYjM6e9ki5gkvm7mjXSSH8G4EDPfRhI20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045210; c=relaxed/simple;
	bh=p1e4kSJUryOEIMmHucmPnH1xL8U7oEe7fTQyV3BOt8s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YNS7Pc0dyV4VrRhX2LKbAZXegxL2uGjw07DuR82fFkmeQkwUmOQHsC/qOYwURZTMBMgyV4AQ1Up2CSaIGsoLD75HFHAPW7I5uMnoIdKR+ojw/CfvLeWthFumK6AvxNipgB5a85Eg1jkDOBOPDnztXht63nFMm9SxkivJdczAhoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHwTj6Fv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHwTj6Fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FD81F0089D;
	Sat,  3 Oct 2026 16:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045207;
	bh=Luiy6EC5G5foCZ68fFSm152TbYSyvv4kUBI03y6fwtQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MHwTj6Fvfpp10/DtoJ4BTNz4qh+0nYRXvTvo1D4t0zvsIcWJcALWRBR/ENJ+qbJ/X
	 8KbJvaMXO6QscSNWYiUvOcLoQS/wCdy+ejQgxYcYbCnoifCtKGNJLx677ieDHFBfmd
	 7LwS7GKnnDPFubBfuAb9N8b6FLoCXg+WcJCNmWfHq1sbb6Z5c9UEA6LftDSdBeW2XC
	 IyC+2m8OUkQyT9xpiusQdCZl4VjSipmeS4cMTXLwtbGYu1CRM42Grqud1Kbjfk5Ptn
	 XMBSimChF47g2jiRJCLWAkPXx43Uk3300zF16uusNhv2eNYWKABNfsGFSeGmnp5QEL
	 U/ttzGv1Oe/sQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:32 +0100
Subject: [PATCH v4 01/38] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-1-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11283; i=ljs@kernel.org;
 h=from:subject:message-id; bh=p1e4kSJUryOEIMmHucmPnH1xL8U7oEe7fTQyV3BOt8s=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6qkxmnM/YpOtVdY4/rXv8GvfBKaiGaLlge8vzGyVu
 54otlano5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNZq8Dw39ff4sytVomalY6H
 849si5fJyOownT37gLWZf6CBpcEjaYb/gboJdaEPXDg2s0hMaPLZbcNSF2J8JKvi2kXmGNlktlx
 uAA==
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
map_put_vm_file().

Track whether this needs to be done by aligning mmap_state with
vm_area_desc and store the original file in the map->file field, keeping
the updated file in map->vm_file.

In order to have the same behaviour for both types of hooks, only drop the
reference __mmap_new_file_vma() itself took in its error path, deferring
the replaced file's reference to map_put_vm_file().

To make this work correctly, map->vm_file has to be updated before any
error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
set this field first.

Also when mmap_prepare() changes the file and is then merged, the reference
count also must be decremented, so update the logic to call
map_put_vm_file() in this case too.

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
index 55917d097933..c27aea6d58d9 100644
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
 
+static void map_put_vm_file(struct mmap_state *map)
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
+		map_put_vm_file(&map);
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
+	map_put_vm_file(&map);
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

