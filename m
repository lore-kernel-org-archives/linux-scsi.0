From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/24] libfc: do not overwrite DID_TIME_OUT status
Date: Thu, 13 Oct 2016 15:10:43 +0200
Message-ID: <1476364260-12191-8-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40743 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755519AbcJMNXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:23:46 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When a command is aborted it might already have the DID_TIME_OUT
status set, so we shouldn't be overwriting that.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/libfc/fc_fcp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 10faca2..0e2a201 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2008,9 +2008,15 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		sc_cmd->result = (DID_ERROR << 16) | fsp->cdb_status;
 		break;
 	case FC_CMD_ABORTED:
-		FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
-			  "due to FC_CMD_ABORTED\n");
-		sc_cmd->result = (DID_ERROR << 16) | fsp->io_status;
+		if (host_byte(sc_cmd->result) == DID_TIME_OUT)
+			FC_FCP_DBG(fsp, "Returning DID_TIME_OUT to scsi-ml "
+				   "due to FC_CMD_ABORTED\n");
+		else {
+			FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
+				   "due to FC_CMD_ABORTED\n");
+			set_host_byte(sc_cmd, DID_ERROR);
+		}
+		sc_cmd->result |= fsp->io_status;
 		break;
 	case FC_CMD_RESET:
 		FC_FCP_DBG(fsp, "Returning DID_RESET to scsi-ml "
-- 
1.8.5.6

