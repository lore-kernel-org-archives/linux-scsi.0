From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/8] libfc: use DID_ERROR when we have internall aborted
	command
Date: Wed, 06 May 2009 10:52:23 -0700
Message-ID: <20090506175223.26695.1669.stgit@fritz>
References: <20090506175206.26695.19457.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48604 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbZEFRwX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2009 13:52:23 -0400
In-Reply-To: <20090506175206.26695.19457.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If we aborted a command, because it timed out we should not use
DID_ABORT. It will fail the command right away back to the upper
layer. We want to use something that indicated that the problem
did not complete normally, but it was not a fatal problem.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---

 drivers/scsi/libfc/fc_fcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 521f996..ad8b747 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1896,7 +1896,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		sc_cmd->result = (DID_ERROR << 16) | fsp->cdb_status;
 		break;
 	case FC_CMD_ABORTED:
-		sc_cmd->result = (DID_ABORT << 16) | fsp->io_status;
+		sc_cmd->result = (DID_ERROR << 16) | fsp->io_status;
 		break;
 	case FC_CMD_TIME_OUT:
 		sc_cmd->result = (DID_BUS_BUSY << 16) | fsp->io_status;

