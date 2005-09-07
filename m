From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] fix EH thread teardown
Date: Wed, 7 Sep 2005 15:51:05 +0200
Message-ID: <20050907135105.GA16340@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37280 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932144AbVIGNvQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 09:51:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

As Rolf Eike Beer noted we might not actually get to the
kthread_should_stop() because we are waiting in the semaphore forever.
I didn't get a rmmod hang because of this, but my instrumentation showed
the thread defitiyly didn't exit.

So make sure to wake the EH thread before the kthread_stop, and to plug
the reaming race check kthead_should_stop() a second time just before
calling down_interruptible().


Index: scsi-misc-2.6/drivers/scsi/hosts.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/hosts.c	2005-09-07 14:21:44.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/hosts.c	2005-09-07 14:22:33.000000000 +0200
@@ -226,8 +226,10 @@
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
-	if (shost->ehandler)
+	if (shost->ehandler) {
+		up(shost->eh_wait);
 		kthread_stop(shost->ehandler);
+	}
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
 
Index: scsi-misc-2.6/drivers/scsi/scsi_error.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_error.c	2005-09-07 14:21:44.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_error.c	2005-09-07 14:22:58.000000000 +0200
@@ -1591,7 +1591,7 @@
 	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent of"
 					  " scsi_eh_%d\n",shost->host_no));
 
-	while (1) {
+	while (!kthread_should_stop()) {
 		/*
 		 * If we get a signal, it means we are supposed to go
 		 * away and die.  This typically happens if the user is
