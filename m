From: Andries.Brouwer@cwi.nl
Subject: scsi_scan.c patch
Date: Thu, 28 Nov 2002 23:02:30 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200211282202.gASM2U808846.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Wondering why my CD-writer did not have a name in sysfs, I saw
that when the name is longer than 50 bytes no name at all is used.
The (much smaller) code below constructs a truncated name instead.

(A reason not to truncate would be the desire to obtain a unique
name, where the unicity is guaranteed by the serial number.
However, my HP CD-writer has a serial number that consists of the
'[' byte only, not much distinctive here.)

Andries

diff -u --recursive --new-file -X /linux/dontdiff a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Thu Nov 28 15:28:19 2002
+++ b/drivers/scsi/scsi_scan.c	Thu Nov 28 22:44:47 2002
@@ -557,32 +557,6 @@
 }
 
 /**
- * scsi_check_id_size - check if size fits in the driverfs name
- * @sdev:	Scsi_Device to use for error message
- * @size:	the length of the id we want to store
- *
- * Description:
- *     Use a function for this since the same code is used in various
- *     places, and we only create one string and call to printk.
- *
- * Return:
- *     0 - fits
- *     1 - size too large
- **/
-static int scsi_check_id_size(Scsi_Device *sdev, int size)
-{
-	if (size > DEVICE_NAME_SIZE) {
-		printk(KERN_WARNING "scsi scan: host %d channel %d id %d lun %d"
-		       " identifier too long, length %d, max %d. Device might"
-		       " be improperly identified.\n", sdev->host->host_no,
-		       sdev->channel, sdev->id, sdev->lun, size,
-		       DEVICE_NAME_SIZE);
-		return 1;
-	} else
-		return 0;
-}
-
-/**
  * scsi_get_evpd_page - get a list of supported vpd pages
  * @sdev:	Scsi_Device to send an INQUIRY VPD
  * @sreq:	Scsi_Request associated with @sdev
@@ -728,17 +702,16 @@
  * scsi_check_fill_deviceid - check the id and if OK fill it
  * @sdev:	device to use for error messages
  * @id_page:	id descriptor for INQUIRY VPD DEVICE ID, page 0x83
- * @name:	store the id in name
+ * @name:	store the id in name (of size DEVICE_NAME_SIZE > 26)
  * @id_search:	store if the id_page matches these values
  *
  * Description:
  *     Check if @id_page matches the @id_search, if so store an id (uid)
- *     into name.
+ *     into name, that is all zero on entrance.
  *
  * Return:
  *     0: Success
  *     1: No match
- *     2: Failure due to size constraints
  **/
 static int scsi_check_fill_deviceid(Scsi_Device *sdev, char *id_page,
 	char *name, const struct scsi_id_search_values *id_search)
@@ -768,70 +741,41 @@
 	if ((id_page[0] & 0x0f) != id_search->code_set)
 		return 1;
 
