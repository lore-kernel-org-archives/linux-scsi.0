From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] i2o: convert to use the data buffer accessors
Date: Thu, 14 Jun 2007 00:41:06 +0900
Message-ID: <20070614004106F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:48197 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738AbXFMPk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2007 11:40:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

- remove the unnecessary map_single path.

- convert to use the new accessors for the sg lists and the
parameters.

Note: needs to change i2o_dma_map_sg when the chaining sg is ready.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/message/i2o/i2o_scsi.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index 1045c8a..aa6fb94 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -377,12 +377,8 @@ static int i2o_scsi_reply(struct i2o_con
 		osm_err("SCSI error %08x\n", error);
 
 	dev = &c->pdev->dev;
-	if (cmd->use_sg)
-		dma_unmap_sg(dev, cmd->request_buffer, cmd->use_sg,
-			     cmd->sc_data_direction);
-	else if (cmd->SCp.dma_handle)
-		dma_unmap_single(dev, cmd->SCp.dma_handle, cmd->request_bufflen,
-				 cmd->sc_data_direction);
+
+	scsi_dma_unmap(cmd);
 
 	cmd->scsi_done(cmd);
 
@@ -664,21 +660,15 @@ #endif
 
 	if (sgl_offset != SGL_OFFSET_0) {
 		/* write size of data addressed by SGL */
-		*mptr++ = cpu_to_le32(SCpnt->request_bufflen);
+		*mptr++ = cpu_to_le32(scsi_bufflen(SCpnt));
 
 		/* Now fill in the SGList and command */
-		if (SCpnt->use_sg) {
-			if (!i2o_dma_map_sg(c, SCpnt->request_buffer,
-					    SCpnt->use_sg,
+
+		if (scsi_sg_count(SCpnt)) {
+			if (!i2o_dma_map_sg(c, scsi_sglist(SCpnt),
+					    scsi_sg_count(SCpnt),
 					    SCpnt->sc_data_direction, &mptr))
 				goto nomem;
-		} else {
-			SCpnt->SCp.dma_handle =
-			    i2o_dma_map_single(c, SCpnt->request_buffer,
-					       SCpnt->request_bufflen,
-					       SCpnt->sc_data_direction, &mptr);
-			if (dma_mapping_error(SCpnt->SCp.dma_handle))
-				goto nomem;
 		}
 	}
 
-- 
1.4.3.2

