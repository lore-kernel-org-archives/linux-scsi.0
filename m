From: <kgudipat@brocade.com>
Subject: [PATCH 02/32] bfa: Added separate MSI-X module parameters.
Date: Wed, 3 Mar 2010 17:42:11 -0800
Message-ID: <1267666931-20377-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:47620 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab0CDBmk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:42:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Added separate MSI-X module parameters to selectively
	  enable / disable MSI-X interrupts for both Brocade HBA and CNA's.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad_attr.c |    3 +++
 drivers/scsi/bfa/bfad_intr.c |   11 ++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 9129ae3..adf801d 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -229,7 +229,9 @@ bfad_im_get_host_speed(struct Scsi_Host *shost)
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
 	struct bfa_pport_attr_s attr;
+	unsigned long   flags;
 
+	spin_lock_irqsave(shost->host_lock, flags);
 	bfa_pport_get_attr(&bfad->bfa, &attr);
 	switch (attr.speed) {
 	case BFA_PPORT_SPEED_8GBPS:
@@ -248,6 +250,7 @@ bfad_im_get_host_speed(struct Scsi_Host *shost)
 		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 		break;
 	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /**
diff --git a/drivers/scsi/bfa/bfad_intr.c b/drivers/scsi/bfa/bfad_intr.c
index 7de8832..2b7dbec 100644
--- a/drivers/scsi/bfa/bfad_intr.c
+++ b/drivers/scsi/bfa/bfad_intr.c
@@ -23,8 +23,10 @@ BFA_TRC_FILE(LDRV, INTR);
 /**
  *  bfa_isr BFA driver interrupt functions
  */
-static int msix_disable;
-module_param(msix_disable, int, S_IRUGO | S_IWUSR);
+static int msix_disable_cb;
+static int msix_disable_ct;
+module_param(msix_disable_cb, int, S_IRUGO | S_IWUSR);
+module_param(msix_disable_ct, int, S_IRUGO | S_IWUSR);
 /**
  * Line based interrupt handler.
  */
@@ -141,6 +143,7 @@ bfad_setup_intr(struct bfad_s *bfad)
 	int error = 0;
 	u32 mask = 0, i, num_bit = 0, max_bit = 0;
 	struct msix_entry msix_entries[MAX_MSIX_ENTRY];
+	struct pci_dev *pdev = bfad->pcidev;
 
 	/* Call BFA to get the msix map for this PCI function.  */
 	bfa_msix_getvecs(&bfad->bfa, &mask, &num_bit, &max_bit);
@@ -148,7 +151,9 @@ bfad_setup_intr(struct bfad_s *bfad)
 	/* Set up the msix entry table */
 	bfad_init_msix_entry(bfad, msix_entries, mask, max_bit);
 
-	if (!msix_disable) {
+	if ((pdev->device == BFA_PCI_DEVICE_ID_CT && !msix_disable_ct) ||
+	    (pdev->device != BFA_PCI_DEVICE_ID_CT && !msix_disable_cb)) {
+
 		error = pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
 		if (error) {
 			/*
-- 
1.6.5.3

