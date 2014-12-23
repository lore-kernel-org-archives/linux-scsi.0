From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] constants.c: asc/ascq codes, sync to T10 20141221
Date: Tue, 23 Dec 2014 11:29:08 -0500
Message-ID: <54999854.2070501@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080208020704050209050002"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50744 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213AbaLWQ3Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2014 11:29:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>

This is a multi-part message in MIME format.
--------------080208020704050209050002
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

The last time these SCSI asc/ascq codes were synced with T10
was 20130605. This patch is against lk 3.19.0-rc1 .

ChangeLog:
   sync the SCSI ASC/ASCQ number to string tables with those
   found at http://www.t10.org/lists/asc-num.txt dated
   20141221

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------080208020704050209050002
Content-Type: text/x-patch;
 name="constants319rc1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="constants319rc1.patch"

--- a/drivers/scsi/constants.c	2014-12-22 11:13:19.113270114 -0500
+++ b/drivers/scsi/constants.c	2014-12-23 10:30:08.799169226 -0500
@@ -392,7 +392,7 @@ struct error_info {
 
 /*
  * The canonical list of T10 Additional Sense Codes is available at:
- * http://www.t10.org/lists/asc-num.txt [most recent: 20130605]
+ * http://www.t10.org/lists/asc-num.txt [most recent: 20141221]
  */
 
 static const struct error_info additional[] =
@@ -421,6 +421,7 @@ static const struct error_info additiona
 	{0x001E, "Conflicting SA creation request"},
 	{0x001F, "Logical unit transitioning to another power condition"},
 	{0x0020, "Extended copy information available"},
+	{0x0021, "Atomic command aborted due to ACA"},
 
 	{0x0100, "No index/sector signal"},
 
@@ -446,6 +447,7 @@ static const struct error_info additiona
 	{0x040C, "Logical unit not accessible, target port in unavailable "
 	 "state"},
 	{0x040D, "Logical unit not ready, structure check required"},
+	{0x040E, "Logical unit not ready, security session in progress"},
 	{0x0410, "Logical unit not ready, auxiliary memory not accessible"},
 	{0x0411, "Logical unit not ready, notify (enable spinup) required"},
 	{0x0412, "Logical unit not ready, offline"},
@@ -462,6 +464,11 @@ static const struct error_info additiona
 	{0x041C, "Logical unit not ready, additional power use not yet "
 	 "granted"},
 	{0x041D, "Logical unit not ready, configuration in progress"},
+	{0x041E, "Logical unit not ready, microcode activation required"},
+	{0x041F, "Logical unit not ready, microcode download required"},
+	{0x0420, "Logical unit not ready, logical unit reset required"},
+	{0x0421, "Logical unit not ready, hard reset required"},
+	{0x0422, "Logical unit not ready, power cycle required"},
 
 	{0x0500, "Logical unit does not respond to selection"},
 
@@ -480,6 +487,7 @@ static const struct error_info additiona
 	{0x0902, "Focus servo failure"},
 	{0x0903, "Spindle servo failure"},
 	{0x0904, "Head select fault"},
+	{0x0905, "Vibration induced tracking error"},
 
 	{0x0A00, "Error log overflow"},
 
@@ -510,6 +518,7 @@ static const struct error_info additiona
 	{0x0C0D, "Write error - not enough unsolicited data"},
 	{0x0C0E, "Multiple write errors"},
 	{0x0C0F, "Defects in error window"},
+	{0x0C10, "Incomplete multiple atomic write operations"},
 
 	{0x0D00, "Error detected by third party temporary initiator"},
 	{0x0D01, "Third party device failure"},
@@ -635,6 +644,10 @@ static const struct error_info additiona
 	{0x2101, "Invalid element address"},
 	{0x2102, "Invalid address for write"},
 	{0x2103, "Invalid write crossing layer jump"},
+	{0x2104, "Unaligned write command"},
+	{0x2105, "Write boundary violation"},
+	{0x2106, "Attempt to read invalid data"},
+	{0x2107, "Read boundary violation"},
 
 	{0x2200, "Illegal function (use 20 00, 24 00, or 26 00)"},
 
@@ -691,6 +704,7 @@ static const struct error_info additiona
 	{0x2705, "Permanent write protect"},
 	{0x2706, "Conditional write protect"},
 	{0x2707, "Space allocation failed write protect"},
+	{0x2708, "Zone is read only"},
 
 	{0x2800, "Not ready to ready change, medium may have changed"},
 	{0x2801, "Import or export element accessed"},
@@ -743,10 +757,15 @@ static const struct error_info additiona
 	{0x2C0A, "Partition or collection contains user objects"},
 	{0x2C0B, "Not reserved"},
 	{0x2C0C, "Orwrite generation does not match"},
+	{0x2C0D, "Reset write pointer not allowed"},
+	{0x2C0E, "Zone is offline"},
 
 	{0x2D00, "Overwrite error on update in place"},
 
 	{0x2E00, "Insufficient time for operation"},
+	{0x2E01, "Command timeout before processing"},
+	{0x2E02, "Command timeout during processing"},
+	{0x2E03, "Command timeout during processing due to error recovery"},
 
 	{0x2F00, "Commands cleared by another initiator"},
 	{0x2F01, "Commands cleared by power loss notification"},
@@ -868,6 +887,7 @@ static const struct error_info additiona
 	{0x3F13, "iSCSI IP address removed"},
 	{0x3F14, "iSCSI IP address changed"},
 	{0x3F15, "Inspect referrals sense descriptors"},
+	{0x3F16, "Microcode has been changed without reset"},
 /*
  *	{0x40NN, "Ram failure"},
  *	{0x40NN, "Diagnostic failure on component nn"},
@@ -946,6 +966,11 @@ static const struct error_info additiona
 	{0x5306, "Volume identifier missing"},
 	{0x5307, "Duplicate volume identifier"},
 	{0x5308, "Element status unknown"},
+	{0x5309, "Data transfer device error - load failed"},
+	{0x530a, "Data transfer device error - unload failed"},
+	{0x530b, "Data transfer device error - unload missing"},
+	{0x530c, "Data transfer device error - eject failed"},
+	{0x530d, "Data transfer device error - library communication failed"},
 
 	{0x5400, "Scsi to host system interface failure"},
 
@@ -963,6 +988,7 @@ static const struct error_info additiona
 	{0x550B, "Insufficient power for operation"},
 	{0x550C, "Insufficient resources to create rod"},
 	{0x550D, "Insufficient resources to create rod token"},
+	{0x550E, "Insufficient zone resources"},
 
 	{0x5700, "Unable to recover table-of-contents"},
 

--------------080208020704050209050002--
