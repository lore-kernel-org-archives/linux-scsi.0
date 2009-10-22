From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH] fnic: Allocate OS interrupt resources just before enabling
	interrupts
Date: Wed, 21 Oct 2009 21:43:45 -0700
Message-ID: <20091022044135.26422.10363.stgit@jeykholt-lnx01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:9302 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZJVEnk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Oct 2009 00:43:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, jeykholt@cisco.com

This patch is prepared on top of scsi-rc-fixes pulled today, and 3 fnic
patches that are part of Robert's set of 20 patches emailed on scsi-ml today.
Its a bug fix that triggers when forcing Legacy interrupts using pci=nomsi
option. Please include for 2.6.32-rc.
---------------

The OS interrupt vectors were getting allocated before the interrupt
resources were mapped from hardware. For Legacy interrupts, since
they are shared with other devices, as soon as an interrupt is
registered with the OS, it can fire while the fnic isr resource is
still unmapped. This can cause crash because of access to unmapped resources.
For MSIX and MSI, since interrupts are not shared with other devices,
this problem didnt happen, because the interrupt is enabled as the last
step before returning from _probe. For Legacy however, since the
interrupt is shared, the handler can be called as soon as it is registered.

Solution is to register interrupt handlers with OS as last step before
enabling device interrupts.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
---
 drivers/scsi/fnic/fnic_main.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)


diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index b0d425a..fc61f17 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -572,19 +572,12 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 		goto err_out_dev_close;
 	}
 
-	err = fnic_request_intr(fnic);
-	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Unable to request irq.\n");
-		goto err_out_clear_intr;
-	}
-
 	err = fnic_alloc_vnic_resources(fnic);
 	if (err) {
 		shost_printk(KERN_ERR, fnic->lport->host,
 			     "Failed to alloc vNIC resources, "
 			     "aborting.\n");
-		goto err_out_free_intr;
+		goto err_out_clear_intr;
 	}
 
 
@@ -729,6 +722,14 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	fc_fabric_login(lp);
 
 	vnic_dev_enable(fnic->vdev);
+
+	err = fnic_request_intr(fnic);
+	if (err) {
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Unable to request irq.\n");
+		goto err_out_free_exch_mgr;
+	}
+
 	for (i = 0; i < fnic->intr_count; i++)
 		vnic_intr_unmask(&fnic->intr[i]);
 
@@ -753,8 +754,6 @@ err_out_free_ioreq_pool:
 	mempool_destroy(fnic->io_req_pool);
 err_out_free_resources:
 	fnic_free_vnic_resources(fnic);
-err_out_free_intr:
-	fnic_free_intr(fnic);
 err_out_clear_intr:
 	fnic_clear_intr_mode(fnic);
 err_out_dev_close:
@@ -828,8 +827,8 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 	scsi_remove_host(fnic->lport->host);
 	fc_exch_mgr_free(fnic->lport);
 	vnic_dev_notify_unset(fnic->vdev);
-	fnic_free_vnic_resources(fnic);
 	fnic_free_intr(fnic);
+	fnic_free_vnic_resources(fnic);
 	fnic_clear_intr_mode(fnic);
 	vnic_dev_close(fnic->vdev);
 	vnic_dev_unregister(fnic->vdev);


