From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH] scsi: iscsi_tcp: set BDI_CAP_STABLE_WRITES when data digest enabled
Date: Wed,  7 Mar 2018 20:29:03 +0800
Message-ID: <1520425743-1923-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: lduncan@suse.com, cleech@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

iscsi tcp will first send out data, then calculate and send data
digest. If we don't have BDI_CAP_STABLE_WRITES, the page cache will
be written in spite of the on going writeback. Consequently, wrong
digest will be got and sent to target.

To fix this, set BDI_CAP_STABLE_WRITES when data digest is enabled
in iscsi_tcp .slave_configure callback.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 6198559..261c686 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -37,6 +37,7 @@
 #include <linux/kfifo.h>
 #include <linux/scatterlist.h>
 #include <linux/module.h>
+#include <linux/backing-dev.h>
 #include <net/tcp.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -954,6 +955,12 @@ static int iscsi_sw_tcp_slave_alloc(struct scsi_device *sdev)
 
 static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 {
+	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(sdev->host);
+	struct iscsi_session *session = tcp_sw_host->session;
+	struct iscsi_conn *conn = session->leadconn;
+
+	if (conn->datadgst_en)
+		sdev->request_queue->backing_dev_info->capabilities |= BDI_CAP_STABLE_WRITES;
 	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);
 	blk_queue_dma_alignment(sdev->request_queue, 0);
 	return 0;
-- 
2.7.4
