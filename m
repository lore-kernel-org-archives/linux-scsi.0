From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] move all of scsi_static_device_list into initdata
Date: Thu, 21 Nov 2002 16:22:59 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121162259.A24215@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: JEJ Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Only the pointers in scsi_static_device_list were going into the
initdata section.

This patch fixes that by using char arrays rather than char pointers.
The table increased in size by 96 bytes, but the init.data size
increased by 1488 bytes, and the rodata decreased by 1392 bytes.

The size checking (previously generated only a message) was removed
since the function it is in no longer can figure out the length, so it
now silently truncates.

The only change in scsi_static_device_list itself is to change all
the NULL's to empty strings.

--- 1.70/drivers/scsi/scsi.c	Thu Nov 21 07:51:33 2002
+++ edited/drivers/scsi/scsi.c	Thu Nov 21 16:13:41 2002
@@ -1615,12 +1615,12 @@
  * scsi_strcpy_devinfo: called from scsi_dev_info_list_add to copy into
  * devinfo vendor and model strings.
  */
-static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
-				char *from, int compatible)
+static void scsi_strcpy_devinfo(char *to, size_t to_length, char *from,
+				int compatible)
 {
 	size_t from_length;
 
-	from_length = strlen(from);
+	from_length = strnlen(from, to_length);
 	strncpy(to, from, min(to_length, from_length));
 	if (from_length < to_length) {
 		if (compatible) {
@@ -1636,9 +1636,6 @@
 				to_length - from_length);
 		}
 	}
-	if (from_length > to_length)
-		 printk(KERN_WARNING "%s: %s string '%s' is too long\n",
-			__FUNCTION__, name, from);
 }
 
 /**
@@ -1667,10 +1664,10 @@
 		return -ENOMEM;
 	}
 
-	scsi_strcpy_devinfo("vendor", devinfo->vendor, sizeof(devinfo->vendor),
-			    vendor, compatible);
-	scsi_strcpy_devinfo("model", devinfo->model, sizeof(devinfo->model),
-			    model, compatible);
+	scsi_strcpy_devinfo(devinfo->vendor, sizeof(devinfo->vendor), vendor,
+			    compatible);
+	scsi_strcpy_devinfo(devinfo->model, sizeof(devinfo->model), model,
+			    compatible);
 
 	if (strflags)
 		devinfo->flags = simple_strtoul(strflags, NULL, 0);
@@ -1753,7 +1750,7 @@
 
 	if (scsi_dev_info_list_add_str(dev_list) == -ENOMEM)
 		return;
-	for (i = 0; scsi_static_device_list[i].vendor != NULL; i++)
+	for (i = 0; scsi_static_device_list[i].vendor[0] != '\0'; i++)
 		if (scsi_dev_info_list_add(1 /* compatibile */,
 			   scsi_static_device_list[i].vendor,
 			   scsi_static_device_list[i].model,
===== drivers/scsi/scsi.h 1.48 vs edited =====
--- 1.48/drivers/scsi/scsi.h	Thu Nov 21 07:51:33 2002
+++ edited/drivers/scsi/scsi.h	Thu Nov 21 13:31:26 2002
@@ -531,9 +531,9 @@
  * dev_info: for the black/white list in the old scsi_static_device_list
  */
 struct dev_info {
-	char *vendor;
-	char *model;
-	char *revision;	/* revision known to be bad, unused */
+	char vendor[8];
+	char model[16];
+	char revision[4];	/* revision known to be bad, unused */
 	unsigned flags;
 };
 
===== drivers/scsi/scsi_scan.c 1.41 vs edited =====
--- 1.41/drivers/scsi/scsi_scan.c	Thu Nov 21 01:01:56 2002
+++ edited/drivers/scsi/scsi_scan.c	Thu Nov 21 13:28:06 2002
@@ -100,7 +100,7 @@
 	{"SONY", "CD-ROM CDU-541", "4.3d", BLIST_NOLUN},
 	{"SONY", "CD-ROM CDU-55S", "1.0i", BLIST_NOLUN},
 	{"SONY", "CD-ROM CDU-561", "1.7x", BLIST_NOLUN},
-	{"SONY", "CD-ROM CDU-8012", NULL, BLIST_NOLUN},
+	{"SONY", "CD-ROM CDU-8012", "", BLIST_NOLUN},
 	{"TANDBERG", "TDC 3600", "U07", BLIST_NOLUN},	/* locks up */
 	{"TEAC", "CD-R55S", "1.0H", BLIST_NOLUN},	/* locks up */
 	/*
@@ -127,61 +127,61 @@
 	{"YAMAHA", "CRW8424S", "1.0", BLIST_NOLUN},	/* locks up */
 	{"YAMAHA", "CRW6416S", "1.0c", BLIST_NOLUN},	/* locks up */
 	{"MITSUMI", "CD-R CR-2201CS", "6119", BLIST_NOLUN},	/* locks up */
-	{"RELISYS", "Scorpio", NULL, BLIST_NOLUN},	/* responds to all lun */
+	{"RELISYS", "Scorpio", "", BLIST_NOLUN},	/* responds to all lun */
 	{"MICROTEK", "ScanMaker II", "5.61", BLIST_NOLUN},	/* responds to all lun */
 
 	/*
 	 * Other types of devices that have special flags.
 	 */
-	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
+	{"SONY", "CD-ROM CDU-8001", "", BLIST_BORKEN},
 	{"TEXEL", "CD-ROM", "1.06", BLIST_BORKEN},
