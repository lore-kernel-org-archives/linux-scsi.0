From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 8/8] zfcp: Fix hexdump data in s390dbf traces
Date: Tue, 04 Nov 2008 16:35:12 +0100
Message-ID: <20081104153630.959928000@de.ibm.com>
References: <20081104153504.606043000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:35320 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbYKDPgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 10:36:33 -0500
Content-Disposition: inline; filename=debug-hexdump.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Fix multiple problems found in the hexdump data:
 - length calculation was wrong, traces were incomplete
 - FC payloads were dumped in different record than the output
   function tried to read
 - minor fixes in output
 - allow complete RSCN traces (up to 1024 bytes according to spec)

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   42 ++++++++++++++++--------------------------
 drivers/s390/scsi/zfcp_dbf.h |    8 ++------
 2 files changed, 18 insertions(+), 32 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-11-03 16:47:05.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-11-03 16:49:33.000000000 +0100
@@ -30,7 +30,7 @@ static void zfcp_dbf_hexdump(debug_info_
 		dump->offset = offset;
 		dump->size = min(from_len - offset, room);
 		memcpy(dump->data, from + offset, dump->size);
-		debug_event(dbf, level, dump, dump->size);
+		debug_event(dbf, level, dump, dump->size + sizeof(*dump));
 	}
 }
 
