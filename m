From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/23] floppy: switch from req->errors to req->error_count
Date: Wed, 19 Apr 2017 21:27:04 +0200
Message-ID: <20170419192708.22098-20-hch@lst.de>
References: <20170419192708.22098-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57746 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934199AbdDST2M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 15:28:12 -0400
In-Reply-To: <20170419192708.22098-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/floppy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index ce102ec47ef2..60d4c7653178 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2805,8 +2805,10 @@ static int set_next_request(void)
 			fdc_queue = 0;
 		if (q) {
 			current_req = blk_fetch_request(q);
-			if (current_req)
+			if (current_req) {
+				current_req->error_count = 0;
 				break;
+			}
 		}
 	} while (fdc_queue != old_pos);
 
@@ -2866,7 +2868,7 @@ static void redo_fd_request(void)
 		_floppy = floppy_type + DP->autodetect[DRS->probed_format];
 	} else
 		probing = 0;
-	errors = &(current_req->errors);
+	errors = &(current_req->error_count);
 	tmp = make_raw_rw_request();
 	if (tmp < 2) {
 		request_done(tmp);
-- 
2.11.0
