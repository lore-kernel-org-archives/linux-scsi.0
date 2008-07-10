From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/18] qla2xxx: Correct fcport state-management during loss.
Date: Thu, 10 Jul 2008 16:55:56 -0700
Message-ID: <1215734163-40825-11-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670AbYGJX4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:16 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

All fcport->state management should be done within
qla2x00_mark_device_lost(), the assignment of state within
qla2x00_mark_vp_devices_dead() caused associated rports to not be
removed.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |    1 -
 drivers/scsi/qla2xxx/qla_os.c  |   13 +++----------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index fa35339..e756576 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -105,7 +105,6 @@ qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 		    "loop_id=0x%04x :%x\n",
 		    vha->host_no, fcport->loop_id, fcport->vp_idx));
 
-		atomic_set(&fcport->state, FCS_DEVICE_DEAD);
 		qla2x00_mark_device_lost(vha, fcport, 0, 0);
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9c3a57f..3f39169 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1931,7 +1931,7 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
 	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	list_for_each_entry(fcport, &pha->fcports, list) {
-		if (ha->vp_idx != 0 && ha->vp_idx != fcport->vp_idx)
+		if (ha->vp_idx != fcport->vp_idx)
 			continue;
 		/*
 		 * No point in marking the device as lost, if the device is
@@ -1939,17 +1939,10 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
 		 */
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
-		if (atomic_read(&fcport->state) == FCS_ONLINE) {
-			if (defer)
-				qla2x00_schedule_rport_del(ha, fcport, defer);
-			else if (ha->vp_idx == fcport->vp_idx)
-				qla2x00_schedule_rport_del(ha, fcport, defer);
-		}
+		if (atomic_read(&fcport->state) == FCS_ONLINE)
+			qla2x00_schedule_rport_del(ha, fcport, defer);
 		atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
-
-	if (defer)
-		qla2xxx_wake_dpc(ha);
 }
 
 /*
-- 
1.5.6.2.292.ga9a3

