From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH] scsi: qla2xxx: reduce the time granularity of the qla2x00_eh_wait_on_command
Date: Thu, 24 May 2018 17:16:10 +0800
Message-ID: <1527153370-1741-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If the cmd has not be returned after aborted by qla2x00_eh_abort,
when qla2x00_eh_wait_on_command is invoked, it has to wait for it.
However, the time is 1000ms at least currently. If there are a lot
cmds need to be aborted, the delay could be long enough to lead to
panic due to such as hung task, ocfs2 heartbeat, etc, just before
scsi recovery work completes and get back the HBA.

Change the granularity to 1ms, even though more context switches
would be introduced, but it should be ok as it is not hot path.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 15eaa6d..9ea4e02 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1064,7 +1064,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
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
