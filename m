From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove __scsi_add_host
Date: Tue, 4 Feb 2003 17:58:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030204175854.A31621@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

now that scsi_add_host accepts a NMULL dev argument we don't need it
anymore.


--- 1.47/drivers/scsi/hosts.c	Tue Jan 28 17:19:33 2003
+++ edited/drivers/scsi/hosts.c	Tue Feb  4 16:27:21 2003
@@ -285,7 +285,15 @@
 	return 0;
 }
 
-int __scsi_add_host(struct Scsi_Host *shost)
+/**
+ * scsi_add_host - add a scsi host
+ * @shost:	scsi host pointer to add
+ * @dev:	a struct device of type scsi class
+ *
+ * Return value: 
+ * 	0 on success / != 0 for error
+ **/
+int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
 {
 	Scsi_Host_Template *sht = shost->hostt;
 	struct scsi_device *sdev;
@@ -294,6 +302,11 @@
 	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
 			sht->info ? sht->info(shost) : sht->name);
 
+	if (dev) {
+		dev->class_data = shost;
+		shost->host_gendev = dev;
+	}
+
 	scsi_scan_host(shost);
 			
 	list_for_each_entry (sdev, &shost->my_devices, siblings) {
@@ -306,23 +319,6 @@
 }
 
 /**
- * scsi_add_host - add a scsi host
- * @shost:	scsi host pointer to add
- * @dev:	a struct device of type scsi class
- *
- * Return value: 
- * 	0 on success / != 0 for error
- **/
-int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
-{
-	if (dev) {
-		dev->class_data = shost;
-		shost->host_gendev = dev;
-	}
-	return __scsi_add_host(shost);
-}
-
-/**
  * scsi_unregister - unregister a scsi host
  * @shost:	scsi host to be unregistered
  **/
@@ -523,7 +507,7 @@
 	 */
 	list_for_each_entry(shost, &scsi_host_list, sh_list)
 		if (shost->hostt == shost_tp)
-			if (__scsi_add_host(shost))
+			if (scsi_add_host(shost, NULL))
 				goto out_of_space;
 
 	return 0;
