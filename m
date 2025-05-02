Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF84B266581;
	Fri,  2 May 2025 06:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746168593; cv=none; b=am9F7bTeTVM41/d07ecCWxA03G+jczWg1a5tz73xM+8dxv9gWORH9/v1l77+03bMk8nx2MnrmVfOJXMHO1iCZQymLsXHA4fJwHuMMhl14sljwBeQCl3mSsjceJbXiaVOC5njyqwbhjrIWeQsLqYBJp5MLsmXUEm9tlMrRwuVNl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746168593; c=relaxed/simple;
	bh=1lWCpmASBkK924/7jJLz5e2c6unvL106KVoor8LqoI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLsIPIzyzsR0raZObYeJ5JlKbPUH78AVsHWQJXUzacdFFwwFDLuJcDCErO3BpLgTRfkTBdeT9fyi65lOTTu2eE/6vIraI5LmlwpFaADfLK+nydJDNmOdhGnD6gRhLcHqghOspv+N1ksckNa+n5dEvYLpniNd2vc4ZWVoWk3UmCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1l/tBuFS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1l/tBuFS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pmkmrZp/v2r7YXacZ37i5GXFUiZ8QGj+39EQV0YIZ1A=; b=1l/tBuFSvjow20r4IxavImVI1G
	Pqceo77c9f7FzXAOb166YUE98dQOQX57lbMjZvQDFXIP/pgYnpROMt3mqJrZ5UdkqAadKpNBhpoEq
	dFsHGUBO1LRIayqyEXOLTXNeQ7Rt1HzLdtYB6DT+d/QEbAyVrYsmIkntndecm6FfaT2gZX2ui9Rse
	zrubul71FfZ4InMrwHtFL5bQr+z8T+rMaBIXcxc7twu6qwpxJ2jhXh0qCcSe8yt30aDhoTU7yzfuU
	M5kyCND1jhCNLk1m6fyVM6uyc1J8frATpmFdn8hW2IQz9msgRwAUTFxhvaujt+86JQloHAIwA5aLD
	Ewpmf7MA==;
Received: from [185.143.37.16] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAkDV-0000000117Q-3K8m;
	Fri, 02 May 2025 06:49:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-mm@kvack.org
Subject: [PATCH 7/7] mm: remove NR_BOUNCE zone stat
Date: Fri,  2 May 2025 07:49:24 +0100
Message-ID: <20250502064930.2981820-8-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250502064930.2981820-1-hch@lst.de>
References: <20250502064930.2981820-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The stat is always 0 now, so remove it and hardwire the user visible
output to 0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/base/node.c    | 2 +-
 fs/proc/meminfo.c      | 3 +--
 include/linux/mmzone.h | 1 -
 mm/show_mem.c          | 4 ++--
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index cd13ef287011..618712071a1e 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -468,7 +468,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     nid, K(node_page_state(pgdat, NR_PAGETABLE)),
 			     nid, K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
 			     nid, 0UL,
-			     nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
+			     nid, 0UL,
 			     nid, K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			     nid, K(sreclaimable +
 				    node_page_state(pgdat, NR_KERNEL_MISC_RECLAIMABLE)),
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 83be312159c9..bc2bc60c36cc 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -120,8 +120,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		    global_node_page_state(NR_SECONDARY_PAGETABLE));
 
 	show_val_kb(m, "NFS_Unstable:   ", 0);
-	show_val_kb(m, "Bounce:         ",
-		    global_zone_page_state(NR_BOUNCE));
+	show_val_kb(m, "Bounce:         ", 0);
 	show_val_kb(m, "WritebackTmp:   ",
 		    global_node_page_state(NR_WRITEBACK_TEMP));
 	show_val_kb(m, "CommitLimit:    ", vm_commit_limit());
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6ccec1bf2896..b1c459f7a485 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -148,7 +148,6 @@ enum zone_stat_item {
 	NR_ZONE_WRITE_PENDING,	/* Count of dirty, writeback and unstable pages */
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
 	/* Second 128 byte cacheline */
-	NR_BOUNCE,
 #if IS_ENABLED(CONFIG_ZSMALLOC)
 	NR_ZSPAGES,		/* allocated in zsmalloc */
 #endif
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 6af13bcd2ab3..5acb51a9fc49 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -223,7 +223,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 		global_node_page_state(NR_SHMEM),
 		global_node_page_state(NR_PAGETABLE),
 		global_node_page_state(NR_SECONDARY_PAGETABLE),
-		global_zone_page_state(NR_BOUNCE),
+		0UL,
 		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE),
 		global_zone_page_state(NR_FREE_PAGES),
 		free_pcp,
@@ -341,7 +341,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 			K(zone->present_pages),
 			K(zone_managed_pages(zone)),
 			K(zone_page_state(zone, NR_MLOCK)),
-			K(zone_page_state(zone, NR_BOUNCE)),
+			0UL,
 			K(free_pcp),
 			K(this_cpu_read(zone->per_cpu_pageset->count)),
 			K(zone_page_state(zone, NR_FREE_CMA_PAGES)));
-- 
2.47.2

