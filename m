From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch] plug async scan race at 1st node scan
Date: Mon, 20 Aug 2007 09:10:35 -0400
Message-ID: <1187615436.3897.5.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:49513 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbXHTNKU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2007 09:10:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tore@linpro.no

In testing 2.6.23-rc3, there is a small window where the async-per-target
scan of the transport can beat the call from the LLDD to scsi_scan_host().
If so, the target scan starts, and can add the sdev (and the sysfslinks) before
the flags for async scan can prevent it. Thus, when async scan finishes and
asks for all sdevs to be enumerated -EEXIST errors will pop up.

This patch has scsi_alloc_host() look for the async scan hooks, and if they
exist, sets the async_scan flag to a pre-state, which still allows the async
target scan to continue, but stops the sysfs enumeration.


-- james s

This patch cut against 2.6.23-rc3 plus the following patch:
   http://marc.info/?l=linux-scsi&m=118289275414202&w=2

PS: there really should be better hooks for knowing if the driver expects
  async or background scanning (perhaps the whole pre-state should be set
  by the driver).

Signed-off-by: James Smart <James.Smart@emulex.com>



diff -upNr a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	2007-08-17 11:49:47.000000000 -0400
+++ b/drivers/scsi/hosts.c	2007-08-19 12:23:06.000000000 -0400
@@ -343,6 +343,12 @@ struct Scsi_Host *scsi_host_alloc(struct
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
 
+	if ((strncmp(scsi_scan_type, "async", 5) == 0) &&
+	    (shost->hostt->scan_finished))
+		shost->async_scan = ASYNC_SCAN_PREASYNC;
+	else
+		shost->async_scan = ASYNC_SCAN_CMPLT;
+
 	if (sht->max_host_blocked)
 		shost->max_host_blocked = sht->max_host_blocked;
 	else
diff -upNr a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	2007-07-08 19:32:17.000000000 -0400
+++ b/drivers/scsi/scsi_priv.h	2007-08-19 12:23:49.000000000 -0400
@@ -38,9 +38,6 @@ static inline void scsi_log_completion(s
 	{ };
 #endif
 
-/* scsi_scan.c */
-int scsi_complete_async_scans(void);
-
 /* scsi_devinfo.c */
 extern int scsi_get_device_flags(struct scsi_device *sdev,
 				 const unsigned char *vendor,
@@ -96,6 +93,8 @@ extern int scsi_scan_host_selected(struc
 				   unsigned int, unsigned int, int);
 extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_rescan_device(struct device *);
+extern char scsi_scan_type[];
+int scsi_complete_async_scans(void);
 
 /* scsi_sysctl.c */
 #ifdef CONFIG_SYSCTL
diff -upNr a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2007-08-19 12:21:10.000000000 -0400
+++ b/drivers/scsi/scsi_scan.c	2007-08-19 12:33:06.000000000 -0400
@@ -95,7 +95,7 @@ MODULE_PARM_DESC(max_luns,
 #define SCSI_SCAN_TYPE_DEFAULT "sync"
 #endif
 
-static char scsi_scan_type[6] = SCSI_SCAN_TYPE_DEFAULT;
+char scsi_scan_type[6] = SCSI_SCAN_TYPE_DEFAULT;
 
 module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S_IRUGO);
 MODULE_PARM_DESC(scan, "sync, async or none");
@@ -908,7 +908,7 @@ static int scsi_add_lun(struct scsi_devi
 	 * register it and tell the rest of the kernel
 	 * about it.
 	 */
-	if (!async && scsi_sysfs_add_sdev(sdev) != 0)
+	if ((async == ASYNC_SCAN_CMPLT) && scsi_sysfs_add_sdev(sdev) != 0)
 		return SCSI_SCAN_NO_RESPONSE;
 
 	return SCSI_SCAN_LUN_PRESENT;
@@ -1472,7 +1472,7 @@ struct scsi_device *__scsi_add_device(st
 		return ERR_PTR(-ENOMEM);
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
+	if (shost->async_scan == ASYNC_SCAN_CMPLT)
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost))
@@ -1588,7 +1588,7 @@ void scsi_scan_target(struct device *par
 		return;
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
+	if (shost->async_scan == ASYNC_SCAN_CMPLT)
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost))
@@ -1641,7 +1641,7 @@ int scsi_scan_host_selected(struct Scsi_
 		return -EINVAL;
 
 	mutex_lock(&shost->scan_mutex);
-	if (!shost->async_scan)
+	if (shost->async_scan == ASYNC_SCAN_CMPLT)
 		scsi_complete_async_scans();
 
 	if (scsi_host_scan_allowed(shost)) {
@@ -1686,7 +1686,7 @@ static struct async_scan_data *scsi_prep
 	if (strncmp(scsi_scan_type, "sync", 4) == 0)
 		return NULL;
 
-	if (shost->async_scan) {
+	if (shost->async_scan == ASYNC_SCAN_RUNNING) {
 		printk("%s called twice for host %d", __FUNCTION__,
 				shost->host_no);
 		dump_stack();
@@ -1703,7 +1703,7 @@ static struct async_scan_data *scsi_prep
 
 	mutex_lock(&shost->scan_mutex);
 	spin_lock_irqsave(shost->host_lock, flags);
-	shost->async_scan = 1;
+	shost->async_scan = ASYNC_SCAN_RUNNING;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	mutex_unlock(&shost->scan_mutex);
 
@@ -1740,9 +1740,13 @@ static void scsi_finish_async_scan(struc
 
 	mutex_lock(&shost->scan_mutex);
 
-	if (!shost->async_scan) {
-		printk("%s called twice for host %d", __FUNCTION__,
+	if (shost->async_scan != ASYNC_SCAN_RUNNING) {
+		if (shost->async_scan == ASYNC_SCAN_CMPLT)
+			printk("%s called twice for host %d", __FUNCTION__,
 				shost->host_no);
+		else /* shost->async_scan == ASYNC_SCAN_PREASYNC */
+			printk("%s called prior to async scan %d", 
+				__FUNCTION__, shost->host_no);
 		dump_stack();
 		return;
 	}
@@ -1752,7 +1756,7 @@ static void scsi_finish_async_scan(struc
 	scsi_sysfs_add_devices(shost);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	shost->async_scan = 0;
+	shost->async_scan = ASYNC_SCAN_CMPLT;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	mutex_unlock(&shost->scan_mutex);
diff -upNr a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2007-08-17 11:49:56.000000000 -0400
+++ b/include/scsi/scsi_host.h	2007-08-19 12:24:28.000000000 -0400
@@ -603,7 +603,10 @@ struct Scsi_Host {
 	unsigned tmf_in_progress:1;
 
 	/* Asynchronous scan in progress */
-	unsigned async_scan:1;
+	unsigned async_scan:2;
+#define ASYNC_SCAN_CMPLT	0
+#define ASYNC_SCAN_RUNNING	1
+#define ASYNC_SCAN_PREASYNC	2
 
 	/*
 	 * Optional work queue to be utilized by the transport


