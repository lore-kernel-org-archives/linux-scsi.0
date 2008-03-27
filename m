From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 01/11] zfcp: Introduce a helper function that dumps hex data to a zfcp trace.
Date: Thu, 27 Mar 2008 14:21:55 +0100
Message-ID: <20080327133022.774992000@de.ibm.com>
References: <20080327132154.826339000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:50805 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbYC0NaZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 09:30:25 -0400
Content-Disposition: inline; filename=zfcp_dbf_add_hex_dump_function.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -31,6 +31,24 @@ MODULE_PARM_DESC(dbfsize,
 
 #define ZFCP_LOG_AREA			ZFCP_LOG_AREA_OTHER
 
+static void zfcp_dbf_hexdump(debug_info_t *dbf, void *to, int to_len,
+			     int level, char *from, int from_len)
+{
+	int offset;
+	struct zfcp_dbf_dump *dump = to;
+	int room = to_len - sizeof(*dump);
+
+	for (offset = 0; offset < from_len; offset += dump->size) {
+		memset(to, 0, to_len);
+		strncpy(dump->tag, "dump", ZFCP_DBF_TAG_SIZE);
+		dump->total_size = from_len;
+		dump->offset = offset;
+		dump->size = min(from_len - offset, room);
+		memcpy(dump->data, from + offset, dump->size);
+		debug_event(dbf, level, dump, dump->size);
+	}
+}
+
 static int
 zfcp_dbf_stck(char *out_buf, const char *label, unsigned long long stck)
 {

-- 
