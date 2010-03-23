From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi_trace: Enhance SCSI command tracing
Date: Tue, 23 Mar 2010 01:16:57 -0400
Message-ID: <yq1bpefhb1y.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:45064 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0CWFSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2010 01:18:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>, Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org


Various SCSI trace enhancements:

 - Display data and protection information scatterlist lengths in the
   trace output

 - Add support for VERIFY and WRITE SAME commands and decode the UNMAP
   bit if applicable

 - Add decoding of the PROTECT field for READ/VERIFY/WRITE/WRITE SAME
   commands as well as the EXPECTED INITIAL REFERENCE TAG field for
   their 32-byte variants

 - Decode READ CAPACITY(16), GET LBA STATUS, and UNMAP

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index f5ee7f7..0088140 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -19,7 +19,8 @@
 #include <linux/trace_seq.h>
 #include <trace/events/scsi.h>
 
-#define SERVICE_ACTION(cdb) ((cdb[8] << 8) | cdb[9])
+#define SERVICE_ACTION16(cdb) (cdb[1] & 0x1f)
+#define SERVICE_ACTION32(cdb) ((cdb[8] << 8) | cdb[9])
 
 static const char *
 scsi_trace_misc(struct trace_seq *, unsigned char *, int);
@@ -55,8 +56,9 @@ scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
 	txlen |= (cdb[7] << 8);
 	txlen |=  cdb[8];
 
-	trace_seq_printf(p, "lba=%llu txlen=%llu",
-			 (unsigned long long)lba, (unsigned long long)txlen);
+	trace_seq_printf(p, "lba=%llu txlen=%llu protect=%u",
+			 (unsigned long long)lba, (unsigned long long)txlen,
+			 cdb[1] >> 5);
 	trace_seq_putc(p, 0);
 
 	return ret;
@@ -77,8 +79,9 @@ scsi_trace_rw12(struct trace_seq *p, unsigned char *cdb, int len)
 	txlen |= (cdb[8] << 8);
 	txlen |=  cdb[9];
 
-	trace_seq_printf(p, "lba=%llu txlen=%llu",
-			 (unsigned long long)lba, (unsigned long long)txlen);
+	trace_seq_printf(p, "lba=%llu txlen=%llu protect=%u",
+			 (unsigned long long)lba, (unsigned long long)txlen,
+			 cdb[1] >> 5);
 	trace_seq_putc(p, 0);
 
 	return ret;
@@ -103,8 +106,13 @@ scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
 	txlen |= (cdb[12] << 8);
 	txlen |=  cdb[13];
 
-	trace_seq_printf(p, "lba=%llu txlen=%llu",
-			 (unsigned long long)lba, (unsigned long long)txlen);
+	trace_seq_printf(p, "lba=%llu txlen=%llu protect=%u",
+			 (unsigned long long)lba, (unsigned long long)txlen,
+			 cdb[1] >> 5);
+
+	if (cdb[0] == WRITE_SAME_16)
+		trace_seq_printf(p, " unmap=%u", cdb[1] >> 3 & 1);
+
 	trace_seq_putc(p, 0);
 
 	return ret;
