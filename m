From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/6] qla2xxx: Correct vport delete bug.
Date: Thu,  5 Mar 2009 11:07:02 -0800
Message-ID: <1236280025-89526-4-git-send-email-andrew.vasquez@qlogic.com>
References: <1236280025-89526-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5602 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZCETHL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 14:07:11 -0500
In-Reply-To: <1236280025-89526-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   11 +++++++----
 drivers/scsi/qla2xxx/qla_mbx.c  |    3 ++-
 drivers/scsi/qla2xxx/qla_mid.c  |   10 ++++++----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 14325c0..e54ab2f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2614,6 +2614,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 	port_id_t	wrap, nxt_d_id;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp, *base_vha = pci_get_drvdata(ha->pdev);
+	struct scsi_qla_host *tvp;
 
 	rval = QLA_SUCCESS;
 
@@ -2713,7 +2714,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 		/* Bypass virtual ports of the same host. */
 		found = 0;
 		if (ha->num_vhosts) {
-			list_for_each_entry(vp, &ha->vp_list, list) {
+			list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 				if (new_fcport->d_id.b24 == vp->d_id.b24) {
 					found = 1;
 					break;
@@ -2836,6 +2837,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 	uint16_t first_loop_id;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp;
+	struct scsi_qla_host *tvp;
 
 	rval = QLA_SUCCESS;
 
@@ -2860,7 +2862,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 		/* Check for loop ID being already in use. */
 		found = 0;
 		fcport = NULL;
-		list_for_each_entry(vp, &ha->vp_list, list) {
+		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 			list_for_each_entry(fcport, &vp->vp_fcports, list) {
 				if (fcport->loop_id == dev->loop_id &&
 								fcport != dev) {
@@ -3295,6 +3297,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	uint8_t        status = 0;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp;
+	struct scsi_qla_host *tvp;
 	struct req_que *req = ha->req_q_map[0];
 
 	if (vha->flags.online) {
@@ -3310,7 +3313,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 			atomic_set(&vha->loop_state, LOOP_DOWN);
 			qla2x00_mark_all_devices_lost(vha, 0);
-			list_for_each_entry(vp, &ha->vp_list, list)
+			list_for_each_entry_safe(vp, tvp, &ha->vp_list, list)
 			       qla2x00_mark_all_devices_lost(vp, 0);
 		} else {
 			if (!atomic_read(&vha->loop_down_timer))
@@ -3407,7 +3410,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		DEBUG(printk(KERN_INFO
 				"qla2x00_abort_isp(%ld): succeeded.\n",
 				vha->host_no));
-		list_for_each_entry(vp, &ha->vp_list, list) {
+		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 			if (vp->vp_idx)
 				qla2x00_vp_abort_isp(vp);
 		}
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 4c7504c..4aab7ac 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2685,6 +2685,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	uint16_t stat = le16_to_cpu(rptid_entry->vp_idx);
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *vp;
+	scsi_qla_host_t *tvp;
 
 	if (rptid_entry->entry_status != 0)
 		return;
@@ -2710,7 +2711,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		if (MSB(stat) == 1)
 			return;
 
-		list_for_each_entry(vp, &ha->vp_list, list)
+		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list)
 			if (vp_idx == vp->vp_idx)
 				break;
 		if (!vp)
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 3f23932..785c612 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -69,9 +69,10 @@ static scsi_qla_host_t *
 qla24xx_find_vhost_by_name(struct qla_hw_data *ha, uint8_t *port_name)
 {
 	scsi_qla_host_t *vha;
+	struct scsi_qla_host *tvha;
 
 	/* Locate matching device in database. */
-	list_for_each_entry(vha, &ha->vp_list, list) {
+	list_for_each_entry_safe(vha, tvha, &ha->vp_list, list) {
 		if (!memcmp(port_name, vha->port_name, WWN_SIZE))
 			return vha;
 	}
@@ -194,11 +195,11 @@ qla24xx_configure_vp(scsi_qla_host_t *vha)
 void
 qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 {
-	scsi_qla_host_t *vha;
+	scsi_qla_host_t *vha, *tvha;
 	struct qla_hw_data *ha = rsp->hw;
 	int i = 0;
 
-	list_for_each_entry(vha, &ha->vp_list, list) {
+	list_for_each_entry_safe(vha, tvha, &ha->vp_list, list) {
 		if (vha->vp_idx) {
 			switch (mb[0]) {
 			case MBA_LIP_OCCURRED:
@@ -300,6 +301,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 	int ret;
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *vp;
+	struct scsi_qla_host *tvp;
 
 	if (vha->vp_idx)
 		return;
@@ -308,7 +310,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 
 	clear_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 
-	list_for_each_entry(vp, &ha->vp_list, list) {
+	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 		if (vp->vp_idx)
 			ret = qla2x00_do_dpc_vp(vp);
 	}
-- 
1.6.2.rc0.55.g30aa4f

