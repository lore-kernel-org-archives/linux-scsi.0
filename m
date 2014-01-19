From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 04/17] target/sbc: Add DIF TYPE1+TYPE3 read/write verify emulation
Date: Sun, 19 Jan 2014 02:44:27 +0000
Message-ID: <1390099480-29013-5-git-send-email-nab@daterainc.com>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for DIF read/write verify emulation
for TARGET_DIF_TYPE1_PROT + TARGET_DIF_TYPE3_PROT operation.

This includes sbc_dif_verify_write() + sbc_dif_verify_read()
calls accessable by backend drivers to perform DIF verify
for SGL based data and protection information.

Also included is sbc_dif_copy_prot() logic to copy protection
information to/from backend provided protection SGLs.

Based on scsi_debug.c DIF TYPE1+TYPE3 emulation.

v2 changes:
  - Select CRC_T10DIF for TARGET_CORE in Kconfig (Fengguang)
  - Drop IP checksum logic from sbc_dif_v1_verify (MKP)
  - Fix offset on app_tag = 0xffff in sbc_dif_verify_read()

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Kconfig               |    1 +
 drivers/target/target_core_sbc.c     |  178 ++++++++++++++++++++++++++++++++++
 include/target/target_core_backend.h |    4 +
 3 files changed, 183 insertions(+)

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 1830368..50aad2e 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -3,6 +3,7 @@ menuconfig TARGET_CORE
 	tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
 	depends on SCSI && BLOCK
 	select CONFIGFS_FS
+	select CRC_T10DIF
 	default n
 	help
 	Say Y or M here to enable the TCM Storage Engine and ConfigFS enabled
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 91a92f3..26e8bfb 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/ratelimit.h>
+#include <linux/crc-t10dif.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
@@ -1024,3 +1025,180 @@ err:
 	return ret;
 }
 EXPORT_SYMBOL(sbc_execute_unmap);
