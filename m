From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] BKL removal for EH thread startup
Date: Wed, 25 Aug 2004 18:39:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040825163932.GA12679@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:28861 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268120AbUHYQjg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 12:39:36 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

We don't need the BKL anymore for thread startup.


===== drivers/scsi/scsi_error.c 1.79 vs edited =====
--- 1.79/drivers/scsi/scsi_error.c	2004-06-19 16:47:16 +02:00
+++ edited/drivers/scsi/scsi_error.c	2004-08-25 18:18:31 +02:00
@@ -22,7 +22,6 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/smp_lock.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
@@ -1639,8 +1638,6 @@
 	int rtn;
 	DECLARE_MUTEX_LOCKED(sem);
 
-	lock_kernel();
-
 	/*
 	 *    Flush resources
 	 */
@@ -1651,8 +1648,6 @@
 
 	shost->eh_wait = &sem;
 	shost->ehandler = current;
-
-	unlock_kernel();
 
 	/*
 	 * Wake up the thread that created us.
