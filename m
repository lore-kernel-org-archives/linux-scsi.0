From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/22] scsi: consolidate scsi_print_status()
Date: Thu, 28 Aug 2014 19:33:24 +0200
Message-ID: <1409247216-76074-11-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaH1Rdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:41 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

Update scsi_print_status() to return a const string and remove
the open-coded versions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aha152x.c        |  7 ++----
 drivers/scsi/constants.c      | 50 ++++++++++++++++++++++++-------------------
 include/scsi/scsi_dbg.h       |  2 +-
 include/trace/events/scsi.h   | 17 +--------------
 include/trace/events/target.h | 17 ++-------------
 5 files changed, 34 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 4da3a3b..4287f86 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2130,11 +2130,8 @@ static void status_run(struct Scsi_Host *shpnt)
 	CURRENT_SC->SCp.Status = GETPORT(SCSIDAT);
 
 #if defined(AHA152X_DEBUG)
-	if (HOSTDATA(shpnt)->debug & debug_status) {
-		printk(DEBUG_LEAD "inbound status %02x ", CMDINFO(CURRENT_SC), CURRENT_SC->SCp.Status);
-		scsi_print_status(CURRENT_SC->SCp.Status);
-		printk("\n");
-	}
+	if (HOSTDATA(shpnt)->debug & debug_status)
+		printk(DEBUG_LEAD "inbound status %02x\n", CMDINFO(CURRENT_SC), CURRENT_SC->SCp.Status);
 #endif
 }
 
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index c0d7b3d..323e944 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -437,34 +437,40 @@ EXPORT_SYMBOL(scsi_print_command);
  *	scsi_print_status - print scsi status description
  *	@scsi_status: scsi status value
  *
- *	If the status is recognized, the description is printed.
- *	Otherwise "Unknown status" is output. No trailing space.
- *	If CONFIG_SCSI_CONSTANTS is not set, then print status in hex
- *	(e.g. "0x2" for Check Condition).
+ *	If the status is recognized, the description is returned.
+ *	Otherwise "Unknown status" is returned.
  **/
-void
+const char *
 scsi_print_status(unsigned char scsi_status) {
-#ifdef CONFIG_SCSI_CONSTANTS
 	const char * ccp;
 
 	switch (scsi_status) {
-	case 0:    ccp = "Good"; break;
-	case 0x2:  ccp = "Check Condition"; break;
-	case 0x4:  ccp = "Condition Met"; break;
-	case 0x8:  ccp = "Busy"; break;
-	case 0x10: ccp = "Intermediate"; break;
-	case 0x14: ccp = "Intermediate-Condition Met"; break;
-	case 0x18: ccp = "Reservation Conflict"; break;
-	case 0x22: ccp = "Command Terminated"; break;	/* obsolete */
-	case 0x28: ccp = "Task set Full"; break;	/* was: Queue Full */
-	case 0x30: ccp = "ACA Active"; break;
-	case 0x40: ccp = "Task Aborted"; break;
-	default:   ccp = "Unknown status";
+	case SAM_STAT_GOOD:
+		ccp = "Good"; break;
+	case SAM_STAT_CHECK_CONDITION:
+		ccp = "Check Condition"; break;
+	case SAM_STAT_CONDITION_MET:
+		ccp = "Condition Met"; break;
+	case SAM_STAT_BUSY:
+		ccp = "Busy"; break;
+	case SAM_STAT_INTERMEDIATE:
+		ccp = "Intermediate"; break;
+	case SAM_STAT_INTERMEDIATE_CONDITION_MET:
+		ccp = "Intermediate-Condition Met"; break;
+	case SAM_STAT_RESERVATION_CONFLICT:
+		ccp = "Reservation Conflict"; break;
+	case SAM_STAT_COMMAND_TERMINATED:
+		ccp = "Command Terminated"; break;	/* obsolete */
+	case SAM_STAT_TASK_SET_FULL:
+		ccp = "Task set Full"; break;	/* was: Queue Full */
+	case SAM_STAT_ACA_ACTIVE:
+		ccp = "ACA Active"; break;
+	case SAM_STAT_TASK_ABORTED:
+		ccp = "Task Aborted"; break;
+	default:
+		ccp = "Unknown status";
 	}
-	printk(KERN_INFO "%s", ccp);
-#else
-	printk(KERN_INFO "0x%0x", scsi_status);
-#endif
+	return ccp;
 }
 EXPORT_SYMBOL(scsi_print_status);
 
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 3d9ac9f..a46bc55 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -21,7 +21,7 @@ extern void __scsi_dump_sense(struct scsi_device *, const char *,
 			      const unsigned char *, int);
 extern void scsi_show_result(struct scsi_device *, const char *, int);
 extern void scsi_print_result(struct scsi_cmnd *);
