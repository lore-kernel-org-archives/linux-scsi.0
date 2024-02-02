Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285B3481AF;
	Fri,  2 Feb 2024 07:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859099; cv=none; b=Fer5gc3vS4I8Kdiy9RC+iOPrzVVRUohggIOcR6ZDlORB8xVfwgSaNhP5UxdSoZD6C5LS3x2j8lgO0gN8Ten9ZhAoSW2sjODAQiiNW4yf0/ZZVqVSK/aUGXyZlyZ0S5Ww2qXgjTvsjL/VQB9WKksWoHuSpkQ63bVaPoO7lPinzlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859099; c=relaxed/simple;
	bh=yLw1qVSgBpZMyDDhKF05YmDnrRv59lkLbAmdcDF/Pco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FR6qX+aQapwWclbUWminoWXpKF8Z7zI4YEPlwOEBGuIT9L/noca+Q0zaSH2Vfw8fA5diIsWZS3fpfP85bMBcFnGfdPdHYc6SdrCe/XtBLEQKh11zA3ujB645QlkrqOlA+Fi/DkSp6YM+SYgw0NAbkUGzPPdZ/ECk/TfHBCal1xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YqSSfuOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YqSSfuOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ABBC433F1;
	Fri,  2 Feb 2024 07:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859098;
	bh=yLw1qVSgBpZMyDDhKF05YmDnrRv59lkLbAmdcDF/Pco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqSSfuOK+o9oG/0f0dCSlii98+5ESxx2DqT2FycL8KEgEwHQszVwR6jGMXGrdC2mg
	 s5xJwT4/1zb00gEPeLQCD4H24+qwJlxKOnmcd0qTArUeCU1ZBd1YjYjLcpKJyaaxyF
	 QWW//MszaEQSFpTcqkR8D+nVYSn0t9Jzo1aJSTf1RjpDzqwkcEPfw3GuprazFophWJ
	 YJ9Vusf0gtR0+WYT4aE0NI5mBwAAobmgAFaK6rA+peXLNahkXBJ6cOPwQQzJt8C4FW
	 qSXABXbKtrF4gclFwMs81eY40i8WdfBeOoyPlIFdR926c9pciBl8O6DDmISL9/riy5
	 +cp008QhaNTLA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/26] block: Move zone related debugfs attribute to blk-zoned.c
Date: Fri,  2 Feb 2024 16:31:00 +0900
Message-ID: <20240202073104.2418230-23-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
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
index 3dadf37ad787..bac642e26a3e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -20,6 +20,7 @@
 
 #include "blk.h"
 #include "blk-mq-sched.h"
+#include "blk-mq-debugfs.h"
 
 #define ZONE_COND_NAME(name) [BLK_ZONE_COND_##name] = #name
 static const char *const zone_cond_name[] = {
@@ -1418,3 +1419,22 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
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
2.43.0

