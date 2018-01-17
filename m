From: Ohad Sharabi <ohad.sharabi@sandisk.com>
Subject: [PATCH] scsi: ufs: add trace event for ufs upiu
Date: Wed, 17 Jan 2018 10:51:27 +0200
Message-ID: <1516179087-23235-1-git-send-email-ohad.sharabi@sandisk.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, gregkh@linuxfoundation.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alex.lemberg@wdc.com, Ohad Sharabi <ohad.sharabi@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

Add UFS Protocol Information Units(upiu) trace events for ufs driver,
used to trace various ufs transaction types- command, task-management
and device management.
The trace-point format is generic and can be easily adapted to trace
other upius if needed.
Currently tracing ufs transaction of type 'device management', which
this patch introduce, cannot be obtained from any other trace.
Device management transactions are used for communication with the
device such as reading and writing descriptor or attributes etc.

Signed-off-by: Ohad Sharabi <ohad.sharabi@sandisk.com>
---
 drivers/scsi/ufs/ufshcd.c  | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 include/trace/events/ufs.h | 28 +++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a355d98..6d79c99 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -274,6 +274,47 @@ static inline void ufshcd_remove_non_printable(char *val)
 		*val = ' ';
 }
 
+static void ufshcd_add_upiu_trace(struct ufs_hba *hba, unsigned int tag,
+	const char *str)
+{
+	struct utp_task_req_desc *descp;
+	struct utp_upiu_task_req *task_req;
+	struct utp_upiu_req *rq;
+	u8 tx_code, *hdr, *tsf;
+	int off;
+
+	if (!trace_ufshcd_upiu_enabled())
+		return;
+
+	off = (int)tag - hba->nutrs;
+	if (off < 0) {
+		rq = hba->lrb[tag].ucd_req_ptr;
+		hdr = (u8 *)&rq->header;
+	} else {
+		descp = &hba->utmrdl_base_addr[off];
+		task_req = (struct utp_upiu_task_req *)descp->task_req_upiu;
+		hdr = (u8 *)&task_req->header;
+	}
+
+	tx_code = hdr[0] & 0x3f;
+	switch (hdr[0] & 0x3f) {
+	case UPIU_TRANSACTION_COMMAND:
+		tsf = (u8 *)&rq->sc.cdb;
+		break;
+	case UPIU_TRANSACTION_TASK_REQ:
+		tsf = (u8 *)&task_req->input_param1;
+		break;
+	case UPIU_TRANSACTION_QUERY_REQ:
+		tsf = (u8 *)&rq->qr;
+		break;
+	default:
+		return;
+	}
+
+	/* trace UPIU header and Transaction Specific Fields (TSF) */
+	trace_ufshcd_upiu(dev_name(hba->dev), str, hdr, tsf);
+}
+
 static void ufshcd_add_command_trace(struct ufs_hba *hba,
 		unsigned int tag, const char *str)
 {
@@ -283,6 +324,9 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba,
 	struct ufshcd_lrb *lrbp;
 	int transfer_len = -1;
 
+	/* trace UPIU also */
+	ufshcd_add_upiu_trace(hba, tag, str);
+
 	if (!trace_ufshcd_command_enabled())
 		return;
 
@@ -5462,11 +5506,14 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 
 	spin_unlock_irqrestore(host->host_lock, flags);
 
+	ufshcd_add_upiu_trace(hba, task_tag, "tm_send");
+
 	/* wait until the task management command is completed */
 	err = wait_event_timeout(hba->tm_wq,
 			test_bit(free_slot, &hba->tm_condition),
 			msecs_to_jiffies(TM_CMD_TIMEOUT));
 	if (!err) {
+		ufshcd_add_upiu_trace(hba, task_tag, "tm_complete_err");
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
 		if (ufshcd_clear_tm_cmd(hba, free_slot))
@@ -5475,6 +5522,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 		err = -ETIMEDOUT;
 	} else {
 		err = ufshcd_task_req_compl(hba, free_slot, tm_response);
+		ufshcd_add_upiu_trace(hba, task_tag, "tm_complete");
 	}
 
 	clear_bit(free_slot, &hba->tm_condition);
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index bf6f826..0b2ff5d 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -257,6 +257,34 @@
 	)
 );
 
+TRACE_EVENT(ufshcd_upiu,
+	TP_PROTO(const char *dev_name, const char *str, unsigned char *hdr,
+			unsigned char *tsf),
+
+	TP_ARGS(dev_name, str, hdr, tsf),
+
+	TP_STRUCT__entry(
+		__string(dev_name, dev_name)
+		__string(str, str)
+		__array(unsigned char, hdr, 12)
+		__array(unsigned char, tsf, 16)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev_name, dev_name);
+		__assign_str(str, str);
+		memcpy(__entry->hdr, hdr, sizeof(__entry->hdr));
+		memcpy(__entry->tsf, tsf, sizeof(__entry->tsf));
+	),
+
+	TP_printk(
+		"%s: %s: HDR:%s, CDB:%s",
+		__get_str(str), __get_str(dev_name),
+		__print_hex(__entry->hdr, sizeof(__entry->hdr)),
+		__print_hex(__entry->tsf, sizeof(__entry->tsf))
+	)
+);
+
 #endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ) */
 
 /* This part must be outside protection */
-- 
1.9.1
