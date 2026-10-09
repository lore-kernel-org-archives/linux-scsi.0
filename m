Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EDD4F55BB;
	Fri,  9 Oct 2026 18:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569434; cv=none; b=kO6Hs+QyTARmAxtaEnz8TIzRQTRXNPzZjqxShGRKs5x44co1qod1hLMp+t4B/EuiCrTHA2mOnTU8V6VCwMGKCbYRUsNoWUSF9X94wgHS+jRG8771OBYk88oY0sF144L+AxJv0H8i/47pXmP9UatB5E2dFLgH63epYTN7oDhbBBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569434; c=relaxed/simple;
	bh=a3PfLNgLx1GbuXFw7DoxzYfKOvfjucxXwlN8dVffozI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oh5o+7KdB0RODzXKshDaFj9Bqx5U8A9GO8zrNDyJV/VIRlGf/I+HUSPg71edh3OCgC62ma21HXhdlBSm7LzCUzVXoJaL6FsGoaNijaZxFqT5jdyBMpoq/f6DJGsrZZ4tOJ9MwtMwcO+KZ7pSWJFHl0qFOqQOppr8H7PZOOI4FaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oqpUmEHM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oqpUmEHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676291F00899;
	Fri,  9 Oct 2026 18:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569432;
	bh=ytmLoC3zHdwZxCxWy26b8X7pqcm/Lj2djuN1AI4Dw0A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oqpUmEHM2z/wvmmgp2MRRX+GRvaOCWjV5ii6gbgoGkcP3lf550eL/rHRvYtLwRVRg
	 ZJMUScuAxtIuMMdTd0/rulTohZO+IJpphLyqqqkuRExULVGQPbSlIhiHC/WxZpQ4KG
	 fQh81tHtSR4NOHTEA4EDrNMFYFIFFbqZ2qQD9VidjqYV6Py02HvXoQcYIWihcamcRu
	 KsyHgQuQxyNr6YkiB5k/fnqBzdl/oz22gM4MzVcUF2tjxBA/a5BznF8UgObWl3n4px
	 ou/xRPUciNnG82Yno1GmwVHXPEBP3ceRKVW1FTIGI0NL/tr1c2S0qjp2XAwDzl03Hm
	 vkQeHpFglq1Fw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:11 +0100
Subject: [PATCH v5 17/38] scsi: sg: convert mmap hook to mmap_prepare and
 rework
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-17-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5990; i=ljs@kernel.org;
 h=from:subject:message-id; bh=a3PfLNgLx1GbuXFw7DoxzYfKOvfjucxXwlN8dVffozI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6szuCDXk3+0XoqX8cm3eY+4PvK0fuS8crYx+uu/js
 12HPhw41lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ7N7MyNDwQny18urz1t8X
 SthXznvXf2jRaYbrAhxn1T5bNGTOnp3GyHB6dTbfvV/zD0+YUXnj2VcG2QVaUkYOkn/fnP/7P61
 trg8DAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook.

We are mapping kernel pages here, so use the discontiguous kernel mapping
mmap action to do so.

Unwind the rather confusing loop and instead map as many pages as we can at
one time.

Note that we do not need to pay attention to rsv_schp->k_use_sg here, as
the pages are populated for the length of the buffer at
rsv_schp->page_order granularity as compound pages.

The discontiguous kernel page mapping logic handles the compound pages for
us.

sfp->mmap_called keeps the buffer stable for us. As before it is never
cleared, so a failed mmap also leaves it set.

We also remove some useless vma, vma->vm_file NULL checks - these will
always be non-NULL if you reached the mmap hook logic.

We retain log output for consistency, but change what's output on page
mapping to indicate that sg_discontig_get() does the work now.

Note that we drop the VMA_IO_BIT flag for the VMA here. It was never
necessary as we invoke alloc_pages() which gives us refcounted folios that
are fine for GUP to access (VMA_IO_BIT would prevent that).

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/scsi/sg.c | 115 ++++++++++++++++++++++++------------------------------
 1 file changed, 51 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e6c0..3f9e08725602 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1212,85 +1212,72 @@ sg_fasync(int fd, struct file *filp, int mode)
 	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
 
