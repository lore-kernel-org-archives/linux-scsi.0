From: Joe Perches <joe@perches.com>
Subject: [PATCH] 2.6.10 include/scsi/scsi.h and drivers/scsi/constants.h
Date: Mon, 31 Jan 2005 09:43:03 -0800
Message-ID: <1107193383.11517.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:10247 "EHLO Perches.com")
	by vger.kernel.org with ESMTP id S261287AbVAaRnq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 12:43:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Remove unnecessary ";" from #define and use sense_ macros

--- include/scsi/scsi.h~	2004-12-29 18:58:36.000000000 -0800
+++ include/scsi/scsi.h	2005-01-31 09:07:16.000000000 -0800
@@ -356,7 +356,7 @@
 
 #define sense_class(sense)  (((sense) >> 4) & 0x7)
 #define sense_error(sense)  ((sense) & 0xf)
-#define sense_valid(sense)  ((sense) & 0x80);
+#define sense_valid(sense)  ((sense) & 0x80)
 
 
 #define IDENTIFY_BASE       0x80
--- drivers/scsi/constants.c~	2004-10-18 14:54:39.000000000 -0700
+++ drivers/scsi/constants.c	2005-01-31 09:06:51.000000000 -0800
@@ -924,17 +924,17 @@
 		     const unsigned char *sense_buffer,
 		     struct request *req)
 {
-	int s, sense_class, valid, code, info;
+	int s, class, valid, code, info;
 	const char *error = NULL;
 	unsigned char asc, ascq;
 	const char *sense_txt;
 	const char *name = req->rq_disk ? req->rq_disk->disk_name : devclass;
     
-	sense_class = (sense_buffer[0] >> 4) & 0x07;
-	code = sense_buffer[0] & 0xf;
-	valid = sense_buffer[0] & 0x80;
+	class = sense_class(sense_buffer[0]);
+	code = sense_error(sense_buffer[0]);
+	valid = sense_valid(sense_buffer[0]);
     
-	if (sense_class == 7) {	/* extended sense data */
+	if (class == 7) {	/* extended sense data */
 		s = sense_buffer[7] + 8;
 		if (s > SCSI_SENSE_BUFFERSIZE)
 			s = SCSI_SENSE_BUFFERSIZE;
@@ -1002,7 +1002,7 @@
 			       sense_buffer[0], sense_buffer[2]);
 
 		printk("Non-extended sense class %d code 0x%0x\n",
-		       sense_class, code);
+		       class, code);
 		s = 4;
 	}
     