-extern void scsi_print_status(unsigned char);
+extern const char *scsi_print_status(unsigned char);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
 					  const char **);
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index db6c935..0a6835b 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -169,21 +169,6 @@
 		scsi_msgbyte_name(BUS_DEVICE_RESET),		\
 		scsi_msgbyte_name(ABORT))
 
-#define scsi_statusbyte_name(result)	{ result, #result }
-#define show_statusbyte_name(val)				\
-	__print_symbolic(val,					\
-		scsi_statusbyte_name(SAM_STAT_GOOD),		\
-		scsi_statusbyte_name(SAM_STAT_CHECK_CONDITION),	\
-		scsi_statusbyte_name(SAM_STAT_CONDITION_MET),	\
-		scsi_statusbyte_name(SAM_STAT_BUSY),		\
-		scsi_statusbyte_name(SAM_STAT_INTERMEDIATE),	\
-		scsi_statusbyte_name(SAM_STAT_INTERMEDIATE_CONDITION_MET), \
-		scsi_statusbyte_name(SAM_STAT_RESERVATION_CONFLICT),	\
-		scsi_statusbyte_name(SAM_STAT_COMMAND_TERMINATED),	\
-		scsi_statusbyte_name(SAM_STAT_TASK_SET_FULL),	\
-		scsi_statusbyte_name(SAM_STAT_ACA_ACTIVE),	\
-		scsi_statusbyte_name(SAM_STAT_TASK_ABORTED))
-
 #define scsi_prot_op_name(result)	{ result, #result }
 #define show_prot_op_name(val)					\
 	__print_symbolic(val,					\
@@ -331,7 +316,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		  show_driverbyte_name(((__entry->result) >> 24) & 0xff),
 		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
 		  show_msgbyte_name(((__entry->result) >> 8) & 0xff),
-		  show_statusbyte_name(__entry->result & 0xff))
+		  scsi_print_status(__entry->result & 0xff))
 );
 
 DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,
diff --git a/include/trace/events/target.h b/include/trace/events/target.h
index da9cc0f..de5d594 100644
--- a/include/trace/events/target.h
+++ b/include/trace/events/target.h
@@ -8,6 +8,7 @@
 #include <linux/trace_seq.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_dbg.h>
 #include <target/target_core_base.h>
 
 /* cribbed verbatim from <trace/event/scsi.h> */
@@ -114,20 +115,6 @@
 		{ MSG_ORDERED_TAG,	"ORDERED"	},	\
 		{ MSG_ACA_TAG,		"ACA"		} )
 
-#define show_scsi_status_name(val)				\
-	__print_symbolic(val,					\
-		{ SAM_STAT_GOOD,	"GOOD" },		\
-		{ SAM_STAT_CHECK_CONDITION, "CHECK CONDITION" }, \
-		{ SAM_STAT_CONDITION_MET, "CONDITION MET" },	\
-		{ SAM_STAT_BUSY,	"BUSY" },		\
-		{ SAM_STAT_INTERMEDIATE, "INTERMEDIATE" },	\
-		{ SAM_STAT_INTERMEDIATE_CONDITION_MET, "INTERMEDIATE CONDITION MET" }, \
-		{ SAM_STAT_RESERVATION_CONFLICT, "RESERVATION CONFLICT" }, \
-		{ SAM_STAT_COMMAND_TERMINATED, "COMMAND TERMINATED" }, \
-		{ SAM_STAT_TASK_SET_FULL, "TASK SET FULL" },	\
-		{ SAM_STAT_ACA_ACTIVE, "ACA ACTIVE" },		\
-		{ SAM_STAT_TASK_ABORTED, "TASK ABORTED" } )
-
 TRACE_EVENT(target_sequencer_start,
 
 	TP_PROTO(struct se_cmd *cmd),
@@ -196,7 +183,7 @@ TRACE_EVENT(target_cmd_complete,
 
 	TP_printk("%s <- LUN %03u status %s (sense len %d%s%s)  %s data_length %6u  CDB %s  (TA:%s C:%02x)",
 		  __get_str(initiator), __entry->unpacked_lun,
-		  show_scsi_status_name(__entry->scsi_status),
+		  scsi_print_status(__entry->scsi_status),
 		  __entry->sense_length, __entry->sense_length ? " / " : "",
 		  __print_hex(__entry->sense_data, __entry->sense_length),
 		  show_opcode_name(__entry->opcode),
-- 
1.8.5.2