@@ -113,8 +121,27 @@ scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
 static const char *
 scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
 {
-	const char *ret = p->buffer + p->len;
+	const char *ret = p->buffer + p->len, *cmd;
 	sector_t lba = 0, txlen = 0;
+	u32 ei_lbrt = 0;
+
+	switch (SERVICE_ACTION32(cdb)) {
+	case READ_32:
+		cmd = "READ";
+		break;
+	case VERIFY_32:
+		cmd = "VERIFY";
+		break;
+	case WRITE_32:
+		cmd = "WRITE";
+		break;
+	case WRITE_SAME_32:
+		cmd = "WRITE_SAME";
+		break;
+	default:
+		trace_seq_printf(p, "UNKNOWN");
+		goto out;
+	}
 
 	lba |= ((u64)cdb[12] << 56);
 	lba |= ((u64)cdb[13] << 48);
@@ -124,15 +151,76 @@ scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
 	lba |= (cdb[17] << 16);
 	lba |= (cdb[18] << 8);
 	lba |=  cdb[19];
+	ei_lbrt |= (cdb[20] << 24);
+	ei_lbrt |= (cdb[21] << 16);
+	ei_lbrt |= (cdb[22] << 8);
+	ei_lbrt |=  cdb[23];
 	txlen |= (cdb[28] << 24);
 	txlen |= (cdb[29] << 16);
 	txlen |= (cdb[30] << 8);
 	txlen |=  cdb[31];
 
-	trace_seq_printf(p, "%s_32 lba=%llu txlen=%llu",
-			(SERVICE_ACTION(cdb) == READ_32 ? "READ" : "WRITE"),
-			(unsigned long long)lba, (unsigned long long)txlen);
+	trace_seq_printf(p, "%s_32 lba=%llu txlen=%llu protect=%u ei_lbrt=%u",
+			 cmd, (unsigned long long)lba,
+			 (unsigned long long)txlen, cdb[10] >> 5, ei_lbrt);
+
+	if (SERVICE_ACTION32(cdb) == WRITE_SAME_32)
+		trace_seq_printf(p, " unmap=%u", cdb[10] >> 3 & 1);
+
+out:
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+static const char *
+scsi_trace_unmap(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = p->buffer + p->len;
+	unsigned int regions = cdb[7] << 8 | cdb[8];
+
+	trace_seq_printf(p, "regions=%u", (regions - 8) / 16);
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+static const char *
+scsi_trace_service_action_in(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = p->buffer + p->len, *cmd;
+	sector_t lba = 0;
+	u32 alloc_len = 0;
+
+	switch (SERVICE_ACTION16(cdb)) {
+	case SAI_READ_CAPACITY_16:
+		cmd = "READ_CAPACITY_16";
+		break;
+	case SAI_GET_LBA_STATUS:
+		cmd = "GET_LBA_STATUS";
+		break;
+	default:
+		trace_seq_printf(p, "UNKNOWN");
+		goto out;
+	}
+
+	lba |= ((u64)cdb[2] << 56);
+	lba |= ((u64)cdb[3] << 48);
+	lba |= ((u64)cdb[4] << 40);
+	lba |= ((u64)cdb[5] << 32);
+	lba |= (cdb[6] << 24);
+	lba |= (cdb[7] << 16);
+	lba |= (cdb[8] << 8);
+	lba |=  cdb[9];
+	alloc_len |= (cdb[10] << 24);
+	alloc_len |= (cdb[11] << 16);
+	alloc_len |= (cdb[12] << 8);
+	alloc_len |=  cdb[13];
+
+	trace_seq_printf(p, "%s lba=%llu alloc_len=%u", cmd,
+			 (unsigned long long)lba, alloc_len);
 
+out:
 	trace_seq_putc(p, 0);
 
 	return ret;
@@ -141,9 +229,11 @@ scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
 static const char *
 scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
 {
-	switch (SERVICE_ACTION(cdb)) {
+	switch (SERVICE_ACTION32(cdb)) {
 	case READ_32:
+	case VERIFY_32:
 	case WRITE_32:
+	case WRITE_SAME_32:
 		return scsi_trace_rw32(p, cdb, len);
 		/* fall through */
 	default:
@@ -170,14 +260,23 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
 	case WRITE_6:
 		return scsi_trace_rw6(p, cdb, len);
 	case READ_10:
+	case VERIFY:
 	case WRITE_10:
+	case WRITE_SAME:
 		return scsi_trace_rw10(p, cdb, len);
 	case READ_12:
+	case VERIFY_12:
 	case WRITE_12:
 		return scsi_trace_rw12(p, cdb, len);
 	case READ_16:
+	case VERIFY_16:
 	case WRITE_16:
+	case WRITE_SAME_16:
 		return scsi_trace_rw16(p, cdb, len);
+	case UNMAP:
+		return scsi_trace_unmap(p, cdb, len);
+	case SERVICE_ACTION_IN:
+		return scsi_trace_service_action_in(p, cdb, len);
 	case VARIABLE_LENGTH_CMD:
 		return scsi_trace_varlen(p, cdb, len);
 	default:
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 76cbf82..25fbefd 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -200,6 +200,8 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 		__field( unsigned int,	lun	)
 		__field( unsigned int,	opcode	)
 		__field( unsigned int,	cmd_len )
+		__field( unsigned int,	data_sglen )
+		__field( unsigned int,	prot_sglen )
 		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
 	),
 
@@ -210,12 +212,16 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 		__entry->lun		= cmd->device->lun;
 		__entry->opcode		= cmd->cmnd[0];
 		__entry->cmd_len	= cmd->cmd_len;
+		__entry->data_sglen	= scsi_sg_count(cmd);
+		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
 		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
 	),
 
-	TP_printk("host_no=%u channel=%u id=%u lun=%u cmnd=(%s %s raw=%s)",
+	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
+		  " cmnd=(%s %s raw=%s)",
 		  __entry->host_no, __entry->channel, __entry->id,
-		  __entry->lun, show_opcode_name(__entry->opcode),
+		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
+		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len))
 );
@@ -234,6 +240,8 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 		__field( int,		rtn	)
 		__field( unsigned int,	opcode	)
 		__field( unsigned int,	cmd_len )
+		__field( unsigned int,	data_sglen )
+		__field( unsigned int,	prot_sglen )
 		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
 	),
 
@@ -245,13 +253,16 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 		__entry->rtn		= rtn;
 		__entry->opcode		= cmd->cmnd[0];
 		__entry->cmd_len	= cmd->cmd_len;
+		__entry->data_sglen	= scsi_sg_count(cmd);
+		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
 		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
 	),
 
-	TP_printk("host_no=%u channel=%u id=%u lun=%u cmnd=(%s %s raw=%s)"
-		  " rtn=%d",
+	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
+		  " cmnd=(%s %s raw=%s) rtn=%d",
 		  __entry->host_no, __entry->channel, __entry->id,
-		  __entry->lun, show_opcode_name(__entry->opcode),
+		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
+		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __entry->rtn)
@@ -271,6 +282,8 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__field( int,		result	)
 		__field( unsigned int,	opcode	)
 		__field( unsigned int,	cmd_len )
+		__field( unsigned int,	data_sglen )
+		__field( unsigned int,	prot_sglen )
 		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
 	),
 
@@ -282,13 +295,17 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__entry->result		= cmd->result;
 		__entry->opcode		= cmd->cmnd[0];
 		__entry->cmd_len	= cmd->cmd_len;
+		__entry->data_sglen	= scsi_sg_count(cmd);
+		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
 		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
 	),
 
-	TP_printk("host_no=%u channel=%u id=%u lun=%u cmnd=(%s %s raw=%s) "
-		  "result=(driver=%s host=%s message=%s status=%s)",
+	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u " \
+		  "prot_sgl=%u cmnd=(%s %s raw=%s) result=(driver=%s host=%s " \
+		  "message=%s status=%s)",
 		  __entry->host_no, __entry->channel, __entry->id,
-		  __entry->lun, show_opcode_name(__entry->opcode),
+		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
+		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  show_driverbyte_name(((__entry->result) >> 24) & 0xff),
