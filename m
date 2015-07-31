From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] scsi-trace: define ZBC_IN and ZBC_OUT
Date: Fri, 31 Jul 2015 15:20:34 +0200
Message-ID: <1438348834-108152-3-git-send-email-hare@suse.de>
References: <1438348834-108152-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbbGaNUg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 09:20:36 -0400
In-Reply-To: <1438348834-108152-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add new trace functions for ZBC_IN and ZBC_OUT.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_trace.c   | 87 +++++++++++++++++++++++++++++++++++++++++++++
 include/trace/events/scsi.h |  2 ++
 2 files changed, 89 insertions(+)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 08bb47b..0cad956 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -231,6 +231,89 @@ out:
 }
 
 static const char *
+scsi_trace_zbc_in(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = trace_seq_buffer_ptr(p), *cmd;
+	sector_t zone_id = 0;
+	u32 alloc_len = 0;
+	u8 options;
+
+	switch (SERVICE_ACTION16(cdb)) {
+	case ZI_REPORT_ZONES:
+		cmd = "REPORT_ZONES";
+		break;
+	default:
+		trace_seq_puts(p, "UNKNOWN");
+		goto out;
+	}
+
+	zone_id |= ((u64)cdb[2] << 56);
+	zone_id |= ((u64)cdb[3] << 48);
+	zone_id |= ((u64)cdb[4] << 40);
+	zone_id |= ((u64)cdb[5] << 32);
+	zone_id |= (cdb[6] << 24);
+	zone_id |= (cdb[7] << 16);
+	zone_id |= (cdb[8] << 8);
+	zone_id |=  cdb[9];
+	alloc_len |= (cdb[10] << 24);
+	alloc_len |= (cdb[11] << 16);
+	alloc_len |= (cdb[12] << 8);
+	alloc_len |=  cdb[13];
+	options = cdb[14] & 0x3f;
+
+	trace_seq_printf(p, "%s zone=%llu alloc_len=%u options=%u partial=%u",
+			 cmd, (unsigned long long)zone_id, alloc_len,
+			 options, (cdb[14] >> 7) & 1);
+
+out:
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+static const char *
+scsi_trace_zbc_out(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = trace_seq_buffer_ptr(p), *cmd;
+	sector_t zone_id = 0;
+
+	switch (SERVICE_ACTION16(cdb)) {
+	case ZO_CLOSE_ZONE:
+		cmd = "CLOSE_ZONE";
+		break;
+	case ZO_FINISH_ZONE:
+		cmd = "FINISH_ZONE";
+		break;
+	case ZO_OPEN_ZONE:
+		cmd = "OPEN_ZONE";
+		break;
+	case ZO_RESET_WRITE_POINTER:
+		cmd = "RESET_WRITE_POINTER";
+		break;
+	default:
+		trace_seq_puts(p, "UNKNOWN");
+		goto out;
+	}
+
+	zone_id |= ((u64)cdb[2] << 56);
+	zone_id |= ((u64)cdb[3] << 48);
+	zone_id |= ((u64)cdb[4] << 40);
+	zone_id |= ((u64)cdb[5] << 32);
+	zone_id |= (cdb[6] << 24);
+	zone_id |= (cdb[7] << 16);
+	zone_id |= (cdb[8] << 8);
+	zone_id |=  cdb[9];
+
+	trace_seq_printf(p, "%s zone=%llu all=%u", cmd,
+			 (unsigned long long)zone_id, cdb[14] & 1);
+
+out:
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+static const char *
 scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	switch (SERVICE_ACTION32(cdb)) {
@@ -282,6 +365,10 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
 		return scsi_trace_service_action_in(p, cdb, len);
 	case VARIABLE_LENGTH_CMD:
 		return scsi_trace_varlen(p, cdb, len);
+	case ZBC_IN:
+		return scsi_trace_zbc_in(p, cdb, len);
+	case ZBC_OUT:
+		return scsi_trace_zbc_out(p, cdb, len);
 	default:
 		return scsi_trace_misc(p, cdb, len);
 	}
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 5c0d91f..9a9b3e2 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -94,6 +94,8 @@
 		scsi_opcode_name(WRITE_16),			\
 		scsi_opcode_name(VERIFY_16),			\
 		scsi_opcode_name(WRITE_SAME_16),		\
+		scsi_opcode_name(ZBC_OUT),			\
+		scsi_opcode_name(ZBC_IN),			\
 		scsi_opcode_name(SERVICE_ACTION_IN_16),		\
 		scsi_opcode_name(READ_32),			\
 		scsi_opcode_name(WRITE_32),			\
-- 
1.8.5.2

