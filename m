From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/4] target: always get capacity from ->get_blocks
Date: Thu, 25 Nov 2010 23:14:30 -0800
Message-ID: <1290755672-19819-3-git-send-email-nab@linux-iscsi.org>
References: <1290755672-19819-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm23.bullet.mail.ne1.yahoo.com ([98.138.90.86]:28187 "HELO
	nm23.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752479Ab0KZHPG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2010 02:15:06 -0500
In-Reply-To: <1290755672-19819-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Christoph Hellwig <hch@lst.de>

Always use the ->get_blocks method to get the device capacity instead of
using passthrough commands.  Implement a get_blocks method for pscsi by
Looking at the Linux struct block_device for disks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c     |   12 +++++
 drivers/target/target_core_transport.c |   73 +-------------------------------
 2 files changed, 14 insertions(+), 71 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 773ff83..5e63581 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1228,6 +1228,17 @@ static u32 pscsi_get_dma_length(u32 task_size, struct se_device *dev)
 	return PAGE_SIZE;
 }
 
+static sector_t pscsi_get_blocks(struct se_device *dev)
+{
+	struct pscsi_dev_virt *pdv = dev->dev_ptr;
+
+	if (pdv->pdv_bd && pdv->pdv_bd->bd_part)
+		return pdv->pdv_bd->bd_part->nr_sects;
+
+	dump_stack();
+	return 0;
+}
+
 /*	pscsi_handle_SAM_STATUS_failures():
  *
  *
@@ -1307,6 +1318,7 @@ static struct se_subsystem_api pscsi_template = {
 	.get_device_rev		= pscsi_get_device_rev,
 	.get_device_type	= pscsi_get_device_type,
 	.get_dma_length		= pscsi_get_dma_length,
+	.get_blocks		= pscsi_get_blocks,
 };
 
 static int __init pscsi_module_init(void)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ee1c9e4..12a2fae 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1780,66 +1780,6 @@ int transport_rescan_evpd_device_ident(
 	return 0;
 }
 
-static int transport_get_read_capacity(struct se_device *dev)
-{
-	unsigned char cdb[MAX_COMMAND_SIZE], *buf;
-	u32 blocks, v1, v2;
-	struct se_cmd *cmd;
-	unsigned long long blocks_long;
-
-	memset(cdb, 0, MAX_COMMAND_SIZE);
-	cdb[0] = 0x25; /* READ_CAPACITY */
-
-	cmd = transport_allocate_passthrough(&cdb[0], DMA_FROM_DEVICE,
-			0, NULL, 0, READ_CAP_LEN, (void *)dev);
-	if (!(cmd))
-		return -1;
-
-	if (transport_generic_passthrough(cmd) < 0) {
-		transport_passthrough_release(cmd);
-		return -1;
-	}
-
-	buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
-	blocks = (buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3];
-
-	transport_passthrough_release(cmd);
-
-	if (blocks != 0xFFFFFFFF) {
-		dev->dev_sectors_total = blocks;
-		return 0;
-	}
-
-	printk(KERN_INFO "READ_CAPACITY returned 0xFFFFFFFF, issuing"
-			" SAI_READ_CAPACITY_16\n");
-
-	memset(cdb, 0, MAX_COMMAND_SIZE);
-	cdb[0] = 0x9e; /* SERVICE_ACTION_IN */
-	cdb[1] = 0x10; /* SAI_READ_CAPACITY_16 */
-	cdb[13] = 12;
-
-	cmd = transport_allocate_passthrough(&cdb[0], DMA_FROM_DEVICE,
-			0, NULL, 0, 12, (void *)dev);
-	if (!(cmd))
-		return -1;
-
-	if (transport_generic_passthrough(cmd) < 0) {
-		transport_passthrough_release(cmd);
-		return -1;
-	}
-
-	buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
-	v1 = (buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3];
-	v2 = (buf[4] << 24) | (buf[5] << 16) | (buf[6] << 8) | buf[7];
-	blocks_long = ((unsigned long long)v2 | (unsigned long long)v1 << 32);
-
-	transport_passthrough_release(cmd);
-
-	dev->dev_sectors_total = blocks_long;
-
-	return 0;
-}
-
 static void core_setup_task_attr_emulation(struct se_device *dev)
 {
 	/*
@@ -2002,18 +1942,9 @@ struct se_device *transport_add_device_to_core_hba(
 					(void *)dev);
 	}
 
-	/*
-	 * Only perform the volume scan for peripheral type TYPE_DISK
-	 */
-	if (TRANSPORT(dev)->get_device_type(dev) != 0)
-		return dev;
+	if (TRANSPORT(dev)->get_device_type(dev) == TYPE_DISK)
+		dev->dev_sectors_total = dev->transport->get_blocks(dev);
 
-	/*
-	 * Get the sector count via READ_CAPACITY
-	 */
-	ret = transport_get_read_capacity(dev);
-	if (ret < 0)
-		goto out;
 out:
 	if (!ret)
 		return dev;
-- 
1.5.6.5

