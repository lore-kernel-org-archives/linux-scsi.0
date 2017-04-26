From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v6 10/10] scsi: Implement blk_mq_ops.show_rq()
Date: Wed, 26 Apr 2017 13:47:57 -0700
Message-ID: <20170426204757.18910-11-bart.vanassche@sandisk.com>
References: <20170426204757.18910-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64997 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967278AbdDZUs3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2017 16:48:29 -0400
In-Reply-To: <20170426204757.18910-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org

Show the SCSI CDB for pending SCSI commands in
/sys/kernel/debug/block/*/mq/*/dispatch and */rq_list. An example
of how SCSI commands are displayed by this code:

ffff8801703245c0 {.op=READ, .cmd_flags=META PRIO, .rq_flags=DONTPREP IO_STAT STATS, .tag=14, .internal_tag=-1, .cmd=Read(10) 28 00 2a 81 1b 30 00 00 08 00}

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: <linux-scsi@vger.kernel.org>
---
 drivers/scsi/Makefile       |  1 +
 drivers/scsi/scsi_debugfs.c | 13 +++++++++++++
 drivers/scsi/scsi_debugfs.h |  4 ++++
 drivers/scsi/scsi_lib.c     |  4 ++++
 4 files changed, 22 insertions(+)
 create mode 100644 drivers/scsi/scsi_debugfs.c
 create mode 100644 drivers/scsi/scsi_debugfs.h

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index fc2855565a51..93dbe58c47c8 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -166,6 +166,7 @@ scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
+scsi_mod-$(CONFIG_BLK_DEBUG_FS)	+= scsi_debugfs.o
 scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
new file mode 100644
index 000000000000..a97c9507103d
--- /dev/null
+++ b/drivers/scsi/scsi_debugfs.c
@@ -0,0 +1,13 @@
+#include <linux/seq_file.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include "scsi_debugfs.h"
+
+void scsi_show_rq(struct seq_file *m, struct request *rq)
+{
+	struct scsi_cmnd *cmd = container_of(scsi_req(rq), typeof(*cmd), req);
+	char buf[80];
+
+	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
+	seq_printf(m, ", .cmd=%s", buf);
+}
diff --git a/drivers/scsi/scsi_debugfs.h b/drivers/scsi/scsi_debugfs.h
new file mode 100644
index 000000000000..951b043e82d0
--- /dev/null
+++ b/drivers/scsi/scsi_debugfs.h
@@ -0,0 +1,4 @@
+struct request;
+struct seq_file;
+
+void scsi_show_rq(struct seq_file *m, struct request *rq);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index abc391e00f7d..1c3e87d6c48f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -34,6 +34,7 @@
 
 #include <trace/events/scsi.h>
 
+#include "scsi_debugfs.h"
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
@@ -2157,6 +2158,9 @@ static const struct blk_mq_ops scsi_mq_ops = {
 	.queue_rq	= scsi_queue_rq,
 	.complete	= scsi_softirq_done,
 	.timeout	= scsi_timeout,
+#ifdef CONFIG_BLK_DEBUG_FS
+	.show_rq	= scsi_show_rq,
+#endif
 	.init_request	= scsi_init_request,
 	.exit_request	= scsi_exit_request,
 	.map_queues	= scsi_map_queues,
-- 
2.12.2
