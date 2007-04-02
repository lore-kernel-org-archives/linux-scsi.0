From: brking@linux.vnet.ibm.com
Subject: [patch 1/1] scsi: Disable short inquiry log by default
Date: Mon, 02 Apr 2007 16:20:22 -0500
Message-ID: <200704022120.l32LKOZU018499@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:58879 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965918AbXDBVU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 17:20:27 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l32LKQ71011252
	for <linux-scsi@vger.kernel.org>; Mon, 2 Apr 2007 17:20:26 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l32LKPVs141148
	for <linux-scsi@vger.kernel.org>; Mon, 2 Apr 2007 15:20:25 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l32LKOpw018577
	for <linux-scsi@vger.kernel.org>; Mon, 2 Apr 2007 15:20:25 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


If a scsi device reports less than 36 bytes of standard inquiry
data, scsi core logs a KERN_INFO printk indicating this. It was
observed that this results in lots of clutter in the log on
systems with devices that respond to a SCSI Inquiry with PQ=3 or
PQ=1 with less than 36 bytes of inquiry data, such as ibmvscsi.
Disable this log by default.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/scsi_scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_scan.c~scsi_scan_short_inq_log drivers/scsi/scsi_scan.c
--- linux-2.6/drivers/scsi/scsi_scan.c~scsi_scan_short_inq_log	2007-04-02 15:10:46.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/scsi_scan.c	2007-04-02 15:13:39.000000000 -0500
@@ -662,8 +662,8 @@ static int scsi_probe_lun(struct scsi_de
 	 * strings.
 	 */
 	if (sdev->inquiry_len < 36) {
-		printk(KERN_INFO "scsi scan: INQUIRY result too short (%d),"
-				" using 36\n", sdev->inquiry_len);
+		SCSI_LOG_SCAN_BUS(1, printk(KERN_INFO "scsi scan: INQUIRY result too"
+					    " short (%d), using 36\n", sdev->inquiry_len));
 		sdev->inquiry_len = 36;
 	}
 
_
