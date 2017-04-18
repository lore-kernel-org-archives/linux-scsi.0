From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: ataflop: switch from req->errors to req->error_count
Date: Tue, 18 Apr 2017 08:52:25 -0700
Message-ID: <20170418155229.5977-20-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52228 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757445AbdDRPws (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 11:52:48 -0400
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/ataflop.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 2104b1b4ccda..fa69ecd52cb5 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -617,12 +617,12 @@ static void fd_error( void )
 	if (!fd_request)
 		return;
 
-	fd_request->errors++;
-	if (fd_request->errors >= MAX_ERRORS) {
+	fd_request->error_count++;
+	if (fd_request->error_count >= MAX_ERRORS) {
 		printk(KERN_ERR "fd%d: too many errors.\n", SelectedDrive );
 		fd_end_request_cur(-EIO);
 	}
-	else if (fd_request->errors == RECALIBRATE_ERRORS) {
+	else if (fd_request->error_count == RECALIBRATE_ERRORS) {
 		printk(KERN_WARNING "fd%d: recalibrating\n", SelectedDrive );
 		if (SelectedDrive != -1)
 			SUD.track = -1;
@@ -1386,7 +1386,7 @@ static void setup_req_params( int drive )
 	ReqData = ReqBuffer + 512 * ReqCnt;
 
 	if (UseTrackbuffer)
-		read_track = (ReqCmd == READ && fd_request->errors == 0);
+		read_track = (ReqCmd == READ && fd_request->error_count == 0);
 	else
 		read_track = 0;
 
@@ -1409,8 +1409,10 @@ static struct request *set_next_request(void)
 			fdc_queue = 0;
 		if (q) {
 			rq = blk_fetch_request(q);
-			if (rq)
+			if (rq) {
+				rq->error_count = 0;
 				break;
+			}
 		}
 	} while (fdc_queue != old_pos);
 
-- 
2.11.0
