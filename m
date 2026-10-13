Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225674FD283;
	Tue, 13 Oct 2026 15:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904198; cv=none; b=WMB8CAHZ9DiznpBHYlr476pMl/gD7/aU/EDPewVI8Lo14KYumc7sy/6czNKW3iGH2rFS1MCGsiGw7fOr+T5QgNtt13A+IojIJqFSF3ayZxVrSaybGurSu7g6FRjyy55Z8O+Q+UHYNMOkhCsDMH9Y2b5VNCeO1wzuYN7p+kF8XWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904198; c=relaxed/simple;
	bh=TbqTPYaAeeKYfJzERyfDmnse82FvI3oUPXbYIaX+sow=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rBtkuPkb1EaXsB185A+Llr8IyLNWef72DjX7hj8q7Iuo7JXFA8fVS8nalUX9JNbozZdMZhRTtuAPwE92BZ1tYC62dTZSQO0aO0RsU60q5Uoy/rPR6KdmTlrEjCNtG44VSUB5iiARRae+AK0sZ0GwAsq4gXfNOVH1LdbLRzs6w18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QaMMPvoB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QaMMPvoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699EF1F00893;
	Tue, 13 Oct 2026 15:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904196;
	bh=pqjij0GQHv0uGr5m3MLqkx9Z/Edu8SdGUtOw7ak7aEU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QaMMPvoBkRQFAMn/jOf8exJm85hwBU5pSElCP/Er+C40M6N+nEcPRKHuZe7qiGCoi
	 FMiKMiqdGgyIWPe3gPJwJ7y+l+nzSPqsSYMIwYHywtyX4x/hEzxvxSoUiwP48W61S8
	 /K1Q3HENunFrDm14o2cQDUwlnzKVqNoVxn0iE61EgkEUdMRY8R4+LWEJEa7vrkBQLZ
	 EbUqY952L3/osbrWlw36bO6EczAH1Xviw7prpI9EIF5yss6+RXyVBcjYshcFZ5laN3
	 Y8ILMCLkC9O0UPqru/KG6ii8DhSkgmlKBPfMEJvkp7fNYJ5kVy278xiAGZTGWPlERj
	 5Jcp8ZDSHQVUA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:47 +0100
Subject: [PATCH v6 07/39] mm: assert mmap lock held, use new flags API in
 vm_insert_page[s]
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-7-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1941; i=ljs@kernel.org;
 h=from:subject:message-id; bh=TbqTPYaAeeKYfJzERyfDmnse82FvI3oUPXbYIaX+sow=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZxgd3q2ZYbv9L0VRdKmsr5XjkcJfTodf1Xzyqz5T
 aVJd/++6yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEmmwY/hdv2LP/+bo1Rb0a
 Z7aZGO1/1b9r9sE6WSsflZSsF/vCrhQw/Pcxmb1B2vSNUxRXUMPJeh3lDYGrouy+/4x6+uiN8Tf
 ttdwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

The existing logic asserts that an mmap write lock is held, bizarrely, by
asserting that an mmap_read_trylock() fails (which is not the same thing).

Assert the mmap write lock here and switch to using the new VMA flags API
while here.

Note that the vma_start_write() is explicitly broken out from
vm_flags_set() here in order to use vma_set_flags() safely.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 448342883e9d..a35cca09eb71 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2599,10 +2599,11 @@ int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 
 	if (!range_in_vma(vma, addr, end))
 		return -EFAULT;
-	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
-		VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
-		vm_flags_set(vma, VM_MIXEDMAP);
+	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
 	}
 	/* Defer page refcount checking till we're about to map that page. */
 	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
@@ -2675,10 +2676,11 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
 {
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		BUG_ON(mmap_read_trylock(vma->vm_mm));
-		BUG_ON(vma->vm_flags & VM_PFNMAP);
-		vm_flags_set(vma, VM_MIXEDMAP);
+	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
 	}
 	return insert_page(vma, addr, page, vma->vm_page_prot, false);
 }

-- 
2.55.0

