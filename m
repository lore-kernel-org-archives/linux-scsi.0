From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/25] floppy: switch from req->errors to req->error_count
Date: Thu,  6 Apr 2017 17:39:39 +0200
Message-ID: <20170406153944.10058-21-hch@lst.de>
References: <20170406153944.10058-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170406153944.10058-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

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
