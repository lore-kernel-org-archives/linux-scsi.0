From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: cciss kexec reset_devices commit
Date: Thu, 26 Feb 2009 16:10:18 -0800
Message-ID: <49A72F6A.3000904@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:18164 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbZB0AJM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Feb 2009 19:09:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Mike Miller <mike.miller@hp.com>

Was commit 5e4c91c84b194b26cf592779e451f4b5be777cba supposed to remove
the unconditional 30-second delay and replace it with a timeout loop?

What I see now (in source code) is the 30-second delay followed by
30 1-second retries...???


 		schedule_timeout_uninterruptible(30*HZ);
 
 		/* Now try to get the controller to respond to a no-op */
-		for (i=0; i<12; i++) {
+		for (i=0; i<30; i++) {
 			if (cciss_noop(pdev) == 0)
 				break;
-			else
-				printk("cciss: no-op failed%s\n", (i < 11 ? "; re-trying" : ""));
+
+			schedule_timeout_uninterruptible(HZ);
+		}
+		if (i == 30) {
+			printk(KERN_ERR "cciss: controller seems dead\n");
+			return -EBUSY;
 		}
 	}

-- 
~Randy
