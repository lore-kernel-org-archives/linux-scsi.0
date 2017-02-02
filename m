From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V4 13/24] aacraid: Added support to set QD of attached drives
Date: Thu, 2 Feb 2017 15:53:27 -0800
Message-ID: <20170202235338.14724-14-RaghavaAditya.Renukunta@microsemi.com>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0060.outbound.protection.outlook.com ([104.47.37.60]:36096
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752508AbdBCGa5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 01:30:57 -0500
In-Reply-To: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de

Added support to set qd of drives in slave_configure.This only works for
HBA1000 attached drives.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
---

Changes in  V2:
None

Changes in  V3:
None

Changes in  V4:
Reworked slave configure function

 drivers/scsi/aacraid/linit.c | 102 ++++++++++++++++++++++++++++++-------------
 1 file changed, 71 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 1912e7b..03d935c 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -401,61 +401,89 @@ static int aac_biosparm(struct scsi_device *sdev, struct block_device *bdev,
 static int aac_slave_configure(struct scsi_device *sdev)
 {
 	struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
+	int chn, tid;
+	unsigned int depth = 0;
+	unsigned int set_timeout = 0;
+
+	chn = aac_logical_to_phys(sdev_channel(sdev));
+	tid = sdev_id(sdev);
+	if (chn < AAC_MAX_BUSES && tid < AAC_MAX_TARGETS &&
+		aac->hba_map[chn][tid].devtype == AAC_DEVTYPE_NATIVE_RAW) {
+		depth = aac->hba_map[chn][tid].qd_limit;
+		set_timeout = 1;
+		goto common_config;
+	}
+
+
 	if (aac->jbod && (sdev->type == TYPE_DISK))
 		sdev->removable = 1;
-	if ((sdev->type == TYPE_DISK) &&
-			(sdev_channel(sdev) != CONTAINER_CHANNEL) &&
-			(!aac->jbod || sdev->inq_periph_qual) &&
-			(!aac->raid_scsi_mode || (sdev_channel(sdev) != 2))) {
+
+	if (sdev->type == TYPE_DISK
+	 && sdev_channel(sdev) != CONTAINER_CHANNEL
+	 && (!aac->jbod || sdev->inq_periph_qual)
+	 && (!aac->raid_scsi_mode || (sdev_channel(sdev) != 2))) {
+
 		if (expose_physicals == 0)
 			return -ENXIO;
+
 		if (expose_physicals < 0)
 			sdev->no_uld_attach = 1;
 	}
-	if (sdev->tagged_supported && (sdev->type == TYPE_DISK) &&
-			(!aac->raid_scsi_mode || (sdev_channel(sdev) != 2)) &&
-			!sdev->no_uld_attach) {
+
+	if (sdev->tagged_supported
+	 &&  sdev->type == TYPE_DISK
+	 &&  (!aac->raid_scsi_mode || (sdev_channel(sdev) != 2))
+	 && !sdev->no_uld_attach) {
+
 		struct scsi_device * dev;
 		struct Scsi_Host *host = sdev->host;
 		unsigned num_lsu = 0;
 		unsigned num_one = 0;
-		unsigned depth;
 		unsigned cid;
 
-		/*
-		 * Firmware has an individual device recovery time typically
-		 * of 35 seconds, give us a margin.
-		 */
-		if (sdev->request_queue->rq_timeout < (45 * HZ))
-			blk_queue_rq_timeout(sdev->request_queue, 45*HZ);
+		set_timeout = 1;
+
 		for (cid = 0; cid < aac->maximum_num_containers; ++cid)
 			if (aac->fsa_dev[cid].valid)
 				++num_lsu;
+
 		__shost_for_each_device(dev, host) {
-			if (dev->tagged_supported && (dev->type == TYPE_DISK) &&
-					(!aac->raid_scsi_mode ||
-						(sdev_channel(sdev) != 2)) &&
-					!dev->no_uld_attach) {
+			if (dev->tagged_supported
+			 && dev->type == TYPE_DISK
+			 && (!aac->raid_scsi_mode || (sdev_channel(sdev) != 2))
+			 && !dev->no_uld_attach) {
 				if ((sdev_channel(dev) != CONTAINER_CHANNEL)
-				 || !aac->fsa_dev[sdev_id(dev)].valid)
+				 || !aac->fsa_dev[sdev_id(dev)].valid) {
 					++num_lsu;
-			} else
+				}
+			} else {
 				++num_one;
+			}
 		}
+
 		if (num_lsu == 0)
 			++num_lsu;
-		depth = (host->can_queue - num_one) / num_lsu;
-		if (depth > 256)
-			depth = 256;
-		else if (depth < 2)
-			depth = 2;
-		scsi_change_queue_depth(sdev, depth);
-	} else {
-		scsi_change_queue_depth(sdev, 1);
 
-		sdev->tagged_supported = 1;
+		depth = (host->can_queue - num_one) / num_lsu;
 	}
 
+common_config:
+	/*
+	 * Firmware has an individual device recovery time typically
+	 * of 35 seconds, give us a margin.
+	 */
+	if (set_timeout && sdev->request_queue->rq_timeout < (45 * HZ))
+		blk_queue_rq_timeout(sdev->request_queue, 45*HZ);
+
+	if (depth > 256)
+		depth = 256;
+	else if (depth < 1)
+		depth = 1;
+
+	scsi_change_queue_depth(sdev, depth);
+
+	sdev->tagged_supported = 1;
+
 	return 0;
 }
 
@@ -470,6 +498,15 @@ static int aac_slave_configure(struct scsi_device *sdev)
 
 static int aac_change_queue_depth(struct scsi_device *sdev, int depth)
 {
+	struct aac_dev *aac = (struct aac_dev *)(sdev->host->hostdata);
+	int chn, tid, is_native_device = 0;
+
+	chn = aac_logical_to_phys(sdev_channel(sdev));
+	tid = sdev_id(sdev);
+	if (chn < AAC_MAX_BUSES && tid < AAC_MAX_TARGETS &&
+		aac->hba_map[chn][tid].devtype == AAC_DEVTYPE_NATIVE_RAW)
+		is_native_device = 1;
+
 	if (sdev->tagged_supported && (sdev->type == TYPE_DISK) &&
 	    (sdev_channel(sdev) == CONTAINER_CHANNEL)) {
 		struct scsi_device * dev;
@@ -491,9 +528,12 @@ static int aac_change_queue_depth(struct scsi_device *sdev, int depth)
 		else if (depth < 2)
 			depth = 2;
 		return scsi_change_queue_depth(sdev, depth);
+	} else if (is_native_device) {
+		scsi_change_queue_depth(sdev, aac->hba_map[chn][tid].qd_limit);
+	} else {
+		scsi_change_queue_depth(sdev, 1);
 	}
-
-	return scsi_change_queue_depth(sdev, 1);
+	return sdev->queue_depth;
 }
 
 static ssize_t aac_show_raid_level(struct device *dev, struct device_attribute *attr, char *buf)
-- 
2.7.4
