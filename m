From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] LDM-based scsi host lookup
Date: Tue, 27 May 2003 13:25:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030527112550.GB13798@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:23216 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263246AbTE0LMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 07:12:39 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Replace scsi_host_hn_get with scsi_host_lookup that walks
through the shost class and gets a proper reference to the
host.  This should fix the OOPS that Douglas saw last week.


--- 1.67/drivers/scsi/hosts.c	Mon May 26 14:17:48 2003
+++ edited/drivers/scsi/hosts.c	Mon May 26 15:06:44 2003
@@ -522,16 +522,33 @@
 }
 
 /**
- * scsi_host_hn_get - get a Scsi_Host by host no and inc ref count
- * @host_no:	host number to locate
- *
- * Return value:
- * 	A pointer to located Scsi_Host or NULL.
- **/
-struct Scsi_Host *scsi_host_hn_get(unsigned short host_no)
+ * scsi_host_lookup - get a reference to a Scsi_Host by host no
+ *
+ * @hostnum:	host number to locate
+ *
+ * Return value:
+ *	A pointer to located Scsi_Host or NULL.
+ **/
+struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
 {
-	/* XXX Inc ref count */
-	return scsi_find_host_by_num(host_no);
+	struct class *class = class_get(&shost_class);
+	struct class_device *cdev;
+	struct Scsi_Host *shost = NULL, *p;
+
+	if (class) {
+		down_read(&class->subsys.rwsem);
+		list_for_each_entry(cdev, &class->children, node) {
+			p = class_to_shost(cdev);
+			if (p->host_no == hostnum) {
+				scsi_host_get(p);
+				shost = p;
+				break;
+			}
+		}
+		up_read(&class->subsys.rwsem);
+	}
+
+	return shost;
 }
 
 /**
@@ -540,10 +557,8 @@
  **/
 void scsi_host_get(struct Scsi_Host *shost)
 {
-
 	get_device(&shost->host_gendev);
 	class_device_get(&shost->class_dev);
-	return;
 }
 
 /**
@@ -555,7 +570,6 @@
 
 	class_device_put(&shost->class_dev);
 	put_device(&shost->host_gendev);
-	return;
 }
 
 /**
===== drivers/scsi/scsi_priv.h 1.9 vs edited =====
--- 1.9/drivers/scsi/scsi_priv.h	Mon May 26 14:17:48 2003
+++ edited/drivers/scsi/scsi_priv.h	Mon May 26 15:06:30 2003
@@ -56,7 +56,7 @@
 extern void scsi_host_busy_inc(struct Scsi_Host *, Scsi_Device *);
 extern void scsi_host_busy_dec_and_test(struct Scsi_Host *, Scsi_Device *);
 extern struct Scsi_Host *scsi_host_get_next(struct Scsi_Host *);
-extern struct Scsi_Host *scsi_host_hn_get(unsigned short);
+extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 extern void scsi_host_put(struct Scsi_Host *);
 extern void scsi_host_init(void);
 
@@ -128,5 +128,7 @@
  * class and device attributes */
 extern struct class_device_attribute *scsi_sysfs_shost_attrs[];
 extern struct device_attribute *scsi_sysfs_sdev_attrs[];
+
+extern struct class shost_class;
 
 #endif /* _SCSI_PRIV_H */
--- 1.23/drivers/scsi/scsi_proc.c	Mon May 12 16:26:15 2003
+++ edited/drivers/scsi/scsi_proc.c	Mon May 26 15:07:09 2003
@@ -250,7 +214,7 @@
 	struct scsi_device *sdev;
 	int error = -ENODEV;
 
-	shost = scsi_host_hn_get(host);
+	shost = scsi_host_lookup(host);
 	if (!shost)
 		return -ENODEV;
 
@@ -272,7 +236,7 @@
 	struct Scsi_Host *shost;
 	int error = -ENODEV;
 
-	shost = scsi_host_hn_get(host);
+	shost = scsi_host_lookup(host);
 	if (!shost)
 		return -ENODEV;
 	sdev = scsi_find_device(shost, channel, id, lun);
--- 1.19/drivers/scsi/scsi_sysfs.c	Mon May 26 14:17:48 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Mon May 26 15:06:07 2003
@@ -54,7 +54,7 @@
 	NULL
 };
 
-static struct class shost_class = {
+struct class shost_class = {
 	.name		= "scsi_host",
 };
 
