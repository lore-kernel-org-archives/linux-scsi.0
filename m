From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH] scsi: qla2xxx: reduce the time granularity of qla2x00_eh_wait_on_command
Date: Tue, 10 Apr 2018 16:48:35 +0800
Message-ID: <1523350115-4026-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If the cmd has not be returned after aborted by qla2x00_eh_abort,
we have to wait for it. However, the time is 1000ms at least currently.
If there are a lot cmds need to be aborted, the delay could be long
enough to lead to panic due to such as hung task, ocfs2 heartbeat,
etc, just before scsi recovery works.
Change the granularity to 1ms, even though more context switches
would be introduced, but it should be ok as it is not hot path.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5c5dcca4..9f52ad9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1072,7 +1072,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 static int
 qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
 {
-#define ABORT_POLLING_PERIOD	1000
+#define ABORT_POLLING_PERIOD	1
 #define ABORT_WAIT_ITER		((2 * 1000) / (ABORT_POLLING_PERIOD))
 	unsigned long wait_iter = ABORT_WAIT_ITER;
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-- 
2.7.4
