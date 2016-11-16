From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH] fnic: Correcting rport check location in fnic_queuecommand_lck
Date: Wed, 16 Nov 2016 00:54:01 -0800
Message-ID: <1479286441-8243-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-4.cisco.com ([173.37.142.91]:4252 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752352AbcKPJDv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 04:03:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: satishkh@cisco.com, linux-scsi@vger.kernel.org, thenzl@redhat.com
Cc: Sesidhar Baddela <sebaddel@cisco.com>

Signed-off-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index bfaba06..2544a37 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -441,30 +441,38 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	unsigned long ptr;
 	spinlock_t *io_lock = NULL;
 	int io_lock_acquired = 0;
+	struct fc_rport_libfc_priv *rp;
 
 	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKED)))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
 	rport = starget_to_rport(scsi_target(sc->device));
+	if (!rport) {
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+				"returning DID_NO_CONNECT for IO as rport is NULL\n");
+		sc->result = DID_NO_CONNECT << 16;
+		done(sc);
+		return 0;
+	}
+
 	ret = fc_remote_port_chkready(rport);
 	if (ret) {
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+				"rport is not ready\n");
 		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
 		sc->result = ret;
 		done(sc);
 		return 0;
 	}
 
-	if (rport) {
-		struct fc_rport_libfc_priv *rp = rport->dd_data;
-
-		if (!rp || rp->rp_state != RPORT_ST_READY) {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+	rp = rport->dd_data;
+	if (!rp || rp->rp_state != RPORT_ST_READY) {
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 				"returning DID_NO_CONNECT for IO as rport is removed\n");
-			atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
-			sc->result = DID_NO_CONNECT<<16;
-			done(sc);
-			return 0;
-		}
+		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
+		sc->result = DID_NO_CONNECT<<16;
+		done(sc);
+		return 0;
 	}
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
-- 
2.5.5

