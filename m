From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 11/14] qla2xxx: Prevent multiple firmware dump collection for ISP27XX.
Date: Thu, 9 Apr 2015 15:00:05 -0400
Message-ID: <1428606008-14976-12-git-send-email-himanshu.madhani@qlogic.com>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:3535 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933049AbbDITl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 15:41:58 -0400
In-Reply-To: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

For ISP27XX, driver will capture new firmware dump even if there is
one already collected. Prevent this from happening by checking
fw_dumped flag.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    2 +-
 drivers/scsi/qla2xxx/qla_tmpl.c |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index b06b6b5..0e6ee3c 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -60,7 +60,7 @@
  * |                              |                    | 0xb13c-0xb140  |
  * |                              |                    | 0xb149		|
  * | MultiQ                       |       0xc00c       |		|
- * | Misc                         |       0xd213       | 0xd016-0xd017	|
+ * | Misc                         |       0xd300       | 0xd016-0xd017	|
  * |                              |                    | 0xd021,0xd024	|
  * |                              |                    | 0xd025,0xd029	|
  * |                              |                    | 0xd02a,0xd02e	|
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 7f67fb2..58fc115 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -947,6 +947,10 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 		ql_log(ql_log_warn, vha, 0xd01e, "fwdump buffer missing.\n");
 	else if (!vha->hw->fw_dump_template)
 		ql_log(ql_log_warn, vha, 0xd01f, "fwdump template missing.\n");
+	else if (vha->hw->fw_dumped)
+		ql_log(ql_log_warn, vha, 0xd300,
+		    "Firmware has been previously dumped (%p),"
+		    " -- ignoring request\n", vha->hw->fw_dump);
 	else
 		qla27xx_execute_fwdt_template(vha);
 
-- 
1.7.7

