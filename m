From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill ASSERT_LOCK
Date: Mon, 21 Apr 2003 12:00:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030421120000.C24845@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:62477 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263801AbTDUJsA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 05:48:00 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

There's just one user left, and that one is in aha152x.c and thus
clearly bogus..


--- 1.27/drivers/scsi/aha152x.c	Thu Mar 27 09:31:56 2003
+++ edited/drivers/scsi/aha152x.c	Mon Apr 21 10:08:55 2003
@@ -1379,8 +1379,6 @@
  */ 
 static int setup_expected_interrupts(struct Scsi_Host *shpnt)
 {
-	ASSERT_LOCK(&QLOCK,1);
-
 	if(CURRENT_SC) {
 		CURRENT_SC->SCp.phase |= 1 << 16;
 	
--- 1.73/drivers/scsi/scsi.h	Fri Apr 18 11:58:55 2003
+++ edited/drivers/scsi/scsi.h	Mon Apr 21 10:10:01 2003
@@ -87,21 +87,6 @@
 #endif
 
 /*
- * Used for debugging the new queueing code.  We want to make sure
- * that the lock state is consistent with design.  Only do this in
- * the user space simulator.
- */
-#define ASSERT_LOCK(_LOCK, _COUNT)
-
-#if defined(CONFIG_SMP) && defined(CONFIG_USER_DEBUG)
-#undef ASSERT_LOCK
-#define ASSERT_LOCK(_LOCK,_COUNT)       \
-        { if( (_LOCK)->lock != _COUNT )   \
-                panic("Lock count inconsistent %s %d\n", __FILE__, __LINE__); \
-                                                                                       }
-#endif
-
-/*
  *  Use these to separate status msg and our bytes
  *
  *  These are set by:
