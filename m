Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E87451AEE0;
	Tue, 13 Oct 2026 15:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904595; cv=none; b=jaryEB/SYeYwzOBn/wGi5kGB1UElYTyMre/SoKa7zJm6LpRqGGm/MG0K8sb9BKS153cwPoxtXeI+YipJ7jQ9YZ/q+YeAiLg0f+3qz3NXDOK1nH21IVyk/0RlDCB3xrP727eNHwnDR8bp+sFhZO7Vb7etf9y5NBXrRM0PckoEfuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904595; c=relaxed/simple;
	bh=MY9UuAl0nfMrM4GSY6SwItqCUTxM/pJjBHtqUqIj4oQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=INNPxDmBdlG0fU2bdkF0tFljDLWjODty+uTOwzl8KoaPzXa8Lj1pC/cXplAWSzlK5BpnqeQt80D1mJXTJrg014hWmunVHDVU28Uhnt5gjRBsPQG+Pvi+MWw5bQN6WiTcahSsnZs7hAIUFd/0jqzgBVKn//SI06D5FDigp6PNDaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PV5aBdva; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PV5aBdva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CEB1F000FF;
	Tue, 13 Oct 2026 15:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904594;
	bh=i4y1sz7ZVghomqASsiy9XjZk1iqHWnAgN1nUm45xiCg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PV5aBdvadH0SfHvKhSrJFwpI31/6TLnUPl2tF4inkGRjH2ijS95fbUwXttmLzcpNF
	 5YVTNWNyE258rCi9csqPX0Vj3cl9jaUDTYbMJFqgtmVLV19Z7aozriIyOun6cOX4CA
	 Uqu8rE7sCZr4z3nz4Kzn2wrrCdQCFfiLVbmodNsFAGB1+jJbDNaURDMI061vbNIp7A
	 9SZegYRQAPKdv3I+JM3iXh765idzGneUCjN998P+vvPrKb4ofuLC3QTcRU0UWm0cTM
	 2Aj3jBmQzN+qkgGPCcVlhU/BclKU4af39C0cIrIexLOcaqP3dxowDtNAZxqEI9H8iS
	 yN5UVLyQAcdhA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:00 +0100
Subject: [PATCH v6 20/39] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-20-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2685; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MY9UuAl0nfMrM4GSY6SwItqCUTxM/pJjBHtqUqIj4oQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZy6kXSgTuanGnvKJJENNyOu/UwUsd+bw7y5x6TbY
 u5UgX2fO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR+zUM/zQvH7vAej3kqe3+
 bfVvFVQDI1RbnR7ofOBZnLM9W+V/pB8jw0Nhvv3x24xm9HZqz/rgs192a1lrRdjTt8lfVzDsibP
 dwwAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Use the mmap_prepare in favour of the deprecated mmap hook as part of the
work to convert one to another.

Since this is simply a refcounted kernel page that has been allocated, it
should not be marked VM_IO and should be inserted using the kernel page
insertion mechanism, so convert it to do this instead.

Use the VMA descriptor's private data field as a scratch buffer to store
the page in - this stays valid throughout the kernel page mapping
operation.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 7226677ebde7..801697b74d4f 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -1084,22 +1084,6 @@ static void cs_hsi_stop(struct cs_hsi_iface *hi)
 	kfree(hi);
 }
 
-static vm_fault_t cs_char_vma_fault(struct vm_fault *vmf)
-{
-	struct cs_char *csdata = vmf->vma->vm_private_data;
-	struct page *page;
-
-	page = virt_to_page((void *)csdata->mmap_base);
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
-static const struct vm_operations_struct cs_char_vm_ops = {
-	.fault	= cs_char_vma_fault,
-};
-
 static int cs_char_fasync(int fd, struct file *file, int on)
 {
 	struct cs_char *csdata = file->private_data;
@@ -1256,18 +1240,19 @@ static long cs_char_ioctl(struct file *file, unsigned int cmd,
 	return r;
 }
 
-static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
+static int cs_char_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (vma->vm_end < vma->vm_start)
-		return -EINVAL;
+	struct file *file = desc->file;
+	struct cs_char *csdata = file->private_data;
+	struct page **pages = (struct page **)&desc->private_data;
 
-	if (vma_pages(vma) != 1)
+	if (vma_desc_pages(desc) != 1)
 		return -EINVAL;
 
-	vm_flags_set(vma, VM_IO | VM_DONTDUMP | VM_DONTEXPAND);
-	vma->vm_ops = &cs_char_vm_ops;
-	vma->vm_private_data = file->private_data;
+	vma_desc_set_flags(desc, VMA_DONTDUMP_BIT, VMA_DONTEXPAND_BIT);
 
+	*pages = virt_to_page((void *)csdata->mmap_base);
+	mmap_action_map_kernel_pages_full(desc, pages);
 	return 0;
 }
 
@@ -1353,7 +1338,7 @@ static const struct file_operations cs_char_fops = {
 	.write		= cs_char_write,
 	.poll		= cs_char_poll,
 	.unlocked_ioctl	= cs_char_ioctl,
-	.mmap		= cs_char_mmap,
+	.mmap_prepare	= cs_char_mmap_prepare,
 	.open		= cs_char_open,
 	.release	= cs_char_release,
 	.fasync		= cs_char_fasync,

-- 
2.55.0

