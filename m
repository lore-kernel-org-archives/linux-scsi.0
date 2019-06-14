From: Branden Bonaby <brandonbonaby94@gmail.com>
Subject: [PATCH] scsi: storvsc: Add ability to change scsi queue depth
Date: Fri, 14 Jun 2019 19:48:22 -0400
Message-ID: <20190614234822.5193-1-brandonbonaby94@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: Branden Bonaby <brandonbonaby94@gmail.com>, linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Adding functionality to allow the SCSI queue depth to be changed,
by utilizing the "scsi_change_queue_depth" function.

Signed-off-by: Branden Bonaby <brandonbonaby94@gmail.com>
---
 drivers/scsi/storvsc_drv.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8472de1007ff..719ca9906fc2 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -387,6 +387,7 @@ enum storvsc_request_type {
 
 static int storvsc_ringbuffer_size = (128 * 1024);
 static u32 max_outstanding_req_per_channel;
+static int storvsc_change_queue_depth(struct scsi_device *sdev, int queue_depth);
 
 static int storvsc_vcpus_per_sub_channel = 4;
 
@@ -1711,6 +1712,7 @@ static struct scsi_host_template scsi_driver = {
 	.dma_boundary =		PAGE_SIZE-1,
 	.no_write_same =	1,
 	.track_queue_depth =	1,
+	.change_queue_depth =	storvsc_change_queue_depth,
 };
 
 enum {
@@ -1917,6 +1919,15 @@ static int storvsc_probe(struct hv_device *device,
 	return ret;
 }
 
+/* Change a scsi target's queue depth */
+static int storvsc_change_queue_depth(struct scsi_device *sdev, int queue_depth)
+{
+	if (queue_depth > scsi_driver.can_queue){
+		queue_depth = scsi_driver.can_queue;
+	}
+	return scsi_change_queue_depth(sdev, queue_depth);
+}
+
 static int storvsc_remove(struct hv_device *dev)
 {
 	struct storvsc_device *stor_device = hv_get_drvdata(dev);
-- 
2.17.1
