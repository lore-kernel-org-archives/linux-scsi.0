From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] proper scsi_devicelist handling
Date: Sun, 3 Nov 2002 22:04:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021103220414.A8156@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Factor out code calling methods of all device template on a scsi_device
out to three helper functions in scsi.c, make scsi_devicelist static to
it and add a r/w semaphore to protect it.

Make scsi_host_list and scsi_host_hn_list static to hosts.c and remove
the never used scsi_host_tmpl_list (we only add to it and remove from
it but never traverse it)


--- 1.20/drivers/scsi/hosts.c	Mon Oct 28 19:27:35 2002
+++ edited/drivers/scsi/hosts.c	Sun Nov  3 18:48:14 2002
@@ -45,13 +45,9 @@
 #include "scsi.h"
 #include "hosts.h"
 
-LIST_HEAD(scsi_host_tmpl_list);
-LIST_HEAD(scsi_host_hn_list);
-
-LIST_HEAD(scsi_host_list);
-spinlock_t scsi_host_list_lock = SPIN_LOCK_UNLOCKED;
-
-struct Scsi_Device_Template * scsi_devicelist;
+static LIST_HEAD(scsi_host_hn_list);
+static LIST_HEAD(scsi_host_list);
+static spinlock_t scsi_host_list_lock = SPIN_LOCK_UNLOCKED;
 
 static int scsi_host_next_hn;		/* host_no for next new host */
 static int scsi_hosts_registered;	/* cnt of registered scsi hosts */
@@ -115,7 +111,6 @@
 {
 	int pcount;
 	Scsi_Device *sdev;
-	struct Scsi_Device_Template *sdev_tp;
 	Scsi_Cmnd *scmd;
 
 	/*
@@ -175,10 +170,7 @@
 	 * structures
 	 */
 	for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
-		for (sdev_tp = scsi_devicelist; sdev_tp;
-		     sdev_tp = sdev_tp->next)
-			if (sdev_tp->detach)
-				(*sdev_tp->detach) (sdev);
+		scsi_detach_device(sdev);
 
 		/* If something still attached, punt */
 		if (sdev->attached) {
@@ -471,12 +463,9 @@
 {
 	int cur_cnt;
 	Scsi_Device *sdev;
-	struct Scsi_Device_Template *sdev_tp;
 	struct list_head *lh;
 	struct Scsi_Host *shost;
 
-	INIT_LIST_HEAD(&shost_tp->shtp_list);
-
 	/*
 	 * Check no detect routine.
 	 */
@@ -526,8 +515,6 @@
 			}
 		}
 
-		list_add_tail(&shost_tp->shtp_list, &scsi_host_tmpl_list);
-
 		/* The next step is to call scan_scsis here.  This generates the
 		 * Scsi_Devices entries
 		 */
@@ -549,31 +536,15 @@
 			}
 		}
 
-		for (sdev_tp = scsi_devicelist; sdev_tp;
-		     sdev_tp = sdev_tp->next) {
-			if (sdev_tp->init && sdev_tp->dev_noticed)
-				(*sdev_tp->init) ();
-		}
-
 		/*
 		 * Next we create the Scsi_Cmnd structures for this host 
 		 */
 		list_for_each(lh, &scsi_host_list) {
 			shost = list_entry(lh, struct Scsi_Host, sh_list);
 			for (sdev = shost->host_queue; sdev; sdev = sdev->next)
-				if (sdev->host->hostt == shost_tp) {
-					scsi_build_commandblocks(sdev);
-					if (sdev->current_queue_depth == 0)
+				if (sdev->host->hostt == shost_tp)
+					if (scsi_attach_device(sdev))
 						goto out_of_space;
-					for (sdev_tp = scsi_devicelist;
-					     sdev_tp;
-					     sdev_tp = sdev_tp->next)
-						if (sdev_tp->attach)
-							(*sdev_tp->attach) (sdev);
-					if (!sdev->attached) {
-                                                scsi_release_commandblocks(sdev);
-					}
-				}
 		}
 	}
 
@@ -613,14 +584,6 @@
 	if (pcount != scsi_hosts_registered)
 		printk(KERN_INFO "scsi : %d host%s left.\n", scsi_hosts_registered,
 		       (scsi_hosts_registered == 1) ? "" : "s");
