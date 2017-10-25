From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 1/3] cxlflash: Use derived maximum write same length
Date: Wed, 25 Oct 2017 16:35:57 -0500
Message-ID: <1508967357-54439-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1508967302-54403-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751775AbdJYVgS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Oct 2017 17:36:18 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9PLYNGX096476
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2017 17:36:18 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2du0kdd9a7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2017 17:36:17 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 25 Oct 2017 15:36:16 -0600
In-Reply-To: <1508967302-54403-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The existing write same routine within the cxlflash driver uses a
statically defined value for the maximum write same transfer length.
While this is close to the value reflected by the original device that
was supported by cxlflash, newer devices are capable of much larger
lengths. Supporting what the device is capable of offers substantial
performance improvement as the scrub routine within cxlflash operates
on 'chunk size' units (256MB with a 4K sector size).

Instead of a #define, use the write same maximum length that is stored
in the block layer in units of 512 byte sectors. This value is initially
determined from the block limits VPD page during device discovery and
can also be manipulated from sysfs. As a general cleanup, designate the
timeout used when executing the write same command as constant.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/sislite.h | 3 ---
 drivers/scsi/cxlflash/vlun.c    | 6 ++++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index 09daa86..bedf1ce 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -548,7 +548,4 @@ struct sisl_rht_entry_f1 {
 #define TMF_LUN_RESET  0x1U
 #define TMF_CLEAR_ACA  0x2U
 
-
-#define SISLITE_MAX_WS_BLOCKS 512
-
 #endif /* _SISLITE_H */
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 703bf1e..5deef57 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -428,12 +428,14 @@ static int write_same16(struct scsi_device *sdev,
 	u8 *sense_buf = NULL;
 	int rc = 0;
 	int result = 0;
-	int ws_limit = SISLITE_MAX_WS_BLOCKS;
 	u64 offset = lba;
 	int left = nblks;
-	u32 to = sdev->request_queue->rq_timeout;
 	struct cxlflash_cfg *cfg = shost_priv(sdev->host);
 	struct device *dev = &cfg->dev->dev;
+	const u32 s = ilog2(sdev->sector_size) - 9;
+	const u32 to = sdev->request_queue->rq_timeout;
+	const u32 ws_limit = blk_queue_get_max_sectors(sdev->request_queue,
+						       REQ_OP_WRITE_SAME) >> s;
 
 	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
 	scsi_cmd = kzalloc(MAX_COMMAND_SIZE, GFP_KERNEL);
-- 
2.1.0
