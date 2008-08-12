From: Martin Petermann <martin@linux.vnet.ibm.com>
Subject: [patch 1/1] scsi: fix check of PQ and PDT bits for WLUNs
Date: Tue, 12 Aug 2008 13:40:38 +0200
Message-ID: <20080812114123.133900000@linux.vnet.ibm.com>
References: <20080812114037.963047000@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:36686 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbYHLLmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Aug 2008 07:42:38 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.8/8.13.8) with ESMTP id m7CBfOjR028958
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 11:41:24 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7CBfO782957448
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 13:41:24 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7CBfNSZ022603
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 13:41:24 +0200
Content-Disposition: inline; filename=scsi_scan.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Martin Petermann <martin@linux.vnet.ibm.com>

From: Martin Petermann <martin@linux.vnet.ibm.com>

With kernel version 2.6.19 a check was introduced not to create a generic
SCSI device for devices that return PQ=1 and PDT=0x1f. For WLUNs (see 
SAM-3, p. 41ff) generic SCSI devices should be created unconditionally
without looking at the PQ bit. I'm referring here to the thread "With kernel
2.6.19 no sg devices for devices that return PQ=1, PDT=0x1f" of the 
linux-scsi forum. This is my proposed fix.

Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>

---
 drivers/scsi/scsi_scan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_scan.c	2008-08-12 12:51:32.000000000 +0200
+++ b/drivers/scsi/scsi_scan.c	2008-08-12 12:58:16.000000000 +0200
@@ -75,6 +75,11 @@
 #define SCSI_SCAN_TARGET_PRESENT	1
 #define SCSI_SCAN_LUN_PRESENT		2
 
+#define SCSI_W_LUN_BASE 0xc100
+#define SCSI_W_LUN_REPORT_LUNS (SCSI_W_LUN_BASE + 1)
+#define SCSI_W_LUN_ACCESS_CONTROL (SCSI_W_LUN_BASE + 2)
+#define SCSI_W_LUN_TARGET_LOG_PAGE (SCSI_W_LUN_BASE + 3)
+
 static const char *scsi_null_device_strs = "nullnullnullnull";
 
 #define MAX_SCSI_LUNS	512
@@ -1080,7 +1085,7 @@ static int scsi_probe_and_add_lun(struct
 	 * PDT=1Fh none (no FDD connected to the requested logical unit)
 	 */
 	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
-	     (result[0] & 0x1f) == 0x1f) {
+	    (result[0] & 0x1f) == 0x1f && (lun & 0xff00) != SCSI_W_LUN_BASE) {
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 					"scsi scan: peripheral device type"
 					" of 31, no device added\n"));

-- 