-
-	/*
-	 * Remove it from the list if all
-	 * hosts were successfully removed (ie preset == 0)
-	 */
-	if (!shost_tp->present) {
-		list_del(&shost_tp->shtp_list);
-	}
 
 	MOD_DEC_USE_COUNT;
 
--- 1.27/drivers/scsi/hosts.h	Fri Nov  1 15:42:44 2002
+++ edited/drivers/scsi/hosts.h	Sun Nov  3 18:41:44 2002
@@ -57,9 +57,6 @@
 
 typedef struct	SHT
 {
-
-    struct list_head	shtp_list;
-
     /* Used with loadable modules so that we know when it is safe to unload */
     struct module * module;
 
@@ -520,8 +517,6 @@
 	unsigned short host_registered;
 } Scsi_Host_Name;
 	
-extern struct Scsi_Device_Template * scsi_devicelist;
-
 extern void scsi_proc_host_mkdir(Scsi_Host_Template *);
 extern void scsi_proc_host_add(struct Scsi_Host *);
 extern void scsi_proc_host_rm(struct Scsi_Host *);
--- 1.52/drivers/scsi/scsi.c	Fri Nov  1 07:28:17 2002
+++ edited/drivers/scsi/scsi.c	Sun Nov  3 18:55:01 2002
@@ -133,6 +133,12 @@
 static struct softscsi_data softscsi_data[NR_CPUS] __cacheline_aligned;
 
 /*
+ * List of all highlevel drivers.
+ */
+static struct Scsi_Device_Template *scsi_devicelist;
+static DECLARE_RWSEM(scsi_devicelist_mutex);
+
+/*
  * Note - the initial logging level can be set here to log events at boot time.
  * After the system is up, you may enable logging via the /proc interface.
  */
