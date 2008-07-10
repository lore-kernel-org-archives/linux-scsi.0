From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 13/18] qla2xxx: Correct rport/fcport visibility-state handling during loop-resync.
Date: Thu, 10 Jul 2008 16:55:58 -0700
Message-ID: <1215734163-40825-13-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715AbYGJX4R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:17 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

There were several issues here, one, during RSCN handling if a
follow-on RSCN occurred (within interrupt context) the DPC thread
could inadvertantly leave the fcport in a stale lost state.
Secondly, scheduled rport removal is handled exclusively by the
'parent' DPC thread, so wake up the proper thread.  Finally,
process vport loop-resync's only when the vport has in an
"active" state (ID acquired).

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    4 +++-
 drivers/scsi/qla2xxx/qla_mid.c  |    3 ++-
 drivers/scsi/qla2xxx/qla_os.c   |    5 +++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4c83ff8..f8cfeb0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2012,8 +2012,10 @@ qla2x00_configure_loop(scsi_qla_host_t *ha)
 	if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
 		if (test_bit(LOCAL_LOOP_UPDATE, &save_flags))
 			set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
-		if (test_bit(RSCN_UPDATE, &save_flags))
+		if (test_bit(RSCN_UPDATE, &save_flags)) {
+			ha->flags.rscn_queue_overflow = 1;
 			set_bit(RSCN_UPDATE, &ha->dpc_flags);
+		}
 	}
 
 	return (rval);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index e756576..9a850a2 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -277,7 +277,8 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 		clear_bit(RESET_ACTIVE, &vha->dpc_flags);
 	}
 
-	if (test_and_clear_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)) {
+	if (atomic_read(&vha->vp_state) == VP_ACTIVE &&
+	    test_and_clear_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)) {
 		if (!(test_and_set_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags))) {
 			qla2x00_loop_resync(vha);
 			clear_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3f39169..0f44914 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1849,6 +1849,7 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *ha, fc_port_t *fcport,
     int defer)
 {
 	struct fc_rport *rport;
+	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	if (!fcport->rport)
 		return;
@@ -1858,8 +1859,8 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *ha, fc_port_t *fcport,
 		spin_lock_irq(ha->host->host_lock);
 		fcport->drport = rport;
 		spin_unlock_irq(ha->host->host_lock);
-		set_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags);
-		qla2xxx_wake_dpc(ha);
+		set_bit(FCPORT_UPDATE_NEEDED, &pha->dpc_flags);
+		qla2xxx_wake_dpc(pha);
 	} else
 		fc_remote_port_delete(rport);
 }
-- 
1.5.6.2.292.ga9a3

