From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 4/4] update scsi-ml's scsi_init_io
Date: Fri, 03 Jun 2005 18:33:40 -0700
Message-ID: <1117848820.23706.11.camel@mina>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org, axboe@suse.de
List-Id: linux-scsi@vger.kernel.org

All REQ_BLOCK_PC requests are bio backed now.

This patch was made against 2.6.12-rc5 but works with scsi-misc.

--- linux-2.6.12-rc5.orig/drivers/scsi/scsi_lib.c	2005-06-03 03:23:47.000000000 -0700
+++ linux-2.6.12-rc5/drivers/scsi/scsi_lib.c	2005-06-03 14:31:41.000000000 -0700
@@ -920,24 +920,19 @@ static int scsi_init_io(struct scsi_cmnd
 	int		   count;
 
 	/*
-	 * if this is a rq->data based REQ_BLOCK_PC, setup for a non-sg xfer
+	 * we use scatter-gather for all requests with data
+	 * (it makes highmem I/O easier to support without kmapping pages)
 	 */
-	if ((req->flags & REQ_BLOCK_PC) && !req->bio) {
-		cmd->request_bufflen = req->data_len;
-		cmd->request_buffer = req->data;
-		req->buffer = req->data;
-		cmd->use_sg = 0;
+	cmd->use_sg = req->nr_phys_segments;
+	if (!cmd->use_sg) {
+		BUG_ON(req->bio || req->data);
+		cmd->request_bufflen = 0;
+		cmd->request_buffer = NULL;
+		req->buffer = NULL;
 		return 0;
 	}
 
 	/*
-	 * we used to not use scatter-gather for single segment request,
-	 * but now we do (it makes highmem I/O easier to support without
-	 * kmapping pages)
-	 */
-	cmd->use_sg = req->nr_phys_segments;
-
-	/*
 	 * if sg table allocation fails, requeue request later.
 	 */
 	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
