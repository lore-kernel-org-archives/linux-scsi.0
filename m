From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] SCSI: Include protection operation in SCSI command trace
Date: Tue, 08 Mar 2011 02:03:59 -0500
Message-ID: <yq11v2idrfk.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:33061 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1CHHEU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2011 02:04:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com


When debugging DIF/DIX it is very helpful to be able to see which DIX
operation is associated with the scsi_cmnd. Include the protection op in
the SCSI command trace.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8041fe1..0ce9ddd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1038,6 +1038,7 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 	cmd->request = req;
 
 	cmd->cmnd = req->cmd;
+	cmd->prot_op = SCSI_PROT_NORMAL;
 
 	return cmd;
 }
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 25fbefd..db6c935 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -184,6 +184,17 @@
 		scsi_statusbyte_name(SAM_STAT_ACA_ACTIVE),	\
 		scsi_statusbyte_name(SAM_STAT_TASK_ABORTED))
 
+#define scsi_prot_op_name(result)	{ result, #result }
+#define show_prot_op_name(val)					\
+	__print_symbolic(val,					\
+		scsi_prot_op_name(SCSI_PROT_NORMAL),		\
+		scsi_prot_op_name(SCSI_PROT_READ_INSERT),	\
+		scsi_prot_op_name(SCSI_PROT_WRITE_STRIP),	\
+		scsi_prot_op_name(SCSI_PROT_READ_STRIP),	\
+		scsi_prot_op_name(SCSI_PROT_WRITE_INSERT),	\
+		scsi_prot_op_name(SCSI_PROT_READ_PASS),		\
+		scsi_prot_op_name(SCSI_PROT_WRITE_PASS))
+
 const char *scsi_trace_parse_cdb(struct trace_seq*, unsigned char*, int);
 #define __parse_cdb(cdb, len) scsi_trace_parse_cdb(p, cdb, len)
 
@@ -202,6 +213,7 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 		__field( unsigned int,	cmd_len )
 		__field( unsigned int,	data_sglen )
 		__field( unsigned int,	prot_sglen )
+		__field( unsigned char,	prot_op )
 		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
 	),
 
@@ -214,13 +226,15 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 		__entry->cmd_len	= cmd->cmd_len;
 		__entry->data_sglen	= scsi_sg_count(cmd);
 		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
+		__entry->prot_op	= scsi_get_prot_op(cmd);
 		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
 	),
 
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
-		  " cmnd=(%s %s raw=%s)",
+		  " prot_op=%s cmnd=(%s %s raw=%s)",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
+		  show_prot_op_name(__entry->prot_op),
 		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len))
@@ -242,6 +256,7 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 		__field( unsigned int,	cmd_len )
 		__field( unsigned int,	data_sglen )
 		__field( unsigned int,	prot_sglen )
+		__field( unsigned char,	prot_op )
 		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
 	),
 
@@ -255,13 +270,15 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 		__entry->cmd_len	= cmd->cmd_len;
 		__entry->data_sglen	= scsi_sg_count(cmd);
 		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
+		__entry->prot_op	= scsi_get_prot_op(cmd);
 		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
 	),
 
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
-		  " cmnd=(%s %s raw=%s) rtn=%d",
+		  " prot_op=%s cmnd=(%s %s raw=%s) rtn=%d",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
+		  show_prot_op_name(__entry->prot_op),
 		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
@@ -284,6 +301,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__field( unsigned int,	cmd_len )
 		__field( unsigned int,	data_sglen )
 		__field( unsigned int,	prot_sglen )
+		__field( unsigned char,	prot_op )
 		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
 	),
 
@@ -297,14 +315,16 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__entry->cmd_len	= cmd->cmd_len;
 		__entry->data_sglen	= scsi_sg_count(cmd);
 		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
+		__entry->prot_op	= scsi_get_prot_op(cmd);
 		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
 	),
 
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u " \
-		  "prot_sgl=%u cmnd=(%s %s raw=%s) result=(driver=%s host=%s " \
-		  "message=%s status=%s)",
+		  "prot_sgl=%u prot_op=%s cmnd=(%s %s raw=%s) result=(driver=" \
+		  "%s host=%s message=%s status=%s)",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
+		  show_prot_op_name(__entry->prot_op),
 		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
