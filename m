From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/4] target: Fix sbc_dif_generate() for WRITE SAME
Date: Tue, 21 Apr 2015 08:36:21 +0900
Message-ID: <1429572982-6809-4-git-send-email-akinobu.mita@gmail.com>
References: <1429572982-6809-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1429572982-6809-1-git-send-email-akinobu.mita@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

For WRITE SAME, data transfer memory only contains a single block but
protection information is required for all blocks that are written by
the command.

This makes sbc_dif_generate() work for WRITE_SAME.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/target/target_core_sbc.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 982836b..9815c1b 100644
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
 sense_reason_t
 sbc_dif_generate(struct se_cmd *cmd)
 {
@@ -1185,8 +1203,15 @@ sbc_dif_generate(struct se_cmd *cmd)
 	struct scatterlist *dsg, *psg = cmd->t_prot_sg;
 	sector_t sector = cmd->t_task_lba;
 	void *daddr, *paddr;
-	int i, j, offset = 0;
+	int i, j, offset = 0, left = cmd->prot_length;
+	bool is_write_same = sbc_is_write_same(cmd);
+
+	if (is_write_same &&
+	    (cmd->t_data_sg->length != dev->dev_attrib.block_size ||
+	     cmd->t_data_nents != 1))
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
+repeat:
 	for_each_sg(cmd->t_data_sg, dsg, cmd->t_data_nents, i) {
 		if (dsg->length % dev->dev_attrib.block_size)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -1219,11 +1244,14 @@ sbc_dif_generate(struct se_cmd *cmd)
 
 			sector++;
 			offset += sizeof(struct se_dif_v1_tuple);
+			left -= sizeof(struct se_dif_v1_tuple);
 		}
 
 		kunmap_atomic(paddr);
 		kunmap_atomic(daddr);
 	}
+	if (is_write_same && left)
+		goto repeat;
 
 	return 0;
 }
-- 
1.9.1
