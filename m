From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: Thu, 24 Apr 2003 17:22:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424172231.A4378@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bi01p1.co.us.ibm.com ([32.97.110.142]:43202 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S264629AbTDYAOH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 20:14:07 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, Andries.Brouwer@cwi.nl, mdharm-scsi@one-eyed-alien.net

Patch against current scsi-misc-2.5 tree.

Remove the scsi EVPD code.

Set the sysfs name to the form "SCSI scsi-type".

--- 1.79/drivers/scsi/scsi_scan.c	Wed Apr 23 03:22:53 2003
+++ edited/drivers/scsi/scsi_scan.c	Thu Apr 24 16:55:44 2003
@@ -506,481 +506,6 @@
 }
 
 /**
- * scsi_get_evpd_page - get a list of supported vpd pages
- * @sdev:	Scsi_Device to send an INQUIRY VPD
- * @sreq:	Scsi_Request associated with @sdev
- *
- * Description:
- *     Get SCSI INQUIRY Vital Product Data page 0 - a list of supported
- *     VPD pages.
- *
- * Return:
- *     A pointer to data containing the results on success, else NULL.
- **/
-unsigned char *scsi_get_evpd_page(Scsi_Device *sdev, Scsi_Request *sreq)
-{
-	unsigned char *evpd_page;
-	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
-	int max_lgth = 255;
-
-retry:
-	evpd_page = kmalloc(max_lgth, GFP_ATOMIC |
-			      (sdev->host->unchecked_isa_dma) ?
-			      GFP_DMA : 0);
-	if (!evpd_page) {
-		printk(KERN_WARNING "scsi scan: Allocation failure identifying"
-		       " host %d channel %d id %d lun %d, device might be"
-		       " improperly identified.\n", sdev->host->host_no,
-		       sdev->channel, sdev->id, sdev->lun);
-		return NULL;
-	}
-
-	memset(scsi_cmd, 0, MAX_COMMAND_SIZE);
-	scsi_cmd[0] = INQUIRY;
-	scsi_cmd[1] = 0x01;
-	scsi_cmd[4] = max_lgth;
-	sreq->sr_cmd_len = 0;
-	sreq->sr_sense_buffer[0] = 0;
-	sreq->sr_sense_buffer[2] = 0;
-	sreq->sr_data_direction = SCSI_DATA_READ;
-	scsi_wait_req(sreq, (void *) scsi_cmd, (void *) evpd_page,
-			max_lgth, SCSI_TIMEOUT+4*HZ, 3);
-
-	if (sreq->sr_result) {
-		kfree(evpd_page);
-		return NULL;
-	}
-
-	/*
-	 * check to see if response was truncated
-	 */
-	if (evpd_page[3] > max_lgth) {
-		max_lgth = evpd_page[3] + 4;
-		kfree(evpd_page);
-		goto retry;
-	}
-
-	/*
-	 * Some ill behaved devices return the standard inquiry here
-	 * rather than the evpd data, snoop the data to verify.
-	 */
-	if (evpd_page[3] > 16) {
-		/*
-		 * If the vendor id appears in the evpd page assume the
-		 * page is invalid.
-		 */
-		if (!strncmp(&evpd_page[8], sdev->vendor, 8)) {
-			kfree(evpd_page);
-			return NULL;
-		}
-	}
-	return evpd_page;
-}
-
-
-/*
- * INQUIRY VPD page 0x83 identifier descriptor related values. Reference the
- * SCSI Primary Commands specification for details.
- *
- * XXX The following defines should be in scsi.h
- */
-
-/*
- * id type values of id descriptors. These are assumed to fit in 4 bits,
- * else the code using hex_str[id_type] needs modification.
- */
-#define SCSI_ID_VENDOR_SPECIFIC	0
-#define SCSI_ID_T10_VENDOR	1
-#define SCSI_ID_EUI_64		2
-#define SCSI_ID_NAA		3
-
-/*
- * Supported NAA values. These fit in 4 bits, so the don't care value
- * cannot conflict with real values.
- *
- */
-#define	SCSI_ID_NAA_DONT_CARE		0xff
-#define	SCSI_ID_NAA_IEEE_REG		5
-#define	SCSI_ID_NAA_IEEE_REG_EXTENDED	6
-
-/*
- * Supported Code Set values.
- */
-#define	SCSI_ID_BINARY	1
-#define	SCSI_ID_ASCII	2
-
-/*
- * Use a priority based list of id, naa, and binary/ascii for the
- * identifier descriptor in VPD page 0x83.
- *
- * Brute force search for a match starting with the first value in
- * id_search_list. This is not a performance issue, since there
- * is normally one or some small number of descriptors.
- */
-struct scsi_id_search_values {
-	int	id_type;
-	int	naa_type;
-	int	code_set;
-};
-
-static const struct scsi_id_search_values id_search_list[] = {
-	{ SCSI_ID_NAA,	SCSI_ID_NAA_IEEE_REG_EXTENDED,	SCSI_ID_BINARY },
-	{ SCSI_ID_NAA,	SCSI_ID_NAA_IEEE_REG_EXTENDED,	SCSI_ID_ASCII },
-	{ SCSI_ID_NAA,	SCSI_ID_NAA_IEEE_REG,	SCSI_ID_BINARY },
-	{ SCSI_ID_NAA,	SCSI_ID_NAA_IEEE_REG,	SCSI_ID_ASCII },
-	/*
-	 * Devices already exist using NAA values that are now marked
-	 * reserved. These should not conflict with other values, or it is
-	 * a bug in the device. As long as we find the IEEE extended one
-	 * first, we really don't care what other ones are used. Using
-	 * don't care here means that a device that returns multiple
-	 * non-IEEE descriptors in a random order will get different
-	 * names.
-	 */
-	{ SCSI_ID_NAA,	SCSI_ID_NAA_DONT_CARE,	SCSI_ID_BINARY },
-	{ SCSI_ID_NAA,	SCSI_ID_NAA_DONT_CARE,	SCSI_ID_ASCII },
-	{ SCSI_ID_EUI_64,	SCSI_ID_NAA_DONT_CARE,	SCSI_ID_BINARY },
-	{ SCSI_ID_EUI_64,	SCSI_ID_NAA_DONT_CARE,	SCSI_ID_ASCII },
-	{ SCSI_ID_T10_VENDOR,	SCSI_ID_NAA_DONT_CARE,	SCSI_ID_BINARY },
-	{ SCSI_ID_T10_VENDOR,	SCSI_ID_NAA_DONT_CARE,	SCSI_ID_ASCII },
-	{ SCSI_ID_VENDOR_SPECIFIC,	SCSI_ID_NAA_DONT_CARE,	SCSI_ID_BINARY },
-	{ SCSI_ID_VENDOR_SPECIFIC,	SCSI_ID_NAA_DONT_CARE,	SCSI_ID_ASCII },
-};
-
-/**
- * scsi_check_fill_deviceid - check the id and if OK fill it
- * @sdev:	device to use for error messages
- * @id_page:	id descriptor for INQUIRY VPD DEVICE ID, page 0x83
- * @name:	store the id in name (of size DEVICE_NAME_SIZE > 26)
- * @id_search:	store if the id_page matches these values
- *
- * Description:
- *     Check if @id_page matches the @id_search, if so store an id (uid)
- *     into name, that is all zero on entrance.
- *
- * Return:
- *     0: Success
- *     1: No match
- **/
-static int scsi_check_fill_deviceid(Scsi_Device *sdev, char *id_page,
-	char *name, const struct scsi_id_search_values *id_search)
-{
-	static const char hex_str[]="0123456789abcdef";
-	int i, j;
-
-	/*
-	 * ASSOCIATION must be with the device (value 0)
-	 */
-	if ((id_page[1] & 0x30) != 0)
-		return 1;
-
-	if ((id_page[1] & 0x0f) != id_search->id_type)
-		return 1;
-	/*
-	 * Possibly check NAA sub-type.
-	 */
-	if ((id_search->naa_type != SCSI_ID_NAA_DONT_CARE) &&
-	    (id_search->naa_type != (id_page[4] & 0xf0) >> 4)) {
-		return 1;
-	}
-
-	/*
-	 * Check for matching code set - ASCII or BINARY.
-	 */
-	if ((id_page[0] & 0x0f) != id_search->code_set)
-		return 1;
-
-	/*
-	 * All OK - store ID
-	 */
-	name[0] = hex_str[id_search->id_type];
-
-	/*
-	 * Prepend the vendor and model before the id, since the id
-	 * might not be unique across all vendors and models.
-	 * The same code is used below, with a different size.
-	 */
-	if (id_search->id_type == SCSI_ID_VENDOR_SPECIFIC) {
-		strncat(name, sdev->vendor, 8);
-		strncat(name, sdev->model, 16);
-	}
-
-	i = 4;
-	j = strlen(name);
-	if ((id_page[0] & 0x0f) == SCSI_ID_ASCII) {
-		/*
-		 * ASCII descriptor.
-		 */
-		while (i < 4 + id_page[3] && j < DEVICE_NAME_SIZE-1)
-			name[j++] = id_page[i++];
-	} else {
-		/*
-		 * Binary descriptor, convert to ASCII, using two bytes of
-		 * ASCII for each byte in the id_page.
-		 */
-		while (i < 4 + id_page[3] && j < DEVICE_NAME_SIZE-2) {
-			name[j++] = hex_str[(id_page[i] & 0xf0) >> 4];
-			name[j++] = hex_str[id_page[i] & 0x0f];
-			i++;
-		}
-	}
-	return 0;
-}
-
-/**
- * scsi_get_deviceid - get a device id using INQUIRY VPD page 0x83
- * @sdev:	get the identifer of this device
- * @sreq:	Scsi_Requeset associated with @sdev
- *
- * Description:
- *     Try to get an id (serial number) for device @sdev using a SCSI
- *     Vital Product Data page 0x83 (device id).
- *
- * Return:
- *     0: Failure
- *     1: Success
- **/
-static int scsi_get_deviceid(Scsi_Device *sdev, Scsi_Request *sreq)
-{
-	unsigned char *id_page;
-	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
-	int id_idx, scnt, ret;
-	int max_lgth = 255;
-
-retry:
-	id_page = kmalloc(max_lgth, GFP_ATOMIC |
-			      (sdev->host->unchecked_isa_dma) ?
-			      GFP_DMA : 0);
-	if (!id_page) {
-		printk(KERN_WARNING "scsi scan: Allocation failure identifying"
-		       " host %d channel %d id %d lun %d, device might be"
-		       " improperly identified.\n", sdev->host->host_no,
-		       sdev->channel, sdev->id, sdev->lun);
-		return 0;
-	}
-
-	memset(scsi_cmd, 0, MAX_COMMAND_SIZE);
-	scsi_cmd[0] = INQUIRY;
-	scsi_cmd[1] = 0x01;
-	scsi_cmd[2] = 0x83;
-	scsi_cmd[4] = max_lgth;
-	sreq->sr_cmd_len = 0;
-	sreq->sr_sense_buffer[0] = 0;
-	sreq->sr_sense_buffer[2] = 0;
-	sreq->sr_data_direction = SCSI_DATA_READ;
-	scsi_wait_req(sreq, (void *) scsi_cmd, (void *) id_page,
-			max_lgth, SCSI_TIMEOUT+4*HZ, 3);
-	if (sreq->sr_result) {
-		ret = 0;
-		goto leave;
-	}
-
-	/*
-	 * check to see if response was truncated
-	 */
-	if (id_page[3] > max_lgth) {
-		max_lgth = id_page[3] + 4;
-		kfree(id_page);
-		goto retry;
-	}
-
-	/*
-	 * Search for a match in the prioritized id_search_list.
-	 */
-	for (id_idx = 0; id_idx < ARRAY_SIZE(id_search_list); id_idx++) {
-		/*
-		 * Examine each descriptor returned. There is normally only
-		 * one or a small number of descriptors.
-		 */
-		for (scnt = 4; scnt <= id_page[3] + 3;
-			scnt += id_page[scnt + 3] + 4) {
-			if ((scsi_check_fill_deviceid(sdev, &id_page[scnt],
-			     sdev->sdev_driverfs_dev.name,
-			     &id_search_list[id_idx])) == 0) {
-				SCSI_LOG_SCAN_BUS(4, printk(KERN_INFO
-				  "scsi scan: host %d channel %d id %d lun %d"
-				  " used id desc %d/%d/%d\n",
-				  sdev->host->host_no, sdev->channel,
-				  sdev->id, sdev->lun,
-				  id_search_list[id_idx].id_type,
-				  id_search_list[id_idx].naa_type,
-				  id_search_list[id_idx].code_set));
-				ret = 1;
-				goto leave;
-			} else {
-				SCSI_LOG_SCAN_BUS(4, printk(KERN_INFO
-				  "scsi scan: host %d channel %d id %d lun %d"
-				  " no match/error id desc %d/%d/%d\n",
-				  sdev->host->host_no, sdev->channel,
-				  sdev->id, sdev->lun,
-				  id_search_list[id_idx].id_type,
-				  id_search_list[id_idx].naa_type,
-				  id_search_list[id_idx].code_set));
-			}
-			/*
-			 * scsi_check_fill_deviceid can fill the first
-			 * byte of name with a non-zero value, reset it.
-			 */
-			sdev->sdev_driverfs_dev.name[0] = '\0';
-		}
-	}
-	ret = 0;
-
-  leave:
-	kfree(id_page);
-	return ret;
-}
-
-/**
- * scsi_get_serialnumber - get a serial number using INQUIRY page 0x80
- * @sdev:	get the serial number of this device
- * @sreq:	Scsi_Requeset associated with @sdev
- *
- * Description:
- *     Send a SCSI INQUIRY page 0x80 to @sdev to get a serial number.
- *
- * Return:
- *     0: Failure
- *     1: Success
- **/
-int scsi_get_serialnumber(Scsi_Device *sdev, Scsi_Request *sreq)
-{
-	unsigned char *serialnumber_page;
-	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
-	const int max_lgth = 255;
-	int len;
-
-	serialnumber_page = kmalloc(max_lgth, GFP_ATOMIC |
-			      (sdev->host->unchecked_isa_dma) ? GFP_DMA : 0);
-	if (!serialnumber_page) {
-		printk(KERN_WARNING "scsi scan: Allocation failure identifying"
-		       " host %d channel %d id %d lun %d, device might be"
-		       " improperly identified.\n", sdev->host->host_no,
-		       sdev->channel, sdev->id, sdev->lun);
-		return 0;
-	}
-
-	memset(scsi_cmd, 0, MAX_COMMAND_SIZE);
-	scsi_cmd[0] = INQUIRY;
-	scsi_cmd[1] = 0x01;
-	scsi_cmd[2] = 0x80;
-	scsi_cmd[4] = max_lgth;
-	sreq->sr_cmd_len = 0;
-	sreq->sr_sense_buffer[0] = 0;
-	sreq->sr_sense_buffer[2] = 0;
-	sreq->sr_data_direction = SCSI_DATA_READ;
-	scsi_wait_req(sreq, (void *) scsi_cmd, (void *) serialnumber_page,
-			max_lgth, SCSI_TIMEOUT+4*HZ, 3);
-
-	if (sreq->sr_result)
-		goto leave;
-
-	/*
-	 * a check to see if response was truncated is superfluous,
-	 * since serialnumber_page[3] cannot be larger than 255
-	 */
-
-	sdev->sdev_driverfs_dev.name[0] = SCSI_UID_SER_NUM;
-	strncat(sdev->sdev_driverfs_dev.name, sdev->vendor, 8);
-	strncat(sdev->sdev_driverfs_dev.name, sdev->model, 16);
-	len = serialnumber_page[3];
-	if (len > DEVICE_NAME_SIZE-26)
-		len = DEVICE_NAME_SIZE-26;
-	strncat(sdev->sdev_driverfs_dev.name, &serialnumber_page[4], len);
-	kfree(serialnumber_page);
-	return 1;
- leave:
-	memset(sdev->sdev_driverfs_dev.name, 0, DEVICE_NAME_SIZE);
-	kfree(serialnumber_page);
-	return 0;
-}
-
-/**
- * scsi_get_default_name - get a default name
- * @sdev:	get a default name for this device
- *
- * Description:
- *     Set the name of @sdev (of size DEVICE_NAME_SIZE > 29) to the
- *     concatenation of the vendor, model, and revision found in @sdev.
- *
- * Return:
- *     1: Success
- **/
-int scsi_get_default_name(Scsi_Device *sdev)
-{
-	sdev->sdev_driverfs_dev.name[0] = SCSI_UID_UNKNOWN;
-	strncpy(&sdev->sdev_driverfs_dev.name[1], sdev->vendor, 8);
-	strncat(sdev->sdev_driverfs_dev.name, sdev->model, 16);
-	strncat(sdev->sdev_driverfs_dev.name, sdev->rev, 4);
-	return 1;
-}
-
-/**
- * scsi_load_identifier:
- * @sdev:	get an identifier (name) of this device
- * @sreq:	Scsi_Requeset associated with @sdev
- *
- * Description:
- *     Determine what INQUIRY pages are supported by @sdev, and try the
- *     different pages until we get an identifier, or no other pages are
- *     left. Start with page 0x83 (device id) and then try page 0x80
- *     (serial number). If neither of these pages gets an id, use the
- *     default naming convention.
- *
- *     The first character of sdev_driverfs_dev.name is SCSI_UID_SER_NUM
- *     (S) if we used page 0x80, SCSI_UID_UNKNOWN (Z) if we used the
- *     default name, otherwise it starts with the page 0x83 id type
- *     (see the SCSI Primary Commands specification for details).
- *
- * Notes:
- *     If a device returns the same serial number for different LUNs or
- *     even for different LUNs on different devices, special handling must
- *     be added to get an id, or a new black list flag must be added (so
- *     we use the default name, or add a way to prefix the id/name with
- *     SCSI_UID_UNKNOWN - and change the define to something meaningful
- *     like SCSI_UID_NOT_UNIQUE). Complete user level scanning would be
- *     nice for such devices, so we do not need device specific code in
- *     the kernel.
- **/
-static void scsi_load_identifier(Scsi_Device *sdev, Scsi_Request *sreq)
-{
-	unsigned char *evpd_page = NULL;
-	int cnt;
-
-	memset(sdev->sdev_driverfs_dev.name, 0, DEVICE_NAME_SIZE);
-	evpd_page = scsi_get_evpd_page(sdev, sreq);
-	if (evpd_page == NULL) {
-		/*
-		 * try to obtain serial number anyway
-		 */
-		(void)scsi_get_serialnumber(sdev, sreq);
-	} else {
-		/*
-		 * XXX search high to low, since the pages are lowest to
-		 * highest - page 0x83 will be after page 0x80.
-		 */
-		for (cnt = 4; cnt <= evpd_page[3] + 3; cnt++)
-			if (evpd_page[cnt] == 0x83)
-				if (scsi_get_deviceid(sdev, sreq))
-					goto leave;
-
-		for (cnt = 4; cnt <= evpd_page[3] + 3; cnt++)
-			if (evpd_page[cnt] == 0x80)
-				if (scsi_get_serialnumber(sdev, sreq))
-					goto leave;
-
-		if (sdev->sdev_driverfs_dev.name[0] == 0)
-			scsi_get_default_name(sdev);
-
-	}
-leave:
-	if (evpd_page) kfree(evpd_page);
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: host %d channel %d"
-	    " id %d lun %d name/id: '%s'\n", sdev->host->host_no,
-	    sdev->channel, sdev->id, sdev->lun, sdev->sdev_driverfs_dev.name));
-}
-
-/**
  * scsi_probe_lun - probe a single LUN using a SCSI INQUIRY
  * @sreq:	used to send the INQUIRY
  * @inq_result:	area to store the INQUIRY result
@@ -1126,11 +651,29 @@
 	return;
 }
 
+static void scsi_set_name(struct scsi_device *sdev, char *inq_result)
+{
+	int i;
+	char type[72];
+
+	i = inq_result[0] & 0x1f;
+	if (i < MAX_SCSI_DEVICE_CODE)
+		strcpy(type, scsi_device_types[i]);
+	else
+		strcpy(type, "Unknown");
+
+	i = strlen(type) - 1;
+	while (i >= 0 && type[i] == ' ')
+		type[i--] = '\0';
+
+	snprintf(sdev->sdev_driverfs_dev.name, DEVICE_NAME_SIZE, "SCSI %s",
+		 type);
+}
+
 /**
  * scsi_add_lun - allocate and fully initialze a Scsi_Device
  * @sdevscan:	holds information to be stored in the new Scsi_Device
  * @sdevnew:	store the address of the newly allocated Scsi_Device
- * @sreq:	scsi request used when getting an identifier
  * @inq_result:	holds the result of a previous INQUIRY to the LUN
  * @bflags:	black/white list flag
  *
@@ -1144,8 +687,7 @@
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a Scsi_Device
  *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
  **/
