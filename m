Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6191F1936;
	Mon,  5 May 2025 08:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746432726; cv=none; b=HzKkl5s4IFqVgdva1Oq4fJKUGtjYyFQGFR2CEjjZElZKf4iNBTV5yxVVYUvHAePs0isnCjqBC++SKmXqR5UOQbiHb0Rt6w8isSx8dmfEgsaB/ZIr+5jTLISwaucxDRZQ9gWI+Q2vHGYwr/Gd+28Zz1w+WL6a1eocp3cB9gUl2Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746432726; c=relaxed/simple;
	bh=1zVN+xIjzBc6r95Ek2ZLZ6eKl04IQcO8Ingr9kQRn0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMrN+lsVOpsy/Xx6MFTkx4980QSUwo/uqI9dimclc0zTUi5rCMIK7GbTKbvuY00y93NWmXQbIv4IBjd37+x2X5K3Oh/2G46g6A1SsO/ZXhBwM1toxFPFgdUwVwrtdEPXUR/M/WZSNCX75xJozjeWC3dCrG0mKL8Iut8LuGoMZk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iHhzDuj3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iHhzDuj3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wODqmHTHx7WBWPwc1/eP5FfzwUfd9WEhL1rHfNg6Hgc=; b=iHhzDuj3hAaxNoGYCzKKu+ZYTV
	8LYcYy6IW/jGQu/ddFeYW6eRXb1suNkIwVP+TfS2/FYOJLDFDIEevqlwFqpCOZrnGekRo3QixTiPW
	uVeRoZStlr/DEtkbnmcvFTophuZU9ozZ2ZRD6KpSX9mAjvtJyn60BxUusDEckK7eFy81+rLvun2Lx
	tdeHQEceZxQypxZTu8yUI0ekx1twbdWN8BVi7cFb+ZUgZCjw9+Je+KkfbSBkdNis/PuQAJMWdNfVq
	opLcHr/a8nk13DMmytZD+FXtRgwlcMHykByvyaO6eiBlRCZOAAqQ5c5U79lwmV4JbTqCwiaExIEvw
	mFRtAqCQ==;
Received: from 2a02-8389-2341-5b80-f2ef-69c9-6274-23a2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f2ef:69c9:6274:23a2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uBqvi-00000006kZi-3rFk;
	Mon, 05 May 2025 08:12:03 +0000
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
	linux-mm@kvack.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/7] mm: remove NR_BOUNCE zone stat
Date: Mon,  5 May 2025 10:11:26 +0200
Message-ID: <20250505081138.3435992-8-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505081138.3435992-1-hch@lst.de>
References: <20250505081138.3435992-1-hch@lst.de>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

