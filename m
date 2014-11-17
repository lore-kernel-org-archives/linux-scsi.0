From: Rob Evers <revers@redhat.com>
Subject: [PATCH V4 4/5] scsi: Change default value of max_report_luns to 16k-1
Date: Mon, 17 Nov 2014 10:22:09 -0500
Message-ID: <1416237730-1862-5-git-send-email-revers@redhat.com>
References: <1416237730-1862-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbaKQPWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 10:22:14 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAHFMDGf030672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2014 10:22:13 -0500
Received: from localhost ([10.18.25.106])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sAHFMD2N017084
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2014 10:22:13 -0500
In-Reply-To: <1416237730-1862-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

First, allocate a buffer large enough for report luns command to report
on 511 LUs and issue a report luns command.  This buffer size matches
the previous report lun behavior based on the original default
max_report_luns value.

If more that 511 LUs are reported in the first report luns, allocate a
new buffer with enough space, up to max_report_luns, for all the LUs
reported and re-issue the report luns command.

If the allocation of the 2nd buffer fails, use the result of the first
report luns to configure the LUs reported there.

According to T10 SPC-4 'REPORT LUNS' and 'Allocation length' specifications,
the 'REPORT LUNS parameter data format' will return normally when more space
is required to report all luns, and indicate how much total space is required
in the LUN LIST LENGTH field.

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/scsi_scan.c | 90 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 68 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 193c20c..0d9108e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -105,12 +105,13 @@ MODULE_PARM_DESC(scan, "sync, async or none");
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
 
@@ -1415,9 +1416,10 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	char devname[64];
 	unsigned int length;
 	u64 lun;
-	unsigned int num_luns;
+	unsigned int num_luns, num_luns_reported;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
+	struct scsi_lun *first_lun_data, *second_lun_data;
 	u8 *data;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
@@ -1458,48 +1460,92 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
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
-	lun_data = kmalloc(length, GFP_KERNEL |
-			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
-	if (!lun_data) {
+
+	if (max_scsi_report_luns > INITIAL_MAX_REPORT_LUNS)
+		length = (INITIAL_MAX_REPORT_LUNS + 1) *
+			  sizeof(struct scsi_lun);
+	else
+		length = (max_scsi_report_luns + 1) *
+			  sizeof(struct scsi_lun);
+
+	first_lun_data = kmalloc(length, GFP_KERNEL |
+				 (sdev->host->unchecked_isa_dma ?
+				 __GFP_DMA : 0));
+	if (!first_lun_data) {
 		printk(ALLOC_FAILURE_MSG, __func__);
 		ret = 1;
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
 		sdev_printk(KERN_WARNING, sdev,
 			    "Only %d (max_scsi_report_luns)"
 			    " of %d luns reported, try increasing"
-			    " max_scsi_report_luns.\n",
-			    max_scsi_report_luns, num_luns);
-		num_luns = max_scsi_report_luns;
-	}
+			    " max_report_luns parameter\n",
+			    max_scsi_report_luns, num_luns_reported);
+	} else
+		num_luns = num_luns_reported;
+
+	if (num_luns > INITIAL_MAX_REPORT_LUNS) {
+		/*
+		 * add one for the header
+		 */
+		length = length + sizeof(struct scsi_lun);
+		second_lun_data = kmalloc(length, GFP_KERNEL |
+					  (sdev->host->unchecked_isa_dma ?
+					  __GFP_DMA : 0));
+		if (!second_lun_data) {
+			num_luns = INITIAL_MAX_REPORT_LUNS;
+			lun_data = first_lun_data;
+			printk(ALLOC_FAILURE_MSG, __func__);
+			sdev_printk(KERN_WARNING, sdev,
+				    "Configuring %d of %d luns reported\n",
+				    num_luns, num_luns_reported);
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
+					  (data[2] << 8) | (data[3] << 0));
+
+				num_luns = (length / sizeof(struct scsi_lun));
+			}
+		}
+	} else
+		lun_data = first_lun_data;
 
 	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
 		"scsi scan: REPORT LUN scan\n"));
-- 
1.8.3.1

