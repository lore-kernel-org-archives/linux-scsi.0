Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CCC3F5BD6;
	Tue, 13 Oct 2026 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904565; cv=none; b=MoIFmaA8aQ9umaCffBE/aNCrcCCyqqQvupAYOx5+F4OTlsOhQkWGVMlEy3Fc0x9AXo0fcAfwedmyPADJOYqZgqTCgClTp2ziKVpyhECXAZlLUus1scVEsXT9MeL/FqtkV88paK4AgLMRESa1sbaPo4O771CHLA+x7uWHra+qqEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904565; c=relaxed/simple;
	bh=E35+ZMn94RagHNIjsMN4/PIbgNGNlEUqBmCKgWbVnaI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dW8cUGk4O3BkcAmOJ8CVcenYJP1vxLcGorg4beKaM476BdZ5uQ4Cv9QVm9wC6gX+kOaMfqMzy3/1i1L2Ds74gNBJnhu57tuhQD/xemWVYsFUvCbT1dIk/PKYQgpE+jxVc39nxJV3ZfGvms6vZlQYMshKYUzwj/pMNLZqB6pcrUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oXRyBlwb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oXRyBlwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B441F00893;
	Tue, 13 Oct 2026 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904564;
	bh=GFhfE0EpCejkYMfipk7Q12g1VtbQ/nJQw01XCYAedo4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oXRyBlwbANCVnegp8iY5cvbAabzXfj7uUWG6HhCOs/m2gAAg9SHQKtYTIXLYZmhGU
	 PQ5SLGPgKkNbAUAFxAFzfOy9nOM5On+4vw8QFPdcKNuOiJTEmrNOOQIN7oVMJY9AJh
	 Z0cLlUEWHBql8lSrt6YwoEYoeBlm3HP99n1KUUtvGcihgzPboSk/CcQQCG7FpQcV9t
	 zV6piyKQPCpcBp68tfpewArXOCIJzZRK7mFR/LrtCvCcnbllR45tE1dSVaVdR8p1q5
	 8lZLI5QktBckfspAyjjvz+J0dOMYGDYMsRjt8Swy4F3cjWDlt0zFJKE1VO1eMqL+Za
	 zTq8OB5/LWNOw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:59 +0100
Subject: [PATCH v6 19/39] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO,
 add VM_MIXEDMAP
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-19-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2469; i=ljs@kernel.org;
 h=from:subject:message-id; bh=E35+ZMn94RagHNIjsMN4/PIbgNGNlEUqBmCKgWbVnaI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZy6l/j3/7mDaSI3zSJqPf9uujU3O7z5TcLd1Aff7
 u6sT4u06ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEpGYx/I/pkjx+UcHxg5LH
 agEVsX8vptTf5tD7ftf69+arRr/Ot39mZOhUOrvUR+Y8W+6cF+d4Dc9c75k2ja8uK+jOYdt/DtZ
 qX3kA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Currently all drivers which use defio allocate system memory. All of them
also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocates
system RAM, so simply failed to set this flag when it ought to.

This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
erroring out with a kernel warning if not.

The logic requires a page from the driver and since commit 1ecbc7dd2902
("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
always required it to be refcounted, so this was implicitly already the
case.

Finally this patch sets VM_MIXEDMAP, as the logic is mapping
kernel-allocated memory so this is appropriate.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/video/fbdev/core/fb_defio.c | 6 +++---
 drivers/video/fbdev/ssd1307fb.c     | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index fd00b86e1ae6..fb359ecc3966 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -366,13 +366,13 @@ int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
+	if (WARN_ON_ONCE(!(info->flags & FBINFO_VIRTFB)))
+		return -EINVAL;
 	if (!try_module_get(THIS_MODULE))
 		return -EINVAL;
 
 	vma->vm_ops = &fb_deferred_io_vm_ops;
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
-	if (!(info->flags & FBINFO_VIRTFB))
-		vm_flags_set(vma, VM_IO);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_private_data = info->fbdefio_state;
 
 	fb_deferred_io_state_get(info->fbdefio_state); /* released in vma->vm_ops->close() */
diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index c4fdecafd856..958514a35433 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -763,6 +763,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
 	info->fix.smem_start = __pa(vmem);
 	info->fix.smem_len = vmem_size;
 
+	info->flags = FBINFO_VIRTFB;
+
 	fb_deferred_io_init(info);
 
 	i2c_set_clientdata(client, info);

-- 
2.55.0

