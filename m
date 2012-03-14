From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 1/3] atp870u: use pci_dev->revision
Date: Wed, 14 Mar 2012 22:02:11 +0300
Message-ID: <201203142202.11514.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This driver uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it wasn't
converted by commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all
drivers to use pci_device->revision).

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the current Linus' tree.

 drivers/scsi/atp870u.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/scsi/atp870u.c
===================================================================
--- linux-2.6.orig/drivers/scsi/atp870u.c
+++ linux-2.6/drivers/scsi/atp870u.c
@@ -2583,7 +2583,7 @@ static int atp870u_probe(struct pci_dev 
 	 * this than via the PCI device table
 	 */
 	if (ent->device == PCI_DEVICE_ID_ARTOP_AEC7610) {
-		error = pci_read_config_byte(pdev, PCI_CLASS_REVISION, &atpdev->chip_ver);
+		atpdev->chip_ver = pdev->revision;
 		if (atpdev->chip_ver < 2)
 			goto err_eio;
 	}
@@ -2602,7 +2602,7 @@ static int atp870u_probe(struct pci_dev 
 	base_io &= 0xfffffff8;
 
 	if ((ent->device == ATP880_DEVID1)||(ent->device == ATP880_DEVID2)) {
-		error = pci_read_config_byte(pdev, PCI_CLASS_REVISION, &atpdev->chip_ver);
+		atpdev->chip_ver = pdev->revision;
 		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x80);//JCC082803
 
 		host_id = inb(base_io + 0x39);
