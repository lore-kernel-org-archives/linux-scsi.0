From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 09/35] qla2xxx: ISP27xx fwdump template error print simplification.
Date: Thu, 25 Sep 2014 05:16:40 -0400
Message-ID: <1411636626-7566-10-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:64944 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020AbaIYJvV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:21 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    3 +++
 drivers/scsi/qla2xxx/qla_tmpl.c |   31 ++++---------------------------
 drivers/scsi/qla2xxx/qla_tmpl.h |    2 ++
 3 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index fff8769..d60c1c6 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -65,6 +65,9 @@
  * |                              |                    | 0xb149		|
  * | MultiQ                       |       0xc00c       |		|
  * | Misc                         |       0xd213       | 0xd011-0xd017	|
+ * |                              |                    | 0xd021,0xd024	|
+ * |                              |                    | 0xd025,0xd029	|
+ * |                              |                    | 0xd02a,0xd02e	|
  * |                              |                    | 0xd031-0xd0ff	|
  * |                              |                    | 0xd101-0xd1fe	|
  * |                              |                    | 0xd214-0xd2fe	|
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index d92ee06..a8c0c73 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -355,14 +355,9 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host *vha,
 			ent->t262.start_addr = start;
 			ent->t262.end_addr = end;
 		}
-	} else if (ent->t262.ram_area == T262_RAM_AREA_DDR_RAM) {
-		ql_dbg(ql_dbg_misc, vha, 0xd021,
-		    "%s: unsupported ddr ram\n", __func__);
-		qla27xx_skip_entry(ent, buf);
-		goto done;
 	} else {
 		ql_dbg(ql_dbg_misc, vha, 0xd022,
-		    "%s: unknown area %u\n", __func__, ent->t262.ram_area);
+		    "%s: unknown area %x\n", __func__, ent->t262.ram_area);
 		qla27xx_skip_entry(ent, buf);
 		goto done;
 	}
@@ -377,8 +372,6 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host *vha,
 
 	dwords = end - start + 1;
 	if (buf) {
-		ql_dbg(ql_dbg_misc, vha, 0xd024,
-		    "%s: @%lx -> (%lx dwords)\n", __func__, start, dwords);
 		buf += *len;
 		qla24xx_dump_ram(vha->hw, start, buf, dwords, &buf);
 	}
@@ -423,13 +416,9 @@ qla27xx_fwdt_entry_t263(struct scsi_qla_host *vha,
 				count++;
 			}
 		}
-	} else if (ent->t263.queue_type == T263_QUEUE_TYPE_ATIO) {
-		ql_dbg(ql_dbg_misc, vha, 0xd025,
-		    "%s: unsupported atio queue\n", __func__);
-		qla27xx_skip_entry(ent, buf);
 	} else {
 		ql_dbg(ql_dbg_misc, vha, 0xd026,
-		    "%s: unknown queue %u\n", __func__, ent->t263.queue_type);
+		    "%s: unknown queue %x\n", __func__, ent->t263.queue_type);
 		qla27xx_skip_entry(ent, buf);
 	}
 
@@ -524,17 +513,9 @@ qla27xx_fwdt_entry_t268(struct scsi_qla_host *vha,
 			    "%s: missing eft\n", __func__);
 			qla27xx_skip_entry(ent, buf);
 		}
-	} else if (ent->t268.buf_type == T268_BUF_TYPE_EXCH_BUFOFF) {
-		ql_dbg(ql_dbg_misc, vha, 0xd029,
-		    "%s: unsupported exchange offload buffer\n", __func__);
-		qla27xx_skip_entry(ent, buf);
-	} else if (ent->t268.buf_type == T268_BUF_TYPE_EXTD_LOGIN) {
-		ql_dbg(ql_dbg_misc, vha, 0xd02a,
-		    "%s: unsupported extended login buffer\n", __func__);
-		qla27xx_skip_entry(ent, buf);
 	} else {
 		ql_dbg(ql_dbg_misc, vha, 0xd02b,
-		    "%s: unknown buf %x\n", __func__, ent->t268.buf_type);
+		    "%s: unknown buffer %x\n", __func__, ent->t268.buf_type);
 		qla27xx_skip_entry(ent, buf);
 	}
 
@@ -670,13 +651,9 @@ qla27xx_fwdt_entry_t274(struct scsi_qla_host *vha,
 				count++;
 			}
 		}
-	} else if (ent->t274.queue_type == T274_QUEUE_TYPE_ATIO_SHAD) {
-		ql_dbg(ql_dbg_misc, vha, 0xd02e,
-		    "%s: unsupported atio queue\n", __func__);
-		qla27xx_skip_entry(ent, buf);
 	} else {
 		ql_dbg(ql_dbg_misc, vha, 0xd02f,
-		    "%s: unknown queue %u\n", __func__, ent->t274.queue_type);
+		    "%s: unknown queue %x\n", __func__, ent->t274.queue_type);
 		qla27xx_skip_entry(ent, buf);
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.h b/drivers/scsi/qla2xxx/qla_tmpl.h
index f19856b..141c1c5 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.h
+++ b/drivers/scsi/qla2xxx/qla_tmpl.h
@@ -214,6 +214,8 @@ struct __packed qla27xx_fwdt_entry {
 #define T268_BUF_TYPE_EXTD_TRACE	1
 #define T268_BUF_TYPE_EXCH_BUFOFF	2
 #define T268_BUF_TYPE_EXTD_LOGIN	3
+#define T268_BUF_TYPE_REQ_MIRROR	4
+#define T268_BUF_TYPE_RSP_MIRROR	5
 
 #define T274_QUEUE_TYPE_REQ_SHAD	1
 #define T274_QUEUE_TYPE_RSP_SHAD	2
-- 
1.7.7

