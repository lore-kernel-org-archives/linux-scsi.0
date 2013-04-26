From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH RESEND 7/9] zfcp: module parameter dbflevel for early debugging
Date: Fri, 26 Apr 2013 16:13:53 +0200
Message-ID: <1366985635-38270-8-git-send-email-maier@linux.vnet.ibm.com>
References: <1366985635-38270-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:59544 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3DZOR5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Apr 2013 10:17:57 -0400
Received: from /spool/local
	by e06smtp18.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Fri, 26 Apr 2013 15:14:06 +0100
In-Reply-To: <1366985635-38270-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>

So far, we could only increase the s390dbf log level after an FCP
device has been initially set online for it to create the dbf entries
required to adjust the level.

Introduce zfcp.dbflevel as counterpart to the already existing
zfcp.dbfsize to enable debugging of e.g. setting an FCP device online.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -3,7 +3,7 @@
  *
  * Debug traces for zfcp.
  *
- * Copyright IBM Corp. 2002, 2010
+ * Copyright IBM Corp. 2002, 2013
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -23,6 +23,13 @@ module_param(dbfsize, uint, 0400);
 MODULE_PARM_DESC(dbfsize,
 		 "number of pages for each debug feature area (default 4)");
 
+static u32 dbflevel = 3;
+
+module_param(dbflevel, uint, 0400);
+MODULE_PARM_DESC(dbflevel,
+		 "log level for each debug feature area "
+		 "(default 3, range 0..6)");
+
 static inline unsigned int zfcp_dbf_plen(unsigned int offset)
 {
 	return sizeof(struct zfcp_dbf_pay) + offset - ZFCP_DBF_PAY_MAX_REC;
@@ -447,7 +454,7 @@ static debug_info_t *zfcp_dbf_reg(const
 		return NULL;
 
 	debug_register_view(d, &debug_hex_ascii_view);
-	debug_set_level(d, 3);
+	debug_set_level(d, dbflevel);
 
 	return d;
 }

