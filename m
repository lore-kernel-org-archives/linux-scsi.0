From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] handle failure when starting the eh thread
Date: Sun, 21 Sep 2003 18:44:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030921164442.GA7910@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:65168 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262456AbTIUQop (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Sep 2003 12:44:45 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

And while at it also fix the scsi_error_handler() prototype.


--- 1.91/drivers/scsi/hosts.c	Wed Sep  3 23:53:20 2003
+++ edited/drivers/scsi/hosts.c	Sun Sep 21 17:52:38 2003
@@ -262,7 +262,7 @@
 
 	rval = scsi_setup_command_freelist(shost);
 	if (rval)
-		goto fail;
+		goto fail_kfree;
 
 	device_initialize(&shost->shost_gendev);
 	snprintf(shost->shost_gendev.bus_id, BUS_ID_SIZE, "host%d",
@@ -276,13 +276,17 @@
 		  shost->host_no);
 
 	shost->eh_notify = &complete;
-	/* XXX(hch): handle error return */
-	kernel_thread((int (*)(void *))scsi_error_handler, shost, 0);
+	rval = kernel_thread(scsi_error_handler, shost, 0);
+	if (rval < 0)
+		goto fail_destroy_freelist;
 	wait_for_completion(&complete);
 	shost->eh_notify = NULL;
 	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
- fail:
+
+ fail_destroy_freelist:
+	scsi_destroy_command_freelist(shost);
+ fail_kfree:
 	kfree(shost);
 	return NULL;
 }
--- 1.63/drivers/scsi/scsi_error.c	Sat Sep 20 11:11:42 2003
+++ edited/drivers/scsi/scsi_error.c	Sun Sep 21 17:49:36 2003
@@ -1490,7 +1490,7 @@
  *    event (i.e. failure).  When this takes place, we have the job of
  *    trying to unjam the bus and restarting things.
  **/
-void scsi_error_handler(void *data)
+int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = (struct Scsi_Host *) data;
 	int rtn;
@@ -1594,6 +1594,7 @@
 	 * the way out the door.
 	 */
 	complete_and_exit(shost->eh_notify, 0);
+	return 0;
 }
 
 /*
--- 1.26/drivers/scsi/scsi_priv.h	Mon Aug 25 15:37:25 2003
+++ edited/drivers/scsi/scsi_priv.h	Sun Sep 21 17:49:44 2003
@@ -91,7 +91,7 @@
 
 /* scsi_error.c */
 extern void scsi_times_out(struct scsi_cmnd *cmd);
-extern void scsi_error_handler(void *host);
+extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
 extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
