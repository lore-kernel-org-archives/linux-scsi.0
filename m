From: Tushar Dave <tushar.n.dave@oracle.com>
Subject: [PATCH v2] qlogicpti: Fix compiler warnings
Date: Wed, 23 Nov 2016 18:28:04 -0800
Message-ID: <1479954484-1301-1-git-send-email-tushar.n.dave@oracle.com>
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

For the record, qlogicpti never executes on sun4v. Therefore even
though 64bit DMA is enabled on SPARC, qlogicpti continues to use
legacy iommu that guarantees DMA address is always in 32bit range.

This patch resolves aforementioned compiler warnings.

Signed-off-by: Tushar Dave <tushar.n.dave@oracle.com>
Reviewed-by: thomas tai <thomas.tai@oracle.com>
---

v1->v2:
- Addressed comments by James Bottomley.
- commit message updated.

 drivers/scsi/qlogicpti.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

