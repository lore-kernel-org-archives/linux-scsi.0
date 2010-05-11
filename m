From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/7][RFC] qla4xxx: ping support via BSG interface
Date: Tue, 11 May 2010 13:27:15 +0530
Message-ID: <20100511075715.GA30495@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:54132
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755875Ab0EKIBQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2010 04:01:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    2 +-
 drivers/scsi/qla4xxx/ql4_glbl.h |    1 +
 drivers/scsi/qla4xxx/ql4_mbx.c  |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_os.c   |    6 ++----
 4 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 527a7ae..6af1d3a 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -32,7 +32,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
-
+#include <scsi/scsi_bsg_iscsi.h>
 
 #ifndef PCI_DEVICE_ID_QLOGIC_ISP4010
 #define PCI_DEVICE_ID_QLOGIC_ISP4010	0x4010
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index c1af9d6..0d153ef 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -53,6 +53,7 @@ int qla4xxx_restore_factory_defaults(struct iscsi_bsg_job *job,
 		struct qla4xxx_bsg_cmd *qla4xxx_cmd);
 int qla4xxx_disable_acb(struct iscsi_bsg_job *bsg_job,
 		struct qla4xxx_bsg_cmd *qla4xxx_cmd);
+int qla4xxx_ping(struct iscsi_bsg_job *bsg_job);
 
 /* FIXME: Goodness!  this really wants a small struct to hold the
  * parameters. On x86 the args will get passed on the stack! */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 12f2e0c..c092fc1 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1320,3 +1320,42 @@ int qla4xxx_disable_acb(struct iscsi_bsg_job *bsg_job,
 
 	return ret;
 }
+
+/**
+ * qla4xxx_ping - ping to specified IP address
+ * @ha: Pointer to host adapter structure.
+ * @job: iscsi_bsg_job to handle
+ **/
+int qla4xxx_ping(struct iscsi_bsg_job *job)
+{
+	uint32_t        mbox_cmd[MBOX_REG_COUNT];
+	uint32_t        mbox_sts[MBOX_REG_COUNT];
+	uint32_t        ctrl_flag = 0;
+	struct scsi_qla_host *ha = to_qla_host(job->shost);
+
+	if (job->request->rqst_data.h_ping.ip_type & ISCSI_PING_IPV6)
+		ctrl_flag |= ISCSI_PING_IPV6;
+	else
+		ctrl_flag = 0;
+
+	memset(mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_PING;
+	mbox_cmd[1] = ctrl_flag;
+	mbox_cmd[2] = job->request->rqst_data.h_ping.ip_address[0];
+	mbox_cmd[3] = job->request->rqst_data.h_ping.ip_address[1];
+	mbox_cmd[4] = job->request->rqst_data.h_ping.ip_address[2];
+	mbox_cmd[5] = job->request->rqst_data.h_ping.ip_address[3];
+	mbox_cmd[6] = job->request->rqst_data.h_ping.payload_size;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_PING, failed w/ "
+		    "status %04X\n", ha->host_no, __func__,
+		    mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 24eaeae..daf862d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -335,10 +335,8 @@ static int qla4xxx_bsg_request(struct iscsi_bsg_job *job)
 	case ISCSI_BSG_HST_VENDOR:
 		rval = qla4xxx_process_vendor_specific(job);
 		break;
-	case ISCSI_BSG_HST_NET_CONFIG:
-		printk(KERN_ERR "ISCSI_BSG_HST_NET_CONFIG Commands "
-		    "NOT Supported\n");
-		rval = -ENOSYS;
+	case ISCSI_BSG_HST_PING:
+		rval = qla4xxx_ping(job);
 		break;
 	default:
 		rval = -EINVAL;
-- 
1.7.0.5

