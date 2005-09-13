From: "goggin, edward" <egoggin@emc.com>
Subject: proposed update to scsi_id needing review
Date: Tue, 13 Sep 2005 12:48:43 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AC87@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5B882.FF8ED297"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:38769 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP id S964881AbVIMQuA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 12:50:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-hotplug-devel@lists.sourceforge.net'" <linux-hotplug-devel@lists.sourceforge.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "'patman@aracnet.com'" <patman@aracnet.com>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5B882.FF8ED297
Content-Type: text/plain

Resending (original on June 9th) this patch notice after merging these
scsi_id changes into the version of scsi_id found in udev-068.

This patch is to enable the use of scsi_id to derive a UID for a SCSI-2
device which is not compliant with the page 83 inquiry reply format for
either SPC-2 or SPC-3.  In this case, the page 83 reply does not
contain a list of  Identification descriptors but a single binary encoded
hexa-decimal Vendor Specified Identifier.

The update is being driven by the need for scsi_id to support older
model EMC Symmetrix hardware, that is, models 4, 5, and 6.

 <<scsi_id.patch>> 

------_=_NextPart_000_01C5B882.FF8ED297
Content-Type: application/octet-stream;
	name="scsi_id.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="scsi_id.patch"

diff -u udev-068/extras/scsi_id/scsi_id.8 scsi_id/scsi_id.8=0A=
--- udev-068/extras/scsi_id/scsi_id.8	2005-08-18 12:04:49.000000000 =
-0500=0A=
+++ scsi_id/scsi_id.8	2005-09-13 03:09:40.000000000 -0500=0A=
@@ -91,10 +91,18 @@=0A=
 Prefix the identification string with the  driver model (sysfs) bus id =
of=0A=
 the SCSI device.=0A=
 .TP=0A=
-.BI \-p "\| 0x80 | 0x83"=0A=
-Use SCSI INQUIRY VPD page code 0x80 or 0x83. The default behaviour is =
to=0A=
-query the available VPD pages, and use page 0x83 if found, else page =
0x80=0A=
-if found, else nothing.=0A=
+.BI \-p "\| 0x80 | 0x83 | pre-spc3-83"=0A=
+Use SCSI INQUIRY VPD page code 0x80, 0x83, or pre-spc3-83.=0A=
+.sp=0A=
+The default=0A=
+behaviour is to query the availabe VPD pages, and use page 0x83 if =
found,=0A=
+else page 0x80 if found, else nothing.=0A=
+.sp=0A=
+Page pre-spc3-83 should only be utilized for those scsi devices =
which=0A=
+are not compliant with the SPC-2 or SPC-3 format for page 83.  While =
this=0A=
+option is used for older model 4, 5, and 6 EMC Symmetrix devices, =
its=0A=
+use with SPC-2 or SPC-3 compliant devices will fallback to the page =
83=0A=
+format supported by these devices.=0A=
 .TP=0A=
 .BI \-s "\| sysfs\-device"=0A=
 Generate an id for the=0A=
diff -u udev-068/extras/scsi_id/scsi_id.c scsi_id/scsi_id.c=0A=
--- udev-068/extras/scsi_id/scsi_id.c	2005-08-18 12:04:49.000000000 =
-0500=0A=
+++ scsi_id/scsi_id.c	2005-09-13 03:33:52.000000000 -0500=0A=
@@ -67,7 +67,7 @@=0A=
 static int sys_specified;=0A=
 static char config_file[MAX_NAME_LEN] =3D SCSI_ID_CONFIG_FILE;=0A=
 static int display_bus_id;=0A=
-static int default_page_code;=0A=
+static enum page_code default_page_code;=0A=
 static int use_stderr;=0A=
 static int debug;=0A=
 static int hotplug_mode;=0A=
