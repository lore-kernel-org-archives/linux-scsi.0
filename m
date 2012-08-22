From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 28/42] qla2xxx: set idc version if function is first one to come.
Date: Wed, 22 Aug 2012 14:21:22 -0400
Message-ID: <1345659696-3670-29-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:51518 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964998Ab2HVSi3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:29 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    1 -
 drivers/scsi/qla2xxx/qla_nx.c  |   30 ++++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 6de4d03..279f52c 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -34,7 +34,6 @@
  * | AER/EEH                      |       0x9011       |		|
  * | Virtual Port                 |       0xa007       |		|
  * | ISP82XX Specific             |       0xb084       | 0xb002,0xb024  |
- * |                              |                    | 0xb082,0xb083  |
  * | MultiQ                       |       0xc00c       |		|
  * | Misc                         |       0xd010       |		|
  * | Target Mode		  |	  0xe06f       |		|
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 9fc08b8..3a05444 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2303,6 +2303,29 @@ void qla82xx_init_flags(struct qla_hw_data *ha)
 }
 
 inline void
+qla82xx_set_idc_version(scsi_qla_host_t *vha)
+{
+	int idc_ver;
+	uint32_t drv_active;
+	struct qla_hw_data *ha = vha->hw;
+
+	drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+	if (drv_active == (QLA82XX_DRV_ACTIVE << (ha->portnum * 4))) {
+		qla82xx_wr_32(ha, QLA82XX_CRB_DRV_IDC_VERSION,
+		    QLA82XX_IDC_VERSION);
+		ql_log(ql_log_info, vha, 0xb082,
+		    "IDC version updated to %d\n", QLA82XX_IDC_VERSION);
+	} else {
+		idc_ver = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_IDC_VERSION);
+		if (idc_ver != QLA82XX_IDC_VERSION)
+			ql_log(ql_log_info, vha, 0xb083,
+			    "qla2xxx driver IDC version %d is not compatible "
+			    "with IDC version %d of the other drivers\n",
+			    QLA82XX_IDC_VERSION, idc_ver);
+	}
+}
+
+inline void
 qla82xx_set_drv_active(scsi_qla_host_t *vha)
 {
 	uint32_t drv_active;
@@ -2878,9 +2901,6 @@ dev_initialize:
 	    "HW State: INITIALIZING.\n");
 	qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA8XXX_DEV_INITIALIZING);
 
-	/* Driver that sets device state to initializating sets IDC version */
-	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_IDC_VERSION, QLA82XX_IDC_VERSION);
-
 	qla82xx_idc_unlock(ha);
 	rval = qla82xx_start_firmware(vha);
 	qla82xx_idc_lock(ha);
@@ -3210,8 +3230,10 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 	int loopcount = 0;
 
 	qla82xx_idc_lock(ha);
-	if (!vha->flags.init_done)
+	if (!vha->flags.init_done) {
 		qla82xx_set_drv_active(vha);
+		qla82xx_set_idc_version(vha);
+	}
 
 	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
 	old_dev_state = dev_state;
-- 
1.7.7

