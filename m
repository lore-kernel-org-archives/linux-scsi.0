From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.5-rc6
Date: Wed, 11 Jul 2012 08:45:42 +0100
Message-ID: <1341992742.3522.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of three fixes for data corruption (libsas task file),
oops causing (NULL in scsi_cmd_to_driver) and driver failure (bnx2i).
The oops caused by the NULL in scsi_cmd_to_driver() manifests in
scsi_eh_send_cmd() and has been seen by several people now.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dan Williams (1):
      libsas: fix taskfile corruption in sas_ata_qc_fill_rtf

Eddie Wai (1):
      bnx2i: Removed the reference to the netdev->base_addr

Mark Rustad (1):
      Fix NULL dereferences in scsi_cmd_to_driver

And the diffstat:

 drivers/scsi/aic94xx/aic94xx_task.c |    2 +-
 drivers/scsi/bnx2i/bnx2i.h          |    1 +
 drivers/scsi/bnx2i/bnx2i_hwi.c      |    3 +--
 drivers/scsi/bnx2i/bnx2i_iscsi.c    |   10 +++++-----
 drivers/scsi/libsas/sas_ata.c       |   12 ++++++------
 include/scsi/libsas.h               |    6 ++++--
 include/scsi/scsi_cmnd.h            |    8 +++++++-
 7 files changed, 25 insertions(+), 17 deletions(-)

With the full diff below.

James

---
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 532d212..393e7ce 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -201,7 +201,7 @@ static void asd_get_response_tasklet(struct asd_ascb *ascb,
 
 		if (SAS_STATUS_BUF_SIZE >= sizeof(*resp)) {
 			resp->frame_len = le16_to_cpu(*(__le16 *)(r+6));
-			memcpy(&resp->ending_fis[0], r+16, 24);
+			memcpy(&resp->ending_fis[0], r+16, ATA_RESP_FIS_SIZE);
 			ts->buf_valid_size = sizeof(*resp);
 		}
 	}
diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 0c53c28..7e77cf6 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -350,6 +350,7 @@ struct bnx2i_hba {
 	struct pci_dev *pcidev;
 	struct net_device *netdev;
 	void __iomem *regview;
+	resource_size_t reg_base;
 
 	u32 age;
 	unsigned long cnic_dev_type;
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index ece47e5..86a12b4 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -2724,7 +2724,6 @@ int bnx2i_map_ep_dbell_regs(struct bnx2i_endpoint *ep)
 		goto arm_cq;
 	}
 
-	reg_base = ep->hba->netdev->base_addr;
 	if ((test_bit(BNX2I_NX2_DEV_5709, &ep->hba->cnic_dev_type)) &&
 	    (ep->hba->mail_queue_access == BNX2I_MQ_BIN_MODE)) {
 		config2 = REG_RD(ep->hba, BNX2_MQ_CONFIG2);
@@ -2740,7 +2739,7 @@ int bnx2i_map_ep_dbell_regs(struct bnx2i_endpoint *ep)
 		/* 5709 device in normal node and 5706/5708 devices */
 		reg_off = CTX_OFFSET + (MB_KERNEL_CTX_SIZE * cid_num);
 
-	ep->qp.ctx_base = ioremap_nocache(reg_base + reg_off,
+	ep->qp.ctx_base = ioremap_nocache(ep->hba->reg_base + reg_off,
 					  MB_KERNEL_CTX_SIZE);
 	if (!ep->qp.ctx_base)
 		return -ENOMEM;
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f8d516b..621538b 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -811,13 +811,13 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 	bnx2i_identify_device(hba);
 	bnx2i_setup_host_queue_size(hba, shost);
 
+	hba->reg_base = pci_resource_start(hba->pcidev, 0);
 	if (test_bit(BNX2I_NX2_DEV_5709, &hba->cnic_dev_type)) {
-		hba->regview = ioremap_nocache(hba->netdev->base_addr,
-					       BNX2_MQ_CONFIG2);
+		hba->regview = pci_iomap(hba->pcidev, 0, BNX2_MQ_CONFIG2);
 		if (!hba->regview)
 			goto ioreg_map_err;
 	} else if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type)) {
-		hba->regview = ioremap_nocache(hba->netdev->base_addr, 4096);
+		hba->regview = pci_iomap(hba->pcidev, 0, 4096);
 		if (!hba->regview)
 			goto ioreg_map_err;
 	}
