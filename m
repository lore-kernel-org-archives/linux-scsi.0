From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] handles possible failures in scsi initialization
Date: Thu, 20 Feb 2003 20:41:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030220204151.A19476@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

.. and unwind properly to avoid leaks


--- 1.91/drivers/scsi/scsi.c	Tue Feb 11 10:53:40 2003
+++ edited/drivers/scsi/scsi.c	Thu Feb 20 17:57:04 2003
@@ -1148,29 +1148,6 @@
 }
 
 /**
- * scsi_dev_list_init: set up the dynamic device list.
- * @dev_list:	string of device flags to add
- *
- * Description:
- * 	Add command line @dev_list entries, then add
- * 	scsi_static_device_list entries to the scsi device info list.
- **/
-static void scsi_dev_info_list_init (char *dev_list)
-{
-	int i;
-
-	if (scsi_dev_info_list_add_str(dev_list) == -ENOMEM)
-		return;
-	for (i = 0; scsi_static_device_list[i].vendor != NULL; i++)
-		if (scsi_dev_info_list_add(1 /* compatibile */,
-			   scsi_static_device_list[i].vendor,
-			   scsi_static_device_list[i].model,
-			   NULL,
-			   scsi_static_device_list[i].flags) == -ENOMEM)
-			return;
-}
-
-/**
  * scsi_dev_info_list_delete: called from scsi.c:exit_scsi to remove
  * 	the scsi_dev_info_list.
  **/
@@ -1187,6 +1164,37 @@
 }
 
 /**
+ * scsi_dev_list_init: set up the dynamic device list.
+ * @dev_list:	string of device flags to add
+ *
+ * Description:
+ * 	Add command line @dev_list entries, then add
+ * 	scsi_static_device_list entries to the scsi device info list.
+ **/
+static int scsi_dev_info_list_init (char *dev_list)
+{
+	int error, i;
+
+	error = scsi_dev_info_list_add_str(dev_list);
+	if (error)
+		return error;
+
+	for (i = 0; scsi_static_device_list[i].vendor != NULL; i++) {
+		error = scsi_dev_info_list_add(1 /* compatibile */,
+				scsi_static_device_list[i].vendor,
+				scsi_static_device_list[i].model,
+				NULL,
+				scsi_static_device_list[i].flags);
+		if (error)
+			break;
+	}
+
+	if (error)
+		scsi_dev_info_list_delete();
+	return error;
+}
+
+/**
  * get_device_flags - get device specific flags from the dynamic device
  * list. Called during scan time.
  * @vendor:	vendor name
@@ -1437,17 +1445,39 @@
 
 #endif
 
-/* FIXME(hch): add proper error handling */
 static int __init init_scsi(void)
 {
-	scsi_init_queue();
-	scsi_init_procfs();
-	devfs_mk_dir(NULL, "scsi", NULL);
+	int error;
+
+	error = scsi_init_queue();
+	if (error)
+		return error;
+	error = scsi_init_procfs();
+	if (error)
+		goto cleanup_queue;
+	error = -ENOMEM;
+	if (!devfs_mk_dir(NULL, "scsi", NULL))
+		goto cleanup_procfs;
+	error = scsi_dev_info_list_init(scsi_dev_flags);
+	if (error)
+		goto cleanup_devfs;
+	error = scsi_sysfs_register();
+	if (error)
+		goto cleanup_devlist;
+
 	scsi_host_init();
-	scsi_dev_info_list_init(scsi_dev_flags);
-	scsi_sysfs_register();
 	open_softirq(SCSI_SOFTIRQ, scsi_softirq, NULL);
 	return 0;
+
+cleanup_devlist:
+	scsi_dev_info_list_delete();
+cleanup_devfs:
+	devfs_remove("scsi");
+cleanup_procfs:
+	scsi_exit_procfs();
+cleanup_queue:
+	scsi_exit_queue();
+	return error;
 }
 
 static void __exit exit_scsi(void)
