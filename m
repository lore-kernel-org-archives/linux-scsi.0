From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] add more scsi_device sysfs attributes
Date: Tue, 3 Dec 2002 15:57:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021203155743.A10834@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from northrelay03.pok.ibm.com (northrelay03.pok.ibm.com [9.56.224.151])
	by e4.ny.us.ibm.com (8.12.2/8.12.2) with ESMTP id gB3Nx08g162346
	for <linux-scsi@vger.kernel.org>; Tue, 3 Dec 2002 18:59:00 -0500
Received: from gateway1.beaverton.ibm.com (gateway1.beaverton.ibm.com [138.95.180.2])
	by northrelay03.pok.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id gB3NwwQP022842
	for <linux-scsi@vger.kernel.org>; Tue, 3 Dec 2002 18:58:58 -0500
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway1.beaverton.ibm.com (8.11.6/8.11.6) with ESMTP id gB3NrJV12611
	for <linux-scsi@vger.kernel.org>; Tue, 3 Dec 2002 15:53:19 -0800
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id gB3Nvh510966
	for linux-scsi@vger.kernel.org; Tue, 3 Dec 2002 15:57:43 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi -

This patch adds some scsi_device sysfs specific macros (based on some 
in the usb source), and adds more scsi_device sysfs attributes.

It modifies the current output of the "type" attribute to be 
the numeric value of the type, and adds a few other attributes.

It is easy to add or remove scsi_device attributes with this patch.

Example sysfs with this patch:

[patman@elm3a50 patman]$ ls /sysfs/bus/scsi/devices/0:0:0:0
0:0:0:0:gen   current_queue_depth  name             power  vendor
access_count  device_blocked       new_queue_depth  rev
block         model                online           type

And results of catting each file above (block and 0:0:0:0:gen are
not files):

/sysfs/bus/scsi/devices/0:0:0:0/access_count: '2'
/sysfs/bus/scsi/devices/0:0:0:0/current_queue_depth: '253'
/sysfs/bus/scsi/devices/0:0:0:0/device_blocked: '0'
/sysfs/bus/scsi/devices/0:0:0:0/model: 'ST318203LC    !#'
/sysfs/bus/scsi/devices/0:0:0:0/name: 'SIBM-PSG ST318203LC    !#LRA6701300007027J5ZL'
/sysfs/bus/scsi/devices/0:0:0:0/new_queue_depth: '253'
/sysfs/bus/scsi/devices/0:0:0:0/online: '1'
/sysfs/bus/scsi/devices/0:0:0:0/power: '0'
/sysfs/bus/scsi/devices/0:0:0:0/rev: 'B222'
/sysfs/bus/scsi/devices/0:0:0:0/type: '0'
/sysfs/bus/scsi/devices/0:0:0:0/vendor: 'IBM-PSG '

The online bit field is writable, although setting it to 0 is not useful.

--- 1.1/drivers/scsi/scsi_sysfs.c	Thu Nov 28 10:54:06 2002
+++ edited/drivers/scsi/scsi_sysfs.c	Tue Dec  3 08:53:21 2002
@@ -132,39 +132,115 @@
 }
 
 
