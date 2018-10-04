From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: lpfc: use correct maxch in lpfc_debugfs_nvmestat_data
Date: Thu, 4 Oct 2018 18:29:09 +0800
Message-ID: <20181004102909.12308-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

'maxch' should be used rather than 'phba->cfg_nvme_io_channel'

Fixes:66a210ffb877 ("scsi: lpfc: Add per io channel NVME IO statistics")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index aec5b10..fe1ec0e 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -923,7 +923,7 @@ lpfc_debugfs_nvmestat_data(struct lpfc_vport *vport, char *buf, int size)
 			maxch = 32;
 		totin = 0;
 		totout = 0;
-		for (i = 0; i < phba->cfg_nvme_io_channel; i++) {
+		for (i = 0; i < maxch; i++) {
 			cstat = &lport->cstat[i];
 			tot = atomic_read(&cstat->fc4NvmeIoCmpls);
 			totin += tot;
-- 
2.7.0
