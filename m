From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/5] virtio_blk: change to use __blk_end_request()
Date: Wed, 01 Oct 2008 10:11:20 -0400 (EDT)
Message-ID: <20081001.101120.41628825.k-ueda@ct.jp.nec.com>
References: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37573 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYJAONu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2008 10:13:50 -0400
In-Reply-To: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: rusty@rustcorp.com.au, oakad@yahoo.com, adrian@mcmen.demon.co.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch converts virtio_blk to use __blk_end_request() directly
so that end_{queued|dequeued}_request() can be removed.
Related 'uptodate' argument is converted to 'error'.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/block/virtio_blk.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6-block/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6-block.orig/drivers/block/virtio_blk.c
+++ linux-2.6-block/drivers/block/virtio_blk.c
@@ -47,20 +47,20 @@ static void blk_done(struct virtqueue *v
 
 	spin_lock_irqsave(&vblk->lock, flags);
 	while ((vbr = vblk->vq->vq_ops->get_buf(vblk->vq, &len)) != NULL) {
-		int uptodate;
+		int error;
 		switch (vbr->status) {
 		case VIRTIO_BLK_S_OK:
-			uptodate = 1;
+			error = 0;
 			break;
 		case VIRTIO_BLK_S_UNSUPP:
-			uptodate = -ENOTTY;
+			error = -ENOTTY;
 			break;
 		default:
-			uptodate = 0;
+			error = -EIO;
 			break;
 		}
 
-		end_dequeued_request(vbr->req, uptodate);
+		__blk_end_request(vbr->req, error, blk_rq_bytes(vbr->req));
 		list_del(&vbr->list);
 		mempool_free(vbr, vblk->pool);
 	}
