From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Host drivers and conversion of SCSI to the driver model
Date: Mon, 23 Jun 2003 10:57:22 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0306231045060.1043-100000@ida.rowland.org>
References: <20030620210725.GB18449@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3332 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266060AbTFWOnQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 10:43:16 -0400
In-Reply-To: <20030620210725.GB18449@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 20 Jun 2003, Mike Anderson wrote:

> Alan Stern [stern@rowland.harvard.edu] wrote:
> > 
> > Mike:
> > 
> > What does the future for this progression look like?  Will there be some
> > standard place under /sys/class/scsi??? where a host driver like
> > usb-storage can register its class device?
> 
> Did you need your own class device or can you use the shost_attrs
> capability that James added?

The shost_attrs stuff looks fine, expect for two points.

	1. The scsi_sysfs_modify_shost_attribute() and 
scsi_sysfs_modify_sdev_attribute() functions appear to be written a bit 
carelessly.  Below is a patch that: permits modification of the first 
attribute in the list, allocates a new list with entries having the 
correct size, copies the correct number of entries from the old list, and 
wraps excessively long source lines.

	2. More importantly, the current organization of the code has a
serious problem.  The SCSI core does not modify the host driver when the
reference count for either shost->class_dev or shost->host_gendev drops to
0.  Without knowing that, it is unsafe for the driver ever to deallocate a
private host data structure, since a user process may continue to hold a 
reference to an open attribute file indefinitely, even after 
scsi_unregister() has returned.

Alan Stern


===== scsi_sysfs.c 1.12 vs edited =====
--- 1.12/drivers/scsi/scsi_sysfs.c	Mon Jun  9 13:37:14 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Mon Jun 23 10:43:49 2003
@@ -388,30 +388,36 @@
  *
  * returns zero if successful or error if not
  **/
-int scsi_sysfs_modify_shost_attribute(struct class_device_attribute ***class_attrs,
-				      struct class_device_attribute *attr)
+int scsi_sysfs_modify_shost_attribute(
+			struct class_device_attribute ***class_attrs,
+			struct class_device_attribute *attr)
 {
-	int modify = 0;
+	int modify = -1;
 	int num_attrs;
 
 	if(*class_attrs == NULL)
 		*class_attrs = scsi_sysfs_shost_attrs;
 
 	for(num_attrs=0; (*class_attrs)[num_attrs] != NULL; num_attrs++)
-		if(strcmp((*class_attrs)[num_attrs]->attr.name, attr->attr.name) == 0)
+		if(strcmp((*class_attrs)[num_attrs]->attr.name,
+				attr->attr.name) == 0)
 			modify = num_attrs;
 
-	if(*class_attrs == scsi_sysfs_shost_attrs || !modify) {
+	if(*class_attrs == scsi_sysfs_shost_attrs || modify < 0) {
 		/* note: need space for null at the end as well */
-		struct class_device_attribute **tmp_attrs = kmalloc(sizeof(struct class_device_attribute)*(num_attrs + (modify ? 1 : 2)), GFP_KERNEL);
+		struct class_device_attribute **tmp_attrs =
+				kmalloc(sizeof(*tmp_attrs) *
+					  (num_attrs + (modify >= 0 ? 1 : 2)),
+					GFP_KERNEL);
 		if(tmp_attrs == NULL)
 			return -ENOMEM;
-		memcpy(tmp_attrs, *class_attrs, sizeof(struct class_device_attribute)*num_attrs);
+		memcpy(tmp_attrs, *class_attrs, sizeof(*tmp_attrs) *
+				(num_attrs + 1));
 		if(*class_attrs != scsi_sysfs_shost_attrs)
 			kfree(*class_attrs);
 		*class_attrs = tmp_attrs;
 	}
-	if(modify) {
+	if(modify >= 0) {
 		/* spare the caller from having to copy things it's
 		 * not interested in */
 		struct class_device_attribute *old_attr =
@@ -444,27 +450,32 @@
 int scsi_sysfs_modify_sdev_attribute(struct device_attribute ***dev_attrs,
 				     struct device_attribute *attr)
 {
-	int modify = 0;
+	int modify = -1;
 	int num_attrs;
 
 	if(*dev_attrs == NULL)
 		*dev_attrs = scsi_sysfs_sdev_attrs;
 
 	for(num_attrs=0; (*dev_attrs)[num_attrs] != NULL; num_attrs++)
-		if(strcmp((*dev_attrs)[num_attrs]->attr.name, attr->attr.name) == 0)
+		if(strcmp((*dev_attrs)[num_attrs]->attr.name,
+				attr->attr.name) == 0)
 			modify = num_attrs;
 
-	if(*dev_attrs == scsi_sysfs_sdev_attrs || !modify) {
+	if(*dev_attrs == scsi_sysfs_sdev_attrs || modify < 0) {
 		/* note: need space for null at the end as well */
-		struct device_attribute **tmp_attrs = kmalloc(sizeof(struct device_attribute)*(num_attrs + (modify ? 1 : 2)), GFP_KERNEL);
+		struct device_attribute **tmp_attrs =
+				kmalloc(sizeof(*tmp_attrs) *
+					  (num_attrs + (modify >= 0 ? 1 : 2)),
+					GFP_KERNEL);
 		if(tmp_attrs == NULL)
 			return -ENOMEM;
-		memcpy(tmp_attrs, *dev_attrs, sizeof(struct device_attribute)*num_attrs);
+		memcpy(tmp_attrs, *dev_attrs, sizeof(*tmp_attrs) *
+				(num_attrs + 1));
 		if(*dev_attrs != scsi_sysfs_sdev_attrs)
 			kfree(*dev_attrs);
 		*dev_attrs = tmp_attrs;
 	}
-	if(modify) {
+	if(modify >= 0) {
 		/* spare the caller from having to copy things it's
 		 * not interested in */
 		struct device_attribute *old_attr =

