From: Brian King <brking@us.ibm.com>
Subject: [PATCH 2.4] sd terabyte disk fix
Date: Thu, 27 May 2004 22:10:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B6ADA9.3010407@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020800010807000307040509"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:64190 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262170AbUE1DKg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 23:10:36 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020800010807000307040509
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James,

The following bug was hit when creating a hardware RAID array > 1 TB.
Please apply.

Thanks

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------020800010807000307040509
Content-Type: text/plain;
 name="sd_terabyte_disk.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sd_terabyte_disk.patch"


This patch fixes a signed/unsigned bug that prevented > 1TB
scsi disks from working.


---

 linux-2.4.26-bjking1/drivers/scsi/sd.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/sd.c~sd_terabyte_disk drivers/scsi/sd.c
--- linux-2.4.26/drivers/scsi/sd.c~sd_terabyte_disk	2004-05-26 10:06:58.000000000 -0500
+++ linux-2.4.26-bjking1/drivers/scsi/sd.c	2004-05-27 22:05:32.000000000 -0500
@@ -294,7 +294,8 @@ static request_queue_t *sd_find_queue(kd
 
 static int sd_init_command(Scsi_Cmnd * SCpnt)
 {
-	int dev, block, this_count;
+	int dev, this_count;
+	unsigned int block;
 	struct hd_struct *ppnt;
 	Scsi_Disk *dpnt;
 #if CONFIG_SCSI_LOGGING
@@ -307,7 +308,7 @@ static int sd_init_command(Scsi_Cmnd * S
 	block = SCpnt->request.sector;
 	this_count = SCpnt->request_bufflen >> 9;
 
-	SCSI_LOG_HLQUEUE(1, printk("Doing sd request, dev = 0x%x, block = %d\n",
+	SCSI_LOG_HLQUEUE(1, printk("Doing sd request, dev = 0x%x, block = %u\n",
 	    SCpnt->request.rq_dev, block));
 
 	dpnt = &rscsi_disks[dev];
@@ -329,7 +330,7 @@ static int sd_init_command(Scsi_Cmnd * S
 		return 0;
 	}
 	SCSI_LOG_HLQUEUE(2, sd_devname(dev, nbuff));
-	SCSI_LOG_HLQUEUE(2, printk("%s : real dev = /dev/%d, block = %d\n",
+	SCSI_LOG_HLQUEUE(2, printk("%s : real dev = /dev/%d, block = %u\n",
 				   nbuff, dev, block));
 
 	/*

_

--------------020800010807000307040509--

