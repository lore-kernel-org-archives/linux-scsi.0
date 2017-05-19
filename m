From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.12-rc1
Date: Fri, 19 May 2017 15:15:25 -0700
Message-ID: <1495232125.24209.40.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42722 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756697AbdESWP3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 18:15:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the first sweep of mostly minor fixes.  There's one security
one: the read past the end of a buffer in qedf, and a panic fix for
lpfc SLI-3 adapters, but the rest are a set of include and build
dependency tidy ups and assorted other small fixes and updates.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: scsi_lib: Add #include <scsi/scsi_transport.h>

Christoph Hellwig (1):
      scsi: MAINTAINERS: update OSD entries

Colin Ian King (2):
      scsi: pmcraid: remove redundant check to see if request_size is less than zero
      scsi: lpfc: ensure els_wq is being checked before destroying it

Dan Carpenter (2):
      scsi: qedf: Cleanup the type of io_log->op
      scsi: lpfc: double lock typo in lpfc_ns_rsp()

Guenter Roeck (1):
      scsi: cxlflash: Select IRQ_POLL

Gustavo A. R. Silva (1):
      scsi: qedf: properly update arguments position in function call

Hannes Reinecke (1):
      scsi: libfc: do not flood console with messages 'libfc: queue full ...'

James Smart (1):
      scsi: lpfc: Fix panic on BFS configuration

Kees Cook (1):
      scsi: qedf: Avoid reading past end of buffer

Zhou Zhengping (1):
      scsi: Skip deleted devices in __scsi_device_lookup

And the diffstat:

 MAINTAINERS                   |  4 ----
 drivers/scsi/cxlflash/Kconfig |  1 +
 drivers/scsi/libfc/fc_fcp.c   | 15 +++++++++------
 drivers/scsi/lpfc/lpfc_crtn.h |  1 +
 drivers/scsi/lpfc/lpfc_ct.c   |  2 +-
 drivers/scsi/lpfc/lpfc_init.c |  9 ++++++++-
 drivers/scsi/lpfc/lpfc_sli.c  | 19 ++++++++++++-------
 drivers/scsi/pmcraid.c        |  3 ---
 drivers/scsi/qedf/qedf.h      |  2 +-
 drivers/scsi/qedf/qedf_els.c  |  2 +-
 drivers/scsi/qedf/qedf_main.c |  2 +-
 drivers/scsi/scsi.c           |  2 ++
 drivers/scsi/scsi_lib.c       |  1 +
 13 files changed, 38 insertions(+), 25 deletions(-)

With full diffs below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 08360bb0468b..0e174d4b86a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9530,10 +9530,6 @@ F:	drivers/net/wireless/intersil/orinoco/
 
 OSD LIBRARY and FILESYSTEM
 M:	Boaz Harrosh <ooo@electrozaur.com>
-M:	Benny Halevy <bhalevy@primarydata.com>
-L:	osd-dev@open-osd.org
-W:	http://open-osd.org
-T:	git git://git.open-osd.org/open-osd.git
 S:	Maintained
 F:	drivers/scsi/osd/
 F:	include/scsi/osd_*
diff --git a/drivers/scsi/cxlflash/Kconfig b/drivers/scsi/cxlflash/Kconfig
index c052104e523e..a011c5dbf214 100644
--- a/drivers/scsi/cxlflash/Kconfig
+++ b/drivers/scsi/cxlflash/Kconfig
@@ -5,6 +5,7 @@
 config CXLFLASH
 	tristate "Support for IBM CAPI Flash"
 	depends on PCI && SCSI && CXL && EEH
+	select IRQ_POLL
 	default m
 	help
 	  Allows CAPI Accelerated IO to Flash
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index a808e8ef1d08..234352da5c3c 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -407,11 +407,12 @@ static void fc_fcp_can_queue_ramp_up(struct fc_lport *lport)
  * can_queue. Eventually we will hit the point where we run
  * on all reserved structs.
  */
