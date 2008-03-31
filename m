From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/9] zfcp: Simplify usage of hex dump output function for debug trace.
Date: Mon, 31 Mar 2008 11:15:26 +0200
Message-ID: <20080331091832.402743000@de.ibm.com>
References: <20080331091522.688709000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:28578 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbYCaJSf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 05:18:35 -0400
Content-Disposition: inline; filename=zfcp_dbf_cleanup_hexdump_view.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

Simplify usage of output function for hex dumps.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   69 +++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 41 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-31 10:24:54.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-31 10:25:13.000000000 +0200
@@ -90,33 +90,26 @@ static void zfcp_dbf_out(char **buf, con
 	*buf += sprintf(*buf, "\n");
 }
 
-static int
-zfcp_dbf_view_dump(char *out_buf, const char *label,
-		   char *buffer, int buflen, int offset, int total_size)
+static void zfcp_dbf_outd(char **p, const char *label, char *buffer,
+			  int buflen, int offset, int total_size)
 {
-	int len = 0;
-
-	if (offset == 0)
-		len += sprintf(out_buf + len, "%-24s  ", label);
-
+	if (!offset)
+		*p += sprintf(*p, "%-24s  ", label);
 	while (buflen--) {
 		if (offset > 0) {
 			if ((offset % 32) == 0)
-				len += sprintf(out_buf + len, "\n%-24c  ", ' ');
+				*p += sprintf(*p, "\n%-24c  ", ' ');
 			else if ((offset % 4) == 0)
-				len += sprintf(out_buf + len, " ");
+				*p += sprintf(*p, " ");
 		}
-		len += sprintf(out_buf + len, "%02x", *buffer++);
+		*p += sprintf(*p, "%02x", *buffer++);
 		if (++offset == total_size) {
-			len += sprintf(out_buf + len, "\n");
+			*p += sprintf(*p, "\n");
 			break;
 		}
 	}
-
-	if (total_size == 0)
-		len += sprintf(out_buf + len, "\n");
-
-	return len;
+	if (!total_size)
+		*p += sprintf(*p, "\n");
 }
 
 static int
@@ -133,8 +126,8 @@ zfcp_dbf_view_header(debug_info_t * id, 
 			     t.tv_sec, t.tv_nsec);
 		zfcp_dbf_out(&p, "cpu", "%02i", entry->id.fields.cpuid);
 	} else	{
-		p += zfcp_dbf_view_dump(p, NULL, dump->data, dump->size,
-					dump->offset, dump->total_size);
+		zfcp_dbf_outd(&p, NULL, dump->data, dump->size, dump->offset,
+			      dump->total_size);
 		if ((dump->offset + dump->size) == dump->total_size)
 			p += sprintf(p, "\n");
 	}
