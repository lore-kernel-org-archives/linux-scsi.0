From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] scsi : set target can_queue from devinfo flags
Date: Tue, 13 May 2008 13:45:04 -0400
Message-ID: <1210700704.16304.1.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42990 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbYEMRpH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 13:45:07 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m4DHj5ox006088
	for <linux-scsi@vger.kernel.org>; Tue, 13 May 2008 10:45:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch, discussed in the initial thread on target can_queue limits
(see  http://marc.info/?l=linux-scsi&m=120944296225094&w=2 )
allows the target can_queue limit to be obtained from the device list based on
Inquiry data obtained during scan.

I have pinged several of the array vendors to supply target-port level values
for their arrays. Hopefully, we will see them populate the device list with some
real values shortly.

This patch was cut against scsi-misc-2.6, and depends on Mike Christies patches
contained in the original thread.

-- james s

PS: This sure desires the promoting of the starget in sysfs, with an attribute
    for the can_queue value.



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 scsi_devinfo.c |  437 +++++++++++++++++++++++++++++++--------------------------
 scsi_priv.h    |    5 
 scsi_scan.c    |   13 +
 3 files changed, 251 insertions(+), 204 deletions(-)


diff -upNr a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c	2008-05-05 11:28:09.000000000 -0400
+++ b/drivers/scsi/scsi_devinfo.c	2008-05-13 12:27:59.000000000 -0400
@@ -22,6 +22,7 @@ struct scsi_dev_info_list {
 	char model[16];
 	unsigned flags;
 	unsigned compatible; /* for use with scsi_static_device_list entries */
+	unsigned tgt_qlimit;
 };
 

@@ -44,205 +45,206 @@ static struct {
 	char *model;
 	char *revision;	/* revision known to be bad, unused */
 	unsigned flags;
+	unsigned tgt_qlimit;
 } scsi_static_device_list[] __initdata = {
 	/*
 	 * The following devices are known not to tolerate a lun != 0 scan
 	 * for one reason or another. Some will respond to all luns,
 	 * others will lock up.
 	 */
-	{"Aashima", "IMAGERY 2400SP", "1.03", BLIST_NOLUN},	/* locks up */
-	{"CHINON", "CD-ROM CDS-431", "H42", BLIST_NOLUN},	/* locks up */
-	{"CHINON", "CD-ROM CDS-535", "Q14", BLIST_NOLUN},	/* locks up */
-	{"DENON", "DRD-25X", "V", BLIST_NOLUN},			/* locks up */
-	{"HITACHI", "DK312C", "CM81", BLIST_NOLUN},	/* responds to all lun */
-	{"HITACHI", "DK314C", "CR21", BLIST_NOLUN},	/* responds to all lun */
-	{"IBM", "2104-DU3", NULL, BLIST_NOLUN},		/* locks up */
-	{"IBM", "2104-TU3", NULL, BLIST_NOLUN},		/* locks up */
-	{"IMS", "CDD521/10", "2.06", BLIST_NOLUN},	/* locks up */
-	{"MAXTOR", "XT-3280", "PR02", BLIST_NOLUN},	/* locks up */
-	{"MAXTOR", "XT-4380S", "B3C", BLIST_NOLUN},	/* locks up */
-	{"MAXTOR", "MXT-1240S", "I1.2", BLIST_NOLUN},	/* locks up */
-	{"MAXTOR", "XT-4170S", "B5A", BLIST_NOLUN},	/* locks up */
-	{"MAXTOR", "XT-8760S", "B7B", BLIST_NOLUN},	/* locks up */
-	{"MEDIAVIS", "RENO CD-ROMX2A", "2.03", BLIST_NOLUN},	/* responds to all lun */
-	{"MICROTEK", "ScanMakerIII", "2.30", BLIST_NOLUN},	/* responds to all lun */
-	{"NEC", "CD-ROM DRIVE:841", "1.0", BLIST_NOLUN},/* locks up */
-	{"PHILIPS", "PCA80SC", "V4-2", BLIST_NOLUN},	/* responds to all lun */
-	{"RODIME", "RO3000S", "2.33", BLIST_NOLUN},	/* locks up */
-	{"SUN", "SENA", NULL, BLIST_NOLUN},		/* responds to all luns */
+	{"Aashima", "IMAGERY 2400SP", "1.03", BLIST_NOLUN, 0},	/* locks up */
+	{"CHINON", "CD-ROM CDS-431", "H42", BLIST_NOLUN, 0},	/* locks up */
+	{"CHINON", "CD-ROM CDS-535", "Q14", BLIST_NOLUN, 0},	/* locks up */
+	{"DENON", "DRD-25X", "V", BLIST_NOLUN, 0},		/* locks up */
+	{"HITACHI", "DK312C", "CM81", BLIST_NOLUN, 0},	/* responds to all lun */
+	{"HITACHI", "DK314C", "CR21", BLIST_NOLUN, 0},	/* responds to all lun */
+	{"IBM", "2104-DU3", NULL, BLIST_NOLUN, 0},		/* locks up */
+	{"IBM", "2104-TU3", NULL, BLIST_NOLUN, 0},		/* locks up */
+	{"IMS", "CDD521/10", "2.06", BLIST_NOLUN, 0},	/* locks up */
+	{"MAXTOR", "XT-3280", "PR02", BLIST_NOLUN, 0},	/* locks up */
+	{"MAXTOR", "XT-4380S", "B3C", BLIST_NOLUN, 0},	/* locks up */
+	{"MAXTOR", "MXT-1240S", "I1.2", BLIST_NOLUN, 0},	/* locks up */
+	{"MAXTOR", "XT-4170S", "B5A", BLIST_NOLUN, 0},	/* locks up */
+	{"MAXTOR", "XT-8760S", "B7B", BLIST_NOLUN, 0},	/* locks up */
+	{"MEDIAVIS", "RENO CD-ROMX2A", "2.03", BLIST_NOLUN, 0},	/* responds to all lun */
+	{"MICROTEK", "ScanMakerIII", "2.30", BLIST_NOLUN, 0},	/* responds to all lun */
+	{"NEC", "CD-ROM DRIVE:841", "1.0", BLIST_NOLUN, 0},/* locks up */
+	{"PHILIPS", "PCA80SC", "V4-2", BLIST_NOLUN, 0},	/* responds to all lun */
+	{"RODIME", "RO3000S", "2.33", BLIST_NOLUN, 0},	/* locks up */
+	{"SUN", "SENA", NULL, BLIST_NOLUN, 0},		/* responds to all luns */
 	/*
 	 * The following causes a failed REQUEST SENSE on lun 1 for
 	 * aha152x controller, which causes SCSI code to reset bus.
 	 */
-	{"SANYO", "CRD-250S", "1.20", BLIST_NOLUN},
+	{"SANYO", "CRD-250S", "1.20", BLIST_NOLUN, 0},
 	/*
 	 * The following causes a failed REQUEST SENSE on lun 1 for
 	 * aha152x controller, which causes SCSI code to reset bus.
 	 */
-	{"SEAGATE", "ST157N", "\004|j", BLIST_NOLUN},
-	{"SEAGATE", "ST296", "921", BLIST_NOLUN},	/* responds to all lun */
-	{"SEAGATE", "ST1581", "6538", BLIST_NOLUN},	/* responds to all lun */
-	{"SONY", "CD-ROM CDU-541", "4.3d", BLIST_NOLUN},
-	{"SONY", "CD-ROM CDU-55S", "1.0i", BLIST_NOLUN},
-	{"SONY", "CD-ROM CDU-561", "1.7x", BLIST_NOLUN},
-	{"SONY", "CD-ROM CDU-8012", NULL, BLIST_NOLUN},
-	{"SONY", "SDT-5000", "3.17", BLIST_SELECT_NO_ATN},
-	{"TANDBERG", "TDC 3600", "U07", BLIST_NOLUN},	/* locks up */
-	{"TEAC", "CD-R55S", "1.0H", BLIST_NOLUN},	/* locks up */
+	{"SEAGATE", "ST157N", "\004|j", BLIST_NOLUN, 0},
+	{"SEAGATE", "ST296", "921", BLIST_NOLUN, 0},	/* responds to all lun */
+	{"SEAGATE", "ST1581", "6538", BLIST_NOLUN, 0},	/* responds to all lun */
+	{"SONY", "CD-ROM CDU-541", "4.3d", BLIST_NOLUN, 0},
+	{"SONY", "CD-ROM CDU-55S", "1.0i", BLIST_NOLUN, 0},
+	{"SONY", "CD-ROM CDU-561", "1.7x", BLIST_NOLUN, 0},
+	{"SONY", "CD-ROM CDU-8012", NULL, BLIST_NOLUN, 0},
+	{"SONY", "SDT-5000", "3.17", BLIST_SELECT_NO_ATN, 0},
+	{"TANDBERG", "TDC 3600", "U07", BLIST_NOLUN, 0},	/* locks up */
+	{"TEAC", "CD-R55S", "1.0H", BLIST_NOLUN, 0},	/* locks up */
 	/*
 	 * The following causes a failed REQUEST SENSE on lun 1 for
 	 * seagate controller, which causes SCSI code to reset bus.
 	 */
-	{"TEAC", "CD-ROM", "1.06", BLIST_NOLUN},
-	{"TEAC", "MT-2ST/45S2-27", "RV M", BLIST_NOLUN},	/* responds to all lun */
+	{"TEAC", "CD-ROM", "1.06", BLIST_NOLUN, 0},
+	{"TEAC", "MT-2ST/45S2-27", "RV M", BLIST_NOLUN, 0},	/* responds to all lun */
 	/*
 	 * The following causes a failed REQUEST SENSE on lun 1 for
 	 * seagate controller, which causes SCSI code to reset bus.
 	 */
-	{"HP", "C1750A", "3226", BLIST_NOLUN},		/* scanjet iic */
-	{"HP", "C1790A", "", BLIST_NOLUN},		/* scanjet iip */
-	{"HP", "C2500A", "", BLIST_NOLUN},		/* scanjet iicx */
-	{"MEDIAVIS", "CDR-H93MV", "1.31", BLIST_NOLUN},	/* locks up */
-	{"MICROTEK", "ScanMaker II", "5.61", BLIST_NOLUN},	/* responds to all lun */
-	{"MITSUMI", "CD-R CR-2201CS", "6119", BLIST_NOLUN},	/* locks up */
-	{"NEC", "D3856", "0009", BLIST_NOLUN},
-	{"QUANTUM", "LPS525S", "3110", BLIST_NOLUN},	/* locks up */
-	{"QUANTUM", "PD1225S", "3110", BLIST_NOLUN},	/* locks up */
-	{"QUANTUM", "FIREBALL ST4.3S", "0F0C", BLIST_NOLUN},	/* locks up */
-	{"RELISYS", "Scorpio", NULL, BLIST_NOLUN},	/* responds to all lun */
-	{"SANKYO", "CP525", "6.64", BLIST_NOLUN},	/* causes failed REQ SENSE, extra reset */
-	{"TEXEL", "CD-ROM", "1.06", BLIST_NOLUN},
-	{"transtec", "T5008", "0001", BLIST_NOREPORTLUN },
-	{"YAMAHA", "CDR100", "1.00", BLIST_NOLUN},	/* locks up */
-	{"YAMAHA", "CDR102", "1.00", BLIST_NOLUN},	/* locks up */
-	{"YAMAHA", "CRW8424S", "1.0", BLIST_NOLUN},	/* locks up */
-	{"YAMAHA", "CRW6416S", "1.0c", BLIST_NOLUN},	/* locks up */
-	{"", "Scanner", "1.80", BLIST_NOLUN},	/* responds to all lun */
+	{"HP", "C1750A", "3226", BLIST_NOLUN, 0},	/* scanjet iic */
+	{"HP", "C1790A", "", BLIST_NOLUN, 0},		/* scanjet iip */
+	{"HP", "C2500A", "", BLIST_NOLUN, 0},		/* scanjet iicx */
+	{"MEDIAVIS", "CDR-H93MV", "1.31", BLIST_NOLUN, 0},	/* locks up */
+	{"MICROTEK", "ScanMaker II", "5.61", BLIST_NOLUN, 0},	/* responds to all lun */
+	{"MITSUMI", "CD-R CR-2201CS", "6119", BLIST_NOLUN, 0},	/* locks up */
+	{"NEC", "D3856", "0009", BLIST_NOLUN, 0},
+	{"QUANTUM", "LPS525S", "3110", BLIST_NOLUN, 0},	/* locks up */
+	{"QUANTUM", "PD1225S", "3110", BLIST_NOLUN, 0},	/* locks up */
+	{"QUANTUM", "FIREBALL ST4.3S", "0F0C", BLIST_NOLUN, 0},	/* locks up */
+	{"RELISYS", "Scorpio", NULL, BLIST_NOLUN, 0},	/* responds to all lun */
+	{"SANKYO", "CP525", "6.64", BLIST_NOLUN, 0},	/* causes failed REQ SENSE, extra reset */
+	{"TEXEL", "CD-ROM", "1.06", BLIST_NOLUN, 0},
+	{"transtec", "T5008", "0001", BLIST_NOREPORTLUN, 0},
+	{"YAMAHA", "CDR100", "1.00", BLIST_NOLUN, 0},	/* locks up */
+	{"YAMAHA", "CDR102", "1.00", BLIST_NOLUN, 0},	/* locks up */
+	{"YAMAHA", "CRW8424S", "1.0", BLIST_NOLUN, 0},	/* locks up */
+	{"YAMAHA", "CRW6416S", "1.0c", BLIST_NOLUN, 0},	/* locks up */
+	{"", "Scanner", "1.80", BLIST_NOLUN, 0},  /* responds to all lun */
 
 	/*
 	 * Other types of devices that have special flags.
 	 * Note that all USB devices should have the BLIST_INQUIRY_36 flag.
 	 */
-	{"3PARdata", "VV", NULL, BLIST_REPORTLUN2},
-	{"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},
-	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
-	{"AFT PRO", "-IX CF", "0.0>", BLIST_FORCELUN},
-	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_FORCELUN | BLIST_INQUIRY_36},
-	{"BROWNIE", "1200U3P", NULL, BLIST_NOREPORTLUN},
-	{"BROWNIE", "1600U3P", NULL, BLIST_NOREPORTLUN},
-	{"CANON", "IPUBJD", NULL, BLIST_SPARSELUN},
-	{"CBOX3", "USB Storage-SMC", "300A", BLIST_FORCELUN | BLIST_INQUIRY_36},
-	{"CMD", "CRA-7280", NULL, BLIST_SPARSELUN},	/* CMD RAID Controller */
-	{"CNSI", "G7324", NULL, BLIST_SPARSELUN},	/* Chaparral G7324 RAID */
-	{"CNSi", "G8324", NULL, BLIST_SPARSELUN},	/* Chaparral G8324 RAID */
+	{"3PARdata", "VV", NULL, BLIST_REPORTLUN2, 0},
+	{"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN, 0},
+	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN, 0},
+	{"AFT PRO", "-IX CF", "0.0>", BLIST_FORCELUN, 0},
+	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_FORCELUN | BLIST_INQUIRY_36, 0},
+	{"BROWNIE", "1200U3P", NULL, BLIST_NOREPORTLUN, 0},
+	{"BROWNIE", "1600U3P", NULL, BLIST_NOREPORTLUN, 0},
+	{"CANON", "IPUBJD", NULL, BLIST_SPARSELUN, 0},
+	{"CBOX3", "USB Storage-SMC", "300A", BLIST_FORCELUN | BLIST_INQUIRY_36, 0},
+	{"CMD", "CRA-7280", NULL, BLIST_SPARSELUN, 0},	/* CMD RAID Controller */
+	{"CNSI", "G7324", NULL, BLIST_SPARSELUN, 0},	/* Chaparral G7324 RAID */
+	{"CNSi", "G8324", NULL, BLIST_SPARSELUN, 0},	/* Chaparral G8324 RAID */
 	{"COMPAQ", "ARRAY CONTROLLER", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |
-		BLIST_MAX_512 | BLIST_REPORTLUN2},	/* Compaq RA4x00 */
-	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN | BLIST_MAX_512}, /* Compaq RA4x00 */
-	{"COMPAQ", "CR3500", NULL, BLIST_FORCELUN},
-	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
-	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
-	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
-	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
-	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
-	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
-	{"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},
-	{"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN},	/* Dell PV 530F */
-	{"DELL", "PV530F", NULL, BLIST_SPARSELUN},
-	{"DELL", "PERCRAID", NULL, BLIST_FORCELUN},
-	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, storage on LUN 0 */
-	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, no storage on LUN 0 */
-	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
-	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
-	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN},
-	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
-	{"easyRAID", "F8", NULL, BLIST_NOREPORTLUN},
-	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
-	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
-	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},
-	{"HITACHI", "DF400", "*", BLIST_SPARSELUN},
-	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
-	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
-	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "6586-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "6588-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP VA7400 */
-	{"HP", "OPEN-", "*", BLIST_REPORTLUN2}, /* HP XP Arrays */
-	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
-	{"HP", "HSV100", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
-	{"HP", "C1557A", NULL, BLIST_FORCELUN},
-	{"HP", "C3323-300", "4269", BLIST_NOTQ},
-	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
-	{"HP", "DF400", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "DF500", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "DF600", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "6586-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "6588-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
-	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
-	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
-	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
-	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
-	{"INSITE", "I325VM", NULL, BLIST_KEY},
-	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
-	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
-	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"MATSHITA", "DMC-LC5", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
-	{"MATSHITA", "DMC-LC40", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
-	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
-	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
-	{"MICROP", "4110", NULL, BLIST_NOTQ},
-	{"MYLEX", "DACARMRB", "*", BLIST_REPORTLUN2},
-	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
-	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"NAKAMICH", "MJ-5.16S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
-	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"Promise", "", NULL, BLIST_SPARSELUN},
-	{"QUANTUM", "XP34301", "1071", BLIST_NOTQ},
-	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
-	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
-	{"SEAGATE", "ST34555N", "0930", BLIST_NOTQ},	/* Chokes on tagged INQUIRY */
-	{"SEAGATE", "ST3390N", "9546", BLIST_NOTQ},
-	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
-	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
-	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
-	{"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
-	{"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
-	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
-	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
-	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
-	{"ST650211", "CF", NULL, BLIST_RETRY_HWERROR},
-	{"SUN", "T300", "*", BLIST_SPARSELUN},
-	{"SUN", "T4", "*", BLIST_SPARSELUN},
-	{"TEXEL", "CD-ROM", "1.06", BLIST_BORKEN},
-	{"Tornado-", "F4", "*", BLIST_NOREPORTLUN},
-	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM},
-	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
-	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
-	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
-	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
-	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN},
-	{"WDC WD25", "00JB-00FUA0", NULL, BLIST_NOREPORTLUN},
-	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"Zzyzx", "RocketStor 500S", NULL, BLIST_SPARSELUN},
-	{"Zzyzx", "RocketStor 2000", NULL, BLIST_SPARSELUN},
-	{ NULL, NULL, NULL, 0 },
+		BLIST_MAX_512 | BLIST_REPORTLUN2, 0},	/* Compaq RA4x00 */
+	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN | BLIST_MAX_512, 0}, /* Compaq RA4x00 */
+	{"COMPAQ", "CR3500", NULL, BLIST_FORCELUN, 0},
+	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD, 0},
+	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD, 0},
+	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD, 0},
+	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN, 0},
+	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD, 0},
+	{"DELL", "PV660F", NULL, BLIST_SPARSELUN, 0},
+	{"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN, 0},
+	{"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN, 0},	/* Dell PV 530F */
+	{"DELL", "PV530F", NULL, BLIST_SPARSELUN, 0},
+	{"DELL", "PERCRAID", NULL, BLIST_FORCELUN, 0},
+	{"DGC", "RAID", NULL, BLIST_SPARSELUN, 0},	/* Dell PV 650F, storage on LUN 0 */
+	{"DGC", "DISK", NULL, BLIST_SPARSELUN, 0},	/* Dell PV 650F, no storage on LUN 0 */
+	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN, 0},
+	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN, 0},
+	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN, 0},
+	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN, 0},
+	{"easyRAID", "F8", NULL, BLIST_NOREPORTLUN, 0},
+	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36, 0},
+	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36, 0},
+	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36, 0},
+	{"HITACHI", "DF400", "*", BLIST_SPARSELUN, 0},
+	{"HITACHI", "DF500", "*", BLIST_SPARSELUN, 0},
+	{"HITACHI", "DF600", "*", BLIST_SPARSELUN, 0},
+	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HITACHI", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HITACHI", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HITACHI", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HITACHI", "6586-", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HITACHI", "6588-", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN, 0},	/* HP VA7400 */
+	{"HP", "OPEN-", "*", BLIST_REPORTLUN2, 0}, /* HP XP Arrays */
+	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN, 0},
+	{"HP", "HSV100", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD, 0},
+	{"HP", "C1557A", NULL, BLIST_FORCELUN, 0},
+	{"HP", "C3323-300", "4269", BLIST_NOTQ, 0},
+	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN, 0},
+	{"HP", "DF400", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HP", "DF500", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HP", "DF600", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HP", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HP", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HP", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HP", "6586-", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"HP", "6588-", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN, 0},
+	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR, 0},
+	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN, 0},
+	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY, 0},
+	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY, 0},
+	{"INSITE", "I325VM", NULL, BLIST_KEY, 0},
+	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36, 0},
+	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN, 0},
+	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN, 0},
+	{"MATSHITA", "DMC-LC5", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36, 0},
+	{"MATSHITA", "DMC-LC40", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36, 0},
+	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN, 0},
+	{"MegaRAID", "LD", NULL, BLIST_FORCELUN, 0},
+	{"MICROP", "4110", NULL, BLIST_NOTQ, 0},
+	{"MYLEX", "DACARMRB", "*", BLIST_REPORTLUN2, 0},
+	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN, 0},
+	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN, 0},
+	{"NAKAMICH", "MJ-5.16S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN, 0},
+	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN, 0},
+	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2, 0},
+	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN, 0},
+	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN, 0},
+	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN, 0},
+	{"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN, 0},
+	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN, 0},
+	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN, 0},
+	{"Promise", "", NULL, BLIST_SPARSELUN, 0},
+	{"QUANTUM", "XP34301", "1071", BLIST_NOTQ, 0},
+	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN, 0},
+	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN, 0},
+	{"SEAGATE", "ST34555N", "0930", BLIST_NOTQ, 0},	/* Chokes on tagged INQUIRY */
+	{"SEAGATE", "ST3390N", "9546", BLIST_NOTQ, 0},
+	{"SGI", "RAID3", "*", BLIST_SPARSELUN, 0},
+	{"SGI", "RAID5", "*", BLIST_SPARSELUN, 0},
+	{"SGI", "TP9100", "*", BLIST_REPORTLUN2, 0},
+	{"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH, 0},
+	{"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH, 0},
+	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36, 0},
+	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN, 0},
+	{"SONY", "TSL", NULL, BLIST_FORCELUN, 0},		/* DDS3 & DDS4 autoloaders */
+	{"ST650211", "CF", NULL, BLIST_RETRY_HWERROR, 0},
+	{"SUN", "T300", "*", BLIST_SPARSELUN, 0},
+	{"SUN", "T4", "*", BLIST_SPARSELUN, 0},
+	{"TEXEL", "CD-ROM", "1.06", BLIST_BORKEN, 0},
+	{"Tornado-", "F4", "*", BLIST_NOREPORTLUN, 0},
+	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM, 0},
+	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM, 0},
+	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36, 0},
+	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN, 0},
+	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN, 0},
+	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN, 0},
+	{"WDC WD25", "00JB-00FUA0", NULL, BLIST_NOREPORTLUN, 0},
+	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN, 0},
+	{"Zzyzx", "RocketStor 500S", NULL, BLIST_SPARSELUN, 0},
+	{"Zzyzx", "RocketStor 2000", NULL, BLIST_SPARSELUN, 0},
+	{ NULL, NULL, NULL, 0 , 0},
 };
 
 /*
@@ -282,6 +284,7 @@ static void scsi_strcpy_devinfo(char *na
  * @model:	model (product) string
  * @strflags:	integer string
  * @flags:	if strflags NULL, use this flag value
+ * @tgt_qlimit: target port cmd queueing limit
  *
  * Description:
  * 	Create and add one dev_info entry for @vendor, @model, @strflags or
@@ -292,7 +295,7 @@ static void scsi_strcpy_devinfo(char *na
  * Returns: 0 OK, -error on failure.
  **/
 static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
