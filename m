From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] microtek: convert to use the data buffer accessors
Date: Sun, 12 Aug 2007 16:11:58 +0900
Message-ID: <20070811072657A.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:54912 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbXHLHMJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Aug 2007 03:12:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, greg@kroah.com, fujita.tomonori@lab.ntt.co.jp

The patch is only compile tested.

---
>From d5ad824bce0e5e3894a102fee74f1f7c36d639b7 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Sun, 12 Aug 2007 15:33:23 +0900
Subject: [PATCH] microtek: convert to use the data buffer accessors

- remove the unnecessary map_single path.

- convert to use the new accessors for the sg lists and the
parameters.

TODO: sg chaining support

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/usb/image/microtek.c |   32 +++++++++++++-------------------
 1 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 768b2c1..59b57c3 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -446,7 +446,8 @@ static void mts_data_done( struct urb* transfer )
 	MTS_INT_INIT();
 
 	if ( context->data_length != transfer->actual_length ) {
-		context->srb->resid = context->data_length - transfer->actual_length;
+		scsi_set_resid(context->srb,
+			       context->data_length - transfer->actual_length);
 	} else if ( unlikely(status) ) {
 		context->srb->result = (status == -ENOENT ? DID_ABORT : DID_ERROR)<<16;
 	}
@@ -490,7 +491,7 @@ static void mts_command_done( struct urb *transfer )
 					   context->data_pipe,
 					   context->data,
 					   context->data_length,
-					   context->srb->use_sg > 1 ? mts_do_sg : mts_data_done);
+					   scsi_sg_count(context->srb) > 1 ? mts_do_sg : mts_data_done);
 		} else {
 			mts_get_status(transfer);
 		}
@@ -505,21 +506,22 @@ static void mts_do_sg (struct urb* transfer)
 	int status = transfer->status;
 	MTS_INT_INIT();
 
-	MTS_DEBUG("Processing fragment %d of %d\n", context->fragment,context->srb->use_sg);
+	MTS_DEBUG("Processing fragment %d of %d\n", context->fragment,
+		  scsi_sg_count(context->srb));
 
 	if (unlikely(status)) {
                 context->srb->result = (status == -ENOENT ? DID_ABORT : DID_ERROR)<<16;
 		mts_transfer_cleanup(transfer);
         }
 
-	sg = context->srb->request_buffer;
+	sg = scsi_sglist(context->srb);
 	context->fragment++;
 	mts_int_submit_urb(transfer,
 			   context->data_pipe,
 			   page_address(sg[context->fragment].page) +
 			   sg[context->fragment].offset,
 			   sg[context->fragment].length,
-			   context->fragment + 1 == context->srb->use_sg ? mts_data_done : mts_do_sg);
+			   context->fragment + 1 == scsi_sg_count(context->srb) ? mts_data_done : mts_do_sg);
 	return;
 }
 
@@ -547,25 +549,17 @@ mts_build_transfer_context(struct scsi_cmnd *srb, struct mts_desc* desc)
 	desc->context.srb = srb;
 	desc->context.fragment = 0;
 
-	if (!srb->use_sg) {
-		if ( !srb->request_bufflen ){
-			desc->context.data = NULL;
-			desc->context.data_length = 0;
-			return;
-		} else {
-			desc->context.data = srb->request_buffer;
-			desc->context.data_length = srb->request_bufflen;
-			MTS_DEBUG("length = %d or %d\n",
-				  srb->request_bufflen, srb->bufflen);
-		}
-	} else {
+	if (scsi_sg_count(srb)) {
 		MTS_DEBUG("Using scatter/gather\n");
-		sg = srb->request_buffer;
+		sg = scsi_sglist(srb);
 		desc->context.data = page_address(sg[0].page) + sg[0].offset;
 		desc->context.data_length = sg[0].length;
+	} else {
+		desc->context.data = NULL;
+		desc->context.data_length = 0;
+		return;
 	}
 
-
 	/* can't rely on srb->sc_data_direction */
 
 	/* Brutally ripped from usb-storage */
-- 
1.5.2.4

