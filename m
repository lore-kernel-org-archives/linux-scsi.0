From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/25] dm mpath: don't check for req->errors
Date: Thu,  6 Apr 2017 17:39:32 +0200
Message-ID: <20170406153944.10058-14-hch@lst.de>
References: <20170406153944.10058-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52197 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752436AbdDFPk2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 11:40:28 -0400
In-Reply-To: <20170406153944.10058-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

We'll get all proper errors reported through ->end_io and ->errors will
go away soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 7f223dbed49f..4aa1b865e66e 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1491,7 +1491,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	 */
 	int r = DM_ENDIO_REQUEUE;
 
-	if (!error && !clone->errors)
+	if (!error)
 		return 0;	/* I/O complete */
 
 	if (noretry_error(error))
-- 
2.11.0
