From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 31/42] qla2xxx: Enclose adapter related calls in adapter check in failed state handler.
Date: Wed, 22 Aug 2012 14:21:25 -0400
Message-ID: <1345659696-3670-32-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:19040 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964975Ab2HVSig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:36 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 3a05444..7807444 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3028,8 +3028,10 @@ qla8xxx_dev_failed_handler(scsi_qla_host_t *vha)
 	ql_log(ql_log_fatal, vha, 0x00b8,
 	    "Disabling the board.\n");
 
-	qla82xx_clear_drv_active(ha);
-	qla82xx_idc_unlock(ha);
+	if (IS_QLA82XX(ha)) {
+		qla82xx_clear_drv_active(ha);
+		qla82xx_idc_unlock(ha);
+	}
 
 	/* Set DEV_FAILED flag to disable timer */
 	vha->device_flags |= DFLG_DEV_FAILED;
-- 
1.7.7

