From: dave wysochanski <davidw@netapp.com>
Subject: [PATCH] [take2][scsi-rc-fixes] Don't add scsi_device for devices
	that return PQ=1, PDT=0x1f
Date: Wed, 09 Aug 2006 14:56:32 -0400
Message-ID: <1155149792.3989.20.camel@linux-659c.rtp.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:35097 "EHLO mx2.netapp.com")
	by vger.kernel.org with ESMTP id S1751147AbWHIS4f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2006 14:56:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hare@suse.de, "Kraft, Claire" <Claire.Kraft@netapp.com>, "Shenoy, Raghavendra" <Raghavendra.Shenoy@netapp.com>, "George, Martin" <marting@netapp.com>, "Nair, Vinod K" <nvinod@netapp.com>

Some targets may return slight variations of PQ and PDT to indicate
no LUN mapped.  USB UFI setting PDT=0x1f but having reserved bits for
PQ is one example, and NetApp targets returning PQ=1 and PDT=0x1f is
another.  Both instances seem like reasonable responses according to
SPC-3 and UFI specs.

The current scsi_probe_and_add_lun() code adds a scsi_device 
for targets that return PQ=1 and PDT=0x1f.  This causes LUNs of type 
"UNKNOWN" to show up in /proc/scsi/scsi when no LUNs are mapped. 
In addition, subsequent rescans fail to recognize LUNs that may be 
added on the target, unless preceded by a write to the delete attribute 
of the "UNKNOWN" LUN.

This patch addresses this problem by skipping over the scsi_add_lun() 
when PQ=1,PDT=0x1f is encountered, and just returns 
SCSI_SCAN_TARGET_PRESENT.


Signed-off-by: Dave Wysochanski <davidw@netapp.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>


--- a/drivers/scsi/scsi_scan.c	2006-07-15 17:53:08.000000000 -0400
+++ b/drivers/scsi/scsi_scan.c	2006-08-09 14:01:20.000000000 -0400
@@ -943,11 +943,26 @@ static int scsi_probe_and_add_lun(struct
 	}
 
 	/*
-	 * Non-standard SCSI targets may set the PDT to 0x1f (unknown or
-	 * no device type) instead of using the Peripheral Qualifier to
-	 * indicate that no LUN is present.  For example, USB UFI does this.
+	 * Some targets may set slight variations of PQ and PDT to signal
+	 * that no LUN is present, so don't add sdev in these cases.
+	 * Two specific examples are:
+	 * 1) NetApp targets: return PQ=1, PDT=0x1f
+	 * 2) USB UFI: returns PDT=0x1f, with the PQ bits being "reserved"
+	 *    in the UFI 1.0 spec (we cannot rely on reserved bits).
+	 *
+	 * References:
+	 * 1) SCSI SPC-3, pp. 145-146
+	 * PQ=1: "A peripheral device having the specified peripheral
+	 * device type is not connected to this logical unit. However, the 
+	 * device server is capable of supporting the specified peripheral
+	 * device type on this logical unit."
+	 * PDT=0x1f: "Unknown or no device type"
+	 * 2) USB UFI 1.0, p. 20
+	 * PDT=00h Direct-access device (floppy)
+	 * PDT=1Fh none (no FDD connected to the requested logical unit)
 	 */
-	if (starget->pdt_1f_for_no_lun && (result[0] & 0x1f) == 0x1f) {
+	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
+	     (result[0] & 0x1f) == 0x1f) {
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 					"scsi scan: peripheral device type"
 					" of 31, no device added\n"));

