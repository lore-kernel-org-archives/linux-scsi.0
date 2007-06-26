From: Matthew Wilcox <matthew@wil.cx>
Subject: Fix async scanning double-add problems
Date: Tue, 26 Jun 2007 15:18:51 -0600
Message-ID: <20070626211851.GS22063@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50059 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbXFZVSx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2007 17:18:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>


Stress-testing and some thought has revealed some places where
asynchronous scanning needs some more attention to locking.

 - Since async_scan is a bit, we need to hold the host_lock while
   modifying it to prevent races against other CPUs modifying the word
   that bit is in.  This is probably a theoretical race for the moment,
   but other patches may change that.
 - The async_scan bit means not only that this host is being scanned
   asynchronously, but that all the devices attached to this host are not
   yet added to sysfs.  So we must ensure that this bit is always in sync.
   I've chosen to do this with the scan_mutex since it's already acquired
   in most of the right places.
 - If the host changes state to deleted while we're in the middle of
   a scan, we'll end up with some devices on the host's list which must
   be deleted.  Add a check to scsi_sysfs_add_devices() to ensure the
   host is still running.
 - To avoid the async_scan bit being protected by three locks, the
   async_scan_lock now only protects the scanning_list.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 662577f..7754ce7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -121,6 +121,7 @@ MODULE_PARM_DESC(inq_timeout,
 		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
 		 " Default is 5. Some non-compliant devices need more.");
 
+/* This lock protects only this list */
 static DEFINE_SPINLOCK(async_scan_lock);
 static LIST_HEAD(scanning_hosts);
 
@@ -1477,14 +1478,14 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return ERR_PTR(-ENODEV);
 
-	if (!shost->async_scan)
-		scsi_complete_async_scans();
-
 	starget = scsi_alloc_target(parent, channel, id);
 	if (!starget)
 		return ERR_PTR(-ENOMEM);
 
 	mutex_lock(&shost->scan_mutex);
+	if (!shost->async_scan)
+		scsi_complete_async_scans();
+
 	if (scsi_host_scan_allowed(shost))
 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 	mutex_unlock(&shost->scan_mutex);
@@ -1597,10 +1598,10 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return;
 
+	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
-	mutex_lock(&shost->scan_mutex);
 	if (scsi_host_scan_allowed(shost))
 		__scsi_scan_target(parent, channel, id, lun, rescan);
 	mutex_unlock(&shost->scan_mutex);
@@ -1645,15 +1646,15 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 		"%s: <%u:%u:%u>\n",
 		__FUNCTION__, channel, id, lun));
 
-	if (!shost->async_scan)
-		scsi_complete_async_scans();
-
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
 	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
 	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
 		return -EINVAL;
 
 	mutex_lock(&shost->scan_mutex);
+	if (!shost->async_scan)
+		scsi_complete_async_scans();
+
 	if (scsi_host_scan_allowed(shost)) {
 		if (channel == SCAN_WILD_CARD)
 			for (channel = 0; channel <= shost->max_channel;
@@ -1672,7 +1673,8 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
 	shost_for_each_device(sdev, shost) {
-		if (scsi_sysfs_add_sdev(sdev) != 0)
+		if (!scsi_host_scan_allowed(shost) ||
+		    scsi_sysfs_add_sdev(sdev) != 0)
 			scsi_destroy_sdev(sdev);
 	}
 }
@@ -1690,6 +1692,7 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 {
 	struct async_scan_data *data;
+	unsigned long flags;
 
 	if (strncmp(scsi_scan_type, "sync", 4) == 0)
 		return NULL;
@@ -1709,8 +1712,13 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		goto err;
 	init_completion(&data->prev_finished);
 
-	spin_lock(&async_scan_lock);
+	mutex_lock(&shost->scan_mutex);
+	spin_lock_irqsave(shost->host_lock, flags);
 	shost->async_scan = 1;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	mutex_unlock(&shost->scan_mutex);
+
+	spin_lock(&async_scan_lock);
 	if (list_empty(&scanning_hosts))
 		complete(&data->prev_finished);
 	list_add_tail(&data->list, &scanning_hosts);
@@ -1734,11 +1742,15 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 static void scsi_finish_async_scan(struct async_scan_data *data)
 {
 	struct Scsi_Host *shost;
+	unsigned long flags;
 
 	if (!data)
 		return;
 
 	shost = data->shost;
+
+	mutex_lock(&shost->scan_mutex);
+
 	if (!shost->async_scan) {
 		printk("%s called twice for host %d", __FUNCTION__,
 				shost->host_no);
@@ -1750,8 +1762,13 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 
 	scsi_sysfs_add_devices(shost);
 
-	spin_lock(&async_scan_lock);
+	spin_lock_irqsave(shost->host_lock, flags);
 	shost->async_scan = 0;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	mutex_unlock(&shost->scan_mutex);
+
+	spin_lock(&async_scan_lock);
 	list_del(&data->list);
 	if (!list_empty(&scanning_hosts)) {
 		struct async_scan_data *next = list_entry(scanning_hosts.next,
