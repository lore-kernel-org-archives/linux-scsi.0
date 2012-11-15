From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 2/3] target: Add/check max_write_same_len device attribute + update block limits VPD
Date: Thu, 15 Nov 2012 20:13:58 +0000
Message-ID: <1353010439-4600-3-git-send-email-nab@linux-iscsi.org>
References: <1353010439-4600-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1353010439-4600-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a new max_write_same_len device attribute for use with
WRITE_SAME w/ UNMAP=0 backend emulation.  This can be useful for
lowering the default backend value (IBLOCK uses 0xFFFF).

Also, update block limits VPD emulation code in spc_emulate_evpd_b0() to
report MAXIMUM WRITE SAME LENGTH, and enforce max_write_same_len during
sbc_parse() -> sbc_setup_write_same() CDB sanity checking for all emulated
WRITE_SAME w/ UNMAP=0 cases.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |    4 ++++
 drivers/target/target_core_device.c   |   11 +++++++++++
 drivers/target/target_core_internal.h |    1 +
 drivers/target/target_core_sbc.c      |    8 ++++++++
 drivers/target/target_core_spc.c      |    8 +++++++-
 include/target/target_core_base.h     |    3 +++
 6 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 7b473b6..2b14164 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -676,6 +676,9 @@ SE_DEV_ATTR(unmap_granularity, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(unmap_granularity_alignment);
 SE_DEV_ATTR(unmap_granularity_alignment, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(max_write_same_len);
+SE_DEV_ATTR(max_write_same_len, S_IRUGO | S_IWUSR);
+
 CONFIGFS_EATTR_OPS(target_core_dev_attrib, se_dev_attrib, da_group);
 
 static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
@@ -701,6 +704,7 @@ static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_max_unmap_block_desc_count.attr,
 	&target_core_dev_attrib_unmap_granularity.attr,
 	&target_core_dev_attrib_unmap_granularity_alignment.attr,
+	&target_core_dev_attrib_max_write_same_len.attr,
 	NULL,
 };
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 599374e..54439bc 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -706,6 +706,16 @@ int se_dev_set_unmap_granularity_alignment(
 	return 0;
 }
 
+int se_dev_set_max_write_same_len(
+	struct se_device *dev,
+	u32 max_write_same_len)
+{
+	dev->dev_attrib.max_write_same_len = max_write_same_len;
+	pr_debug("dev[%p]: Set max_write_same_len: %u\n",
+			dev, dev->dev_attrib.max_write_same_len);
+	return 0;
+}
+
 int se_dev_set_emulate_dpo(struct se_device *dev, int flag)
 {
 	if (flag != 0 && flag != 1) {
@@ -1393,6 +1403,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.unmap_granularity = DA_UNMAP_GRANULARITY_DEFAULT;
 	dev->dev_attrib.unmap_granularity_alignment =
 				DA_UNMAP_GRANULARITY_ALIGNMENT_DEFAULT;
+	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
 	dev->dev_attrib.fabric_max_sectors = DA_FABRIC_MAX_SECTORS;
 	dev->dev_attrib.optimal_sectors = DA_FABRIC_MAX_SECTORS;
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index bc9c522..93e9c1f 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -24,6 +24,7 @@ int	se_dev_set_max_unmap_lba_count(struct se_device *, u32);
 int	se_dev_set_max_unmap_block_desc_count(struct se_device *, u32);
 int	se_dev_set_unmap_granularity(struct se_device *, u32);
 int	se_dev_set_unmap_granularity_alignment(struct se_device *, u32);
+int	se_dev_set_max_write_same_len(struct se_device *, u32);
 int	se_dev_set_emulate_dpo(struct se_device *, int);
 int	se_dev_set_emulate_fua_write(struct se_device *, int);
 int	se_dev_set_emulate_fua_read(struct se_device *, int);
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index a5a8f46..8dd8a802 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -238,6 +238,8 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
 static sense_reason_t
 sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *ops)
 {
+	unsigned int sectors = spc_get_write_same_sectors(cmd);
+
 	if ((flags[0] & 0x04) || (flags[0] & 0x02)) {
 		pr_err("WRITE_SAME PBDATA and LBDATA"
 			" bits not supported for Block Discard"
@@ -258,6 +260,12 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	if (!ops->execute_write_same)
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 
+	if (sectors > cmd->se_dev->dev_attrib.max_write_same_len) {
+		pr_warn("WRITE_SAME sectors: %u exceeds max_write_same_len: %u\n",
+			sectors, cmd->se_dev->dev_attrib.max_write_same_len);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
 	cmd->execute_cmd = ops->execute_write_same;
 	return 0;
 }
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 4b3c183..cf1b8bb 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -465,7 +465,7 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	 * Exit now if we don't support TP.
 	 */
 	if (!have_tp)
-		return 0;
+		goto max_write_same;
 
 	/*
 	 * Set MAXIMUM UNMAP LBA COUNT
@@ -491,6 +491,12 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	if (dev->dev_attrib.unmap_granularity_alignment != 0)
 		buf[32] |= 0x80; /* Set the UGAVALID bit */
 
+	/*
+	 * MAXIMUM WRITE SAME LENGTH
+	 */
+max_write_same:
+	put_unaligned_be64(dev->dev_attrib.max_write_same_len, &buf[36]);
+
 	return 0;
 }
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 5350f6e..645d90a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -71,6 +71,8 @@
 #define DA_UNMAP_GRANULARITY_DEFAULT		0
 /* Default unmap_granularity_alignment */
 #define DA_UNMAP_GRANULARITY_ALIGNMENT_DEFAULT	0
+/* Default max_write_same_len, disabled by default */
+#define DA_MAX_WRITE_SAME_LEN			0
 /* Default max transfer length */
 #define DA_FABRIC_MAX_SECTORS			8192
 /* Emulation for Direct Page Out */
@@ -609,6 +611,7 @@ struct se_dev_attrib {
 	u32		max_unmap_block_desc_count;
 	u32		unmap_granularity;
 	u32		unmap_granularity_alignment;
+	u32		max_write_same_len;
 	struct se_device *da_dev;
 	struct config_group da_group;
 };
-- 
1.7.2.5
