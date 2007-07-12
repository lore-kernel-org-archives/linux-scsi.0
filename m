From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] microtek.c - use data accessors and !use_sg cleanup
Date: Thu, 12 Jul 2007 16:11:24 +0300
Message-ID: <4696287C.8060501@panasas.com>
References: <468BE4CE.80402@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:32467 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760860AbXGLNLd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 09:11:33 -0400
In-Reply-To: <468BE4CE.80402@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


  - use scsi_cmnd data accessors
  - Clean the !use_sg code paths

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/image/microtek.c |   32 ++++++++++++++------------------
 1 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 51bd80d..0a5c6e8 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -447,7 +447,8 @@ static void mts_data_done( struct urb* transfer )
 	MTS_INT_INIT();
 
 	if ( context->data_length != transfer->actual_length ) {
-		context->srb->resid = context->data_length - transfer->actual_length;
+		scsi_set_resid(context->srb, context->data_length -
+		                                     transfer->actual_length);
 	} else if ( unlikely(transfer->status) ) {
 		context->srb->result = (transfer->status == -ENOENT ? DID_ABORT : DID_ERROR)<<16;
 	}
@@ -490,7 +491,8 @@ static void mts_command_done( struct urb *transfer )
 					   context->data_pipe,
 					   context->data,
 					   context->data_length,
-					   context->srb->use_sg > 1 ? mts_do_sg : mts_data_done);
+					   scsi_sg_count(context->srb) > 1 ?
+					           mts_do_sg : mts_data_done);
 		} else {
 			mts_get_status(transfer);
 		}
@@ -504,21 +506,23 @@ static void mts_do_sg (struct urb* transfer)
 	struct scatterlist * sg;
 	MTS_INT_INIT();
 
-	MTS_DEBUG("Processing fragment %d of %d\n", context->fragment,context->srb->use_sg);
+	MTS_DEBUG("Processing fragment %d of %d\n", context->fragment,
+	                                          scsi_sg_count(context->srb));
 
 	if (unlikely(transfer->status)) {
                 context->srb->result = (transfer->status == -ENOENT ? DID_ABORT : DID_ERROR)<<16;
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
+			   context->fragment + 1 == scsi_sg_count(context->srb) ?
+			   mts_data_done : mts_do_sg);
 	return;
 }
 
@@ -546,20 +550,12 @@ mts_build_transfer_context(struct scsi_cmnd *srb, struct mts_desc* desc)
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
+	if (!scsi_bufflen(srb)) {
+		desc->context.data = NULL;
+		desc->context.data_length = 0;
+		return;
 	} else {
-		MTS_DEBUG("Using scatter/gather\n");
-		sg = srb->request_buffer;
+		sg = scsi_sglist(srb);
 		desc->context.data = page_address(sg[0].page) + sg[0].offset;
 		desc->context.data_length = sg[0].length;
 	}
-- 
1.5.2.2.249.g45fd


