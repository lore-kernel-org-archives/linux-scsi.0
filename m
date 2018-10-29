From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/14] blk-mq: initial support for multiple queue maps
Date: Mon, 29 Oct 2018 10:37:34 -0600
Message-ID: <20181029163738.10172-11-axboe@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-1-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Add a queue offset to the tag map. This enables users to map
iteratively, for each queue map type they support.

Bump maximum number of supported maps to 2, we're now fully
able to support more than 1 map.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq-cpumap.c  | 9 +++++----
 block/blk-mq-pci.c     | 2 +-
 block/blk-mq-virtio.c  | 2 +-
 include/linux/blk-mq.h | 3 ++-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 6e6686c55984..03a534820271 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -14,9 +14,10 @@
 #include "blk.h"
 #include "blk-mq.h"
 
-static int cpu_to_queue_index(unsigned int nr_queues, const int cpu)
+static int cpu_to_queue_index(struct blk_mq_queue_map *qmap,
+			      unsigned int nr_queues, const int cpu)
 {
-	return cpu % nr_queues;
+	return qmap->queue_offset + (cpu % nr_queues);
 }
 
 static int get_first_sibling(unsigned int cpu)
@@ -44,11 +45,11 @@ int blk_mq_map_queues(struct blk_mq_queue_map *qmap)
 		 * performace optimizations.
 		 */
 		if (cpu < nr_queues) {
-			map[cpu] = cpu_to_queue_index(nr_queues, cpu);
+			map[cpu] = cpu_to_queue_index(qmap, nr_queues, cpu);
 		} else {
 			first_sibling = get_first_sibling(cpu);
 			if (first_sibling == cpu)
-				map[cpu] = cpu_to_queue_index(nr_queues, cpu);
+				map[cpu] = cpu_to_queue_index(qmap, nr_queues, cpu);
 			else
 				map[cpu] = map[first_sibling];
 		}
diff --git a/block/blk-mq-pci.c b/block/blk-mq-pci.c
index 40333d60a850..1dce18553984 100644
--- a/block/blk-mq-pci.c
+++ b/block/blk-mq-pci.c
@@ -43,7 +43,7 @@ int blk_mq_pci_map_queues(struct blk_mq_queue_map *qmap, struct pci_dev *pdev,
 			goto fallback;
 
 		for_each_cpu(cpu, mask)
-			qmap->mq_map[cpu] = queue;
+			qmap->mq_map[cpu] = qmap->queue_offset + queue;
 	}
 
 	return 0;
diff --git a/block/blk-mq-virtio.c b/block/blk-mq-virtio.c
index 661fbfef480f..370827163835 100644
--- a/block/blk-mq-virtio.c
+++ b/block/blk-mq-virtio.c
@@ -44,7 +44,7 @@ int blk_mq_virtio_map_queues(struct blk_mq_queue_map *qmap,
 			goto fallback;
 
 		for_each_cpu(cpu, mask)
-			qmap->mq_map[cpu] = queue;
+			qmap->mq_map[cpu] = qmap->queue_offset + queue;
 	}
 
 	return 0;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 837087cf07cc..b5ae2b5677c1 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -78,10 +78,11 @@ struct blk_mq_hw_ctx {
 struct blk_mq_queue_map {
 	unsigned int *mq_map;
 	unsigned int nr_queues;
+	unsigned int queue_offset;
 };
 
 enum {
-	HCTX_MAX_TYPES = 1,
+	HCTX_MAX_TYPES = 2,
 };
 
 struct blk_mq_tag_set {
-- 
2.17.1
