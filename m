Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2189948EC72;
	Sat,  3 Oct 2026 16:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045953; cv=none; b=OoA/QiIus0IzhuFGkonfgAj13RSwJh1HUDMBXrdeb7iJcIVPqTWHflBzZM+2igQiwjtEbb4d3oBkg4VrslgYvIysFmyzYE8zR8HS04/AbHEy6/SmzCHI8CSj1LDbp/wfeiEh3XOUBvSki+MEZ/0vjY4+LOqrEerqlJw9XzTChnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045953; c=relaxed/simple;
	bh=D4Bktmj1CFdgrn8TjfxCWBpiKXIl0qBVGlP1ttOp62E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=B7c1gKh7V2htzZlaO+fjUZQ4p/FXIVZejTBR89LE/zPQZX976O0I0jxgZUm+4zuwhNnAWx+pfNMDfsN4iKlhe1piCJisZK8SQdUGSCHb3eOoW342ZoGuOEulyfAtna9AvnipbeMDTL2lUNjtTsIWLBfdv3/BdejOvr8xtiyj3YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h2Dsfg1X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h2Dsfg1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0211F0089B;
	Sat,  3 Oct 2026 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045951;
	bh=36Kk9cCfrs+K/ZkPenTGstnZo1LIkvSMm4GHKa8AJS8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h2Dsfg1Xql747wZrXI3+/fz+4Y+deOBQpJgW4qxqntXMyJIAE2gecb3qiFuHuXvd+
	 voif1GZgA7UUtM0vblPSsNPjNQDh007WtJxzNKXuJJmlWKpUzw2tnVJ9qgiQPBmEV8
	 /KVzqVkx+NRAzVGPz7fMFbNn8ZnZgIP0r0ErqwsLluheJjglZbyJsVBdmasrHRGE4P
	 6Pq1MEmJdPiKAYiq6X7WUP7FQrKS1ygoauY3kSAe+KyFRs+sH7NmCBzkGjvS5CwQJA
	 a/SBJmbkZ0EKfc4synBXhjltgsKTDX7nydodQN9HWpicB+1/PaZ7llQz1G7dJeMRog
	 umWRkuiKGNkLw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:33:07 +0100
Subject: [PATCH v4 36/38] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-36-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2224; i=ljs@kernel.org;
 h=from:subject:message-id; bh=D4Bktmj1CFdgrn8TjfxCWBpiKXIl0qBVGlP1ttOp62E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6unornY/vrR45rV+j2uBywp8dvvNmSxU7+n9/NWs3
 aJ+svP+d5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiYh8YGebu/HL6nv7eWw39
 GyuW/VrPzaW79K14dimT2lbWJtGUiukMv5i8wo8cZas3Zl5++fGUqQvXCFf+/z1F/2tr5tngzWr
 7U3kB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted to
predicates which explicitly express what is actually being checked for
rather than the nebulous concept of possessing 'special' VMA flags.

In any case 'special' is not so special a term of art in mm - it includes
VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
other cases too.

Therefore make things less special by eliminating these now unused flags.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 8 --------
 tools/testing/vma/include/dup.h | 8 --------
 2 files changed, 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 55320cf2c525..7ada0da24d0c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -576,14 +576,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-#define VM_SPECIAL vma_flags_to_legacy(VMA_SPECIAL_FLAGS)
-
 /*
  * Physically remapped pages are special. Tell the
  * rest of the world about it:
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 94bf818ad0e1..7a6d99ad5303 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -352,14 +352,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 

-- 
2.55.0