@@ -108,7 +108,7 @@ static int zfcp_dbf_view_header(debug_in
 			     t.tv_sec, t.tv_nsec);
 		zfcp_dbf_out(&p, "cpu", "%02i", entry->id.fields.cpuid);
 	} else	{
-		zfcp_dbf_outd(&p, NULL, dump->data, dump->size, dump->offset,
+		zfcp_dbf_outd(&p, "", dump->data, dump->size, dump->offset,
 			      dump->total_size);
 		if ((dump->offset + dump->size) == dump->total_size)
 			p += sprintf(p, "\n");
@@ -366,6 +366,7 @@ static void zfcp_hba_dbf_view_response(c
 			break;
 		zfcp_dbf_out(p, "scsi_cmnd", "0x%0Lx", r->u.fcp.cmnd);
 		zfcp_dbf_out(p, "scsi_serial", "0x%016Lx", r->u.fcp.serial);
+		p += sprintf(*p, "\n");
 		break;
 
 	case FSF_QTCB_OPEN_PORT_WITH_DID:
@@ -465,7 +466,8 @@ static int zfcp_hba_dbf_view_format(debu
 	else if (strncmp(r->tag, "berr", ZFCP_DBF_TAG_SIZE) == 0)
 		zfcp_hba_dbf_view_berr(&p, &r->u.berr);
 
-	p += sprintf(p, "\n");
+	if (strncmp(r->tag, "resp", ZFCP_DBF_TAG_SIZE) != 0)
+		p += sprintf(p, "\n");
 	return p - out_buf;
 }
 
@@ -880,6 +882,7 @@ void zfcp_san_dbf_event_ct_request(struc
 	struct ct_hdr *hdr = sg_virt(ct->req);
 	struct zfcp_san_dbf_record *r = &adapter->san_dbf_buf;
 	struct zfcp_san_dbf_record_ct_request *oct = &r->u.ct_req;
+	int level = 3;
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
@@ -896,9 +899,10 @@ void zfcp_san_dbf_event_ct_request(struc
 	oct->options = hdr->options;
 	oct->max_res_size = hdr->max_res_size;
 	oct->len = min((int)ct->req->length - (int)sizeof(struct ct_hdr),
-		       ZFCP_DBF_CT_PAYLOAD);
-	memcpy(oct->payload, (void *)hdr + sizeof(struct ct_hdr), oct->len);
-	debug_event(adapter->san_dbf, 3, r, sizeof(*r));
+		       ZFCP_DBF_SAN_MAX_PAYLOAD);
+	debug_event(adapter->san_dbf, level, r, sizeof(*r));
+	zfcp_dbf_hexdump(adapter->san_dbf, r, sizeof(*r), level,
+			 (void *)hdr + sizeof(struct ct_hdr), oct->len);
 	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
 }
 
@@ -914,6 +918,7 @@ void zfcp_san_dbf_event_ct_response(stru
 	struct ct_hdr *hdr = sg_virt(ct->resp);
 	struct zfcp_san_dbf_record *r = &adapter->san_dbf_buf;
 	struct zfcp_san_dbf_record_ct_response *rct = &r->u.ct_resp;
+	int level = 3;
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
@@ -929,9 +934,10 @@ void zfcp_san_dbf_event_ct_response(stru
 	rct->expl = hdr->reason_code_expl;
 	rct->vendor_unique = hdr->vendor_unique;
 	rct->len = min((int)ct->resp->length - (int)sizeof(struct ct_hdr),
-		       ZFCP_DBF_CT_PAYLOAD);
-	memcpy(rct->payload, (void *)hdr + sizeof(struct ct_hdr), rct->len);
-	debug_event(adapter->san_dbf, 3, r, sizeof(*r));
+		       ZFCP_DBF_SAN_MAX_PAYLOAD);
+	debug_event(adapter->san_dbf, level, r, sizeof(*r));
+	zfcp_dbf_hexdump(adapter->san_dbf, r, sizeof(*r), level,
+			 (void *)hdr + sizeof(struct ct_hdr), rct->len);
 	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
 }
 
@@ -954,7 +960,7 @@ static void zfcp_san_dbf_event_els(const
 	rec->u.els.ls_code = ls_code;
 	debug_event(adapter->san_dbf, level, rec, sizeof(*rec));
 	zfcp_dbf_hexdump(adapter->san_dbf, rec, sizeof(*rec), level,
-			 buffer, min(buflen, ZFCP_DBF_ELS_MAX_PAYLOAD));
+			 buffer, min(buflen, ZFCP_DBF_SAN_MAX_PAYLOAD));
 	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
 }
 
@@ -1008,8 +1014,6 @@ static int zfcp_san_dbf_view_format(debu
 				    char *out_buf, const char *in_buf)
 {
 	struct zfcp_san_dbf_record *r = (struct zfcp_san_dbf_record *)in_buf;
-	char *buffer = NULL;
-	int buflen = 0, total = 0;
 	char *p = out_buf;
 
 	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
@@ -1029,9 +1033,6 @@ static int zfcp_san_dbf_view_format(debu
 		zfcp_dbf_out(&p, "gs_subtype", "0x%02x", ct->gs_subtype);
 		zfcp_dbf_out(&p, "options", "0x%02x", ct->options);
 		zfcp_dbf_out(&p, "max_res_size", "0x%04x", ct->max_res_size);
-		total = ct->len;
-		buffer = ct->payload;
-		buflen = min(total, ZFCP_DBF_CT_PAYLOAD);
 	} else if (strncmp(r->tag, "rctc", ZFCP_DBF_TAG_SIZE) == 0) {
 		struct zfcp_san_dbf_record_ct_response *ct = &r->u.ct_resp;
 		zfcp_dbf_out(&p, "cmd_rsp_code", "0x%04x", ct->cmd_rsp_code);
@@ -1039,23 +1040,12 @@ static int zfcp_san_dbf_view_format(debu
 		zfcp_dbf_out(&p, "reason_code", "0x%02x", ct->reason_code);
 		zfcp_dbf_out(&p, "reason_code_expl", "0x%02x", ct->expl);
 		zfcp_dbf_out(&p, "vendor_unique", "0x%02x", ct->vendor_unique);
-		total = ct->len;
-		buffer = ct->payload;
-		buflen = min(total, ZFCP_DBF_CT_PAYLOAD);
 	} else if (strncmp(r->tag, "oels", ZFCP_DBF_TAG_SIZE) == 0 ||
 		   strncmp(r->tag, "rels", ZFCP_DBF_TAG_SIZE) == 0 ||
 		   strncmp(r->tag, "iels", ZFCP_DBF_TAG_SIZE) == 0) {
 		struct zfcp_san_dbf_record_els *els = &r->u.els;
 		zfcp_dbf_out(&p, "ls_code", "0x%02x", els->ls_code);
-		total = els->len;
-		buffer = els->payload;
-		buflen = min(total, ZFCP_DBF_ELS_PAYLOAD);
 	}
-
-	zfcp_dbf_outd(&p, "payload", buffer, buflen, 0, total);
-	if (buflen == total)
-		p += sprintf(p, "\n");
-
 	return p - out_buf;
 }
 
--- a/drivers/s390/scsi/zfcp_dbf.h	2008-11-03 16:47:05.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.h	2008-11-03 16:49:20.000000000 +0100
@@ -163,8 +163,6 @@ struct zfcp_san_dbf_record_ct_request {
 	u8 options;
 	u16 max_res_size;
 	u32 len;
-#define ZFCP_DBF_CT_PAYLOAD	24
-	u8 payload[ZFCP_DBF_CT_PAYLOAD];
 } __attribute__ ((packed));
 
 struct zfcp_san_dbf_record_ct_response {
@@ -174,15 +172,11 @@ struct zfcp_san_dbf_record_ct_response {
 	u8 expl;
 	u8 vendor_unique;
 	u32 len;
-	u8 payload[ZFCP_DBF_CT_PAYLOAD];
 } __attribute__ ((packed));
 
 struct zfcp_san_dbf_record_els {
 	u8 ls_code;
 	u32 len;
-#define ZFCP_DBF_ELS_PAYLOAD	32
-#define ZFCP_DBF_ELS_MAX_PAYLOAD 1024
-	u8 payload[ZFCP_DBF_ELS_PAYLOAD];
 } __attribute__ ((packed));
 
 struct zfcp_san_dbf_record {
@@ -196,6 +190,8 @@ struct zfcp_san_dbf_record {
 		struct zfcp_san_dbf_record_ct_response ct_resp;
 		struct zfcp_san_dbf_record_els els;
 	} u;
+#define ZFCP_DBF_SAN_MAX_PAYLOAD 1024
+	u8 payload[32];
 } __attribute__ ((packed));
 
 struct zfcp_scsi_dbf_record {

-- 