@@ -519,9 +519,11 @@=0A=
 =0A=
 		case 'p':=0A=
 			if (strcmp(optarg, "0x80") =3D=3D 0) {=0A=
-				default_page_code =3D 0x80;=0A=
+				default_page_code =3D PAGE_80;=0A=
 			} else if (strcmp(optarg, "0x83") =3D=3D 0) {=0A=
-				default_page_code =3D 0x83;=0A=
+				default_page_code =3D PAGE_83;=0A=
+			} else if (strcmp(optarg, "pre-spc3-83") =3D=3D 0) {=0A=
+				default_page_code =3D PAGE_83_PRE_SPC3; =0A=
 			} else {=0A=
 				log_message(LOG_WARNING,=0A=
 					    "Unknown page code '%s'\n", optarg);=0A=
@@ -640,9 +642,11 @@=0A=
 =0A=
 		case 'p':=0A=
 			if (strcmp(optarg, "0x80") =3D=3D 0) {=0A=
-				*page_code =3D 0x80;=0A=
+				*page_code =3D PAGE_80;=0A=
 			} else if (strcmp(optarg, "0x83") =3D=3D 0) {=0A=
-				*page_code =3D 0x83;=0A=
+				*page_code =3D PAGE_83;=0A=
+			} else if (strcmp(optarg, "pre-spc3-83") =3D=3D 0) {=0A=
+				*page_code =3D PAGE_83_PRE_SPC3; =0A=
 			} else {=0A=
 				log_message(LOG_WARNING,=0A=
 					    "Unknown page code '%s'\n", optarg);=0A=
diff -u udev-068/extras/scsi_id/scsi_id.config =
scsi_id/scsi_id.config=0A=
--- udev-068/extras/scsi_id/scsi_id.config	2005-08-18 =
12:04:49.000000000 -0500=0A=
+++ scsi_id/scsi_id.config	2005-09-13 03:01:27.000000000 -0500=0A=
@@ -41,3 +41,8 @@=0A=
 # if you rely on the id for persistent naming or multi-path =
configuration.=0A=
 =0A=
 ## vendor=3DELBONIA, model=3Dborken, options=3D-b=0A=
+=0A=
+# EMC SYMMETRIX models 4 and 5, and some model 6 systems return the =
VSI=0A=
+# field of the page 83 reply according to SCSI-2 format.  This format =
is=0A=
+# binary encoded hexa-decimal as opposed to the Identifiscation =
descriptor=0A=
+# utilized by both SPC-2 and SPC-3 compliant systems.=0A=
diff -u udev-068/extras/scsi_id/scsi_id.h scsi_id/scsi_id.h=0A=
--- udev-068/extras/scsi_id/scsi_id.h	2005-08-18 12:04:49.000000000 =
-0500=0A=
+++ scsi_id/scsi_id.h	2005-09-13 03:00:10.000000000 -0500=0A=
@@ -53,3 +53,13 @@=0A=
 #ifndef u8=0A=
 typedef unsigned char u8;=0A=
 #endif=0A=
+=0A=
+/*=0A=
+ * Page code values. =0A=
+ */=0A=
+enum page_code {=0A=
+		PAGE_83_PRE_SPC3 =3D -0x83,=0A=
+		PAGE_UNSPECIFIED =3D 0x00,=0A=
+		PAGE_80		 =3D 0x80,=0A=
+		PAGE_83		 =3D 0x83,=0A=
+};=0A=
diff -u udev-068/extras/scsi_id/scsi_serial.c scsi_id/scsi_serial.c=0A=
--- udev-068/extras/scsi_id/scsi_serial.c	2005-08-18 12:04:49.000000000 =
-0500=0A=
+++ scsi_id/scsi_serial.c	2005-09-13 04:44:18.000000000 -0500=0A=
@@ -567,12 +567,12 @@=0A=
 	unsigned char page_83[SCSI_INQ_BUFF_LEN];=0A=
 =0A=
 	memset(page_83, 0, SCSI_INQ_BUFF_LEN);=0A=
-	retval =3D scsi_inquiry(scsi_dev, fd, 1, 0x83, page_83,=0A=
+	retval =3D scsi_inquiry(scsi_dev, fd, 1, PAGE_83, page_83,=0A=
 			      SCSI_INQ_BUFF_LEN);=0A=
 	if (retval < 0)=0A=
 		return 1;=0A=
 =0A=
-	if (page_83[1] !=3D 0x83) {=0A=
+	if (page_83[1] !=3D PAGE_83) {=0A=
 		log_message(LOG_WARNING, "%s: Invalid page 0x83\n",=0A=
 			    scsi_dev->name);=0A=
 		return 1;=0A=
@@ -616,6 +616,74 @@=0A=
 	return 1;=0A=
 }=0A=
 =0A=
+/*=0A=
+ * Get device identification VPD page for older SCSI-2 device which is =
not=0A=
+ * compliant with either SPC-2 or SPC-3 format.=0A=
+ *=0A=
+ * Return the hard coded error code value 2 if the page 83 reply is =
not=0A=
+ * conformant to the SCSI-2 format.=0A=
+ */=0A=
+static int do_scsi_page83_prespc3_inquiry(struct sysfs_device =
*scsi_dev, int fd,=0A=
+				          char *serial, int len)=0A=
+{=0A=
+	int retval;=0A=
+	int i, j;=0A=
+	unsigned char page_83[SCSI_INQ_BUFF_LEN];=0A=
+=0A=
+	memset(page_83, 0, SCSI_INQ_BUFF_LEN);=0A=
+	retval =3D scsi_inquiry(scsi_dev, fd, 1, PAGE_83, page_83, =
SCSI_INQ_BUFF_LEN);=0A=
+	if (retval < 0)=0A=
+		return 1;=0A=
+=0A=
+	if (page_83[1] !=3D PAGE_83) {=0A=
+		log_message(LOG_WARNING, "%s: Invalid page 0x83\n", =
scsi_dev->name);=0A=
+		return 1;=0A=
+	}=0A=
+	/*=0A=
+	 * Model 4, 5, and (some) model 6 EMC Symmetrix devices return=0A=
+	 * a page 83 reply according to SCSI-2 format instead of SPC-2/3.=0A=
+	 *=0A=
+	 * The SCSI-2 page 83 format returns an IEEE WWN in binary=0A=
+	 * encoded hexi-decimal in the 16 bytes following the initial=0A=
+	 * 4-byte page 83 reply header.=0A=
+	 *=0A=
+	 * Both the SPC-2 and SPC-3 formats return an IEEE WWN as part=0A=
+	 * of an Identification descriptor.  The 3rd byte of the first=0A=
+	 * Identification descriptor is a reserved (BSZ) byte field.=0A=
+	 *=0A=
+	 * Reference the 7th byte of the page 83 reply to determine=0A=
+	 * whether the reply is compliant with SCSI-2 or SPC-2/3=0A=
+	 * specifications.  A zero value in the 7th byte indicates=0A=
+	 * an SPC-2/3 conformant reply, (i.e., the reserved field of the=0A=
+	 * first Identification descriptor).  This byte will be non-zero=0A=
+	 * for a SCSI-2 conformant page 83 reply from these EMC=0A=
+	 * Symmetrix models since the 7th byte of the reply corresponds=0A=
+	 * to the 4th and 5th nibbles of the 6-byte OUI for EMC, that is,=0A=
+	 * 0x006048.=0A=
+	 */=0A=
+	if (page_83[6] =3D=3D 0)=0A=
+		return 2;=0A=
+=0A=
+	serial[0] =3D hex_str[id_search_list[0].id_type];=0A=
+	/*=0A=
+	 * The first four bytes contain data, not a descriptor.=0A=
+	 */=0A=
+	i =3D 4;=0A=
+	j =3D strlen(serial);=0A=
+	/*=0A=
+	 * Binary descriptor, convert to ASCII,=0A=
+	 * using two bytes of ASCII for each byte=0A=
+	 * in the page_83.=0A=
+	 */=0A=
+	while (i < (page_83[3]+4)) {=0A=
+		serial[j++] =3D hex_str[(page_83[i] & 0xf0) >> 4];=0A=
+		serial[j++] =3D hex_str[page_83[i] & 0x0f];=0A=
+		i++;=0A=
+	}=0A=
+	dprintf("using pre-spc3-83 for %s.\n", scsi_dev->name);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
 /* Get unit serial number VPD page */=0A=
 static int do_scsi_page80_inquiry(struct sysfs_device *scsi_dev, int =
fd,=0A=
 				  char *serial, int max_len)=0A=
@@ -627,11 +695,11 @@=0A=
 	unsigned char buf[SCSI_INQ_BUFF_LEN];=0A=
 =0A=
 	memset(buf, 0, SCSI_INQ_BUFF_LEN);=0A=
-	retval =3D scsi_inquiry(scsi_dev, fd, 1, 0x80, buf, =
SCSI_INQ_BUFF_LEN);=0A=
+	retval =3D scsi_inquiry(scsi_dev, fd, 1, PAGE_80, buf, =
SCSI_INQ_BUFF_LEN);=0A=
 	if (retval < 0)=0A=
 		return retval;=0A=
 =0A=
-	if (buf[1] !=3D 0x80) {=0A=
+	if (buf[1] !=3D PAGE_80) {=0A=
 		log_message(LOG_WARNING, "%s: Invalid page 0x80\n",=0A=
 			    scsi_dev->name);=0A=
 		return 1;=0A=
@@ -674,7 +742,7 @@=0A=
 		return 1;=0A=
 	}=0A=
 =0A=
-	if (page_code =3D=3D 0x80) {=0A=
+	if (page_code =3D=3D PAGE_80) {=0A=
 		if (do_scsi_page80_inquiry(scsi_dev, fd, serial, len)) {=0A=
 			retval =3D 1;=0A=
 			goto completed;=0A=
@@ -682,7 +750,7 @@=0A=
 			retval =3D 0;=0A=
 			goto completed;=0A=
 		}=0A=
-	} else if (page_code =3D=3D 0x83) {=0A=
+	} else if (page_code =3D=3D PAGE_83) {=0A=
 		if (do_scsi_page83_inquiry(scsi_dev, fd, serial, len)) {=0A=
 			retval =3D 1;=0A=
 			goto completed;=0A=
@@ -690,6 +758,31 @@=0A=
 			retval =3D 0;=0A=
 			goto completed;=0A=
 		}=0A=
+	} else if (page_code =3D=3D PAGE_83_PRE_SPC3) {=0A=
+		retval =3D do_scsi_page83_prespc3_inquiry(scsi_dev, fd, serial, =
len);=0A=
+		if (retval) {=0A=
+			/*=0A=
+			 * Fallback to servicing a SPC-2/3 compliant page 83=0A=
+			 * inquiry if the page 83 reply format does not=0A=
+			 * conform to pre-SPC3 expectations.=0A=
+			 */=0A=
+			if (retval =3D=3D 2) {=0A=
+				if (do_scsi_page83_inquiry(scsi_dev, fd, serial, len)) {=0A=
+					retval =3D 1;=0A=
+					goto completed;=0A=
+				} else  {=0A=
+					retval =3D 0;=0A=
+					goto completed;=0A=
+				}=0A=
+			}=0A=
+			else {=0A=
+				retval =3D 1;=0A=
+				goto completed;=0A=
+			}=0A=
+		} else  {=0A=
+			retval =3D 0;=0A=
+			goto completed;=0A=
+		}=0A=
 	} else if (page_code !=3D 0x00) {=0A=
 		log_message(LOG_WARNING, "%s: unsupported page code 0x%d\n",=0A=
 			    scsi_dev->name, page_code);=0A=
@@ -713,7 +806,7 @@=0A=
 	dprintf("%s: Checking page0\n", scsi_dev->name);=0A=
 =0A=
 	for (ind =3D 4; ind <=3D page0[3] + 3; ind++)=0A=
-		if (page0[ind] =3D=3D 0x83)=0A=
+		if (page0[ind] =3D=3D PAGE_83)=0A=
 			if (!do_scsi_page83_inquiry(scsi_dev, fd, serial,=0A=
 						    len)) {=0A=
 				/*=0A=
@@ -724,7 +817,7 @@=0A=
 			}=0A=
 =0A=
 	for (ind =3D 4; ind <=3D page0[3] + 3; ind++)=0A=
-		if (page0[ind] =3D=3D 0x80)=0A=
+		if (page0[ind] =3D=3D PAGE_80)=0A=
 			if (!do_scsi_page80_inquiry(scsi_dev, fd, serial,=0A=
 						    len)) {=0A=
 				/*=0A=

------_=_NextPart_000_01C5B882.FF8ED297--
