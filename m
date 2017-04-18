From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: dm mpath: don't check for req->errors
Date: Tue, 18 Apr 2017 08:52:17 -0700
Message-ID: <20170418155229.5977-12-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757452AbdDRPwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 11:52:49 -0400
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

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