-static int scsi_add_lun(Scsi_Device *sdev, Scsi_Request *sreq,
-		char *inq_result, int *bflags)
+static int scsi_add_lun(Scsi_Device *sdev, char *inq_result, int *bflags)
 {
 	struct scsi_device *sdev_sibling;
 	struct scsi_target *starget;
@@ -1204,6 +746,8 @@
 
 	sdev->random = (sdev->type == TYPE_TAPE) ? 0 : 1;
 
+	scsi_set_name(sdev, inq_result);
+
 	print_inquiry(inq_result);
 
 	/*
@@ -1240,15 +784,6 @@
 	if (inq_result[7] & 0x10)
 		sdev->sdtr = 1;
 
-	/*
-	 * XXX maybe move the identifier and driverfs/devfs setup to a new
-	 * function, and call them after this function is called.
-	 *
-	 * scsi_load_identifier is the only reason sreq is needed in this
-	 * function.
-	 */
-	scsi_load_identifier(sdev, sreq);
-	
 	scsi_device_register(sdev);
 
 	sprintf(sdev->devfs_name, "scsi/host%d/bus%d/target%d/lun%d",
@@ -1376,7 +911,7 @@
 		goto out_free_result;
 	}
 
-	res = scsi_add_lun(sdev, sreq, result, &bflags);
+	res = scsi_add_lun(sdev, result, &bflags);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