-static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
+static bool fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 {
 	struct fc_fcp_internal *si = fc_get_scsi_internal(lport);
 	unsigned long flags;
 	int can_queue;
+	bool changed = false;
 
 	spin_lock_irqsave(lport->host->host_lock, flags);
 
@@ -427,9 +428,11 @@ static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 	if (!can_queue)
 		can_queue = 1;
 	lport->host->can_queue = can_queue;
+	changed = true;
 
 unlock:
 	spin_unlock_irqrestore(lport->host->host_lock, flags);
+	return changed;
 }
 
 /*
@@ -1896,11 +1899,11 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 
 	if (!fc_fcp_lport_queue_ready(lport)) {
 		if (lport->qfull) {
-			fc_fcp_can_queue_ramp_down(lport);
-			shost_printk(KERN_ERR, lport->host,
-				     "libfc: queue full, "
-				     "reducing can_queue to %d.\n",
-				     lport->host->can_queue);
+			if (fc_fcp_can_queue_ramp_down(lport))
+				shost_printk(KERN_ERR, lport->host,
+					     "libfc: queue full, "
+					     "reducing can_queue to %d.\n",
+					     lport->host->can_queue);
 		}
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 944b32ca4931..1c55408ac718 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -294,6 +294,7 @@ int lpfc_selective_reset(struct lpfc_hba *);
 void lpfc_reset_barrier(struct lpfc_hba *);
 int lpfc_sli_brdready(struct lpfc_hba *, uint32_t);
 int lpfc_sli_brdkill(struct lpfc_hba *);
+int lpfc_sli_chipset_init(struct lpfc_hba *phba);
 int lpfc_sli_brdreset(struct lpfc_hba *);
 int lpfc_sli_brdrestart(struct lpfc_hba *);
 int lpfc_sli_hba_setup(struct lpfc_hba *);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 1487406aea77..c7962dae4dab 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -630,7 +630,7 @@ lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint8_t fc4_type,
 						NLP_EVT_DEVICE_RECOVERY);
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag &= ~NLP_NVMET_RECOV;
-			spin_lock_irq(shost->host_lock);
+			spin_unlock_irq(shost->host_lock);
 		}
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 90ae354a9c45..4b1eb98c228d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3602,6 +3602,13 @@ lpfc_get_wwpn(struct lpfc_hba *phba)
 	LPFC_MBOXQ_t *mboxq;
 	MAILBOX_t *mb;
 
+	if (phba->sli_rev < LPFC_SLI_REV4) {
+		/* Reset the port first */
+		lpfc_sli_brdrestart(phba);
+		rc = lpfc_sli_chipset_init(phba);
+		if (rc)
+			return (uint64_t)-1;
+	}
 
 	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
 						GFP_KERNEL);
@@ -8847,7 +8854,7 @@ lpfc_sli4_queue_unset(struct lpfc_hba *phba)
 		lpfc_wq_destroy(phba, phba->sli4_hba.nvmels_wq);
 
 	/* Unset ELS work queue */
-	if (phba->sli4_hba.els_cq)
+	if (phba->sli4_hba.els_wq)
 		lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
 
 	/* Unset unsolicited receive queue */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cf19f4976f5f..2a4fc00dfa9b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4204,13 +4204,16 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
 	/* Reset HBA */
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 			"0325 Reset HBA Data: x%x x%x\n",
-			phba->pport->port_state, psli->sli_flag);
+			(phba->pport) ? phba->pport->port_state : 0,
+			psli->sli_flag);
 
 	/* perform board reset */
 	phba->fc_eventTag = 0;
 	phba->link_events = 0;
-	phba->pport->fc_myDID = 0;
-	phba->pport->fc_prevDID = 0;
+	if (phba->pport) {
+		phba->pport->fc_myDID = 0;
+		phba->pport->fc_prevDID = 0;
+	}
 
 	/* Turn off parity checking and serr during the physical reset */
 	pci_read_config_word(phba->pcidev, PCI_COMMAND, &cfg_value);
@@ -4336,7 +4339,8 @@ lpfc_sli_brdrestart_s3(struct lpfc_hba *phba)
 	/* Restart HBA */
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 			"0337 Restart HBA Data: x%x x%x\n",
-			phba->pport->port_state, psli->sli_flag);
+			(phba->pport) ? phba->pport->port_state : 0,
+			psli->sli_flag);
 
 	word0 = 0;
 	mb = (MAILBOX_t *) &word0;
