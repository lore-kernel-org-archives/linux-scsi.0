From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 05/35] qla2xxx: Add ISP27xx fwdump template entry T275 (insert buffer).
Date: Thu, 25 Sep 2014 05:16:36 -0400
Message-ID: <1411636626-7566-6-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:22467 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbaIYJvP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:15 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    7 +++----
 drivers/scsi/qla2xxx/qla_tmpl.c |   27 +++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_tmpl.h |    6 ++++++
 3 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 61bd49f..fff8769 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -64,11 +64,10 @@
  * |                              |                    | 0xb13c-0xb140  |
  * |                              |                    | 0xb149		|
  * | MultiQ                       |       0xc00c       |		|
- * | Misc                         |       0xd212       | 0xd011-0xd017	|
- * |                              |                    | 0xd020		|
- * |                              |                    | 0xd030-0xd0ff	|
+ * | Misc                         |       0xd213       | 0xd011-0xd017	|
+ * |                              |                    | 0xd031-0xd0ff	|
  * |                              |                    | 0xd101-0xd1fe	|
- * |                              |                    | 0xd213-0xd2fe	|
+ * |                              |                    | 0xd214-0xd2fe	|
  * | Target Mode		  |	  0xe078       |		|
  * | Target Mode Management	  |	  0xf072       | 0xf002-0xf003	|
  * |                              |                    | 0xf046-0xf049  |
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 6f2f7b2..d92ee06 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -690,6 +690,32 @@ qla27xx_fwdt_entry_t274(struct scsi_qla_host *vha,
 }
 
 static int
+qla27xx_fwdt_entry_t275(struct scsi_qla_host *vha,
+	struct qla27xx_fwdt_entry *ent, void *buf, ulong *len)
+{
+	ulong offset = offsetof(typeof(*ent), t275.buffer);
+
+	ql_dbg(ql_dbg_misc, vha, 0xd213,
+	    "%s: buffer(%x) [%lx]\n", __func__, ent->t275.length, *len);
+	if (!ent->t275.length) {
+		ql_dbg(ql_dbg_misc, vha, 0xd020,
+		    "%s: buffer zero length\n", __func__);
+		qla27xx_skip_entry(ent, buf);
+		goto done;
+	}
+	if (offset + ent->t275.length > ent->hdr.entry_size) {
+		ql_dbg(ql_dbg_misc, vha, 0xd030,
+		    "%s: buffer overflow\n", __func__);
+		qla27xx_skip_entry(ent, buf);
+		goto done;
+	}
+
+	qla27xx_insertbuf(ent->t275.buffer, ent->t275.length, buf, len);
+done:
+	return false;
+}
+
+static int
 qla27xx_fwdt_entry_other(struct scsi_qla_host *vha,
 	struct qla27xx_fwdt_entry *ent, void *buf, ulong *len)
 {
@@ -731,6 +757,7 @@ static struct qla27xx_fwdt_entry_call ql27xx_fwdt_entry_call_list[] = {
 	{ ENTRY_TYPE_RDREMRAM		, qla27xx_fwdt_entry_t272  } ,
 	{ ENTRY_TYPE_PCICFG		, qla27xx_fwdt_entry_t273  } ,
 	{ ENTRY_TYPE_GET_SHADOW		, qla27xx_fwdt_entry_t274  } ,
+	{ ENTRY_TYPE_WRITE_BUF		, qla27xx_fwdt_entry_t275  } ,
 	{ -1				, qla27xx_fwdt_entry_other }
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.h b/drivers/scsi/qla2xxx/qla_tmpl.h
index 1967424..f19856b 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.h
+++ b/drivers/scsi/qla2xxx/qla_tmpl.h
@@ -53,6 +53,7 @@ struct __packed qla27xx_fwdt_template {
 #define ENTRY_TYPE_RDREMRAM		272
 #define ENTRY_TYPE_PCICFG		273
 #define ENTRY_TYPE_GET_SHADOW		274
+#define ENTRY_TYPE_WRITE_BUF		275
 
 #define CAPTURE_FLAG_PHYS_ONLY		BIT_0
 #define CAPTURE_FLAG_PHYS_VIRT		BIT_1
@@ -193,6 +194,11 @@ struct __packed qla27xx_fwdt_entry {
 			uint8_t  queue_type;
 			uint8_t  reserved[3];
 		} t274;
+
+		struct __packed {
+			uint32_t length;
+			uint8_t  buffer[];
+		} t275;
 	};
 };
 
-- 
1.7.7

