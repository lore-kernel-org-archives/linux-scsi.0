From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] sg: limit maximum cdb size to 252 bytes
Date: Wed, 25 Jun 2014 13:05:42 -0400
Message-ID: <53AB0166.8060905@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080307080200080506010405"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55768 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033AbaFYRFs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2014 13:05:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>

This is a multi-part message in MIME format.
--------------080307080200080506010405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Boaz Harrosh commented on the "[PATCH v5] sg: relax 16
byte cdb restriction" thread that SCSI variable length
commands (which are all SCSI commands greater than 16
bytes long) must themselves be a multiple of 4 bytes
long.

ChangeLog
   - limit the maximum cdb size permitted by the sg
     v3 interface to 252 bytes. Commands that large
     are called "variable length" and their length
     needs to be a multiple of 4.

Original patch:
   Reviewed-by: Boaz Harrosh <boaz@electrozaur.com>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>


--------------080307080200080506010405
Content-Type: text/x-patch;
 name="sg_cdb252.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg_cdb252.patch"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b6d183a..2e01a9d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -74,9 +74,10 @@ static void sg_proc_cleanup(void);
 #define SG_MAX_DEVS 32768
 
 /* SG_MAX_CDB_SIZE should be 260 (spc4r37 section 3.1.30) however the type
- * of sg_io_hdr::cmd_len can only represent 255
+ * of sg_io_hdr::cmd_len can only represent 255. All SCSI commands greater
+ * than 16 bytes are "variable length" whose length is a multiple of 4
  */
-#define SG_MAX_CDB_SIZE 255
+#define SG_MAX_CDB_SIZE 252
 
 /*
  * Suppose you want to calculate the formula muldiv(x,m,d)=int(x * m / d)

--------------080307080200080506010405--
