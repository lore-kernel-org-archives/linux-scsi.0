From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 6/9] target/sbc: Add sbc_dif_write_insert software emulation
Date: Thu,  3 Apr 2014 09:35:50 +0000
Message-ID: <1396517753-23546-7-git-send-email-nab@daterainc.com>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds WRITE_INSERT emulation within target-core
using TYPE1 / TYPE3 PI modes.

This is useful in order for existing legacy fabrics that do not
support protection offloads to interact with backend devices that
currently have T10 PI enabled.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c     |   44 ++++++++++++++++++++++++++++++++++
 include/target/target_core_backend.h |    1 +
 2 files changed, 45 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index f2d73dd..97b207d 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1096,6 +1096,50 @@ err:
 }
 EXPORT_SYMBOL(sbc_execute_unmap);
 
+void
+sbc_dif_write_insert(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct se_dif_v1_tuple *sdt;
+	struct scatterlist *dsg, *psg = cmd->t_prot_sg;
+	sector_t sector = cmd->t_task_lba;
+	void *daddr, *paddr;
+	int i, j, offset = 0;
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
+			sdt->guard_tag = cpu_to_be16(crc_t10dif(daddr + j,
+						dev->dev_attrib.block_size));
+			if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE1_PROT)
+				sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
+			sdt->app_tag = 0;
+
+			pr_debug("DIF WRITE INSERT sector: %llu guard_tag: 0x%04x"
+				 " app_tag: 0x%04x ref_tag: %u\n",
+				 (unsigned long long)sector, sdt->guard_tag,
+				 sdt->app_tag, be32_to_cpu(sdt->ref_tag));
+
+			sector++;
+			offset += sizeof(struct se_dif_v1_tuple);
+		}
+
+		kunmap_atomic(paddr);
+		kunmap_atomic(daddr);
+	}
+}
+
 static sense_reason_t
 sbc_dif_v1_verify(struct se_device *dev, struct se_dif_v1_tuple *sdt,
 		  const void *p, sector_t sector, unsigned int ei_lba)
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 7020e33..8e6eac6 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -73,6 +73,7 @@ sense_reason_t sbc_execute_unmap(struct se_cmd *cmd,
 	sense_reason_t (*do_unmap_fn)(struct se_cmd *cmd, void *priv,
 				      sector_t lba, sector_t nolb),
 	void *priv);
+void	sbc_dif_write_insert(struct se_cmd *);
 sense_reason_t	sbc_dif_verify_write(struct se_cmd *, sector_t, unsigned int,
 				     unsigned int, struct scatterlist *, int);
 sense_reason_t	sbc_dif_verify_read(struct se_cmd *, sector_t, unsigned int,
-- 
1.7.10.4
