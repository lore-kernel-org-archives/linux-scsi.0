From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: lpfc: Fix potential NULL pointer dereference in
 lpfc_nvme_fcp_io_submit
Date: Mon, 27 Nov 2017 07:52:30 -0600
Message-ID: <20171127135230.GA4546@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

pnvme_lport is being dereferenced before it is null checked, hence there
is a potential null pointer dereference.

Fix this by null checking pnvme_lport before it is dereferenced.

Addresses-Coverity-ID: 1423709 ("Dereference before null check")
Fixes: b7672ae681f8 ("scsi: lpfc: Fix crash in lpfc_nvme_fcp_io_submit during LIP")
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
Also, I wonder if the right pointer to check at line:

if (!pnvme_rport || !freqpriv) {

is pnvme_fcreq instead of freqpriv

 drivers/scsi/lpfc/lpfc_nvme.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 517ae57..68cba7d 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1251,6 +1251,11 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	uint64_t start = 0;
 #endif
 
+	if (!pnvme_lport) {
+		ret = -ENODEV;
+		goto out_fail;
+	}
+
 	lport = (struct lpfc_nvme_lport *)pnvme_lport->private;
 	vport = lport->vport;
 	phba = vport->phba;
@@ -1261,7 +1266,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	}
 
 	/* Validate pointers. */
-	if (!pnvme_lport || !pnvme_rport || !freqpriv) {
+	if (!pnvme_rport || !freqpriv) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR | LOG_NODE,
 				 "6117 No Send:IO submit ptrs NULL, lport %p, "
 				 "rport %p fcreq_priv %p\n",
-- 
2.7.4
