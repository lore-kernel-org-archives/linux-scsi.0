From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/16] libfc: Add debug statements when fc_fcp returns
	DID_ERROR to scsi-ml
Date: Fri, 12 Mar 2010 16:08:50 -0800
Message-ID: <20100313000850.22251.93153.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26880 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMAIu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:08:50 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

DID_ERROR cases can be ambigouos. Debugging FCP error cases
will be much easier if we have debug statements when we hit
these error conditions.

This patch simply adds debug messages using the FC_FCP_DBG
macro when we return DID_ERROR to SCSI. This way if a DID_ERROR
is reproducible turning on debug_logging will give a clue
to developers as to what the problem might be.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index df8be9c..5340d00 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1915,6 +1915,8 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		}
 		break;
 	case FC_ERROR:
+		FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
+			   "due to FC_ERROR\n");
 		sc_cmd->result = DID_ERROR << 16;
 		break;
 	case FC_DATA_UNDRUN:
@@ -1923,12 +1925,19 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			 * scsi status is good but transport level
 			 * underrun.
 			 */
-			sc_cmd->result = (fsp->state & FC_SRB_RCV_STATUS ?
-					  DID_OK : DID_ERROR) << 16;
+			if (fsp->state & FC_SRB_RCV_STATUS) {
+				sc_cmd->result = DID_OK << 16;
+			} else {
+				FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml"
+					   " due to FC_DATA_UNDRUN (trans)\n");
+				sc_cmd->result = DID_ERROR << 16;
+			}
 		} else {
 			/*
 			 * scsi got underrun, this is an error
 			 */
+			FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
+				   "due to FC_DATA_UNDRUN (scsi)\n");
 			CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
 			sc_cmd->result = (DID_ERROR << 16) | fsp->cdb_status;
 		}
@@ -1937,9 +1946,13 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		/*
 		 * overrun is an error
 		 */
+		FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
+			   "due to FC_DATA_OVRRUN\n");
 		sc_cmd->result = (DID_ERROR << 16) | fsp->cdb_status;
 		break;
 	case FC_CMD_ABORTED:
+		FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
+			   "due to FC_CMD_ABORTED\n");
 		sc_cmd->result = (DID_ERROR << 16) | fsp->io_status;
 		break;
 	case FC_CMD_RECOVERY:
@@ -1952,6 +1965,8 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		sc_cmd->result = (DID_NO_CONNECT << 16);
 		break;
 	default:
+		FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
+			   "due to unknown error\n");
 		sc_cmd->result = (DID_ERROR << 16);
 		break;
 	}

