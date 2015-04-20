From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/4] target: Abandon odd SG mapping for data transfer memory
Date: Tue, 21 Apr 2015 08:36:20 +0900
Message-ID: <1429572982-6809-3-git-send-email-akinobu.mita@gmail.com>
References: <1429572982-6809-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1429572982-6809-1-git-send-email-akinobu.mita@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

sbc_dif_generate() and sbc_dif_verify() assume that each SG element
for data transfer memory doesn't straddle the block size boundary.

However, when using SG_IO ioctl, we can choose the data transfer memory
which doesn't satisfy that alignment requirement.

This change detects such cases and makes those functions return failure
to stop continuing the operation.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/target/target_core_sbc.c       | 10 +++++++++-
 drivers/target/target_core_transport.c | 21 ++++++++++++---------
 include/target/target_core_backend.h   |  2 +-
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index edba39f..982836b 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1177,7 +1177,7 @@ err:
 }
 EXPORT_SYMBOL(sbc_execute_unmap);
 
-void
+sense_reason_t
 sbc_dif_generate(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
@@ -1188,6 +1188,9 @@ sbc_dif_generate(struct se_cmd *cmd)
 	int i, j, offset = 0;
 
 	for_each_sg(cmd->t_data_sg, dsg, cmd->t_data_nents, i) {
+		if (dsg->length % dev->dev_attrib.block_size)
+			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
 		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
 
@@ -1221,6 +1224,8 @@ sbc_dif_generate(struct se_cmd *cmd)
 		kunmap_atomic(paddr);
 		kunmap_atomic(daddr);
 	}
+
+	return 0;
 }
 
 static sense_reason_t
@@ -1323,6 +1328,9 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 	sense_reason_t rc;
 
 	for_each_sg(cmd->t_data_sg, dsg, cmd->t_data_nents, i) {
+		if (dsg->length % dev->dev_attrib.block_size)
+			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
 		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fe52883..d96852e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1760,7 +1760,7 @@ static int target_write_prot_action(struct se_cmd *cmd)
 	switch (cmd->prot_op) {
 	case TARGET_PROT_DOUT_INSERT:
 		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DOUT_INSERT))
-			sbc_dif_generate(cmd);
+			cmd->pi_err = sbc_dif_generate(cmd);
 		break;
 	case TARGET_PROT_DOUT_STRIP:
 		if (cmd->se_sess->sup_prot_ops & TARGET_PROT_DOUT_STRIP)
@@ -1769,18 +1769,19 @@ static int target_write_prot_action(struct se_cmd *cmd)
 		sectors = cmd->data_length >> ilog2(cmd->se_dev->dev_attrib.block_size);
 		cmd->pi_err = sbc_dif_verify(cmd, cmd->t_task_lba,
 					     sectors, 0, cmd->t_prot_sg, 0);
-		if (unlikely(cmd->pi_err)) {
-			spin_lock_irq(&cmd->t_state_lock);
-			cmd->transport_state &= ~CMD_T_BUSY|CMD_T_SENT;
-			spin_unlock_irq(&cmd->t_state_lock);
-			transport_generic_request_failure(cmd, cmd->pi_err);
-			return -1;
-		}
 		break;
 	default:
 		break;
 	}
 
+	if (unlikely(cmd->pi_err)) {
+		spin_lock_irq(&cmd->t_state_lock);
+		cmd->transport_state &= ~CMD_T_BUSY|CMD_T_SENT;
+		spin_unlock_irq(&cmd->t_state_lock);
+		transport_generic_request_failure(cmd, cmd->pi_err);
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -2010,7 +2011,9 @@ static bool target_read_prot_action(struct se_cmd *cmd)
 		if (cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_INSERT)
 			break;
 
-		sbc_dif_generate(cmd);
+		cmd->pi_err = sbc_dif_generate(cmd);
+		if (cmd->pi_err)
+			return true;
 		break;
 	default:
 		break;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index ab8ed4c..41dfde0 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -85,7 +85,7 @@ sense_reason_t sbc_execute_unmap(struct se_cmd *cmd,
 	sense_reason_t (*do_unmap_fn)(struct se_cmd *cmd, void *priv,
 				      sector_t lba, sector_t nolb),
 	void *priv);
-void	sbc_dif_generate(struct se_cmd *);
+sense_reason_t	sbc_dif_generate(struct se_cmd *);
 sense_reason_t	sbc_dif_verify(struct se_cmd *, sector_t, unsigned int,
 				     unsigned int, struct scatterlist *, int);
 void sbc_dif_copy_prot(struct se_cmd *, unsigned int, bool,
-- 
1.9.1