-static vm_fault_t
-sg_vma_fault(struct vm_fault *vmf)
+static int sg_discontig_init(void *vm_private_data, void **private)
 {
-	struct vm_area_struct *vma = vmf->vma;
-	Sg_fd *sfp;
-	unsigned long offset, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-
-	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return VM_FAULT_SIGBUS;
-	rsv_schp = &sfp->reserve;
-	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= rsv_schp->bufflen)
-		return VM_FAULT_SIGBUS;
-	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
-				      "sg_vma_fault: offset=%lu, scatg=%d\n",
-				      offset, rsv_schp->k_use_sg));
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		if (offset < len) {
-			struct page *page = rsv_schp->pages[k] + (offset >> PAGE_SHIFT);
-			get_page(page);	/* increment page count */
-			vmf->page = page;
-			return 0; /* success */
-		}
-		sa += len;
-		offset -= len;
+	const unsigned long req_sz = (unsigned long)*private;
+	Sg_fd *sfp = vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	int err = 0;
+
+	mutex_lock(&sfp->f_mutex);
+	if (req_sz > rsv_schp->bufflen) {
+		err = -ENOMEM;	/* cannot map more than reserved buffer */
+		goto out;
+	}
+	sfp->mmap_called = 1; /* Prevents changes to buffer size. */
+out:
+	mutex_unlock(&sfp->f_mutex);
+	return err;
+}
+
+static int
+sg_discontig_get(struct discontig_kernel_page_state *state)
+{
+	Sg_fd *sfp = state->vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	const unsigned int order = rsv_schp->page_order;
+	const pgoff_t nr_pages = state->nr_pages_mapped;
+
+	if (nr_pages >= (rsv_schp->bufflen >> PAGE_SHIFT)) {
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 
-	return VM_FAULT_SIGBUS;
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
+				      "%s: offset=%lu, scatg=%d\n", __func__,
+				      nr_pages << PAGE_SHIFT, rsv_schp->k_use_sg));
+
+	discontig_kernel_map_page(state, rsv_schp->pages[nr_pages >> order]);
+	return 0;
 }
 
-static const struct vm_operations_struct sg_mmap_vm_ops = {
-	.fault = sg_vma_fault,
+static const struct discontig_kernel_page_ops sg_discontig_ops = {
+	.init = sg_discontig_init,
+	.get = sg_discontig_get,
 };
 
 static int
-sg_mmap(struct file *filp, struct vm_area_struct *vma)
+sg_mmap_prepare(struct vm_area_desc *desc)
 {
-	Sg_fd *sfp;
-	unsigned long req_sz, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-	int ret = 0;
+	Sg_fd *sfp = desc->file->private_data;
+	const unsigned long req_sz = vma_desc_size(desc);
 
-	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
+	if (!sfp)
 		return -ENXIO;
-	req_sz = vma->vm_end - vma->vm_start;
+
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_mmap starting, vm_start=%p, len=%d\n",
-				      (void *) vma->vm_start, (int) req_sz));
-	if (vma->vm_pgoff)
+				      (void *) desc->start, (int) req_sz));
+
+	if (desc->pgoff)
 		return -EINVAL;	/* want no offset */
-	rsv_schp = &sfp->reserve;
-	mutex_lock(&sfp->f_mutex);
-	if (req_sz > rsv_schp->bufflen) {
-		ret = -ENOMEM;	/* cannot map more than reserved buffer */
-		goto out;
-	}
 
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		sa += len;
-	}
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = sfp;
 
-	sfp->mmap_called = 1;
-	vm_flags_set(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_private_data = sfp;
-	vma->vm_ops = &sg_mmap_vm_ops;
-out:
-	mutex_unlock(&sfp->f_mutex);
-	return ret;
+	mmap_action_map_discontig_kernel_pages(desc, (void *)req_sz,
+					       &sg_discontig_ops);
+	return 0;
 }
 
 static void
@@ -1415,7 +1402,7 @@ static const struct file_operations sg_fops = {
 	.unlocked_ioctl = sg_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.open = sg_open,
-	.mmap = sg_mmap,
+	.mmap_prepare = sg_mmap_prepare,
 	.release = sg_release,
 	.fasync = sg_fasync,
 };

-- 
2.55.0

