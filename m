From: "goggin, edward" <egoggin@emc.com>
Subject: proposed update to scsi_id needing review
Date: Thu, 9 Jun 2005 19:15:42 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AA82@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:24512 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP id S262414AbVFIXQL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2005 19:16:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-hotplug-devel@lists.sourceforge.net'" <linux-hotplug-devel@lists.sourceforge.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "'patman@aracnet.com'" <patman@aracnet.com>

This patch is to enable the use of scsi_id to derive a UID for a SCSI-2
device
which is not compliant with the page 83 inquiry reply format for either
SPC-2
or SPC-3.  In this case, the page 83 reply does not contain a list of
Identification
descriptors but a single binary encoded hexa-decimal Vendor Specified
Identifier.

The update is being driven by the need for scsi_id to support older model
EMC Symmetrix hardware, that is, models 4, 5, and 6.

diff -u scsi_id-0.9/scsi_id.8 scsi_id-0.9.update5/scsi_id.8
--- scsi_id-0.9/scsi_id.8	2005-05-26 11:43:37.000000000 -0400
+++ scsi_id-0.9.update5/scsi_id.8	2005-06-07 15:13:42.000256000 -0400
@@ -87,10 +87,18 @@
 Prefix the identification string with the  driver model (sysfs) bus id of
 the SCSI device.
 .TP
-.BI \-p "\| 0x80 | 0x83"
-Use SCSI INQUIRY VPD page code 0x80 or 0x83. The default behaviour is to
-query the available VPD pages, and use page 0x83 if found, else page 0x80
-if found, else nothing.
+.BI \-p "\| 0x80 | 0x83 | pre-spc3-83"
+Use SCSI INQUIRY VPD page code 0x80, 0x83, or pre-spc3-83.
+.sp
+The default
+behaviour is to query the availabe VPD pages, and use page 0x83 if found,
+else page 0x80 if found, else nothing.
+.sp
+Page pre-spc3-83 should only be utilized for those scsi devices which
+are not compliant with the SPC-2 or SPC-3 format for page 83.  While this
+option is used for older model 4, 5, and 6 EMC Symmetrix devices, its
+use with SPC-2 or SPC-3 compliant devices will fallback to the page 83
+format supported by these devices.
 .TP
 .BI \-s "\| sysfs\-device"
 Generate an id for the
diff -u scsi_id-0.9/scsi_id.c scsi_id-0.9.update5/scsi_id.c
--- scsi_id-0.9/scsi_id.c	2005-05-26 11:43:37.000000000 -0400
+++ scsi_id-0.9.update5/scsi_id.c	2005-06-06 14:31:26.000256000 -0400
@@ -66,7 +66,7 @@
 static int sys_specified;
 static char config_file[MAX_NAME_LEN] = SCSI_ID_CONFIG_FILE;
 static int display_bus_id;
-static int default_page_code;
+static enum page_code default_page_code;
 static int use_stderr;
 static int debug;
 static int hotplug_mode;
