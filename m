From: madhu.iyengar@qlogic.com
Subject: [PATCH 16/18] qla2xxx: Verify login-state has transitioned to PRLI-completed.
Date: Wed, 30 Mar 2011 11:46:31 -0700
Message-ID: <1301510793-2492-17-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45793 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756053Ab1C3SvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:18 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Before driver's own internal state is marked as PLOGI/PRLI
complete. This additional check closes a window seen with
dual-personality initiator/target devices where a driver's
PLOGI/PRLI request occurs within the window after the target's
PLOGI request has completed, but prior to the target's PRLI
arriving and processed by the firmware. Without this additional
check, the firmware will return port-information stating that the
port neither supports target nor initiator functions, causing the
driver to register the rport prematurely to the FC-transport
without the proper 'roles' being set.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   11 +++++++++++
 drivers/scsi/qla2xxx/qla_mbx.c  |   17 ++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 234c1c2..d31ac9b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -383,6 +383,17 @@ qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 
 	switch (data[0]) {
 	case MBS_COMMAND_COMPLETE:
+		/*
+		 * Driver must validate login state - If PRLI not complete,
+		 * force a relogin attempt via implicit LOGO, PLOGI, and PRLI
+		 * requests.
+		 */
+		rval = qla2x00_get_port_database(vha, fcport, 0);
+		if (rval != QLA_SUCCESS) {
+			qla2x00_post_async_logout_work(vha, fcport, NULL);
+			qla2x00_post_async_login_work(vha, fcport, NULL);
+			break;
+		}
 		if (fcport->flags & FCF_FCP2_DEVICE) {
 			qla2x00_post_async_adisc_work(vha, fcport, data);
 			break;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 33502e8..6ce699b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1261,11 +1261,12 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		/* Check for logged in state. */
 		if (pd24->current_login_state != PDS_PRLI_COMPLETE &&
 		    pd24->last_login_state != PDS_PRLI_COMPLETE) {
-			DEBUG2(printk("%s(%ld): Unable to verify "
-			    "login-state (%x/%x) for loop_id %x\n",
-			    __func__, vha->host_no,
-			    pd24->current_login_state,
-			    pd24->last_login_state, fcport->loop_id));
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+			   "scsi(%ld): Unable to verify login-state (%x/%x) "
+			   " - portid=%02x%02x%02x.\n", vha->host_no,
+			   pd24->current_login_state, pd24->last_login_state,
+			   fcport->d_id.b.domain, fcport->d_id.b.area,
+			   fcport->d_id.b.al_pa));
 			rval = QLA_FUNCTION_FAILED;
 			goto gpd_error_out;
 		}
@@ -1289,6 +1290,12 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		/* Check for logged in state. */
 		if (pd->master_state != PD_STATE_PORT_LOGGED_IN &&
 		    pd->slave_state != PD_STATE_PORT_LOGGED_IN) {
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+			   "scsi(%ld): Unable to verify login-state (%x/%x) "
+			   " - portid=%02x%02x%02x.\n", vha->host_no,
+			   pd->master_state, pd->slave_state,
+			   fcport->d_id.b.domain, fcport->d_id.b.area,
+			   fcport->d_id.b.al_pa));
 			rval = QLA_FUNCTION_FAILED;
 			goto gpd_error_out;
 		}
-- 
1.6.0.2

