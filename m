Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055D21272BC;
	Tue,  2 Apr 2024 12:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061584; cv=none; b=iz4KYWf5jr46Zd8pLIFOm1bZxoi6Fy/36/7J1KhaW/j8dVlcqIZW5ZGSIepL6MrWu/a5Gi4aKgTbkxsIzoIRqquhJqfHbfF4COdLzQNx/w7cCB7llxGZv35PPIN9KQ/ziY7g/5TBjZlKfdlfOgIHw8cVTb1r4YwvAW2usBhYzFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061584; c=relaxed/simple;
	bh=f9LOcjPpZWUNyf5RI7zHoFOwYAtPGLvRYpdeC5XwLtA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YObkA29xwQoYw+EPvea1GF0Zp0yPQ6Q0u/uvVkmGSPInOUQB2YsWfBXs7nLieelFpsSp5thlzZJzWcecexscehEe51lWXVpWnBno8J3JzXNEhxfxn6x3Bv1d5mwIVCDxNkrnGh0kS/uNcRwUKoN5LlRuWZgV1TPaWtavpbD/yOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A5x17ke9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A5x17ke9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9520C43394;
	Tue,  2 Apr 2024 12:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712061583;
	bh=f9LOcjPpZWUNyf5RI7zHoFOwYAtPGLvRYpdeC5XwLtA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=A5x17ke9jpa3Ko1XX5zXX9u+Ap3AeUMrNIQDew6Dv8QEUNvtiGvVdVOMtaPAPyMjA
	 X/pfkXnSHp01ly/tgxU9stRvzkJqAnT/x/TBs6jStb4TnsQzaxmLxTV5z3SMWhdHb+
	 q+Ikkk0lKjQ1mr29vM/+Jx1NGwbjvIZ+XgiPEy+JTA2Zd7t0qFX06Hj2Ox7jnM00bT
	 mym4o335sIFXrSFEbIhB3gFytziVaBThb3inCA7eF7LszkiU9U21GuNT3Z14JmUlqj
	 7HhrUdSLCIcAebZrd4ERf/LPx1/1AYPTfG4c55rEZc04Vctv1e6e4XJaNvTgkp6wmQ
	 hraitV3Q15CAg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 24/28] block: Move zone related debugfs attribute to blk-zoned.c
Date: Tue,  2 Apr 2024 21:39:03 +0900
Message-ID: <20240402123907.512027-25-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240402123907.512027-1-dlemoal@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

block/blk-mq-debugfs-zone.c contains a single debugfs attribute
function. Defining this outside of block/blk-zoned.c does not really
help in any way, so move this zone related debugfs attribute to
block/blk-zoned.c and delete block/blk-mq-debugfs-zone.c.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 block/Kconfig                |  4 ----
 block/Makefile               |  1 -
 block/blk-mq-debugfs-zoned.c | 22 ----------------------
 block/blk-mq-debugfs.h       |  2 +-
 block/blk-zoned.c            | 20 ++++++++++++++++++++
 5 files changed, 21 insertions(+), 28 deletions(-)
 delete mode 100644 block/blk-mq-debugfs-zoned.c

diff --git a/block/Kconfig b/block/Kconfig
index 1de4682d48cc..9f647149fbee 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -198,10 +198,6 @@ config BLK_DEBUG_FS
 	Unless you are building a kernel for a tiny system, you should
 	say Y here.
 
-config BLK_DEBUG_FS_ZONED
-       bool
-       default BLK_DEBUG_FS && BLK_DEV_ZONED
-
 config BLK_SED_OPAL
 	bool "Logic for interfacing with Opal enabled SEDs"
 	depends on KEYS
diff --git a/block/Makefile b/block/Makefile
index 46ada9dc8bbf..168150b9c510 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -33,7 +33,6 @@ obj-$(CONFIG_BLK_MQ_VIRTIO)	+= blk-mq-virtio.o
 obj-$(CONFIG_BLK_DEV_ZONED)	+= blk-zoned.o
 obj-$(CONFIG_BLK_WBT)		+= blk-wbt.o
 obj-$(CONFIG_BLK_DEBUG_FS)	+= blk-mq-debugfs.o
-obj-$(CONFIG_BLK_DEBUG_FS_ZONED)+= blk-mq-debugfs-zoned.o
 obj-$(CONFIG_BLK_SED_OPAL)	+= sed-opal.o
 obj-$(CONFIG_BLK_PM)		+= blk-pm.o
 obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o \
diff --git a/block/blk-mq-debugfs-zoned.c b/block/blk-mq-debugfs-zoned.c
deleted file mode 100644
index a77b099c34b7..000000000000
--- a/block/blk-mq-debugfs-zoned.c
+++ /dev/null
@@ -1,22 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (C) 2017 Western Digital Corporation or its affiliates.
- */
-
-#include <linux/blkdev.h>
-#include "blk-mq-debugfs.h"
-
-int queue_zone_wlock_show(void *data, struct seq_file *m)
-{
-	struct request_queue *q = data;
-	unsigned int i;
-
-	if (!q->disk->seq_zones_wlock)
-		return 0;
-
-	for (i = 0; i < q->disk->nr_zones; i++)
-		if (test_bit(i, q->disk->seq_zones_wlock))
-			seq_printf(m, "%u\n", i);
-
-	return 0;
-}
diff --git a/block/blk-mq-debugfs.h b/block/blk-mq-debugfs.h
index 9c7d4b6117d4..3ebe2c29b624 100644
--- a/block/blk-mq-debugfs.h
+++ b/block/blk-mq-debugfs.h
@@ -83,7 +83,7 @@ static inline void blk_mq_debugfs_unregister_rqos(struct rq_qos *rqos)
 }
 #endif
 
-#ifdef CONFIG_BLK_DEBUG_FS_ZONED
+#if defined(CONFIG_BLK_DEV_ZONED) && defined(CONFIG_BLK_DEBUG_FS)
 int queue_zone_wlock_show(void *data, struct seq_file *m);
 #else
 static inline int queue_zone_wlock_show(void *data, struct seq_file *m)
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index b0fafbb5b3f9..8ba05d468604 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -22,6 +22,7 @@
 
 #include "blk.h"
 #include "blk-mq-sched.h"
+#include "blk-mq-debugfs.h"
 
 #define ZONE_COND_NAME(name) [BLK_ZONE_COND_##name] = #name
 static const char *const zone_cond_name[] = {
@@ -1819,3 +1820,22 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
+
+#ifdef CONFIG_BLK_DEBUG_FS
+
+int queue_zone_wlock_show(void *data, struct seq_file *m)
+{
+	struct request_queue *q = data;
+	unsigned int i;
+
+	if (!q->disk->seq_zones_wlock)
+		return 0;
+
+	for (i = 0; i < q->disk->nr_zones; i++)
+		if (test_bit(i, q->disk->seq_zones_wlock))
+			seq_printf(m, "%u\n", i);
+
+	return 0;
+}
+
+#endif
-- 
2.44.0

