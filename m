From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] fnic: remove a pointless test
Date: Tue,  1 Nov 2016 17:40:21 +0100
Message-ID: <1478018421-22820-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46238 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbcKAQkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Nov 2016 12:40:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sramars@cisco.com, hiralpat@cisco.com, buchino@cisco.com

rport can't be null here, it would have failed already in
fc_remote_port_chkready

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index d9fd2f8415..1d3ecaee56 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -441,6 +441,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	unsigned long ptr;
 	spinlock_t *io_lock = NULL;
 	int io_lock_acquired = 0;
+	struct fc_rport_libfc_priv *rp;
 
 	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKED)))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -454,17 +455,14 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 		return 0;
 	}
 
-	if (rport) {
-		struct fc_rport_libfc_priv *rp = rport->dd_data;
-
-		if (!rp || rp->rp_state != RPORT_ST_READY) {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				"returning DID_NO_CONNECT for IO as rport is removed\n");
-			atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
-			sc->result = DID_NO_CONNECT<<16;
-			done(sc);
-			return 0;
-		}
+	rp = rport->dd_data;
+	if (!rp || rp->rp_state != RPORT_ST_READY) {
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			"returning DID_NO_CONNECT for IO as rport is removed\n");
+		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
+		sc->result = DID_NO_CONNECT<<16;
+		done(sc);
+		return 0;
 	}
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
-- 
2.7.4

