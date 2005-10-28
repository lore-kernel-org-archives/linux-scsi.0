From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] remove Scsi_Host.eh_active
Date: Sat, 29 Oct 2005 01:02:43 +0200
Message-ID: <20051028230242.GB13083@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:22711 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1750700AbVJ1XCp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 19:02:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

now that the abuse in qla2xxx is gone this field can be remove.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c	2005-10-22 13:33:15.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_error.c	2005-10-24 22:29:31.000000000 +0200
@@ -1613,8 +1613,6 @@
 			printk("Error handler scsi_eh_%d waking up\n",
 				shost->host_no));
 
-		shost->eh_active = 1;
-
 		/*
 		 * We have a host that is failing for some reason.  Figure out
 		 * what we need to do to get it up and online again (if we can).
@@ -1625,8 +1623,6 @@
 		else
 			scsi_unjam_host(shost);
 
-		shost->eh_active = 0;
-
 		/*
 		 * Note - if the above fails completely, the action is to take
 		 * individual devices offline and flush the queue of any
Index: linux-2.6/include/scsi/scsi_host.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_host.h	2005-09-20 23:58:44.000000000 +0200
+++ linux-2.6/include/scsi/scsi_host.h	2005-10-24 22:29:31.000000000 +0200
@@ -469,8 +469,6 @@
 	struct task_struct    * ehandler;  /* Error recovery thread. */
 	struct semaphore      * eh_action; /* Wait for specific actions on the
                                           host. */
-	unsigned int            eh_active:1; /* Indicates the eh thread is awake and active if
-                                          this is true. */
 	wait_queue_head_t       host_wait;
 	struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