@@ -445,9 +445,11 @@
 
 		case 'p':
 			if (strcmp(optarg, "0x80") == 0) {
-				default_page_code = 0x80;
+				default_page_code = PAGE_80;
 			} else if (strcmp(optarg, "0x83") == 0) {
-				default_page_code = 0x83;
+				default_page_code = PAGE_83;
+			} else if (strcmp(optarg, "pre-spc3-83") == 0) {
+				default_page_code = PAGE_83_PRE_SPC3; 
 			} else {
 				log_message(LOG_WARNING,
 					    "Unknown page code '%s'\n",
optarg);
@@ -544,9 +546,11 @@
 
 		case 'p':
 			if (strcmp(optarg, "0x80") == 0) {
-				*page_code = 0x80;
+				*page_code = PAGE_80;
 			} else if (strcmp(optarg, "0x83") == 0) {
-				*page_code = 0x83;
+				*page_code = PAGE_83;
+			} else if (strcmp(optarg, "pre-spc3-83") == 0) {
+				*page_code = PAGE_83_PRE_SPC3; 
 			} else {
 				log_message(LOG_WARNING,
 					    "Unknown page code '%s'\n",
optarg);
diff -u scsi_id-0.9/scsi_id.config scsi_id-0.9.update5/scsi_id.config
--- scsi_id-0.9/scsi_id.config	2005-05-26 11:43:37.000000000 -0400
+++ scsi_id-0.9.update5/scsi_id.config	2005-06-06 15:42:41.000256000 -0400
@@ -41,3 +41,8 @@
 # if you rely on the id for persistent naming or multi-path configuration.
 
 ## vendor=ELBONIA, model=borken, options=-b
+
+# EMC SYMMETRIX models 4 and 5, and some model 6 systems return the VSI
+# field of the page 83 reply according to SCSI-2 format.  This format is
+# binary encoded hexa-decimal as opposed to the Identifiscation descriptor
+# utilized by both SPC-2 and SPC-3 compliant systems.
diff -u scsi_id-0.9/scsi_id.h scsi_id-0.9.update5/scsi_id.h
--- scsi_id-0.9/scsi_id.h	2005-05-26 11:43:37.000000000 -0400
+++ scsi_id-0.9.update5/scsi_id.h	2005-06-06 14:32:32.000256000 -0400
@@ -53,3 +53,13 @@
 #ifndef u8
 typedef unsigned char u8;
 #endif
+
+/*
+ * Page code values. 
+ */
+enum page_code {
+		PAGE_83_PRE_SPC3 = -0x83,
+		PAGE_UNSPECIFIED = 0x00,
+		PAGE_80		 = 0x80,
+		PAGE_83		 = 0x83,
+};
diff -u scsi_id-0.9/scsi_serial.c scsi_id-0.9.update5/scsi_serial.c
--- scsi_id-0.9/scsi_serial.c	2005-05-26 11:43:37.000000000 -0400
+++ scsi_id-0.9.update5/scsi_serial.c	2005-06-07 15:05:45.000256000 -0400
@@ -560,12 +560,12 @@
 	unsigned char page_83[SCSI_INQ_BUFF_LEN];
 
 	memset(page_83, 0, SCSI_INQ_BUFF_LEN);
-	retval = scsi_inquiry(scsi_dev, fd, 1, 0x83, page_83,
+	retval = scsi_inquiry(scsi_dev, fd, 1, PAGE_83, page_83,
 			      SCSI_INQ_BUFF_LEN);
 	if (retval < 0)
 		return 1;
 
-	if (page_83[1] != 0x83) {
+	if (page_83[1] != PAGE_83) {
 		log_message(LOG_WARNING, "%s: Invalid page 0x83\n",
 			    scsi_dev->name);
 		return 1;
@@ -609,6 +609,74 @@
 	return 1;
 }
 
+/*
+ * Get device identification VPD page for older SCSI-2 device which is not
+ * compliant with either SPC-2 or SPC-3 format.
+ *
+ * Return the hard coded error code value 2 if the page 83 reply is not
+ * conformant to the SCSI-2 format.
+ */
+static int do_scsi_page83_prespc3_inquiry(struct sysfs_device *scsi_dev,
int fd,
+				          char *serial, int len)
+{
+	int retval;
+	int i, j;
+	unsigned char page_83[SCSI_INQ_BUFF_LEN];
+
+	memset(page_83, 0, SCSI_INQ_BUFF_LEN);
+	retval = scsi_inquiry(scsi_dev, fd, 1, PAGE_83, page_83,
SCSI_INQ_BUFF_LEN);
+	if (retval < 0)
+		return 1;
+
+	if (page_83[1] != PAGE_83) {
+		log_message(LOG_WARNING, "%s: Invalid page 0x83\n",
scsi_dev->name);
+		return 1;
+	}
+	/*
+	 * Model 4, 5, and (some) model 6 EMC Symmetrix devices return
+	 * a page 83 reply according to SCSI-2 format instead of SPC-2/3.
+	 *
+	 * The SCSI-2 page 83 format returns an IEEE WWN in binary
+	 * encoded hexi-decimal in the 16 bytes following the initial
+	 * 4-byte page 83 reply header.
+	 *
+	 * Both the SPC-2 and SPC-3 formats return an IEEE WWN as part
+	 * of an Identification descriptor.  The 3rd byte of the first
+	 * Identification descriptor is a reserved (BSZ) byte field.
+	 *
+	 * Reference the 7th byte of the page 83 reply to determine
+	 * whether the reply is compliant with SCSI-2 or SPC-2/3
+	 * specifications.  A zero value in the 7th byte indicates
+	 * an SPC-2/3 conformant reply, (i.e., the reserved field of the
+	 * first Identification descriptor).  This byte will be non-zero
+	 * for a SCSI-2 conformant page 83 reply from these EMC
+	 * Symmetrix models since the 7th byte of the reply corresponds
+	 * to the 4th and 5th nibbles of the 6-byte OUI for EMC, that is,
+	 * 0x006048.
+	 */
+	if (page_83[6] == 0)
+		return 2;
+
+	serial[0] = hex_str[id_search_list[0].id_type];
+	/*
+	 * The first four bytes contain data, not a descriptor.
+	 */
+	i = 4;
+	j = strlen(serial);
+	/*
+	 * Binary descriptor, convert to ASCII,
+	 * using two bytes of ASCII for each byte
+	 * in the page_83.
+	 */
+	while (i < (page_83[3]+4)) {
+		serial[j++] = hex_str[(page_83[i] & 0xf0) >> 4];
+		serial[j++] = hex_str[page_83[i] & 0x0f];
+		i++;
+	}
+	dprintf("using pre-spc3-83 for %s.\n", scsi_dev->name);
+	return 0;
+}
+
 /* Get unit serial number VPD page */
 static int do_scsi_page80_inquiry(struct sysfs_device *scsi_dev, int fd,
 				  char *serial, int max_len)
@@ -620,11 +688,11 @@
 	unsigned char buf[SCSI_INQ_BUFF_LEN];
 
 	memset(buf, 0, SCSI_INQ_BUFF_LEN);
-	retval = scsi_inquiry(scsi_dev, fd, 1, 0x80, buf,
SCSI_INQ_BUFF_LEN);
+	retval = scsi_inquiry(scsi_dev, fd, 1, PAGE_80, buf,
SCSI_INQ_BUFF_LEN);
 	if (retval < 0)
 		return retval;
 
-	if (buf[1] != 0x80) {
+	if (buf[1] != PAGE_80) {
 		log_message(LOG_WARNING, "%s: Invalid page 0x80\n",
 			    scsi_dev->name);
 		return 1;
@@ -667,7 +735,7 @@
 		return 1;
 	}
 
-	if (page_code == 0x80) {
+	if (page_code == PAGE_80) {
 		if (do_scsi_page80_inquiry(scsi_dev, fd, serial, len)) {
 			retval = 1;
 			goto completed;
@@ -675,7 +743,7 @@
 			retval = 0;
 			goto completed;
 		}
-	} else if (page_code == 0x83) {
+	} else if (page_code == PAGE_83) {
 		if (do_scsi_page83_inquiry(scsi_dev, fd, serial, len)) {
 			retval = 1;
 			goto completed;
@@ -683,6 +751,31 @@
 			retval = 0;
 			goto completed;
 		}
+	} else if (page_code == PAGE_83_PRE_SPC3) {
+		retval = do_scsi_page83_prespc3_inquiry(scsi_dev, fd,
serial, len);
+		if (retval) {
+			/*
+			 * Fallback to servicing a SPC-2/3 compliant page 83
+			 * inquiry if the page 83 reply format does not
+			 * conform to pre-SPC3 expectations.
+			 */
+			if (retval == 2) {
+				if (do_scsi_page83_inquiry(scsi_dev, fd,
serial, len)) {
+					retval = 1;
+					goto completed;
+				} else  {
+					retval = 0;
+					goto completed;
+				}
+			}
+			else {
+				retval = 1;
+				goto completed;
+			}
+		} else  {
+			retval = 0;
+			goto completed;
+		}
 	} else if (page_code != 0x00) {
 		log_message(LOG_WARNING, "%s: unsupported page code 0x%d\n",
 			    scsi_dev->name, page_code);
@@ -706,7 +799,7 @@
 	dprintf("%s: Checking page0\n", scsi_dev->name);
 
 	for (ind = 4; ind <= page0[3] + 3; ind++)
-		if (page0[ind] == 0x83)
+		if (page0[ind] == PAGE_83)
 			if (!do_scsi_page83_inquiry(scsi_dev, fd, serial,
 						    len)) {
 				/*
@@ -717,7 +810,7 @@
 			}
 
 	for (ind = 4; ind <= page0[3] + 3; ind++)
-		if (page0[ind] == 0x80)
+		if (page0[ind] == PAGE_80)
 			if (!do_scsi_page80_inquiry(scsi_dev, fd, serial,
 						    len)) {
 				/*
