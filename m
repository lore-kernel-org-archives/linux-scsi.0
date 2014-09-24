From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 01/35] qla2xxx: ISP27xx add tests for incomplete template.
Date: Wed, 24 Sep 2014 03:08:04 -0400
Message-ID: <1411542518-2477-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51474 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961AbaIXHmo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:42:44 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
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
index c72ee97b..2ac81e0 100644
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

