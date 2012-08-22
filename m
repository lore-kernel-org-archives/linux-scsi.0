From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 21/42] qla2xxx: Dont call nic restart firmware if it is already active and running.
Date: Wed, 22 Aug 2012 14:21:15 -0400
Message-ID: <1345659696-3670-22-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:23871 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964991Ab2HVSiX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:23 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index cf8944f..6af7a25 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -435,6 +435,7 @@ qla83xx_nic_core_fw_load(scsi_qla_host_t *vha)
 	int rval = QLA_SUCCESS;
 	struct qla_hw_data *ha = vha->hw;
 	uint32_t idc_major_ver, idc_minor_ver;
+	uint16_t config[4];
 
 	qla83xx_idc_lock(vha, 0);
 
@@ -486,6 +487,13 @@ qla83xx_nic_core_fw_load(scsi_qla_host_t *vha)
 	idc_minor_ver |= (QLA83XX_SUPP_IDC_MINOR_VERSION << (ha->portnum * 2));
 	qla83xx_wr_reg(vha, QLA83XX_IDC_MINOR_VERSION, idc_minor_ver);
 
+	if (ha->flags.nic_core_reset_owner) {
+		memset(config, 0, sizeof(config));
+		if (!qla81xx_get_port_config(vha, config))
+			qla83xx_wr_reg(vha, QLA83XX_IDC_DEV_STATE,
+			    QLA8XXX_DEV_READY);
+	}
+
 	rval = qla83xx_idc_state_handler(vha);
 
 exit:
-- 
1.7.7

