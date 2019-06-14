From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: qedi: Make some symbols static
Date: Fri, 14 Jun 2019 23:48:20 +0800
Message-ID: <20190614154820.26744-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Fix sparse warnings:

drivers/scsi/qedi/qedi_iscsi.c:1541:6: warning:
 symbol 'qedi_get_iscsi_error' was not declared. Should it be static?
drivers/scsi/qedi/qedi_main.c:1806:17: warning:
 symbol 'qedi_get_cmd_from_tid' was not declared. Should it be static?
drivers/scsi/qedi/qedi_main.c:47:6: warning:
 symbol 'qedi_ll2_buf_size' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 2 +-
 drivers/scsi/qedi/qedi_main.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 8829880..e0bc8c8 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1535,7 +1535,7 @@ static const struct {
 	},
 };
 
-char *qedi_get_iscsi_error(enum iscsi_error_types err_code)
+static char *qedi_get_iscsi_error(enum iscsi_error_types err_code)
 {
 	int i;
 	char *msg = NULL;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 1b58e63..4651a20 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -41,7 +41,7 @@ module_param(qedi_io_tracing, uint, 0644);
 MODULE_PARM_DESC(qedi_io_tracing,
 		 " Enable logging of SCSI requests/completions into trace buffer. (default off).");
 
-uint qedi_ll2_buf_size = 0x400;
+static uint qedi_ll2_buf_size = 0x400;
 module_param(qedi_ll2_buf_size, uint, 0644);
 MODULE_PARM_DESC(qedi_ll2_buf_size,
 		 "parameter to set ping packet size, default - 0x400, Jumbo packets - 0x2400.");
@@ -1813,7 +1813,7 @@ void qedi_get_proto_itt(struct qedi_ctx *qedi, u32 tid, u32 *proto_itt)
 		  tid, *proto_itt);
 }
 
-struct qedi_cmd *qedi_get_cmd_from_tid(struct qedi_ctx *qedi, u32 tid)
+static struct qedi_cmd *qedi_get_cmd_from_tid(struct qedi_ctx *qedi, u32 tid)
 {
 	struct qedi_cmd *cmd = NULL;
 
-- 
2.7.4
