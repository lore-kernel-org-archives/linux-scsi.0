From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/23] advansys: Remove ASC_SCSI_REQ_Q
Date: Fri, 24 Apr 2015 13:18:33 +0200
Message-ID: <1429874322-85488-16-git-send-email-hare@suse.de>
References: <1429874322-85488-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965973AbbDXLSv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 07:18:51 -0400
In-Reply-To: <1429874322-85488-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Removed unused structure ASC_SCSI_REQ_Q and update the
comments to 'ADV_SCSI_REQ_Q'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index a6bc8aa..ac9a9da 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -353,17 +353,6 @@ typedef struct asc_scsi_q {
 	ushort next_sg_index;
 } ASC_SCSI_Q;
 
-typedef struct asc_scsi_req_q {
-	ASC_SCSIQ_1 r1;
-	ASC_SCSIQ_2 r2;
-	uchar *cdbptr;
-	ASC_SG_HEAD *sg_head;
-	uchar *sense_ptr;
-	ASC_SCSIQ_3 r3;
-	uchar cdb[ASC_MAX_CDB_LEN];
-	uchar sense[ASC_MIN_SENSE_LEN];
-} ASC_SCSI_REQ_Q;
-
 typedef struct asc_scsi_bios_req_q {
 	ASC_SCSIQ_1 r1;
 	ASC_SCSIQ_2 r2;
@@ -1707,7 +1696,7 @@ typedef struct adveep_38C1600_config {
 typedef struct adv_carr_t {
 	__le32 carr_va;	/* Carrier Virtual Address */
 	__le32 carr_pa;	/* Carrier Physical Address */
-	__le32 areq_vpa;	/* ASC_SCSI_REQ_Q Virtual or Physical Address */
+	__le32 areq_vpa;	/* ADV_SCSI_REQ_Q Virtual or Physical Address */
 	/*
 	 * next_vpa [31:4]            Carrier Virtual or Physical Next Pointer
 	 *
@@ -1738,7 +1727,7 @@ typedef struct adv_carr_t {
     (ADV_CARRIER_COUNT * sizeof(ADV_CARR_T))
 
 /*
- * ASC_SCSI_REQ_Q 'a_flag' definitions
+ * ADV_SCSI_REQ_Q 'a_flag' definitions
  *
  * The Adv Library should limit use to the lower nibble (4 bits) of
  * a_flag. Drivers are free to use the upper nibble (4 bits) of a_flag.
@@ -2029,7 +2018,7 @@ do { \
 
 /*
  * Abort an SRB in the chip's RISC Memory. The 'srb_tag' argument must
- * match the ASC_SCSI_REQ_Q 'srb_tag' field.
+ * match the ADV_SCSI_REQ_Q 'srb_tag' field.
  *
  * If the request has not yet been sent to the device it will simply be
  * aborted from RISC memory. If the request is disconnected it will be
@@ -2075,7 +2064,7 @@ do { \
 #define ADV_TID_TO_TIDMASK(tid)   (0x01 << ((tid) & ADV_MAX_TID))
 
 /*
- * ASC_SCSI_REQ_Q 'done_status' and 'host_status' return values.
+ * ADV_SCSI_REQ_Q 'done_status' and 'host_status' return values.
  */
 
 #define QD_NO_STATUS         0x00	/* Request not completed yet. */
@@ -6237,9 +6226,9 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 		 * Get a pointer to the newly completed ADV_SCSI_REQ_Q structure.
 		 * The RISC will have set 'areq_vpa' to a virtual address.
 		 *
-		 * The firmware will have copied the ASC_SCSI_REQ_Q.scsiq_ptr
+		 * The firmware will have copied the ADV_SCSI_REQ_Q.scsiq_ptr
 		 * field to the carrier ADV_CARR_T.areq_vpa field. The conversion
-		 * below complements the conversion of ASC_SCSI_REQ_Q.scsiq_ptr'
+		 * below complements the conversion of ADV_SCSI_REQ_Q.scsiq_ptr'
 		 * in AdvExeScsiQueue().
 		 */
 		u32 pa_offset = le32_to_cpu(asc_dvc->irq_sp->areq_vpa);
@@ -6751,9 +6740,9 @@ static void AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 		q_addr = ASC_QNO_TO_QADDR(q_no);
 
 		/*
-		 * Convert the request's SRB pointer to a host ASC_SCSI_REQ
+		 * Convert the request's SRB pointer to a host ASC_SCSI_Q
 		 * structure pointer using a macro provided by the driver.
-		 * The ASC_SCSI_REQ pointer provides a pointer to the
+		 * The ASC_SCSI_Q pointer provides a pointer to the
 		 * host ASC_SG_HEAD structure.
 		 */
 		/* Read request's SRB pointer. */
@@ -7947,7 +7936,7 @@ adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp,
  * If an adv_req_t can not be allocated to issue the request,
  * then return ASC_BUSY. If an error occurs, then return ASC_ERROR.
  *
- * Multi-byte fields in the ASC_SCSI_REQ_Q that are used by the
+ * Multi-byte fields in the ADV_SCSI_REQ_Q that are used by the
  * microcode for DMA addresses or math operations are byte swapped
  * to little-endian order.
  */
@@ -8633,7 +8622,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
  * If 'done_status' is not set to QD_DO_RETRY, then 'error_retry' will be
  * set to SCSI_MAX_RETRY.
  *
- * Multi-byte fields in the ASC_SCSI_REQ_Q that are used by the microcode
+ * Multi-byte fields in the ADV_SCSI_REQ_Q that are used by the microcode
  * for DMA addresses or math operations are byte swapped to little-endian
  * order.
  *
-- 
1.8.5.2

