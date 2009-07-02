From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.31-rc1
Date: Thu, 02 Jul 2009 09:16:51 -0500
Message-ID: <1246544211.4055.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:32831 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbZGBOQw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2009 10:16:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Surprisingly we only have a small number of these, and they're spread
around both the new features and the old code (the fix checks on
unsigned actually prevents an oops on dma mapping failure).  The patch
is here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

      fnic: use DMA_BIT_MASK(nn) instead of deprecated DMA_nnBIT_MASK

Brian King (1):
      ibmvscsi: Fix module load hang

Christof Schmitt (1):
      FC transport: Locking fix for common-code FC pass-through patch

James Bottomley (1):
      zalon: fix oops on attach failure

Karen Xie (1):
      cxgb3i: fix connection error when vlan is enabled

Roel Kluin (1):
      fnic: remove redundant BUG_ONs and fix checks on unsigned

The diffstat is:

 drivers/scsi/cxgb3i/cxgb3i_iscsi.c |    4 ++++
 drivers/scsi/fnic/fnic_main.c      |    8 ++++----
 drivers/scsi/fnic/fnic_scsi.c      |    7 ++-----
 drivers/scsi/ibmvscsi/ibmvscsi.c   |    7 ++++++-
 drivers/scsi/scsi_transport_fc.c   |    5 +++--
 drivers/scsi/zalon.c               |    2 +-
 6 files changed, 20 insertions(+), 13 deletions(-)

Full diff below.

James

---

diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index 74369a3..c399f48 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -13,6 +13,7 @@
 
 #include <linux/inet.h>
 #include <linux/crypto.h>
+#include <linux/if_vlan.h>
 #include <net/dst.h>
 #include <net/tcp.h>
 #include <scsi/scsi_cmnd.h>
@@ -184,6 +185,9 @@ static struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *ndev)
 	struct cxgb3i_adapter *snic;
 	int i;
 
+	if (ndev->priv_flags & IFF_802_1Q_VLAN)
+		ndev = vlan_dev_real_dev(ndev);
+
 	read_lock(&cxgb3i_snic_rwlock);
 	list_for_each_entry(snic, &cxgb3i_snic_list, list_head) {
 		for (i = 0; i < snic->hba_cnt; i++) {
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index a840728..2c266c0 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -473,16 +473,16 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	 * limitation for the device.  Try 40-bit first, and
 	 * fail to 32-bit.
 	 */
-	err = pci_set_dma_mask(pdev, DMA_40BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(40));
 	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			shost_printk(KERN_ERR, fnic->lport->host,
 				     "No usable DMA configuration "
 				     "aborting\n");
 			goto err_out_release_regions;
 		}
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
 			shost_printk(KERN_ERR, fnic->lport->host,
 				     "Unable to obtain 32-bit DMA "
@@ -490,7 +490,7 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 			goto err_out_release_regions;
 		}
 	} else {
-		err = pci_set_consistent_dma_mask(pdev, DMA_40BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(40));
 		if (err) {
 			shost_printk(KERN_ERR, fnic->lport->host,
 				     "Unable to obtain 40-bit DMA "
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index eabf365..bfc9969 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -245,7 +245,7 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 					  struct vnic_wq_copy *wq,
 					  struct fnic_io_req *io_req,
 					  struct scsi_cmnd *sc,
-					  u32 sg_count)
+					  int sg_count)
 {
 	struct scatterlist *sg;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc->device));
@@ -260,9 +260,6 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 	char msg[2];
 
 	if (sg_count) {
-		BUG_ON(sg_count < 0);
-		BUG_ON(sg_count > FNIC_MAX_SG_DESC_CNT);
-
 		/* For each SGE, create a device desc entry */
 		desc = io_req->sgl_list;
 		for_each_sg(scsi_sglist(sc), sg, sg_count, i) {
@@ -344,7 +341,7 @@ int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	struct fnic *fnic;
 	struct vnic_wq_copy *wq;
 	int ret;
-	u32 sg_count;
+	int sg_count;
 	unsigned long flags;
 	unsigned long ptr;
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 869a11b..9928704 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1095,9 +1095,14 @@ static void adapter_info_rsp(struct srp_event_struct *evt_struct)
 				MAX_INDIRECT_BUFS);
 			hostdata->host->sg_tablesize = MAX_INDIRECT_BUFS;
 		}
+
+		if (hostdata->madapter_info.os_type == 3) {
+			enable_fast_fail(hostdata);
+			return;
+		}
 	}
 
-	enable_fast_fail(hostdata);
+	send_srp_login(hostdata);
 }
 
 /**
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2eee9e6..292c02f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3670,13 +3670,14 @@ static void
 fc_bsg_goose_queue(struct fc_rport *rport)
 {
 	int flagset;
+	unsigned long flags;
 
 	if (!rport->rqst_q)
 		return;
 
 	get_device(&rport->dev);
 
-	spin_lock(rport->rqst_q->queue_lock);
+	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
 	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
 		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
 	if (flagset)
@@ -3684,7 +3685,7 @@ fc_bsg_goose_queue(struct fc_rport *rport)
 	__blk_run_queue(rport->rqst_q);
 	if (flagset)
 		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
-	spin_unlock(rport->rqst_q->queue_lock);
+	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
 
 	put_device(&rport->dev);
 }
diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index 97f3158..27e84e4 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -134,7 +134,7 @@ zalon_probe(struct parisc_device *dev)
 
 	host = ncr_attach(&zalon7xx_template, unit, &device);
 	if (!host)
-		goto fail;
+		return -ENODEV;
 
 	if (request_irq(dev->irq, ncr53c8xx_intr, IRQF_SHARED, "zalon", host)) {
 	  dev_printk(KERN_ERR, &dev->dev, "irq problem with %d, detaching\n ",


