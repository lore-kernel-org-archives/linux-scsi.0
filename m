From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] add sysfs attributes to scan and delete scsi_devices
Date: Tue, 8 Jul 2003 13:40:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708134016.A32161@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:11221 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265332AbTGHUZr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2003 16:25:47 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

This patch against recent 2.5 bk adds a sysfs attribute to allow scanning
(or rescanning) and deletion of scsi_devices.

It also allows scanning of entire hosts, channels, or targets.

diff -purN -X /home/patman/dontdiff bleed-2.5/drivers/scsi/scsi_priv.h scan-del-attr-bl-2.5/drivers/scsi/scsi_priv.h
--- bleed-2.5/drivers/scsi/scsi_priv.h	Wed Jul  2 13:40:54 2003
+++ scan-del-attr-bl-2.5/drivers/scsi/scsi_priv.h	Mon Jul  7 12:45:29 2003
@@ -107,6 +107,8 @@ extern void scsi_forget_host(struct Scsi
 extern void scsi_free_sdev(struct scsi_device *);
 extern void scsi_free_shost(struct Scsi_Host *);
 extern void scsi_rescan_device(struct device *);
+extern int scsi_scan(const char *);
+extern int scsi_remove(const char *);
 
 /* scsi_sysfs.c */
 extern int scsi_device_register(struct scsi_device *);
diff -purN -X /home/patman/dontdiff bleed-2.5/drivers/scsi/scsi_scan.c scan-del-attr-bl-2.5/drivers/scsi/scsi_scan.c
--- bleed-2.5/drivers/scsi/scsi_scan.c	Mon Jul  7 11:10:22 2003
+++ scan-del-attr-bl-2.5/drivers/scsi/scsi_scan.c	Mon Jul  7 12:45:29 2003
@@ -49,6 +49,12 @@
 #define SCSI_UID_UNKNOWN 'Z'
 
 /*
+ * Special value for scanning to specify scanning or rescanning of all
+ * possible channels, (target) ids, or luns on a given host.
+ */
+#define SCAN_WILD_CARD	~0
+
+/*
  * Return values of some of the scanning functions.
  *
  * SCSI_SCAN_NO_RESPONSE: no valid response received from the target, this
@@ -679,13 +685,32 @@ static int scsi_add_lun(struct scsi_devi
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
@@ -760,7 +785,7 @@ static int scsi_probe_and_add_lun(struct
  *     Modifies sdevscan->lun.
  **/
 static void scsi_sequential_lun_scan(struct Scsi_Host *shost, uint channel,
-		uint id, int bflags, int lun0_res, int scsi_level)
+		uint id, int bflags, int lun0_res, int scsi_level, int rescan)
 {
 	unsigned int sparse_lun, lun, max_dev_lun;
 
@@ -829,7 +854,8 @@ static void scsi_sequential_lun_scan(str
 	 */
 	for (lun = 1; lun < max_dev_lun; ++lun)
 		if ((scsi_probe_and_add_lun(shost, channel, id, lun,
-		      NULL, NULL) != SCSI_SCAN_LUN_PRESENT) && !sparse_lun)
+		      NULL, NULL, rescan) != SCSI_SCAN_LUN_PRESENT) &&
+		    !sparse_lun)
 			return;
 }
 
