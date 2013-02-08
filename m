From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 15/23] Revert "[SCSI] qla2xxx: Avoid losing any fc ports when loop id's are exhausted."
Date: Fri,  8 Feb 2013 01:57:56 -0500
Message-ID: <1360306684-8286-16-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:38904 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759996Ab3BHHTL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:11 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

This reverts commit 4dc77c36f86c2dc4e3f483146d33b64d12c0da3f.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   83 +++++++++++++++++++++++++++++---------
 1 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8888d9b..51f007f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3159,7 +3159,7 @@ static int
 qla2x00_configure_fabric(scsi_qla_host_t *vha)
 {
 	int	rval;
-	fc_port_t	*fcport;
+	fc_port_t	*fcport, *fcptemp;
 	uint16_t	next_loopid;
 	uint16_t	mb[MAILBOX_REGISTER_COUNT];
 	uint16_t	loop_id;
@@ -3197,7 +3197,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 		    0xfc, mb, BIT_1|BIT_0);
 		if (rval != QLA_SUCCESS) {
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
-			break;
+			return rval;
 		}
 		if (mb[0] != MBS_COMMAND_COMPLETE) {
 			ql_dbg(ql_dbg_disc, vha, 0x2042,
@@ -3233,12 +3233,10 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 		if (rval != QLA_SUCCESS)
 			break;
 
-		/* Add new ports to existing port list */
-		list_splice_tail_init(&new_fcports, &vha->vp_fcports);
-
-		/* Starting free loop ID. */
-		next_loopid = ha->min_external_loopid;
-
+		/*
+		 * Logout all previous fabric devices marked lost, except
+		 * FCP2 devices.
+		 */
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
 				break;
@@ -3246,7 +3244,6 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0)
 				continue;
 
-			/* Logout lost/gone fabric devices (non-FCP2) */
 			if (fcport->scan_state != QLA_FCPORT_SCAN_FOUND &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				qla2x00_mark_device_lost(vha, fcport,
@@ -3260,30 +3257,76 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 					    fcport->d_id.b.domain,
 					    fcport->d_id.b.area,
 					    fcport->d_id.b.al_pa);
+					fcport->loop_id = FC_NO_LOOP_ID;
 				}
 				continue;
 			}
 			fcport->scan_state = QLA_FCPORT_SCAN_NONE;
+		}
 
-			/* Login fabric devices that need a login */
-			if ((fcport->flags & FCF_LOGIN_NEEDED) != 0 &&
-			    atomic_read(&vha->loop_down_timer) == 0) {
-				if (fcport->loop_id == FC_NO_LOOP_ID) {
-					fcport->loop_id = next_loopid;
-					rval = qla2x00_find_new_loop_id(
-					    base_vha, fcport);
-					if (rval != QLA_SUCCESS) {
-						/* Ran out of IDs to use */
-						continue;
-					}
+		/* Starting free loop ID. */
+		next_loopid = ha->min_external_loopid;
+
+		/*
+		 * Scan through our port list and login entries that need to be
+		 * logged in.
+		 */
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (atomic_read(&vha->loop_down_timer) ||
+			    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
+				break;
+
+			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0 ||
+			    (fcport->flags & FCF_LOGIN_NEEDED) == 0)
+				continue;
+
+			if (fcport->loop_id == FC_NO_LOOP_ID) {
+				fcport->loop_id = next_loopid;
+				rval = qla2x00_find_new_loop_id(
+				    base_vha, fcport);
+				if (rval != QLA_SUCCESS) {
+					/* Ran out of IDs to use */
+					break;
 				}
 			}
+			/* Login and update database */
+			qla2x00_fabric_dev_login(vha, fcport, &next_loopid);
+		}
+
+		/* Exit if out of loop IDs. */
+		if (rval != QLA_SUCCESS) {
+			break;
+		}
+
+		/*
+		 * Login and add the new devices to our port list.
+		 */
+		list_for_each_entry_safe(fcport, fcptemp, &new_fcports, list) {
+			if (atomic_read(&vha->loop_down_timer) ||
+			    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
+				break;
+
+			/* Find a new loop ID to use. */
+			fcport->loop_id = next_loopid;
+			rval = qla2x00_find_new_loop_id(base_vha, fcport);
+			if (rval != QLA_SUCCESS) {
+				/* Ran out of IDs to use */
+				break;
+			}
 
 			/* Login and update database */
 			qla2x00_fabric_dev_login(vha, fcport, &next_loopid);
+
+			list_move_tail(&fcport->list, &vha->vp_fcports);
 		}
 	} while (0);
 
+	/* Free all new device structures not processed. */
+	list_for_each_entry_safe(fcport, fcptemp, &new_fcports, list) {
+		list_del(&fcport->list);
+		kfree(fcport);
+	}
+
 	if (rval) {
 		ql_dbg(ql_dbg_disc, vha, 0x2068,
 		    "Configure fabric error exit rval=%d.\n", rval);
-- 
1.7.7

