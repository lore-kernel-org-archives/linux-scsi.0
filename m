From: Joe Perches <joe@perches.com>
Subject: [PATCH] scsi: qedf: Fix defective logging format and argument mismatches
Date: Sat,  4 Mar 2017 00:07:04 -0800
Message-ID: <b75448afd5e48f342ad9f1785c6546eee7948af9.1488614805.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add __printf compiler verification of format and arguments.
Fix fallout.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/qedf/qedf_dbg.h | 13 ++++++++-----
 drivers/scsi/qedf/qedf_fip.c |  2 +-
 drivers/scsi/qedf/qedf_io.c  |  4 ++--
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_dbg.h b/drivers/scsi/qedf/qedf_dbg.h
index 23bd70628a2f..7d173f48a81e 100644
--- a/drivers/scsi/qedf/qedf_dbg.h
+++ b/drivers/scsi/qedf/qedf_dbg.h
@@ -81,14 +81,17 @@ struct qedf_dbg_ctx {
 #define QEDF_INFO(pdev, level, fmt, ...)	\
 		qedf_dbg_info(pdev, __func__, __LINE__, level, fmt,	\
 			      ## __VA_ARGS__)
-
-extern void qedf_dbg_err(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
+__printf(4, 5)
+void qedf_dbg_err(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 			  const char *fmt, ...);
-extern void qedf_dbg_warn(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
+__printf(4, 5)
+void qedf_dbg_warn(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 			   const char *, ...);
-extern void qedf_dbg_notice(struct qedf_dbg_ctx *qedf, const char *func,
+__printf(4, 5)
+void qedf_dbg_notice(struct qedf_dbg_ctx *qedf, const char *func,
 			    u32 line, const char *, ...);
-extern void qedf_dbg_info(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
+__printf(5, 6)
+void qedf_dbg_info(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 			  u32 info, const char *fmt, ...);
 
 /* GRC Dump related defines */
diff --git a/drivers/scsi/qedf/qedf_fip.c b/drivers/scsi/qedf/qedf_fip.c
index 868d423380d1..ed58b9104f58 100644
--- a/drivers/scsi/qedf/qedf_fip.c
+++ b/drivers/scsi/qedf/qedf_fip.c
@@ -203,7 +203,7 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 			case FIP_DT_MAC:
 				mp = (struct fip_mac_desc *)desc;
 				QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2,
-				    "fd_mac=%pM.\n", __func__, mp->fd_mac);
+				    "fd_mac=%pM\n", mp->fd_mac);
 				ether_addr_copy(cvl_mac, mp->fd_mac);
 				break;
 			case FIP_DT_NAME:
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index ee0dcf9d3aba..46debe5034af 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1342,7 +1342,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		} else {
 			refcount = kref_read(&io_req->refcount);
 			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO,
-			    "%d:0:%d:%d xid=0x%0x op=0x%02x "
+			    "%d:0:%d:%lld xid=0x%0x op=0x%02x "
 			    "lba=%02x%02x%02x%02x cdb_status=%d "
 			    "fcp_resid=0x%x refcount=%d.\n",
 			    qedf->lport->host->host_no, sc_cmd->device->id,
@@ -1426,7 +1426,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 
 	sc_cmd->result = result << 16;
 	refcount = kref_read(&io_req->refcount);
-	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO, "%d:0:%d:%d: Completing "
+	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO, "%d:0:%d:%lld: Completing "
 	    "sc_cmd=%p result=0x%08x op=0x%02x lba=0x%02x%02x%02x%02x, "
 	    "allowed=%d retries=%d refcount=%d.\n",
 	    qedf->lport->host->host_no, sc_cmd->device->id,
-- 
2.10.0.rc2.1.g053435c
