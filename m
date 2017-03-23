From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: lpfc: fix building without debugfs support
Date: Thu, 23 Mar 2017 15:53:45 +0100
Message-ID: <20170323145407.2811-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On a randconfig build without CONFIG_SCSI_LPFC_DEBUG_FS, I ran into
multiple compile failures:

drivers/scsi/lpfc/lpfc_debugfs.h: In function 'lpfc_debug_dump_wq':
drivers/scsi/lpfc/lpfc_debugfs.h:405:15: error: 'DUMP_FCP' undeclared (first use in this function); did you mean 'DUMP_VAR'?
drivers/scsi/lpfc/lpfc_debugfs.h:405:15: note: each undeclared identifier is reported only once for each function it appears in
drivers/scsi/lpfc/lpfc_debugfs.h:408:22: error: 'DUMP_NVME' undeclared (first use in this function); did you mean 'DUMP_NONE'?
drivers/scsi/lpfc/lpfc_nvmet.c: In function 'lpfc_nvmet_xmt_ls_rsp_cmp':
drivers/scsi/lpfc/lpfc_nvmet.c:109:2: error: implicit declaration of function 'lpfc_nvmeio_data'; did you mean 'lpfc_mem_free'? [-Werror=implicit-function-declaration]
drivers/scsi/lpfc/lpfc_nvmet.c: In function 'lpfc_nvmet_xmt_fcp_op':
drivers/scsi/lpfc/lpfc_nvmet.c:523:10: error: unused variable 'id' [-Werror=unused-variable]

They are all trivial to fix, so I'm doing it in a combined patch here.

Fixes: 1d9d5a9879ad ("scsi: lpfc: refactor debugfs queue dump routines")
Fixes: bd2cdd5e400f ("scsi: lpfc: NVME Initiator: Add debugfs support")
Fixes: 2b65e18202fd ("scsi: lpfc: NVME Target: Add debugfs support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_debugfs.h | 22 ++++++++++++++--------
 drivers/scsi/lpfc/lpfc_nvmet.c   |  4 ++--
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index c05f56c3023f..7b7d314af0e0 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -44,14 +44,6 @@
 /* hbqinfo output buffer size */
 #define LPFC_HBQINFO_SIZE 8192
 
-enum {
-	DUMP_FCP,
-	DUMP_NVME,
-	DUMP_MBX,
-	DUMP_ELS,
-	DUMP_NVMELS,
-};
-
 /* nvmestat output buffer size */
 #define LPFC_NVMESTAT_SIZE 8192
 #define LPFC_NVMEKTIME_SIZE 8192
@@ -283,8 +275,22 @@ struct lpfc_idiag {
 	struct lpfc_idiag_offset offset;
 	void *ptr_private;
 };
+
+#else
+
+#define lpfc_nvmeio_data(phba, fmt, arg...) \
+	no_printk(fmt, ##arg)
+
 #endif
 
+enum {
+	DUMP_FCP,
+	DUMP_NVME,
+	DUMP_MBX,
+	DUMP_ELS,
+	DUMP_NVMELS,
+};
+
 /* Mask for discovery_trace */
 #define LPFC_DISC_TRC_ELS_CMD		0x1	/* Trace ELS commands */
 #define LPFC_DISC_TRC_ELS_RSP		0x2	/* Trace ELS response */
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 7ca868f394da..acba1b67e505 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -520,7 +520,7 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 	struct lpfc_hba *phba = ctxp->phba;
 	struct lpfc_iocbq *nvmewqeq;
 	unsigned long iflags;
-	int rc, id;
+	int rc;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (phba->ktime_on) {
@@ -530,7 +530,7 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 			ctxp->ts_nvme_data = ktime_get_ns();
 	}
 	if (phba->cpucheck_on & LPFC_CHECK_NVMET_IO) {
-		id = smp_processor_id();
+		int id = smp_processor_id();
 		ctxp->cpu = id;
 		if (id < LPFC_CHECK_CPU_CNT)
 			phba->cpucheck_xmt_io[id]++;
-- 
2.9.0
