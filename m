From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/2] target: Pass through I/O topology for block backstores
Date: Mon, 11 Nov 2013 08:59:17 -0800
Message-ID: <1384189158-19913-2-git-send-email-agrover@redhat.com>
References: <1384189158-19913-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384189158-19913-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In addition to block size (already implemented), passing through
alignment offset, logical-to-phys block exponent, I/O granularity and
optimal I/O length will allow initiators to properly handle layout on
LUNs with 4K block sizes.

Tested with various weird values via scsi_debug module.

One thing to look at with this patch is the new block limits values --
instead of granularity 1 optimal 8192, Lio will now be returning whatever
the block device says, which may affect performance.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_iblock.c  |   43 ++++++++++++++++++++++++++++++++++
 drivers/target/target_core_sbc.c     |   12 ++++++++-
 drivers/target/target_core_spc.c     |   11 +++++++-
 include/target/target_core_backend.h |    5 ++++
 4 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index b9a3394..c87959f 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -710,6 +710,45 @@ static sector_t iblock_get_blocks(struct se_device *dev)
 	return iblock_emulate_read_cap_with_block_size(dev, bd, q);
 }
 
+static sector_t iblock_get_alignment_offset_lbas(struct se_device *dev)
+{
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct block_device *bd = ib_dev->ibd_bd;
+	int ret;
+
+	ret = bdev_alignment_offset(bd);
+	if (ret == -1)
+		return 0;
+
+	/* convert offset-bytes to offset-lbas */
+	return ret / bdev_logical_block_size(bd);
+}
+
+static unsigned int iblock_get_lbppbe(struct se_device *dev)
+{
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct block_device *bd = ib_dev->ibd_bd;
+	int logs_per_phys = bdev_physical_block_size(bd) / bdev_logical_block_size(bd);
+
+	return ilog2(logs_per_phys);
+}
+
+static unsigned int iblock_get_io_min(struct se_device *dev)
+{
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct block_device *bd = ib_dev->ibd_bd;
+
+	return bdev_io_min(bd);
+}
+
+static unsigned int iblock_get_io_opt(struct se_device *dev)
+{
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct block_device *bd = ib_dev->ibd_bd;
+
+	return bdev_io_opt(bd);
+}
+
 static struct sbc_ops iblock_sbc_ops = {
 	.execute_rw		= iblock_execute_rw,
 	.execute_sync_cache	= iblock_execute_sync_cache,
@@ -749,6 +788,10 @@ static struct se_subsystem_api iblock_template = {
 	.show_configfs_dev_params = iblock_show_configfs_dev_params,
 	.get_device_type	= sbc_get_device_type,
 	.get_blocks		= iblock_get_blocks,
+	.get_alignment_offset_lbas = iblock_get_alignment_offset_lbas,
+	.get_lbppbe		= iblock_get_lbppbe,
+	.get_io_min		= iblock_get_io_min,
+	.get_io_opt		= iblock_get_io_opt,
 	.get_write_cache	= iblock_get_write_cache,
 };
 
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 6c17295..61a30f0 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -105,12 +105,22 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 	buf[9] = (dev->dev_attrib.block_size >> 16) & 0xff;
 	buf[10] = (dev->dev_attrib.block_size >> 8) & 0xff;
 	buf[11] = dev->dev_attrib.block_size & 0xff;
+
+	if (dev->transport->get_lbppbe)
+		buf[13] = dev->transport->get_lbppbe(dev) & 0x0f;
+
+	if (dev->transport->get_alignment_offset_lbas) {
+		u16 lalba = dev->transport->get_alignment_offset_lbas(dev);
+		buf[14] = (lalba >> 8) & 0x3f;
+		buf[15] = lalba & 0xff;
+	}
+
 	/*
 	 * Set Thin Provisioning Enable bit following sbc3r22 in section
 	 * READ CAPACITY (16) byte 14 if emulate_tpu or emulate_tpws is enabled.
 	 */
 	if (dev->dev_attrib.emulate_tpu || dev->dev_attrib.emulate_tpws)
-		buf[14] = 0x80;
+		buf[14] |= 0x80;
 
 	rbuf = transport_kmap_data_sg(cmd);
 	if (rbuf) {
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 0745395..f89a86f 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -452,6 +452,7 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	struct se_device *dev = cmd->se_dev;
 	u32 max_sectors;
 	int have_tp = 0;
+	int opt, min;
 
 	/*
 	 * Following spc3r22 section 6.5.3 Block Limits VPD page, when
@@ -475,7 +476,10 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH GRANULARITY
 	 */
-	put_unaligned_be16(1, &buf[6]);
+	if (dev->transport->get_io_min && (min = dev->transport->get_io_min(dev)))
+		put_unaligned_be16(min / dev->dev_attrib.block_size, &buf[6]);
+	else
+		put_unaligned_be16(1, &buf[6]);
 
 	/*
 	 * Set MAXIMUM TRANSFER LENGTH
@@ -487,7 +491,10 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH
 	 */
-	put_unaligned_be32(dev->dev_attrib.optimal_sectors, &buf[12]);
+	if (dev->transport->get_io_opt && (opt = dev->transport->get_io_opt(dev)))
+		put_unaligned_be32(opt / dev->dev_attrib.block_size, &buf[12]);
+	else
+		put_unaligned_be32(dev->dev_attrib.optimal_sectors, &buf[12]);
 
 	/*
 	 * Exit now if we don't support TP.
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 5ebe21c..39e0114 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -34,6 +34,11 @@ struct se_subsystem_api {
 	sense_reason_t (*parse_cdb)(struct se_cmd *cmd);
 	u32 (*get_device_type)(struct se_device *);
 	sector_t (*get_blocks)(struct se_device *);
+	sector_t (*get_alignment_offset_lbas)(struct se_device *);
+	/* lbppbe = logical blocks per physical block exponent. see SBC-3 */
+	unsigned int (*get_lbppbe)(struct se_device *);
+	unsigned int (*get_io_min)(struct se_device *);
+	unsigned int (*get_io_opt)(struct se_device *);
 	unsigned char *(*get_sense_buffer)(struct se_cmd *);
 	bool (*get_write_cache)(struct se_device *);
 };
-- 
1.7.1
