From: Tushar Dave <tushar.n.dave@oracle.com>
Subject: [PATCH] qlogicpti: Fix compiler warnings
Date: Wed, 23 Nov 2016 13:29:57 -0800
Message-ID: <1479936597-29061-1-git-send-email-tushar.n.dave@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, thomas.tai@oracle.com, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

qlogicpti uses '__u32' for dma handle while invoking kernel DMA APIs,
instead of using dma_addr_t. This hasn't caused any 'incompatible
pointer type' warning on SPARC because until now dma_addr_t is of
type u32. However, recent changes in SPARC ATU (iommu) enabled 64bit
DMA and therefore dma_addr_t became of type u64. This makes
'incompatible pointer type' warnings inevitable.

e.g.
drivers/scsi/qlogicpti.c: In function ‘qpti_map_queues’:
drivers/scsi/qlogicpti.c:813: warning: passing argument 3 of ‘dma_alloc_coherent’ from incompatible pointer type
./include/linux/dma-mapping.h:445: note: expected ‘dma_addr_t *’ but argument is of type ‘__u32 *’
drivers/scsi/qlogicpti.c:822: warning: passing argument 3 of ‘dma_alloc_coherent’ from incompatible pointer type
./include/linux/dma-mapping.h:445: note: expected ‘dma_addr_t *’ but argument is of type ‘__u32 *’

This patch resolves above compiler warnings.

Signed-off-by: Tushar Dave <tushar.n.dave@oracle.com>
Reviewed-by: thomas tai <thomas.tai@oracle.com>
---
 drivers/scsi/qlogicpti.c | 10 ++++++----
 drivers/scsi/qlogicpti.h |  4 ++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 69bfc0a..e25ad8c 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -315,6 +315,8 @@ static inline void qlogicpti_set_hostdev_defaults(struct qlogicpti *qpti)
 static int qlogicpti_reset_hardware(struct Scsi_Host *host)
 {
 	struct qlogicpti *qpti = (struct qlogicpti *) host->hostdata;
+	__u32 qres_dvma = (__u32)qpti->res_dvma;
+	__u32 qreq_dvma = (__u32)qpti->req_dvma;
 	u_short param[6];
 	unsigned short risc_code_addr;
 	int loop_count, i;
@@ -391,8 +393,8 @@ static int qlogicpti_reset_hardware(struct Scsi_Host *host)
 
 	param[0] = MBOX_INIT_RES_QUEUE;
 	param[1] = RES_QUEUE_LEN + 1;
-	param[2] = (u_short) (qpti->res_dvma >> 16);
-	param[3] = (u_short) (qpti->res_dvma & 0xffff);
+	param[2] = (u_short)(qres_dvma >> 16);
+	param[3] = (u_short)(qres_dvma & 0xffff);
 	param[4] = param[5] = 0;
 	if (qlogicpti_mbox_command(qpti, param, 1)) {
 		printk(KERN_EMERG "qlogicpti%d: Cannot init response queue.\n",
@@ -403,8 +405,8 @@ static int qlogicpti_reset_hardware(struct Scsi_Host *host)
 
 	param[0] = MBOX_INIT_REQ_QUEUE;
 	param[1] = QLOGICPTI_REQ_QUEUE_LEN + 1;
-	param[2] = (u_short) (qpti->req_dvma >> 16);
-	param[3] = (u_short) (qpti->req_dvma & 0xffff);
+	param[2] = (u_short)(qreq_dvma >> 16);
+	param[3] = (u_short)(qreq_dvma & 0xffff);
 	param[4] = param[5] = 0;
 	if (qlogicpti_mbox_command(qpti, param, 1)) {
 		printk(KERN_EMERG "qlogicpti%d: Cannot init request queue.\n",
diff --git a/drivers/scsi/qlogicpti.h b/drivers/scsi/qlogicpti.h
index 4377e87..892a0b0 100644
--- a/drivers/scsi/qlogicpti.h
+++ b/drivers/scsi/qlogicpti.h
@@ -356,8 +356,8 @@ struct qlogicpti {
 
 	/* The rest of the elements are unimportant for performance. */
 	struct qlogicpti         *next;
-	__u32                     res_dvma;             /* Ptr to RESPONSE bufs (DVMA)*/
-	__u32                     req_dvma;             /* Ptr to REQUEST bufs (DVMA) */
+	dma_addr_t                res_dvma;             /* Ptr to RESPONSE bufs (DVMA)*/
+	dma_addr_t                req_dvma;             /* Ptr to REQUEST bufs (DVMA) */
 	u_char	                  fware_majrev, fware_minrev, fware_micrev;
 	struct Scsi_Host         *qhost;
 	int                       qpti_id;
-- 
1.9.1

