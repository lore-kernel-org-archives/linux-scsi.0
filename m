From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: [PATCH 2/2 v4] scsi: add scsi trace core functions and put trace
 points
Date: Thu, 01 Apr 2010 20:41:40 +0900
Message-ID: <4BB48674.8030604@jp.fujitsu.com>
References: <4BB4855E.7030509@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46652 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab0DALm6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 07:42:58 -0400
In-Reply-To: <4BB4855E.7030509@jp.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Frederic
Cc: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

This adds scsi trace core functions and trace points.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

---

 linux-2.6.34-rc3-trace-kei/drivers/scsi/Makefile       |    1 
 linux-2.6.34-rc3-trace-kei/drivers/scsi/scsi.c         |    6 
 linux-2.6.34-rc3-trace-kei/drivers/scsi/scsi_error.c   |    4 
 linux-2.6.34-rc3-trace-kei/drivers/scsi/scsi_trace.c   |  185 +++++++++
 linux-2.6.34-rc3-trace-kei/include/trace/events/scsi.h |  328 +++++++++++++++++
 linux-2.6.34-rc3-trace-kei/kernel/trace/trace_output.c |    1 
 6 files changed, 525 insertions(+)

diff -puN drivers/scsi/Makefile~add_scsi_trace_core_functions_and_put_trace_points drivers/scsi/Makefile
--- linux-2.6.34-rc3-trace/drivers/scsi/Makefile~add_scsi_trace_core_functions_and_put_trace_points	2010-04-01 20:38:33.000000000 +0900
+++ linux-2.6.34-rc3-trace-kei/drivers/scsi/Makefile	2010-04-01 20:38:33.000000000 +0900
@@ -162,6 +162,7 @@ scsi_mod-y			+= scsi_scan.o scsi_sysfs.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
+scsi_mod-y			+= scsi_trace.o
 
 scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_if.o
 
diff -puN drivers/scsi/scsi.c~add_scsi_trace_core_functions_and_put_trace_points drivers/scsi/scsi.c
--- linux-2.6.34-rc3-trace/drivers/scsi/scsi.c~add_scsi_trace_core_functions_and_put_trace_points	2010-04-01 20:38:33.000000000 +0900
+++ linux-2.6.34-rc3-trace-kei/drivers/scsi/scsi.c	2010-04-01 20:38:33.000000000 +0900
@@ -67,6 +67,9 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/scsi.h>
+
 static void scsi_done(struct scsi_cmnd *cmd);
 
 /*
@@ -747,10 +750,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 		cmd->result = (DID_NO_CONNECT << 16);
 		scsi_done(cmd);
 	} else {
+		trace_scsi_dispatch_cmd_start(cmd);
 		rtn = host->hostt->queuecommand(cmd, scsi_done);
 	}
 	spin_unlock_irqrestore(host->host_lock, flags);
 	if (rtn) {
+		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
 		    rtn != SCSI_MLQUEUE_TARGET_BUSY)
 			rtn = SCSI_MLQUEUE_HOST_BUSY;
@@ -781,6 +786,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
  */
 static void scsi_done(struct scsi_cmnd *cmd)
 {
+	trace_scsi_dispatch_cmd_done(cmd);
 	blk_complete_request(cmd->request);
 }
 
diff -puN drivers/scsi/scsi_error.c~add_scsi_trace_core_functions_and_put_trace_points drivers/scsi/scsi_error.c
--- linux-2.6.34-rc3-trace/drivers/scsi/scsi_error.c~add_scsi_trace_core_functions_and_put_trace_points	2010-04-01 20:38:33.000000000 +0900
+++ linux-2.6.34-rc3-trace-kei/drivers/scsi/scsi_error.c	2010-04-01 20:38:33.000000000 +0900
@@ -38,6 +38,8 @@
 #include "scsi_logging.h"
 #include "scsi_transport_api.h"
 
