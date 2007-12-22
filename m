From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 2/5] iscsi bidi support
Date: Sat, 22 Dec 2007 15:10:08 -0500
Message-ID: <20071222201954.755E3900CDB@quasar.osc.edu>
References: <20071222201558.GA25063@osc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:53854 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbXLVUcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Dec 2007 15:32:05 -0500
In-Reply-To: <20071222201558.GA25063@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

From: Boaz Harrosh <bharrosh@panasas.com>

Adapted from separate libiscsi and TCP patches by Boaz to update for
iscsi changes and iscsi-tcp rewrite.  Dropped some needless conversion
to scsi_out() in some places.  Original log follows.

Once bidi support is accepted at block and scsi-ml layers
below bidi support to iscsi can be applied.
The assumed bidi API from scsi-ml is based on scsi_sgtables
but it is not at all far from any other implementation as far
as iscsi code is concerned:
- scsi_bidi_cmd() - return true if the command is bidi. Note
		    that this is a deviation from previous RFCs
		    in that we no longer have sc_dma_direction
		    == DMA_BIDIRECTIONAL. The command direction is DMA_TO_DEVICE
		    but with this flag on.
- scsi_{in,out}() - Which will return the right sg_table for IN or OUT
		    operation, in a generic way.
		    The small difference here due to sgtable implementation
		    is that in the past we had scsi_in()->sglist == NULL for
		    DMA_NONE and now we have scsi_in() == NULL.

At the generic libiscsi level
- prepare the additional bidi_read rlength header.
- access the right scsi_in() and/or scsi_out() side of things.
also for resid.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/scsi/iscsi_tcp.c |   14 ++++---
 drivers/scsi/libiscsi.c  |   81 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 78 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9fde5ce..373639a 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -542,10 +542,11 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	tcp_ctask->exp_datasn++;
 
 	tcp_ctask->data_offset = be32_to_cpu(rhdr->offset);
-	if (tcp_ctask->data_offset + tcp_conn->in.datalen > scsi_bufflen(sc)) {
+	if (tcp_ctask->data_offset + tcp_conn->in.datalen >
+							scsi_in(sc)->length) {
 		debug_tcp("%s: data_offset(%d) + data_len(%d) > total_length_in(%d)\n",
 		          __FUNCTION__, tcp_ctask->data_offset,
-		          tcp_conn->in.datalen, scsi_bufflen(sc));
+			  tcp_conn->in.datalen, scsi_in(sc)->length);
 		return ISCSI_ERR_DATA_OFFSET;
 	}
 
@@ -558,8 +559,8 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 
 			if (res_count > 0 &&
 			    (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
-			     res_count <= scsi_bufflen(sc)))
-				scsi_set_resid(sc, res_count);
+			     res_count <= scsi_in(sc)->length))
+				scsi_in(sc)->resid = res_count;
 			else
 				sc->result = (DID_BAD_TARGET << 16) |
 					rhdr->cmd_status;
@@ -783,8 +784,9 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 				  tcp_ctask->data_offset,
 				  tcp_conn->in.datalen);
 			return iscsi_segment_seek_sg(&tcp_conn->in.segment,
-						     scsi_sglist(ctask->sc),
-						     scsi_sg_count(ctask->sc),
+						     scsi_in(ctask->sc)->sglist,
+						     scsi_in(ctask->sc)->
+								sg_count,
 						     tcp_ctask->data_offset,
 						     tcp_conn->in.datalen,
 						     iscsi_tcp_process_data_in,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 94a8046..cb7f539 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -176,6 +176,30 @@ static int iscsi_prep_ecdb_ahs(struct iscsi_cmd_task *ctask)
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
+	rlen_ahdr->ahslength = cpu_to_be16(sizeof(rlen_ahdr->read_length) +
+					   sizeof(rlen_ahdr->reserved));
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
@@ -200,7 +224,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	hdr->flags = ISCSI_ATTR_SIMPLE;
 	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
 	hdr->itt = build_itt(ctask->itt, conn->id, session->age);
-	hdr->data_length = cpu_to_be32(scsi_bufflen(sc));
 	hdr->cmdsn = cpu_to_be32(session->cmdsn);
 	session->cmdsn++;
 	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
@@ -216,9 +239,18 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	}
 	memcpy(hdr->cdb, sc->cmnd, cmd_len);
 