@@ -880,7 +906,8 @@ static int scsilun_to_int(struct scsi_lu
  *     0: scan completed (or no memory, so further scanning is futile)
  *     1: no report lun scan, or not configured
  **/
-static int scsi_report_lun_scan(struct scsi_device *sdev, int bflags)
+static int scsi_report_lun_scan(struct scsi_device *sdev, int bflags,
+				int rescan)
 {
 	char devname[64];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
@@ -1034,7 +1061,7 @@ static int scsi_report_lun_scan(struct s
 			int res;
 
 			res = scsi_probe_and_add_lun(sdev->host, sdev->channel,
-				sdev->id, lun, NULL, NULL);
+				sdev->id, lun, NULL, NULL, rescan);
 			if (res == SCSI_SCAN_NO_RESPONSE) {
 				/*
 				 * Got some results, but now none, abort.
@@ -1060,7 +1087,7 @@ static int scsi_report_lun_scan(struct s
 	return 0;
 }
 #else
-# define scsi_report_lun_scan(sdev, blags)	(1)
+# define scsi_report_lun_scan(sdev, blags, rescan)	(1)
 #endif	/* CONFIG_SCSI_REPORT_LUNS */
 
 struct scsi_device *scsi_add_device(struct Scsi_Host *shost,
@@ -1069,7 +1096,11 @@ struct scsi_device *scsi_add_device(stru
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
@@ -1112,7 +1143,7 @@ void scsi_rescan_device(struct device *d
  *     sequential scan of LUNs on the target id.
  **/
 static void scsi_scan_target(struct Scsi_Host *shost, unsigned int channel,
-			     unsigned int id)
+			     unsigned int id, unsigned int lun, int rescan)
 {
 	int bflags = 0;
 	int res;
@@ -1124,19 +1155,29 @@ static void scsi_scan_target(struct Scsi
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
@@ -1145,37 +1186,26 @@ static void scsi_scan_target(struct Scsi
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
@@ -1183,9 +1213,155 @@ void scsi_scan_host(struct Scsi_Host *sh
 				order_id = shost->max_id - id - 1;
 			else
 				order_id = id;
-			scsi_scan_target(shost, channel, order_id);
+			scsi_scan_target(shost, channel, order_id, lun, rescan);
 		}
+	else
+		scsi_scan_target(shost, channel, id, lun, rescan);
+}
+
+static int scsi_scan_host_selected(struct Scsi_Host *shost,
+				    unsigned int channel, unsigned int id,
+				    unsigned int lun, int rescan)
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
+}
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
+/**
+ * scsi_scan - scan and possibly rescan for a given adapter
+ * @str: string with values of form "host_no chan id lun"
+ *
+ * Description:
+ *     Determine the host_no, channel, id, and lun by parsing @str, and
+ *     then call scsi_scan_host_selected. Except for host_no, values can
+ *     be wild-carded using "-".
+ *
+ * Returns: 0 on success, -error on failure.
+ **/
+int scsi_scan(const char *str)
+{
+	struct Scsi_Host *shost;
+	char s1[15], s2[15], s3[15], s4[15], junk;
+	unsigned int host_no, channel, id, lun;
+	int res;
+
+	res = sscanf(str, "%10s %10s %10s %10s %c", s1, s2, s3, s4, &junk);
+	if (res != 4)
+		return -EINVAL;
+	if (check_set(&host_no, s1, NULL))
+		return -EINVAL;
+	if (check_set(&channel, s2, "-"))
+		return -EINVAL;
+	if (check_set(&id, s3, "-"))
+		return -EINVAL;
+	if (check_set(&lun, s4, "-"))
+		return -EINVAL;
+
+	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "%s: <%u:%u:%u:%u>\n",
+		__FUNCTION__, host_no, channel, id, lun));
+	/*
+	 * Doesn't check for overflow of host_no
+	 */
+	shost = scsi_host_lookup(host_no);
+	if (!shost)
+		return -ENODEV;
+
+	res = scsi_scan_host_selected(shost, channel, id, lun, 1 /* rescan */);
+	scsi_host_put(shost);
+	return res;
+}
+
+/**
+ * scsi_remove - remove one scsi_device from shost
+ * @str: string with values of form "host_no chan id lun"
+ *
+ * Description:
+ *     Determine the host_no, channel, id, and lun by parsing @str, and
+ *     then call scsi_remove_device. No wild card support.
+ *
+ * Returns: 0 on success, -error on failure.
+ **/
+int scsi_remove(const char *str)
+{
+	struct scsi_device *sdev;
+	struct Scsi_Host *shost;
+	char s1[15], s2[15], s3[15], s4[15], junk;
+	unsigned int host_no, channel, id, lun;
+	int res;
+
+	res = sscanf(str, "%10s %10s %10s %10s %c", s1, s2, s3, s4, &junk);
+	if (res != 4)
+		return -EINVAL;
+	if (check_set(&host_no, s1, NULL))
+		return -EINVAL;
+	if (check_set(&channel, s2, NULL))
+		return -EINVAL;
+	if (check_set(&id, s3, NULL))
+		return -EINVAL;
+	if (check_set(&lun, s4, NULL))
+		return -EINVAL;
+
+	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "%s: <%u:%u:%u:%u>\n",
+		__FUNCTION__, host_no, channel, id, lun));
+	/*
+	 * Doesn't check for overflow of host_no
+	 */
+	shost = scsi_host_lookup(host_no);
+	if (!shost)
+		return -ENODEV;
+
+	sdev = scsi_find_device(shost, channel, id, lun);
+	if (!sdev) {
+		res = -ENODEV;
+		goto out;
+	}
+
+	if (sdev->access_count) {
+		res = -EBUSY;
+		goto out;
 	}
+
+	res = 0;
+	scsi_remove_device(sdev);
+out:
+	scsi_host_put(shost);
+	return res;
 }
 
 void scsi_forget_host(struct Scsi_Host *shost)
diff -purN -X /home/patman/dontdiff bleed-2.5/drivers/scsi/scsi_sysfs.c scan-del-attr-bl-2.5/drivers/scsi/scsi_sysfs.c
--- bleed-2.5/drivers/scsi/scsi_sysfs.c	Wed Jul  2 18:33:55 2003
+++ scan-del-attr-bl-2.5/drivers/scsi/scsi_sysfs.c	Tue Jul  8 10:54:23 2003
@@ -73,6 +73,27 @@ struct bus_type scsi_bus_type = {
         .match		= scsi_bus_match,
 };
 
+static ssize_t store_scan(struct bus_type *bus, const char *buf, size_t count)
+{
+	int res;
+
+	res = scsi_scan(buf);
+	if (res == 0)
+		res = count;
+	return res;
+};
+static BUS_ATTR(scan, S_IWUSR, NULL, store_scan);
+
+static ssize_t store_delete(struct bus_type *bus, const char *buf, size_t count)
+{
+	int res;
+
+	res = scsi_remove(buf);
+	if (res == 0)
+		res = count;
+	return res;
+};
+static BUS_ATTR(delete, S_IWUSR, NULL, store_delete);
 
 int scsi_sysfs_register(void)
 {
@@ -81,6 +102,12 @@ int scsi_sysfs_register(void)
 	error = bus_register(&scsi_bus_type);
 	if (error)
 		return error;
+	error = bus_create_file(&scsi_bus_type, &bus_attr_scan);
+	if (error)
+		goto bus_unregister;
+	error = bus_create_file(&scsi_bus_type, &bus_attr_delete);
+	if (error)
+		goto bus_unregister;
 	error = class_register(&shost_class);
 	if (error)
 		goto bus_unregister;
