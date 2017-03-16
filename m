From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [RFC 2/2] qla2xxx: Driver changes to use new poll_queue() callback
Date: Thu, 16 Mar 2017 14:40:48 -0700
Message-ID: <20170316214048.20481-3-himanshu.madhani@cavium.com>
References: <20170316214048.20481-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0076.outbound.protection.outlook.com ([104.47.36.76]:13856
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752487AbdCPWRk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 18:17:40 -0400
In-Reply-To: <20170316214048.20481-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org, darren.trapp@cavium.com

From: Darren Trapp <darren.trapp@cavium.com>

The blk_mq layer allows polling a transport for a specific
completion if the HIPRI request flag is set. This can be
accomplished by using "libengine=pvsync2 –hipri" option
in FIO tool. This flag then allows polling into LLDD to
service specific compeletion queue for IOs. It also removes
the interrupt latency and significantly improved performance
in NVMeF that utilizes it. There is expense of higher CPU
utlization due to active polling.

Here's sample results for comparision

FIO command line with synchronous IO’s results in latency avg=32.73us
reported by FIO

./fio/fio  --time_based --ioengine=sync --direct=1 --runtime=30 --readwrite=read \
  --iodepth=1 --blocksize=4k --name=job0 --group_reporting --filename=/dev/sdd

FIO command line with active polling IO’s results in latency avg=26.04 reported by FIO

./fio/fio  --time_based --ioengine=pvsync2 --hipri --direct=1 --runtime=30 \
  --readwrite=read --iodepth=1 --blocksize=4k --name=job0 --group_reporting \
  --filename=/dev/sdd

FIO version 2.17

Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 41d5b09f7326..1f3a113954fd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -253,6 +253,7 @@ static int qla2xxx_scan_finished(struct Scsi_Host *, unsigned long time);
 static void qla2xxx_scan_start(struct Scsi_Host *);
 static void qla2xxx_slave_destroy(struct scsi_device *);
 static int qla2xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
+static int qla2xxx_poll_queue(struct Scsi_Host *, struct scsi_cmnd *);
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_target_reset(struct scsi_cmnd *);
@@ -268,6 +269,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= QLA2XXX_DRIVER_NAME,
 	.queuecommand		= qla2xxx_queuecommand,
+	.poll_queue		= qla2xxx_poll_queue,
 
 	.eh_timed_out		= fc_eh_timed_out,
 	.eh_abort_handler	= qla2xxx_eh_abort,
@@ -973,6 +975,40 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 }
 
 /*
+ * Poll for command to be completed. Initiated by SCSI layer.
+ */
+static int
+qla2xxx_poll_queue(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+{
+	uint32_t tag;
+	uint16_t hwq;
+	struct qla_qpair *qpair;
+	unsigned long flags;
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	int ret = 0;
+
+	tag = blk_mq_unique_tag(cmd->request);
+	hwq = blk_mq_unique_tag_to_hwq(tag);
+	qpair = ha->queue_pair_map[hwq];
+
+	/* Acquire  ring specific lock */
+	spin_lock_irqsave(&qpair->qp_lock, flags);
+	if (!CMD_SP(cmd)) {
+		spin_unlock_irqrestore(&qpair->qp_lock, flags);
+		return 1;
+	}
+
+	qla24xx_process_response_queue(vha, qpair->rsp);
+
+	if (!CMD_SP(cmd))
+		ret = 1;
+
+	spin_unlock_irqrestore(&qpair->qp_lock, flags);
+	return ret;
+}
+
+/*
  * qla2x00_eh_wait_on_command
  *    Waits for the command to be returned by the Firmware for some
  *    max time.
-- 
2.12.0
