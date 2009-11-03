From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/54] fnic: Allocate OS interrupt resources just before
	enabling interrupts
Date: Tue, 03 Nov 2009 11:45:37 -0800
Message-ID: <20091103194536.4085.88591.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34715 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbZKCTpb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:45:31 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Abhijeet Joglekar <abjoglek@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Abhijeet Joglekar <abjoglek@cisco.com>

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
Signed-off-by: Robert Love <robert.w.love@intel.com>
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

