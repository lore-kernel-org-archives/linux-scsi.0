Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BA5388369;
	Tue,  8 Sep 2026 20:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788898149; cv=none; b=nKMcXdO0DEXQv8KIeAzOz5aaRjc2SxPAF6dFLiIXcXzipMYll6Q3Kg0ie2PAuX9IWCTxtg4kuOPDBmu4LbFM1ivSwmYkrzOHlZqn+Xx9NKgJYi24ytBsJ0x8k7Q5SUUZzN2brbr9kF6JMSVHXe3eZSnum5T4m65i67siJShBS2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788898149; c=relaxed/simple;
	bh=JOTHkDDSySWU/FaBwU/dlcCoevcoCS8rHIuAzWMFwPs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kHy1viOi9goeNyaNZy9N+lQL3HJ1fHbAX4811qVA9Z66uEk9jXQzP770fRaI6R5gsxW1pByzQoFCaaX/7CtwZIH0Uw+qB7mGvB2hsQzcjBNOeRr3doOHPKiaduIGqAg3azUeftZGmq8Ih0+KXgegFPEt2ux7+Nnn6tWJP5lk8MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LeCjzr7L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LeCjzr7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B1C1F00A3D;
	Tue,  8 Sep 2026 20:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898147;
	bh=wkAy/O15nPnQoj39O2Jkmru1wT+lgic9B+37FMixNf4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LeCjzr7Lxvh1mK11clJatYArBKS24pOQj2ahoUiXsKc+TMcQ3s0bRMEPuPKe/H5cG
	 ZsEW/MtqSep77H7nCkm/77+CSVWcqJoxGZbLCWl5ASvegv3qYyEmX0y8XC6Y0141Uo
	 af6EjWwftHJuxPib7aF1l8vclmOnQgNieZ2HZiXZ30rDUhO/T0XypyMo2NiBJytLM4
	 vPOstzXzO+A/e9TtkCQ+tQ4x7dLeKigZgNz7/Tm6QuEugL9gtJG1veO65ATNV8fJQy
	 ELtXRPMisE79w3KzHtZleS+cd+UVh9zhKe52slLyVzGy5GWrN5w3yIDSpibI8kwAuV
	 +VL06VNS0fwRg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:18 +0100
Subject: [PATCH 14/39] mm/vma: add vma[_flags]_is_kernel_owned() predicates
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-14-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5413; i=ljs@kernel.org;
 h=from:subject:message-id; bh=JOTHkDDSySWU/FaBwU/dlcCoevcoCS8rHIuAzWMFwPs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG46/Dk21jE44vPvzcGS/6+X8j0O/utbrRvtXblW5
 8piq5c+HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIcCPDXwExux8XPzA27F31
 bw0Tc6V9VTTb95yHxzZq+2xPZsnjNmBkuOonutzuk7tY0u2ujD8rmbM+7a/6VPJWsjn8WMXKbT1
 7OQE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Rather than referring to VMA flags with uncertain meaning, add a new
predicate that explicitly describes what possession of the VMA_PFNMAP_BIT
or VMA_MIXEDMAP_BIT flags mean, and then refer to that function for
determining VMA mergeability.

Either flag means the contents of the mapping are owned by the kernel,
usually a driver, rather than by the core mm: the memory may be MMIO,
kernel-allocated pages or even ordinary pages the driver maps itself, but
the core must not populate, reclaim, migrate, copy-on-write or merge the
range on its own initiative.

We initially also include VMA_IO_BIT here, as by implication, these must be
kernel-owned. (mlock() also sets VMA_IO_BIT transiently on ordinary VMAs
while locking them, which is addressed later in this series.)

However the intent is to in future remove this, as no mapping should be
marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.

This forms the basis of further work intended to improve how we express VMA
properties such as this.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 56 ++++++++++++++++++++++++++++++++++++++++-
 tools/testing/vma/include/dup.h | 29 ++++++++++++++++++++-
 2 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4604cd011ca4..45c59474c853 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,44 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_is_kernel_owned() - Do the specified VMA flags indicate that the
+ * contents of the VMA are owned by the kernel rather than the core mm?
+ * @flags: The VMA flags to test.
+ *
+ * A kernel-owned mapping is one whose contents are established and controlled
+ * by the kernel, typically a driver, rather than by the core mm's fault and
+ * rmap machinery.
+ *
+ * The mapping may be memory-mapped I/O, kernel-allocated pages or ordinary
+ * pages the owner has chosen to map itself (shmem via a PFN map, for instance).
+ *
+ * But in all cases core mm must not populate, reclaim, migrate, Copy-on-Write
+ * or merge it of its own accord.
+ *
+ * The pages mapped, if any, may or may not be reference counted or map counted.
+ *
+ * Returns: true if the flags indicate a kernel-owned mapping.
+ */
+static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
+{
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				  VMA_IO_BIT);
+}
+
+/**
+ * vma_is_kernel_owned() - Are the contents of @vma owned by the kernel?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_kernel_owned() for a description of this property.
+ *
+ * Returns: true if the VMA is kernel-owned.
+ */
+static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_kernel_owned(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1620,7 +1658,23 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, kernel-owned mappings may have established state upon mapping
+	 * not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (vma_flags_is_kernel_owned(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }
 
 /**
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 52eee05e6c32..3fe40e0f4034 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1659,7 +1659,34 @@ static inline bool file_is_dev_zero(const struct file *file)
 	return file && file->f_op == &zero_fops;
 }
 
+static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
+{
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				  VMA_IO_BIT);
+}
+
+static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_kernel_owned(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that the properties of a VMA completely describe
+	 * the properties of that VMA.
+	 *
+	 * However, kernel-owned mappings may have established state upon mapping
+	 * not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, PFN maps encode the source PFN of the range in
+	 * vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (vma_flags_is_kernel_owned(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }

-- 
2.55.0

