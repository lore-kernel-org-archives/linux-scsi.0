From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] bug fix: SCSI async scan sysfs -EEXIST problem
Date: Mon, 07 May 2007 14:57:47 -0400
Message-ID: <1178564267.302.15.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:43098 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966205AbXEGS5a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 14:57:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@steeleye.com

This corrects the kobject_add -EEXIST failure reported in 
http://marc.info/?l=linux-scsi&m=117699334422336&w=2

Basically, there was a collision between async scsi scan's
scsi_sysfs_add_devices() and asynchronous scanning kicked off by the
fc transport's rport code.  Both called scsi_sysfs_add_sdev() for the
same sdev.

The problem was that async scsi scan's call did not hold the scan_mutex
when making the call to scsi_sysfs_add_sdev().  Additionally, looking at
the shost->async_scan flag, which is critical for whether the sdev gets
enumerated or not, many uses were fuzzy. As a bit flag, it should have
been under the scsi_host lock, but via the way it's used within
scsi_scan.c, it should have been under the scan_mutex. It was positioned
within the async scan semaphore, which didn't help anything. Key to its
change, is that is done prior to releasing the scan_mutex after around
the scsi_sysfs_add_sdev() calls.  To avoid all the lock repositioning,
I simply converted it to an atomic. A little overkill, but has the
coherency it needs.

Confirmed by Josef that it corrected his problems.

-- james s


Signed-off-by: James Smart <James.Smart@emulex.com>



diff -upNr a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2007-04-25 23:08:32.000000000 -0400
+++ b/drivers/scsi/scsi_scan.c	2007-05-04 18:35:58.000000000 -0400
@@ -1081,7 +1081,8 @@ static int scsi_probe_and_add_lun(struct
 		goto out_free_result;
 	}
 
-	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
+	res = scsi_add_lun(sdev, result, &bflags,
+				atomic_read(&shost->async_scan));
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
@@ -1470,7 +1471,7 @@ struct scsi_device *__scsi_add_device(st
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return ERR_PTR(-ENODEV);
 
-	if (!shost->async_scan)
+	if (!atomic_read(&shost->async_scan))
 		scsi_complete_async_scans();
 
 	starget = scsi_alloc_target(parent, channel, id);
@@ -1590,7 +1591,7 @@ void scsi_scan_target(struct device *par
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return;
 
-	if (!shost->async_scan)
+	if (!atomic_read(&shost->async_scan))
 		scsi_complete_async_scans();
 
 	mutex_lock(&shost->scan_mutex);
@@ -1638,7 +1639,7 @@ int scsi_scan_host_selected(struct Scsi_
 		"%s: <%u:%u:%u>\n",
 		__FUNCTION__, channel, id, lun));
 
-	if (!shost->async_scan)
+	if (!atomic_read(&shost->async_scan))
 		scsi_complete_async_scans();
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
@@ -1687,7 +1688,7 @@ static struct async_scan_data *scsi_prep
 	if (strncmp(scsi_scan_type, "sync", 4) == 0)
 		return NULL;
 
-	if (shost->async_scan) {
+	if (atomic_read(&shost->async_scan)) {
 		printk("%s called twice for host %d", __FUNCTION__,
 				shost->host_no);
 		dump_stack();
@@ -1702,8 +1703,9 @@ static struct async_scan_data *scsi_prep
 		goto err;
 	init_completion(&data->prev_finished);
 
+	atomic_set(&shost->async_scan, 1);
+
 	spin_lock(&async_scan_lock);
-	shost->async_scan = 1;
 	if (list_empty(&scanning_hosts))
 		complete(&data->prev_finished);
 	list_add_tail(&data->list, &scanning_hosts);
@@ -1732,7 +1734,7 @@ static void scsi_finish_async_scan(struc
 		return;
 
 	shost = data->shost;
-	if (!shost->async_scan) {
+	if (!atomic_read(&shost->async_scan)) {
 		printk("%s called twice for host %d", __FUNCTION__,
 				shost->host_no);
 		dump_stack();
@@ -1741,10 +1743,12 @@ static void scsi_finish_async_scan(struc
 
 	wait_for_completion(&data->prev_finished);
 
+	mutex_lock(&shost->scan_mutex);
 	scsi_sysfs_add_devices(shost);
+	atomic_set(&shost->async_scan, 0);
+	mutex_unlock(&shost->scan_mutex);
 
 	spin_lock(&async_scan_lock);
-	shost->async_scan = 0;
 	list_del(&data->list);
 	if (!list_empty(&scanning_hosts)) {
 		struct async_scan_data *next = list_entry(scanning_hosts.next,
diff -upNr a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2007-04-25 23:08:32.000000000 -0400
+++ b/include/scsi/scsi_host.h	2007-05-04 17:48:48.000000000 -0400
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <asm/atomic.h>
 
 struct request_queue;
 struct block_device;
@@ -605,7 +606,7 @@ struct Scsi_Host {
 	unsigned tmf_in_progress:1;
 
 	/* Asynchronous scan in progress */
-	unsigned async_scan:1;
+	atomic_t async_scan;
 
 	/*
 	 * Optional work queue to be utilized by the transport