@@ -348,14 +341,10 @@ static int zfcp_hba_dbf_view_response(ch
 	zfcp_dbf_out(&p, "fsf_issued", "%011lu:%06lu", t.tv_sec, t.tv_nsec);
 	zfcp_dbf_out(&p, "fsf_prot_status", "0x%08x", r->fsf_prot_status);
 	zfcp_dbf_out(&p, "fsf_status", "0x%08x", r->fsf_status);
-	p += zfcp_dbf_view_dump(p, "fsf_prot_status_qual",
-				r->fsf_prot_status_qual,
-				FSF_PROT_STATUS_QUAL_SIZE,
-				0, FSF_PROT_STATUS_QUAL_SIZE);
-	p += zfcp_dbf_view_dump(p, "fsf_status_qual",
-				r->fsf_status_qual,
-				FSF_STATUS_QUALIFIER_SIZE,
-				0, FSF_STATUS_QUALIFIER_SIZE);
+	zfcp_dbf_outd(&p, "fsf_prot_status_qual", r->fsf_prot_status_qual,
+		      FSF_PROT_STATUS_QUAL_SIZE, 0, FSF_PROT_STATUS_QUAL_SIZE);
+	zfcp_dbf_outd(&p, "fsf_status_qual", r->fsf_status_qual,
+		      FSF_STATUS_QUALIFIER_SIZE, 0, FSF_STATUS_QUALIFIER_SIZE);
 	zfcp_dbf_out(&p, "fsf_req_status", "0x%08x", r->fsf_req_status);
 	zfcp_dbf_out(&p, "sbal_first", "0x%02x", r->sbal_first);
 	zfcp_dbf_out(&p, "sbal_curr", "0x%02x", r->sbal_curr);
@@ -415,12 +404,11 @@ static int zfcp_hba_dbf_view_status(char
 	zfcp_dbf_out(&p, "failed", "0x%02x", r->failed);
 	zfcp_dbf_out(&p, "status_type", "0x%08x", r->status_type);
 	zfcp_dbf_out(&p, "status_subtype", "0x%08x", r->status_subtype);
-	p += zfcp_dbf_view_dump(p, "queue_designator",
-				(char *)&r->queue_designator,
-				sizeof(struct fsf_queue_designator),
-				0, sizeof(struct fsf_queue_designator));
-	p += zfcp_dbf_view_dump(p, "payload", (char *)&r->payload,
-				r->payload_size, 0, r->payload_size);
+	zfcp_dbf_outd(&p, "queue_designator", (char *)&r->queue_designator,
+		      sizeof(struct fsf_queue_designator), 0,
+		      sizeof(struct fsf_queue_designator));
+	zfcp_dbf_outd(&p, "payload", (char *)&r->payload, r->payload_size, 0,
+		      r->payload_size);
 	return p - buf;
 }
 
@@ -1031,7 +1019,7 @@ zfcp_san_dbf_view_format(debug_info_t * 
 		buflen = min(total, ZFCP_DBF_ELS_PAYLOAD);
 	}
 
-	p += zfcp_dbf_view_dump(p, "payload", buffer, buflen, 0, total);
+	zfcp_dbf_outd(&p, "payload", buffer, buflen, 0, total);
 	if (buflen == total)
 		p += sprintf(p, "\n");
 
@@ -1179,8 +1167,8 @@ zfcp_scsi_dbf_view_format(debug_info_t *
 	zfcp_dbf_out(&p, "scsi_result", "0x%08x", r->scsi_result);
 	zfcp_dbf_out(&p, "scsi_cmnd", "0x%0Lx", r->scsi_cmnd);
 	zfcp_dbf_out(&p, "scsi_serial", "0x%016Lx", r->scsi_serial);
-	p += zfcp_dbf_view_dump(p, "scsi_opcode", r->scsi_opcode,
-				ZFCP_DBF_SCSI_OPCODE, 0, ZFCP_DBF_SCSI_OPCODE);
+	zfcp_dbf_outd(&p, "scsi_opcode", r->scsi_opcode, ZFCP_DBF_SCSI_OPCODE,
+		      0, ZFCP_DBF_SCSI_OPCODE);
 	zfcp_dbf_out(&p, "scsi_retries", "0x%02x", r->scsi_retries);
 	zfcp_dbf_out(&p, "scsi_allowed", "0x%02x", r->scsi_allowed);
 	if (strncmp(r->tag, "abrt", ZFCP_DBF_TAG_SIZE) == 0)
@@ -1202,11 +1190,10 @@ zfcp_scsi_dbf_view_format(debug_info_t *
 			     r->type.fcp.rsp_code);
 		zfcp_dbf_out(&p, "fcp_sns_info_len", "0x%08x",
 			     r->type.fcp.sns_info_len);
-		p += zfcp_dbf_view_dump(p, "fcp_sns_info",
-					r->type.fcp.sns_info,
-					min((int)r->type.fcp.sns_info_len,
-					ZFCP_DBF_SCSI_FCP_SNS_INFO), 0,
-					r->type.fcp.sns_info_len);
+		zfcp_dbf_outd(&p, "fcp_sns_info", r->type.fcp.sns_info,
+			      min((int)r->type.fcp.sns_info_len,
+			      ZFCP_DBF_SCSI_FCP_SNS_INFO), 0,
+			      r->type.fcp.sns_info_len);
 	}
 	p += sprintf(p, "\n");
 	return p - out_buf;

-- 
