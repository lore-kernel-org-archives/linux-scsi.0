From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 2/3] scsi/trace: Delete duplicated decoders of hostbyte and
 driverbyte
Date: Mon, 01 Sep 2014 12:33:30 +0000
Message-ID: <20140901123330.597.54765.stgit@yuno-kbuild.novalocal>
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

There are decoders of hostbyte and driverbyte in constants.c, so this patch
deletes those in SCSI traveevents.

Note:
If CONFIG_SCSI_CONSTANTS is disabled, hostbyte, driverbyte, msgbyte, and
statusbyte are output as raw format from this patch.

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
 drivers/scsi/constants.c    |   21 ++++++++++---------
 include/scsi/scsi.h         |    5 +++++
 include/trace/events/scsi.h |   47 +++++++++++++------------------------------
 3 files changed, 30 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index c6a7a4a..8c1f7ac 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1505,21 +1505,22 @@ static const char * const driverbyte_table[]={
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
 #define NUM_DRIVERBYTE_STRS ARRAY_SIZE(driverbyte_table)
 
-void scsi_show_result(struct scsi_device *sdev, const char *name, int result)
+inline const char *show_hostbyte_name(int hb)
 {
-	int hb = host_byte(result);
-	int db = driver_byte(result);
-	const char *hb_string;
-	const char *db_string;
-
-	hb_string = (hb < NUM_HOSTBYTE_STRS) ? hostbyte_table[hb] : "invalid";
-	db_string = (db < NUM_DRIVERBYTE_STRS) ?
-		driverbyte_table[db] : "invalid";
+	return (hb < NUM_HOSTBYTE_STRS) ? hostbyte_table[hb] : "invalid";
+}
 
+inline const char *show_driverbyte_name(int db)
+{
+	return (db < NUM_DRIVERBYTE_STRS) ? driverbyte_table[db] : "invalid";
+}
 
+void scsi_show_result(struct scsi_device *sdev, const char *name, int result)
+{
 	sdev_printk(KERN_INFO, sdev,
 		    "[%s] Result: hostbyte=%s driverbyte=%s\n",
-		    name, hb_string, db_string);
+		    name, show_hostbyte_name(host_byte(result)),
+		    show_driverbyte_name(driver_byte(result)));
 }
 
 #else
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 54ebf54..6d6b3ef 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -586,4 +586,9 @@ static inline __u32 scsi_to_u32(__u8 *ptr)
 	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
 }
 
+#ifdef CONFIG_SCSI_CONSTANTS
+inline const char *show_hostbyte_name(int hb);
+inline const char *show_driverbyte_name(int db);
+#endif
+
 #endif /* _SCSI_SCSI_H */
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 8aecdc2..67be592 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -105,39 +105,6 @@
 		scsi_opcode_name(ATA_16),			\
 		scsi_opcode_name(ATA_12))
 
-#define scsi_hostbyte_name(result)	{ result, #result }
-#define show_hostbyte_name(val)					\
-	__print_symbolic(val,					\
-		scsi_hostbyte_name(DID_OK),			\
-		scsi_hostbyte_name(DID_NO_CONNECT),		\
-		scsi_hostbyte_name(DID_BUS_BUSY),		\
-		scsi_hostbyte_name(DID_TIME_OUT),		\
-		scsi_hostbyte_name(DID_BAD_TARGET),		\
-		scsi_hostbyte_name(DID_ABORT),			\
-		scsi_hostbyte_name(DID_PARITY),			\
-		scsi_hostbyte_name(DID_ERROR),			\
-		scsi_hostbyte_name(DID_RESET),			\
-		scsi_hostbyte_name(DID_BAD_INTR),		\
-		scsi_hostbyte_name(DID_PASSTHROUGH),		\
-		scsi_hostbyte_name(DID_SOFT_ERROR),		\
-		scsi_hostbyte_name(DID_IMM_RETRY),		\
-		scsi_hostbyte_name(DID_REQUEUE),		\
-		scsi_hostbyte_name(DID_TRANSPORT_DISRUPTED),	\
-		scsi_hostbyte_name(DID_TRANSPORT_FAILFAST))
-
-#define scsi_driverbyte_name(result)	{ result, #result }
-#define show_driverbyte_name(val)				\
-	__print_symbolic(val,					\
-		scsi_driverbyte_name(DRIVER_OK),		\
-		scsi_driverbyte_name(DRIVER_BUSY),		\
-		scsi_driverbyte_name(DRIVER_SOFT),		\
-		scsi_driverbyte_name(DRIVER_MEDIA),		\
-		scsi_driverbyte_name(DRIVER_ERROR),		\
-		scsi_driverbyte_name(DRIVER_INVALID),		\
-		scsi_driverbyte_name(DRIVER_TIMEOUT),		\
-		scsi_driverbyte_name(DRIVER_HARD),		\
-		scsi_driverbyte_name(DRIVER_SENSE))
-
 #define scsi_msgbyte_name(result)	{ result, #result }
 #define show_msgbyte_name(val)					\
 	__print_symbolic(val,					\
@@ -319,6 +286,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
 	),
 
+#ifdef CONFIG_SCSI_CONSTANTS
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u " \
 		  "prot_sgl=%u prot_op=%s cmnd=(%s %s raw=%s) result=(driver=" \
 		  "%s host=%s message=%s status=%s)",
@@ -332,6 +300,19 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		  show_hostbyte_name(host_byte(__entry->result)),
 		  show_msgbyte_name(msg_byte(__entry->result)),
 		  show_statusbyte_name(status_byte(__entry->result)))
+#else
+	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u " \
+		  "prot_sgl=%u prot_op=%s cmnd=(%s %s raw=%s) result=(driver=" \
+		  "0x%02x host=0x%02x message=0x%02x status=0x%02x)",
+		  __entry->host_no, __entry->channel, __entry->id,
+		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
+		  show_prot_op_name(__entry->prot_op),
+		  show_opcode_name(__entry->opcode),
+		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
+		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
+		  driver_byte(__entry->result), host_byte(__entry->result),
+		  msg_byte(__entry->result), status_byte(__entry->result))
+#endif
 );
 
 DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,
