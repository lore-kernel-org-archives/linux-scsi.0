From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 10/24][RFC] usb/microtek: No special handling for REQUEST_SENSE command please
Date: Mon,  4 Feb 2008 18:54:11 +0200
Message-ID: <1202144051-4909-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:54640 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbYBDQ77 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 11:59:59 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  - Request sense command now comes like any other command with sg-list
    and regular dma mapping. So just remove that special handling.
    No thanks!
  - Some left-over cleanup from the accessors and not use_sg patch
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/image/microtek.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index bc207e3..3ff0474 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -480,23 +480,13 @@ static void mts_command_done( struct urb *transfer )
 		return;
 	}
 
-	if (context->srb->cmnd[0] == REQUEST_SENSE) {
-		mts_int_submit_urb(transfer,
-				   context->data_pipe,
-				   context->srb->sense_buffer,
+	if (context->data)
+		mts_int_submit_urb(transfer, context->data_pipe, context->data,
 				   context->data_length,
-				   mts_data_done);
-	} else { if ( context->data ) {
-			mts_int_submit_urb(transfer,
-					   context->data_pipe,
-					   context->data,
-					   context->data_length,
-					   scsi_sg_count(context->srb) > 1 ?
-					           mts_do_sg : mts_data_done);
-		} else {
+				   scsi_sg_count(context->srb) > 1 ?
+						     mts_do_sg : mts_data_done);
+	else
 			mts_get_status(transfer);
-		}
-	}
 
 	return;
 }
-- 
1.5.3.3

