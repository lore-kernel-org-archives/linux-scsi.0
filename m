From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg descriptor sense cleanup lk 2.6.11-rc1-bk1
Date: Mon, 17 Jan 2005 21:39:37 +1000
Message-ID: <41EBA3F9.8030305@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050504050606020109000001"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:59056 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262773AbVAQLjf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jan 2005 06:39:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------050504050606020109000001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Continuation of descriptor sense data expansion to
sg driver.

Next will be the sd driver which awaits a
new utility function in constants.c to read the
sense data information field for medium/hardware
errors.

Changelog:
   - expand sense data handling to descriptor format
   - make module parameters visible in
       /sys/modules/sg/parameters
   - add "readable" SCSI commands: READ(16), REPORT LUNS,
     SERVICE_ACTION_IN, RECEIVE_DIAGNOSTIC, READ_LONG
     and MAINTENANCE_IN_CMD to list

Signed-off-by: Douglas Gilbert <dougg@torque.net>

--------------050504050606020109000001
Content-Type: text/x-patch;
 name="sg2611rc1bk1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg2611rc1bk1.diff"

--- linux/drivers/scsi/sg.c	2004-12-25 12:21:22.000000000 +1000
+++ linux/drivers/scsi/sg.c2611rc1bk1des	2005-01-17 18:11:42.000000000 +1000
@@ -7,7 +7,7 @@
  * Original driver (sg.c):
  *        Copyright (C) 1992 Lawrence Foard
  * Version 2 and 3 extensions to driver:
- *        Copyright (C) 1998 - 2004 Douglas Gilbert
+ *        Copyright (C) 1998 - 2005 Douglas Gilbert
  *
  *  Modified  19-JAN-1998  Richard Gooch <rgooch@atnf.csiro.au>  Devfs support
  *
@@ -18,8 +18,8 @@
  *
  */
 
-static int sg_version_num = 30531;	/* 2 digits for each component */
-#define SG_VERSION_STR "3.5.31"
+static int sg_version_num = 30532;	/* 2 digits for each component */
+#define SG_VERSION_STR "3.5.32"
 
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
@@ -60,7 +60,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20040516";
+static char *sg_version_date = "20050117";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -1282,6 +1282,8 @@
 	srp->header.duration =
 	    jiffies_to_msecs(jiffies - srp->header.duration);
 	if (0 != SRpnt->sr_result) {
+		struct scsi_sense_hdr sshdr;
+
 		memcpy(srp->sense_b, SRpnt->sr_sense_buffer,
 		       sizeof (srp->sense_b));
 		srp->header.status = 0xff & SRpnt->sr_result;
@@ -1296,11 +1298,12 @@
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
 		if (driver_byte(SRpnt->sr_result) != 0
-		    && (SRpnt->sr_sense_buffer[0] & 0x7f) == 0x70
-		    && (SRpnt->sr_sense_buffer[2] & 0xf) == UNIT_ATTENTION
+		    && scsi_command_normalize_sense(SCpnt, &sshdr)
+		    && !scsi_sense_is_deferred(&sshdr)
+		    && sshdr.sense_key == UNIT_ATTENTION
 		    && sdp->device->removable) {
-			/* Detected disc change. Set the bit - this may be used if */
-			/* there are filesystems using this device. */
+			/* Detected possible disc change. Set the bit - this */
+			/* may be used if there are filesystems using this device */
 			sdp->device->changed = 1;
 		}
 	}
@@ -1573,8 +1576,8 @@
  * of sysfs parameters (which module_param doesn't yet support).
  * Sysfs parameters defined explicitly below.
  */
-module_param_named(def_reserved_size, def_reserved_size, int, 0);
-module_param_named(allow_dio, sg_allow_dio, int, 0);
+module_param_named(def_reserved_size, def_reserved_size, int, S_IRUGO);
+module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
 
 MODULE_AUTHOR("Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI generic (sg) driver");
@@ -2606,9 +2609,14 @@
 	free_pages((unsigned long) buff, order);
 }
 
+#ifndef MAINTENANCE_IN_CMD
+#define MAINTENANCE_IN_CMD 0xa3
+#endif
+
 static unsigned char allow_ops[] = { TEST_UNIT_READY, REQUEST_SENSE,
 	INQUIRY, READ_CAPACITY, READ_BUFFER, READ_6, READ_10, READ_12,
-	MODE_SENSE, MODE_SENSE_10, LOG_SENSE
+	READ_16, MODE_SENSE, MODE_SENSE_10, LOG_SENSE, REPORT_LUNS,
+	SERVICE_ACTION_IN, RECEIVE_DIAGNOSTIC, READ_LONG, MAINTENANCE_IN_CMD
 };
 
 static int

--------------050504050606020109000001--