-	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
-	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
-	{"INSITE", "I325VM", NULL, BLIST_KEY},
+	{"IOMEGA", "Io20S         *F", "", BLIST_KEY},
+	{"INSITE", "Floptical   F*8I", "", BLIST_KEY},
+	{"INSITE", "I325VM", "", BLIST_KEY},
 	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
-	{"MICROP", "4110", NULL, BLIST_NOTQ},
-	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
-	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"NAKAMICH", "MJ-5.16S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
-	{"CANON", "IPUBJD", NULL, BLIST_SPARSELUN},
-	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
-	{"DEC", "HSG80", NULL, BLIST_FORCELUN},
-	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN},
-	{"COMPAQ", "CR3500", NULL, BLIST_FORCELUN},
-	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"MICROP", "4110", "", BLIST_NOTQ},
+	{"NRC", "MBR-7", "", BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"NRC", "MBR-7.4", "", BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"REGAL", "CDC-4X", "", BLIST_MAX5LUN | BLIST_SINGLELUN},
+	{"NAKAMICH", "MJ-4.8S", "", BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"NAKAMICH", "MJ-5.16S", "", BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"PIONEER", "CD-ROM DRM-600", "", BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"PIONEER", "CD-ROM DRM-602X", "", BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"PIONEER", "CD-ROM DRM-604X", "", BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"EMULEX", "MD21/S2     ESDI", "", BLIST_SINGLELUN},
+	{"CANON", "IPUBJD", "", BLIST_SPARSELUN},
+	{"nCipher", "Fastness Crypto", "", BLIST_FORCELUN},
+	{"DEC", "HSG80", "", BLIST_FORCELUN},
+	{"COMPAQ", "LOGICAL VOLUME", "", BLIST_FORCELUN},
+	{"COMPAQ", "CR3500", "", BLIST_FORCELUN},
+	{"NEC", "PD-1 ODX654P", "", BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"MATSHITA", "PD-1", "", BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
-	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM},
-	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
-	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
-	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, storage on LUN 0 */
-	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, no storage on LUN 0 */
-	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
-	{"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},
-	{"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN},	/* Dell PV 530F */
-	{"DELL", "PV530F", NULL, BLIST_SPARSELUN},
-	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
-	{"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP VA7400 */
-	{"CMD", "CRA-7280", NULL, BLIST_SPARSELUN},	/* CMD RAID Controller */
-	{"CNSI", "G7324", NULL, BLIST_SPARSELUN},	/* Chaparral G7324 RAID */
-	{"CNSi", "G8324", NULL, BLIST_SPARSELUN},	/* Chaparral G8324 RAID */
-	{"Zzyzx", "RocketStor 500S", NULL, BLIST_SPARSELUN},
-	{"Zzyzx", "RocketStor 2000", NULL, BLIST_SPARSELUN},
-	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
-	{"DELL", "PERCRAID", NULL, BLIST_FORCELUN},
-	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
-	{"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},
-	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
-	{"COMPAQ", "MSA1000", NULL, BLIST_FORCELUN},
-	{"HP", "C1557A", NULL, BLIST_FORCELUN},
-	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
-	{ NULL, NULL, NULL, 0 },
+	{"TOSHIBA", "CDROM", "", BLIST_ISROM},
+	{"TOSHIBA", "CD-ROM", "", BLIST_ISROM},
+	{"MegaRAID", "LD", "", BLIST_FORCELUN},
+	{"DGC", "RAID", "", BLIST_SPARSELUN},	/* Dell PV 650F, storage on LUN 0 */
+	{"DGC", "DISK", "", BLIST_SPARSELUN},	/* Dell PV 650F, no storage on LUN 0 */
+	{"DELL", "PV660F", "", BLIST_SPARSELUN},
+	{"DELL", "PV660F   PSEUDO", "", BLIST_SPARSELUN},
+	{"DELL", "PSEUDO DEVICE .", "", BLIST_SPARSELUN},	/* Dell PV 530F */
+	{"DELL", "PV530F", "", BLIST_SPARSELUN},
+	{"EMC", "SYMMETRIX", "", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
+	{"HP", "A6189A", "", BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP VA7400 */
+	{"CMD", "CRA-7280", "", BLIST_SPARSELUN},	/* CMD RAID Controller */
+	{"CNSI", "G7324", "", BLIST_SPARSELUN},	/* Chaparral G7324 RAID */
+	{"CNSi", "G8324", "", BLIST_SPARSELUN},	/* Chaparral G8324 RAID */
+	{"Zzyzx", "RocketStor 500S", "", BLIST_SPARSELUN},
+	{"Zzyzx", "RocketStor 2000", "", BLIST_SPARSELUN},
+	{"SONY", "TSL", "", BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
+	{"DELL", "PERCRAID", "", BLIST_FORCELUN},
+	{"HP", "NetRAID-4M", "", BLIST_FORCELUN},
+	{"ADAPTEC", "AACRAID", "", BLIST_FORCELUN},
+	{"ADAPTEC", "Adaptec 5400S", "", BLIST_FORCELUN},
+	{"COMPAQ", "MSA1000", "", BLIST_FORCELUN},
+	{"HP", "C1557A", "", BLIST_FORCELUN},
+	{"IBM", "AuSaV1S2", "", BLIST_FORCELUN},
+	{ "", "", "", 0 },
 };
 
 #define ALLOC_FAILURE_MSG	KERN_ERR "%s: Allocation failure during" \

-- Patrick Mansfield
