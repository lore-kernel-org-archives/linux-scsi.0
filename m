From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 3/5] target: pscsi: Fix sense data handling
Date: Wed, 28 Jun 2017 14:58:58 +0900
Message-ID: <20170628055900.22889-4-damien.lemoal@wdc.com>
References: <20170628055900.22889-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59669 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751579AbdF1F7k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 01:59:40 -0400
In-Reply-To: <20170628055900.22889-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A . Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>

On completion of a request sent to the target backstore device,
pscsi_req_done() calls target_complete_cmd() which in turn will execute
pscsi_transport_complete(). In case of a failed request, this last
function will copy the target request sense data to the initiator side
request sense data. However, in pscsi_req_done(), the sense data is
retreived from the request after calling target_complete_cmd(), which
result in the sense data always conatining zeroes. Simply fix this by
copying the sense data before calling target_complete_cmd().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/target/target_core_pscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 97d0318..959d9f6 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1065,6 +1065,8 @@ static void pscsi_req_done(struct request *req, int uptodate)
 			pt->pscsi_result);
 	}
 
+	memcpy(pt->pscsi_sense, scsi_req(req)->sense, TRANSPORT_SENSE_BUFFER);
+
 	switch (host_byte(pt->pscsi_result)) {
 	case DID_OK:
 		target_complete_cmd(cmd, cmd->scsi_status);
@@ -1077,7 +1079,6 @@ static void pscsi_req_done(struct request *req, int uptodate)
 		break;
 	}
 
-	memcpy(pt->pscsi_sense, scsi_req(req)->sense, TRANSPORT_SENSE_BUFFER);
 	__blk_put_request(req->q, req);
 	kfree(pt);
 }
-- 
2.9.4
