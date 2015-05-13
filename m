From: Rajat Jain <rajatja@google.com>
Subject: [PATCH] trace/events/scsi: Add SCSI tag to scsi cmd trace events
Date: Wed, 13 May 2015 12:11:01 -0700
Message-ID: <1431544261-17363-1-git-send-email-rajatja@google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33121 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934295AbbEMTL3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2015 15:11:29 -0400
Received: by iebgx4 with SMTP id gx4so41080076ieb.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 12:11:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Rajat Jain <rajatxjain@gmail.com>, Rajat Jain <rajatja@google.com>

Print the tag along with other information while tracing a command.
This is useful for tracing & debugging tagged commands.

(There are checkpatch errors about spacing, that I did not fix to
 stay consistent with the code immediately above and below in
 that file).

Signed-off-by: Rajat Jain <rajatja@google.com>
---
 include/trace/events/scsi.h | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 079bd10..d61d3d1 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -211,6 +211,7 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 		__field( unsigned int,	lun	)
 		__field( unsigned int,	opcode	)
 		__field( unsigned int,	cmd_len )
+		__field( int,		tag	)
 		__field( unsigned int,	data_sglen )
 		__field( unsigned int,	prot_sglen )
 		__field( unsigned char,	prot_op )
@@ -224,6 +225,7 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 		__entry->lun		= cmd->device->lun;
 		__entry->opcode		= cmd->cmnd[0];
 		__entry->cmd_len	= cmd->cmd_len;
+		__entry->tag		= cmd->request->tag;
 		__entry->data_sglen	= scsi_sg_count(cmd);
 		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
 		__entry->prot_op	= scsi_get_prot_op(cmd);
@@ -231,10 +233,10 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 	),
 
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
-		  " prot_op=%s cmnd=(%s %s raw=%s)",
+		  " prot_op=%s tag=%d cmnd=(%s %s raw=%s)",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
-		  show_prot_op_name(__entry->prot_op),
+		  show_prot_op_name(__entry->prot_op), __entry->tag,
 		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len))
@@ -254,6 +256,7 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 		__field( int,		rtn	)
 		__field( unsigned int,	opcode	)
 		__field( unsigned int,	cmd_len )
+		__field( int,		tag	)
 		__field( unsigned int,	data_sglen )
 		__field( unsigned int,	prot_sglen )
 		__field( unsigned char,	prot_op )
@@ -268,6 +271,7 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 		__entry->rtn		= rtn;
 		__entry->opcode		= cmd->cmnd[0];
 		__entry->cmd_len	= cmd->cmd_len;
+		__entry->tag		= cmd->request->tag;
 		__entry->data_sglen	= scsi_sg_count(cmd);
 		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
 		__entry->prot_op	= scsi_get_prot_op(cmd);
@@ -275,10 +279,10 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 	),
 
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
-		  " prot_op=%s cmnd=(%s %s raw=%s) rtn=%d",
+		  " prot_op=%s tag=%d cmnd=(%s %s raw=%s) rtn=%d",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
-		  show_prot_op_name(__entry->prot_op),
+		  show_prot_op_name(__entry->prot_op), __entry->tag,
 		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
@@ -299,6 +303,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__field( int,		result	)
 		__field( unsigned int,	opcode	)
 		__field( unsigned int,	cmd_len )
+		__field( int,		tag	)
 		__field( unsigned int,	data_sglen )
 		__field( unsigned int,	prot_sglen )
 		__field( unsigned char,	prot_op )
@@ -313,6 +318,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__entry->result		= cmd->result;
 		__entry->opcode		= cmd->cmnd[0];
 		__entry->cmd_len	= cmd->cmd_len;
+		__entry->tag		= cmd->request->tag;
 		__entry->data_sglen	= scsi_sg_count(cmd);
 		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
 		__entry->prot_op	= scsi_get_prot_op(cmd);
@@ -320,11 +326,11 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 	),
 
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u " \
-		  "prot_sgl=%u prot_op=%s cmnd=(%s %s raw=%s) result=(driver=" \
-		  "%s host=%s message=%s status=%s)",
+		  "prot_sgl=%u prot_op=%s tag=%d cmnd=(%s %s raw=%s) " \
+		  "result=(driver=%s host=%s message=%s status=%s)",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
-		  show_prot_op_name(__entry->prot_op),
+		  show_prot_op_name(__entry->prot_op), __entry->tag,
 		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
-- 
2.2.0.rc0.207.ga3a616c

