From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] fix fc class work queue usage
Date: Fri, 25 Mar 2005 22:15:54 -0800
Message-ID: <4244FE1A.6010502@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020904060808020104090702"
Received: from sabe.cs.wisc.edu ([128.105.6.20]:6296 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261968AbVCZGPn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Mar 2005 01:15:43 -0500
Received: from [192.168.0.2] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j2Q6FfUt010157
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 26 Mar 2005 00:15:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020904060808020104090702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

According to this article http://lwn.net/Articles/125930/, "When
cancel_delayed_work() returns zero, it means that the delayed
work request was fired off before the call; it might, in fact,
be running on another CPU when the cancel attempt is made".
If it is successful, it returns a nonzero value. Tracing
through cancel_delayed_work's timer usage would seem to confirm
this. The fc class today though performs a flush_scheduled_work,
when the return value is nonzero instead of zero.

Also it appears the fc class will use flush_scheduled_work to
flush the work from the shost_work_q when it should be using
flush_workqueue(shost->work_q) (flush_scheduled_work() only
flushes the default, keventd_wq, work queue).

The attached patch adds a scsi_flush_work function for
scsi_transport_fc to use and it fixes the cancel_delayed_work()
test to detect when to flush the work queues correctly (it
also only calls cancel_delayed_work when the work is queued
as delayed (scan_work is not delayed). The patch has only been
compile tested since I am away from any FC HW for a while.

Signed-off-by: Mike Chrisite <michaelc@cs.wisc.edu>

--------------020904060808020104090702
Content-Type: text/x-patch;
 name="fix-scsi-wq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-scsi-wq.patch"

diff -aurp scsi-misc-2.6.orig/drivers/scsi/hosts.c scsi-misc-2.6.test/drivers/scsi/hosts.c
--- scsi-misc-2.6.orig/drivers/scsi/hosts.c	2005-03-25 21:34:30.000000000 -0800
+++ scsi-misc-2.6.test/drivers/scsi/hosts.c	2005-03-25 21:40:32.000000000 -0800
@@ -443,3 +443,20 @@ int scsi_queue_work(struct Scsi_Host *sh
 }
 EXPORT_SYMBOL_GPL(scsi_queue_work);
 
+/**
+ * scsi_flush_work - Flush a Scsi_Host's workqueue.
+ * @shost:	Pointer to Scsi_Host.
+ **/
+void scsi_flush_work(struct Scsi_Host *shost)
+{
+	if (!shost->work_q) {
+		printk(KERN_ERR
+			"ERROR: Scsi host '%s' attempted to flush scsi-work, "
+			"when no workqueue created.\n", shost->hostt->name);
+		dump_stack();
+		return;
+	}
+
+	flush_workqueue(shost->work_q);
+}
+EXPORT_SYMBOL_GPL(scsi_flush_work);
diff -aurp scsi-misc-2.6.orig/drivers/scsi/scsi_transport_fc.c scsi-misc-2.6.test/drivers/scsi/scsi_transport_fc.c
--- scsi-misc-2.6.orig/drivers/scsi/scsi_transport_fc.c	2005-03-25 21:34:36.000000000 -0800
+++ scsi-misc-2.6.test/drivers/scsi/scsi_transport_fc.c	2005-03-25 21:53:36.000000000 -0800
@@ -1375,12 +1375,14 @@ EXPORT_SYMBOL(fc_remote_port_add);
 static void
 fc_rport_tgt_remove(struct fc_rport *rport)
 {
+	struct Scsi_Host *shost = rport_to_shost(rport);
+
 	scsi_target_unblock(&rport->dev);
 
 	/* Stop anything on the workq */
-	if (cancel_delayed_work(&rport->dev_loss_work) ||
-	    cancel_delayed_work(&rport->scan_work))
+	if (!cancel_delayed_work(&rport->dev_loss_work))
 		flush_scheduled_work();
+	scsi_flush_work(shost);
 
 	scsi_remove_target(&rport->dev);
 }
@@ -1625,7 +1627,7 @@ fc_remote_port_unblock(struct fc_rport *
 	 * failure as the state machine state change will validate the
 	 * transaction.
 	 */
-	if (cancel_delayed_work(work))
+	if (!cancel_delayed_work(work))
 		flush_scheduled_work();
 
 	if (rport->port_state == FC_PORTSTATE_OFFLINE)
diff -aurp scsi-misc-2.6.orig/include/scsi/scsi_host.h scsi-misc-2.6.test/include/scsi/scsi_host.h
--- scsi-misc-2.6.orig/include/scsi/scsi_host.h	2005-03-25 21:34:47.000000000 -0800
+++ scsi-misc-2.6.test/include/scsi/scsi_host.h	2005-03-25 21:25:06.000000000 -0800
@@ -590,6 +590,7 @@ static inline struct Scsi_Host *dev_to_s
 }
 
 extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
+extern void scsi_flush_work(struct Scsi_Host *);
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int __must_check scsi_add_host(struct Scsi_Host *, struct device *);

--------------020904060808020104090702--
