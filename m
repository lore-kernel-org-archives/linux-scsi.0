From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: lpfc: use proper format string for dma_addr_t
Date: Mon, 27 Feb 2017 21:37:12 +0100
Message-ID: <20170227203726.3420612-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

dma_addr_t may be either u32 or u64, depending on the kernel configuration,
and we get a warning for the 32-bit case:

drivers/scsi/lpfc/lpfc_nvme.c: In function 'lpfc_nvme_ls_req':
drivers/scsi/lpfc/lpfc_logmsg.h:52:52: error: format '%llu' expects argument of type 'long long unsigned int', but argument 11 has type 'dma_addr_t {aka unsigned int}' [-Werror=format=]
drivers/scsi/lpfc/lpfc_logmsg.h:52:52: error: format '%llu' expects argument of type 'long long unsigned int', but argument 12 has type 'dma_addr_t {aka unsigned int}' [-Werror=format=]
drivers/scsi/lpfc/lpfc_nvme.c: In function 'lpfc_nvme_ls_abort':
drivers/scsi/lpfc/lpfc_logmsg.h:52:52: error: format '%llu' expects argument of type 'long long unsigned int', but argument 11 has type 'dma_addr_t {aka unsigned int}' [-Werror=format=]
drivers/scsi/lpfc/lpfc_logmsg.h:52:52: error: format '%llu' expects argument of type 'long long unsigned int', but argument 12 has type 'dma_addr_t {aka unsigned int}' [-Werror=format=]

printk has a special "%pad" format string that passes the dma address by
reference to solve this problem.

Fixes: 01649561a8b4 ("scsi: lpfc: NVME Initiator: bind to nvme_fc api")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 625b6589a34d..609a908ea9db 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -457,11 +457,11 @@ lpfc_nvme_ls_req(struct nvme_fc_local_port *pnvme_lport,
 	/* Expand print to include key fields. */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
 			 "6051 ENTER.  lport %p, rport %p lsreq%p rqstlen:%d "
-			 "rsplen:%d %llux %llux\n",
+			 "rsplen:%d %pad %pad\n",
 			 pnvme_lport, pnvme_rport,
 			 pnvme_lsreq, pnvme_lsreq->rqstlen,
-			 pnvme_lsreq->rsplen, pnvme_lsreq->rqstdma,
-			 pnvme_lsreq->rspdma);
+			 pnvme_lsreq->rsplen, &pnvme_lsreq->rqstdma,
+			 &pnvme_lsreq->rspdma);
 
 	vport->phba->fc4NvmeLsRequests++;
 
@@ -527,11 +527,11 @@ lpfc_nvme_ls_abort(struct nvme_fc_local_port *pnvme_lport,
 	/* Expand print to include key fields. */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_ABTS,
 			 "6040 ENTER.  lport %p, rport %p lsreq %p rqstlen:%d "
-			 "rsplen:%d %llux %llux\n",
+			 "rsplen:%d %pad %pad\n",
 			 pnvme_lport, pnvme_rport,
 			 pnvme_lsreq, pnvme_lsreq->rqstlen,
-			 pnvme_lsreq->rsplen, pnvme_lsreq->rqstdma,
-			 pnvme_lsreq->rspdma);
+			 pnvme_lsreq->rsplen, &pnvme_lsreq->rqstdma,
+			 &pnvme_lsreq->rspdma);
 
 	/*
 	 * Lock the ELS ring txcmplq and build a local list of all ELS IOs
-- 
2.9.0