+
+static sense_reason_t
+sbc_dif_v1_verify(struct se_device *dev, struct se_dif_v1_tuple *sdt,
+		  const void *p, sector_t sector, unsigned int ei_lba)
+{
+	int block_size = dev->dev_attrib.block_size;
+	__be16 csum;
+
+	csum = cpu_to_be16(crc_t10dif(p, block_size));
+
+	if (sdt->guard_tag != csum) {
+		pr_err("DIFv1 checksum failed on sector %llu guard tag 0x%04x"
+			" csum 0x%04x\n", (unsigned long long)sector,
+			be16_to_cpu(sdt->guard_tag), be16_to_cpu(csum));
+		return TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
+	}
+
+	if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE1_PROT &&
+	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
+		pr_err("DIFv1 Type 1 reference failed on sector: %llu tag: 0x%08x"
+		       " sector MSB: 0x%08x\n", (unsigned long long)sector,
+		       be32_to_cpu(sdt->ref_tag), (u32)(sector & 0xffffffff));
+		return TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
+	}
+
+	if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE2_PROT &&
+	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
+		pr_err("DIFv1 Type 2 reference failed on sector: %llu tag: 0x%08x"
+		       " ei_lba: 0x%08x\n", (unsigned long long)sector,
+			be32_to_cpu(sdt->ref_tag), ei_lba);
+		return TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
+	}
+
+	return 0;
+}
+
+static void
+sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
+		  struct scatterlist *sg, int sg_off)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct scatterlist *psg;
+	void *paddr, *addr;
+	unsigned int i, len, left;
+
+	left = sectors * dev->prot_length;
+
+	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
+
+		len = min(psg->length, left);
+		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+		addr = kmap_atomic(sg_page(sg)) + sg_off;
+
+		if (read)
+			memcpy(paddr, addr, len);
+		else
+			memcpy(addr, paddr, len);
+
+		left -= len;
+		kunmap_atomic(paddr);
+		kunmap_atomic(addr);
+	}
+}
+
+sense_reason_t
+sbc_dif_verify_write(struct se_cmd *cmd, sector_t start, unsigned int sectors,
+		     unsigned int ei_lba, struct scatterlist *sg, int sg_off)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct se_dif_v1_tuple *sdt;
+	struct scatterlist *dsg, *psg = cmd->t_prot_sg;
+	sector_t sector = start;
+	void *daddr, *paddr;
+	int i, j, offset = 0;
+	sense_reason_t rc;
+
+	for_each_sg(cmd->t_data_sg, dsg, cmd->t_data_nents, i) {
+		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+
+		for (j = 0; j < dsg->length; j += dev->dev_attrib.block_size) {
+
+			if (offset >= psg->length) {
+				kunmap_atomic(paddr);
+				psg = sg_next(psg);
+				paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+				offset = 0;
+			}
+
+			sdt = paddr + offset;
+
+			pr_debug("DIF WRITE sector: %llu guard_tag: 0x%04x"
+				 " app_tag: 0x%04x ref_tag: %u\n",
+				 (unsigned long long)sector, sdt->guard_tag,
+				 sdt->app_tag, be32_to_cpu(sdt->ref_tag));
+
+			rc = sbc_dif_v1_verify(dev, sdt, daddr + j, sector,
+					       ei_lba);
+			if (rc) {
+				kunmap_atomic(paddr);
+				kunmap_atomic(daddr);
+				return rc;
+			}
+
+			sector++;
+			ei_lba++;
+			offset += sizeof(struct se_dif_v1_tuple);
+		}
+
+		kunmap_atomic(paddr);
+		kunmap_atomic(daddr);
+	}
+	sbc_dif_copy_prot(cmd, sectors, false, sg, sg_off);
+
+	return 0;
+}
+EXPORT_SYMBOL(sbc_dif_verify_write);
+
+sense_reason_t
+sbc_dif_verify_read(struct se_cmd *cmd, sector_t start, unsigned int sectors,
+		    unsigned int ei_lba, struct scatterlist *sg, int sg_off)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct se_dif_v1_tuple *sdt;
+	struct scatterlist *dsg;
+	sector_t sector = start;
+	void *daddr, *paddr;
+	int i, j, offset = sg_off;
+	sense_reason_t rc;
+
+	for_each_sg(cmd->t_data_sg, dsg, cmd->t_data_nents, i) {
+		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		paddr = kmap_atomic(sg_page(sg)) + sg->offset;
+
+		for (j = 0; j < dsg->length; j += dev->dev_attrib.block_size) {
+
+			if (offset >= sg->length) {
+				kunmap_atomic(paddr);
+				sg = sg_next(sg);
+				paddr = kmap_atomic(sg_page(sg)) + sg->offset;
+				offset = 0;
+			}
+
+			sdt = paddr + offset;
+
+			pr_debug("DIF READ sector: %llu guard_tag: 0x%04x"
+				 " app_tag: 0x%04x ref_tag: %u\n",
+				 (unsigned long long)sector, sdt->guard_tag,
+				 sdt->app_tag, be32_to_cpu(sdt->ref_tag));
+
+			if (sdt->app_tag == cpu_to_be16(0xffff)) {
+				sector++;
+				offset += sizeof(struct se_dif_v1_tuple);
+				continue;
+			}
+
+			rc = sbc_dif_v1_verify(dev, sdt, daddr + j, sector,
+					       ei_lba);
+			if (rc) {
+				kunmap_atomic(paddr);
+				kunmap_atomic(daddr);
+				return rc;
+			}
+
+			sector++;
+			ei_lba++;
+			offset += sizeof(struct se_dif_v1_tuple);
+		}
+
+		kunmap_atomic(paddr);
+		kunmap_atomic(daddr);
+	}
+	sbc_dif_copy_prot(cmd, sectors, true, sg, sg_off);
+
+	return 0;
+}
+EXPORT_SYMBOL(sbc_dif_verify_read);
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 0dc2745..7020e33 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -73,6 +73,10 @@ sense_reason_t sbc_execute_unmap(struct se_cmd *cmd,
 	sense_reason_t (*do_unmap_fn)(struct se_cmd *cmd, void *priv,
 				      sector_t lba, sector_t nolb),
 	void *priv);
+sense_reason_t	sbc_dif_verify_write(struct se_cmd *, sector_t, unsigned int,
+				     unsigned int, struct scatterlist *, int);
+sense_reason_t	sbc_dif_verify_read(struct se_cmd *, sector_t, unsigned int,
+				    unsigned int, struct scatterlist *, int);
 
 void	transport_set_vpd_proto_id(struct t10_vpd *, unsigned char *);
 int	transport_set_vpd_assoc(struct t10_vpd *, unsigned char *);
-- 
1.7.10.4
