From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 5/7] bnx2fc: If IO is still in cleanup then do not return to SCSI layer.
Date: Mon, 26 Jun 2017 08:59:36 -0700
Message-ID: <20170626155938.2091-6-chad.dupuis@cavium.com>
References: <20170626155938.2091-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0055.outbound.protection.outlook.com ([104.47.33.55]:28710
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751592AbdFZP7y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jun 2017 11:59:54 -0400
In-Reply-To: <20170626155938.2091-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

In eh_abort, driver is calling scsi->done() for a IO for which cleanup is
pending. As the IO is outstanding with the firmware, it may do DMA
associated with the IO. This may lead to heap corruption.

Do not complete the IO for which cleanup is still pending. Return failure
from eh_abort and let the SCSI-ml retry the IO.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 6e8b9be..5b6153f 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1167,16 +1167,11 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		printk(KERN_ERR PFX "eh_abort: io_req (xid = 0x%x) "
 				"not on active_q\n", io_req->xid);
 		/*
-		 * This condition can happen only due to the FW bug,
-		 * where we do not receive cleanup response from
-		 * the FW. Handle this case gracefully by erroring
-		 * back the IO request to SCSI-ml
+		 * The IO is still with the FW.
+		 * Return failure and let SCSI-ml retry eh_abort.
 		 */
-		bnx2fc_scsi_done(io_req, DID_ABORT);
-
-		kref_put(&io_req->refcount, bnx2fc_cmd_release);
 		spin_unlock_bh(&tgt->tgt_lock);
-		return SUCCESS;
+		return FAILED;
 	}
 
 	/*
-- 
1.8.5.6
