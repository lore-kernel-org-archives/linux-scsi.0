Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E283EC83D;
	Tue, 13 Oct 2026 15:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904137; cv=none; b=nQddmOUd2L7M0PJ2eoYV8rVD/cpRI7WJh7amHJk7Q+ASz59/oUAKC4MKfPad1E4MdEmZ7g5T1BsEhJxafPG1V5PwXkdLCGs25TMJa+nwp3qc81961ZjIkLabRawgTq7bEI1xzyDR98sMvo/YY9VMsfGNmnZVVN/51UQSjs6i5Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904137; c=relaxed/simple;
	bh=W5EJA/cmsVT7jDTw6eYY8+j+S742rFhYZzwOfLirwec=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YqW7IOiN7pM4C/26e+ZU+Xh6v8bYXy8NW+fHHateN6rLkTeR7zZ3ju+hmVvqvcKUUirVeBTRPRhUSyekdhP685qVcPrYOSQA2TRXnZs8gcTEZRpZ7hIcpDWTJSWyCDK06tqO5HQ47SZWHYApYbltWZPoHh4LIq65NwPmavTzPhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHOPEcU7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHOPEcU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0219F1F00893;
	Tue, 13 Oct 2026 15:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904135;
	bh=SAzG9Wth1XJ2c0bU3DI60XqRT1mNgvn5WEld38uFlsY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FHOPEcU7MXinlxgbwWxCoeD5kIf5P/lIzM7XJGaKv4AAf09FeVis+fbDl6q2+pPY+
	 spXkLO3MXzogC821f/XTwMp8SAwmiQqxtIPsVfoO9L9d7FbFRHRvf8YuD09fA7bxjE
	 SlSItJH1h0l+ilsQVXHmxvfBluDOi7boaCOmN+9yXJzSYS08qphyqDae7oBnwVLRWM
	 Q4mnxEr5QgHO4tSaRiaIzPzhg4mfAdemvg+5lSiBikE0l3VKSI6JE3qTC+2nWQZDlU
	 8WL81pMWCJrlgZ1vKDANjXQZbh+xFIMGOYgT0zOqRkrmZa0k5cnEINgwkJKg8p3cRD
	 /j9W4+enKtBkg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:45 +0100
Subject: [PATCH v6 05/39] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-5-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2708; i=ljs@kernel.org;
 h=from:subject:message-id; bh=W5EJA/cmsVT7jDTw6eYY8+j+S742rFhYZzwOfLirwec=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeRxfEfJ/U3brQdO/Ntp7ihlnc+maHFNKPJS4a0rdC
 ZH9vE6rOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARe3dGhq+yJTeWZkcfY/rk
 e29+2g0dL8npjWfn31io99DKqea3wGyG/7EH5LU+HM49IFuqE23eHJLcZ7DixoMtVb/Pix2SKel
 i4AMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

There's no reason to export the symbols for these functions which are only
called from internal mm logic, additionally there's no reason for them to
be declared in mm.h.

This patch therefore removes the exports and moves the declarations to
mm/internal.h.

No functional change intended.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 3 ---
 mm/internal.h      | 3 +++
 mm/memory.c        | 2 --
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 68250ece4219..0c17f0932b76 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4768,9 +4768,6 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num);
-int map_kernel_pages_prepare(struct vm_area_desc *desc);
-int map_kernel_pages_complete(struct vm_area_struct *vma,
-			      struct mmap_action *action);
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
diff --git a/mm/internal.h b/mm/internal.h
index 061a87f9c3fb..fc4e249e2343 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1512,6 +1512,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *desc);
 int remap_pfn_range_complete(struct vm_area_struct *vma,
 			     struct mmap_action *action);
 int simple_ioremap_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_complete(struct vm_area_struct *vma,
+			      struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 926276d41920..448342883e9d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2628,7 +2628,6 @@ int map_kernel_pages_prepare(struct vm_area_desc *desc)
 
 	return 0;
 }
-EXPORT_SYMBOL(map_kernel_pages_prepare);
 
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action)
@@ -2640,7 +2639,6 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
 			    action->map_kernel.pages,
 			    &nr_pages, vma->vm_page_prot);
 }
-EXPORT_SYMBOL(map_kernel_pages_complete);
 
 /**
  * vm_insert_page - insert single page into user vma

-- 
2.55.0

