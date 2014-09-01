From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 3/3] scsi/trace: Delete a duplicated decoder of SCSI command
Date: Mon, 01 Sep 2014 12:33:33 +0000
Message-ID: <20140901123333.597.49239.stgit@yuno-kbuild.novalocal>
References: <20140901123325.597.47231.stgit@yuno-kbuild.novalocal>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140901123325.597.47231.stgit@yuno-kbuild.novalocal>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, "Ewan D. Milne" <emilne@redhat.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

There is a decoder of SCSI command in constants.c, so this patch deletes it in
SCSI traveevents.

A decoder in traceevents uses macros, so the command name is output as
"XXX_YYY_ZZZ". On the other hand, a decoder in constants uses strings, so
the command name is output as "Xxx Yyy Zzz" including space. We use a decoder
in constants, so this patch adds double quotes for the name.

Note:
- If CONFIG_SCSI_CONSTANTS is disabled, command names are not shown.
- Add command names for 0x07 and 0x2b.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Robert Elliott <Elliott@hp.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 drivers/scsi/constants.c    |   13 +++-
 include/scsi/scsi.h         |    1 
 include/trace/events/scsi.h |  130 +++++++++----------------------------------
 3 files changed, 37 insertions(+), 107 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 8c1f7ac..50e08c8 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -36,7 +36,7 @@
 static const char * cdb_byte0_names[] = {
 /* 00-03 */ "Test Unit Ready", "Rezero Unit/Rewind", NULL, "Request Sense",
 /* 04-07 */ "Format Unit/Medium", "Read Block Limits", NULL,
-	    "Reassign Blocks",
+	    "Reassign Blocks/Initialize Element Status",
 /* 08-0d */ "Read(6)", NULL, "Write(6)", "Seek(6)", NULL, NULL,
 /* 0e-12 */ NULL, "Read Reverse", "Write Filemarks", "Space", "Inquiry",
 /* 13-16 */ "Verify(6)", "Recover Buffered Data", "Mode Select(6)",
@@ -47,8 +47,8 @@ static const char * cdb_byte0_names[] = {
 /* 20-22 */  NULL, NULL, NULL,
 /* 23-28 */ "Read Format Capacities", "Set Window",
 	    "Read Capacity(10)", NULL, NULL, "Read(10)",
-/* 29-2d */ "Read Generation", "Write(10)", "Seek(10)", "Erase(10)",
-            "Read updated block",
+/* 29-2d */ "Read Generation", "Write(10)", "Seek(10)/Position To Element",
+	    "Erase(10)", "Read updated block",
 /* 2e-31 */ "Write Verify(10)", "Verify(10)", "Search High", "Search Equal",
 /* 32-34 */ "Search Low", "Set Limits", "Prefetch/Read Position",
 /* 35-37 */ "Synchronize Cache(10)", "Lock/Unlock Cache(10)",
@@ -103,6 +103,11 @@ static const char * cdb_byte0_names[] = {
             "Volume set (out), Send DVD structure",
 };
 
+inline const char *show_opcode_name(int cdb0)
+{
+	return cdb_byte0_names[cdb0];
+}
+
 struct value_name_pair {
 	int value;
 	const char * name;
@@ -365,7 +370,7 @@ static void print_opcode_name(struct scsi_device *sdev, const char *prefix,
 	if (cdb0 < 0xc0) {
 		cdb_classifier = NULL;
 #ifdef CONFIG_SCSI_CONSTANTS
-		cdb_name = cdb_byte0_names[cdb0];
+		cdb_name = show_opcode_name(cdb0);
 		if (!cdb_name)
 			cdb_classifier = " (reserved)";
 #endif
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 6d6b3ef..59fedff 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -587,6 +587,7 @@ static inline __u32 scsi_to_u32(__u8 *ptr)
 }
 
 #ifdef CONFIG_SCSI_CONSTANTS
+inline const char *show_opcode_name(int cdb0);
 inline const char *show_hostbyte_name(int hb);
 inline const char *show_driverbyte_name(int db);
 #endif
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 67be592..5695ad7 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -9,102 +9,6 @@
 #include <linux/tracepoint.h>
 #include <linux/trace_seq.h>
 
-#define scsi_opcode_name(opcode)	{ opcode, #opcode }
-#define show_opcode_name(val)					\
-	__print_symbolic(val,					\
-		scsi_opcode_name(TEST_UNIT_READY),		\
-		scsi_opcode_name(REZERO_UNIT),			\
-		scsi_opcode_name(REQUEST_SENSE),		\
-		scsi_opcode_name(FORMAT_UNIT),			\
-		scsi_opcode_name(READ_BLOCK_LIMITS),		\
-		scsi_opcode_name(REASSIGN_BLOCKS),		\
-		scsi_opcode_name(INITIALIZE_ELEMENT_STATUS),	\
-		scsi_opcode_name(READ_6),			\
-		scsi_opcode_name(WRITE_6),			\
-		scsi_opcode_name(SEEK_6),			\
-		scsi_opcode_name(READ_REVERSE),			\
-		scsi_opcode_name(WRITE_FILEMARKS),		\
-		scsi_opcode_name(SPACE),			\
-		scsi_opcode_name(INQUIRY),			\
-		scsi_opcode_name(RECOVER_BUFFERED_DATA),	\
-		scsi_opcode_name(MODE_SELECT),			\
-		scsi_opcode_name(RESERVE),			\
-		scsi_opcode_name(RELEASE),			\
-		scsi_opcode_name(COPY),				\
-		scsi_opcode_name(ERASE),			\
-		scsi_opcode_name(MODE_SENSE),			\
-		scsi_opcode_name(START_STOP),			\
-		scsi_opcode_name(RECEIVE_DIAGNOSTIC),		\
-		scsi_opcode_name(SEND_DIAGNOSTIC),		\
-		scsi_opcode_name(ALLOW_MEDIUM_REMOVAL),		\
-		scsi_opcode_name(SET_WINDOW),			\
-		scsi_opcode_name(READ_CAPACITY),		\
-		scsi_opcode_name(READ_10),			\
-		scsi_opcode_name(WRITE_10),			\
-		scsi_opcode_name(SEEK_10),			\
-		scsi_opcode_name(POSITION_TO_ELEMENT),		\
-		scsi_opcode_name(WRITE_VERIFY),			\
-		scsi_opcode_name(VERIFY),			\
-		scsi_opcode_name(SEARCH_HIGH),			\
-		scsi_opcode_name(SEARCH_EQUAL),			\
-		scsi_opcode_name(SEARCH_LOW),			\
-		scsi_opcode_name(SET_LIMITS),			\
-		scsi_opcode_name(PRE_FETCH),			\
-		scsi_opcode_name(READ_POSITION),		\
-		scsi_opcode_name(SYNCHRONIZE_CACHE),		\
-		scsi_opcode_name(LOCK_UNLOCK_CACHE),		\
-		scsi_opcode_name(READ_DEFECT_DATA),		\
-		scsi_opcode_name(MEDIUM_SCAN),			\
-		scsi_opcode_name(COMPARE),			\
-		scsi_opcode_name(COPY_VERIFY),			\
-		scsi_opcode_name(WRITE_BUFFER),			\
-		scsi_opcode_name(READ_BUFFER),			\
-		scsi_opcode_name(UPDATE_BLOCK),			\
-		scsi_opcode_name(READ_LONG),			\
-		scsi_opcode_name(WRITE_LONG),			\
-		scsi_opcode_name(CHANGE_DEFINITION),		\
-		scsi_opcode_name(WRITE_SAME),			\
-		scsi_opcode_name(UNMAP),			\
-		scsi_opcode_name(READ_TOC),			\
-		scsi_opcode_name(LOG_SELECT),			\
-		scsi_opcode_name(LOG_SENSE),			\
-		scsi_opcode_name(XDWRITEREAD_10),		\
-		scsi_opcode_name(MODE_SELECT_10),		\
-		scsi_opcode_name(RESERVE_10),			\
-		scsi_opcode_name(RELEASE_10),			\
-		scsi_opcode_name(MODE_SENSE_10),		\
-		scsi_opcode_name(PERSISTENT_RESERVE_IN),	\
-		scsi_opcode_name(PERSISTENT_RESERVE_OUT),	\
-		scsi_opcode_name(VARIABLE_LENGTH_CMD),		\
-		scsi_opcode_name(REPORT_LUNS),			\
-		scsi_opcode_name(MAINTENANCE_IN),		\
-		scsi_opcode_name(MAINTENANCE_OUT),		\
-		scsi_opcode_name(MOVE_MEDIUM),			\
-		scsi_opcode_name(EXCHANGE_MEDIUM),		\
-		scsi_opcode_name(READ_12),			\
-		scsi_opcode_name(WRITE_12),			\
-		scsi_opcode_name(WRITE_VERIFY_12),		\
-		scsi_opcode_name(SEARCH_HIGH_12),		\
-		scsi_opcode_name(SEARCH_EQUAL_12),		\
-		scsi_opcode_name(SEARCH_LOW_12),		\
-		scsi_opcode_name(READ_ELEMENT_STATUS),		\
-		scsi_opcode_name(SEND_VOLUME_TAG),		\
-		scsi_opcode_name(WRITE_LONG_2),			\
-		scsi_opcode_name(READ_16),			\
-		scsi_opcode_name(WRITE_16),			\
-		scsi_opcode_name(VERIFY_16),			\
-		scsi_opcode_name(WRITE_SAME_16),		\
-		scsi_opcode_name(SERVICE_ACTION_IN),		\
-		scsi_opcode_name(SAI_READ_CAPACITY_16),		\
-		scsi_opcode_name(SAI_GET_LBA_STATUS),		\
-		scsi_opcode_name(MI_REPORT_TARGET_PGS),		\
-		scsi_opcode_name(MO_SET_TARGET_PGS),		\
-		scsi_opcode_name(READ_32),			\
-		scsi_opcode_name(WRITE_32),			\
-		scsi_opcode_name(WRITE_SAME_32),		\
-		scsi_opcode_name(ATA_16),			\
-		scsi_opcode_name(ATA_12))
-
 #define scsi_msgbyte_name(result)	{ result, #result }
 #define show_msgbyte_name(val)					\
 	__print_symbolic(val,					\
@@ -197,14 +101,24 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
 	),
 
+#ifdef CONFIG_SCSI_CONSTANTS
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
-		  " prot_op=%s cmnd=(%s %s raw=%s)",
+		  " prot_op=%s cmnd=(\"%s\" %s raw=%s)",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
 		  show_prot_op_name(__entry->prot_op),
 		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len))
+#else
+	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
+		  " prot_op=%s cmnd=(%s raw=%s)",
+		  __entry->host_no, __entry->channel, __entry->id,
+		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
+		  show_prot_op_name(__entry->prot_op),
+		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
+		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len))
+#endif
 );
 
 TRACE_EVENT(scsi_dispatch_cmd_error,
@@ -241,8 +155,9 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
 	),
 
