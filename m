From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] take 2 add sysfs attributes to scan and delete scsi_devices
Date: Wed, 9 Jul 2003 13:27:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030709132757.A7360@beaverton.ibm.com>
References: <20030708134016.A32161@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:36765 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266123AbTGIUNn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2003 16:13:43 -0400
Content-Disposition: inline
In-Reply-To: <20030708134016.A32161@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Jul 08, 2003 at 01:40:16PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

This patch against scsi-misc-2.5 adds a sysfs attribute to allow scanning
(or rescanning) and deletion of scsi_devices.

It also allows scanning of entire hosts, channels, or targets.

Updated per comments received, mainly create the scan and delete
attributes per host.

The scsi_proc.c remove code was not changed, it and this patch still need
changes based on Mike A's patches.

diff -purN -X /home/patman/dontdiff scsi-misc-2.5-pure/drivers/scsi/scsi_priv.h scan-del-attr-sm-2.5/drivers/scsi/scsi_priv.h
--- scsi-misc-2.5-pure/drivers/scsi/scsi_priv.h	Wed Jul  9 09:12:38 2003
+++ scan-del-attr-sm-2.5/drivers/scsi/scsi_priv.h	Wed Jul  9 09:22:42 2003
@@ -42,6 +42,12 @@
 	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
 
 /*
+ * Special value for scanning to specify scanning or rescanning of all
+ * possible channels, (target) ids, or luns on a given shost.
+ */
+#define SCAN_WILD_CARD	~0
+
+/*
  * scsi_target: representation of a scsi target, for now, this is only
  * used for single_lun devices. If no one has active IO to the target,
  * starget_sdev_user is NULL, else it points to the active sdev.
@@ -102,6 +108,8 @@ extern void scsi_exit_procfs(void);
 #endif /* CONFIG_PROC_FS */
 
 /* scsi_scan.c */
+int scsi_scan_host_selected(struct Scsi_Host *, unsigned int, unsigned int,
+			    unsigned int, int);
 extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_free_sdev(struct scsi_device *);
 extern void scsi_free_shost(struct Scsi_Host *);
diff -purN -X /home/patman/dontdiff scsi-misc-2.5-pure/drivers/scsi/scsi_proc.c scan-del-attr-sm-2.5/drivers/scsi/scsi_proc.c
--- scsi-misc-2.5-pure/drivers/scsi/scsi_proc.c	Thu Jun 12 02:50:06 2003
+++ scan-del-attr-sm-2.5/drivers/scsi/scsi_proc.c	Wed Jul  9 12:05:37 2003
@@ -174,21 +174,11 @@ static int proc_print_scsidevice(struct 
 static int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
 {
 	struct Scsi_Host *shost;
-	struct scsi_device *sdev;
-	int error = -ENODEV;
-
+	int error;
 	shost = scsi_host_lookup(host);
 	if (!shost)
 		return -ENODEV;
-
-	if (!scsi_find_device(shost, channel, id, lun)) {
-		sdev = scsi_add_device(shost, channel, id, lun);
-		if (IS_ERR(sdev))
-			error = PTR_ERR(sdev);
-		else
-			error = 0;
-	}
-
+	error = scsi_scan_host_selected(shost, channel, id, lun, 1);
 	scsi_host_put(shost);
 	return error;
 }
diff -purN -X /home/patman/dontdiff scsi-misc-2.5-pure/drivers/scsi/scsi_scan.c scan-del-attr-sm-2.5/drivers/scsi/scsi_scan.c
--- scsi-misc-2.5-pure/drivers/scsi/scsi_scan.c	Wed Jul  9 09:12:38 2003
+++ scan-del-attr-sm-2.5/drivers/scsi/scsi_scan.c	Wed Jul  9 09:19:41 2003
@@ -678,13 +678,32 @@ static int scsi_add_lun(struct scsi_devi
  **/
 static int scsi_probe_and_add_lun(struct Scsi_Host *host,
 		uint channel, uint id, uint lun, int *bflagsp,
-		struct scsi_device **sdevp)
+		struct scsi_device **sdevp, int rescan)
 {
 	struct scsi_device *sdev;
 	struct scsi_request *sreq;
 	unsigned char *result;
 	int bflags, res = SCSI_SCAN_NO_RESPONSE;
 
+	/*
+	 * The rescan flag is used as an optimization, the first scan of a
+	 * host adapter calls into here with rescan == 0.
+	 */
+	if (rescan) {
+		sdev = scsi_find_device(host, channel, id, lun);
+		if (sdev) {
+			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
+				"scsi scan: device exists on <%d:%d:%d:%d>\n",
+				host->host_no, channel, id, lun));
+			if (sdevp)
+				*sdevp = sdev;
+			if (bflagsp)
+				*bflagsp = scsi_get_device_flags(sdev->vendor,
+								 sdev->model);
+			return SCSI_SCAN_LUN_PRESENT;
+		}
+	}
+
 	sdev = scsi_alloc_sdev(host, channel, id, lun);
 	if (!sdev)
 		goto out;
