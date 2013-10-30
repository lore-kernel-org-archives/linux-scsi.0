From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 01/22] qla2xxx: Print proper QLAFX00 product name at probe.
Date: Wed, 30 Oct 2013 03:38:08 -0400
Message-ID: <1383118709-5569-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.148.157] ([67.231.148.157]:45341 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752693Ab3J3ILs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:48 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_os.c  |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index ee5c183..acc1ea4 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -11,7 +11,7 @@
  * ----------------------------------------------------------------------
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
- * | Module Init and Probe        |       0x0159       | 0x4b,0xba,0xfa |
+ * | Module Init and Probe        |       0x015a       | 0x4b,0xba,0xfa |
  * | Mailbox commands             |       0x1181       | 0x111a-0x111b  |
  * |                              |                    | 0x1155-0x1158  |
  * |                              |                    | 0x1018-0x1019  |
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9f01bbb..7d4f10d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2914,8 +2914,12 @@ skip_dpc:
 
 	qla2x00_dfs_setup(base_vha);
 
-	ql_log(ql_log_info, base_vha, 0x00fb,
-	    "QLogic %s - %s.\n", ha->model_number, ha->model_desc);
+	if (IS_QLAFX00(ha))
+		ql_log(ql_log_info, base_vha, 0x015a,
+		    "QLogic %s.\n", ha->mr.product_name);
+	else
+		ql_log(ql_log_info, base_vha, 0x00fb,
+		    "QLogic %s - %s.\n", ha->model_number, ha->model_desc);
 	ql_log(ql_log_info, base_vha, 0x00fc,
 	    "ISP%04X: %s @ %s hdma%c host#=%ld fw=%s.\n",
 	    pdev->device, ha->isp_ops->pci_info_str(base_vha, pci_info),
-- 
1.7.7

