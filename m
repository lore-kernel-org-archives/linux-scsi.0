From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 05/11] zfcp: Introduce printf helper functions for debug trace.
Date: Thu, 27 Mar 2008 14:21:59 +0100
Message-ID: <20080327133026.257442000@de.ibm.com>
References: <20080327132154.826339000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:9318 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439AbYC0Naa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 09:30:30 -0400
Content-Disposition: inline; filename=zfcp_dbf_simplifed_output_functions.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

Introducing helper functions that allow for code simpfifications.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -95,6 +95,22 @@ zfcp_dbf_view(char *out_buf, const char 
 	return len;
 }
 
+static void zfcp_dbf_outs(char **buf, const char *s1, const char *s2)
+{
+	*buf += sprintf(*buf, "%-24s%s\n", s1, s2);
+}
+
+static void zfcp_dbf_out(char **buf, const char *s, const char *format, ...)
+{
+	va_list arg;
+
+	*buf += sprintf(*buf, "%-24s", s);
+	va_start(arg, format);
+	*buf += vsprintf(*buf, format, arg);
+	va_end(arg);
+	*buf += sprintf(*buf, "\n");
+}
+
 static int
 zfcp_dbf_view_dump(char *out_buf, const char *label,
 		   char *buffer, int buflen, int offset, int total_size)

-- 
