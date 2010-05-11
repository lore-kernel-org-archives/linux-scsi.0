From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 7/7][RFC] iscsi_transport: add new up event for AEN.
Date: Tue, 11 May 2010 13:30:28 +0530
Message-ID: <20100511080028.GA30806@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:17288
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755960Ab0EKIE3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2010 04:04:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

Add up event "ISCSI_KEVENT_HOST_AEN" in iscsi_uevent_e{}
This can be used to send AEN to user space.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    1 +
 drivers/scsi/qla4xxx/ql4_isr.c |    4 ++++
 drivers/scsi/qla4xxx/ql4_os.c  |   23 +++++++++++++++++++++++
 include/scsi/iscsi_if.h        |    1 +
 4 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 6af1d3a..08c0069 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -311,6 +311,7 @@ struct scsi_qla_host {
 #define DPC_RESET_HA_INTR		5 /* 0x00000020 */
 #define DPC_ISNS_RESTART		7 /* 0x00000080 */
 #define DPC_AEN				9 /* 0x00000200 */
+#define DPC_AEN_OFFLOAD			10 /* 0x00000400 */
 #define DPC_GET_DHCP_IP_ADDR		15 /* 0x00008000 */
 #define DPC_LINK_CHANGED		18 /* 0x00040000 */
 
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 596c303..bfede70 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -474,6 +474,10 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 				ha->aen_log.entry[ha->aen_log.count].mbox_sts[i] =
 					readl(&ha->reg->mailbox[i]);
 			ha->aen_log.count++;
+
+			/* The DPC routine post aen to userspace */
+			set_bit(DPC_AEN_OFFLOAD, &ha->dpc_flags);
+			queue_work(ha->dpc_thread, &ha->dpc_work);
 		}
 		switch (mbox_status) {
 		case MBOX_ASTS_SYSTEM_ERROR:
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c21c864..a855aef 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -839,6 +839,24 @@ mem_alloc_error_exit:
 }
 
 /**
+ * qla4xxx_send_aen - post aen to userspace
+ * @ha: Pointer to host adapter structure.
+ **/
+static int qla4xxx_send_aen(struct scsi_qla_host *ha)
+{
+	char *buf = (char *)(&(ha->aen_log));
+
+	if (iscsi_offload_mesg(ha->host, &qla4xxx_iscsi_transport,
+	    ISCSI_KEVENT_HOST_AEN, buf, sizeof(struct ql4_aen_log))) {
+		DEBUG2(printk(KERN_ALERT "qla4xxx:(%ld) aen send error\n",
+		    ha->host_no));
+		return QLA_ERROR;
+	}
+	ha->aen_log.count = 0;
+	return QLA_SUCCESS;
+}
+
+/**
  * qla4xxx_timer - checks every second for work to do.
  * @ha: Pointer to host adapter structure.
  **/
@@ -929,6 +947,7 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 	     test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
 	     test_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags) ||
 	     test_bit(DPC_LINK_CHANGED, &ha->dpc_flags) ||
+	     test_bit(DPC_AEN_OFFLOAD, &ha->dpc_flags) ||
 	     test_bit(DPC_AEN, &ha->dpc_flags)) &&
 	     ha->dpc_thread) {
 		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine"
@@ -1304,6 +1323,10 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 		}
 	}
 
+	/* ---- post aen to userspace? --- */
+	if (test_and_clear_bit(DPC_AEN_OFFLOAD, &ha->dpc_flags))
+		qla4xxx_send_aen(ha);
+
 	/* ---- process AEN? --- */
 	if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags))
 		qla4xxx_process_aen(ha, PROCESS_ALL_AENS);
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index fa51817..8e03121 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -70,6 +70,7 @@ enum iscsi_uevent_e {
 
 	ISCSI_KEVENT_PATH_REQ		= KEVENT_BASE + 7,
 	ISCSI_KEVENT_IF_DOWN		= KEVENT_BASE + 8,
+	ISCSI_KEVENT_HOST_AEN		= KEVENT_BASE + 9,
 };
 
 enum iscsi_tgt_dscvr {
-- 
1.7.0.5

