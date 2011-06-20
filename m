From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v2 05/12] fcoe: Unable to select the exchangeID from offload
 pool for storage targets
Date: Mon, 20 Jun 2011 16:59:15 -0700
Message-ID: <20110620235915.1777.70466.stgit@localhost6.localdomain6>
References: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49618 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351Ab1FTX7P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 19:59:15 -0400
In-Reply-To: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kiran Patil <kiran.patil@intel.com>

From: Kiran Patil <kiran.patil@intel.com>

Problem: When initiator sends write command to target, target tries to assign new sequence. It
         allocates new exchangeID (RX_ID) always from non-offloaded pool (Non-offload EMA)

Fix:     Enhanced fcoe_oem_match routine to look at F_CTL flags and if it is exchange responder and
         command type is WRITEDATA, then function returns TRUE instead of FALSE. This function
         is used to determine which pool to use (offload pool of exchange is used only if this
         function returns TRUE).

Technical Notes: N/A

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index f76a321..6378c58 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -751,12 +751,27 @@ static int fcoe_shost_config(struct fc_lport *lport, struct device *dev)
  * The offload EM that this routine is associated with will handle any
  * packets that are for SCSI read requests.
  *
+ * This has been enhanced to work when FCoE stack is operating in target
+ * mode.
+ *
  * Returns: True for read types I/O, otherwise returns false.
  */
 bool fcoe_oem_match(struct fc_frame *fp)
 {
-	return fc_fcp_is_read(fr_fsp(fp)) &&
-		(fr_fsp(fp)->data_len > fcoe_ddp_min);
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	struct fcp_cmnd *fcp;
+
+	if (fc_fcp_is_read(fr_fsp(fp)) &&
+	    (fr_fsp(fp)->data_len > fcoe_ddp_min))
+		return true;
+	else if (!(ntoh24(fh->fh_f_ctl) & FC_FC_EX_CTX)) {
+		fcp = fc_frame_payload_get(fp, sizeof(*fcp));
+		if (ntohs(fh->fh_rx_id) == FC_XID_UNKNOWN &&
+		    fcp && (ntohl(fcp->fc_dl) > fcoe_ddp_min) &&
+		    (fcp->fc_flags & FCP_CFL_WRDATA))
+			return true;
+	}
+	return false;
 }
 
 /**

