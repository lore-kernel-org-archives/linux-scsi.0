Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6873F50E5AB;
	Thu, 17 Sep 2026 16:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662670; cv=none; b=mr2lE9wdasA6DN4ilaynFFnbeOLSfUxBMHaEFnAm0HyjUMpwOWhCrhhXHC8Zv1NB8dbOrJWmB4vpkHhZu7BeqC/V3P6HWpDQEUujFeY0oDbpnvlDZBYtA4QJXdqZjdj76pZTpX6vBs1Cg/Fi4UhwHQ4R85GNd8YogWH5MiKFYLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662670; c=relaxed/simple;
	bh=AQdN68/spfXtpTeKBaZ+Me0gdfgYIcDdx+d6akTD8vU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AE8zbzPb1chiO7KfNqJgMxZfY9ZwIDDNDx/WJOaXXDWz1ZMU9sw76pZeCcWEnxvuooNuugnX7IdU47IzvheET+uvl7wUa3dKB14ZL+QkDF1xhUfNp92ozy9+bz7MYoSoE5Xj1wEdj4qvRUlYGTT3et9cLYHYTc3xVzpkLy4Xzco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0PXlPCx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0PXlPCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474621F00898;
	Thu, 17 Sep 2026 16:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662669;
	bh=L7jaJ3XNIQiKLT5qkSlMCmmbkCuTcTW6Guk4wu+FJrg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=V0PXlPCx7005iUwQIzRn8WrFZyyFxtVLov03zt/j4Cb9KmBmrLJgrmIpFAyfapLrd
	 H+8UUkC5mv9ThnEPdrIeBvRjIZCRkR6q8+DWj+26jr/U/1bc099Dt09f3XbstGf0tB
	 GPF/qledlC6JuLnn7ZKiMvsnyi5RO8rzGZHKayPV0lImzjxMdDbwLfhcGBqXR6uGVW
	 sVoxSfdhF2FyDVHTK+GQKY24DJ87K2yGos/VWGWHmcjL23ivX7hPCN7F87RaumZo8V
	 n08M5BJ2yk7qRbIrAGbhKLJVnMQk6AD7IM19ETyOl35+W21+u+ROFzCF9UfcNa1wD3
	 hUJk1gDPbvIzQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:25 +0100
Subject: [PATCH v3 16/40] mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT
 if kernel-owned
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-16-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2269; i=ljs@kernel.org;
 h=from:subject:message-id; bh=AQdN68/spfXtpTeKBaZ+Me0gdfgYIcDdx+d6akTD8vU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB+U/XmtbGsK473bjdP6GHabnKk7IeVwVcs4JsDOL
 zjlgPHCjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExkki3DP3WRy9bveDdY/uc7
 LPb+sUuFZsGHpirJ2GS33v1dZbxT9BgZttZGce3vv72WZ5veMwbrRweunnzCVMCUcfVzwm2X7hc
 tjAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
the underlying file is itself read-only.

This means that mprotect() cannot mark a shared mapping of a read-only file
as read/write, as doing so would violate the read only attribute, and
permit writes.

In general, we do not want file systems to be able to do this for
read/write files.

Doing so would violate fundamental user expectation of file attributes and
likely break userspace.

However, drivers pose a tricky problem here - the /dev/xxx file may be
read/write but provide access to a resource which is fundamentally
read-only.

Therefore we must allow drivers to be able to clear VMA_MAYWRITE_BIT.

To achieve both of these things, restrict this ability to kernel-owned
mappings as identified by vma_flags_is_kernel_owned().

This constrains this ability to drivers which own the mapping's contents,
whether memory-mapped I/O, kernel-allocated pages, or ordinary pages they
map themselves, and so define its semantics.

Every in-tree mmap hook which clears VMA_MAYWRITE_BIT, some twenty sites
across drivers, filesystems and bpf, establishes a kernel-owned mapping,
with usbmon and the ALSA PCM status page converted earlier in this series
to do so.

Note that drivers may, if they do not gate on VMA_SHARED_BIT, be able to
disable MAP_PRIVATE-file-backed mapping CoW semantics.

This is perhaps not always intended, but we retain this capacity to
maintain existing behaviour.

As all drivers which clear VMA_MAYWRITE_BIT establish kernel-owned
mappings, no functional change is intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 62f2ce1ad5a1..1dec10946918 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2795,6 +2795,11 @@ static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
 	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
 		return -EINVAL;
 
+	/* Only kernel-owned mappings may clear VMA_MAYWRITE_BIT. */
+	if (!vma_flags_is_kernel_owned(curr_flags) &&
+	    WARN_ON_ONCE(was_maywrite && !is_maywrite))
+		return -EINVAL;
+
 	return mmap_validate_vma_flags(curr_flags);
 }
 

-- 
2.55.0