@@ -1718,7 +1724,6 @@
 static int proc_scsi_gen_write(struct file * file, const char * buf,
                               unsigned long length, void *data)
 {
-	struct Scsi_Device_Template *SDTpnt;
 	Scsi_Device *scd;
 	struct Scsi_Host *HBA_ptr;
 	char *p;
@@ -1924,12 +1929,7 @@
 		if (scd->access_count)
 			goto out;
 
-		SDTpnt = scsi_devicelist;
-		while (SDTpnt != NULL) {
-			if (SDTpnt->detach)
-				(*SDTpnt->detach) (scd);
-			SDTpnt = SDTpnt->next;
-		}
+		scsi_detach_device(scd);
 
 		if (scd->attached == 0) {
 			/*
@@ -1969,6 +1969,56 @@
 }
 #endif
 
+void scsi_detect_device(struct scsi_device *sdev)
+{
+	struct Scsi_Device_Template *sdt;
+
+	down_read(&scsi_devicelist_mutex);
+	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
+		if (sdt->detect)
+			sdev->attached += (*sdt->detect)(sdev);
+	up_read(&scsi_devicelist_mutex);
+}
+
+int scsi_attach_device(struct scsi_device *sdev)
+{
+	struct Scsi_Device_Template *sdt;
+
+	scsi_build_commandblocks(sdev);
+	if (sdev->current_queue_depth == 0)
+		goto fail;
+
+	down_read(&scsi_devicelist_mutex);
+	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
+		if (sdt->init && sdt->dev_noticed)
+			(*sdt->init) ();
+	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
+		if (sdt->attach)
+			(*sdt->attach) (sdev);
+	up_read(&scsi_devicelist_mutex);
+
+	if (!sdev->attached)
+		scsi_release_commandblocks(sdev);
+	return 0;
+
+fail:
+	printk(KERN_ERR "%s: Allocation failure during SCSI scanning, "
+			"some SCSI devices might not be configured\n",
+			__FUNCTION__);
+	return -ENOMEM;
+}
+
+void scsi_detach_device(struct scsi_device *sdev)
+{
+	struct Scsi_Device_Template *sdt;
+
+	down_read(&scsi_devicelist_mutex);
+	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
+		if (sdt->detach)
+			(*sdt->detach)(sdev);
+	up_read(&scsi_devicelist_mutex);
+}
+
 /*
  * This entry point should be called by a loadable module if it is trying
  * add a high level scsi driver to the system.
@@ -1987,8 +2037,10 @@
 	if (tpnt->next)
 		return 1;
 
+	down_write(&scsi_devicelist_mutex);
 	tpnt->next = scsi_devicelist;
 	scsi_devicelist = tpnt;
+	up_write(&scsi_devicelist_mutex);
 
 	tpnt->scsi_driverfs_driver.name = (char *)tpnt->tag;
 	tpnt->scsi_driverfs_driver.bus = &scsi_driverfs_bus_type;
@@ -2094,6 +2146,7 @@
 	/*
 	 * Extract the template from the linked list.
 	 */
+	down_write(&scsi_devicelist_mutex);
 	spnt = scsi_devicelist;
 	prev_spnt = NULL;
 	while (spnt != tpnt) {
@@ -2104,6 +2157,7 @@
 		scsi_devicelist = tpnt->next;
 	else
 		prev_spnt->next = spnt->next;
+	up_write(&scsi_devicelist_mutex);
 
 	MOD_DEC_USE_COUNT;
 	unlock_kernel();
--- 1.31/drivers/scsi/scsi.h	Sat Oct 26 18:39:02 2002
+++ edited/drivers/scsi/scsi.h	Sun Nov  3 18:39:51 2002
@@ -481,6 +481,9 @@
 			int timeout, int retries);
 extern int scsi_dev_init(void);
 extern int scsi_mlqueue_insert(struct scsi_cmnd *, int);
+extern void scsi_detect_device(struct scsi_device *);
+extern int scsi_attach_device(struct scsi_device *);
+extern void scsi_detach_device(struct scsi_device *);
 
 /*
  * Newer request-based interfaces.
--- 1.31/drivers/scsi/scsi_scan.c	Wed Oct 23 13:04:01 2002
+++ edited/drivers/scsi/scsi_scan.c	Sun Nov  3 18:48:33 2002
@@ -1322,7 +1322,6 @@
 			Scsi_Request *sreq, char *inq_result, int *bflags)
 {
 	Scsi_Device *sdev;
-	struct Scsi_Device_Template *sdt;
 	char devname[64];
 	extern devfs_handle_t scsi_devfs_handle;
 
@@ -1479,9 +1478,7 @@
 	 * function */
 	sdev->max_device_blocked = SCSI_DEFAULT_DEVICE_BLOCKED;
 
-	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
-		if (sdt->detect)
-			sdev->attached += (*sdt->detect) (sdev);
+	scsi_detect_device(sdev);
 
 	if (sdev->host->hostt->slave_attach != NULL) {
 		if (sdev->host->hostt->slave_attach(sdev) != 0) {
@@ -2010,7 +2007,6 @@
 				   uint id, uint lun)
 {
 	Scsi_Device *sdevscan, *sdev = NULL;
-	struct Scsi_Device_Template *sdt;
 	int res;
 
 	if ((channel > shost->max_channel) || (id >= shost->max_id) ||
@@ -2028,24 +2024,7 @@
 	if (res != SCSI_SCAN_LUN_PRESENT) 
 		return;
 
-	BUG_ON(sdev == NULL);
-
-	scsi_build_commandblocks(sdev);
-	if (sdev->current_queue_depth == 0) {
-		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
-		return;
-	}
-
-	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
-		if (sdt->init && sdt->dev_noticed)
-			(*sdt->init) ();
-
-	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
-		if (sdt->attach)
-			(*sdt->attach) (sdev);
-
-	if (!sdev->attached)
-		scsi_release_commandblocks(sdev);
+	scsi_attach_device(sdev);
 }
 
 /**
--- 1.15/drivers/scsi/scsi_syms.c	Tue Oct 29 05:58:39 2002
+++ edited/drivers/scsi/scsi_syms.c	Sun Nov  3 18:36:05 2002
@@ -92,7 +92,6 @@
 EXPORT_SYMBOL(scsi_host_get_next);
 EXPORT_SYMBOL(scsi_host_hn_get);
 EXPORT_SYMBOL(scsi_host_put);
-EXPORT_SYMBOL(scsi_devicelist);
 EXPORT_SYMBOL(scsi_device_types);
 
 /*
