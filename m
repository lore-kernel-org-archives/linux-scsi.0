From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.10-rc7
Date: Fri, 10 Feb 2017 22:19:40 -0800
Message-ID: <1486793980.1874.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55058 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750983AbdBKGTq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 11 Feb 2017 01:19:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Six fairly small fixes.  None is a real show stopper, two automation
detected problems: one memory leak, one use after free and four others
each of which fixes something that has been a significant source of
annoyance to someone.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: qla2xxx: Fix a recently introduced memory leak

Dave Carroll (1):
      scsi: aacraid: Fix INTx/MSI-x issue with older controllers

Mauricio Faria de Oliveira (1):
      scsi: qla2xxx: Avoid that issuing a LIP triggers a kernel crash

Ram Pai (1):
      scsi: mpt3sas: Force request partial completion alignment

Steffen Maier (1):
      scsi: zfcp: fix use-after-free by not tracing WKA port open/close on failed send

ojab (1):
      scsi: mpt3sas: disable ASPM for MPI2 controllers

And the diffstat:

 drivers/s390/scsi/zfcp_fsf.c         |  8 ++++----
 drivers/scsi/aacraid/comminit.c      |  8 ++++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 18 ++++++++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c       |  3 ++-
 drivers/scsi/qla2xxx/qla_os.c        |  2 +-
 5 files changed, 31 insertions(+), 8 deletions(-)

With full diff below.

James

---

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 75f820ca..27ff38f 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1583,7 +1583,7 @@ static void zfcp_fsf_open_wka_port_handler(struct zfcp_fsf_req *req)
 int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
-	struct zfcp_fsf_req *req = NULL;
+	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1612,7 +1612,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 		zfcp_fsf_req_free(req);
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
-	if (req && !IS_ERR(req))
+	if (!retval)
 		zfcp_dbf_rec_run_wka("fsowp_1", wka_port, req->req_id);
 	return retval;
 }
@@ -1638,7 +1638,7 @@ static void zfcp_fsf_close_wka_port_handler(struct zfcp_fsf_req *req)
 int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
-	struct zfcp_fsf_req *req = NULL;
+	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1667,7 +1667,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 		zfcp_fsf_req_free(req);
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
-	if (req && !IS_ERR(req))
+	if (!retval)
 		zfcp_dbf_rec_run_wka("fscwp_1", wka_port, req->req_id);
 	return retval;
 }
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 4f56b10..5b48bed 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -50,9 +50,13 @@ struct aac_common aac_config = {
 
 static inline int aac_is_msix_mode(struct aac_dev *dev)
 {
-	u32 status;
+	u32 status = 0;
 
-	status = src_readl(dev, MUnit.OMR);
+	if (dev->pdev->device == PMC_DEVICE_S6 ||
+		dev->pdev->device == PMC_DEVICE_S7 ||
+		dev->pdev->device == PMC_DEVICE_S8) {
+		status = src_readl(dev, MUnit.OMR);
+	}
 	return (status & AAC_INT_MODE_MSIX);
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 75f3fce..0b5b423 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -51,6 +51,7 @@
 #include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/interrupt.h>
 #include <linux/aer.h>
 #include <linux/raid_class.h>
@@ -4657,6 +4658,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	u32 response_code = 0;
 	unsigned long flags;
+	unsigned int sector_sz;
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
@@ -4715,6 +4717,20 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	}
 
 	xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
+
+	/* In case of bogus fw or device, we could end up having
+	 * unaligned partial completion. We can force alignment here,
+	 * then scsi-ml does not need to handle this misbehavior.
+	 */
+	sector_sz = scmd->device->sector_size;
+	if (unlikely(scmd->request->cmd_type == REQ_TYPE_FS && sector_sz &&
+		     xfer_cnt % sector_sz)) {
+		sdev_printk(KERN_INFO, scmd->device,
+		    "unaligned partial completion avoided (xfer_cnt=%u, sector_sz=%u)\n",
+			    xfer_cnt, sector_sz);
+		xfer_cnt = round_down(xfer_cnt, sector_sz);
+	}
+
 	scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_cnt);
 	if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)
 		log_info =  le32_to_cpu(mpi_reply->IOCLogInfo);
@@ -8746,6 +8762,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	switch (hba_mpi_version) {
 	case MPI2_VERSION:
+		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
+			PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
 		/* Use mpt2sas driver host template for SAS 2.0 HBA's */
 		shost = scsi_host_alloc(&mpt2sas_driver_template,
 		  sizeof(struct MPT3SAS_ADAPTER));
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 54e1223..28ffafe 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3238,7 +3238,7 @@ qla2x00_free_irqs(scsi_qla_host_t *vha)
 	 * from a probe failure context.
 	 */
 	if (!ha->rsp_q_map || !ha->rsp_q_map[0])
-		return;
+		goto free_irqs;
 	rsp = ha->rsp_q_map[0];
 
 	if (ha->flags.msix_enabled) {
@@ -3258,6 +3258,7 @@ qla2x00_free_irqs(scsi_qla_host_t *vha)
 		free_irq(pci_irq_vector(ha->pdev, 0), rsp);
 	}
 
+free_irqs:
 	pci_free_irq_vectors(ha->pdev);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ad4edc1..1cd3c48 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1616,7 +1616,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 				/* Don't abort commands in adapter during EEH
 				 * recovery as it's not accessible/responding.
 				 */
-				if (!ha->flags.eeh_busy) {
+				if (GET_CMD_SP(sp) && !ha->flags.eeh_busy) {
 					/* Get a reference to the sp and drop the lock.
 					 * The reference ensures this sp->done() call
 					 * - and not the call in qla2xxx_eh_abort() -
