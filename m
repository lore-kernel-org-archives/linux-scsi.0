From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Wed, 26 Dec 2007 11:27:40 +1100
Message-ID: <200712261127.41088.rusty@rustcorp.com.au>
References: <200712211013.38511.rusty@rustcorp.com.au> <200712211426.47896.rusty@rustcorp.com.au> <20071221133746B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:51413 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbXLZA1x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Dec 2007 19:27:53 -0500
In-Reply-To: <20071221133746B.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net

On Friday 21 December 2007 15:37:46 FUJITA Tomonori wrote:
> Some scsi drivers like ips access to sglist in a tricky way.

Indeed.  I fail to see how this code works, in fact:

drivers/scsi/ips.c:ips_queue() line 1101

	if (ips_is_passthru(SC)) {

		ips_copp_wait_item_t *scratch;

		/* A Reset IOCTL is only sent by the boot CD in extreme cases.           */
		/* There can never be any system activity ( network or disk ), but check */
		/* anyway just as a good practice.                                       */
		pt = (ips_passthru_t *) scsi_sglist(SC);
		if ((pt->CoppCP.cmd.reset.op_code == IPS_CMD_RESET_CHANNEL) &&
		    (pt->CoppCP.cmd.reset.adapter_flag == 1)) {

Casting the scsi_sglist(SC) (which ips_is_passthrough treated as a
scatterlist) to an ips_passthrough_t seems completely bogus.  It looks like
it wants to access the region mapped by the scatterlist.

There are many signs through the code that it needs a great deal of work:
what is the purpose of sg_break?  Why does the code check if kmap_atomic
fails?

===
Convert the ips SCSI driver to sg_ring.

Slightly non-trivial conversion, will need testing.

The first issue is the standard one with "scsi_for_each_sg"
conversion: scsi_for_each_sg will always start i at 0 and increment it
each time around; "sg_ring_for_each" will start i at 0 but it will
return to zero for each new sg_ring entry; you need a separate counter
if you really want a simple increment.

Various flaws in the driver have been maintained.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 63176a8a6ce3 drivers/scsi/ips.c
--- a/drivers/scsi/ips.c	Mon Dec 24 17:40:08 2007 +1100
+++ b/drivers/scsi/ips.c	Wed Dec 26 11:20:52 2007 +1100
@@ -1105,7 +1105,7 @@ static int ips_queue(struct scsi_cmnd *S
 		/* A Reset IOCTL is only sent by the boot CD in extreme cases.           */
 		/* There can never be any system activity ( network or disk ), but check */
 		/* anyway just as a good practice.                                       */
-		pt = (ips_passthru_t *) scsi_sglist(SC);
+		pt = (ips_passthru_t *) SC->sg;
 		if ((pt->CoppCP.cmd.reset.op_code == IPS_CMD_RESET_CHANNEL) &&
 		    (pt->CoppCP.cmd.reset.adapter_flag == 1)) {
 			if (ha->scb_activelist.count != 0) {
@@ -1508,8 +1508,8 @@ static int ips_is_passthru(struct scsi_c
 	if ((SC->cmnd[0] == IPS_IOCTL_COMMAND) &&
 	    (SC->device->channel == 0) &&
 	    (SC->device->id == IPS_ADAPTER_ID) &&
-	    (SC->device->lun == 0) && scsi_sglist(SC)) {
-                struct scatterlist *sg = scsi_sglist(SC);
+	    (SC->device->lun == 0) && SC->sg) {
+                struct scatterlist *sg = &SC->sg->sg[0];
                 char  *buffer;
 
                 /* kmap_atomic() ensures addressability of the user buffer.*/
@@ -1575,12 +1575,12 @@ ips_make_passthru(ips_ha_t *ha, struct s
 	ips_passthru_t *pt;
 	int length = 0;
 	int i, ret;
-        struct scatterlist *sg = scsi_sglist(SC);
+        struct sg_ring *sg;
 
 	METHOD_TRACE("ips_make_passthru", 1);
 
-        scsi_for_each_sg(SC, sg, scsi_sg_count(SC), i)
-                length += sg[i].length;
+	sg_ring_for_each(SC->sg, sg, i)
+                length += sg->sg[i].length;
 
 	if (length < sizeof (ips_passthru_t)) {
 		/* wrong size */
@@ -2005,7 +2005,7 @@ ips_cleanup_passthru(ips_ha_t * ha, ips_
 
 	METHOD_TRACE("ips_cleanup_passthru", 1);
 
-	if ((!scb) || (!scb->scsi_cmd) || (!scsi_sglist(scb->scsi_cmd))) {
+	if ((!scb) || (!scb->scsi_cmd) || (!scb->scsi_cmd->sg)) {
 		DEBUG_VAR(1, "(%s%d) couldn't cleanup after passthru",
 			  ips_name, ha->host_num);
 
@@ -2758,16 +2758,18 @@ ips_next(ips_ha_t * ha, int intr)
                 scb->sg_count = scsi_dma_map(SC);
                 BUG_ON(scb->sg_count < 0);
 		if (scb->sg_count) {
-			struct scatterlist *sg;
-			int i;
+			struct sg_ring *sg;
+			int i, idx;
 
 			scb->flags |= IPS_SCB_MAP_SG;
 
-                        scsi_for_each_sg(SC, sg, scb->sg_count, i) {
+			idx = 0;
+			sg_ring_for_each(SC->sg, sg, i) {
 				if (ips_fill_scb_sg_single
-				    (ha, sg_dma_address(sg), scb, i,
-				     sg_dma_len(sg)) < 0)
-					break;
+				    (ha, sg_dma_address(&sg->sg[i]), scb, idx,
+				     sg_dma_len(&sg->sg[i])) < 0)
+					break;
+				idx++;
 			}
 			scb->dcdb.transfer_length = scb->data_len;
 		} else {
@@ -3251,34 +3253,35 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 		 * the rest of the data and continue.
 		 */
 		if ((scb->breakup) || (scb->sg_break)) {
-                        struct scatterlist *sg;
+                        struct sg_ring *sg;
                         int i, sg_dma_index, ips_sg_index = 0;
 
 			/* we had a data breakup */
 			scb->data_len = 0;
 
-                        sg = scsi_sglist(scb->scsi_cmd);
-
                         /* Spin forward to last dma chunk */
-                        sg_dma_index = scb->breakup;
-                        for (i = 0; i < scb->breakup; i++)
-                                sg = sg_next(sg);
-
+			sg_dma_index = 0;
+			sg_ring_for_each(scb->scsi_cmd->sg, sg, i) {
+				if (sg_dma_index == scb->breakup)
+					break;
+				sg_dma_index++;
+			}
+			
 			/* Take care of possible partial on last chunk */
                         ips_fill_scb_sg_single(ha,
-                                               sg_dma_address(sg),
+                                               sg_dma_address(&sg->sg[i]),
                                                scb, ips_sg_index++,
-                                               sg_dma_len(sg));
-
-                        for (; sg_dma_index < scsi_sg_count(scb->scsi_cmd);
-                             sg_dma_index++, sg = sg_next(sg)) {
+                                               sg_dma_len(&sg->sg[i]));
+
+			do {
                                 if (ips_fill_scb_sg_single
                                     (ha,
-                                     sg_dma_address(sg),
+                                     sg_dma_address(&sg->sg[i]),
                                      scb, ips_sg_index++,
-                                     sg_dma_len(sg)) < 0)
-                                        break;
-                        }
+                                     sg_dma_len(&sg->sg[i])) < 0)
+					break;
+			} while ((sg = sg_ring_iter(scb->scsi_cmd->sg, sg, &i))
+				 != NULL);
 
 			scb->dcdb.transfer_length = scb->data_len;
 			scb->dcdb.cmd_attribute |=
@@ -3510,26 +3513,28 @@ ips_scmd_buf_write(struct scsi_cmnd *scm
 ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)
 {
         int i;
-        unsigned int min_cnt, xfer_cnt;
+        unsigned int min_cnt, xfer_cnt = 0;
         char *cdata = (char *) data;
         unsigned char *buffer;
         unsigned long flags;
-        struct scatterlist *sg = scsi_sglist(scmd);
-
-        for (i = 0, xfer_cnt = 0;
-             (i < scsi_sg_count(scmd)) && (xfer_cnt < count); i++) {
-                min_cnt = min(count - xfer_cnt, sg[i].length);
+	struct sg_ring *sg;
+
+	sg_ring_for_each(scmd->sg, sg, i) {
+                min_cnt = min(count - xfer_cnt, sg->sg[i].length);
 
                 /* kmap_atomic() ensures addressability of the data buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg_page(&sg[i]), KM_IRQ0) + sg[i].offset;
+                buffer = kmap_atomic(sg_page(&sg->sg[i]), KM_IRQ0)
+			+ sg->sg[i].offset;
                 memcpy(buffer, &cdata[xfer_cnt], min_cnt);
-                kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
+                kunmap_atomic(buffer - sg->sg[i].offset, KM_IRQ0);
                 local_irq_restore(flags);
 
                 xfer_cnt += min_cnt;
-        }
+		if (xfer_cnt == count)
+			break;
+	}
 }
 
 /****************************************************************************/
@@ -3543,26 +3548,28 @@ ips_scmd_buf_read(struct scsi_cmnd *scmd
 ips_scmd_buf_read(struct scsi_cmnd *scmd, void *data, unsigned int count)
 {
         int i;
-        unsigned int min_cnt, xfer_cnt;
+        unsigned int min_cnt, xfer_cnt = 0;
         char *cdata = (char *) data;
         unsigned char *buffer;
         unsigned long flags;
-        struct scatterlist *sg = scsi_sglist(scmd);
-
-        for (i = 0, xfer_cnt = 0;
-             (i < scsi_sg_count(scmd)) && (xfer_cnt < count); i++) {
-                min_cnt = min(count - xfer_cnt, sg[i].length);
+	struct sg_ring *sg;
+
+	sg_ring_for_each(scmd->sg, sg, i) {
+                min_cnt = min(count - xfer_cnt, sg->sg[i].length);
 
                 /* kmap_atomic() ensures addressability of the data buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg_page(&sg[i]), KM_IRQ0) + sg[i].offset;
+                buffer = kmap_atomic(sg_page(&sg->sg[i]), KM_IRQ0) 
+			+ sg->sg[i].offset;
                 memcpy(&cdata[xfer_cnt], buffer, min_cnt);
-                kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
+                kunmap_atomic(buffer - sg->sg[i].offset, KM_IRQ0);
                 local_irq_restore(flags);
 
                 xfer_cnt += min_cnt;
-        }
+		if (xfer_cnt == count)
+			break;
+	}
 }
 
 /****************************************************************************/
@@ -4196,7 +4203,7 @@ ips_rdcap(ips_ha_t * ha, ips_scb_t * scb
 
 	METHOD_TRACE("ips_rdcap", 1);
 
-	if (scsi_bufflen(scb->scsi_cmd) < 8)
+	if (scb->scsi_cmd->request_bufflen < 8)
 		return (0);
 
 	cap.lba =
