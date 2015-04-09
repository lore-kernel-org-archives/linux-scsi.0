From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 06/14] qla2xxx: Add message for sucessful FW dump collected for ISP27XX.
Date: Thu, 9 Apr 2015 15:00:00 -0400
Message-ID: <1428606008-14976-7-git-send-email-himanshu.madhani@qlogic.com>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:29067 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933300AbbDITmA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 15:42:00 -0400
In-Reply-To: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

o Added message indicating firmware dump was sucessfully collected
  for ISP27XX.
o Improve logging to help debug firmware dump process for ISP27XX.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    2 +-
 drivers/scsi/qla2xxx/qla_tmpl.c |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index d77fe43..5774c53 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -60,7 +60,7 @@
  * |                              |                    | 0xb13c-0xb140  |
  * |                              |                    | 0xb149		|
  * | MultiQ                       |       0xc00c       |		|
- * | Misc                         |       0xd213       | 0xd011-0xd017	|
+ * | Misc                         |       0xd213       | 0xd016-0xd017	|
  * |                              |                    | 0xd021,0xd024	|
  * |                              |                    | 0xd025,0xd029	|
  * |                              |                    | 0xd02a,0xd02e	|
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 7a92f60..1437fce 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -219,6 +219,8 @@ qla27xx_skip_entry(struct qla27xx_fwdt_entry *ent, void *buf)
 {
 	if (buf)
 		ent->hdr.driver_flags |= DRIVER_FLAG_SKIP_ENTRY;
+	ql_dbg(ql_dbg_misc + ql_dbg_verbose, NULL, 0xd011,
+	    "Skipping entry %d\n", ent->hdr.entry_type);
 }
 
 static int
@@ -784,6 +786,12 @@ qla27xx_walk_template(struct scsi_qla_host *vha,
 
 	ql_dbg(ql_dbg_misc, vha, 0xd01b,
 	    "%s: len=%lx\n", __func__, *len);
+
+	if (buf)
+		ql_log(ql_log_warn, vha, 0xd015,
+		    "Firmware dump saved to temp buffer (%ld/%p)\n",
+		    vha->host_no, vha->hw->fw_dump);
+
 }
 
 static void
-- 
1.7.7

