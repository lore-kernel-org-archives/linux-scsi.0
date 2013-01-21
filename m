From: vikas.chaudhary@qlogic.com
Subject: [PATCH 04/10] qla4xxx: Remove unnecessary code from qla4xxx_init_local_data
Date: Sun, 20 Jan 2013 23:50:59 -0500
Message-ID: <1358743865-435-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:15145 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750803Ab3AUFLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jan 2013 00:11:39 -0500
In-Reply-To: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Karen Higgins <karen.higgins@qlogic.com>

From: Karen Higgins <karen.higgins@qlogic.com>

Removed unnecessary calls to qla4xxx_get_firmware_status from
function qla4xxx_init_local_data

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 2045fd79..8fc8548 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -195,12 +195,10 @@ exit_get_sys_info_no_free:
  * @ha: pointer to host adapter structure.
  *
  **/
-static int qla4xxx_init_local_data(struct scsi_qla_host *ha)
+static void qla4xxx_init_local_data(struct scsi_qla_host *ha)
 {
 	/* Initialize aen queue */
 	ha->aen_q_count = MAX_AEN_ENTRIES;
-
-	return qla4xxx_get_firmware_status(ha);
 }
 
 static uint8_t
@@ -951,8 +949,7 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha, int is_reset)
 	if (ha->isp_ops->get_sys_info(ha) == QLA_ERROR)
 		goto exit_init_hba;
 
-	if (qla4xxx_init_local_data(ha) == QLA_ERROR)
-		goto exit_init_hba;
+	qla4xxx_init_local_data(ha);
 
 	status = qla4xxx_init_firmware(ha);
 	if (status == QLA_ERROR)
-- 
1.7.8.GIT

