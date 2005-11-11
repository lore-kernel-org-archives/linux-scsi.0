From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 5/5] add kmemcache for scsi_io_context
Date: Fri, 11 Nov 2005 05:31:41 -0600
Message-ID: <1131708701.3066.28.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32694 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750738AbVKKLcA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 06:32:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Add kmemcache of scsi io contexts.

In the future when we finalize on where these functions will live
we can add a mempool for it and do a bioset for out REQ_BLOCK_PC
bios. This is needed becuase the dm-multipath handlers will
want to use the scsi_exectute* functions for failover and we cannot
have them and the bio device allocating from the same mempool.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 80d3414..f665601 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -306,6 +306,8 @@ struct scsi_io_context {
 	char sense[SCSI_SENSE_BUFFERSIZE];
 };
 
+static kmem_cache_t *scsi_io_context_cache;
+
 static void scsi_end_async(struct request *req)
 {
 	struct scsi_io_context *sioc = req->end_io_data;
@@ -313,7 +315,7 @@ static void scsi_end_async(struct reques
 	if (sioc->done)
 		sioc->done(sioc->data, sioc->sense, req->errors, req->data_len);
 
-	kfree(sioc);
+	kmem_cache_free(scsi_io_context_cache, sioc);
 	__blk_put_request(req->q, req);
 }
 
@@ -452,9 +454,10 @@ int scsi_execute_async(struct scsi_devic
 	int err = 0;
 	int write = (data_direction == DMA_TO_DEVICE);
 
-	sioc = kzalloc(sizeof(*sioc), gfp);
+	sioc = kmem_cache_alloc(scsi_io_context_cache, gfp);
 	if (!sioc)
 		return DRIVER_ERROR << 24;
+	memset(sioc, 0, sizeof(*sioc));
 
 	req = blk_get_request(sdev->request_queue, write, gfp);
 	if (!req)
@@ -1764,6 +1767,14 @@ int __init scsi_init_queue(void)
 {
 	int i;
 
+	scsi_io_context_cache = kmem_cache_create("scsi_io_context",
+					sizeof(struct scsi_io_context),
+					0, 0, NULL, NULL);
+	if (!scsi_io_context_cache) {
+		printk(KERN_ERR "SCSI: can't init scsi io context cache\n");
+		return -ENOMEM;
+	}
+
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
 		int size = sgp->size * sizeof(struct scatterlist);
@@ -1791,6 +1802,8 @@ void scsi_exit_queue(void)
 {
 	int i;
 
+	kmem_cache_destroy(scsi_io_context_cache);
+
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
 		mempool_destroy(sgp->pool);