@@ -759,7 +778,7 @@ static int scsi_probe_and_add_lun(struct
  *     Modifies sdevscan->lun.
  **/
 static void scsi_sequential_lun_scan(struct Scsi_Host *shost, uint channel,
-		uint id, int bflags, int lun0_res, int scsi_level)
+		uint id, int bflags, int lun0_res, int scsi_level, int rescan)
 {
 	unsigned int sparse_lun, lun, max_dev_lun;
 
@@ -828,7 +847,8 @@ static void scsi_sequential_lun_scan(str
 	 */
 	for (lun = 1; lun < max_dev_lun; ++lun)
 		if ((scsi_probe_and_add_lun(shost, channel, id, lun,
-		      NULL, NULL) != SCSI_SCAN_LUN_PRESENT) && !sparse_lun)
+		      NULL, NULL, rescan) != SCSI_SCAN_LUN_PRESENT) &&
+		    !sparse_lun)
 			return;
 }
 
@@ -879,7 +899,8 @@ static int scsilun_to_int(struct scsi_lu
  *     0: scan completed (or no memory, so further scanning is futile)
  *     1: no report lun scan, or not configured
  **/
-static int scsi_report_lun_scan(struct scsi_device *sdev, int bflags)
+static int scsi_report_lun_scan(struct scsi_device *sdev, int bflags,
+				int rescan)
 {
 	char devname[64];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
@@ -1033,7 +1054,7 @@ static int scsi_report_lun_scan(struct s
 			int res;
 
 			res = scsi_probe_and_add_lun(sdev->host, sdev->channel,
-				sdev->id, lun, NULL, NULL);
+				sdev->id, lun, NULL, NULL, rescan);
 			if (res == SCSI_SCAN_NO_RESPONSE) {
 				/*
 				 * Got some results, but now none, abort.
@@ -1059,7 +1080,7 @@ static int scsi_report_lun_scan(struct s
 	return 0;
 }
 #else
-# define scsi_report_lun_scan(sdev, blags)	(1)
+# define scsi_report_lun_scan(sdev, blags, rescan)	(1)
 #endif	/* CONFIG_SCSI_REPORT_LUNS */
 
 struct scsi_device *scsi_add_device(struct Scsi_Host *shost,
@@ -1068,7 +1089,11 @@ struct scsi_device *scsi_add_device(stru
 	struct scsi_device *sdev;
 	int res;
 
-	res = scsi_probe_and_add_lun(shost, channel, id, lun, NULL, &sdev);
+	/*
+	 * Caller already checked if sdev exists, but be paranoid and call
+	 * with rescan of 1.
+	 */
+	res = scsi_probe_and_add_lun(shost, channel, id, lun, NULL, &sdev, 1);
 	if (res != SCSI_SCAN_LUN_PRESENT)
 		sdev = ERR_PTR(-ENODEV);
 	return sdev;
@@ -1111,7 +1136,7 @@ void scsi_rescan_device(struct device *d
  *     sequential scan of LUNs on the target id.
  **/
 static void scsi_scan_target(struct Scsi_Host *shost, unsigned int channel,
-			     unsigned int id)
+			     unsigned int id, unsigned int lun, int rescan)
 {
 	int bflags = 0;
 	int res;
@@ -1123,19 +1148,29 @@ static void scsi_scan_target(struct Scsi
 		 */
 		return;
 
+	if (lun != SCAN_WILD_CARD) {
+		/*
+		 * Scan for a specific host/chan/id/lun.
+		 */
+		scsi_probe_and_add_lun(shost, channel, id, lun, NULL, NULL,
+				       rescan);
+		return;
+	}
+
 	/*
 	 * Scan LUN 0, if there is some response, scan further. Ideally, we
 	 * would not configure LUN 0 until all LUNs are scanned.
 	 */
-	res = scsi_probe_and_add_lun(shost, channel, id, 0, &bflags, &sdev);
+	res = scsi_probe_and_add_lun(shost, channel, id, 0, &bflags, &sdev,
+				     rescan);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
-		if (scsi_report_lun_scan(sdev, bflags) != 0)
+		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0)
 			/*
 			 * The REPORT LUN did not scan the target,
 			 * do a sequential scan.
 			 */
 			scsi_sequential_lun_scan(shost, channel, id, bflags,
-				       	res, sdev->scsi_level);
+				       	res, sdev->scsi_level, rescan);
 	} else if (res == SCSI_SCAN_TARGET_PRESENT) {
 		/*
 		 * There's a target here, but lun 0 is offline so we
@@ -1144,37 +1179,26 @@ static void scsi_scan_target(struct Scsi
 		 * a default scsi level of SCSI_2
 		 */
 		scsi_sequential_lun_scan(shost, channel, id, BLIST_SPARSELUN,
-				SCSI_SCAN_TARGET_PRESENT, SCSI_2);
+				SCSI_SCAN_TARGET_PRESENT, SCSI_2, rescan);
 	}
 }
 
-/**
- * scsi_scan_host - scan the given adapter
- * @shost:	adapter to scan
- *
- * Description:
- *     Iterate and call scsi_scan_target to scan all possible target id's
- *     on all possible channels.
- **/
-void scsi_scan_host(struct Scsi_Host *shost)
+static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
+			      unsigned int id, unsigned int lun, int rescan)
 {
-	uint channel, id, order_id;
+	uint order_id;
 
-	/*
-	 * The sdevscan host, channel, id and lun are filled in as
-	 * needed to scan.
-	 */
-	for (channel = 0; channel <= shost->max_channel; channel++) {
-		/*
-		 * XXX adapter drivers when possible (FCP, iSCSI)
-		 * could modify max_id to match the current max,
-		 * not the absolute max.
-		 *
-		 * XXX add a shost id iterator, so for example,
-		 * the FC ID can be the same as a target id
-		 * without a huge overhead of sparse id's.
-		 */
+	if (id == SCAN_WILD_CARD)
 		for (id = 0; id < shost->max_id; ++id) {
+			/*
+			 * XXX adapter drivers when possible (FCP, iSCSI)
+			 * could modify max_id to match the current max,
+			 * not the absolute max.
+			 *
+			 * XXX add a shost id iterator, so for example,
+			 * the FC ID can be the same as a target id
+			 * without a huge overhead of sparse id's.
+			 */
 			if (shost->reverse_ordering)
 				/*
 				 * Scan from high to low id.
@@ -1182,9 +1206,36 @@ void scsi_scan_host(struct Scsi_Host *sh
 				order_id = shost->max_id - id - 1;
 			else
 				order_id = id;
-			scsi_scan_target(shost, channel, order_id);
+			scsi_scan_target(shost, channel, order_id, lun, rescan);
 		}
-	}
+	else
+		scsi_scan_target(shost, channel, id, lun, rescan);
+}
+
+int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
+			    unsigned int id, unsigned int lun, int rescan)
+{
+	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
+	    ((id != SCAN_WILD_CARD) && (id > shost->max_id)) ||
+	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
+		return -EINVAL;
+
+	if (channel == SCAN_WILD_CARD) 
+		for (channel = 0; channel <= shost->max_channel; channel++)
+			scsi_scan_channel(shost, channel, id, lun, rescan);
+	else
+		scsi_scan_channel(shost, channel, id, lun, rescan);
+	return 0;
+}
+
+/**
+ * scsi_scan_host - scan the given adapter
+ * @shost:	adapter to scan
+ **/
+void scsi_scan_host(struct Scsi_Host *shost)
+{
+	scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
+				SCAN_WILD_CARD, 0);
 }
 
 void scsi_forget_host(struct Scsi_Host *shost)
diff -purN -X /home/patman/dontdiff scsi-misc-2.5-pure/drivers/scsi/scsi_sysfs.c scan-del-attr-sm-2.5/drivers/scsi/scsi_sysfs.c
--- scsi-misc-2.5-pure/drivers/scsi/scsi_sysfs.c	Wed Jul  9 09:12:38 2003
+++ scan-del-attr-sm-2.5/drivers/scsi/scsi_sysfs.c	Wed Jul  9 12:04:45 2003
@@ -15,6 +15,85 @@
 #include "hosts.h"
 
 #include "scsi_priv.h"
+#include "scsi_logging.h"
+
+static int check_set(unsigned int *val, char *src, char *wild)
+{
+	char *last;
+
+	if (wild && strncmp(src, wild, 20) == 0) {
+		*val = SCAN_WILD_CARD;
+	} else {
+		/*
+		 * Doesn't check for int overflow
+		 */
+		*val = simple_strtoul(src, &last, 0);
+		if (*last != '\0')
+			return 1;
+	}
+	return 0;
+}
+
+static int scsi_scan(struct Scsi_Host *shost, const char *str)
+{
+	char s1[15], s2[15], s3[15], junk;
+	unsigned int channel, id, lun;
+	int res;
+
+	res = sscanf(str, "%10s %10s %10s %c", s1, s2, s3, &junk);
+	if (res != 3)
+		return -EINVAL;
+	if (check_set(&channel, s1, "-"))
+		return -EINVAL;
+	if (check_set(&id, s2, "-"))
+		return -EINVAL;
+	if (check_set(&lun, s3, "-"))
+		return -EINVAL;
+
+	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "%s: <%u:%u:%u:%u>\n",
+		__FUNCTION__, shost->host_no, channel, id, lun));
+	res = scsi_scan_host_selected(shost, channel, id, lun, 1);
+	return res;
+}
+
+static int scsi_remove(struct Scsi_Host *shost, const char *str)
+{
+	struct scsi_device *sdev;
+	char s1[15], s2[15], s3[15], junk;
+	unsigned int channel, id, lun;
+	int res;
+
+	res = sscanf(str, "%10s %10s %10s %c", s1, s2, s3, &junk);
+	if (res != 3)
+		return -EINVAL;
+	if (check_set(&channel, s1, NULL))
+		return -EINVAL;
+	if (check_set(&id, s2, NULL))
+		return -EINVAL;
+	if (check_set(&lun, s3, NULL))
+		return -EINVAL;
+
+	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "%s: <%u:%u:%u:%u>\n",
+		__FUNCTION__, shost->host_no, channel, id, lun));
+	sdev = scsi_find_device(shost, channel, id, lun);
+	if (!sdev) {
+		res = -ENODEV;
+		goto out;
+	}
+
+	if (sdev->access_count) {
+		/*
+		 * FIXME andmike patch
+		 */
+		res = -EBUSY;
+		goto out;
+	}
+
+	res = 0;
+	scsi_remove_device(sdev);
+out:
+	return res;
+}
 
 /*
  * shost_show_function: macro to create an attr function that can be used to
@@ -39,6 +118,33 @@ static CLASS_DEVICE_ATTR(field, S_IRUGO,
 /*
  * Create the actual show/store functions and data structures.
  */
+
+static ssize_t store_scan(struct class_device *class_dev, const char *buf,
+			  size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	int res;
+
+	res = scsi_scan(shost, buf);
+	if (res == 0)
+		res = count;
+	return res;
+};
+static CLASS_DEVICE_ATTR(scan, S_IWUSR, NULL, store_scan);
+
+static ssize_t store_delete(struct class_device *class_dev, const char *buf,
+			    size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	int res;
+
+	res = scsi_remove(shost, buf);
+	if (res == 0)
+		res = count;
+	return res;
+};
+static CLASS_DEVICE_ATTR(delete, S_IWUSR, NULL, store_delete);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
@@ -51,6 +157,8 @@ static struct class_device_attribute *sc
 	&class_device_attr_cmd_per_lun,
 	&class_device_attr_sg_tablesize,
 	&class_device_attr_unchecked_isa_dma,
+	&class_device_attr_scan,
+	&class_device_attr_delete,
 	NULL
 };
 
@@ -73,7 +181,6 @@ struct bus_type scsi_bus_type = {
         .match		= scsi_bus_match,
 };
 
-
 int scsi_sysfs_register(void)
 {
 	int error;
