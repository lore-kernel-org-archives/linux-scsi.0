From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 12/13] hpsa: always call pci_set_master after
 pci_enable_device
Date: Fri, 14 Nov 2014 17:27:24 -0600
Message-ID: <20141114232724.20808.42206.stgit@don-ProLiant-MicroServer-Gen8>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:46510 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422933AbaKNXZu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:25:50 -0500
In-Reply-To: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

If the kernel is booted with the reset_device parameter, which
is done for kdump, then the driver needs to call pci_set_master
after pci_enable_device to reenable bus mastering (since
the preceding pci_disable_device call disables bus mastering).

Also, place that after pci_request_regions both in the
kdump code and the normal pci_init code.

Remove the comment summarizing what pci_set_master
does, with the incomplete commentary on the impact of
pci_disable_device.

Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 761612d..72daca9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6363,15 +6363,15 @@ static int hpsa_pci_init(struct ctlr_info *h)
 		return err;
 	}
 
-	/* Enable bus mastering (pci_disable_device may disable this) */
-	pci_set_master(h->pdev);
-
 	err = pci_request_regions(h->pdev, HPSA);
 	if (err) {
 		dev_err(&h->pdev->dev,
 			"cannot obtain PCI resources, aborting\n");
 		return err;
 	}
+
+	pci_set_master(h->pdev);
+
 	hpsa_interrupt_mode(h);
 	err = hpsa_pci_find_memory_BAR(h->pdev, &h->paddr);
 	if (err)
@@ -6451,7 +6451,9 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
 		dev_warn(&pdev->dev, "failed to enable device.\n");
 		return -ENODEV;
 	}
+
 	pci_set_master(pdev);
+
 	/* Reset the controller with a PCI power-cycle or via doorbell */
 	rc = hpsa_kdump_hard_reset_controller(pdev);
 

