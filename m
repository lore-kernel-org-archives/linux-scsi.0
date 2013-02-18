From: Rob Evers <revers@redhat.com>
Subject: [PATCH v2 2/3] Configure reported luns
Date: Mon, 18 Feb 2013 14:15:51 -0500
Message-ID: <1361214952-28978-3-git-send-email-revers@redhat.com>
References: <1361214952-28978-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab3BRTPz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2013 14:15:55 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1IJFsMB031734
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2013 14:15:54 -0500
Received: from localhost (dhcp-186-142.bos.redhat.com [10.16.186.142])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r1IJFsen028624
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2013 14:15:54 -0500
In-Reply-To: <1361214952-28978-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change default value of max_report_luns to 16k-1.

Use data returned from max report luns command to configure the number
of logical units present if previous default of 511 isn't enough.

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/scsi_scan.c | 89 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 68 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b2abf22..671ff58 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -109,12 +109,13 @@ MODULE_PARM_DESC(scan, "sync, async or none");
  * in practice, the maximum number of LUNs suppored by any device
  * is about 16k.
  */
-static unsigned int max_scsi_report_luns = 511;
+static unsigned int max_scsi_report_luns = 16383;
 
 module_param_named(max_report_luns, max_scsi_report_luns, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_report_luns,
 		 "REPORT LUNS maximum number of LUNS received (should be"
-		 " between 1 and 16384)");
+		 " between 1 and 16383)");
+#define INITIAL_MAX_REPORT_LUNS 511
 
 static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ + 18;
 
@@ -1366,9 +1367,10 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	char devname[64];
 	unsigned int length;
 	unsigned int lun;
-	unsigned int num_luns;
+	unsigned int num_luns, num_luns_reported;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
+	struct scsi_lun *first_lun_data, *second_lun_data;
 	u8 *data;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
@@ -1409,45 +1411,90 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	/*
 	 * Allocate enough to hold the header (the same size as one scsi_lun)
 	 * plus the max number of luns we are requesting.
-	 *
-	 * Reallocating and trying again (with the exact amount we need)
-	 * would be nice, but then we need to somehow limit the size
-	 * allocated based on the available memory and the limits of
-	 * kmalloc - we don't want a kmalloc() failure of a huge value to
-	 * prevent us from finding any LUNs on this target.
 	 */
-	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
-	lun_data = kmalloc(length, GFP_ATOMIC |
-			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
-	if (!lun_data) {
+	if (max_scsi_report_luns > INITIAL_MAX_REPORT_LUNS)
+		length = (INITIAL_MAX_REPORT_LUNS + 1) *
+			sizeof(struct scsi_lun);
+	else
+		length = (max_scsi_report_luns + 1) *
+			sizeof(struct scsi_lun);
+
+	first_lun_data = kmalloc(length, GFP_ATOMIC |
+				 (sdev->host->unchecked_isa_dma ?
+				 __GFP_DMA : 0));
+	if (!first_lun_data) {
 		printk(ALLOC_FAILURE_MSG, __func__);
 		goto out;
 	}
 
-	result = scsi_do_report_luns(sdev, length, lun_data, devname);
+	result = scsi_do_report_luns(sdev, length, first_lun_data, devname);
 
 	if (result) {
 		/*
 		 * The device probably does not support a REPORT LUN command
 		 */
+		lun_data = first_lun_data;
 		ret = 1;
 		goto out_err;
 	}
 
 	/*
-	 * Get the length from the first four bytes of lun_data.
+	 * Get the length from the first four bytes of first_lun_data.
 	 */
-	data = (u8 *) lun_data->scsi_lun;
+	data = (u8 *) first_lun_data->scsi_lun;
 	length = ((data[0] << 24) | (data[1] << 16) |
 		  (data[2] << 8) | (data[3] << 0));
 
-	num_luns = (length / sizeof(struct scsi_lun));
-	if (num_luns > max_scsi_report_luns) {
+	num_luns_reported = (length / sizeof(struct scsi_lun));
+
+	if (num_luns_reported > max_scsi_report_luns) {
+		num_luns = max_scsi_report_luns;
+		length = num_luns * sizeof(struct scsi_lun);
 		printk(KERN_WARNING "scsi: On %s only %d (max_scsi_report_luns)"
 		       " of %d luns reported, try increasing"
-		       " max_scsi_report_luns.\n", devname,
-		       max_scsi_report_luns, num_luns);
-		num_luns = max_scsi_report_luns;
+		       " max_report_luns parameter.\n", devname,
+		       max_scsi_report_luns, num_luns_reported);
+	} else {
+		num_luns = num_luns_reported;
+	}
+
+	if (num_luns > INITIAL_MAX_REPORT_LUNS) {
+		/*
+		 * add one for the header
+		 */
+		length = length + sizeof(struct scsi_lun);
+		second_lun_data = kmalloc(length, GFP_ATOMIC |
+					  (sdev->host->unchecked_isa_dma ?
+					  __GFP_DMA : 0));
+		if (!second_lun_data) {
+			num_luns = INITIAL_MAX_REPORT_LUNS;
+			lun_data = first_lun_data;
+			printk(ALLOC_FAILURE_MSG, __func__);
+			printk(KERN_WARNING "scsi: On %s %d of %d luns reported.\n",
+			       devname, num_luns,
+			       num_luns_reported);
+		} else {
+			kfree(first_lun_data);
+			lun_data = second_lun_data;
+			result = scsi_do_report_luns(sdev, length,
+						     lun_data, devname);
+			if (result) {
+				ret = 1;
+				goto out_err;
+			} else {
+				/*
+				 * Get the length from the first four bytes
+				 * of second_lun_data.
+				 */
+				data = (u8 *) lun_data->scsi_lun;
+				length = ((data[0] << 24) | (data[1] << 16) |
+				  (data[2] << 8) | (data[3] << 0));
+
+				num_luns = (length / sizeof(struct scsi_lun));
+			}
+		}
+	} else {
+		lun_data = first_lun_data;
 	}
 
 	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-- 
1.7.11.7