-	name[0]  = hex_str[id_search->id_type];
+	/*
+	 * All OK - store ID
+	 */
+	name[0] = hex_str[id_search->id_type];
+
+	/*
+	 * Prepend the vendor and model before the id, since the id
+	 * might not be unique across all vendors and models.
+	 * The same code is used below, with a different size.
+	 */
+	if (id_search->id_type == SCSI_ID_VENDOR_SPECIFIC) {
+		strncat(name, sdev->vendor, 8);
+		strncat(name, sdev->model, 16);
+	}
+
+	i = 4;
+	j = strlen(name);
 	if ((id_page[0] & 0x0f) == SCSI_ID_ASCII) {
 		/*
 		 * ASCII descriptor.
 		 */
-		if (id_search->id_type == SCSI_ID_VENDOR_SPECIFIC) {
-			/*
-			 * Prepend the vendor and model before the id,
-			 * since the id might not be unique across all
-			 * vendors and models. The same code is used
-			 * below, with a differnt size.
-			 *
-			 * Need 1 byte for the idtype, 1 for trailing
-			 * '\0', 8 for vendor, 16 for model total 26, plus
-			 * the name descriptor length.
-			 */
-			if (scsi_check_id_size(sdev, 26 + id_page[3]))
-				return 2;
-			else {
-				strncat(name, sdev->vendor, 8);
-				strncat(name, sdev->model, 16);
-			}
-		} else if (scsi_check_id_size (sdev, (2 + id_page[3])))
-			/*
-			 * Need 1 byte for the idtype, 1 byte for
-			 * the trailing '\0', plus the descriptor length.
-			 */
-			return 2;
-		memcpy(&name[strlen(name)], &id_page[4], id_page[3]);
-		return 0;
-	} else if ((id_page[0] & 0x0f) == SCSI_ID_BINARY) {
-		if (id_search->id_type == SCSI_ID_VENDOR_SPECIFIC) {
-			/*
-			 * Prepend the vendor and model before the id.
-			 */
-			if (scsi_check_id_size(sdev, 26 + (id_page[3] * 2)))
-				return 2;
-			else {
-				strncat(name, sdev->vendor, 8);
-				strncat(name, sdev->model, 16);
-			}
-		} else if (scsi_check_id_size(sdev, 2 + (id_page[3] * 2)))
-			/*
-			 * Need 1 byte for the idtype, 1 for trailing
-			 * '\0', 8 for vendor, 16 for model total 26, plus
-			 * the name descriptor length.
-			 */
-			return 2;
+		while (i < 4 + id_page[3] && j < DEVICE_NAME_SIZE-1)
+			name[j++] = id_page[i++];
+	} else {
 		/*
 		 * Binary descriptor, convert to ASCII, using two bytes of
-		 * ASCII for each byte in the id_page. Store starting at
-		 * the end of name.
+		 * ASCII for each byte in the id_page.
 		 */
-		for(i = 4, j = strlen(name); i < 4 + id_page[3]; i++) {
+		while (i < 4 + id_page[3] && j < DEVICE_NAME_SIZE-2) {
 			name[j++] = hex_str[(id_page[i] & 0xf0) >> 4];
 			name[j++] = hex_str[id_page[i] & 0x0f];
+			i++;
 		}
-		return 0;
 	}
-	/*
-	 * Code set must have already matched.
-	 */
-	printk(KERN_ERR "scsi scan: scsi_check_fill_deviceid unexpected state.\n");
-	return 1;
+	return 0;
 }
 
 /**
@@ -892,7 +836,7 @@
 	}
 
 	/*
-	 * Search for a match in the proiritized id_search_list.
+	 * Search for a match in the prioritized id_search_list.
 	 */
 	for (id_idx = 0; id_idx < ARRAY_SIZE(id_search_list); id_idx++) {
 		/*
@@ -955,6 +899,7 @@
 	unsigned char *serialnumber_page;
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int max_lgth = 255;
+	int len;
 
  retry:
 	serialnumber_page = kmalloc(max_lgth, GFP_ATOMIC |
@@ -991,17 +936,13 @@
 		goto retry;
 	}
 
-	/*
-	 * Need 1 byte for SCSI_UID_SER_NUM, 1 for trailing '\0', 8 for
-	 * vendor, 16 for model = 26, plus serial number size.
-	 */
-	if (scsi_check_id_size (sdev, (26 + serialnumber_page[3])))
-		goto leave;
 	sdev->sdev_driverfs_dev.name[0] = SCSI_UID_SER_NUM;
 	strncat(sdev->sdev_driverfs_dev.name, sdev->vendor, 8);
 	strncat(sdev->sdev_driverfs_dev.name, sdev->model, 16);
-	strncat(sdev->sdev_driverfs_dev.name, &serialnumber_page[4],
-		serialnumber_page[3]);
+	len = serialnumber_page[3];
+	if (len > DEVICE_NAME_SIZE-26)
+		len = DEVICE_NAME_SIZE-26;
+	strncat(sdev->sdev_driverfs_dev.name, &serialnumber_page[4], len);
 	kfree(serialnumber_page);
 	return 1;
  leave:
@@ -1015,23 +956,19 @@
  * @sdev:	get a default name for this device
  *
  * Description:
- *     Set the name of @sdev to the concatenation of the vendor, model,
- *     and revision found in @sdev.
+ *     Set the name of @sdev (of size DEVICE_NAME_SIZE > 29) to the
+ *     concatenation of the vendor, model, and revision found in @sdev.
  *
  * Return:
  *     1: Success
  **/
 int scsi_get_default_name(Scsi_Device *sdev)
 {
-	if (scsi_check_id_size(sdev, 29))
-		return 0;
-	else {
-		sdev->sdev_driverfs_dev.name[0] = SCSI_UID_UNKNOWN;
-		strncpy(&sdev->sdev_driverfs_dev.name[1], sdev->vendor, 8);
-		strncat(sdev->sdev_driverfs_dev.name, sdev->model, 16);
-		strncat(sdev->sdev_driverfs_dev.name, sdev->rev, 4);
-		return 1;
-	}
+	sdev->sdev_driverfs_dev.name[0] = SCSI_UID_UNKNOWN;
+	strncpy(&sdev->sdev_driverfs_dev.name[1], sdev->vendor, 8);
+	strncat(sdev->sdev_driverfs_dev.name, sdev->model, 16);
+	strncat(sdev->sdev_driverfs_dev.name, sdev->rev, 4);
+	return 1;
 }
 
 /**
