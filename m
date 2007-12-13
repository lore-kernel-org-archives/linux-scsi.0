From: michaelc@cs.wisc.edu
Subject: [PATCH 03/24] Prettify resid handling and some extra checks
Date: Thu, 13 Dec 2007 12:43:22 -0600
Message-ID: <11975714303190-git-send-email-michaelc@cs.wisc.edu>
References: <11975714233983-git-send-email-michaelc@cs.wisc.edu>
 <1197571428957-git-send-email-michaelc@cs.wisc.edu>
 <11975714291290-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764636AbXLMSpn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:45:43 -0500
In-Reply-To: <11975714291290-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>

From: Mike Christie <michaelc@cs.wisc.edu>

from Boaz Harrosh:
  - Check to see that OVERFLOW is not negative indicating
    a bug.
  - Unify handling of UNDERFLOW and OVERFLOW to the same
    code.
  - Also handle BIDI_OVERFLOW.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   16 +++++++---------
 drivers/scsi/libiscsi.c  |   12 +++++++-----
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 1b540e0..fd88777 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -507,22 +507,20 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	}
 
 	if (rhdr->flags & ISCSI_FLAG_DATA_STATUS) {
+		sc->result = (DID_OK << 16) | rhdr->cmd_status;
 		conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
-		if (rhdr->flags & ISCSI_FLAG_DATA_UNDERFLOW) {
+		if (rhdr->flags & (ISCSI_FLAG_DATA_UNDERFLOW |
+		                   ISCSI_FLAG_DATA_OVERFLOW)) {
 			int res_count = be32_to_cpu(rhdr->residual_count);
 
 			if (res_count > 0 &&
-			    res_count <= scsi_bufflen(sc)) {
+			    (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
+			     res_count <= scsi_bufflen(sc)))
 				scsi_set_resid(sc, res_count);
-				sc->result = (DID_OK << 16) | rhdr->cmd_status;
-			} else
+			else
 				sc->result = (DID_BAD_TARGET << 16) |
 					rhdr->cmd_status;
-		} else if (rhdr->flags & ISCSI_FLAG_DATA_OVERFLOW) {
-			scsi_set_resid(sc, be32_to_cpu(rhdr->residual_count));
-			sc->result = (DID_OK << 16) | rhdr->cmd_status;
-		} else
-			sc->result = (DID_OK << 16) | rhdr->cmd_status;
+		}
 	}
 
 	conn->datain_pdus_cnt++;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 176458f..0beb4c6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -291,17 +291,19 @@ invalid_datalen:
 			   min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
 	}
 
-	if (rhdr->flags & ISCSI_FLAG_CMD_UNDERFLOW) {
+	if (rhdr->flags & (ISCSI_FLAG_CMD_UNDERFLOW |
+	                   ISCSI_FLAG_CMD_OVERFLOW)) {
 		int res_count = be32_to_cpu(rhdr->residual_count);
 
-		if (res_count > 0 && res_count <= scsi_bufflen(sc))
+		if (res_count > 0 &&
+		    (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
+		     res_count <= scsi_bufflen(sc)))
 			scsi_set_resid(sc, res_count);
 		else
 			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
-	} else if (rhdr->flags & ISCSI_FLAG_CMD_BIDI_UNDERFLOW)
+	} else if (rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
+	                          ISCSI_FLAG_CMD_BIDI_OVERFLOW))
 		sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
-	else if (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW)
-		scsi_set_resid(sc, be32_to_cpu(rhdr->residual_count));
 
 out:
 	debug_scsi("done [sc %lx res %d itt 0x%x]\n",
-- 
1.5.1.2

