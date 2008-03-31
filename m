From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/9] zfcp: simplify zfcp_dbf_timestamp()
Date: Mon, 31 Mar 2008 11:15:23 +0200
Message-ID: <20080331091829.435589000@de.ibm.com>
References: <20080331091522.688709000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:28576 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbYCaJSc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 05:18:32 -0400
Content-Disposition: inline; filename=zfcp_dbf_cleanup_timestamp.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

Change zfcp_dbf_timestamp() so that it just calculates timespec from
timestamp. First step to be able to rip this code out of zfcp.
Besides, this change makes it easier to rip out old-style debug view
functions.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 14:58:07.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 14:58:21.000000000 +0100
@@ -49,23 +49,17 @@ static void zfcp_dbf_hexdump(debug_info_
 	}
 }
 
-static int
-zfcp_dbf_stck(char *out_buf, const char *label, unsigned long long stck)
+/* FIXME: this duplicate this code in s390 debug feature */
+static void zfcp_dbf_timestamp(unsigned long long stck, struct timespec *time)
 {
 	unsigned long long sec;
-	struct timespec dbftime;
-	int len = 0;
 
 	stck -= 0x8126d60e46000000LL - (0x3c26700LL * 1000000 * 4096);
 	sec = stck >> 12;
 	do_div(sec, 1000000);
-	dbftime.tv_sec = sec;
+	time->tv_sec = sec;
 	stck -= (sec * 1000000) << 12;
-	dbftime.tv_nsec = ((stck * 1000) >> 12);
-	len += sprintf(out_buf + len, "%-24s%011lu:%06lu\n",
-		       label, dbftime.tv_sec, dbftime.tv_nsec);
-
-	return len;
+	time->tv_nsec = ((stck * 1000) >> 12);
 }
 
 static int zfcp_dbf_tag(char *out_buf, const char *label, const char *tag)
@@ -146,10 +140,12 @@ zfcp_dbf_view_header(debug_info_t * id, 
 {
 	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)DEBUG_DATA(entry);
 	int len = 0;
+	struct timespec t;
 
 	if (strncmp(dump->tag, "dump", ZFCP_DBF_TAG_SIZE) != 0) {
-		len += zfcp_dbf_stck(out_buf + len, "timestamp",
-				     entry->id.stck);
+		zfcp_dbf_timestamp(entry->id.stck, &t);
+		len += zfcp_dbf_view(out_buf + len, "timestamp", "%011lu:%06lu",
+				     t.tv_sec, t.tv_nsec);
 		len += zfcp_dbf_view(out_buf + len, "cpu", "%02i",
 				     entry->id.fields.cpuid);
 	} else {
@@ -363,6 +359,7 @@ zfcp_hba_dbf_view_response(char *out_buf
 			   struct zfcp_hba_dbf_record_response *rec)
 {
 	int len = 0;
+	struct timespec t;
 
 	len += zfcp_dbf_view(out_buf + len, "fsf_command", "0x%08x",
 			     rec->fsf_command);
@@ -370,7 +367,9 @@ zfcp_hba_dbf_view_response(char *out_buf
 			     rec->fsf_reqid);
 	len += zfcp_dbf_view(out_buf + len, "fsf_seqno", "0x%08x",
 			     rec->fsf_seqno);
-	len += zfcp_dbf_stck(out_buf + len, "fsf_issued", rec->fsf_issued);
+	zfcp_dbf_timestamp(rec->fsf_issued, &t);
+	len += zfcp_dbf_view(out_buf + len, "fsf_issued", "%011lu:%06lu",
+			     t.tv_sec, t.tv_nsec);
 	len += zfcp_dbf_view(out_buf + len, "fsf_prot_status", "0x%08x",
 			     rec->fsf_prot_status);
 	len += zfcp_dbf_view(out_buf + len, "fsf_status", "0x%08x",
@@ -1222,6 +1221,7 @@ zfcp_scsi_dbf_view_format(debug_info_t *
 	struct zfcp_scsi_dbf_record *rec =
 	    (struct zfcp_scsi_dbf_record *)in_buf;
 	int len = 0;
+	struct timespec t;
 
 	if (strncmp(rec->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
 		return 0;
@@ -1253,7 +1253,9 @@ zfcp_scsi_dbf_view_format(debug_info_t *
 			     rec->fsf_reqid);
 	len += zfcp_dbf_view(out_buf + len, "fsf_seqno", "0x%08x",
 			     rec->fsf_seqno);
-	len += zfcp_dbf_stck(out_buf + len, "fsf_issued", rec->fsf_issued);
+	zfcp_dbf_timestamp(rec->fsf_issued, &t);
+	len += zfcp_dbf_view(out_buf + len, "fsf_issued", "%011lu:%06lu",
+			     t.tv_sec, t.tv_nsec);
 	if (strncmp(rec->tag, "rslt", ZFCP_DBF_TAG_SIZE) == 0) {
 		len +=
 		    zfcp_dbf_view(out_buf + len, "fcp_rsp_validity", "0x%02x",

-- 