@@ -884,7 +884,7 @@ cid_que_err:
 	bnx2i_free_mp_bdt(hba);
 mp_bdt_mem_err:
 	if (hba->regview) {
-		iounmap(hba->regview);
+		pci_iounmap(hba->pcidev, hba->regview);
 		hba->regview = NULL;
 	}
 ioreg_map_err:
@@ -910,7 +910,7 @@ void bnx2i_free_hba(struct bnx2i_hba *hba)
 	pci_dev_put(hba->pcidev);
 
 	if (hba->regview) {
-		iounmap(hba->regview);
+		pci_iounmap(hba->pcidev, hba->regview);
 		hba->regview = NULL;
 	}
 	bnx2i_free_mp_bdt(hba);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 441d88a..d109cc3 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -139,12 +139,12 @@ static void sas_ata_task_done(struct sas_task *task)
 	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_STAT_GOOD ||
 	    ((stat->stat == SAM_STAT_CHECK_CONDITION &&
 	      dev->sata_dev.command_set == ATAPI_COMMAND_SET))) {
-		ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
+		memcpy(dev->sata_dev.fis, resp->ending_fis, ATA_RESP_FIS_SIZE);
 
 		if (!link->sactive) {
-			qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
+			qc->err_mask |= ac_err_mask(dev->sata_dev.fis[2]);
 		} else {
-			link->eh_info.err_mask |= ac_err_mask(dev->sata_dev.tf.command);
+			link->eh_info.err_mask |= ac_err_mask(dev->sata_dev.fis[2]);
 			if (unlikely(link->eh_info.err_mask))
 				qc->flags |= ATA_QCFLAG_FAILED;
 		}
@@ -161,8 +161,8 @@ static void sas_ata_task_done(struct sas_task *task)
 				qc->flags |= ATA_QCFLAG_FAILED;
 			}
 
-			dev->sata_dev.tf.feature = 0x04; /* status err */
-			dev->sata_dev.tf.command = ATA_ERR;
+			dev->sata_dev.fis[3] = 0x04; /* status err */
+			dev->sata_dev.fis[2] = ATA_ERR;
 		}
 	}
 
@@ -269,7 +269,7 @@ static bool sas_ata_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
 	struct domain_device *dev = qc->ap->private_data;
 
-	memcpy(&qc->result_tf, &dev->sata_dev.tf, sizeof(qc->result_tf));
+	ata_tf_from_fis(dev->sata_dev.fis, &qc->result_tf);
 	return true;
 }
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index f4f1c96..10ce74f 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -163,6 +163,8 @@ enum ata_command_set {
         ATAPI_COMMAND_SET = 1,
 };
 
+#define ATA_RESP_FIS_SIZE 24
+
 struct sata_device {
         enum   ata_command_set command_set;
         struct smp_resp        rps_resp; /* report_phy_sata_resp */
@@ -171,7 +173,7 @@ struct sata_device {
 
 	struct ata_port *ap;
 	struct ata_host ata_host;
-	struct ata_taskfile tf;
+	u8     fis[ATA_RESP_FIS_SIZE];
 };
 
 enum {
@@ -537,7 +539,7 @@ enum exec_status {
  */
 struct ata_task_resp {
 	u16  frame_len;
-	u8   ending_fis[24];	  /* dev to host or data-in */
+	u8   ending_fis[ATA_RESP_FIS_SIZE];	  /* dev to host or data-in */
 };
 
 #define SAS_STATUS_BUF_SIZE 96
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 1e11985..ac06cc5 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -134,10 +134,16 @@ struct scsi_cmnd {
 
 static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 {
+	struct scsi_driver **sdp;
+
 	if (!cmd->request->rq_disk)
 		return NULL;
 
-	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
+	sdp = (struct scsi_driver **)cmd->request->rq_disk->private_data;
+	if (!sdp)
+		return NULL;
+
+	return *sdp;
 }
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
