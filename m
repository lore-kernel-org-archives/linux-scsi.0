From: vikas.chaudhary@qlogic.com
Subject: [PATCH 09/12] qla4xxx: Added new function qla4_8xxx_get_minidump
Date: Wed, 22 Aug 2012 07:55:07 -0400
Message-ID: <1345636510-23131-10-git-send-email-vikas.chaudhary@qlogic.com>
References: <1345636510-23131-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:63319 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756068Ab2HVML5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 08:11:57 -0400
In-Reply-To: <1345636510-23131-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Move minidump code from qla4_8xxx_device_bootstrap() to
new function qla4_8xxx_get_minidump() to make code more
modular.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 70793bf..6daa25c 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2283,6 +2283,20 @@ static void qla4_8xxx_uevent_emit(struct scsi_qla_host *ha, u32 code)
 	kobject_uevent_env(&(&ha->pdev->dev)->kobj, KOBJ_CHANGE, envp);
 }
 
+static void qla4_8xxx_get_minidump(struct scsi_qla_host *ha)
+{
+	if (ql4xenablemd && test_bit(AF_FW_RECOVERY, &ha->flags) &&
+	    !test_bit(AF_82XX_FW_DUMPED, &ha->flags)) {
+		if (!qla4_8xxx_collect_md_data(ha)) {
+			qla4_8xxx_uevent_emit(ha, QL4_UEVENT_CODE_FW_DUMP);
+			set_bit(AF_82XX_FW_DUMPED, &ha->flags);
+		} else {
+			ql4_printk(KERN_INFO, ha, "%s: Unable to collect minidump\n",
+				   __func__);
+		}
+	}
+}
+
 /**
  * qla4_8xxx_device_bootstrap - Initialize device, set DEV_READY, start fw
  * @ha: pointer to adapter structure
@@ -2338,15 +2352,7 @@ dev_initialize:
 			    QLA8XXX_DEV_INITIALIZING);
 
 	ha->isp_ops->idc_unlock(ha);
-	if (ql4xenablemd && test_bit(AF_FW_RECOVERY, &ha->flags) &&
-	    !test_and_set_bit(AF_82XX_FW_DUMPED, &ha->flags)) {
-		if (!qla4_8xxx_collect_md_data(ha)) {
-			qla4_8xxx_uevent_emit(ha, QL4_UEVENT_CODE_FW_DUMP);
-		} else {
-			ql4_printk(KERN_INFO, ha, "Unable to collect minidump\n");
-			clear_bit(AF_82XX_FW_DUMPED, &ha->flags);
-		}
-	}
+	qla4_8xxx_get_minidump(ha);
 	rval = ha->isp_ops->restart_firmware(ha);
 	ha->isp_ops->idc_lock(ha);
 
-- 
1.7.8.GIT

