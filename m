Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F471C68D;
	Wed,  3 Jul 2024 23:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720049977; cv=none; b=Er7vIlZG1xvAJdSDQBn7mgMmFuOeJmfwYO3uuZgMaKxLtgurlJe78hi3A12NHtuHjQAiIyxDxSeBUMMJ2fxj509TSZ+R5meBrdugFtFNYy+RjS4WTwUFBm+78C+xsQM+NO27ibz4i/9TaXssfnLp0krdSyBp9kjgn38DhMS69iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720049977; c=relaxed/simple;
	bh=+oT0s1t6ne+ViPC+N118LF7b5geXlthDWRxaWUk/t2E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wmh4i2Ub9L6ye3NyE5kbb0zk7ehh0d1/IT/OnGXvPscU6nl5fWA/VjRo3FCn5qwBYd1khqz7Kni2RW1k4MbrM41JUdXR8jtYNjo2im3A7TH+NRjD8K9KCbt1ZhAltqdbxX0n9XGVUCIgYzsXYX0PS/2vtQXTjaMnvGcV+TQix2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvZ3fyyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvZ3fyyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC4CC4AF0A;
	Wed,  3 Jul 2024 23:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720049976;
	bh=+oT0s1t6ne+ViPC+N118LF7b5geXlthDWRxaWUk/t2E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LvZ3fyyD6NJFGE/tEwe5JE/Sxv6k3bc9Mx/KnSR+h7REM/wPMpoSSl19LeJnETBa7
	 qveOIdLcrkBD/4Itp7CATIwv+16DwbhYV5t8d1gZi8eS3/EBoZZ075dMO0vydjMYlQ
	 vYRk+i+SJ6AVAh+vIshKJtDpfdCNy8KSMGLZueUlzyosk+vSD36Db9tkk6HGjsT3Nf
	 B5YxadQSBtAurgV2Xq+rY+XvrXls0NFR+IdA/00z78mcJOym3j1iq7Ba3MQYoxqKGK
	 btp0WkqGtsdCrj0oNRktnZYGxJZEDENt4nD85qp+cthLOd8iIwK9WXgeCLtnznVy8M
	 aboHkE6TUE7Fg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] null_blk: Introduce the zone_full parameter
Date: Thu,  4 Jul 2024 08:39:28 +0900
Message-ID: <20240703233932.545228-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703233932.545228-1-dlemoal@kernel.org>
References: <20240703233932.545228-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow creating a zoned null_blk device with the initial state of its
sequential write required zones to be FULL. This is convenient to avoid
having to first write these zones to perform read performance evaluation
or test zone management operations such as zone reset (and zone reset
all).

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/block/null_blk/main.c     |  9 ++++++++-
 drivers/block/null_blk/null_blk.h |  1 +
 drivers/block/null_blk/zoned.c    | 10 ++++++++--
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 5de9ca4eceb4..783f730efff4 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -262,6 +262,10 @@ module_param_named(zone_append_max_sectors, g_zone_append_max_sectors, int, 0444
 MODULE_PARM_DESC(zone_append_max_sectors,
 		 "Maximum size of a zone append command (in 512B sectors). Specify 0 for zone append emulation");
 
+static bool g_zone_full;
+module_param_named(zone_full, g_zone_full, bool, S_IRUGO);
+MODULE_PARM_DESC(zone_full, "Initialize the sequential write required zones of a zoned device to be full. Default: false");
+
 static struct nullb_device *null_alloc_dev(void);
 static void null_free_dev(struct nullb_device *dev);
 static void null_del_dev(struct nullb *nullb);
@@ -458,6 +462,7 @@ NULLB_DEVICE_ATTR(zone_nr_conv, uint, NULL);
 NULLB_DEVICE_ATTR(zone_max_open, uint, NULL);
 NULLB_DEVICE_ATTR(zone_max_active, uint, NULL);
 NULLB_DEVICE_ATTR(zone_append_max_sectors, uint, NULL);
+NULLB_DEVICE_ATTR(zone_full, bool, NULL);
 NULLB_DEVICE_ATTR(virt_boundary, bool, NULL);
 NULLB_DEVICE_ATTR(no_sched, bool, NULL);
 NULLB_DEVICE_ATTR(shared_tags, bool, NULL);
@@ -610,6 +615,7 @@ static struct configfs_attribute *nullb_device_attrs[] = {
 	&nullb_device_attr_zone_append_max_sectors,
 	&nullb_device_attr_zone_readonly,
 	&nullb_device_attr_zone_offline,
+	&nullb_device_attr_zone_full,
 	&nullb_device_attr_virt_boundary,
 	&nullb_device_attr_no_sched,
 	&nullb_device_attr_shared_tags,
@@ -700,7 +706,7 @@ static ssize_t memb_group_features_show(struct config_item *item, char *page)
 			"shared_tags,size,submit_queues,use_per_node_hctx,"
 			"virt_boundary,zoned,zone_capacity,zone_max_active,"
 			"zone_max_open,zone_nr_conv,zone_offline,zone_readonly,"
-			"zone_size,zone_append_max_sectors\n");
+			"zone_size,zone_append_max_sectors,zone_full\n");
 }
 
 CONFIGFS_ATTR_RO(memb_group_, features);
@@ -781,6 +787,7 @@ static struct nullb_device *null_alloc_dev(void)
 	dev->zone_max_open = g_zone_max_open;
 	dev->zone_max_active = g_zone_max_active;
 	dev->zone_append_max_sectors = g_zone_append_max_sectors;
+	dev->zone_full = g_zone_full;
 	dev->virt_boundary = g_virt_boundary;
 	dev->no_sched = g_no_sched;
 	dev->shared_tags = g_shared_tags;
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 3234e6c85eed..a7bb32f73ec3 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -101,6 +101,7 @@ struct nullb_device {
 	bool memory_backed; /* if data is stored in memory */
 	bool discard; /* if support discard */
 	bool zoned; /* if device is zoned */
+	bool zone_full; /* Initialize zones to be full */
 	bool virt_boundary; /* virtual boundary on/off for the device */
 	bool no_sched; /* no IO scheduler for the device */
 	bool shared_tags; /* share tag set between devices for blk-mq */
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 9f7151ad93cf..7996e2e7dce2 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -145,7 +145,7 @@ int null_init_zoned_dev(struct nullb_device *dev,
 		zone = &dev->zones[i];
 
 		null_init_zone_lock(dev, zone);
-		zone->start = zone->wp = sector;
+		zone->start = sector;
 		if (zone->start + dev->zone_size_sects > dev_capacity_sects)
 			zone->len = dev_capacity_sects - zone->start;
 		else
@@ -153,7 +153,13 @@ int null_init_zoned_dev(struct nullb_device *dev,
 		zone->capacity =
 			min_t(sector_t, zone->len, zone_capacity_sects);
 		zone->type = BLK_ZONE_TYPE_SEQWRITE_REQ;
-		zone->cond = BLK_ZONE_COND_EMPTY;
+		if (dev->zone_full) {
+			zone->cond = BLK_ZONE_COND_FULL;
+			zone->wp = zone->start + zone->capacity;
+		} else{
+			zone->cond = BLK_ZONE_COND_EMPTY;
+			zone->wp = zone->start;
+		}
 
 		sector += dev->zone_size_sects;
 	}
-- 
2.45.2

