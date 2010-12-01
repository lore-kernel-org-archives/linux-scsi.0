From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/27] libfc: incorrect scsi host byte codes returned to
	scsi-ml
Date: Tue, 30 Nov 2010 16:18:39 -0800
Message-ID: <20101201001838.18369.63853.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61256 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0LAASo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:18:44 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: John Fastabend <john.r.fastabend@intel.com>

From: john fastabend <john.r.fastabend@intel.com>

The fcp packet recovery handler fc_fcp_recover() is called
when errors occurr in a fcp session. Currently it is
generically setting the status code to FC_CMD_RECOVERY for
all error types. This results in DID_BUS_BUSY errors
being returned to the scsi-ml.

DID_BUS_BUSY errors indicate "BUS stayed busy through time
out period" according to scsi.h. Many of the error reported
by fc_rcp_recovery() are pkt errors. Here we update
fc_fcp_recovery to use better host byte codes.

With certain FAST FAIL flags set DID_BUS_BUSY and DID_ERROR
will have different behaviors this was causing dm multipath
to fail quickly in some cases where a retry would be a
better action.

Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |   61 +++++++++++++++++++++++++++++--------------
 1 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index eb3fe37..87361cc 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -96,7 +96,7 @@ static void fc_fcp_resp(struct fc_fcp_pkt *, struct fc_frame *);
 static void fc_fcp_complete_locked(struct fc_fcp_pkt *);
 static void fc_tm_done(struct fc_seq *, struct fc_frame *, void *);
 static void fc_fcp_error(struct fc_fcp_pkt *, struct fc_frame *);
-static void fc_fcp_recovery(struct fc_fcp_pkt *);
+static void fc_fcp_recovery(struct fc_fcp_pkt *, u8 code);
 static void fc_fcp_timeout(unsigned long);
 static void fc_fcp_rec(struct fc_fcp_pkt *);
 static void fc_fcp_rec_error(struct fc_fcp_pkt *, struct fc_frame *);
@@ -120,7 +120,8 @@ static void fc_fcp_srr_error(struct fc_fcp_pkt *, struct fc_frame *);
 #define FC_DATA_UNDRUN		7
 #define FC_ERROR		8
 #define FC_HRD_ERROR		9
-#define FC_CMD_RECOVERY		10
+#define FC_CRC_ERROR		10
+#define FC_TIMED_OUT		11
 
 /*
  * Error recovery timeout values.
@@ -438,6 +439,7 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 	void *buf;
 	struct scatterlist *sg;
 	u32 nents;
+	u8 host_bcode = FC_COMPLETE;
 
 	fh = fc_frame_header_get(fp);
 	offset = ntohl(fh->fh_parm_offset);
@@ -446,13 +448,16 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 	buf = fc_frame_payload_get(fp, 0);
 
 	/*
-	 * if this I/O is ddped then clear it
-	 * and initiate recovery since data
-	 * frames are expected to be placed
-	 * directly in that case.
+	 * if this I/O is ddped then clear it and initiate recovery since data
+	 * frames are expected to be placed directly in that case.
+	 *
+	 * Indicate error to scsi-ml because something went wrong with the
+	 * ddp handling to get us here.
 	 */
 	if (fsp->xfer_ddp != FC_XID_UNKNOWN) {
 		fc_fcp_ddp_done(fsp);
+		FC_FCP_DBG(fsp, "DDP I/O in fc_fcp_recv_data set ERROR\n");
+		host_bcode = FC_ERROR;
 		goto err;
 	}
 	if (offset + len > fsp->data_len) {
@@ -462,6 +467,9 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 			goto crc_err;
 		FC_FCP_DBG(fsp, "data received past end. len %zx offset %zx "
 			   "data_len %x\n", len, offset, fsp->data_len);
+
+		/* Data is corrupted indicate scsi-ml should retry */
+		host_bcode = FC_DATA_OVRRUN;
 		goto err;
 	}
 	if (offset != fsp->xfer_len)
@@ -498,8 +506,10 @@ crc_err:
 			 * If so, we need to retry the entire operation.
 			 * Otherwise, ignore it.
 			 */
-			if (fsp->state & FC_SRB_DISCONTIG)
+			if (fsp->state & FC_SRB_DISCONTIG) {
+				host_bcode = FC_CRC_ERROR;
 				goto err;
+			}
 			return;
 		}
 	}
@@ -517,7 +527,7 @@ crc_err:
 		fc_fcp_complete_locked(fsp);
 	return;
 err:
