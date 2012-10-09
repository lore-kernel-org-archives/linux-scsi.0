From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] qla2xxx: Add missing ->vport_slock while calling qlt_update_vp_map
Date: Tue,  9 Oct 2012 19:12:11 +0000
Message-ID: <1349809931-9079-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jiri Kosina <jkosina@suse.cz>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

All other callers of qlt_update_vp_map() already hold ->vport_slock
while updating the vp target map, so go ahead and add the missing
->vport_slock within qla24xx_disable_vp() code.

Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_mid.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 3e8b324..c7eb3bb 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -149,6 +149,7 @@ qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 int
 qla24xx_disable_vp(scsi_qla_host_t *vha)
 {
+	unsigned long flags;
 	int ret;
 
 	ret = qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
@@ -156,7 +157,9 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 
 	/* Remove port id from vp target map */
+	spin_lock_irqsave(&vha->hw->vport_slock, flags);
 	qlt_update_vp_map(vha, RESET_AL_PA);
+	spin_unlock_irqrestore(&vha->hw->vport_slock, flags);
 
 	qla2x00_mark_vp_devices_dead(vha);
 	atomic_set(&vha->vp_state, VP_FAILED);
-- 
1.7.2.5
