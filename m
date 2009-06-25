From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] update scsi/constants.c
Date: Thu, 25 Jun 2009 15:43:02 -0400
Message-ID: <4A43D346.6080506@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040909040403040908040503"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from firefly.infotech.no ([82.134.31.146]:57909 "EHLO
	elrond.bb.infotech.no" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752875AbZFYTnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2009 15:43:11 -0400
Received: from localhost (localhost [127.0.0.1])
	by elrond.bb.infotech.no (Postfix) with ESMTP id 9F0B430393
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2009 21:43:10 +0200 (CEST)
Received: from elrond.bb.infotech.no ([127.0.0.1])
	by localhost (elrond.bb.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xEDYTScpSG2C for <linux-scsi@vger.kernel.org>;
	Thu, 25 Jun 2009 21:43:04 +0200 (CEST)
Received: from [192.168.48.95] (ip-209.54.99.216.dsl-cust.ca.inter.net [216.99.54.209])
	by elrond.bb.infotech.no (Postfix) with ESMTPA id C3F2F30392
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2009 21:43:03 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040909040403040908040503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

It has been 3 years since this file was sync-ed with
www.t10.org . Information taken from the last bunch
of drafts released in May 2009. More asc/ascq codes
are coming for thin provisioning; when approved and
allocated another patch could add them prior to this
patch going live.

Changelog:
   - add some new command names and rename two commands
   - sync asc/ascq table with www.t10.org/lists/asc-num.txt
   - correct bug in scsi_extd_sense_format() [second
     for loop]

Doug Gilbert

--------------040909040403040908040503
Content-Type: text/x-patch;
 name="scsi_constants1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_constants1.diff"

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--- linux/drivers/scsi/constants.c2630	2009-06-10 11:18:32.000000000 -0400
+++ linux/drivers/scsi/constants.c	2009-06-25 15:25:58.000000000 -0400
@@ -4,8 +4,7 @@
  * Additions for SCSI 2 and Linux 2.2.x by D. Gilbert (990422)
  * Additions for SCSI 3+ (SPC-3 T10/1416-D Rev 07 3 May 2002)
  *   by D. Gilbert and aeb (20020609)
- * Additions for SPC-3 T10/1416-D Rev 21 22 Sept 2004, D. Gilbert 20041025
- * Update to SPC-4 T10/1713-D Rev 5a, 14 June 2006, D. Gilbert 20060702
+ * Update to SPC-4 T10/1713-D Rev 20, 22 May 2009, D. Gilbert 20090624
  */
 
 #include <linux/blkdev.h>
@@ -56,9 +55,9 @@
             "Read Buffer", 
 /* 3d-3f */ "Update Block", "Read Long(10)",  "Write Long(10)",
 /* 40-41 */ "Change Definition", "Write Same(10)",
-/* 42-48 */ "Read sub-channel", "Read TOC/PMA/ATIP", "Read density support",
-            "Play audio(10)", "Get configuration", "Play audio msf",
-            "Play audio track/index",
+/* 42-48 */ "Unmap/Read sub-channel", "Read TOC/PMA/ATIP",
+	    "Read density support", "Play audio(10)", "Get configuration",
+	    "Play audio msf", "Play audio track/index",
 /* 49-4f */ "Play track relative(10)", "Get event status notification",
             "Pause/resume", "Log Select", "Log Sense", "Stop play/scan",
             NULL,
@@ -71,12 +70,13 @@
 /* 60-67 */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 /* 68-6f */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 /* 70-77 */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-/* 78-7f */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, "Variable length",
+/* 78-7f */ NULL, NULL, NULL, NULL, NULL, NULL, "Extended CDB",
+	    "Variable length",
 /* 80-84 */ "Xdwrite(16)", "Rebuild(16)", "Regenerate(16)", "Extended copy",
             "Receive copy results",
 /* 85-89 */ "ATA command pass through(16)", "Access control in",
 	    "Access control out", "Read(16)", "Memory Export Out(16)",
-/* 8a-8f */ "Write(16)", NULL, "Read attributes", "Write attributes",
+/* 8a-8f */ "Write(16)", "ORWrite", "Read attributes", "Write attributes",
             "Write and verify(16)", "Verify(16)",
 /* 90-94 */ "Pre-fetch(16)", "Synchronize cache(16)",
             "Lock/unlock cache(16)", "Write same(16)", NULL,
@@ -107,22 +107,24 @@
 };
 
 static const struct value_name_pair maint_in_arr[] = {
-	{0x5, "Report device identifier"},
+	{0x5, "Report identifying information"},
 	{0xa, "Report target port groups"},
 	{0xb, "Report aliases"},
 	{0xc, "Report supported operation codes"},
 	{0xd, "Report supported task management functions"},
 	{0xe, "Report priority"},
 	{0xf, "Report timestamp"},
+	{0x10, "Management protocol in"},
 };
 #define MAINT_IN_SZ ARRAY_SIZE(maint_in_arr)
 
 static const struct value_name_pair maint_out_arr[] = {
-	{0x6, "Set device identifier"},
+	{0x6, "Set identifying information"},
 	{0xa, "Set target port groups"},
 	{0xb, "Change aliases"},
 	{0xe, "Set priority"},
-	{0xe, "Set timestamp"},
+	{0xf, "Set timestamp"},
+	{0x10, "Management protocol out"},
 };
 #define MAINT_OUT_SZ ARRAY_SIZE(maint_out_arr)
 