-	fc_fcp_recovery(fsp);
+	fc_fcp_recovery(fsp, host_bcode);
 }
 
 /**
@@ -1347,7 +1357,7 @@ static void fc_fcp_timeout(unsigned long data)
 	else if (fsp->state & FC_SRB_RCV_STATUS)
 		fc_fcp_complete_locked(fsp);
 	else
-		fc_fcp_recovery(fsp);
+		fc_fcp_recovery(fsp, FC_TIMED_OUT);
 	fsp->state &= ~FC_SRB_FCP_PROCESSING_TMO;
 unlock:
 	fc_fcp_unlock_pkt(fsp);
@@ -1391,7 +1401,7 @@ retry:
 	if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 		fc_fcp_timer_set(fsp, FC_SCSI_REC_TOV);
 	else
-		fc_fcp_recovery(fsp);
+		fc_fcp_recovery(fsp, FC_TIMED_OUT);
 }
 
 /**
@@ -1460,7 +1470,7 @@ static void fc_fcp_rec_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 				fc_fcp_retry_cmd(fsp);
 				break;
 			}
-			fc_fcp_recovery(fsp);
+			fc_fcp_recovery(fsp, FC_ERROR);
 			break;
 		}
 	} else if (opcode == ELS_LS_ACC) {
@@ -1575,7 +1585,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 			fc_fcp_rec(fsp);
 		else
-			fc_fcp_recovery(fsp);
+			fc_fcp_recovery(fsp, FC_ERROR);
 		break;
 	}
 	fc_fcp_unlock_pkt(fsp);
@@ -1587,9 +1597,9 @@ out:
  * fc_fcp_recovery() - Handler for fcp_pkt recovery
  * @fsp: The FCP pkt that needs to be aborted
  */
-static void fc_fcp_recovery(struct fc_fcp_pkt *fsp)
+static void fc_fcp_recovery(struct fc_fcp_pkt *fsp, u8 code)
 {
-	fsp->status_code = FC_CMD_RECOVERY;
+	fsp->status_code = code;
 	fsp->cdb_status = 0;
 	fsp->io_status = 0;
 	/*
@@ -1695,7 +1705,7 @@ static void fc_fcp_srr_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 		break;
 	case ELS_LS_RJT:
 	default:
-		fc_fcp_recovery(fsp);
+		fc_fcp_recovery(fsp, FC_ERROR);
 		break;
 	}
 	fc_fcp_unlock_pkt(fsp);
@@ -1721,7 +1731,7 @@ static void fc_fcp_srr_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 			fc_fcp_rec(fsp);
 		else
-			fc_fcp_recovery(fsp);
+			fc_fcp_recovery(fsp, FC_TIMED_OUT);
 		break;
 	case -FC_EX_CLOSED:			/* e.g., link failure */
 		/* fall through */
@@ -1944,18 +1954,29 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		break;
 	case FC_CMD_ABORTED:
 		FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
-			   "due to FC_CMD_ABORTED\n");
+			  "due to FC_CMD_ABORTED\n");
 		sc_cmd->result = (DID_ERROR << 16) | fsp->io_status;
 		break;
-	case FC_CMD_RECOVERY:
-		sc_cmd->result = (DID_BUS_BUSY << 16) | fsp->io_status;
-		break;
 	case FC_CMD_RESET:
+		FC_FCP_DBG(fsp, "Returning DID_RESET to scsi-ml "
+			   "due to FC_CMD_RESET\n");
 		sc_cmd->result = (DID_RESET << 16);
 		break;
 	case FC_HRD_ERROR:
+		FC_FCP_DBG(fsp, "Returning DID_NO_CONNECT to scsi-ml "
+			   "due to FC_HRD_ERROR\n");
 		sc_cmd->result = (DID_NO_CONNECT << 16);
 		break;
+	case FC_CRC_ERROR:
+		FC_FCP_DBG(fsp, "Returning DID_PARITY to scsi-ml "
+			   "due to FC_CRC_ERROR\n");
+		sc_cmd->result = (DID_PARITY << 16);
+		break;
+	case FC_TIMED_OUT:
+		FC_FCP_DBG(fsp, "Returning DID_BUS_BUSY to scsi-ml "
+			   "due to FC_TIMED_OUT\n");
+		sc_cmd->result = (DID_BUS_BUSY << 16) | fsp->io_status;
+		break;
 	default:
 		FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
 			   "due to unknown error\n");