+#ifdef CONFIG_SCSI_CONSTANTS
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
-		  " prot_op=%s cmnd=(%s %s raw=%s) rtn=%d",
+		  " prot_op=%s cmnd=(\"%s\" %s raw=%s) rtn=%d",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
 		  show_prot_op_name(__entry->prot_op),
@@ -250,6 +165,16 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __entry->rtn)
+#else
+	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
+		  " prot_op=%s cmnd=(%s raw=%s) rtn=%d",
+		  __entry->host_no, __entry->channel, __entry->id,
+		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
+		  show_prot_op_name(__entry->prot_op),
+		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
+		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
+		  __entry->rtn)
+#endif
 );
 
 DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
@@ -288,8 +213,8 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 
 #ifdef CONFIG_SCSI_CONSTANTS
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u " \
-		  "prot_sgl=%u prot_op=%s cmnd=(%s %s raw=%s) result=(driver=" \
-		  "%s host=%s message=%s status=%s)",
+		  "prot_sgl=%u prot_op=%s cmnd=(\"%s\" %s raw=%s) " \
+		  "result=(driver=%s host=%s message=%s status=%s)",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
 		  show_prot_op_name(__entry->prot_op),
@@ -302,12 +227,11 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		  show_statusbyte_name(status_byte(__entry->result)))
 #else
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u " \
-		  "prot_sgl=%u prot_op=%s cmnd=(%s %s raw=%s) result=(driver=" \
-		  "0x%02x host=0x%02x message=0x%02x status=0x%02x)",
+		  "prot_sgl=%u prot_op=%s cmnd=(%s raw=%s) result=" \
+		  "(driver=0x%02x host=0x%02x message=0x%02x status=0x%02x)",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
 		  show_prot_op_name(__entry->prot_op),
-		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  driver_byte(__entry->result), host_byte(__entry->result),
