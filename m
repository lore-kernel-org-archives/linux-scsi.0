From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/1] fnic:changing queue command to return result DID_IMM_RETRY when rport is init
Date: Mon, 26 Jun 2017 17:49:06 -0700
Message-ID: <1498524546-32545-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-4.cisco.com ([173.37.142.91]:6825 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751445AbdF0AwT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 20:52:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: satishkh@cisco.com, Sesidhar Baddela <sebaddel@cisco.com>

Currently the queue command returns DID_NO_CONNECT anytime the rport
is not in RPORT_ST_READY state. Changing it to return DID_NO_CONNECT
only when the rport is in RPORT_ST_DELETE state. When the rport is
in one of the init states retruning DID_IMM_RETRY.

Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Satish Kharat <satishkh@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index d048f3b..cc48cb8 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -466,15 +466,27 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	}
 
 	rp = rport->dd_data;
-	if (!rp || rp->rp_state != RPORT_ST_READY) {
+	if (!rp || rp->rp_state == RPORT_ST_DELETE) {
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				"returning DID_NO_CONNECT for IO as rport is removed\n");
+			"rport 0x%x removed, returning DID_NO_CONNECT\n",
+			rport->port_id);
+
 		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
 		sc->result = DID_NO_CONNECT<<16;
 		done(sc);
 		return 0;
 	}
 
+	if (rp->rp_state != RPORT_ST_READY) {
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			"rport 0x%x in state 0x%x, returning DID_IMM_RETRY\n",
+			rport->port_id, rp->rp_state);
+
+		sc->result = DID_IMM_RETRY << 16;
+		done(sc);
+		return 0;
+	}
+
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-- 
2.7.4
