From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 07/29] qla2xxx: Add ISPFX00 specific bus reset routine.
Date: Tue, 27 Aug 2013 01:37:33 -0400
Message-ID: <1377581875-8574-8-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51756 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720Ab3H0GGh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:37 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R64Ohx012247
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:36 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa9-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:36 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h |    1 +
 drivers/scsi/qla2xxx/qla_mr.c  |   23 +++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c  |    8 +++++---
 4 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index aa10109..9d289a4 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -38,7 +38,7 @@
  * |                              |                    | 0x70ad-0x70ae, |
  * |                              |                    | 0x70d1-0x70da, |
  * |                              |                    | 0x7047,0x703b	|
- * | Task Management              |       0x803c       | 0x8025-0x8026  |
+ * | Task Management              |       0x803d       | 0x8025-0x8026  |
  * |                              |                    | 0x800b,0x8039  |
  * | AER/EEH                      |       0x9011       |		|
  * | Virtual Port                 |       0xa007       |		|
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 152e5dd..9ce9131 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -605,6 +605,7 @@ extern void qlafx00_abort_iocb(srb_t *, struct abort_iocb_entry_fx00 *);
 extern void qlafx00_fxdisc_iocb(srb_t *, struct fxdisc_entry_fx00 *);
 extern void qlafx00_timer_routine(scsi_qla_host_t *);
 extern int qlafx00_rescan_isp(scsi_qla_host_t *);
+extern int qlafx00_loop_reset(scsi_qla_host_t *vha);
 
 /* qla82xx related functions */
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 1aeb9e1..be60a77 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -776,6 +776,29 @@ qlafx00_lun_reset(fc_port_t *fcport, unsigned int l, int tag)
 }
 
 int
+qlafx00_loop_reset(scsi_qla_host_t *vha)
+{
+	int ret;
+	struct fc_port *fcport;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (ql2xtargetreset) {
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (fcport->port_type != FCT_TARGET)
+				continue;
+
+			ret = ha->isp_ops->target_reset(fcport, 0, 0);
+			if (ret != QLA_SUCCESS) {
+				ql_dbg(ql_dbg_taskm, vha, 0x803d,
+				    "Bus Reset failed: Reset=%d "
+				    "d_id=%x.\n", ret, fcport->d_id.b24);
+			}
+		}
+	}
+	return QLA_SUCCESS;
+}
+
+int
 qlafx00_iospace_config(struct qla_hw_data *ha)
 {
 	if (pci_request_selected_regions(ha->pdev, ha->bars,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f92b22b..3f53151 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1303,6 +1303,10 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	struct fc_port *fcport;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (IS_QLAFX00(ha)) {
+		return qlafx00_loop_reset(vha);
+	}
+
 	if (ql2xtargetreset == 1 && ha->flags.enable_target_reset) {
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (fcport->port_type != FCT_TARGET)
@@ -1311,14 +1315,12 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 			ret = ha->isp_ops->target_reset(fcport, 0, 0);
 			if (ret != QLA_SUCCESS) {
 				ql_dbg(ql_dbg_taskm, vha, 0x802c,
-				    "Bus Reset failed: Target Reset=%d "
+				    "Bus Reset failed: Reset=%d "
 				    "d_id=%x.\n", ret, fcport->d_id.b24);
 			}
 		}
 	}
 
-	if (IS_QLAFX00(ha))
-		return QLA_SUCCESS;
 
 	if (ha->flags.enable_lip_full_login && !IS_CNA_CAPABLE(ha)) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
-- 
1.7.7

