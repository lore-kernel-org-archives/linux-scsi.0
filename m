From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH] qla2xxx: Code changes for vport bus reset
Date: Fri, 14 Nov 2008 13:48:12 -0800 (PST)
Message-ID: <alpine.OSX.1.00.0811141332570.6342@ac-mac.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:52267 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbYKNVsW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2008 16:48:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: linux-driver@qlogic.com

The following patch changes the handling of bus reset when issued from a 
vport. In the bus reset code, an extra check is made to make sure that the lip 
reset is not done before resetting the targets if the bus reset came from a 
vport. The patch is based on scsi-misc-2.6.
Please apply.

Thanks,
Anirban

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 drivers/scsi/qla2xxx/qla_os.c  |   17 ++++++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bc52aa0..bbe7181 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2256,7 +2256,7 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 	scsi_qla_host_t *vha;
 	struct qla_hw_data *ha;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
 
 	vha = fcport->vha;
 	ha = vha->hw;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9830fcb..f636588 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -918,7 +918,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 		return ret;
 
 	qla_printk(KERN_INFO, vha->hw,
-	    "scsi(%ld:%d:%d): LOOP RESET ISSUED.\n", vha->host_no, id, lun);
+	    "scsi(%ld:%d:%d): BUS RESET ISSUED.\n", vha->host_no, id, lun);
 
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 		DEBUG2(printk("%s failed:board disabled\n",__func__));
@@ -1039,20 +1039,23 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	struct fc_port *fcport;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (ha->flags.enable_lip_full_login) {
+	if (ha->flags.enable_lip_full_login && !vha->vp_idx) {
 		ret = qla2x00_full_login_lip(vha);
 		if (ret != QLA_SUCCESS) {
-			DEBUG2_3(printk("%s(%ld): bus_reset failed: "
+			DEBUG2_3(printk("%s(%ld): failed: "
 			    "full_login_lip=%d.\n", __func__, vha->host_no,
 			    ret));
-		} else
-			qla2x00_wait_for_loop_ready(vha);
+		}
+		atomic_set(&vha->loop_state, LOOP_DOWN);
+		atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+		qla2x00_mark_all_devices_lost(vha, 0);
+		qla2x00_wait_for_loop_ready(vha);
 	}
 
-	if (ha->flags.enable_lip_reset) {
+	if (ha->flags.enable_lip_reset && !vha->vp_idx) {
 		ret = qla2x00_lip_reset(vha);
 		if (ret != QLA_SUCCESS) {
-			DEBUG2_3(printk("%s(%ld): bus_reset failed: "
+			DEBUG2_3(printk("%s(%ld): failed: "
 			    "lip_reset=%d.\n", __func__, vha->host_no, ret));
 		} else
 			qla2x00_wait_for_loop_ready(vha);
-- 
1.5.5

