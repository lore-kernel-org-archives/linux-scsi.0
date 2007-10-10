From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 21/24 ver2] qlogicpti.c: convert to accessors and !use_sg
 cleanup
Date: Wed, 10 Oct 2007 20:25:30 +0200
Message-ID: <470D191A.6090101@panasas.com>
References: <46E6F92D.2090409@panasas.com> <46E72E52.7030607@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:26411 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752466AbXJJSZi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Oct 2007 14:25:38 -0400
In-Reply-To: <46E72E52.7030607@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>


 - convert to accessors and !use_sg cleanup

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/qlogicpti.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index e93f803..db43d1c 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -871,11 +871,12 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
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
@@ -913,16 +914,6 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
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
@@ -1158,17 +1149,11 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
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


