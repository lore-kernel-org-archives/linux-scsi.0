From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove sleep_on_timeout usage in megaraid
Date: Mon, 31 May 2004 11:13:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040531091343.GB13982@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:61865 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264386AbUEaJOR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2004 05:14:17 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, atulm@lsil.com
Cc: linux-scsi@vger.kernel.org

megaraid does sleep_on_timeout on a stack waitq - use msleep instead.


--- 1.64/drivers/scsi/megaraid.c	2004-05-11 01:10:42 +02:00
+++ edited/drivers/scsi/megaraid.c	2004-05-30 15:04:14 +02:00
@@ -4068,7 +4068,6 @@
 static int
 mega_del_logdrv(adapter_t *adapter, int logdrv)
 {
-	DECLARE_WAIT_QUEUE_HEAD(wq);
 	unsigned long flags;
 	scb_t *scb;
 	int rval;
@@ -4083,11 +4082,9 @@
 	 * Wait till all the issued commands are complete and there are no
 	 * commands in the pending queue
 	 */
-	while( atomic_read(&adapter->pend_cmds) > 0 ||
-			!list_empty(&adapter->pending_list) ) {
-
-		sleep_on_timeout( &wq, 1*HZ );	/* sleep for 1s */
-	}
+	while (atomic_read(&adapter->pend_cmds) > 0 ||
+	       !list_empty(&adapter->pending_list))
+		msleep(1000);	/* sleep for 1s */
 
 	rval = mega_do_del_logdrv(adapter, logdrv);
 
