From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] target: Fix divide by zero bug in fabric_max_sectors for unconfigured devices
Date: Thu, 31 Jan 2013 23:19:15 +0000
Message-ID: <1359674355-8590-3-git-send-email-nab@linux-iscsi.org>
References: <1359674355-8590-1-git-send-email-nab@linux-iscsi.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1359674355-8590-1-git-send-email-nab@linux-iscsi.org>
Sender: stable-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a possible divide by zero bug when the fabric_max_sectors
device attribute is written and backend se_device failed to be successfully
configured -> enabled.

Go ahead and use block_size=512 within se_dev_set_fabric_max_sectors()
in the event of a target_configure_device() failure case, as no valid
dev->dev_attrib.block_size value will have been setup yet.

Cc: stable@vger.kernel.org
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e269510..f2aa754 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -941,6 +941,8 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 
 int se_dev_set_fabric_max_sectors(struct se_device *dev, u32 fabric_max_sectors)
 {
+	int block_size = dev->dev_attrib.block_size;
+
 	if (dev->export_count) {
 		pr_err("dev[%p]: Unable to change SE Device"
 			" fabric_max_sectors while export_count is %d\n",
@@ -978,8 +980,12 @@ int se_dev_set_fabric_max_sectors(struct se_device *dev, u32 fabric_max_sectors)
 	/*
 	 * Align max_sectors down to PAGE_SIZE to follow transport_allocate_data_tasks()
 	 */
+	if (!block_size) {
+		block_size = 512;
+		pr_warn("Defaulting to 512 for zero block_size\n");
+	}
 	fabric_max_sectors = se_dev_align_max_sectors(fabric_max_sectors,
-						      dev->dev_attrib.block_size);
+						      block_size);
 
 	dev->dev_attrib.fabric_max_sectors = fabric_max_sectors;
 	pr_debug("dev[%p]: SE Device max_sectors changed to %u\n",
-- 
1.7.2.5
