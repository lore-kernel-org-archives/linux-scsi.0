From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] use mod_timer in scsi_add_timer
Date: Sun, 31 Aug 2003 13:28:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030831112830.GA19502@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:20874 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261192AbTHaL2f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Aug 2003 07:28:35 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

del_timer / modify / add_timer is racy.  mod_timer on not active
timer is fine, though.

Note that eh_timeout handling looks fishy in more places, I'll
audit it.


--- 1.62/drivers/scsi/scsi_error.c	Mon Aug 25 15:37:40 2003
+++ edited/drivers/scsi/scsi_error.c	Thu Aug 28 23:04:57 2003
@@ -105,24 +105,13 @@
 void scsi_add_timer(struct scsi_cmnd *scmd, int timeout,
 		    void (*complete)(struct scsi_cmnd *))
 {
-
-	/*
-	 * If the clock was already running for this command, then
-	 * first delete the timer.  The timer handling code gets rather
-	 * confused if we don't do this.
-	 */
-	if (scmd->eh_timeout.function)
-		del_timer(&scmd->eh_timeout);
-
 	scmd->eh_timeout.data = (unsigned long)scmd;
-	scmd->eh_timeout.expires = jiffies + timeout;
 	scmd->eh_timeout.function = (void (*)(unsigned long)) complete;
+	mod_timer(&scmd->eh_timeout, jiffies + timeout);
 
 	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: scmd: %p, time:"
 					  " %d, (%p)\n", __FUNCTION__,
 					  scmd, timeout, complete));
-
-	add_timer(&scmd->eh_timeout);
 }
 
 /**
