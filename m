From: Rob Evers <revers@redhat.com>
Subject: [PATCH V6 3/3] scsi: retry report-luns when reported LU count requres more memory
Date: Tue, 16 Dec 2014 11:01:20 -0500
Message-ID: <1418745680-18126-4-git-send-email-revers@redhat.com>
References: <1418745680-18126-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaLPQBX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2014 11:01:23 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBGG1NwT007629
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2014 11:01:23 -0500
Received: from localhost ([10.18.25.106])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sBGG1Nk7024920
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2014 11:01:23 -0500
In-Reply-To: <1418745680-18126-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update scsi_report_lun_scan to initially always report up to 511 LUs,
as the previous default max_report_luns did.  Retry in a loop if not
enough memory is available for the number of LUs reported.  Parameter
max_report_luns is removed as it is no longer used.

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/scsi_scan.c | 41 +++++++++++------------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8db1f6f..88eee50 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -99,20 +99,6 @@ char scsi_scan_type[6] = SCSI_SCAN_TYPE_DEFAULT;
 module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S_IRUGO);
 MODULE_PARM_DESC(scan, "sync, async or none");
 
-/*
- * max_scsi_report_luns: the maximum number of LUNS that will be
- * returned from the REPORT LUNS command. 8 times this value must
- * be allocated. In theory this could be up to an 8 byte value, but
- * in practice, the maximum number of LUNs suppored by any device
- * is about 16k.
- */
-static unsigned int max_scsi_report_luns = 511;
-
-module_param_named(max_report_luns, max_scsi_report_luns, uint, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(max_report_luns,
-		 "REPORT LUNS maximum number of LUNS received (should be"
-		 " between 1 and 16384)");
-
 static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ + 18;
 
 module_param_named(inq_timeout, scsi_inq_timeout, uint, S_IRUGO|S_IWUSR);
@@ -1399,15 +1385,11 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 
 	/*
 	 * Allocate enough to hold the header (the same size as one scsi_lun)
-	 * plus the max number of luns we are requesting.
-	 *
-	 * Reallocating and trying again (with the exact amount we need)
-	 * would be nice, but then we need to somehow limit the size
-	 * allocated based on the available memory and the limits of
-	 * kmalloc - we don't want a kmalloc() failure of a huge value to
-	 * prevent us from finding any LUNs on this target.
+	 * plus the number of luns we are requesting.  511 was the default
+	 * value of the now removed max_report_luns parameter.
 	 */
-	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
+	length = (511 + 1) * sizeof(struct scsi_lun);
+retry:
 	lun_data = kmalloc(length, GFP_KERNEL |
 			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!lun_data) {
@@ -1473,17 +1455,16 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	/*
 	 * Get the length from the first four bytes of lun_data.
 	 */
+	if (get_unaligned_be32(lun_data->scsi_lun) +
+	    sizeof(struct scsi_lun) > length) {
+		length = get_unaligned_be32(lun_data->scsi_lun) +
+			 sizeof(struct scsi_lun);
+		kfree(lun_data);
+		goto retry;
+	}
 	length = get_unaligned_be32(lun_data->scsi_lun);
 
 	num_luns = (length / sizeof(struct scsi_lun));
-	if (num_luns > max_scsi_report_luns) {
-		sdev_printk(KERN_WARNING, sdev,
-			    "Only %d (max_scsi_report_luns)"
-			    " of %d luns reported, try increasing"
-			    " max_scsi_report_luns.\n",
-			    max_scsi_report_luns, num_luns);
-		num_luns = max_scsi_report_luns;
-	}
 
 	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
 		"scsi scan: REPORT LUN scan\n"));
-- 
1.8.3.1

