From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/32] usb: transport - convert to accessors and !use_sg code
 path removal
Date: Wed, 17 Oct 2007 19:26:15 +0200
Message-ID: <471645B7.1050207@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:29059 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759386AbXJQR1S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 13:27:18 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


  - Use scsi data accessors and remove of !use_sg code path.
  - New usb_stor_bulk_srb() for use by drivers

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/transport.c |   44 +++++++++++++++++++++++---------------
 drivers/usb/storage/transport.h |    2 +
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index c646750..d3a84a2 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -459,6 +459,21 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
 }
 
 /*
+ * Common used function. Transfer a complete command
+ * via usb_stor_bulk_transfer_sglist() above. Set cmnd resid
+ */
+int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
+		      struct scsi_cmnd* srb)
+{
+	int resid = scsi_get_resid(srb);
+	int result = usb_stor_bulk_transfer_sglist(us, pipe, scsi_sglist(srb),
+				      scsi_sg_count(srb), scsi_bufflen(srb),
+				      &resid);
+	scsi_set_resid(srb, resid);
+	return result;
+}
+
+/*
  * Transfer an entire SCSI command's worth of data payload over the bulk
  * pipe.
  *
@@ -508,7 +523,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	int result;
 
 	/* send the command to the transport layer */
-	srb->resid = 0;
+	scsi_set_resid(srb, 0);
 	result = us->transport(srb, us);
 
 	/* if the command gets aborted by the higher layers, we need to
@@ -568,7 +583,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 * A short transfer on a command where we don't expect it
 	 * is unusual, but it doesn't mean we need to auto-sense.
 	 */
-	if ((srb->resid > 0) &&
+	if ((scsi_get_resid(srb) > 0) &&
 	    !((srb->cmnd[0] == REQUEST_SENSE) ||
 	      (srb->cmnd[0] == INQUIRY) ||
 	      (srb->cmnd[0] == MODE_SENSE) ||
@@ -593,7 +608,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 			srb->cmd_len = 12;
 
 		/* issue the auto-sense command */
-		srb->resid = 0;
+		scsi_set_resid(srb, 0);
 		temp_result = us->transport(us->srb, us);
 
 		/* let's clean up right away */
@@ -649,7 +664,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	/* Did we transfer less than the minimum amount required? */
 	if (srb->result == SAM_STAT_GOOD &&
-			srb->request_bufflen - srb->resid < srb->underflow)
+			scsi_bufflen(srb) - scsi_get_resid(srb) < srb->underflow)
 		srb->result = (DID_ERROR << 16) | (SUGGEST_RETRY << 24);
 
 	return;
@@ -708,7 +723,7 @@ void usb_stor_stop_transport(struct us_data *us)
 
 int usb_stor_CBI_transport(struct scsi_cmnd *srb, struct us_data *us)
 {
-	unsigned int transfer_length = srb->request_bufflen;
+	unsigned int transfer_length = scsi_bufflen(srb);
 	unsigned int pipe = 0;
 	int result;
 
@@ -737,9 +752,7 @@ int usb_stor_CBI_transport(struct scsi_cmnd *srb, struct us_data *us)
 	if (transfer_length) {
 		pipe = srb->sc_data_direction == DMA_FROM_DEVICE ? 
 				us->recv_bulk_pipe : us->send_bulk_pipe;
-		result = usb_stor_bulk_transfer_sg(us, pipe,
-					srb->request_buffer, transfer_length,
-					srb->use_sg, &srb->resid);
+		result = usb_stor_bulk_srb(us, pipe, srb);
 		US_DEBUGP("CBI data stage result is 0x%x\n", result);
 
 		/* if we stalled the data transfer it means command failed */
@@ -808,7 +821,7 @@ int usb_stor_CBI_transport(struct scsi_cmnd *srb, struct us_data *us)
  */
 int usb_stor_CB_transport(struct scsi_cmnd *srb, struct us_data *us)
 {
-	unsigned int transfer_length = srb->request_bufflen;
+	unsigned int transfer_length = scsi_bufflen(srb);
 	int result;
 
 	/* COMMAND STAGE */
@@ -836,9 +849,7 @@ int usb_stor_CB_transport(struct scsi_cmnd *srb, struct us_data *us)
 	if (transfer_length) {
 		unsigned int pipe = srb->sc_data_direction == DMA_FROM_DEVICE ? 
 				us->recv_bulk_pipe : us->send_bulk_pipe;
-		result = usb_stor_bulk_transfer_sg(us, pipe,
-					srb->request_buffer, transfer_length,
-					srb->use_sg, &srb->resid);
+		result = usb_stor_bulk_srb(us, pipe, srb);
 		US_DEBUGP("CB data stage result is 0x%x\n", result);
 
 		/* if we stalled the data transfer it means command failed */
@@ -904,7 +915,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *) us->iobuf;
-	unsigned int transfer_length = srb->request_bufflen;
+	unsigned int transfer_length = scsi_bufflen(srb);
 	unsigned int residue;
 	int result;
 	int fake_sense = 0;
@@ -955,9 +966,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	if (transfer_length) {
 		unsigned int pipe = srb->sc_data_direction == DMA_FROM_DEVICE ? 
 				us->recv_bulk_pipe : us->send_bulk_pipe;
-		result = usb_stor_bulk_transfer_sg(us, pipe,
-					srb->request_buffer, transfer_length,
-					srb->use_sg, &srb->resid);
+		result = usb_stor_bulk_srb(us, pipe, srb);
 		US_DEBUGP("Bulk data transfer result 0x%x\n", result);
 		if (result == USB_STOR_XFER_ERROR)
 			return USB_STOR_TRANSPORT_ERROR;
@@ -1036,7 +1045,8 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	if (residue) {
 		if (!(us->flags & US_FL_IGNORE_RESIDUE)) {
 			residue = min(residue, transfer_length);
-			srb->resid = max(srb->resid, (int) residue);
+			scsi_set_resid(srb, max(scsi_get_resid(srb),
+			                                       (int) residue));
 		}
 	}
 
diff --git a/drivers/usb/storage/transport.h b/drivers/usb/storage/transport.h
index 633a715..ada7c2f 100644
--- a/drivers/usb/storage/transport.h
+++ b/drivers/usb/storage/transport.h
@@ -139,6 +139,8 @@ extern int usb_stor_bulk_transfer_buf(struct us_data *us, unsigned int pipe,
 		void *buf, unsigned int length, unsigned int *act_len);
 extern int usb_stor_bulk_transfer_sg(struct us_data *us, unsigned int pipe,
 		void *buf, unsigned int length, int use_sg, int *residual);
+extern int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
+		struct scsi_cmnd* srb);
 
 extern int usb_stor_port_reset(struct us_data *us);
 #endif
-- 
1.5.3.1


