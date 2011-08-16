From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 7/9] qla2xxx: Correct inadvertent loop state transitions during port-update handling.
Date: Tue, 16 Aug 2011 11:29:28 -0700
Message-ID: <1313519370-22963-8-git-send-email-chad.dupuis@qlogic.com>
References: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:6160 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab1HPSmK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2011 14:42:10 -0400
In-Reply-To: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Transitioning to a LOOP_UPDATE loop-state could cause the driver
to miss normal link/target processing.  LOOP_UPDATE is a crufty
artifact leftover from at time the driver performed it's own
internal command-queuing.  Safely remove this state.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    3 ---
 drivers/scsi/qla2xxx/qla_isr.c  |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index def6942..37da04d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3838,15 +3838,12 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 		req = vha->req;
 	rsp = req->rsp;
 
-	atomic_set(&vha->loop_state, LOOP_UPDATE);
 	clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
 	if (vha->flags.online) {
 		if (!(rval = qla2x00_fw_ready(vha))) {
 			/* Wait at most MAX_TARGET RSCNs for a stable link. */
 			wait_time = 256;
 			do {
-				atomic_set(&vha->loop_state, LOOP_UPDATE);
-
 				/* Issue a marker after FW becomes ready. */
 				qla2x00_marker(vha, req, rsp, 0, 0,
 					MK_SYNC_ALL);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 477767f..646fc52 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -719,7 +719,6 @@ skip_rio:
 			vha->flags.rscn_queue_overflow = 1;
 		}
 
-		atomic_set(&vha->loop_state, LOOP_UPDATE);
 		atomic_set(&vha->loop_down_timer, 0);
 		vha->flags.management_server_logged_in = 0;
 
-- 
1.6.0.2