@@ -4350,7 +4354,7 @@ lpfc_sli_brdrestart_s3(struct lpfc_hba *phba)
 	readl(to_slim); /* flush */
 
 	/* Only skip post after fc_ffinit is completed */
-	if (phba->pport->port_state)
+	if (phba->pport && phba->pport->port_state)
 		word0 = 1;	/* This is really setting up word1 */
 	else
 		word0 = 0;	/* This is really setting up word1 */
@@ -4359,7 +4363,8 @@ lpfc_sli_brdrestart_s3(struct lpfc_hba *phba)
 	readl(to_slim); /* flush */
 
 	lpfc_sli_brdreset(phba);
-	phba->pport->stopped = 0;
+	if (phba->pport)
+		phba->pport->stopped = 0;
 	phba->link_state = LPFC_INIT_START;
 	phba->hba_flag = 0;
 	spin_unlock_irq(&phba->hbalock);
@@ -4446,7 +4451,7 @@ lpfc_sli_brdrestart(struct lpfc_hba *phba)
  * iteration, the function will restart the HBA again. The function returns
  * zero if HBA successfully restarted else returns negative error code.
  **/
-static int
+int
 lpfc_sli_chipset_init(struct lpfc_hba *phba)
 {
 	uint32_t status, i = 0;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index a4aadf5f4dc6..1cc814f1505a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3770,9 +3770,6 @@ static long pmcraid_ioctl_passthrough(
 			pmcraid_err("couldn't build passthrough ioadls\n");
 			goto out_free_cmd;
 		}
-	} else if (request_size < 0) {
-		rc = -EINVAL;
-		goto out_free_cmd;
 	}
 
 	/* If data is being written into the device, copy the data from user
diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 40aeb6bb96a2..07ee88200e91 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -259,7 +259,7 @@ struct qedf_io_log {
 	uint16_t task_id;
 	uint32_t port_id; /* Remote port fabric ID */
 	int lun;
-	char op; /* SCSI CDB */
+	unsigned char op; /* SCSI CDB */
 	uint8_t lba[4];
 	unsigned int bufflen; /* SCSI buffer length */
 	unsigned int sg_count; /* Number of SG elements */
diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index c505d41f6dc8..90627033bde6 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -109,7 +109,7 @@ static int qedf_initiate_els(struct qedf_rport *fcport, unsigned int op,
 	did = fcport->rdata->ids.port_id;
 	sid = fcport->sid;
 
-	__fc_fill_fc_hdr(fc_hdr, FC_RCTL_ELS_REQ, sid, did,
+	__fc_fill_fc_hdr(fc_hdr, FC_RCTL_ELS_REQ, did, sid,
 			   FC_TYPE_ELS, FC_FC_FIRST_SEQ | FC_FC_END_SEQ |
 			   FC_FC_SEQ_INIT, 0);
 
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index cceddd995a4b..a5c97342fd5d 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2895,7 +2895,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
 	slowpath_params.drv_rev = QEDF_DRIVER_REV_VER;
 	slowpath_params.drv_eng = QEDF_DRIVER_ENG_VER;
-	memcpy(slowpath_params.name, "qedf", QED_DRV_VER_STR_SIZE);
+	strncpy(slowpath_params.name, "qedf", QED_DRV_VER_STR_SIZE);
 	rc = qed_ops->common->slowpath_start(qedf->cdev, &slowpath_params);
 	if (rc) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Cannot start slowpath.\n");
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 7bfbcfa7af40..61cdd99ae41e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -763,6 +763,8 @@ struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
 	struct scsi_device *sdev;
 
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
 		if (sdev->channel == channel && sdev->id == id &&
 				sdev->lun ==lun)
 			return sdev;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 814a4bd8405d..e31f1cc90b81 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -30,6 +30,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h> /* __scsi_init_queue() */
 #include <scsi/scsi_dh.h>
 
 #include <trace/events/scsi.h>