-/**
- * scsi_device_type_read - copy out the SCSI type
- * @dev:		device to check
- * @page:		copy data into this area
- * @count:		number of bytes to copy
- * @off:		start at this offset in page
- *
- * Return:
- *     number of bytes written into page.
- **/
-static ssize_t scsi_device_type_read(struct device *dev, char *page,
-	size_t count, loff_t off)
-{
-	struct scsi_device *sdev = to_scsi_device(dev);
-	const char *type;
+/*
+ * show_function: macro to create an attr function that can be used to
+ * show a non-bit field.
+ */
+#define show_function(field, format_string)				\
+static ssize_t								\
+show_##field (struct device *dev, char *buf, size_t count, loff_t off)	\
+{									\
+	struct scsi_device *sdev;					\
+	if (off)							\
+		return 0;						\
+	sdev = to_scsi_device(dev);					\
+	return snprintf (buf, count, format_string, sdev->field);	\
+}									\
 
-	if (off)
-		return 0;
+/*
+ * sdev_rd_attr: macro to create a function and attribute variable for a
+ * read only field.
+ */
+#define sdev_rd_attr(field, format_string)				\
+	show_function(field, format_string)				\
+static DEVICE_ATTR(field, S_IRUGO, show_##field, NULL)
 
-	if ((sdev->type > MAX_SCSI_DEVICE_CODE) ||
-	    (scsi_device_types[(int)sdev->type] == NULL))
-		type = "Unknown";
-	else
-		type = scsi_device_types[(int)sdev->type];
 
-	return snprintf(page, count, "%s\n", type);
+/*
+ * sdev_rd_attr: create a function and attribute variable for a
+ * read/write field.
+ */
+#define sdev_rw_attr(field, format_string)				\
+	show_function(field, format_string)				\
+									\
+static ssize_t								\
+store_##field (struct device *dev, const char *buf, size_t count, loff_t off)\
+{									\
+	struct scsi_device *sdev;					\
+									\
+	if (off)							\
+		return 0;						\
+	sdev = to_scsi_device(dev);					\
+	return snscanf (buf, count, format_string, &sdev->field);	\
+}									\
+static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field, store_##field)
+
+/*
+ * sdev_rd_attr: create a function and attribute variable for a
+ * read/write bit field.
+ */
+#define sdev_rw_attr_bit(field)						\
+	show_function(field, "%d\n")					\
+									\
+static ssize_t								\
+store_##field (struct device *dev, const char *buf, size_t count, loff_t off)\
+{									\
+	int ret;							\
+	struct scsi_device *sdev;					\
+									\
+	if (off)							\
+		return 0;						\
+	ret = scsi_sdev_check_buf_bit(buf);				\
+	if (ret >= 0)	{						\
+		sdev = to_scsi_device(dev);				\
+		sdev->field = ret;					\
+		ret = count;						\
+	}								\
+	return ret;							\
+}									\
+static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field, store_##field)
+
+/*
+ * scsi_sdev_check_buf_bit: return 0 if buf is "0", return 1 if buf is "1",
+ * else return -EINVAL.
+ */
+static int scsi_sdev_check_buf_bit(const char *buf)
+{
+	if ((buf[1] == '\0') || ((buf[1] == '\n') && (buf[2] == '\0'))) {
+		if (buf[0] == '1')
+			return 1;
+		else if (buf[0] == '0')
+			return 0;
+		else 
+			return -EINVAL;
+	} else
+		return -EINVAL;
 }
 
 /*
- * Create dev_attr_type. This is different from the dev_attr_type in scsi
- * upper level drivers.
+ * Create the actual show/store functions and data structures.
  */
-static DEVICE_ATTR(type,S_IRUGO,scsi_device_type_read,NULL);
+sdev_rd_attr (device_blocked, "%d\n");
+sdev_rd_attr (current_queue_depth, "%d\n");
+sdev_rd_attr (new_queue_depth, "%d\n");
+sdev_rd_attr (type, "%d\n");
+sdev_rd_attr (access_count, "%d\n");
+sdev_rd_attr (vendor, "%.8s\n");
+sdev_rd_attr (model, "%.16s\n");
+sdev_rd_attr (rev, "%.4s\n");
+sdev_rw_attr_bit (online);
+
+static struct device_attribute * const sdev_attrs[] = {
+	&dev_attr_device_blocked,
+	&dev_attr_current_queue_depth,
+	&dev_attr_new_queue_depth,
+	&dev_attr_type,
+	&dev_attr_access_count,
+	&dev_attr_vendor,
+	&dev_attr_model,
+	&dev_attr_rev,
+	&dev_attr_online,
+};
 
 /**
  * scsi_device_register - register a scsi device with the scsi bus
@@ -175,7 +251,7 @@
  **/
 int scsi_device_register(struct scsi_device *sdev)
 {
-	int error = 0;
+	int error = 0, i;
 
 	sprintf(sdev->sdev_driverfs_dev.bus_id,"%d:%d:%d:%d",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
@@ -186,9 +262,12 @@
 	if (error)
 		return error;
 
-	error = device_create_file(&sdev->sdev_driverfs_dev, &dev_attr_type);
+	for (i = 0; !error && i < ARRAY_SIZE(sdev_attrs); i++)
+		error = device_create_file(&sdev->sdev_driverfs_dev,
+					   sdev_attrs[i]);
+
 	if (error)
-		device_unregister(&sdev->sdev_driverfs_dev);
+		scsi_device_unregister(sdev);
 
 	return error;
 }
@@ -199,6 +278,9 @@
  **/
 void scsi_device_unregister(struct scsi_device *sdev)
 {
-	device_remove_file(&sdev->sdev_driverfs_dev, &dev_attr_type);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sdev_attrs); i++)
+		device_remove_file(&sdev->sdev_driverfs_dev, sdev_attrs[i]);
 	device_unregister(&sdev->sdev_driverfs_dev);
 }
