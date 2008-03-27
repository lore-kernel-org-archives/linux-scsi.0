From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 02/11] zfcp: Clean up _zfcp_san_dbf_event_common_els
Date: Thu, 27 Mar 2008 14:21:56 +0100
Message-ID: <20080327133023.786277000@de.ibm.com>
References: <20080327132154.826339000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:2648 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093AbYC0Na0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 09:30:26 -0400
Content-Disposition: inline; filename=zfcp_san_dbf_simplify_els_hex_dump.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

Clean up _zfcp_san_dbf_event_common_els using zfcp_dbf_hexdump()
helper.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   39 ++++++++++-----------------------------
 1 file changed, 10 insertions(+), 29 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -562,38 +562,19 @@ _zfcp_san_dbf_event_common_els(const cha
 {
 	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct zfcp_san_dbf_record *rec = &adapter->san_dbf_buf;
-	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)rec;
 	unsigned long flags;
-	int offset = 0;
 
 	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
-	do {
-		memset(rec, 0, sizeof(struct zfcp_san_dbf_record));
-		if (offset == 0) {
-			strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
-			rec->fsf_reqid = (unsigned long)fsf_req;
-			rec->fsf_seqno = fsf_req->seq_no;
-			rec->s_id = s_id;
-			rec->d_id = d_id;
-			rec->type.els.ls_code = ls_code;
-			buflen = min(buflen, ZFCP_DBF_ELS_MAX_PAYLOAD);
-			rec->type.els.payload_size = buflen;
-			memcpy(rec->type.els.payload,
-			       buffer, min(buflen, ZFCP_DBF_ELS_PAYLOAD));
-			offset += min(buflen, ZFCP_DBF_ELS_PAYLOAD);
-		} else {
-			strncpy(dump->tag, "dump", ZFCP_DBF_TAG_SIZE);
-			dump->total_size = buflen;
-			dump->offset = offset;
-			dump->size = min(buflen - offset,
-					 (int)sizeof(struct zfcp_san_dbf_record)
-					 - (int)sizeof(struct zfcp_dbf_dump));
-			memcpy(dump->data, buffer + offset, dump->size);
-			offset += dump->size;
-		}
-		debug_event(adapter->san_dbf, level,
-			    rec, sizeof(struct zfcp_san_dbf_record));
-	} while (offset < buflen);
+	memset(rec, 0, sizeof(struct zfcp_san_dbf_record));
+	strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
+	rec->fsf_reqid = (unsigned long)fsf_req;
+	rec->fsf_seqno = fsf_req->seq_no;
+	rec->s_id = s_id;
+	rec->d_id = d_id;
+	rec->type.els.ls_code = ls_code;
+	debug_event(adapter->san_dbf, level, rec, sizeof(*rec));
+	zfcp_dbf_hexdump(adapter->san_dbf, rec, sizeof(*rec), level,
+			 buffer, min(buflen, ZFCP_DBF_ELS_MAX_PAYLOAD));
 	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
 }
 

-- 
