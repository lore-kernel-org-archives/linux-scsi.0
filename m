From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 4/5] target: Fix sbc_dif_generate() and sbc_dif_verify() for WRITE SAME
Date: Sat, 25 Apr 2015 23:33:29 +0900
Message-ID: <1429972410-7146-5-git-send-email-akinobu.mita@gmail.com>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35663 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427AbbDYOeJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Apr 2015 10:34:09 -0400
In-Reply-To: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

For WRITE SAME, data transfer memory only contains a single block but
protection information is required for all blocks that are written by
the command.

This makes sbc_dif_generate() and sbc_dif_verify() work for WRITE_SAME.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
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

 drivers/target/target_core_sbc.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 33d2426..10c7cb9 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1177,6 +1177,24 @@ err:
 }
 EXPORT_SYMBOL(sbc_execute_unmap);
 
+static bool sbc_is_write_same(struct se_cmd *cmd)
+{
+	u16 service_action;
+
+	switch (cmd->t_task_cdb[0]) {
+	case WRITE_SAME:
+	case WRITE_SAME_16:
+		return true;
+	case VARIABLE_LENGTH_CMD:
+		service_action = get_unaligned_be16(&cmd->t_task_cdb[8]);
+		if (service_action == WRITE_SAME_32)
+			return true;
+		break;
+	}
+
+	return false;
+}
+
 void
 sbc_dif_generate(struct se_cmd *cmd)
 {
@@ -1187,6 +1205,7 @@ sbc_dif_generate(struct se_cmd *cmd)
 	void *daddr, *paddr;
 	int i, j, offset = 0;
 	unsigned int block_size = dev->dev_attrib.block_size;
+	bool is_write_same = sbc_is_write_same(cmd);
 
 	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
 		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
@@ -1201,6 +1220,8 @@ sbc_dif_generate(struct se_cmd *cmd)
 				offset -= dsg->length;
 				kunmap_atomic(daddr);
 				dsg = sg_next(dsg);
+				if (!dsg && is_write_same)
+					dsg = cmd->t_data_sg;
 				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 			}
 
@@ -1211,6 +1232,8 @@ sbc_dif_generate(struct se_cmd *cmd)
 			if (avail < block_size) {
 				kunmap_atomic(daddr);
 				dsg = sg_next(dsg);
+				if (!dsg && is_write_same)
+					dsg = cmd->t_data_sg;
 				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 				offset = block_size - avail;
 				crc = crc_t10dif_update(crc, daddr, offset);
@@ -1336,6 +1359,7 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 	sense_reason_t rc;
 	int dsg_off = 0;
 	unsigned int block_size = dev->dev_attrib.block_size;
+	bool is_write_same = sbc_is_write_same(cmd);
 
 	for (; psg && sector < start + sectors; psg = sg_next(psg)) {
 		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
@@ -1351,6 +1375,8 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 				dsg_off -= dsg->length;
 				kunmap_atomic(daddr);
 				dsg = sg_next(dsg);
+				if (!dsg && is_write_same)
+					dsg = cmd->t_data_sg;
 				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 			}
 
@@ -1372,6 +1398,8 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 			if (avail < block_size) {
 				kunmap_atomic(daddr);
 				dsg = sg_next(dsg);
+				if (!dsg && is_write_same)
+					dsg = cmd->t_data_sg;
 				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 				dsg_off = block_size - avail;
 				crc = crc_t10dif_update(crc, daddr, dsg_off);
-- 
1.9.1

