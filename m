From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 53/87] scsi: qla4xxx: remove memset after dma_alloc_coherent
Date: Fri, 28 Jun 2019 01:42:47 +0800
Message-ID: <20190627174248.4830-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 1 -
 drivers/scsi/qla4xxx/ql4_os.c  | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index dac9a7013208..eb3167186586 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -2354,7 +2354,6 @@ int qla4_84xx_config_acb(struct scsi_qla_host *ha, int acb_config)
 		rval = QLA_ERROR;
 		goto exit_config_acb;
 	}
-	memset(acb, 0, acb_len);
 
 	switch (acb_config) {
 	case ACB_CONFIG_DISABLE:
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 8c674eca09f1..8666d4fc93da 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9478,8 +9478,6 @@ static int qla4xxx_context_reset(struct scsi_qla_host *ha)
 		goto exit_port_reset;
 	}
 
-	memset(acb, 0, acb_len);
-
 	rval = qla4xxx_get_acb(ha, acb_dma, PRIMARI_ACB, acb_len);
 	if (rval != QLA_SUCCESS) {
 		rval = -EIO;
-- 
2.11.0
