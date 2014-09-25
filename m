From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 01/35] qla2xxx: ISP27xx add tests for incomplete template.
Date: Thu, 25 Sep 2014 05:16:32 -0400
Message-ID: <1411636626-7566-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:50235 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890AbaIYJvT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:19 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    2 +-
 drivers/scsi/qla2xxx/qla_tmpl.c |    9 +++++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 41117b3..55edaa2 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -64,7 +64,7 @@
  * |                              |                    | 0xb13c-0xb140  |
  * |                              |                    | 0xb149		|
  * | MultiQ                       |       0xc00c       |		|
- * | Misc                         |       0xd212       | 0xd017-0xd019	|
+ * | Misc                         |       0xd212       | 0xd017		|
  * |                              |                    | 0xd020		|
  * |                              |                    | 0xd030-0xd0ff	|
  * |                              |                    | 0xd101-0xd1fe	|
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index cb9a0c4..252de5d 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -792,6 +792,15 @@ qla27xx_walk_template(struct scsi_qla_host *vha,
 			break;
 		ent = qla27xx_next_entry(ent);
 	}
+
+	if (count)
+		ql_dbg(ql_dbg_misc, vha, 0xd018,
+		    "%s: residual count (%lx)\n", __func__, count);
+
+	if (ent->hdr.entry_type != ENTRY_TYPE_TMP_END)
+		ql_dbg(ql_dbg_misc, vha, 0xd019,
+		    "%s: missing end (%lx)\n", __func__, count);
+
 	ql_dbg(ql_dbg_misc, vha, 0xd01b,
 	    "%s: len=%lx\n", __func__, *len);
 }
-- 
1.7.7

