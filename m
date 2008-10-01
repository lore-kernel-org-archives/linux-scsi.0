From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 3/5] gdrom: change to use __blk_end_request()
Date: Wed, 01 Oct 2008 10:13:02 -0400 (EDT)
Message-ID: <20081001.101302.104028547.k-ueda@ct.jp.nec.com>
References: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42622 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbYJAOPx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2008 10:15:53 -0400
In-Reply-To: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: rusty@rustcorp.com.au, oakad@yahoo.com, adrian@mcmen.demon.co.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch converts gdrom to use __blk_end_request() directly
so that end_{queued|dequeued}_request() can be removed.

gd.transfer is '1' in error cases and '0' in non-error cases,
so gdrom hasn't been propagating any error code to the block layer.
We can just convert error cases to '-EIO'.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/cdrom/gdrom.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-block/drivers/cdrom/gdrom.c
===================================================================
--- linux-2.6-block.orig/drivers/cdrom/gdrom.c
+++ linux-2.6-block/drivers/cdrom/gdrom.c
@@ -624,14 +624,14 @@ static void gdrom_readdisk_dma(struct wo
 		ctrl_outb(1, GDROM_DMA_STATUS_REG);
 		wait_event_interruptible_timeout(request_queue,
 			gd.transfer == 0, GDROM_DEFAULT_TIMEOUT);
-		err = gd.transfer;
+		err = gd.transfer ? -EIO : 0;
 		gd.transfer = 0;
 		gd.pending = 0;
 		/* now seek to take the request spinlock
 		* before handling ending the request */
 		spin_lock(&gdrom_lock);
 		list_del_init(&req->queuelist);
-		end_dequeued_request(req, 1 - err);
+		__blk_end_request(req, err, blk_rq_bytes(req));
 	}
 	spin_unlock(&gdrom_lock);
 	kfree(read_command);