+#include <trace/events/scsi.h>
+
 #define SENSE_TIMEOUT		(10*HZ)
 
 /*
@@ -51,6 +53,7 @@
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
 	if (shost->host_busy == shost->host_failed) {
+		trace_scsi_eh_wakeup(shost);
 		wake_up_process(shost->ehandler);
 		SCSI_LOG_ERROR_RECOVERY(5,
 				printk("Waking error handler thread\n"));
@@ -126,6 +129,7 @@ enum blk_eh_timer_return scsi_times_out(
 	struct scsi_cmnd *scmd = req->special;
 	enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
 
+	trace_scsi_dispatch_cmd_timeout(scmd);
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
 	if (scmd->device->host->transportt->eh_timed_out)
diff -puN /dev/null drivers/scsi/scsi_trace.c
--- /dev/null	2010-04-01 20:30:54.253357283 +0900
+++ linux-2.6.34-rc3-trace-kei/drivers/scsi/scsi_trace.c	2010-04-01 20:38:33.000000000 +0900
@@ -0,0 +1,185 @@
+/*
+ * Copyright (C) 2010 FUJITSU LIMITED
+ * Copyright (C) 2010 Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/kernel.h>
+#include <linux/trace_seq.h>
+#include <trace/events/scsi.h>
+
+#define SERVICE_ACTION(cdb) ((cdb[8] << 8) | cdb[9])
+
+static const char *
+scsi_trace_misc(struct trace_seq *, unsigned char *, int);
+
+static const char *
+scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = p->buffer + p->len;
+	sector_t lba = 0, txlen = 0;
+
+	lba |= ((cdb[1] & 0x1F) << 16);
+	lba |=  (cdb[2] << 8);
+	lba |=   cdb[3];
+	txlen = cdb[4];
+
+	trace_seq_printf(p, "lba=%llu txlen=%llu",
+			 (unsigned long long)lba, (unsigned long long)txlen);
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+static const char *
+scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = p->buffer + p->len;
+	sector_t lba = 0, txlen = 0;
+
+	lba |= (cdb[2] << 24);
+	lba |= (cdb[3] << 16);
+	lba |= (cdb[4] << 8);
+	lba |=  cdb[5];
+	txlen |= (cdb[7] << 8);
+	txlen |=  cdb[8];
+
+	trace_seq_printf(p, "lba=%llu txlen=%llu",
+			 (unsigned long long)lba, (unsigned long long)txlen);
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+static const char *
+scsi_trace_rw12(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = p->buffer + p->len;
+	sector_t lba = 0, txlen = 0;
+
+	lba |= (cdb[2] << 24);
+	lba |= (cdb[3] << 16);
+	lba |= (cdb[4] << 8);
+	lba |=  cdb[5];
+	txlen |= (cdb[6] << 24);
+	txlen |= (cdb[7] << 16);
+	txlen |= (cdb[8] << 8);
+	txlen |=  cdb[9];
+
+	trace_seq_printf(p, "lba=%llu txlen=%llu",
+			 (unsigned long long)lba, (unsigned long long)txlen);
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+static const char *
+scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = p->buffer + p->len;
+	sector_t lba = 0, txlen = 0;
+
+	lba |= ((u64)cdb[2] << 56);
+	lba |= ((u64)cdb[3] << 48);
+	lba |= ((u64)cdb[4] << 40);
+	lba |= ((u64)cdb[5] << 32);
+	lba |= (cdb[6] << 24);
+	lba |= (cdb[7] << 16);
+	lba |= (cdb[8] << 8);
+	lba |=  cdb[9];
+	txlen |= (cdb[10] << 24);
+	txlen |= (cdb[11] << 16);
+	txlen |= (cdb[12] << 8);
+	txlen |=  cdb[13];
+
+	trace_seq_printf(p, "lba=%llu txlen=%llu",
+			 (unsigned long long)lba, (unsigned long long)txlen);
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+static const char *
+scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = p->buffer + p->len;
+	sector_t lba = 0, txlen = 0;
+
+	lba |= ((u64)cdb[12] << 56);
+	lba |= ((u64)cdb[13] << 48);
+	lba |= ((u64)cdb[14] << 40);
+	lba |= ((u64)cdb[15] << 32);
+	lba |= (cdb[16] << 24);
+	lba |= (cdb[17] << 16);
+	lba |= (cdb[18] << 8);
+	lba |=  cdb[19];
+	txlen |= (cdb[28] << 24);
+	txlen |= (cdb[29] << 16);
+	txlen |= (cdb[30] << 8);
+	txlen |=  cdb[31];
+
+	trace_seq_printf(p, "%s_32 lba=%llu txlen=%llu",
+			(SERVICE_ACTION(cdb) == READ_32 ? "READ" : "WRITE"),
+			(unsigned long long)lba, (unsigned long long)txlen);
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+static const char *
+scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	switch (SERVICE_ACTION(cdb)) {
+	case READ_32:
+	case WRITE_32:
+		return scsi_trace_rw32(p, cdb, len);
+	default:
+		return scsi_trace_misc(p, cdb, len);
+	}
+}
+
+static const char *
+scsi_trace_misc(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = p->buffer + p->len;
+
+	trace_seq_printf(p, "-");
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+const char *
+scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	switch (cdb[0]) {
+	case READ_6:
+	case WRITE_6:
+		return scsi_trace_rw6(p, cdb, len);
+	case READ_10:
+	case WRITE_10:
+		return scsi_trace_rw10(p, cdb, len);
+	case READ_12:
+	case WRITE_12:
+		return scsi_trace_rw12(p, cdb, len);
+	case READ_16:
+	case WRITE_16:
+		return scsi_trace_rw16(p, cdb, len);
+	case VARIABLE_LENGTH_CMD:
+		return scsi_trace_varlen(p, cdb, len);
+	default:
+		return scsi_trace_misc(p, cdb, len);
+	}
+}
diff -puN /dev/null include/trace/events/scsi.h
--- /dev/null	2010-04-01 20:30:54.253357283 +0900
+++ linux-2.6.34-rc3-trace-kei/include/trace/events/scsi.h	2010-04-01 20:38:33.000000000 +0900
@@ -0,0 +1,328 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM scsi
+
+#if !defined(_TRACE_SCSI_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SCSI_H
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+
+#define scsi_opcode_name(opcode)	{ opcode, #opcode }
+#define show_opcode_name(val)					\
+	__print_symbolic(val,					\
+		scsi_opcode_name(TEST_UNIT_READY),		\
+		scsi_opcode_name(REZERO_UNIT),			\
+		scsi_opcode_name(REQUEST_SENSE),		\
+		scsi_opcode_name(FORMAT_UNIT),			\
+		scsi_opcode_name(READ_BLOCK_LIMITS),		\
+		scsi_opcode_name(REASSIGN_BLOCKS),		\
+		scsi_opcode_name(INITIALIZE_ELEMENT_STATUS),	\
+		scsi_opcode_name(READ_6),			\
+		scsi_opcode_name(WRITE_6),			\
+		scsi_opcode_name(SEEK_6),			\
+		scsi_opcode_name(READ_REVERSE),			\
+		scsi_opcode_name(WRITE_FILEMARKS),		\
+		scsi_opcode_name(SPACE),			\
+		scsi_opcode_name(INQUIRY),			\
+		scsi_opcode_name(RECOVER_BUFFERED_DATA),	\
+		scsi_opcode_name(MODE_SELECT),			\
+		scsi_opcode_name(RESERVE),			\
+		scsi_opcode_name(RELEASE),			\
+		scsi_opcode_name(COPY),				\
+		scsi_opcode_name(ERASE),			\
+		scsi_opcode_name(MODE_SENSE),			\
+		scsi_opcode_name(START_STOP),			\
+		scsi_opcode_name(RECEIVE_DIAGNOSTIC),		\
+		scsi_opcode_name(SEND_DIAGNOSTIC),		\
+		scsi_opcode_name(ALLOW_MEDIUM_REMOVAL),		\
+		scsi_opcode_name(SET_WINDOW),			\
+		scsi_opcode_name(READ_CAPACITY),		\
+		scsi_opcode_name(READ_10),			\
+		scsi_opcode_name(WRITE_10),			\
+		scsi_opcode_name(SEEK_10),			\
+		scsi_opcode_name(POSITION_TO_ELEMENT),		\
+		scsi_opcode_name(WRITE_VERIFY),			\
+		scsi_opcode_name(VERIFY),			\
+		scsi_opcode_name(SEARCH_HIGH),			\
+		scsi_opcode_name(SEARCH_EQUAL),			\
+		scsi_opcode_name(SEARCH_LOW),			\
+		scsi_opcode_name(SET_LIMITS),			\
+		scsi_opcode_name(PRE_FETCH),			\
+		scsi_opcode_name(READ_POSITION),		\
+		scsi_opcode_name(SYNCHRONIZE_CACHE),		\
+		scsi_opcode_name(LOCK_UNLOCK_CACHE),		\
+		scsi_opcode_name(READ_DEFECT_DATA),		\
+		scsi_opcode_name(MEDIUM_SCAN),			\
+		scsi_opcode_name(COMPARE),			\
+		scsi_opcode_name(COPY_VERIFY),			\
+		scsi_opcode_name(WRITE_BUFFER),			\
+		scsi_opcode_name(READ_BUFFER),			\
+		scsi_opcode_name(UPDATE_BLOCK),			\
+		scsi_opcode_name(READ_LONG),			\
+		scsi_opcode_name(WRITE_LONG),			\
+		scsi_opcode_name(CHANGE_DEFINITION),		\
+		scsi_opcode_name(WRITE_SAME),			\
+		scsi_opcode_name(UNMAP),			\
+		scsi_opcode_name(READ_TOC),			\
+		scsi_opcode_name(LOG_SELECT),			\
+		scsi_opcode_name(LOG_SENSE),			\
+		scsi_opcode_name(XDWRITEREAD_10),		\
+		scsi_opcode_name(MODE_SELECT_10),		\
+		scsi_opcode_name(RESERVE_10),			\
+		scsi_opcode_name(RELEASE_10),			\
+		scsi_opcode_name(MODE_SENSE_10),		\
+		scsi_opcode_name(PERSISTENT_RESERVE_IN),	\
+		scsi_opcode_name(PERSISTENT_RESERVE_OUT),	\
+		scsi_opcode_name(VARIABLE_LENGTH_CMD),		\
+		scsi_opcode_name(REPORT_LUNS),			\
+		scsi_opcode_name(MAINTENANCE_IN),		\
+		scsi_opcode_name(MAINTENANCE_OUT),		\
+		scsi_opcode_name(MOVE_MEDIUM),			\
+		scsi_opcode_name(EXCHANGE_MEDIUM),		\
+		scsi_opcode_name(READ_12),			\
+		scsi_opcode_name(WRITE_12),			\
+		scsi_opcode_name(WRITE_VERIFY_12),		\
+		scsi_opcode_name(SEARCH_HIGH_12),		\
+		scsi_opcode_name(SEARCH_EQUAL_12),		\
+		scsi_opcode_name(SEARCH_LOW_12),		\
+		scsi_opcode_name(READ_ELEMENT_STATUS),		\
+		scsi_opcode_name(SEND_VOLUME_TAG),		\
+		scsi_opcode_name(WRITE_LONG_2),			\
+		scsi_opcode_name(READ_16),			\
+		scsi_opcode_name(WRITE_16),			\
+		scsi_opcode_name(VERIFY_16),			\
+		scsi_opcode_name(WRITE_SAME_16),		\
+		scsi_opcode_name(SERVICE_ACTION_IN),		\
+		scsi_opcode_name(SAI_READ_CAPACITY_16),		\
+		scsi_opcode_name(SAI_GET_LBA_STATUS),		\
+		scsi_opcode_name(MI_REPORT_TARGET_PGS),		\
+		scsi_opcode_name(MO_SET_TARGET_PGS),		\
+		scsi_opcode_name(READ_32),			\
+		scsi_opcode_name(WRITE_32),			\
+		scsi_opcode_name(WRITE_SAME_32),		\
+		scsi_opcode_name(ATA_16),			\
+		scsi_opcode_name(ATA_12))
+
+#define scsi_hostbyte_name(result)	{ result, #result }
+#define show_hostbyte_name(val)					\
+	__print_symbolic(val,					\
+		scsi_hostbyte_name(DID_OK),			\
+		scsi_hostbyte_name(DID_NO_CONNECT),		\
+		scsi_hostbyte_name(DID_BUS_BUSY),		\
+		scsi_hostbyte_name(DID_TIME_OUT),		\
+		scsi_hostbyte_name(DID_BAD_TARGET),		\
+		scsi_hostbyte_name(DID_ABORT),			\
+		scsi_hostbyte_name(DID_PARITY),			\
+		scsi_hostbyte_name(DID_ERROR),			\
+		scsi_hostbyte_name(DID_RESET),			\
+		scsi_hostbyte_name(DID_BAD_INTR),		\
+		scsi_hostbyte_name(DID_PASSTHROUGH),		\
+		scsi_hostbyte_name(DID_SOFT_ERROR),		\
+		scsi_hostbyte_name(DID_IMM_RETRY),		\
+		scsi_hostbyte_name(DID_REQUEUE),		\
+		scsi_hostbyte_name(DID_TRANSPORT_DISRUPTED),	\
+		scsi_hostbyte_name(DID_TRANSPORT_FAILFAST))
+
+#define scsi_driverbyte_name(result)	{ result, #result }
+#define show_driverbyte_name(val)				\
+	__print_symbolic(val,					\
+		scsi_driverbyte_name(DRIVER_OK),		\
+		scsi_driverbyte_name(DRIVER_BUSY),		\
+		scsi_driverbyte_name(DRIVER_SOFT),		\
+		scsi_driverbyte_name(DRIVER_MEDIA),		\
+		scsi_driverbyte_name(DRIVER_ERROR),		\
+		scsi_driverbyte_name(DRIVER_INVALID),		\
+		scsi_driverbyte_name(DRIVER_TIMEOUT),		\
+		scsi_driverbyte_name(DRIVER_HARD),		\
+		scsi_driverbyte_name(DRIVER_SENSE))
+
+#define scsi_msgbyte_name(result)	{ result, #result }
+#define show_msgbyte_name(val)					\
+	__print_symbolic(val,					\
+		scsi_msgbyte_name(COMMAND_COMPLETE),		\
+		scsi_msgbyte_name(EXTENDED_MESSAGE),		\
+		scsi_msgbyte_name(SAVE_POINTERS),		\
+		scsi_msgbyte_name(RESTORE_POINTERS),		\
+		scsi_msgbyte_name(DISCONNECT),			\
+		scsi_msgbyte_name(INITIATOR_ERROR),		\
+		scsi_msgbyte_name(ABORT_TASK_SET),		\
+		scsi_msgbyte_name(MESSAGE_REJECT),		\
+		scsi_msgbyte_name(NOP),				\
+		scsi_msgbyte_name(MSG_PARITY_ERROR),		\
+		scsi_msgbyte_name(LINKED_CMD_COMPLETE),		\
+		scsi_msgbyte_name(LINKED_FLG_CMD_COMPLETE),	\
+		scsi_msgbyte_name(TARGET_RESET),		\
+		scsi_msgbyte_name(ABORT_TASK),			\
+		scsi_msgbyte_name(CLEAR_TASK_SET),		\
+		scsi_msgbyte_name(INITIATE_RECOVERY),		\
+		scsi_msgbyte_name(RELEASE_RECOVERY),		\
+		scsi_msgbyte_name(CLEAR_ACA),			\
+		scsi_msgbyte_name(LOGICAL_UNIT_RESET),		\
+		scsi_msgbyte_name(SIMPLE_QUEUE_TAG),		\
+		scsi_msgbyte_name(HEAD_OF_QUEUE_TAG),		\
+		scsi_msgbyte_name(ORDERED_QUEUE_TAG),		\
+		scsi_msgbyte_name(IGNORE_WIDE_RESIDUE),		\
+		scsi_msgbyte_name(ACA),				\
+		scsi_msgbyte_name(QAS_REQUEST),			\
+		scsi_msgbyte_name(BUS_DEVICE_RESET),		\
+		scsi_msgbyte_name(ABORT))
+
+#define scsi_statusbyte_name(result)	{ result, #result }
+#define show_statusbyte_name(val)				\
+	__print_symbolic(val,					\
+		scsi_statusbyte_name(SAM_STAT_GOOD),		\
+		scsi_statusbyte_name(SAM_STAT_CHECK_CONDITION),	\
+		scsi_statusbyte_name(SAM_STAT_CONDITION_MET),	\
+		scsi_statusbyte_name(SAM_STAT_BUSY),		\
+		scsi_statusbyte_name(SAM_STAT_INTERMEDIATE),	\
+		scsi_statusbyte_name(SAM_STAT_INTERMEDIATE_CONDITION_MET), \
+		scsi_statusbyte_name(SAM_STAT_RESERVATION_CONFLICT),	\
+		scsi_statusbyte_name(SAM_STAT_COMMAND_TERMINATED),	\
+		scsi_statusbyte_name(SAM_STAT_TASK_SET_FULL),	\
+		scsi_statusbyte_name(SAM_STAT_ACA_ACTIVE),	\
+		scsi_statusbyte_name(SAM_STAT_TASK_ABORTED))
+
+const char *scsi_trace_parse_cdb(struct trace_seq*, unsigned char*, int);
+#define __parse_cdb(cdb, len) scsi_trace_parse_cdb(p, cdb, len)
+
+TRACE_EVENT(scsi_dispatch_cmd_start,
+
+	TP_PROTO(struct scsi_cmnd *cmd),
+
+	TP_ARGS(cmd),
+
+	TP_STRUCT__entry(
+		__field( unsigned int,	host_no	)
+		__field( unsigned int,	channel	)
+		__field( unsigned int,	id	)
+		__field( unsigned int,	lun	)
+		__field( unsigned int,	opcode	)
+		__field( unsigned int,	cmd_len )
+		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
+	),
+
+	TP_fast_assign(
+		__entry->host_no	= cmd->device->host->host_no;
+		__entry->channel	= cmd->device->channel;
+		__entry->id		= cmd->device->id;
+		__entry->lun		= cmd->device->lun;
+		__entry->opcode		= cmd->cmnd[0];
+		__entry->cmd_len	= cmd->cmd_len;
+		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
+	),
+
+	TP_printk("host_no=%u channel=%u id=%u lun=%u cmnd=(%s %s raw=%s)",
+		  __entry->host_no, __entry->channel, __entry->id,
+		  __entry->lun, show_opcode_name(__entry->opcode),
+		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
+		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len))
+);
+
+TRACE_EVENT(scsi_dispatch_cmd_error,
+
+	TP_PROTO(struct scsi_cmnd *cmd, int rtn),
+
+	TP_ARGS(cmd, rtn),
+
+	TP_STRUCT__entry(
+		__field( unsigned int,	host_no	)
+		__field( unsigned int,	channel	)
+		__field( unsigned int,	id	)
+		__field( unsigned int,	lun	)
+		__field( int,		rtn	)
+		__field( unsigned int,	opcode	)
+		__field( unsigned int,	cmd_len )
+		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
+	),
+
+	TP_fast_assign(
+		__entry->host_no	= cmd->device->host->host_no;
+		__entry->channel	= cmd->device->channel;
+		__entry->id		= cmd->device->id;
+		__entry->lun		= cmd->device->lun;
+		__entry->rtn		= rtn;
+		__entry->opcode		= cmd->cmnd[0];
+		__entry->cmd_len	= cmd->cmd_len;
+		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
+	),
+
+	TP_printk("host_no=%u channel=%u id=%u lun=%u cmnd=(%s %s raw=%s)"
+		  " rtn=%d",
+		  __entry->host_no, __entry->channel, __entry->id,
+		  __entry->lun, show_opcode_name(__entry->opcode),
+		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
+		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
+		  __entry->rtn)
+);
+
+DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
+
+	TP_PROTO(struct scsi_cmnd *cmd),
+
+	TP_ARGS(cmd),
+
+	TP_STRUCT__entry(
+		__field( unsigned int,	host_no	)
+		__field( unsigned int,	channel	)
+		__field( unsigned int,	id	)
+		__field( unsigned int,	lun	)
+		__field( int,		result	)
+		__field( unsigned int,	opcode	)
+		__field( unsigned int,	cmd_len )
+		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
+	),
+
+	TP_fast_assign(
+		__entry->host_no	= cmd->device->host->host_no;
+		__entry->channel	= cmd->device->channel;
+		__entry->id		= cmd->device->id;
+		__entry->lun		= cmd->device->lun;
+		__entry->result		= cmd->result;
+		__entry->opcode		= cmd->cmnd[0];
+		__entry->cmd_len	= cmd->cmd_len;
+		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
+	),
+
+	TP_printk("host_no=%u channel=%u id=%u lun=%u cmnd=(%s %s raw=%s) "
+		  "result=(driver=%s host=%s message=%s status=%s)",
+		  __entry->host_no, __entry->channel, __entry->id,
+		  __entry->lun, show_opcode_name(__entry->opcode),
+		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
+		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
+		  show_driverbyte_name(((__entry->result) >> 24) & 0xff),
+		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
+		  show_msgbyte_name(((__entry->result) >> 8) & 0xff),
+		  show_statusbyte_name(__entry->result & 0xff))
+);
+
+DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,
+	     TP_PROTO(struct scsi_cmnd *cmd),
+	     TP_ARGS(cmd));
+
+DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_timeout,
+	     TP_PROTO(struct scsi_cmnd *cmd),
+	     TP_ARGS(cmd));
+
+TRACE_EVENT(scsi_eh_wakeup,
+
+	TP_PROTO(struct Scsi_Host *shost),
+
+	TP_ARGS(shost),
+
+	TP_STRUCT__entry(
+		__field( unsigned int,	host_no	)
+	),
+
+	TP_fast_assign(
+		__entry->host_no	= shost->host_no;
+	),
+
+	TP_printk("host_no=%u", __entry->host_no)
+);
+
+#endif /*  _TRACE_SCSI_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff -puN kernel/trace/trace_output.c~add_scsi_trace_core_functions_and_put_trace_points kernel/trace/trace_output.c
--- linux-2.6.34-rc3-trace/kernel/trace/trace_output.c~add_scsi_trace_core_functions_and_put_trace_points	2010-04-01 20:38:33.000000000 +0900
+++ linux-2.6.34-rc3-trace-kei/kernel/trace/trace_output.c	2010-04-01 20:38:33.000000000 +0900
@@ -209,6 +209,7 @@ int trace_seq_putc(struct trace_seq *s, 
 
 	return 1;
 }
+EXPORT_SYMBOL(trace_seq_putc);
 
 int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
 {

_



