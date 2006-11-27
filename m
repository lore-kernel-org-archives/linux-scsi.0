From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Mon, 27 Nov 2006 19:44:54 +0200
Message-ID: <456B2416.7000101@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:23490 "EHLO
	cassoulet.panasas.com") by vger.kernel.org with ESMTP
	id S1758447AbWK0Rps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Nov 2006 12:45:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>
Cc: Benny Halevy <bhalevy@panasas.com>

Playing with some tests which I admit are not 100% orthodox I have stumbled upon a bug that raises a serious question:

In the call to scsi_execute_async() in the use_sg case, must the scatterlist* (pointed to by buffer) map a buffer that's contiguous in virtual memory or is it allowed to map disjoint segments of memory?

In scsi_req_map_sg() nr_pages is calculated like this:
int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;

this calculation assumes that only the first page can have a non zero offset so disjoint memory segments pointed by sgl will fail mapping in some case when we do not allocate enough nr_pages for them.

Please consider below patch for a fix for such cases. With this patch my tests pass, including booting from a SATA drive (with a 2.6.18 code base).

Without the patch the kernel fails really badly. What happens is that bio_add_pc_page(..) fails and then inside bio_put() and later bio_free() at the call to mempool_free(bio->bi_io_vec, bio_set->bvec_pools[pool_idx]), bio->bi_io_vec == NULL and the kernel panics.

bio->bi_io_vec is set to NULL in bio_alloc_bioset() when nr_iovecs == 0.  As this seems like a valid use case bio_free() should free bio->bi_io_vec only if bio->bi_io_vec != NULL (see second patch).

Both patches are based off of scsi-misc-2.6.

<First Patch>

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Benny Halevy <bhalevy@panasas.com>

==== //depot/local/scsi-misc-2.6-dev/linux/drivers/scsi/scsi_lib.c#1 - /home/bharrosh/p4.local/local/scsi-misc-2.6-dev/linux/drivers/scsi/scsi_lib.c ====
diff -Npu /tmp/tmp.20230.0 /home/bharrosh/p4.local/local/scsi-misc-2.6-dev/linux/drivers/scsi/scsi_lib.c -L a/drivers/scsi/scsi_lib.c -L b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -299,16 +299,20 @@ static int scsi_bi_endio(struct bio *bio
  * sent to use, as some ULDs use that struct to only organize the pages.
  */
 static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
-			   int nsegs, unsigned bufflen, gfp_t gfp)
+			   int nsegs, gfp_t gfp)
 {
 	struct request_queue *q = rq->q;
-	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	int nr_pages = 0;
 	unsigned int data_len = 0, len, bytes, off;
 	struct page *page;
 	struct bio *bio = NULL;
 	int i, err, nr_vecs = 0;
 
 	for (i = 0; i < nsegs; i++) {
+		nr_pages += (sgl[i].length + sgl[i].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	}
+
+	for (i = 0; i < nsegs; i++) {
 		page = sgl[i].page;
 		off = sgl[i].offset;
 		len = sgl[i].length;
@@ -402,7 +406,7 @@ int scsi_execute_async(struct scsi_devic
 	req->cmd_flags |= REQ_QUIET;
 
 	if (use_sg)
-		err = scsi_req_map_sg(req, buffer, use_sg, bufflen, gfp);
+		err = scsi_req_map_sg(req, buffer, use_sg, gfp);
 	else if (bufflen)
 		err = blk_rq_map_kern(req->q, req, buffer, bufflen, gfp);

</First Patch>
<Second Patch>

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Benny Halevy <bhalevy@panasas.com>

diff --git a/fs/bio.c b/fs/bio.c
index f95c874..199b929 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -113,7 +113,8 @@ void bio_free(struct bio *bio, struct bi
 
 	BIO_BUG_ON(pool_idx >= BIOVEC_NR_POOLS);
 
-	mempool_free(bio->bi_io_vec, bio_set->bvec_pools[pool_idx]);
+	if (likely(bio->bi_io_vec))
+		mempool_free(bio->bi_io_vec, bio_set->bvec_pools[pool_idx]);
 	mempool_free(bio, bio_set->bio_pool);
 }
 
</Second Patch>