-			    char *strflags, int flags)
+			    char *strflags, int flags, int tgt_qlimit)
 {
 	struct scsi_dev_info_list *devinfo;
 
@@ -313,6 +316,7 @@ static int scsi_dev_info_list_add(int co
 		devinfo->flags = flags;
 
 	devinfo->compatible = compatible;
+	devinfo->tgt_qlimit = tgt_qlimit;
 
 	if (compatible)
 		list_add_tail(&devinfo->dev_info_list, &scsi_dev_info_list);
@@ -328,7 +332,8 @@ static int scsi_dev_info_list_add(int co
  *
  * Description:
  * 	Parse dev_list, and add entries to the scsi_dev_info_list.
- * 	dev_list is of the form "vendor:product:flag,vendor:product:flag".
+ * 	dev_list is of the form
+ * 	"vendor:product:flag[:tgtqlimit],vendor:product:flag[:tgqlimit]".
  * 	dev_list is modified via strsep. Can be called for command line
  * 	addition, for proc or mabye a sysfs interface.
  *
@@ -336,9 +341,11 @@ static int scsi_dev_info_list_add(int co
  **/
 static int scsi_dev_info_list_add_str(char *dev_list)
 {
-	char *vendor, *model, *strflags, *next;
+	char *vendor, *model, *strflags, *tgtq, *next, *dchk, *ep;
 	char *next_check;
 	int res = 0;
+	int tgtfail;
+	int tgt_qlimit;
 
 	next = dev_list;
 	if (next && next[0] == '"') {
@@ -358,17 +365,42 @@ static int scsi_dev_info_list_add_str(ch
 	for (vendor = strsep(&next, ":"); vendor && (vendor[0] != '\0')
 	     && (res == 0); vendor = strsep(&next, ":")) {
 		strflags = NULL;
+		tgtq = NULL;
+		tgt_qlimit = 0;
+		tgtfail = 0;
 		model = strsep(&next, ":");
-		if (model)
-			strflags = strsep(&next, next_check);
-		if (!model || !strflags) {
+		if (model && next) {
+			/*
+			 * tgtqlimit is optional - so we have to compare
+			 * whether the next delimiter is a field
+			 * delimiter (':') or a record delimiter (',')
+			 */
+			for (dchk = next;
+			     ((*dchk != '\0') && (*dchk != ',') &&
+			      (*dchk != ':'));
+			     dchk++) ;
+
+			if (*dchk == ':') {
+				strflags = strsep(&next, ":");
+				tgtq = strsep(&next, next_check);
+				if (tgtq) {
+					tgt_qlimit = simple_strtoul(tgtq,
+								&ep, 0);
+					if ((*ep != '\0') || (tgt_qlimit < 0))
+						tgtfail = 1;
+				}
+			} else
+				strflags = strsep(&next, next_check);
+		}
+		if (!model || !strflags || tgtfail) {
 			printk(KERN_ERR "%s: bad dev info string '%s' '%s'"
-			       " '%s'\n", __FUNCTION__, vendor, model,
-			       strflags);
+			       " '%s' '%s'\n", __FUNCTION__, vendor, model,
+			       strflags, tgtq);
 			res = -EINVAL;
 		} else
 			res = scsi_dev_info_list_add(0 /* compatible */, vendor,
-						     model, strflags, 0);
+						     model, strflags, 0,
+						     tgt_qlimit);
 	}
 	return res;
 }
@@ -384,16 +416,18 @@ static int scsi_dev_info_list_add_str(ch
  *     @model, if found, return the matching flags value, else return
  *     the host or global default settings.  Called during scan time.
  **/
-int scsi_get_device_flags(struct scsi_device *sdev,
+void scsi_get_device_flags(struct scsi_device *sdev,
 			  const unsigned char *vendor,
-			  const unsigned char *model)
+			  const unsigned char *model,
+			  int *bflags, int *tgt_qlimit)
 {
 	struct scsi_dev_info_list *devinfo;
-	unsigned int bflags;
 
-	bflags = sdev->sdev_bflags;
-	if (!bflags)
-		bflags = scsi_default_dev_flags;
+	*bflags = sdev->sdev_bflags;
+	if (*bflags == 0)
+		*bflags = scsi_default_dev_flags;
+	if (tgt_qlimit)
+		*tgt_qlimit = 0;
 
 	list_for_each_entry(devinfo, &scsi_dev_info_list, dev_info_list) {
 		if (devinfo->compatible) {
@@ -436,16 +470,23 @@ int scsi_get_device_flags(struct scsi_de
 			if (memcmp(devinfo->model, model,
 				   min(max, strlen(devinfo->model))))
 				continue;
-			return devinfo->flags;
+
+			*bflags = devinfo->flags;
+			if (tgt_qlimit)
+				*tgt_qlimit = devinfo->tgt_qlimit;
+			return;
 		} else {
 			if (!memcmp(devinfo->vendor, vendor,
 				     sizeof(devinfo->vendor)) &&
 			     !memcmp(devinfo->model, model,
-				      sizeof(devinfo->model)))
-				return devinfo->flags;
+				      sizeof(devinfo->model))) {
+				*bflags = devinfo->flags;
+				if (tgt_qlimit)
+					*tgt_qlimit = devinfo->tgt_qlimit;
+				return;
+			}
 		}
 	}
-	return bflags;
 }
 
 #ifdef CONFIG_SCSI_PROC_FS
@@ -454,8 +495,9 @@ static int devinfo_seq_show(struct seq_f
 	struct scsi_dev_info_list *devinfo =
 		list_entry(v, struct scsi_dev_info_list, dev_info_list);
 
-	seq_printf(m, "'%.8s' '%.16s' 0x%x\n",
-			devinfo->vendor, devinfo->model, devinfo->flags);
+	seq_printf(m, "'%.8s' '%.16s' 0x%x %d\n",
+			devinfo->vendor, devinfo->model, devinfo->flags,
+			devinfo->tgt_qlimit);
 	return 0;
 }
 
@@ -490,7 +532,7 @@ static int proc_scsi_devinfo_open(struct
  *
  * Description: Adds a black/white list entry for vendor and model with an
  * integer value of flag to the scsi device info list.
- * To use, echo "vendor:model:flag" > /proc/scsi/device_info
+ * To use, echo "vendor:model:flag:tgtqlimit" > /proc/scsi/device_info
  */
 static ssize_t proc_scsi_devinfo_write(struct file *file,
 				       const char __user *buf,
@@ -534,9 +576,9 @@ static const struct file_operations scsi
 
 module_param_string(dev_flags, scsi_dev_flags, sizeof(scsi_dev_flags), 0);
 MODULE_PARM_DESC(dev_flags,
-	 "Given scsi_dev_flags=vendor:model:flags[,v:m:f] add black/white"
-	 " list entries for vendor and model with an integer value of flags"
-	 " to the scsi device info list");
+	 "Given scsi_dev_flags=vendor:model:flags:tgtqlimit[,v:m:f:t] add"
+	 " black/white list entries for vendor and model with an integer"
+	 " value of flags to the scsi device info list");
 
 module_param_named(default_dev_flags, scsi_default_dev_flags, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(default_dev_flags,
@@ -584,7 +626,8 @@ int __init scsi_init_devinfo(void)
 				scsi_static_device_list[i].vendor,
 				scsi_static_device_list[i].model,
 				NULL,
-				scsi_static_device_list[i].flags);
+				scsi_static_device_list[i].flags,
+				scsi_static_device_list[i].tgt_qlimit);
 		if (error)
 			goto out;
 	}
diff -upNr a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	2008-04-24 08:47:38.000000000 -0400
+++ b/drivers/scsi/scsi_priv.h	2008-05-10 13:11:32.000000000 -0400
@@ -42,9 +42,10 @@ static inline void scsi_log_completion(s
 int scsi_complete_async_scans(void);
 
 /* scsi_devinfo.c */
-extern int scsi_get_device_flags(struct scsi_device *sdev,
+extern void scsi_get_device_flags(struct scsi_device *sdev,
 				 const unsigned char *vendor,
-				 const unsigned char *model);
+				 const unsigned char *model,
+				 int *bflags, int *tgt_qlimit);
 extern int __init scsi_init_devinfo(void);
 extern void scsi_exit_devinfo(void);
 
diff -upNr a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2008-05-05 11:28:09.000000000 -0400
+++ b/drivers/scsi/scsi_scan.c	2008-05-13 12:10:09.000000000 -0400
@@ -554,6 +554,7 @@ static int scsi_probe_lun(struct scsi_de
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result;
+	int tgt_qlimit = 0;
 	struct scsi_sense_hdr sshdr;
 
 	*bflags = 0;
@@ -621,8 +622,8 @@ static int scsi_probe_lun(struct scsi_de
 		 * corresponding bit fields in scsi_device, so bflags
 		 * need not be passed as an argument.
 		 */
-		*bflags = scsi_get_device_flags(sdev, &inq_result[8],
-				&inq_result[16]);
+		scsi_get_device_flags(sdev, &inq_result[8], &inq_result[16],
+				 bflags, &tgt_qlimit);
 
 		/* When the first pass succeeds we gain information about
 		 * what larger transfer lengths might work. */
@@ -708,6 +709,9 @@ static int scsi_probe_lun(struct scsi_de
 	    (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
 		sdev->scsi_level++;
 	sdev->sdev_target->scsi_level = sdev->scsi_level;
+	if ((tgt_qlimit > 0) && ((sdev->sdev_target->can_queue == 0) ||
+				 (sdev->sdev_target->can_queue > tgt_qlimit)))
+		sdev->sdev_target->can_queue = tgt_qlimit;
 
 	return 0;
 }
@@ -1004,9 +1008,8 @@ static int scsi_probe_and_add_lun(struct
 				scsi_device_put(sdev);
 
 			if (bflagsp)
-				*bflagsp = scsi_get_device_flags(sdev,
-								 sdev->vendor,
-								 sdev->model);
+				scsi_get_device_flags(sdev, sdev->vendor,
+						sdev->model, bflagsp, NULL);
 			return SCSI_SCAN_LUN_PRESENT;
 		}
 		scsi_device_put(sdev);



