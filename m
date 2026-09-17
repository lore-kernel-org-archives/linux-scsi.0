Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D22C470EB6;
	Thu, 17 Sep 2026 16:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662578; cv=none; b=hW/zaFC8UAk+GVZj5bwjxRWBeHS1bRnX8vFPDQd5VOgcWqbHQQelRS0IN48ZS4/G7hFhJO+TEpSsBA6TuWtTW4QSSY+Aq4FNnPq3/z0GhPsGmnr4DIefTgvtXOFK11q7R40FoGsOxXqji8EUWmLkQShwQYFQKHiNsWVE084TAJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662578; c=relaxed/simple;
	bh=BufAYcKoxP4rPy82Onp5UAmN13VcupWKa3H7JCJQDTQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UevUfvHNPjGBOB3yEEecFfp3ZmQUt/yPBmJUHa8PuqzPGiIADm7PVqGZ+jvDe/cBo+UbgJWg2peVb4jSQ5hk1ttxdqVBLy5u26CVggJ17jG+8ThH6w8S4mMd+kSVcUFyBJGSF0UyXhn9V1UW2cX/BfVKpeps6H5cmQD9FFsxC2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dbRB47of; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbRB47of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220F71F00893;
	Thu, 17 Sep 2026 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662577;
	bh=Ht1E3XYrT6zNGxe7BXRz6LPnDrSfYBDlq1F1i7I+270=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dbRB47ofHZr0h32dLtHj8gOYSjObkQRAfNeh3WPpPefyZxKOj7REK2DmcOKSOXO4f
	 r9l6XNryKF+hpjo+7ObcmU6U7x0dvAHPHf6EiKNhNWj06W9kIeQAdpcIRhTWo4QMl0
	 RLrIJyu85upL/D9BkeJtRpjYmwYQ+tu0uLxXZqU3delH3fds8ajC/dRzaFuPXut4QI
	 XIefC9t+6YJl/LvCrT+V9rJkGbY/z2ONmNS5BphoYawKorecqpAvg6Dk9QmITZDy0M
	 X8mhMaBvKWEtlGv4TgAQKXieOEDeNXteg9TAK+d+4eMe8FYZ7ggCJ4YCtWPX8ir6Wv
	 ykGgfMLJZ62sg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:22 +0100
Subject: [PATCH v3 13/40] ALSA: pcm: use vm_insert_page() to map PCM status
 page
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-13-4583d8a23bca@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Takashi Iwai <tiwai@suse.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2769; i=ljs@kernel.org;
 h=from:subject:message-id; bh=BufAYcKoxP4rPy82Onp5UAmN13VcupWKa3H7JCJQDTQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB8ocPh1OGSVz5SG6f3iG/++71lddiNl9w1Vz6vib
 vJ97/JCOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRzR4M/8PXr92WnfMhnff8
 Ky3lLw5LZ8cV/t7hJLpj/TOrqe6OwZUM/91rC3Tu9qnN7fy2I/G/RaLPxDL7E0EWF1987fxwr/F
 wJzsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

There's no need to keep a fault handler around for this, instead map on
mmap.

While we're here, rename area to vma to be consistent.

This correctly makes the mapping a mixed map mapping.

This works towards establishing the invariant that only PFN mapped or mixed
map mappings may clear the VM_MAYWRITE flag. The status page mapping clears
VM_MAYWRITE, so it must be kernel-owned; the control page mapping remains
writable and is left fault-based.

The assumption is made that the struct pcm_mmap_status structure is at most
a page in size, which is asserted as a build bug.

This is safe to assume, as the size of the structure is 56 bytes at most.

Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 sound/core/pcm_native.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 62324282fcae..c98fb3df14f3 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3760,39 +3760,27 @@ static __poll_t snd_pcm_poll(struct file *file, poll_table *wait)
 /*
  * mmap status record
  */
-static vm_fault_t snd_pcm_mmap_status_fault(struct vm_fault *vmf)
+static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
+			       struct vm_area_struct *vma)
 {
-	struct snd_pcm_substream *substream = vmf->vma->vm_private_data;
+	const unsigned long size = vma->vm_end - vma->vm_start;
 	struct snd_pcm_runtime *runtime;
-	
-	if (substream == NULL)
-		return VM_FAULT_SIGBUS;
-	runtime = substream->runtime;
-	vmf->page = virt_to_page(runtime->status);
-	get_page(vmf->page);
-	return 0;
-}
+	struct page *page;
 
-static const struct vm_operations_struct snd_pcm_vm_ops_status =
-{
-	.fault =	snd_pcm_mmap_status_fault,
-};
+	BUILD_BUG_ON(sizeof(struct snd_pcm_mmap_status) > PAGE_SIZE);
 
-static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
-			       struct vm_area_struct *area)
-{
-	long size;
-	if (!(area->vm_flags & VM_READ))
+	if (!(vma->vm_flags & VM_READ))
 		return -EINVAL;
-	size = area->vm_end - area->vm_start;
-	if (size != PAGE_ALIGN(sizeof(struct snd_pcm_mmap_status)))
+	if (size != PAGE_SIZE)
 		return -EINVAL;
-	area->vm_ops = &snd_pcm_vm_ops_status;
-	area->vm_private_data = substream;
-	vm_flags_mod(area, VM_DONTEXPAND | VM_DONTDUMP,
+
+	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP,
 		     VM_WRITE | VM_MAYWRITE);
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
-	return 0;
+	runtime = substream->runtime;
+	page = virt_to_page(runtime->status);
+	return vm_insert_page(vma, vma->vm_start, page);
 }
 
 /*

-- 
2.55.0