@@ -412,6 +414,7 @@
 	{0x0004, "Beginning-of-partition/medium detected"},
 	{0x0005, "End-of-data detected"},
 	{0x0006, "I/O process terminated"},
+	{0x0007, "Programmable early warning detected"},
 	{0x0011, "Audio play operation in progress"},
 	{0x0012, "Audio play operation paused"},
 	{0x0013, "Audio play operation successfully completed"},
@@ -425,6 +428,7 @@
 	{0x001B, "Set capacity operation in progress"},
 	{0x001C, "Verify operation in progress"},
 	{0x001D, "ATA pass through information available"},
+	{0x001E, "Conflicting SA creation request"},
 
 	{0x0100, "No index/sector signal"},
 
@@ -449,9 +453,12 @@
 	{0x040B, "Logical unit not accessible, target port in standby state"},
 	{0x040C, "Logical unit not accessible, target port in unavailable "
 	 "state"},
+	{0x040D, "Logical unit not ready, structure check required"},
 	{0x0410, "Logical unit not ready, auxiliary memory not accessible"},
 	{0x0411, "Logical unit not ready, notify (enable spinup) required"},
 	{0x0412, "Logical unit not ready, offline"},
+	{0x0413, "Logical unit not ready, SA creation in progress"},
+	{0x0414, "Logical unit not ready, space allocation in progress"},
 
 	{0x0500, "Logical unit does not respond to selection"},
 
@@ -479,6 +486,9 @@
 	{0x0B03, "Warning - background self-test failed"},
 	{0x0B04, "Warning - background pre-scan detected medium error"},
 	{0x0B05, "Warning - background medium scan detected medium error"},
+	{0x0B06, "Warning - non-volatile cache now volatile"},
+	{0x0B07, "Warning - degraded power to non-volatile cache"},
+	{0x0B08, "Warning - power loss expected"},
 
 	{0x0C00, "Write error"},
 	{0x0C01, "Write error - recovered with auto reallocation"},
@@ -593,6 +603,7 @@
 	{0x1C02, "Grown defect list not found"},
 
 	{0x1D00, "Miscompare during verify operation"},
+	{0x1D01, "Miscompare verify of unmapped LBA"},
 
 	{0x1E00, "Recovered id with ECC correction"},
 
@@ -626,6 +637,7 @@
 	{0x2405, "Security working key frozen"},
 	{0x2406, "Nonce not unique"},
 	{0x2407, "Nonce timestamp out of range"},
+	{0x2408, "Invalid XCDB"},
 
 	{0x2500, "Logical unit not supported"},
 
@@ -656,10 +668,12 @@
 	{0x2704, "Persistent write protect"},
 	{0x2705, "Permanent write protect"},
 	{0x2706, "Conditional write protect"},
+	{0x2707, "Space allocation failed write protect"},
 
 	{0x2800, "Not ready to ready change, medium may have changed"},
 	{0x2801, "Import or export element accessed"},
 	{0x2802, "Format-layer may have changed"},
+	{0x2803, "Import/export element accessed, medium changed"},
 
 	{0x2900, "Power on, reset, or bus device reset occurred"},
 	{0x2901, "Power on occurred"},
@@ -680,11 +694,16 @@
 	{0x2A07, "Implicit asymmetric access state transition failed"},
 	{0x2A08, "Priority changed"},
 	{0x2A09, "Capacity data has changed"},
+	{0x2A0A, "Error history I_T nexus cleared"},
+	{0x2A0B, "Error history snapshot released"},
+	{0x2A0C, "Error recovery attributes have changed"},
+	{0x2A0D, "Data encryption capabilities changed"},
 	{0x2A10, "Timestamp changed"},
 	{0x2A11, "Data encryption parameters changed by another i_t nexus"},
 	{0x2A12, "Data encryption parameters changed by vendor specific "
 		 "event"},
 	{0x2A13, "Data encryption key instance counter has changed"},
+	{0x2A14, "SA creation capabilities data has changed"},
 
 	{0x2B00, "Copy cannot execute since host cannot disconnect"},
 
@@ -723,6 +742,8 @@
 	{0x300C, "WORM medium - overwrite attempted"},
 	{0x300D, "WORM medium - integrity check"},
 	{0x3010, "Medium not formatted"},
+	{0x3011, "Incompatible volume type"},
+	{0x3012, "Incompatible volume qualifier"},
 
 	{0x3100, "Medium format corrupted"},
 	{0x3101, "Format command failed"},
