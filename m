From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 07/14] qla2xxx: Add udev notification to save fw dump for ISP27XX
Date: Thu, 9 Apr 2015 15:00:01 -0400
Message-ID: <1428606008-14976-8-git-send-email-himanshu.madhani@qlogic.com>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:25846 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933029AbbDITl3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 15:41:29 -0400
In-Reply-To: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 1437fce..7f67fb2 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -787,11 +787,12 @@ qla27xx_walk_template(struct scsi_qla_host *vha,
 	ql_dbg(ql_dbg_misc, vha, 0xd01b,
 	    "%s: len=%lx\n", __func__, *len);
 
-	if (buf)
+	if (buf) {
 		ql_log(ql_log_warn, vha, 0xd015,
 		    "Firmware dump saved to temp buffer (%ld/%p)\n",
 		    vha->host_no, vha->hw->fw_dump);
-
+		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
+	}
 }
 
 static void
-- 
1.7.7

