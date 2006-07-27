From: Dave Wysochanski <davidw@netapp.com>
Subject: [PATCH] Don't add scsi_device for devices that return PQ=1, PDT=0x1f
Date: Thu, 27 Jul 2006 16:30:36 -0400
Message-ID: <44C9226C.6030309@netapp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050902030406070202040000"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:37700 "EHLO mx2.netapp.com")
	by vger.kernel.org with ESMTP id S1750729AbWG0Uak (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jul 2006 16:30:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de, James.Bottomley@steeleye.com
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, hare@suse.de, "Kraft, Claire" <Claire.Kraft@netapp.com>, "Shenoy, Raghavendra" <Raghavendra.Shenoy@netapp.com>, "George, Martin" <marting@netapp.com>, nvinod@netapp.com

This is a multi-part message in MIME format.
--------------050902030406070202040000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Some targets may return PQ=1 and PDT=0x1f to indicate no LUN is mapped
(Netapp targets do this).  This seems like a valid way to indicate no
LUN mapped according to SPC-3.

However, the current scsi_probe_and_add_lun() code adds a scsi_device
for targets that return PQ=1 and PDT=0x1f.  This causes LUNs of type
"UNKNOWN" to show up in /proc/scsi/scsi when no LUNs are mapped.
In addition, subsequent rescans fail to recognize LUNs that may be
added on the target, unless preceded by a write to the delete attribute
of the "UNKNOWN" LUN.

This patch addresses this problem by skipping over the scsi_add_lun()
when PQ=1,PDT=0x1f is encountered, and just returns
SCSI_SCAN_TARGET_PRESENT.

If there are objections to this patch, I can add a BLIST flag and entry
for Netapp targets but would like to avoid that if possible, since it
seems like the current code might be closer to SPC-3 with this patch.

Signed-off-by: Dave Wysochanski <davidw@netapp.com>


--------------050902030406070202040000
Content-Type: text/x-patch;
 name="scsi_scan_fix_pq_1_pdt_1f.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_scan_fix_pq_1_pdt_1f.patch"

--- linux-2.6.18-rc2/drivers/scsi/scsi_scan.c	2006-07-15 17:53:08.000000000 -0400
+++ linux-2.6.18-rc2-lun0/drivers/scsi/scsi_scan.c	2006-07-27 15:18:59.000000000 -0400
@@ -955,6 +955,24 @@ static int scsi_probe_and_add_lun(struct
 		goto out_free_result;
 	}
 
+	/*
+	 * Some targets may set PQ=1 and PDT=0x1f to signal that no LUN
+	 * is attached, so don't add device.  From SCSI SPC-3, PQ=1:
+	 * "A peripheral device having the specified peripheral device 
+	 * type is not connected to this logical unit. However, the 
+	 * device server is capable of supporting the specified peripheral
+	 * device type on this logical unit."
+	 * Also, from SCSI SPC-3, PDT=0x1f:
+	 * "Unknown or no device type" 
+	 */
+	if ((result[0] >> 5) == 1 && (result[0] & 0x1f) == 0x1f) {
+		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
+					"scsi scan: PQ=1, PDT=0x1f,"
+					" no device added\n"));
+		res = SCSI_SCAN_TARGET_PRESENT;
+		goto out_free_result;
+	}
+
 	res = scsi_add_lun(sdev, result, &bflags);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {

--------------050902030406070202040000--
