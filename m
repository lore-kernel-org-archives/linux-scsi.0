From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 31/42] hpsa: call pci_release_regions after
 pci_disable_device
Date: Tue, 17 Mar 2015 15:05:11 -0500
Message-ID: <20150317200511.19856.56693.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:42558 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337AbbCQUGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:06:51 -0400
Received: from g9t5009.houston.hp.com (g9t5009.houston.hp.com [15.240.92.67])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 2DC6362ABB
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2015 20:06:51 +0000 (UTC)
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Despite the fact that PCI devices are enabled in this order:
    1. pci_enable_device
    2. pci_request_regions

    Documentation/PCI/pci.txt specifies that they be undone
    in this order
    1. pci_disable_device
    2. pci_release_regions

    Tested by injecting error in the call to pci_enable_device
    in hpsa_init_one -> hpsa_pci_init:
    [    9.095001] hpsa 0000:04:00.0: failed to enable PCI device
    [    9.095005] hpsa: probe of 0000:04:00.0 failed with error -22
    (-22 is -EINVAL)
    and then in the call pci_request_regions:
    [    9.178623] hpsa 0000:04:00.0: failed to obtain PCI resources
    [    9.178671] hpsa: probe of 0000:04:00.0 failed with error -16
    (-16 is -EBUSY)

    and then by adding
        reset_devices
    to the kernel command line and inject errors into the two
    calls to pci_enable_device and the call to pci_request_regions
    in hpsa_init_one -> hpsa_init_reset_devices.

    (inject on 6th call, 1st to hpsa2)
    [   62.413750] hpsa 0000:04:00.0: Failed to enable PCI device

    (inject on 7th call, 2nd to hpsa2)
    [   62.807571] hpsa 0000:04:00.0: failed to enable device.

    (inject on 8th call, 3rd to hpsa2)
    [   62.697198] hpsa 0000:04:00.0: failed to obtain PCI resources
    [   62.697234] hpsa: probe of 0000:04:00.0 failed with error -16

    The reset_devices path calls return -ENODEV on failure
    rather than passing the result, which apparently doesn't
    cause the pci driver to print anything.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace < don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b533b8e..33aca38 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7075,8 +7075,12 @@ static void hpsa_free_pci_init(struct ctlr_info *h)
 	iounmap(h->vaddr);			/* pci_init 3 */
 	h->vaddr = NULL;
 	hpsa_disable_interrupt_mode(h);		/* pci_init 2 */
-	pci_release_regions(h->pdev);		/* pci_init 2 */
+	/*
+	 * call pci_disable_device before pci_release_regions per
+	 * Documentation/PCI/pci.txt
+	 */
 	pci_disable_device(h->pdev);		/* pci_init 1 */
+	pci_release_regions(h->pdev);		/* pci_init 2 */
 }
 
 /* several items must be freed later */
@@ -7099,6 +7103,7 @@ static int hpsa_pci_init(struct ctlr_info *h)
 	err = pci_enable_device(h->pdev);
 	if (err) {
 		dev_err(&h->pdev->dev, "failed to enable PCI device\n");
+		pci_disable_device(h->pdev);
 		return err;
 	}
 
@@ -7106,7 +7111,8 @@ static int hpsa_pci_init(struct ctlr_info *h)
 	if (err) {
 		dev_err(&h->pdev->dev,
 			"failed to obtain PCI resources\n");
-		goto clean1;	/* pci */
+		pci_disable_device(h->pdev);
+		return err;
 	}
 
 	pci_set_master(h->pdev);
@@ -7147,9 +7153,12 @@ clean3:	/* vaddr, intmode+region, pci */
 	h->vaddr = NULL;
 clean2:	/* intmode+region, pci */
 	hpsa_disable_interrupt_mode(h);
-	pci_release_regions(h->pdev);
-clean1:	/* pci */
+	/*
+	 * call pci_disable_device before pci_release_regions per
+	 * Documentation/PCI/pci.txt
+	 */
 	pci_disable_device(h->pdev);
+	pci_release_regions(h->pdev);
 	return err;
 }
 

