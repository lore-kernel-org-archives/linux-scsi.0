From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] qla2xxx: add missing includes for qla_isr
Date: Wed, 30 Aug 2017 15:12:31 +0200
Message-ID: <20170830131231.7934-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, qla2xxx-upstream@qlogic.com, Himanshu Madhani <himanshu.madhani@cavium.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Since commit 7401bc18d1ee ("scsi: qla2xxx: Add FC-NVMe command handling")
we make use of 'struct nvmefc_fcp_req' in qla24xx_nvme_iocb_entry() without
including linux/nvme-fc-driver.h where it is defined.

Add linux/nvme-fc-driver.h (and scsi/fc/fc_fs.h as nvme-fc-driver.h needs
the definition of 'struct fc_ba_rjt' from scsi/fc/fc_fs.h) to the header
files included by qla_isr.c.

Fixes: 7401bc18d1ee ("scsi: qla2xxx: Add FC-NVMe command handling")
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7b3b702ef622..b57cbe4ec32b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -14,6 +14,8 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_bsg_fc.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/fc/fc_fs.h>
+#include <linux/nvme-fc-driver.h>
 
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
 static void qla2x00_status_entry(scsi_qla_host_t *, struct rsp_que *, void *);
-- 
2.12.3
