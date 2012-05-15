From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 17/22] qla2xxx: Avoid losing any fc ports when loop id's are exhausted.
Date: Tue, 15 May 2012 14:34:24 -0400
Message-ID: <1337106869-14191-18-git-send-email-chad.dupuis@qlogic.com>
References: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:43280 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S966440Ab2EOS5r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 14:57:47 -0400
In-Reply-To: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   83 +++++++++-----------------------------
 1 files changed, 20 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 34fca3e..886b2b6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2910,7 +2910,7 @@ static int
 qla2x00_configure_fabric(scsi_qla_host_t *vha)
 {
 	int	rval;
-	fc_port_t	*fcport, *fcptemp;
+	fc_port_t	*fcport;
 	uint16_t	next_loopid;
 	uint16_t	mb[MAILBOX_REGISTER_COUNT];
 	uint16_t	loop_id;
@@ -2948,7 +2948,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 		    0xfc, mb, BIT_1|BIT_0);
 		if (rval != QLA_SUCCESS) {
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
-			return rval;
+			break;
 		}
 		if (mb[0] != MBS_COMMAND_COMPLETE) {
 			ql_dbg(ql_dbg_disc, vha, 0x2042,
@@ -2984,10 +2984,12 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 		if (rval != QLA_SUCCESS)
 			break;
 
-		/*
-		 * Logout all previous fabric devices marked lost, except
-		 * FCP2 devices.
-		 */
+		/* Add new ports to existing port list */
+		list_splice_tail_init(&new_fcports, &vha->vp_fcports);
+
+		/* Starting free loop ID. */
+		next_loopid = ha->min_external_loopid;
+
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
 				break;
@@ -2995,6 +2997,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0)
 				continue;
 
+			/* Logout lost/gone fabric devices (non-FCP2) */
 			if (fcport->scan_state != QLA_FCPORT_SCAN_FOUND &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				qla2x00_mark_device_lost(vha, fcport,
@@ -3008,76 +3011,30 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 					    fcport->d_id.b.domain,
 					    fcport->d_id.b.area,
 					    fcport->d_id.b.al_pa);
-					fcport->loop_id = FC_NO_LOOP_ID;
 				}
 				continue;
 			}
 			fcport->scan_state = QLA_FCPORT_SCAN_NONE;
-		}
-
-		/* Starting free loop ID. */
-		next_loopid = ha->min_external_loopid;
-
-		/*
-		 * Scan through our port list and login entries that need to be
-		 * logged in.
-		 */
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (atomic_read(&vha->loop_down_timer) ||
-			    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
-				break;
 
-			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0 ||
-			    (fcport->flags & FCF_LOGIN_NEEDED) == 0)
-				continue;
-
-			if (fcport->loop_id == FC_NO_LOOP_ID) {
-				fcport->loop_id = next_loopid;
-				rval = qla2x00_find_new_loop_id(
-				    base_vha, fcport);
-				if (rval != QLA_SUCCESS) {
-					/* Ran out of IDs to use */
-					break;
+			/* Login fabric devices that need a login */
+			if ((fcport->flags & FCF_LOGIN_NEEDED) != 0 &&
+			    atomic_read(&vha->loop_down_timer) == 0) {
+				if (fcport->loop_id == FC_NO_LOOP_ID) {
+					fcport->loop_id = next_loopid;
+					rval = qla2x00_find_new_loop_id(
+					    base_vha, fcport);
+					if (rval != QLA_SUCCESS) {
+						/* Ran out of IDs to use */
+						continue;
+					}
 				}
 			}
-			/* Login and update database */
-			qla2x00_fabric_dev_login(vha, fcport, &next_loopid);
-		}
-
-		/* Exit if out of loop IDs. */
-		if (rval != QLA_SUCCESS) {
-			break;
-		}
-
-		/*
-		 * Login and add the new devices to our port list.
-		 */
-		list_for_each_entry_safe(fcport, fcptemp, &new_fcports, list) {
-			if (atomic_read(&vha->loop_down_timer) ||
-			    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
-				break;
-
-			/* Find a new loop ID to use. */
-			fcport->loop_id = next_loopid;
-			rval = qla2x00_find_new_loop_id(base_vha, fcport);
-			if (rval != QLA_SUCCESS) {
-				/* Ran out of IDs to use */
-				break;
-			}
 
 			/* Login and update database */
 			qla2x00_fabric_dev_login(vha, fcport, &next_loopid);
-
-			list_move_tail(&fcport->list, &vha->vp_fcports);
 		}
 	} while (0);
 
-	/* Free all new device structures not processed. */
-	list_for_each_entry_safe(fcport, fcptemp, &new_fcports, list) {
-		list_del(&fcport->list);
-		kfree(fcport);
-	}
-
 	if (rval) {
 		ql_dbg(ql_dbg_disc, vha, 0x2068,
 		    "Configure fabric error exit rval=%d.\n", rval);
-- 
1.7.7

