From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/23] scsi_trace: add tracepoint for completion
Date: Tue, 30 Sep 2014 13:50:52 +0200
Message-ID: <1412077852-40893-24-git-send-email-hare@suse.de>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaI3LvH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 07:51:07 -0400
In-Reply-To: <1412077852-40893-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

A tracepoint should be inserted upon completion to make tracing
equivalent to logging.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c     |  1 +
 drivers/scsi/scsi_trace.c   | 16 ++++++++++++++++
 include/trace/events/scsi.h | 31 +++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2df485f..5c67e4e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1626,6 +1626,7 @@ static void scsi_softirq_done(struct request *rq)
 	}
 
 	scsi_log_completion(cmd, disposition);
+	trace_scsi_cmd_completion(cmd, disposition);
 
 	switch (disposition) {
 		case SUCCESS:
diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 503594e..51a7737 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -286,3 +286,19 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
 		return scsi_trace_misc(p, cdb, len);
 	}
 }
+
+const char *
+scsi_trace_mlreturn_name(struct trace_seq *p, int rtn)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+	const char *mlstr = scsi_mlreturn_string(rtn);
+
+	if (mlstr)
+		trace_seq_printf(p, "%s", mlstr);
+	else
+		trace_seq_printf(p, "UNKNOWN (0x%x)", rtn);
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index db6c935..8df94d3 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -6,6 +6,7 @@
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_dbg.h>
 #include <linux/tracepoint.h>
 #include <linux/trace_seq.h>
 
@@ -195,6 +196,9 @@
 		scsi_prot_op_name(SCSI_PROT_READ_PASS),		\
 		scsi_prot_op_name(SCSI_PROT_WRITE_PASS))
 
+const char *scsi_trace_mlreturn_name(struct trace_seq *, int);
+#define __mlreturn_name(rtn) scsi_trace_mlreturn_name(p, rtn)
+
 const char *scsi_trace_parse_cdb(struct trace_seq*, unsigned char*, int);
 #define __parse_cdb(cdb, len) scsi_trace_parse_cdb(p, cdb, len)
 
@@ -342,6 +346,33 @@ DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_timeout,
 	     TP_PROTO(struct scsi_cmnd *cmd),
 	     TP_ARGS(cmd));
 
+TRACE_EVENT(scsi_cmd_completion,
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
+	),
+
+	TP_fast_assign(
+		__entry->host_no	= cmd->device->host->host_no;
+		__entry->channel	= cmd->device->channel;
+		__entry->id		= cmd->device->id;
+		__entry->lun		= cmd->device->lun;
+		__entry->rtn		= rtn;
+	),
+
+	TP_printk("host_no=%u channel=%u id=%u lun=%u disposition=%s",
+		  __entry->host_no, __entry->channel, __entry->id,
+		  __entry->lun, __mlreturn_name(__entry->rtn))
+);
+
 TRACE_EVENT(scsi_eh_wakeup,
 
 	TP_PROTO(struct Scsi_Host *shost),
-- 
1.8.5.2

