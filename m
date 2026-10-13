Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EC150AC3A;
	Tue, 13 Oct 2026 15:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904045; cv=none; b=YNQWwposrE1pKHDobp+wmqq/LRsTp4esGTohMZbiDepC2E1HX/TW+dnGlic9K3Fok/QiakGgaUtzBmWqBpbd4k3ST2t6WSSglguptiY9B597ZE9PU1RvYxYMFHvsi/0VlbjGw4wGJqBnl4Qob3M2bsMwY+fRJWYiCOYMevzG/FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904045; c=relaxed/simple;
	bh=EYqw+AtDKpEde3pCckMQkm9HGGlkplYL0cvv0S5EwV8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fIKmgiZ7GM2hnJpxViZvn5+jj02jAxYhmiydNVwc3fQV1IIFLOWRlfk/6JRIKBI/xZj8C4jipAe1izrSc3l/3Sh0DgR3rNgnjUcqA4N1fTlU5IrYSgpeizhupBw6pzjlmxRZYWb2WprV6bZTQowDI0nIeuu2Lqld7j8E6o1f1e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0CJyDQe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0CJyDQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17E71F000FF;
	Tue, 13 Oct 2026 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904043;
	bh=XQQXLmuz/mYy2m0DRCE2BDh2jZAsmGDyji4q3SA7eeo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=W0CJyDQetBRxIuAkvUzo9XSWPFP2uj49nmF5Ola6oDkax5fLOw4htdgKdsytOaX5D
	 fKB/AqLxOYHFOHmAjt8ojXPCgCA78WqENnldOw0as4l4mcCFFYyBHAyH7TsB63TSr8
	 5h6dyJ6dR5KmSY3dMcYRX2XLk+RphbYhT3pyBjr6eNFn4SarroRPDThxbNL29Q3xJ9
	 lVXkpNZnmVdJfWIqYlVnErwk2NwZNrj/UnmG0wshn07J1ICxsMnOLpUqb4+uJZr9sn
	 MbIqT+7Tz99hZmqryEVpBVBnwG1IqyInMH98GC0PV7qV1CHNet8nfbYk/cY1ufQyBm
	 XE6okl5ntOaow==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:42 +0100
Subject: [PATCH v6 02/39] mm/vma: introduce and use vma_[flags_]can_merge()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-2-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3865; i=ljs@kernel.org;
 h=from:subject:message-id; bh=EYqw+AtDKpEde3pCckMQkm9HGGlkplYL0cvv0S5EwV8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeRxvNhVoP3Z94qSsOTNyr06esJ1D4lZRjFPX1NurP
 rp0qphs7ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBELr9k+Cu0JUL1uEbhkaO7
 YgPmbmHhObXOcNvNOTEZ3NJSb6u+PbvIyLDkrPhkFo5anxrGB92nAo5K7TKVOrbk3qT7yqYyfLZ
 qHzgA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
two new functions vma_flags_can_merge() and vma_can_merge() and update the
merge logic to use the former.

This abstracts the check and expresses it in terms of the desired behaviour
rather than an arbitrary and confusing VMA flag.

This also lays the groundwork for making further improvements in VMA flag
usage.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 21 +++++++++++++++++++++
 mm/vma.c                        | 19 +++++++++++--------
 tools/testing/vma/include/dup.h |  5 +++++
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 969594074fd2..68250ece4219 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,27 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
+ * merged with another?
+ * @flags: The VMA flags to test.
+ * Returns: true if the flags permit merging, false otherwise.
+ */
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}
+
+/**
+ * vma_can_merge() - Do @vma's flags permit it to be merged with another VMA?
+ * @vma: The VMA to test.
+ * Returns: true if the flags permit merging, otherwise false.
+ */
+static inline bool vma_can_merge(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_merge(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/vma.c b/mm/vma.c
index c27aea6d58d9..8f8c554d5c07 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -924,13 +924,14 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
 	/*
-	 * If a special mapping or if the range being modified is neither at the
-	 * furthermost left or right side of the VMA, then we have no chance of
-	 * merging and should abort.
+	 * If the range being modified is neither at the furthermost left or
+	 * right side of the VMA, then we have no chance of merging and should
+	 * abort.
 	 */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!left_side && !right_side))
+	if (!left_side && !right_side)
 		return NULL;
 
 	if (left_side)
@@ -1152,9 +1153,11 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
-	/* Special VMAs are unmergeable, also if no prev/next. */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!prev && !next))
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
+
+	/* VMAs with no prev/next are unmergeable. */
+	if (!prev && !next)
 		return NULL;
 
 	can_merge_left = can_vma_merge_left(vmg);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 16c09dac59d9..2fd422789717 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1647,3 +1647,8 @@ static inline bool file_is_dev_zero(const struct file *file)
 {
 	return file && file->f_op == &zero_fops;
 }
+
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}

-- 
2.55.0

