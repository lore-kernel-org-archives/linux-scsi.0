From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as84) Small fixup for SCSI proc code
Date: Tue, 16 Sep 2003 10:50:57 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309161048340.1533-100000@ida.rowland.org>
References: <20030709144410.GA3544@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:6404 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261887AbTIPOu7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2003 10:50:59 -0400
In-Reply-To: <20030709144410.GA3544@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Mike:

The updated SCSI proc directory code that I sent you a few months ago has
a small mistake -- the error path fails to release a semaphore.  This
patch fixes it; please apply.

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

