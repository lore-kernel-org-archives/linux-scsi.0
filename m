From: michaelc@cs.wisc.edu
Subject: [PATCH 2/3] iscsi: bidi support - libiscsi
Date: Fri, 18 Apr 2008 10:11:52 -0500
Message-ID: <1208531513-5122-3-git-send-email-michaelc@cs.wisc.edu>
References: <1208531513-5122-1-git-send-email-michaelc@cs.wisc.edu>
 <1208531513-5122-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYDRPM0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 11:12:26 -0400
In-Reply-To: <1208531513-5122-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Boaz Harrosh <bharrosh@panasas.com>

  iscsi bidi support at the generic libiscsi level
  - prepare the additional bidi_read rlength header.
  - access the right scsi_in() and/or scsi_out() side of things.
    also for resid.
  - Handle BIDI underflow overflow from target

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Pete Wyckoff <pw@osc.edu>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   85 ++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 70 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 2f6b095..010c1b9 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -176,6 +176,31 @@ static int iscsi_prep_ecdb_ahs(struct iscsi_cmd_task *ctask)
 	return 0;
 }
 
+static int iscsi_prep_bidi_ahs(struct iscsi_cmd_task *ctask)
+{
+	struct scsi_cmnd *sc = ctask->sc;
+	struct iscsi_rlength_ahdr *rlen_ahdr;
+	int rc;
+
+	rlen_ahdr = iscsi_next_hdr(ctask);
+	rc = iscsi_add_hdr(ctask, sizeof(*rlen_ahdr));
+	if (rc)
+		return rc;
+
+	rlen_ahdr->ahslength =
+		cpu_to_be16(sizeof(rlen_ahdr->read_length) +
+						  sizeof(rlen_ahdr->reserved));
+	rlen_ahdr->ahstype = ISCSI_AHSTYPE_RLENGTH;
+	rlen_ahdr->reserved = 0;
+	rlen_ahdr->read_length = cpu_to_be32(scsi_in(sc)->length);
+
+	debug_scsi("bidi-in rlen_ahdr->read_length(%d) "
+		   "rlen_ahdr->ahslength(%d)\n",
+		   be32_to_cpu(rlen_ahdr->read_length),
+		   be16_to_cpu(rlen_ahdr->ahslength));
+	return 0;
+}
+
 /**
  * iscsi_prep_scsi_cmd_pdu - prep iscsi scsi cmd pdu
  * @ctask: iscsi cmd task
@@ -200,7 +225,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	hdr->flags = ISCSI_ATTR_SIMPLE;
 	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
 	hdr->itt = build_itt(ctask->itt, session->age);
-	hdr->data_length = cpu_to_be32(scsi_bufflen(sc));
 	hdr->cmdsn = cpu_to_be32(session->cmdsn);
 	session->cmdsn++;
 	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
@@ -216,7 +240,15 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	memcpy(hdr->cdb, sc->cmnd, cmd_len);
 
 	ctask->imm_count = 0;
+	if (scsi_bidi_cmnd(sc)) {
+		hdr->flags |= ISCSI_FLAG_CMD_READ;
+		rc = iscsi_prep_bidi_ahs(ctask);
+		if (rc)
+			return rc;
+	}
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
+		unsigned out_len = scsi_out(sc)->length;
+		hdr->data_length = cpu_to_be32(out_len);
 		hdr->flags |= ISCSI_FLAG_CMD_WRITE;
 		/*
 		 * Write counters:
@@ -237,19 +269,19 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 		ctask->unsol_datasn = 0;
 
 		if (session->imm_data_en) {
-			if (scsi_bufflen(sc) >= session->first_burst)
+			if (out_len >= session->first_burst)
 				ctask->imm_count = min(session->first_burst,
 							conn->max_xmit_dlength);
 			else
-				ctask->imm_count = min(scsi_bufflen(sc),
+				ctask->imm_count = min(out_len,
 							conn->max_xmit_dlength);
 			hton24(hdr->dlength, ctask->imm_count);
 		} else
 			zero_data(hdr->dlength);
 
 		if (!session->initial_r2t_en) {
-			ctask->unsol_count = min((session->first_burst),
-				(scsi_bufflen(sc))) - ctask->imm_count;
+			ctask->unsol_count = min(session->first_burst, out_len)
+							     - ctask->imm_count;
 			ctask->unsol_offset = ctask->imm_count;
 		}
 
@@ -259,6 +291,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	} else {
 		hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 		zero_data(hdr->dlength);
+		hdr->data_length = cpu_to_be32(scsi_in(sc)->length);
 
 		if (sc->sc_data_direction == DMA_FROM_DEVICE)
 			hdr->flags |= ISCSI_FLAG_CMD_READ;
@@ -277,10 +310,12 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 		return EIO;
 
 	conn->scsicmd_pdus_cnt++;
-	debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x len %d "
-		"cmdsn %d win %d]\n",
-		sc->sc_data_direction == DMA_TO_DEVICE ? "write" : "read",
-		conn->id, sc, sc->cmnd[0], ctask->itt, scsi_bufflen(sc),
+	debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x "
+		"len %d bidi_len %d cmdsn %d win %d]\n",
+		scsi_bidi_cmnd(sc) ? "bidirectional" :
+		     sc->sc_data_direction == DMA_TO_DEVICE ? "write" : "read",
+		conn->id, sc, sc->cmnd[0], ctask->itt,
+		scsi_bufflen(sc), scsi_bidi_cmnd(sc) ? scsi_in(sc)->length : 0,
 		session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
 	return 0;
 }
@@ -343,7 +378,12 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 		conn->session->tt->cleanup_cmd_task(conn, ctask);
 
 	sc->result = err;
-	scsi_set_resid(sc, scsi_bufflen(sc));
+	if (!scsi_bidi_cmnd(sc))
+		scsi_set_resid(sc, scsi_bufflen(sc));
+	else {
+		scsi_out(sc)->resid = scsi_out(sc)->length;
+		scsi_in(sc)->resid = scsi_in(sc)->length;
+	}
 	if (conn->ctask == ctask)
 		conn->ctask = NULL;
 	/* release ref from queuecommand */
