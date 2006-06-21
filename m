From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/2] Improve SCSI device type decoding
Date: Wed, 21 Jun 2006 10:53:00 -0600
Message-ID: <20060621165300.GX1630@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43216 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932261AbWFUQxB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 12:53:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Change API from the scsi_device_types array to the scsi_device_type function.
Gets rid of a lot of common code, as well as being easier to use.  Also
add the new device types in SPC4 r05a.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: ./drivers/block/cciss_scsi.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/block/cciss_scsi.c,v
retrieving revision 1.16
diff -u -p -r1.16 cciss_scsi.c
--- ./drivers/block/cciss_scsi.c	3 Apr 2006 13:44:03 -0000	1.16
+++ ./drivers/block/cciss_scsi.c	21 Jun 2006 16:46:14 -0000
@@ -251,10 +251,6 @@ scsi_cmd_stack_free(int ctlr)
 	stk->pool = NULL;
 }
 
-/* scsi_device_types comes from scsi.h */
-#define DEVICETYPE(n) (n<0 || n>MAX_SCSI_DEVICE_CODE) ? \
-	"Unknown" : scsi_device_types[n]
-
 #if 0
 static int xmargin=8;
 static int amargin=60;
@@ -389,7 +385,7 @@ cciss_scsi_add_entry(int ctlr, int hostn
 	   time anyway (the scsi layer's inquiries will show that info) */
 	if (hostno != -1)
 		printk("cciss%d: %s device c%db%dt%dl%d added.\n", 
-			ctlr, DEVICETYPE(sd->devtype), hostno, 
+			ctlr, scsi_device_type(sd->devtype), hostno, 
 			sd->bus, sd->target, sd->lun);
 	return 0;
 }
@@ -407,7 +403,7 @@ cciss_scsi_remove_entry(int ctlr, int ho
 		ccissscsi[ctlr].dev[i] = ccissscsi[ctlr].dev[i+1];
 	ccissscsi[ctlr].ndevices--;
 	printk("cciss%d: %s device c%db%dt%dl%d removed.\n",
-		ctlr, DEVICETYPE(sd.devtype), hostno, 
+		ctlr, scsi_device_type(sd.devtype), hostno, 
 			sd.bus, sd.target, sd.lun);
 }
 
@@ -458,7 +454,7 @@ adjust_cciss_scsi_table(int ctlr, int ho
 		if (found == 0) { /* device no longer present. */ 
 			changes++;
 			/* printk("cciss%d: %s device c%db%dt%dl%d removed.\n",
-				ctlr, DEVICETYPE(csd->devtype), hostno, 
+				ctlr, scsi_device_type(csd->devtype), hostno, 
 					csd->bus, csd->target, csd->lun); */
 			cciss_scsi_remove_entry(ctlr, hostno, i);
 			/* note, i not incremented */
@@ -468,7 +464,7 @@ adjust_cciss_scsi_table(int ctlr, int ho
 			printk("cciss%d: device c%db%dt%dl%d type changed "
 				"(device type now %s).\n",
 				ctlr, hostno, csd->bus, csd->target, csd->lun,
-					DEVICETYPE(csd->devtype));
+					scsi_device_type(csd->devtype));
 			csd->devtype = sd[j].devtype;
 			i++;	/* so just move along. */
 		} else 		/* device is same as it ever was, */
@@ -1098,7 +1094,7 @@ cciss_update_non_disk_devices(int cntl_n
 			if (ncurrent >= CCISS_MAX_SCSI_DEVS_PER_HBA) {
 				printk(KERN_INFO "cciss%d: %s ignored, "
 					"too many devices.\n", cntl_num,
-					DEVICETYPE(devtype));
+					scsi_device_type(devtype));
 				break;
 			}
 			memcpy(&currentsd[ncurrent].scsi3addr[0], 
Index: ./drivers/scsi/fcal.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/fcal.c,v
retrieving revision 1.8
diff -u -p -r1.8 fcal.c
--- ./drivers/scsi/fcal.c	12 Nov 2005 04:08:10 -0000	1.8
+++ ./drivers/scsi/fcal.c	21 Jun 2006 16:46:14 -0000
@@ -249,8 +249,7 @@ int fcal_proc_info (struct Scsi_Host *ho
 				if (scd->id == target) {
 					SPRINTF ("  [AL-PA: %02x, Id: %02d, Port WWN: %08x%08x, Node WWN: %08x%08x]  ",
 						alpa, target, u1[0], u1[1], u2[0], u2[1]);
-					SPRINTF ("%s ", (scd->type < MAX_SCSI_DEVICE_CODE) ?
-						scsi_device_types[(short) scd->type] : "Unknown device");
+					SPRINTF ("%s ", scsi_device_type(scd->type));
 
 					for (j = 0; (j < 8) && (scd->vendor[j] >= 0x20); j++)
 						SPRINTF ("%c", scd->vendor[j]);
Index: ./drivers/scsi/g_NCR5380.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/g_NCR5380.c,v
retrieving revision 1.14
diff -u -p -r1.14 g_NCR5380.c
--- ./drivers/scsi/g_NCR5380.c	3 Apr 2006 13:44:54 -0000	1.14
+++ ./drivers/scsi/g_NCR5380.c	21 Jun 2006 16:46:14 -0000
@@ -813,7 +813,6 @@ static int generic_NCR5380_proc_info(str
 	struct NCR5380_hostdata *hostdata;
 #ifdef NCR5380_STATS
 	struct scsi_device *dev;
-	extern const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE];
 #endif
 
 	NCR5380_setup(scsi_ptr);
@@ -853,7 +852,7 @@ static int generic_NCR5380_proc_info(str
 		long tr = hostdata->time_read[dev->id] / HZ;
 		long tw = hostdata->time_write[dev->id] / HZ;
 
-		PRINTP("  T:%d %s " ANDP dev->id ANDP(dev->type < MAX_SCSI_DEVICE_CODE) ? scsi_device_types[(int) dev->type] : "Unknown");
+		PRINTP("  T:%d %s " ANDP dev->id ANDP scsi_device_type(dev->type));
 		for (i = 0; i < 8; i++)
 			if (dev->vendor[i] >= 0x20)
 				*(buffer + (len++)) = dev->vendor[i];
Index: ./drivers/scsi/megaraid.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/megaraid.c,v
retrieving revision 1.26
diff -u -p -r1.26 megaraid.c
--- ./drivers/scsi/megaraid.c	13 May 2006 04:12:19 -0000	1.26
+++ ./drivers/scsi/megaraid.c	21 Jun 2006 16:46:14 -0000
@@ -2822,9 +2822,7 @@ mega_print_inquiry(char *page, char *scs
 
 	i = scsi_inq[0] & 0x1f;
 
-	len += sprintf(page+len, "  Type:   %s ",
-		i < MAX_SCSI_DEVICE_CODE ? scsi_device_types[i] :
-		   "Unknown          ");
+	len += sprintf(page+len, "  Type:   %s ", scsi_device_type(i));
 
 	len += sprintf(page+len,
 	"                 ANSI SCSI revision: %02x", scsi_inq[2] & 0x07);
Index: ./drivers/scsi/scsi.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi.c,v
retrieving revision 1.34
diff -u -p -r1.34 scsi.c
--- ./drivers/scsi/scsi.c	19 Apr 2006 04:55:59 -0000	1.34
+++ ./drivers/scsi/scsi.c	21 Jun 2006 16:46:15 -0000
@@ -97,7 +97,7 @@ unsigned int scsi_logging_level;
 EXPORT_SYMBOL(scsi_logging_level);
 #endif
 
-const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE] = {
+static const char *const scsi_device_types[] = {
 	"Direct-Access    ",
 	"Sequential-Access",
 	"Printer          ",
@@ -108,13 +108,27 @@ const char *const scsi_device_types[MAX_
 	"Optical Device   ",
 	"Medium Changer   ",
 	"Communications   ",
-	"Unknown          ",
-	"Unknown          ",
+	"ASC IT8          ",
+	"ASC IT8          ",
 	"RAID             ",
 	"Enclosure        ",
 	"Direct-Access-RBC",
+	"Optical Card     ",
+	"Bridge Controller",
+	"Object Storage   ",
+	"Automation/Drive ",
 };
-EXPORT_SYMBOL(scsi_device_types);
+
+const char * scsi_device_type(unsigned type)
+{
+	if (type == 0x1e)
+		return "Well-known LUN   ";
+	if (type > ARRAY_SIZE(scsi_device_types))
+		return "Unknown          ";
+	return scsi_device_types[type];
+}
+
+EXPORT_SYMBOL(scsi_device_type);
 
 /*
  * Function:    scsi_allocate_request
Index: ./drivers/scsi/scsi_proc.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_proc.c,v
retrieving revision 1.9
diff -u -p -r1.9 scsi_proc.c
--- ./drivers/scsi/scsi_proc.c	17 Jan 2006 14:51:49 -0000	1.9
+++ ./drivers/scsi/scsi_proc.c	21 Jun 2006 16:46:15 -0000
@@ -178,9 +178,7 @@ static int proc_print_scsidevice(struct 
 
 	seq_printf(s, "\n");
 
-	seq_printf(s, "  Type:   %s ",
-		     sdev->type < MAX_SCSI_DEVICE_CODE ?
-	       scsi_device_types[(int) sdev->type] : "Unknown          ");
+	seq_printf(s, "  Type:   %s ", scsi_device_type(sdev->type));
 	seq_printf(s, "               ANSI"
 		     " SCSI revision: %02x", (sdev->scsi_level - 1) ?
 		     sdev->scsi_level - 1 : 1);
Index: ./drivers/scsi/scsi_scan.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_scan.c,v
retrieving revision 1.41
diff -u -p -r1.41 scsi_scan.c
--- ./drivers/scsi/scsi_scan.c	29 May 2006 02:51:18 -0000	1.41
+++ ./drivers/scsi/scsi_scan.c	21 Jun 2006 16:46:15 -0000
@@ -226,10 +226,7 @@ static void print_inquiry(unsigned char 
 
 	i = inq_result[0] & 0x1f;
 
-	printk(KERN_NOTICE "  Type:   %s ",
-	       i <
-	       MAX_SCSI_DEVICE_CODE ? scsi_device_types[i] :
-	       "Unknown          ");
+	printk(KERN_NOTICE "  Type:   %s ", scsi_device_type(i));
 	printk("                 ANSI SCSI revision: %02x",
 	       inq_result[2] & 0x07);
 	if ((inq_result[2] & 0x07) == 1 && (inq_result[3] & 0x0f) == 1)
Index: ./include/scsi/scsi.h
===================================================================
RCS file: /var/cvs/linux-2.6/include/scsi/scsi.h,v
retrieving revision 1.19
diff -u -p -r1.19 scsi.h
--- ./include/scsi/scsi.h	3 Apr 2006 13:46:08 -0000	1.19
+++ ./include/scsi/scsi.h	21 Jun 2006 16:46:16 -0000
@@ -25,13 +25,6 @@ extern const unsigned char scsi_command_
 #define COMMAND_SIZE(opcode) scsi_command_size[((opcode) >> 5) & 7]
 
 /*
- *	SCSI device types
- */
-
-#define MAX_SCSI_DEVICE_CODE 15
-extern const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE];
-
-/*
  * Special value for scanning to specify scanning or rescanning of all
  * possible channels, (target) ids, or luns on a given shost.
  */
@@ -224,6 +217,9 @@ static inline int scsi_status_is_good(in
 #define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
 #define TYPE_RBC	    0x0e
 #define TYPE_NO_LUN         0x7f
+
+/* Returns a human-readable name for the device */
+extern const char * scsi_device_type(unsigned type);
 
 /*
  * standard mode-select header prepended to all mode-select commands
