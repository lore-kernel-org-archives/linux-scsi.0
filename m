From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/4] isci: fix isci_pci_probe() generates warning on efi
 failure path
Date: Wed, 11 Jul 2012 14:59:29 -0700
Message-ID: <20120711215929.26813.77290.stgit@dwillia2-linux.jf.intel.com>
References: <20120711215901.26813.19955.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933272Ab2GKVml (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2012 17:42:41 -0400
In-Reply-To: <20120711215901.26813.19955.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

The oem parameter image embedded in the efi variable is at an offset
from the start of the variable.  However, in the failure path we try to
free the 'orom' pointer which is only valid when the paramaters are
being read from the legacy option-rom space.

Since failure to load the oem parameters is unlikely and we keep the
memory around in the success case just defer all de-allocation to devm.

Cc: <stable@vger.kernel.org>
Reported-by: Don Morris <don.morris@hp.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/init.c       |    1 -
 drivers/scsi/isci/probe_roms.c |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 47e28b5..8870bd3 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -641,7 +641,6 @@ static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct pci_devic
 						orom->hdr.version)) {
 			dev_warn(&pdev->dev,
 				 "[%d]: invalid oem parameters detected, falling back to firmware\n", i);
-			devm_kfree(&pdev->dev, orom);
 			orom = NULL;
 			break;
 		}
diff --git a/drivers/scsi/isci/probe_roms.c b/drivers/scsi/isci/probe_roms.c
index 4d95654..8ac646e 100644
--- a/drivers/scsi/isci/probe_roms.c
+++ b/drivers/scsi/isci/probe_roms.c
@@ -104,7 +104,6 @@ struct isci_orom *isci_request_oprom(struct pci_dev *pdev)
 
 	if (i >= len) {
 		dev_err(&pdev->dev, "oprom parse error\n");
-		devm_kfree(&pdev->dev, rom);
 		rom = NULL;
 	}
 	pci_unmap_biosrom(oprom);

