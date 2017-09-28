From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: sd: Implement blacklist option for WRITE SAME w/ UNMAP
Date: Wed, 27 Sep 2017 21:35:12 -0400
Message-ID: <20170928013512.1058-1-martin.petersen@oracle.com>
References: <1506529677.4100.452.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39561 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752101AbdI1BfZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2017 21:35:25 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8S1ZO5a025179
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 28 Sep 2017 01:35:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8S1ZNqe032349
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 28 Sep 2017 01:35:23 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v8S1ZNf3004004
        for <linux-scsi@vger.kernel.org>; Thu, 28 Sep 2017 01:35:23 GMT
In-Reply-To: <1506529677.4100.452.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

SBC-4 states:

  "A MAXIMUM UNMAP LBA COUNT field set to a non-zero value indicates the
   maximum number of LBAs that may be unmapped by an UNMAP command"

  "A MAXIMUM WRITE SAME LENGTH field set to a non-zero value indicates
   the maximum number of contiguous logical blocks that the device server
   allows to be unmapped or written in a single WRITE SAME command."

Despite the spec being clear on the topic, some devices incorrectly
expect WRITE SAME commands with the UNMAP bit set to be limited to the
value reported in MAXIMUM UNMAP LBA COUNT in the Block Limits VPD.

Implement a blacklist option that can be used to accommodate devices
with this behavior.

Reported-by: Bill Kuzeja <William.Kuzeja@stratus.com>
Reported-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_scan.c    |  3 +++
 drivers/scsi/sd.c           | 16 ++++++++++++----
 include/scsi/scsi_device.h  |  1 +
 include/scsi/scsi_devinfo.h |  1 +
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e7818afeda2b..15590a063ad9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -956,6 +956,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_NO_DIF)
 		sdev->no_dif = 1;
 
+	if (*bflags & BLIST_UNMAP_LIMIT_WS)
+		sdev->unmap_limit_for_ws = 1;
+
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
 	if (*bflags & BLIST_TRY_VPD_PAGES)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b18ba3235900..347be7580181 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -715,13 +715,21 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		break;
 
 	case SD_LBP_WS16:
-		max_blocks = min_not_zero(sdkp->max_ws_blocks,
-					  (u32)SD_MAX_WS16_BLOCKS);
+		if (sdkp->device->unmap_limit_for_ws)
+			max_blocks = sdkp->max_unmap_blocks;
+		else
+			max_blocks = sdkp->max_ws_blocks;
+
+		max_blocks = min_not_zero(max_blocks, (u32)SD_MAX_WS16_BLOCKS);
 		break;
 
 	case SD_LBP_WS10:
-		max_blocks = min_not_zero(sdkp->max_ws_blocks,
-					  (u32)SD_MAX_WS10_BLOCKS);
+		if (sdkp->device->unmap_limit_for_ws)
+			max_blocks = sdkp->max_unmap_blocks;
+		else
+			max_blocks = sdkp->max_ws_blocks;
+
+		max_blocks = min_not_zero(max_blocks, (u32)SD_MAX_WS10_BLOCKS);
 		break;
 
 	case SD_LBP_ZERO:
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 82e93ee94708..67c5a9f223f7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -192,6 +192,7 @@ struct scsi_device {
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 	unsigned broken_fua:1;		/* Don't set FUA bit */
 	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
+	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 9592570e092a..36b03013d629 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -29,5 +29,6 @@
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
 #define BLIST_MAX_1024		0x40000000 /* maximum 1024 sector cdb length */
+#define BLIST_UNMAP_LIMIT_WS	0x80000000 /* Use UNMAP limit for WRITE SAME */
 
 #endif
-- 
2.14.1
