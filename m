Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6DC519E0E;
	Thu, 17 Sep 2026 16:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662548; cv=none; b=WYEKOQ4iORPvPGq2v+lC4VnWx8GxP8LQhVWoKrKNN7ph5yiKPJl/ENdjORwsMFFpvzch0MBdGFTVkIjsaRHErVgw5RMFjsVMZJ6iJ4ik+TEReXXviVAD3OhR2Ai6YZLk2dfULs/TIes4psaUzU6gxQ26d5UrwneRdr49p8gqmsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662548; c=relaxed/simple;
	bh=X46vXp5xg8nLI6IG+V/Ab12M7pEZi9uJqKdEh54QAaM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kTi+wRodsrliP/eWx6waSKOx1dibr6/4KfMu9Ne+UlZyiL5206KENY7W866ZJEfP40VtFgtTWlyGyKYTokqJlQOFnkbVBF0yw334wuZoMRaj4vzu8wxeXw/u+qhhTmfwQWZiDsmZrTzKuZifpvoHojpHGmaQBHJs6PAnuno4Hbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HypnJxB5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HypnJxB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE821F00898;
	Thu, 17 Sep 2026 16:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662546;
	bh=qivR91Lb5/7S8p3yp1PCCxRNqvAnmMyhYSRWXpH7C6E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HypnJxB5nIvhdu/4lyn5V2mzaHKgTstFT3NwAe1e5+ZqghSmo2Hj7mjOK5CoYdPTx
	 PARyOmBlb+YzHiiTbiLYqT+yzZYIAG1LQnY4c8bg49GVruVJRAH7a6NjefXjko9YKe
	 9r3cgnvRiFC1xOnahoCdXU8zbumCPYOfyFGs4CNmNaflrU5KmEGeqQTv6WftryliCv
	 CRL4rfF58Fu402gQsvBPnH8MGc7bjyLyzMq12dc+KlyivUJWTpRdYhUPAbO0MiuYkb
	 PKD1LFiaRtReUNXpDsNBS9Zzu0GWIjj5xX+3hcbxhXXBLaGJKY68gTeOSmcn1LIJG2
	 /RIfIU50StAcQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:21 +0100
Subject: [PATCH v3 12/40] selinux: reject writable opens of policy file,
 drop mmap shared/write check
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-12-4583d8a23bca@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1924; i=ljs@kernel.org;
 h=from:subject:message-id; bh=X46vXp5xg8nLI6IG+V/Ab12M7pEZi9uJqKdEh54QAaM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB/4+lNC4kLT9Xfr2cNNWOx/bZBxCA3lc/ddrff0/
 HctqbfsHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIwDKGn4wMy14xmso2pPDv
 D3n68b3oKp3jKyvnaKX67T30WCys7jQjw36LHf1Lmqed1JoeuUrratDu63IFu0+J/2G76s1hYfO
 rihkA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

The policy file has no write method and is exposed read-only (S_IRUGO in
selinux_files[]), yet sel_open_policy() performs no open mode check, so a
CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
kernfs does.

The file can then never be mapped with FMODE_WRITE, so do_mmap() always
clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
check in sel_mmap_policy() cannot be reached. Remove it.

This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that is
neither a PFN map nor a mixed map, ahead of the core enforcing that only
such mappings may do so.

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 security/selinux/selinuxfs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index c7d91476971c..545a6f89f9e7 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -340,6 +340,9 @@ static int sel_open_policy(struct inode *inode, struct file *filp)
 	struct policy_load_memory *plm = NULL;
 	int rc;
 
+	if (filp->f_mode & FMODE_WRITE)
+		return -EACCES;
+
 	rc = avc_has_perm(current_sid(), SECINITSID_SECURITY,
 			  SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL);
 	if (rc)
@@ -424,14 +427,6 @@ static const struct vm_operations_struct sel_mmap_policy_ops = {
 
 static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED) {
-		/* do not allow mprotect to make mapping writable */
-		vm_flags_clear(vma, VM_MAYWRITE);
-
-		if (vma->vm_flags & VM_WRITE)
-			return -EACCES;
-	}
-
 	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &sel_mmap_policy_ops;
 

-- 
2.55.0