+	if (scsi_bidi_cmnd(sc)) {
+		hdr->flags |= ISCSI_FLAG_CMD_READ;
+		rc = iscsi_prep_bidi_ahs(ctask);
+		if (rc)
+			return rc;
+	}
+
 	ctask->imm_count = 0;
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
+		unsigned int out_len = scsi_out(sc)->length;
 		hdr->flags |= ISCSI_FLAG_CMD_WRITE;
+		hdr->data_length = cpu_to_be32(out_len);
 		/*
 		 * Write counters:
 		 *
@@ -238,19 +270,19 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
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
+					     - ctask->imm_count;
 			ctask->unsol_offset = ctask->imm_count;
 		}
 
@@ -259,6 +291,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 			hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 	} else {
 		hdr->flags |= ISCSI_FLAG_CMD_FINAL;
+		hdr->data_length = cpu_to_be32(scsi_bufflen(sc));
 		zero_data(hdr->dlength);
 
 		if (sc->sc_data_direction == DMA_FROM_DEVICE)
@@ -279,9 +312,11 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 
 	conn->scsicmd_pdus_cnt++;
 	debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x len %d "
-		"cmdsn %d win %d]\n",
+		"bidi_len %d cmdsn %d win %d]\n",
+		scsi_bidi_cmnd(sc) ? "bidirectional" :
 		sc->sc_data_direction == DMA_TO_DEVICE ? "write" : "read",
 		conn->id, sc, sc->cmnd[0], ctask->itt, scsi_bufflen(sc),
+		scsi_bidi_cmnd(sc) ? scsi_in(sc)->length : 0,
 		session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
 	return 0;
 }
@@ -344,7 +379,12 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 		conn->session->tt->cleanup_cmd_task(conn, ctask);
 
 	sc->result = err;
-	scsi_set_resid(sc, scsi_bufflen(sc));
+	if (scsi_bidi_cmnd(sc)) {
+		scsi_out(sc)->resid = scsi_out(sc)->length;
+		scsi_in(sc)->resid = scsi_in(sc)->length;
+	} else {
+		scsi_set_resid(sc, scsi_bufflen(sc));
+	}
 	if (conn->ctask == ctask)
 		conn->ctask = NULL;
 	/* release ref from queuecommand */
@@ -488,9 +528,23 @@ invalid_datalen:
 			scsi_set_resid(sc, res_count);
 		else
 			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
-	} else if (rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
-	                          ISCSI_FLAG_CMD_BIDI_OVERFLOW))
-		sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
+	}
+	if (rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
+			   ISCSI_FLAG_CMD_BIDI_OVERFLOW)) {
+		if (scsi_bidi_cmnd(sc)) {
+			int res_count = be32_to_cpu(rhdr->bi_residual_count);
+
+			if (res_count > 0 &&
+			    (rhdr->flags & ISCSI_FLAG_CMD_BIDI_OVERFLOW ||
+			     res_count <= scsi_in(sc)->length))
+				scsi_in(sc)->resid = res_count;
+			else
+				sc->result = (DID_BAD_TARGET << 16) |
+					     rhdr->cmd_status;
+		} else {
+			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
+		}
+	}
 
 out:
 	debug_scsi("done [sc %lx res %d itt 0x%x]\n",
@@ -1140,7 +1194,12 @@ fault:
 	printk(KERN_ERR "iscsi: cmd 0x%x is not queued (%d)\n",
 	       sc->cmnd[0], reason);
 	sc->result = (DID_NO_CONNECT << 16);
-	scsi_set_resid(sc, scsi_bufflen(sc));
+	if (scsi_bidi_cmnd(sc)) {
+		scsi_out(sc)->resid = scsi_out(sc)->length;
+		scsi_in(sc)->resid = scsi_in(sc)->length;
+	} else {
+		scsi_set_resid(sc, scsi_bufflen(sc));
+	}
 	sc->scsi_done(sc);
 	spin_lock(host->host_lock);
 	return 0;
-- 
1.5.3.6

