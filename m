From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 14/16] libfc: fix fcp pkt recovery in fc_fcp_recv_data
Date: Fri, 12 Mar 2010 16:08:44 -0800
Message-ID: <20100313000844.22251.96719.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26880 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMAIq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:08:46 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Currently fc_fcp_recv_data calls fc_fcp_retry_cmd to
retry failed IO but in this case tgt is still sending
data frames, therefore exchange needs to be aborted
first before initiating retry. So this patch fixes
this by aborting exchange first then have retry.

Renames fc_timeout_error to fc_fcp_recovery since
fc_timeout_error is already called from several other
places beside from fcp timeout handler and then
used fc_fcp_recovery for abort & retry from
fc_fcp_recv_data, this rename also required renaming
FC_CMD_TIME_OUT status to FC_CMD_RECOVERY to be
consistent with new fc_fcp_recovery.

Data frames are not expected for an DDPed exchange and
potentially it could be tampered data frame, so does
recovery in this case by calling fc_fcp_recovery.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |   47 ++++++++++++++++++++++++++-----------------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 6fde2fa..df8be9c 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -96,7 +96,7 @@ static void fc_fcp_resp(struct fc_fcp_pkt *, struct fc_frame *);
 static void fc_fcp_complete_locked(struct fc_fcp_pkt *);
 static void fc_tm_done(struct fc_seq *, struct fc_frame *, void *);
 static void fc_fcp_error(struct fc_fcp_pkt *, struct fc_frame *);
-static void fc_timeout_error(struct fc_fcp_pkt *);
+static void fc_fcp_recovery(struct fc_fcp_pkt *);
 static void fc_fcp_timeout(unsigned long);
 static void fc_fcp_rec(struct fc_fcp_pkt *);
 static void fc_fcp_rec_error(struct fc_fcp_pkt *, struct fc_frame *);
@@ -120,7 +120,7 @@ static void fc_fcp_srr_error(struct fc_fcp_pkt *, struct fc_frame *);
 #define FC_DATA_UNDRUN		7
 #define FC_ERROR		8
 #define FC_HRD_ERROR		9
-#define FC_CMD_TIME_OUT		10
+#define FC_CMD_RECOVERY		10
 
 /*
  * Error recovery timeout values.
@@ -445,9 +445,16 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 	len = fr_len(fp) - sizeof(*fh);
 	buf = fc_frame_payload_get(fp, 0);
 
-	/* if this I/O is ddped, update xfer len */
-	fc_fcp_ddp_done(fsp);
-
+	/*
+	 * if this I/O is ddped then clear it
+	 * and initiate recovery since data
+	 * frames are expected to be placed
+	 * directly in that case.
+	 */
+	if (fsp->xfer_ddp != FC_XID_UNKNOWN) {
+		fc_fcp_ddp_done(fsp);
+		goto err;
+	}
 	if (offset + len > fsp->data_len) {
 		/* this should never happen */
 		if ((fr_flags(fp) & FCPHF_CRC_UNCHECKED) &&
@@ -455,8 +462,7 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 			goto crc_err;
 		FC_FCP_DBG(fsp, "data received past end. len %zx offset %zx "
 			   "data_len %x\n", len, offset, fsp->data_len);
-		fc_fcp_retry_cmd(fsp);
-		return;
+		goto err;
 	}
 	if (offset != fsp->xfer_len)
 		fsp->state |= FC_SRB_DISCONTIG;
@@ -492,7 +498,7 @@ crc_err:
 			 * Otherwise, ignore it.
 			 */
 			if (fsp->state & FC_SRB_DISCONTIG)
-				fc_fcp_retry_cmd(fsp);
+				goto err;
 			return;
 		}
 	}
@@ -508,6 +514,9 @@ crc_err:
 	if (unlikely(fsp->state & FC_SRB_RCV_STATUS) &&
 	    fsp->xfer_len == fsp->data_len - fsp->scsi_resid)
 		fc_fcp_complete_locked(fsp);
+	return;
+err:
+	fc_fcp_recovery(fsp);
 }
 
 /**
@@ -1340,7 +1349,7 @@ static void fc_fcp_timeout(unsigned long data)
 	else if (fsp->state & FC_SRB_RCV_STATUS)
 		fc_fcp_complete_locked(fsp);
 	else
-		fc_timeout_error(fsp);
+		fc_fcp_recovery(fsp);
 	fsp->state &= ~FC_SRB_FCP_PROCESSING_TMO;
 unlock:
 	fc_fcp_unlock_pkt(fsp);
@@ -1384,7 +1393,7 @@ retry:
 	if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 		fc_fcp_timer_set(fsp, FC_SCSI_REC_TOV);
 	else
-		fc_timeout_error(fsp);
+		fc_fcp_recovery(fsp);
 }
 
 /**
@@ -1453,7 +1462,7 @@ static void fc_fcp_rec_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 				fc_fcp_retry_cmd(fsp);
 				break;
 			}
-			fc_timeout_error(fsp);
+			fc_fcp_recovery(fsp);
 			break;
 		}
 	} else if (opcode == ELS_LS_ACC) {
@@ -1568,7 +1577,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 			fc_fcp_rec(fsp);
 		else
-			fc_timeout_error(fsp);
+			fc_fcp_recovery(fsp);
 		break;
 	}
 	fc_fcp_unlock_pkt(fsp);
@@ -1577,12 +1586,12 @@ out:
 }
 
 /**
- * fc_timeout_error() - Handler for fcp_pkt timeouts
- * @fsp: The FCP packt that has timed out
+ * fc_fcp_recovery() - Handler for fcp_pkt recovery
+ * @fsp: The FCP pkt that needs to be aborted
  */
-static void fc_timeout_error(struct fc_fcp_pkt *fsp)
+static void fc_fcp_recovery(struct fc_fcp_pkt *fsp)
 {
-	fsp->status_code = FC_CMD_TIME_OUT;
+	fsp->status_code = FC_CMD_RECOVERY;
 	fsp->cdb_status = 0;
 	fsp->io_status = 0;
 	/*
@@ -1688,7 +1697,7 @@ static void fc_fcp_srr_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 		break;
 	case ELS_LS_RJT:
 	default:
-		fc_timeout_error(fsp);
+		fc_fcp_recovery(fsp);
 		break;
 	}
 	fc_fcp_unlock_pkt(fsp);
@@ -1714,7 +1723,7 @@ static void fc_fcp_srr_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 			fc_fcp_rec(fsp);
 		else
-			fc_timeout_error(fsp);
+			fc_fcp_recovery(fsp);
 		break;
 	case -FC_EX_CLOSED:			/* e.g., link failure */
 		/* fall through */
@@ -1933,7 +1942,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 	case FC_CMD_ABORTED:
 		sc_cmd->result = (DID_ERROR << 16) | fsp->io_status;
 		break;
-	case FC_CMD_TIME_OUT:
+	case FC_CMD_RECOVERY:
 		sc_cmd->result = (DID_BUS_BUSY << 16) | fsp->io_status;
 		break;
 	case FC_CMD_RESET:

