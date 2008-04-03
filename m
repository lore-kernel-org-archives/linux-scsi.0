From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 17/21] qla2xxx: Consistently access the physical HA port.
Date: Thu,  3 Apr 2008 13:13:28 -0700
Message-ID: <1207253612-15538-17-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbYDCUNq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:46 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

There were several places where referencing ha structure of
virtual ports for resources. Among those refereces, certain
fields are get up-to-dated only on ha structure of physical port.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 916462e..01e2608 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2453,7 +2453,8 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 
 			if (fcport->loop_id == FC_NO_LOOP_ID) {
 				fcport->loop_id = next_loopid;
-				rval = qla2x00_find_new_loop_id(ha, fcport);
+				rval = qla2x00_find_new_loop_id(
+				    to_qla_parent(ha), fcport);
 				if (rval != QLA_SUCCESS) {
 					/* Ran out of IDs to use */
 					break;
@@ -2478,7 +2479,8 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 
 			/* Find a new loop ID to use. */
 			fcport->loop_id = next_loopid;
-			rval = qla2x00_find_new_loop_id(ha, fcport);
+			rval = qla2x00_find_new_loop_id(to_qla_parent(ha),
+			    fcport);
 			if (rval != QLA_SUCCESS) {
 				/* Ran out of IDs to use */
 				break;
@@ -4044,16 +4046,16 @@ qla24xx_configure_vhba(scsi_qla_host_t *ha)
 	if (!ha->parent)
 		return -EINVAL;
 
-	rval = qla2x00_fw_ready(ha);
+	rval = qla2x00_fw_ready(ha->parent);
 	if (rval == QLA_SUCCESS) {
 		clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
-		qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
+		qla2x00_marker(ha->parent, 0, 0, MK_SYNC_ALL);
 	}
 
 	ha->flags.management_server_logged_in = 0;
 
 	/* Login to SNS first */
-	qla24xx_login_fabric(ha, NPH_SNS, 0xff, 0xff, 0xfc,
+	qla24xx_login_fabric(ha->parent, NPH_SNS, 0xff, 0xff, 0xfc,
 	    mb, BIT_1);
 	if (mb[0] != MBS_COMMAND_COMPLETE) {
 		DEBUG15(qla_printk(KERN_INFO, ha,
@@ -4067,7 +4069,7 @@ qla24xx_configure_vhba(scsi_qla_host_t *ha)
 	atomic_set(&ha->loop_state, LOOP_UP);
 	set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 	set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
-	rval = qla2x00_loop_resync(ha);
+	rval = qla2x00_loop_resync(ha->parent);
 
 	return rval;
 }
-- 
1.5.5.rc2

