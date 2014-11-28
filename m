From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 16/16] target: Drop left-over PHBA_PDEV set attr checks
Date: Fri, 28 Nov 2014 09:06:42 +0000
Message-ID: <1417165602-32359-17-git-send-email-nab@daterainc.com>
References: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Now that PSCSI is only exposing four hw_* read-only device attributes,
go ahead and drop the left-over -> legacy PHBA_PDEV checks in various
se_dev_set_* code, since it's now only used by virtual devices.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 64 ++++++-------------------------------
 1 file changed, 10 insertions(+), 54 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 953fff7..7653cfb 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -767,12 +767,6 @@ int se_dev_set_emulate_fua_write(struct se_device *dev, int flag)
 		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
-
-	if (flag &&
-	    dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
-		pr_err("emulate_fua_write not supported for pSCSI\n");
-		return -EINVAL;
-	}
 	dev->dev_attrib.emulate_fua_write = flag;
 	pr_debug("dev[%p]: SE Device Forced Unit Access WRITEs: %d\n",
 			dev, dev->dev_attrib.emulate_fua_write);
@@ -803,11 +797,6 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
 		return -EINVAL;
 	}
 	if (flag &&
-	    dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
-		pr_err("emulate_write_cache not supported for pSCSI\n");
-		return -EINVAL;
-	}
-	if (flag &&
 	    dev->transport->get_write_cache) {
 		pr_err("emulate_write_cache not supported for this device\n");
 		return -EINVAL;
@@ -1098,26 +1087,15 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 		return -EINVAL;
 	}
 
-	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
+	if (queue_depth > dev->dev_attrib.queue_depth) {
 		if (queue_depth > dev->dev_attrib.hw_queue_depth) {
-			pr_err("dev[%p]: Passed queue_depth: %u"
-				" exceeds TCM/SE_Device TCQ: %u\n",
-				dev, queue_depth,
+			pr_err("dev[%p]: Passed queue_depth:"
+				" %u exceeds TCM/SE_Device MAX"
+				" TCQ: %u\n", dev, queue_depth,
 				dev->dev_attrib.hw_queue_depth);
 			return -EINVAL;
 		}
-	} else {
-		if (queue_depth > dev->dev_attrib.queue_depth) {
-			if (queue_depth > dev->dev_attrib.hw_queue_depth) {
-				pr_err("dev[%p]: Passed queue_depth:"
-					" %u exceeds TCM/SE_Device MAX"
-					" TCQ: %u\n", dev, queue_depth,
-					dev->dev_attrib.hw_queue_depth);
-				return -EINVAL;
-			}
-		}
 	}
-
 	dev->dev_attrib.queue_depth = dev->queue_depth = queue_depth;
 	pr_debug("dev[%p]: SE Device TCQ Depth changed to: %u\n",
 			dev, queue_depth);
@@ -1146,22 +1124,12 @@ int se_dev_set_fabric_max_sectors(struct se_device *dev, u32 fabric_max_sectors)
 				DA_STATUS_MAX_SECTORS_MIN);
 		return -EINVAL;
 	}
-	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
-		if (fabric_max_sectors > dev->dev_attrib.hw_max_sectors) {
-			pr_err("dev[%p]: Passed fabric_max_sectors: %u"
-				" greater than TCM/SE_Device max_sectors:"
-				" %u\n", dev, fabric_max_sectors,
-				dev->dev_attrib.hw_max_sectors);
-			 return -EINVAL;
-		}
-	} else {
-		if (fabric_max_sectors > DA_STATUS_MAX_SECTORS_MAX) {
-			pr_err("dev[%p]: Passed fabric_max_sectors: %u"
-				" greater than DA_STATUS_MAX_SECTORS_MAX:"
-				" %u\n", dev, fabric_max_sectors,
-				DA_STATUS_MAX_SECTORS_MAX);
-			return -EINVAL;
-		}
+	if (fabric_max_sectors > DA_STATUS_MAX_SECTORS_MAX) {
+		pr_err("dev[%p]: Passed fabric_max_sectors: %u"
+			" greater than DA_STATUS_MAX_SECTORS_MAX:"
+			" %u\n", dev, fabric_max_sectors,
+			DA_STATUS_MAX_SECTORS_MAX);
+		return -EINVAL;
 	}
 	/*
 	 * Align max_sectors down to PAGE_SIZE to follow transport_allocate_data_tasks()
@@ -1188,11 +1156,6 @@ int se_dev_set_optimal_sectors(struct se_device *dev, u32 optimal_sectors)
 			dev, dev->export_count);
 		return -EINVAL;
 	}
-	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
-		pr_err("dev[%p]: Passed optimal_sectors cannot be"
-				" changed for TCM/pSCSI\n", dev);
-		return -EINVAL;
-	}
 	if (optimal_sectors > dev->dev_attrib.fabric_max_sectors) {
 		pr_err("dev[%p]: Passed optimal_sectors %u cannot be"
 			" greater than fabric_max_sectors: %u\n", dev,
@@ -1226,13 +1189,6 @@ int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 		return -EINVAL;
 	}
 
-	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
-		pr_err("dev[%p]: Not allowed to change block_size for"
-			" Physical Device, use for Linux/SCSI to change"
-			" block_size for underlying hardware\n", dev);
-		return -EINVAL;
-	}
-
 	dev->dev_attrib.block_size = block_size;
 	pr_debug("dev[%p]: SE Device block_size changed to %u\n",
 			dev, block_size);
-- 
1.9.1