@@ -478,6 +518,18 @@ invalid_datalen:
 			   min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
 	}
 
+	if (rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
+			   ISCSI_FLAG_CMD_BIDI_OVERFLOW)) {
+		int res_count = be32_to_cpu(rhdr->bi_residual_count);
+
+		if (scsi_bidi_cmnd(sc) && res_count > 0 &&
+				(rhdr->flags & ISCSI_FLAG_CMD_BIDI_OVERFLOW ||
+				 res_count <= scsi_in(sc)->length))
+			scsi_in(sc)->resid = res_count;
+		else
+			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
+	}
+
 	if (rhdr->flags & (ISCSI_FLAG_CMD_UNDERFLOW |
 	                   ISCSI_FLAG_CMD_OVERFLOW)) {
 		int res_count = be32_to_cpu(rhdr->residual_count);
@@ -485,13 +537,11 @@ invalid_datalen:
 		if (res_count > 0 &&
 		    (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
 		     res_count <= scsi_bufflen(sc)))
+			/* write side for bidi or uni-io set_resid */
 			scsi_set_resid(sc, res_count);
 		else
 			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
-	} else if (rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
-	                          ISCSI_FLAG_CMD_BIDI_OVERFLOW))
-		sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
-
+	}
 out:
 	debug_scsi("done [sc %lx res %d itt 0x%x]\n",
 		   (long)sc, sc->result, ctask->itt);
@@ -1147,7 +1197,12 @@ reject:
 fault:
 	spin_unlock(&session->lock);
 	debug_scsi("iscsi: cmd 0x%x is not queued (%d)\n", sc->cmnd[0], reason);
-	scsi_set_resid(sc, scsi_bufflen(sc));
+	if (!scsi_bidi_cmnd(sc))
+		scsi_set_resid(sc, scsi_bufflen(sc));
+	else {
+		scsi_out(sc)->resid = scsi_out(sc)->length;
+		scsi_in(sc)->resid = scsi_in(sc)->length;
+	}
 	sc->scsi_done(sc);
 	spin_lock(host->host_lock);
 	return 0;
-- 
1.5.4.1

