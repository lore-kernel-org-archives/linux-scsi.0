From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] move over exposing host attributes from sg/procfs to sysfs
Date: Fri, 21 Feb 2003 23:49:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030221234953.A30941@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, dougg@torque.net
Cc: linux-scsi@vger.kernel.org

This patch moves over printing of the various struct Scsi_Host
attributes from procfs functions in the sg driver to sysfs.

Not only is this the much more logical place for them, but with some
more work on the pcmcia drivers this will allow us to make
scsi_host_get_next() private to the midlayer for implementing
refcounting and cleaning up locking in that area.


--- 1.6/drivers/scsi/scsi_sysfs.c	Tue Feb  4 20:14:26 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Fri Feb 21 23:08:59 2003
@@ -14,6 +14,44 @@
 #include "scsi.h"
 #include "hosts.h"
 
+
+/*
+ * shost_show_function: macro to create an attr function that can be used to
+ * show a non-bit field.
+ */
+#define shost_show_function(field, format_string)			\
+static ssize_t								\
+show_##field (struct device *dev, char *buf)				\
+{									\
+	struct Scsi_Host *shost = to_scsi_host(dev);			\
+	return snprintf (buf, 20, format_string, shost->field);	\
+}
+
+/*
+ * shost_rd_attr: macro to create a function and attribute variable for a
+ * read only field.
+ */
+#define shost_rd_attr(field, format_string)				\
+	shost_show_function(field, format_string)				\
+static DEVICE_ATTR(field, S_IRUGO, show_##field, NULL)
+
+/*
+ * Create the actual show/store functions and data structures.
+ */
+shost_rd_attr(unique_id, "%u\n");
+shost_rd_attr(host_busy, "%hu\n");
+shost_rd_attr(cmd_per_lun, "%hd\n");
+shost_rd_attr(sg_tablesize, "%hu\n");
+shost_rd_attr(unchecked_isa_dma, "%d\n");
+
+static struct device_attribute *const shost_attrs[] = {
+	&dev_attr_unique_id,
+	&dev_attr_host_busy,
+	&dev_attr_cmd_per_lun,
+	&dev_attr_sg_tablesize,
+	&dev_attr_unchecked_isa_dma,
+};
+
 /**
  * scsi_host_class_name_show - copy out the SCSI host name
  * @dev:		device to check
@@ -39,12 +77,21 @@
 
 static int scsi_host_class_add_dev(struct device * dev)
 {
+	int i;
+
 	device_create_file(dev, &dev_attr_class_name);
+	for (i = 0; i < ARRAY_SIZE(shost_attrs); i++)
+		device_create_file(dev, shost_attrs[i]);
+
 	return 0;
 }
 
 static void scsi_host_class_rm_dev(struct device * dev)
 {
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(shost_attrs); i++)
+		device_remove_file(dev, shost_attrs[i]);
 	device_remove_file(dev, &dev_attr_class_name);
 }
 
@@ -129,10 +176,10 @@
 
 
 /*
- * show_function: macro to create an attr function that can be used to
+ * sdev_show_function: macro to create an attr function that can be used to
  * show a non-bit field.
  */
-#define show_function(field, format_string)				\
+#define sdev_show_function(field, format_string)				\
 static ssize_t								\
 show_##field (struct device *dev, char *buf)				\
 {									\
@@ -146,7 +193,7 @@
  * read only field.
  */
 #define sdev_rd_attr(field, format_string)				\
-	show_function(field, format_string)				\
+	sdev_show_function(field, format_string)				\
 static DEVICE_ATTR(field, S_IRUGO, show_##field, NULL)
 
 
@@ -155,27 +202,27 @@
  * read/write field.
  */
 #define sdev_rw_attr(field, format_string)				\
-	show_function(field, format_string)				\
+	sdev_show_function(field, format_string)				\
 									\
 static ssize_t								\
-store_##field (struct device *dev, const char *buf, size_t count)	\
+sdev_store_##field (struct device *dev, const char *buf, size_t count)	\
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
 	snscanf (buf, 20, format_string, &sdev->field);			\
 	return count;							\
 }									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field, store_##field)
+static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field, sdev_store_##field)
 
 /*
  * sdev_rd_attr: create a function and attribute variable for a
  * read/write bit field.
  */
 #define sdev_rw_attr_bit(field)						\
-	show_function(field, "%d\n")					\
+	sdev_show_function(field, "%d\n")					\
 									\
 static ssize_t								\
-store_##field (struct device *dev, const char *buf, size_t count)	\
+sdev_store_##field (struct device *dev, const char *buf, size_t count)	\
 {									\
 	int ret;							\
 	struct scsi_device *sdev;					\
@@ -187,7 +234,7 @@
 	}								\
 	return ret;							\
 }									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field, store_##field)
+static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field, sdev_store_##field)
 
 /*
  * scsi_sdev_check_buf_bit: return 0 if buf is "0", return 1 if buf is "1",
--- 1.47/drivers/scsi/sg.c	Tue Feb  4 20:10:18 2003
+++ edited/drivers/scsi/sg.c	Fri Feb 21 18:16:35 2003
@@ -2689,18 +2689,6 @@
 				int size, int *eof, void *data);
 static int sg_proc_devstrs_info(char *buffer, int *len, off_t * begin,
 				off_t offset, int size);
-static int sg_proc_host_read(char *buffer, char **start, off_t offset,
-			     int size, int *eof, void *data);
-static int sg_proc_host_info(char *buffer, int *len, off_t * begin,
-			     off_t offset, int size);
-static int sg_proc_hosthdr_read(char *buffer, char **start, off_t offset,
-				int size, int *eof, void *data);
-static int sg_proc_hosthdr_info(char *buffer, int *len, off_t * begin,
-				off_t offset, int size);
-static int sg_proc_hoststrs_read(char *buffer, char **start, off_t offset,
-				 int size, int *eof, void *data);
-static int sg_proc_hoststrs_info(char *buffer, int *len, off_t * begin,
-				 off_t offset, int size);
 static int sg_proc_version_read(char *buffer, char **start, off_t offset,
 				int size, int *eof, void *data);
 static int sg_proc_version_info(char *buffer, int *len, off_t * begin,
@@ -2708,7 +2696,6 @@
 static read_proc_t *sg_proc_leaf_reads[] = {
 	sg_proc_adio_read, sg_proc_dressz_read, sg_proc_debug_read,
 	sg_proc_dev_read, sg_proc_devhdr_read, sg_proc_devstrs_read,
-	sg_proc_host_read, sg_proc_hosthdr_read, sg_proc_hoststrs_read,
 	sg_proc_version_read
 };
 static write_proc_t *sg_proc_leaf_writes[] = {
@@ -3029,81 +3016,6 @@
 				   scsidp->vendor, scsidp->model, scsidp->rev);
 		else
 			PRINT_PROC("<no active device>\n");
-	}
-	return 1;
-}
-
-static int
-sg_proc_host_read(char *buffer, char **start, off_t offset,
-		  int size, int *eof, void *data)
-{
-	SG_PROC_READ_FN(sg_proc_host_info);
-}
-
-static int
-sg_proc_host_info(char *buffer, int *len, off_t * begin, off_t offset, int size)
-{
-	struct Scsi_Host *shp;
-	int k;
-
-	for (k = 0, shp = scsi_host_get_next(NULL); shp;
-	     shp = scsi_host_get_next(shp), ++k) {
-		for (; k < shp->host_no; ++k)
-			PRINT_PROC("-1\t-1\t-1\t-1\t-1\t-1\n");
-		PRINT_PROC("%u\t%hu\t%hd\t%hu\t%d\t%d\n",
-			   shp->unique_id, shp->host_busy, shp->cmd_per_lun,
-			   shp->sg_tablesize, (int) shp->unchecked_isa_dma,
-			   (int) shp->hostt->emulated);
-	}
-	return 1;
-}
-
-static int
-sg_proc_hosthdr_read(char *buffer, char **start, off_t offset,
-		     int size, int *eof, void *data)
-{
-	SG_PROC_READ_FN(sg_proc_hosthdr_info);
-}
-
-static int
-sg_proc_hosthdr_info(char *buffer, int *len, off_t * begin,
-		     off_t offset, int size)
-{
-	PRINT_PROC("uid\tbusy\tcpl\tscatg\tisa\temul\n");
-	return 1;
-}
-
-static int
-sg_proc_hoststrs_read(char *buffer, char **start, off_t offset,
-		      int size, int *eof, void *data)
-{
-	SG_PROC_READ_FN(sg_proc_hoststrs_info);
-}
-
-#define SG_MAX_HOST_STR_LEN 256
-
-static int
-sg_proc_hoststrs_info(char *buffer, int *len, off_t * begin,
-		      off_t offset, int size)
-{
-	struct Scsi_Host *shp;
-	int k;
-	char buff[SG_MAX_HOST_STR_LEN];
-	char *cp;
-
-	for (k = 0, shp = scsi_host_get_next(NULL); shp;
-	     shp = scsi_host_get_next(shp), ++k) {
-		for (; k < shp->host_no; ++k)
-			PRINT_PROC("<no active host>\n");
-		strncpy(buff, shp->hostt->info ? shp->hostt->info(shp) :
-			(shp->hostt->name ? shp->hostt->name : "<no name>"),
-			SG_MAX_HOST_STR_LEN);
-		buff[SG_MAX_HOST_STR_LEN - 1] = '\0';
-		for (cp = buff; *cp; ++cp) {
-			if ('\n' == *cp)
-				*cp = ' ';	/* suppress imbedded newlines */
-		}
-		PRINT_PROC("%s\n", buff);
 	}
 	return 1;
 }
