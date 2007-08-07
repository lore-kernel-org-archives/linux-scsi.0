From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] fc4: convert to use the data buffer accessors
Date: Tue, 07 Aug 2007 17:38:20 +0900
Message-ID: <20070807173820H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:39979 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbXHGIi0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 04:38:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com

- remove the unnecessary map_single path.

- convert to use the new accessors for the sg lists and the
parameters.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/fc4/fc.c |   41 +++++++++++++++--------------------------
 1 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/fc4/fc.c b/drivers/fc4/fc.c
index 22b62b3..82de9e1 100644
--- a/drivers/fc4/fc.c
+++ b/drivers/fc4/fc.c
@@ -427,15 +427,10 @@ static inline void fcp_scsi_receive(fc_channel *fc, int token, int status, fc_hd
 			memcpy(SCpnt->sense_buffer, ((char *)(rsp+1)), sense_len);
 		}
 		
-		if (fcmd->data) {
-			if (SCpnt->use_sg)
-				dma_unmap_sg(fc->dev, (struct scatterlist *)SCpnt->request_buffer,
-						SCpnt->use_sg,
-						SCpnt->sc_data_direction);
-			else
-				dma_unmap_single(fc->dev, fcmd->data, SCpnt->request_bufflen,
-						 SCpnt->sc_data_direction);
-		}
+		if (fcmd->data)
+			dma_unmap_sg(fc->dev, scsi_sglist(SCpnt),
+				     scsi_sg_count(SCpnt),
+				     SCpnt->sc_data_direction);
 		break;
 	default:
 		host_status=DID_ERROR; /* FIXME */
@@ -793,10 +788,14 @@ static int fcp_scsi_queue_it(fc_channel *fc, struct scsi_cmnd *SCpnt,
 				fcp_cntl = FCP_CNTL_QTYPE_SIMPLE;
 		} else
 			fcp_cntl = FCP_CNTL_QTYPE_UNTAGGED;
-		if (!SCpnt->request_bufflen && !SCpnt->use_sg) {
+
+		if (!scsi_bufflen(SCpnt)) {
 			cmd->fcp_cntl = fcp_cntl;
 			fcmd->data = (dma_addr_t)NULL;
 		} else {
+			struct scatterlist *sg;
+			int nents;
+
 			switch (SCpnt->cmnd[0]) {
 			case WRITE_6:
 			case WRITE_10:
@@ -805,22 +804,12 @@ static int fcp_scsi_queue_it(fc_channel *fc, struct scsi_cmnd *SCpnt,
 			default:
 				cmd->fcp_cntl = (FCP_CNTL_READ | fcp_cntl); break;
 			}
-			if (!SCpnt->use_sg) {
-				cmd->fcp_data_len = SCpnt->request_bufflen;
-				fcmd->data = dma_map_single (fc->dev, (char *)SCpnt->request_buffer,
-							     SCpnt->request_bufflen,
-							     SCpnt->sc_data_direction);
-			} else {
-				struct scatterlist *sg = (struct scatterlist *)SCpnt->request_buffer;
-				int nents;
-
-				FCD(("XXX: Use_sg %d %d\n", SCpnt->use_sg, sg->length))
-				nents = dma_map_sg (fc->dev, sg, SCpnt->use_sg,
-						    SCpnt->sc_data_direction);
-				if (nents > 1) printk ("%s: SG for nents %d (use_sg %d) not handled yet\n", fc->name, nents, SCpnt->use_sg);
-				fcmd->data = sg_dma_address(sg);
-				cmd->fcp_data_len = sg_dma_len(sg);
-			}
+
+			sg = scsi_sglist(SCpnt);
+			nents = dma_map_sg(fc->dev, sg, scsi_sg_count(SCpnt),
+					   SCpnt->sc_data_direction);
+			fcmd->data = sg_dma_address(sg);
+			cmd->fcp_data_len = sg_dma_len(sg);
 		}
 		memcpy (cmd->fcp_cdb, SCpnt->cmnd, SCpnt->cmd_len);
 		memset (cmd->fcp_cdb+SCpnt->cmd_len, 0, sizeof(cmd->fcp_cdb)-SCpnt->cmd_len);
-- 
1.5.2.4

