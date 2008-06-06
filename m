From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: Rename scsi_bidi_sdb_cache
Date: Thu, 05 Jun 2008 23:30:03 -0400
Message-ID: <yq18wxjme9w.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:35362 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYFFDaU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 23:30:20 -0400
Received: from agmgw1.us.oracle.com (agmgw1.us.oracle.com [152.68.180.212])
	by rgminet01.oracle.com (Switch-3.2.4/Switch-3.1.6) with ESMTP id m563UHJ9029095
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jun 2008 21:30:18 -0600
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by agmgw1.us.oracle.com (Switch-3.2.0/Switch-3.2.0) with ESMTP id m55KnJEh009001
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jun 2008 21:30:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The data integrity changes need to dynamically allocate
scsi_data_buffers too.  Rename scsi_bidi_sdb_cache for clarity.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r c972c82ff7c6 drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Mon Feb 04 02:42:39 2008 -0500
+++ b/drivers/scsi/scsi_lib.c	Mon Feb 04 02:57:32 2008 -0500
@@ -65,7 +65,7 @@ static struct scsi_host_sg_pool scsi_sg_
 };
 #undef SP
 
-static struct kmem_cache *scsi_bidi_sdb_cache;
+static struct kmem_cache *scsi_sdb_cache;
 
 static void scsi_run_queue(struct request_queue *q);
 
@@ -772,7 +772,7 @@ void scsi_release_buffers(struct scsi_cm
 		struct scsi_data_buffer *bidi_sdb =
 			cmd->request->next_rq->special;
 		scsi_free_sgtable(bidi_sdb);
-		kmem_cache_free(scsi_bidi_sdb_cache, bidi_sdb);
+		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
 		cmd->request->next_rq->special = NULL;
 	}
 }
@@ -1049,7 +1049,7 @@ int scsi_init_io(struct scsi_cmnd *cmd, 
 
 	if (blk_bidi_rq(cmd->request)) {
 		struct scsi_data_buffer *bidi_sdb = kmem_cache_zalloc(
-			scsi_bidi_sdb_cache, GFP_ATOMIC);
+			scsi_sdb_cache, GFP_ATOMIC);
 		if (!bidi_sdb) {
 			error = BLKPREP_DEFER;
 			goto err_exit;
@@ -1677,11 +1677,11 @@ int __init scsi_init_queue(void)
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
 
@@ -1694,7 +1694,7 @@ int __init scsi_init_queue(void)
 		if (!sgp->slab) {
 			printk(KERN_ERR "SCSI: can't init sg slab %s\n",
 					sgp->name);
-			goto cleanup_bidi_sdb;
+			goto cleanup_sdb;
 		}
 
 		sgp->pool = mempool_create_slab_pool(SG_MEMPOOL_SIZE,
@@ -1702,13 +1702,13 @@ int __init scsi_init_queue(void)
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
@@ -1716,7 +1716,7 @@ cleanup_bidi_sdb:
 		if (sgp->slab)
 			kmem_cache_destroy(sgp->slab);
 	}
-	kmem_cache_destroy(scsi_bidi_sdb_cache);
+	kmem_cache_destroy(scsi_sdb_cache);
 cleanup_io_context:
 	kmem_cache_destroy(scsi_io_context_cache);
 
@@ -1728,7 +1728,7 @@ void scsi_exit_queue(void)
 	int i;
 
 	kmem_cache_destroy(scsi_io_context_cache);
-	kmem_cache_destroy(scsi_bidi_sdb_cache);
+	kmem_cache_destroy(scsi_sdb_cache);
 
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;