@@ -782,6 +803,10 @@
 	{0x3B15, "Medium magazine unlocked"},
 	{0x3B16, "Mechanical positioning or changer error"},
 	{0x3B17, "Read past end of user object"},
+	{0x3B18, "Element disabled"},
+	{0x3B19, "Element enabled"},
+	{0x3B1A, "Data transfer device removed"},
+	{0x3B1B, "Data transfer device inserted"},
 
 	{0x3D00, "Invalid bits in identify message"},
 
@@ -882,6 +907,8 @@
 	{0x5506, "Auxiliary memory out of space"},
 	{0x5507, "Quota error"},
 	{0x5508, "Maximum number of supplemental decryption keys exceeded"},
+	{0x5509, "Medium auxiliary memory not accessible"},
+	{0x550A, "Data currently unavailable"},
 
 	{0x5700, "Unable to recover table-of-contents"},
 
@@ -993,6 +1020,12 @@
 	{0x5E02, "Standby condition activated by timer"},
 	{0x5E03, "Idle condition activated by command"},
 	{0x5E04, "Standby condition activated by command"},
+	{0x5E05, "Idle_b condition activated by timer"},
+	{0x5E06, "Idle_b condition activated by command"},
+	{0x5E07, "Idle_c condition activated by timer"},
+	{0x5E08, "Idle_c condition activated by command"},
+	{0x5E09, "Standby_y condition activated by timer"},
+	{0x5E0A, "Standby_y condition activated by command"},
 	{0x5E41, "Power state change to active"},
 	{0x5E42, "Power state change to idle"},
 	{0x5E43, "Power state change to standby"},
@@ -1091,7 +1124,28 @@
 	{0x7403, "Incorrect data encryption key"},
 	{0x7404, "Cryptographic integrity validation failed"},
 	{0x7405, "Error decrypting data"},
+	{0x7406, "Unknown signature verification key"},
+	{0x7407, "Encryption parameters not useable"},
+	{0x7408, "Digital signature validation failure"},
+	{0x7409, "Encryption mode mismatch on read"},
+	{0x740A, "Encrypted block not raw read enabled"},
+	{0x740B, "Incorrect Encryption parameters"},
+	{0x740C, "Unable to decrypt parameter list"},
+	{0x740D, "Encryption algorithm disabled"},
+	{0x7410, "SA creation parameter value invalid"},
+	{0x7411, "SA creation parameter value rejected"},
+	{0x7412, "Invalid SA usage"},
+	{0x7421, "Data Encryption configuration prevented"},
+	{0x7430, "SA creation parameter not supported"},
+	{0x7440, "Authentication failed"},
+	{0x7461, "External data encryption key manager access error"},
+	{0x7462, "External data encryption key manager error"},
+	{0x7463, "External data encryption key not found"},
+	{0x7464, "External data encryption request not authorized"},
+	{0x746E, "External data encryption control timeout"},
+	{0x746F, "External data encryption control error"},
 	{0x7471, "Logical unit access not authorized"},
+	{0x7479, "Security conflict in translated device"},
 
 	{0, NULL}
 };
@@ -1103,12 +1157,12 @@
 
 static const struct error_info2 additional2[] =
 {
-	{0x40,0x00,0x7f,"Ram failure (%x)"},
-	{0x40,0x80,0xff,"Diagnostic failure on component (%x)"},
-	{0x41,0x00,0xff,"Data path failure (%x)"},
-	{0x42,0x00,0xff,"Power-on or self-test failure (%x)"},
-	{0x4D,0x00,0xff,"Tagged overlapped commands (queue tag %x)"},
-	{0x70,0x00,0xff,"Decompression exception short algorithm id of %x"},
+	{0x40, 0x00, 0x7f, "Ram failure (%x)"},
+	{0x40, 0x80, 0xff, "Diagnostic failure on component (%x)"},
+	{0x41, 0x00, 0xff, "Data path failure (%x)"},
+	{0x42, 0x00, 0xff, "Power-on or self-test failure (%x)"},
+	{0x4D, 0x00, 0xff, "Tagged overlapped commands (task tag %x)"},
+	{0x70, 0x00, 0xff, "Decompression exception short algorithm id of %x"},
 	{0, 0, 0, NULL}
 };
 
@@ -1157,14 +1211,15 @@
 	int i;
 	unsigned short code = ((asc << 8) | ascq);
 
-	for (i=0; additional[i].text; i++)
+	for (i = 0; additional[i].text; i++)
 		if (additional[i].code12 == code)
 			return additional[i].text;
-	for (i=0; additional2[i].fmt; i++)
+	for (i = 0; additional2[i].fmt; i++) {
 		if (additional2[i].code1 == asc &&
-		    additional2[i].code2_min >= ascq &&
-		    additional2[i].code2_max <= ascq)
+		    ascq >= additional2[i].code2_min &&
+		    ascq <= additional2[i].code2_max)
 			return additional2[i].fmt;
+	}
 #endif
 	return NULL;
 }

--------------040909040403040908040503--
