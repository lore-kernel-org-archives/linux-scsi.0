From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 15/15] qla4xxx: ping support via BSG interface
Date: Fri, 11 Jun 2010 13:19:28 +0530
Message-ID: <20100611074928.GA27846@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:49682
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753432Ab0FKHvf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 03:51:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    1 +
 drivers/scsi/qla4xxx/ql4_glbl.h |    1 +
 drivers/scsi/qla4xxx/ql4_mbx.c  |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_os.c   |    3 +++
 4 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index b227bbc..3251e23 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -32,6 +32,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
+#include <scsi/scsi_bsg_iscsi.h>
 
 #include "ql4_dbg.h"
 #include "ql4_nx.h"
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 4140dfd..a2abf95 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -56,6 +56,7 @@ int qla4xxx_restore_factory_defaults(struct iscsi_bsg_job *job,
 		struct qla4xxx_bsg_cmd *qla4xxx_cmd);
 int qla4xxx_disable_acb(struct iscsi_bsg_job *bsg_job,
 		struct qla4xxx_bsg_cmd *qla4xxx_cmd);
+int qla4xxx_ping(struct iscsi_bsg_job *bsg_job);
 
 /* FIXME: Goodness!  this really wants a small struct to hold the
  * parameters. On x86 the args will get passed on the stack! */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 524d03e..0e0a308 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1467,3 +1467,42 @@ int qla4xxx_disable_acb(struct iscsi_bsg_job *bsg_job,
 	}
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
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	uint32_t ctrl_flag = 0;
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
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_PING, failed w/ "
+		    "status %04X\n", ha->host_no, __func__,
+		    mbox_sts[0]));
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c59e832..21fe7f5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -356,6 +356,9 @@ static int qla4xxx_bsg_request(struct iscsi_bsg_job *job)
 		    "NOT Supported\n");
 		rval = -ENOSYS;
 		break;
+	case ISCSI_BSG_HST_PING:
+		rval = qla4xxx_ping(job);
+		break;
 	default:
 		rval = -EINVAL;
 		break;
-- 
1.7.0.5

