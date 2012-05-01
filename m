From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 02/17] hpsa: do not skip disabled devices
Date: Tue, 01 May 2012 11:42:14 -0500
Message-ID: <20120501164214.11705.11863.stgit@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

There was code to skip "disabled" devices which was intended to
skip devices disabled in the BIOS, but it really just checks to
see if the device can write to host memory, which this is disabled
by pci_disable_device on driver unload, so this check has the effect
of preventing subsequent load of the driver.  And devices disabled in
the BIOS don't show up at all anyway, so this check never made any
sense to begin with, and should be removed.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1a6c319..5119ce6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3705,14 +3705,6 @@ static int __devinit hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 	return ARRAY_SIZE(products) - 1; /* generic unknown smart array */
 }
 
-static inline bool hpsa_board_disabled(struct pci_dev *pdev)
-{
-	u16 command;
-
-	(void) pci_read_config_word(pdev, PCI_COMMAND, &command);
-	return ((command & PCI_COMMAND_MEMORY) == 0);
-}
-
 static int __devinit hpsa_pci_find_memory_BAR(struct pci_dev *pdev,
 	unsigned long *memory_bar)
 {
@@ -3932,11 +3924,6 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 	h->product_name = products[prod_index].product_name;
 	h->access = *(products[prod_index].access);
 
-	if (hpsa_board_disabled(h->pdev)) {
-		dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
-		return -ENODEV;
-	}
-
 	pci_disable_link_state(h->pdev, PCIE_LINK_STATE_L0S |
 			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
 
