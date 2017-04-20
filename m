From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/23] dm mpath: don't check for req->errors
Date: Thu, 20 Apr 2017 16:03:05 +0200
Message-ID: <20170420140316.6546-13-hch@lst.de>
References: <20170420140316.6546-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170420140316.6546-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

We'll get all proper errors reported through ->end_io and ->errors will
go away soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index ab55955ed704..2950b145443d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1492,7 +1492,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	 */
 	int r = DM_ENDIO_REQUEUE;
 
-	if (!error && !clone->errors)
+	if (!error)
 		return 0;	/* I/O complete */
 
 	if (noretry_error(error))
-- 
2.11.0
