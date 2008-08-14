From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/8] qla2xxx: Correct vport-state management issues during ISP-ABORT.
Date: Wed, 13 Aug 2008 21:36:57 -0700
Message-ID: <1218688622-71361-3-git-send-email-andrew.vasquez@qlogic.com>
References: <20080814043632.GL61889@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:58080 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYHNEhL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 00:37:11 -0400
In-Reply-To: <20080814043632.GL61889@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

* Use correct 'ha' to mark a device lost from ISR.
  I/Os will always be returned on the physical-HA.
  qla2x00_mark_device_lost() should be called with the HA bound
  to the fcport.
* Mark *all* devices lost during ISP-ABORT (bighammer).

These fixes correct issues discovered locally where during
link-perturbation and heavy vport-I/O fcport/rport states would
stray and an rport's scsi-target lost (timed-out).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    3 +++
 drivers/scsi/qla2xxx/qla_isr.c  |    7 +++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 601a6b2..e1de7a6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3251,6 +3251,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 {
 	int rval;
 	uint8_t        status = 0;
+	scsi_qla_host_t *vha;
 
 	if (ha->flags.online) {
 		ha->flags.online = 0;
@@ -3265,6 +3266,8 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
 			atomic_set(&ha->loop_state, LOOP_DOWN);
 			qla2x00_mark_all_devices_lost(ha, 0);
+			list_for_each_entry(vha, &ha->vp_list, vp_list)
+			       qla2x00_mark_all_devices_lost(vha, 0);
 		} else {
 			if (!atomic_read(&ha->loop_down_timer))
 				atomic_set(&ha->loop_down_timer,
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 874d802..d6a1a66 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1184,9 +1184,8 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		    atomic_read(&fcport->state)));
 
 		cp->result = DID_BUS_BUSY << 16;
-		if (atomic_read(&fcport->state) == FCS_ONLINE) {
-			qla2x00_mark_device_lost(ha, fcport, 1, 1);
-		}
+		if (atomic_read(&fcport->state) == FCS_ONLINE)
+			qla2x00_mark_device_lost(fcport->ha, fcport, 1, 1);
 		break;
 
 	case CS_RESET:
@@ -1229,7 +1228,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 
 		/* Check to see if logout occurred. */
 		if ((le16_to_cpu(sts->status_flags) & SF_LOGOUT_SENT))
-			qla2x00_mark_device_lost(ha, fcport, 1, 1);
+			qla2x00_mark_device_lost(fcport->ha, fcport, 1, 1);
 		break;
 
 	default:
-- 
1.6.0.rc2.22.g71b9

