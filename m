From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as84) Fix a mistake in scsi_proc.c
Date: Fri, 26 Sep 2003 12:03:23 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309261200140.5938-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:8452 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262069AbTIZQDY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 12:03:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

I tried sending this patch to Mike Anderson a couple of times, but never
got any response.  It's an obvious fix for a mistake in a section of code
I sent to him last spring: an error path fails to release a mutex.

If you don't see anything wrong here, please apply it.

Alan Stern


===== scsi_proc.c 1.16 vs edited =====
--- 1.16/drivers/scsi/scsi_proc.c	Thu Aug 14 18:37:32 2003
+++ edited/drivers/scsi/scsi_proc.c	Fri Aug 15 15:40:28 2003
@@ -85,12 +85,11 @@
 	down(&global_host_template_sem);
 	if (!sht->present++) {
 		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
-        	if (!sht->proc_dir) {
+        	if (!sht->proc_dir)
 			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
 			       __FUNCTION__, sht->proc_name);
-			return;
-		}
-		sht->proc_dir->owner = sht->module;
+		else
+			sht->proc_dir->owner = sht->module;
 	}
 	up(&global_host_template_sem);
 }

