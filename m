From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 21/24] qlogicpti.c: convert to accessors and !use_sg cleanup
Date: Wed, 12 Sep 2007 03:09:54 +0300
Message-ID: <46E72E52.7030607@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:30643 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752560AbXILANi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 20:13:38 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


 - convert to accessors and !use_sg cleanup

[Note: This patch might conflict with upstream patches to this driver.
 If so, please tell me and I'll fix it.]

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/qlogicpti.c |   54 +++++++++------------------------------------
 1 files changed, 11 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 5948872..b685c4f 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -873,11 +873,12 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
 	struct scatterlist *sg;
 	int i, n;
 
-	if (Cmnd->use_sg) {
+	if (scsi_bufflen(Cmnd)) {
 		int sg_count;
 
-		sg = (struct scatterlist *) Cmnd->request_buffer;
-		sg_count = sbus_map_sg(qpti->sdev, sg, Cmnd->use_sg, Cmnd->sc_data_direction);
+		sg = scsi_sglist(Cmnd);
+		sg_count = sbus_map_sg(qpti->sdev, sg, scsi_sg_count(Cmnd),
+		                                      Cmnd->sc_data_direction);
 
 		ds = cmd->dataseg;
 		cmd->segment_cnt = sg_count;
@@ -915,16 +916,6 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
 			}
 			sg_count -= n;
 		}
-	} else if (Cmnd->request_bufflen) {
-		Cmnd->SCp.ptr = (char *)(unsigned long)
-			sbus_map_single(qpti->sdev,
-					Cmnd->request_buffer,
-					Cmnd->request_bufflen,
-					Cmnd->sc_data_direction);
-
-		cmd->dataseg[0].d_base = (u32) ((unsigned long)Cmnd->SCp.ptr);
-		cmd->dataseg[0].d_count = Cmnd->request_bufflen;
-		cmd->segment_cnt = 1;
 	} else {
 		cmd->dataseg[0].d_base = 0;
 		cmd->dataseg[0].d_count = 0;
@@ -953,32 +944,15 @@ static inline void update_can_queue(struct Scsi_Host *host, u_int in_ptr, u_int
 
 static unsigned int scsi_rbuf_get(struct scsi_cmnd *cmd, unsigned char **buf_out)
 {
-	unsigned char *buf;
-	unsigned int buflen;
+	struct scatterlist *sg = scsi_sglist(cmd);
 
-	if (cmd->use_sg) {
-		struct scatterlist *sg;
-
-		sg = (struct scatterlist *) cmd->request_buffer;
-		buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
-		buflen = sg->length;
-	} else {
-		buf = cmd->request_buffer;
-		buflen = cmd->request_bufflen;
-	}
-
-	*buf_out = buf;
-	return buflen;
+	*buf_out = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+	return sg->length;
 }
 
 static void scsi_rbuf_put(struct scsi_cmnd *cmd, unsigned char *buf)
 {
-	if (cmd->use_sg) {
-		struct scatterlist *sg;
-
-		sg = (struct scatterlist *) cmd->request_buffer;
-		kunmap_atomic(buf - sg->offset, KM_IRQ0);
-	}
+	kunmap_atomic(buf - scsi_sglist(cmd)->offset, KM_IRQ0);
 }
 
 /*
@@ -1278,17 +1252,11 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
 		else
 			Cmnd->result = DID_ERROR << 16;
 
-		if (Cmnd->use_sg) {
+		if (scsi_bufflen(Cmnd))
 			sbus_unmap_sg(qpti->sdev,
-				      (struct scatterlist *)Cmnd->request_buffer,
-				      Cmnd->use_sg,
+				      scsi_sglist(Cmnd), scsi_sg_count(Cmnd),
 				      Cmnd->sc_data_direction);
-		} else if (Cmnd->request_bufflen) {
-			sbus_unmap_single(qpti->sdev,
-					  (__u32)((unsigned long)Cmnd->SCp.ptr),
-					  Cmnd->request_bufflen,
-					  Cmnd->sc_data_direction);
-		}
+
 		qpti->cmd_count[Cmnd->device->id]--;
 		sbus_writew(out_ptr, qpti->qregs + MBOX5);
 		Cmnd->host_scribble = (unsigned char *) done_queue;
-- 
1.5.3.1


