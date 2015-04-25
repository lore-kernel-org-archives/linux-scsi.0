From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 3/5] target: handle odd SG mapping for data transfer memory
Date: Sat, 25 Apr 2015 23:33:28 +0900
Message-ID: <1429972410-7146-4-git-send-email-akinobu.mita@gmail.com>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Tim Chen <tim.c.chen@linux.intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

sbc_dif_generate() and sbc_dif_verify() currently assume that each
SG element for data transfer memory doesn't straddle the block size
boundary.

However, when using SG_IO ioctl, we can choose the data transfer
memory which doesn't satisfy that alignment requirement.

In order to handle such cases correctly, this change inverts the outer
loop to iterate data transfer memory and the inner loop to iterate
protection information and enables to calculate CRC for a block which
straddles multiple SG elements.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
* Changes from v2:
- Handle odd SG mapping correctly instead of giving up

 drivers/target/target_core_sbc.c | 108 +++++++++++++++++++++++++--------------
 1 file changed, 69 insertions(+), 39 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index edba39f..33d2426 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1182,27 +1182,43 @@ sbc_dif_generate(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_dif_v1_tuple *sdt;
-	struct scatterlist *dsg, *psg = cmd->t_prot_sg;
+	struct scatterlist *dsg = cmd->t_data_sg, *psg;
 	sector_t sector = cmd->t_task_lba;
 	void *daddr, *paddr;
 	int i, j, offset = 0;
+	unsigned int block_size = dev->dev_attrib.block_size;
 
-	for_each_sg(cmd->t_data_sg, dsg, cmd->t_data_nents, i) {
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
 		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 
-		for (j = 0; j < dsg->length; j += dev->dev_attrib.block_size) {
+		for (j = 0; j < psg->length;
+				j += sizeof(struct se_dif_v1_tuple)) {
+			__u16 crc = 0;
+			unsigned int avail;
 
-			if (offset >= psg->length) {
-				kunmap_atomic(paddr);
-				psg = sg_next(psg);
-				paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-				offset = 0;
+			if (offset >= dsg->length) {
+				offset -= dsg->length;
+				kunmap_atomic(daddr);
+				dsg = sg_next(dsg);
+				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 			}
 
-			sdt = paddr + offset;
-			sdt->guard_tag = cpu_to_be16(crc_t10dif(daddr + j,
-						dev->dev_attrib.block_size));
+			sdt = paddr + j;
+
+			avail = min(block_size, dsg->length - offset);
+			crc = crc_t10dif(daddr + offset, avail);
+			if (avail < block_size) {
+				kunmap_atomic(daddr);
+				dsg = sg_next(dsg);
+				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+				offset = block_size - avail;
+				crc = crc_t10dif_update(crc, daddr, offset);
+			} else {
+				offset += block_size;
+			}
+
+			sdt->guard_tag = cpu_to_be16(crc);
 			if (cmd->prot_type == TARGET_DIF_TYPE1_PROT)
 				sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
 			sdt->app_tag = 0;
@@ -1215,26 +1231,23 @@ sbc_dif_generate(struct se_cmd *cmd)
 				 be32_to_cpu(sdt->ref_tag));
 
 			sector++;
-			offset += sizeof(struct se_dif_v1_tuple);
 		}
 
-		kunmap_atomic(paddr);
 		kunmap_atomic(daddr);
+		kunmap_atomic(paddr);
 	}
 }
 
 static sense_reason_t
 sbc_dif_v1_verify(struct se_cmd *cmd, struct se_dif_v1_tuple *sdt,
-		  const void *p, sector_t sector, unsigned int ei_lba)
+		  __u16 crc, sector_t sector, unsigned int ei_lba)
 {
-	struct se_device *dev = cmd->se_dev;
-	int block_size = dev->dev_attrib.block_size;
 	__be16 csum;
 
 	if (!(cmd->prot_checks & TARGET_DIF_CHECK_GUARD))
 		goto check_ref;
 
-	csum = cpu_to_be16(crc_t10dif(p, block_size));
+	csum = cpu_to_be16(crc);
 
 	if (sdt->guard_tag != csum) {
 		pr_err("DIFv1 checksum failed on sector %llu guard tag 0x%04x"
@@ -1316,26 +1329,32 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_dif_v1_tuple *sdt;
-	struct scatterlist *dsg;
+	struct scatterlist *dsg = cmd->t_data_sg;
 	sector_t sector = start;
 	void *daddr, *paddr;
-	int i, j;
+	int i;
 	sense_reason_t rc;
+	int dsg_off = 0;
+	unsigned int block_size = dev->dev_attrib.block_size;
 
-	for_each_sg(cmd->t_data_sg, dsg, cmd->t_data_nents, i) {
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+	for (; psg && sector < start + sectors; psg = sg_next(psg)) {
 		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 
-		for (j = 0; j < dsg->length; j += dev->dev_attrib.block_size) {
-
-			if (psg_off >= psg->length) {
-				kunmap_atomic(paddr - psg->offset);
-				psg = sg_next(psg);
-				paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-				psg_off = 0;
+		for (i = psg_off; i < psg->length &&
+				sector < start + sectors;
+				i += sizeof(struct se_dif_v1_tuple)) {
+			__u16 crc;
+			unsigned int avail;
+
+			if (dsg_off >= dsg->length) {
+				dsg_off -= dsg->length;
+				kunmap_atomic(daddr);
+				dsg = sg_next(dsg);
+				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 			}
 
-			sdt = paddr + psg_off;
+			sdt = paddr + i;
 
 			pr_debug("DIF READ sector: %llu guard_tag: 0x%04x"
 				 " app_tag: 0x%04x ref_tag: %u\n",
@@ -1343,27 +1362,38 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 				 sdt->app_tag, be32_to_cpu(sdt->ref_tag));
 
 			if (sdt->app_tag == cpu_to_be16(0xffff)) {
-				sector++;
-				psg_off += sizeof(struct se_dif_v1_tuple);
-				continue;
+				dsg_off += block_size;
+				goto next;
+			}
+
+			avail = min(block_size, dsg->length - dsg_off);
+
+			crc = crc_t10dif(daddr + dsg_off, avail);
+			if (avail < block_size) {
+				kunmap_atomic(daddr);
+				dsg = sg_next(dsg);
+				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+				dsg_off = block_size - avail;
+				crc = crc_t10dif_update(crc, daddr, dsg_off);
+			} else {
+				dsg_off += block_size;
 			}
 
-			rc = sbc_dif_v1_verify(cmd, sdt, daddr + j, sector,
-					       ei_lba);
+			rc = sbc_dif_v1_verify(cmd, sdt, crc, sector, ei_lba);
 			if (rc) {
-				kunmap_atomic(paddr - psg->offset);
 				kunmap_atomic(daddr - dsg->offset);
+				kunmap_atomic(paddr - psg->offset);
 				cmd->bad_sector = sector;
 				return rc;
 			}
-
+next:
 			sector++;
 			ei_lba++;
-			psg_off += sizeof(struct se_dif_v1_tuple);
 		}
 
-		kunmap_atomic(paddr - psg->offset);
+		psg_off = 0;
 		kunmap_atomic(daddr - dsg->offset);
+		kunmap_atomic(paddr - psg->offset);
 	}
 
 	return 0;
-- 
1.9.1
