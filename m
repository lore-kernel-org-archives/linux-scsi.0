From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH] libfc: abort an exchange in case of underrun error
Date: Tue, 17 Mar 2015 17:12:07 -0700
Message-ID: <20150318001207.11827.82460.stgit@lin-nd1-054.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:2322 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbbCRAMI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2015 20:12:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: fcoe-devel@open-fcoe.org

Currently exchange is not aborted in case underrun, so this patch
fixes this by issuing exchange abort along FC_DATA_UNDRUN error since
such error-ed exchange must be aborted first before same can be re-used.

Tested-By: Jack Morgan<jack.morgan@intel.com>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c679594..9ad1248 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -959,8 +959,10 @@ static void fc_fcp_complete_locked(struct fc_fcp_pkt *fsp)
 		if (fsp->cdb_status == SAM_STAT_GOOD &&
 		    fsp->xfer_len < fsp->data_len && !fsp->io_status &&
 		    (!(fsp->scsi_comp_flags & FCP_RESID_UNDER) ||
-		     fsp->xfer_len < fsp->data_len - fsp->scsi_resid))
+		     fsp->xfer_len < fsp->data_len - fsp->scsi_resid)) {
 			fsp->status_code = FC_DATA_UNDRUN;
+			fc_fcp_send_abort(fsp);
+		}
 	}
 
 	seq = fsp->seq_ptr;

