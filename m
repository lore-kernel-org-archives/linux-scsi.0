From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/24] libfc: fixed a read IO data integrity issue when a IO
	data frame lost
Date: Fri, 27 Feb 2009 10:55:07 -0800
Message-ID: <20090227185507.25509.87242.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:35029 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbZB0SzJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:55:09 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

From: Vasu Dev <vasu.dev@intel.com>

The fc_fcp_complete_locked detected data underrun in this case and set
the FC_DATA_UNDRUN but that was ignored by fc_io_compl for all cases
including read underrun.

Added code to not to ignore FC_DATA_UNDRUN for read IO and instead
suggested scsi-ml to retry cmd to  recover from lost data frame.

Not sure if it is okay to ignore FC_DATA_UNDRUN for other case, so let
code as is for other cases but removed or-ing with zero valued fsp->cdb_status
for those cases.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index f440aac..ecc7261 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1810,12 +1810,12 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		sc_cmd->result = DID_ERROR << 16;
 		break;
 	case FC_DATA_UNDRUN:
-		if (fsp->cdb_status == 0) {
+		if ((fsp->cdb_status == 0) && !(fsp->req_flags & FC_SRB_READ)) {
 			/*
 			 * scsi status is good but transport level
-			 * underrun. for read it should be an error??
+			 * underrun.
 			 */
-			sc_cmd->result = (DID_OK << 16) | fsp->cdb_status;
+			sc_cmd->result = DID_OK << 16;
 		} else {
 			/*
 			 * scsi got underrun, this is an error

