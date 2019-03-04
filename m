From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/4] scsi: lpfc: fix unused variable warning
Date: Mon,  4 Mar 2019 20:39:08 +0100
Message-ID: <20190304193917.702601-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The newly introduced 'cpu' variable is only used inside of an optional
block, so we get a warning without CONFIG_SCSI_LPFC_DEBUG_FS:

drivers/scsi/lpfc/lpfc_nvme.c: In function 'lpfc_nvme_io_cmd_wqe_cmpl':
drivers/scsi/lpfc/lpfc_nvme.c:968:30: error: unused variable 'cpu' [-Werror=unused-variable]
  uint32_t code, status, idx, cpu;

Move the declaration into the same block to avoid the warning.

Fixes: 63df6d637e33 ("scsi: lpfc: Adapt cpucheck debugfs logic to Hardware Queues")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 72cb8ad9027b..d16ca413110d 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -965,7 +965,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_nvme_fcpreq_priv *freqpriv;
 	struct lpfc_nvme_lport *lport;
-	uint32_t code, status, idx, cpu;
+	uint32_t code, status, idx;
 	uint16_t cid, sqhd, data;
 	uint32_t *ptr;
 
@@ -1139,6 +1139,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		lpfc_nvme_ktime(phba, lpfc_ncmd);
 	}
 	if (phba->cpucheck_on & LPFC_CHECK_NVME_IO) {
+		uint32_t cpu;
 		idx = lpfc_ncmd->cur_iocbq.hba_wqidx;
 		cpu = smp_processor_id();
 		if (cpu < LPFC_CHECK_CPU_CNT) {
-- 
2.20.0
