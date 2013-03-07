From: vikas.chaudhary@qlogic.com
Subject: [PATCH 3/8] qla4xxx: Set graceful reset bit for ISP83XX
Date: Thu,  7 Mar 2013 05:43:09 -0500
Message-ID: <1362652994-7593-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:27815 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755965Ab3CGLFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 06:05:22 -0500
In-Reply-To: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

For ISP83XX set graceful reset bit in IDC_DRV_CTRL
if reset is issued by application

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 1c387e7..b3ccb1a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6081,6 +6081,7 @@ static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type)
 {
 	struct scsi_qla_host *ha = to_qla_host(shost);
 	int rval = QLA_SUCCESS;
+	uint32_t idc_ctrl;
 
 	if (ql4xdontresethba) {
 		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: Don't Reset HBA\n",
@@ -6111,6 +6112,14 @@ static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type)
 	}
 
 recover_adapter:
+	/* For ISP83XX set graceful reset bit in IDC_DRV_CTRL if
+	 * reset is issued by application */
+	if (is_qla8032(ha) && test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
+		idc_ctrl = qla4_83xx_rd_reg(ha, QLA83XX_IDC_DRV_CTRL);
+		qla4_83xx_wr_reg(ha, QLA83XX_IDC_DRV_CTRL,
+				 (idc_ctrl | GRACEFUL_RESET_BIT1));
+	}
+
 	rval = qla4xxx_recover_adapter(ha);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: recover adapter fail\n",
-- 
1.8.0

