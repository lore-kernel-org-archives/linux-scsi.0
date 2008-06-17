From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1 of 4] scsi: Rename scsi_bidi_sdb_cache
Date: Tue, 17 Jun 2008 12:47:31 -0400
Message-ID: <55f361a1749438a7f414.1213721251@sermon.lab.mkp.net>
References: <patchbomb.1213721250@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41666 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbYFQQ61 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2008 12:58:27 -0400
In-Reply-To: <patchbomb.1213721250@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The data integrity changes need to dynamically allocate
scsi_data_buffers too.  Rename scsi_bidi_sdb_cache for clarity.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
1 file changed, 13 insertions(+), 13 deletions(-)
drivers/scsi/scsi_lib.c |   26 +++++++++++++-------------



diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -65,7 +65,7 @@ static struct scsi_host_sg_pool scsi_sg_
 };
 #undef SP
 
-static struct kmem_cache *scsi_bidi_sdb_cache;
+static struct kmem_cache *scsi_sdb_cache;
 
 static void scsi_run_queue(struct request_queue *q);
 
@@ -775,7 +775,7 @@ void scsi_release_buffers(struct scsi_cm
 		struct scsi_data_buffer *bidi_sdb =
 			cmd->request->next_rq->special;
 		scsi_free_sgtable(bidi_sdb);
-		kmem_cache_free(scsi_bidi_sdb_cache, bidi_sdb);
+		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
 		cmd->request->next_rq->special = NULL;
 	}
 }
@@ -1050,7 +1050,7 @@ int scsi_init_io(struct scsi_cmnd *cmd, 
 
 	if (blk_bidi_rq(cmd->request)) {
 		struct scsi_data_buffer *bidi_sdb = kmem_cache_zalloc(
-			scsi_bidi_sdb_cache, GFP_ATOMIC);
+			scsi_sdb_cache, GFP_ATOMIC);
 		if (!bidi_sdb) {
 			error = BLKPREP_DEFER;
 			goto err_exit;
@@ -1684,11 +1684,11 @@ int __init scsi_init_queue(void)
 		return -ENOMEM;
 	}
 
-	scsi_bidi_sdb_cache = kmem_cache_create("scsi_bidi_sdb",
-					sizeof(struct scsi_data_buffer),
-					0, 0, NULL);
-	if (!scsi_bidi_sdb_cache) {
-		printk(KERN_ERR "SCSI: can't init scsi bidi sdb cache\n");
+	scsi_sdb_cache = kmem_cache_create("scsi_data_buffer",
+					   sizeof(struct scsi_data_buffer),
+					   0, 0, NULL);
+	if (!scsi_sdb_cache) {
+		printk(KERN_ERR "SCSI: can't init scsi sdb cache\n");
 		goto cleanup_io_context;
 	}
 
@@ -1701,7 +1701,7 @@ int __init scsi_init_queue(void)
 		if (!sgp->slab) {
 			printk(KERN_ERR "SCSI: can't init sg slab %s\n",
 					sgp->name);
-			goto cleanup_bidi_sdb;
+			goto cleanup_sdb;
 		}
 
 		sgp->pool = mempool_create_slab_pool(SG_MEMPOOL_SIZE,
@@ -1709,13 +1709,13 @@ int __init scsi_init_queue(void)
 		if (!sgp->pool) {
 			printk(KERN_ERR "SCSI: can't init sg mempool %s\n",
 					sgp->name);
-			goto cleanup_bidi_sdb;
+			goto cleanup_sdb;
 		}
 	}
 
 	return 0;
 
-cleanup_bidi_sdb:
+cleanup_sdb:
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
 		if (sgp->pool)
@@ -1723,7 +1723,7 @@ cleanup_bidi_sdb:
 		if (sgp->slab)
 			kmem_cache_destroy(sgp->slab);
 	}
-	kmem_cache_destroy(scsi_bidi_sdb_cache);
+	kmem_cache_destroy(scsi_sdb_cache);
 cleanup_io_context:
 	kmem_cache_destroy(scsi_io_context_cache);
 
@@ -1735,7 +1735,7 @@ void scsi_exit_queue(void)
 	int i;
 
 	kmem_cache_destroy(scsi_io_context_cache);
-	kmem_cache_destroy(scsi_bidi_sdb_cache);
+	kmem_cache_destroy(scsi_sdb_cache);
 
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;


