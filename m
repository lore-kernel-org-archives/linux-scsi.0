From: Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] [SCSI] gdth: Remove buggy ROM handling
Date: Tue, 06 Nov 2012 15:04:44 -0700
Message-ID: <20121106220444.19405.66777.stgit@bhelgaas.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:34968 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2KFWEr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2012 17:04:47 -0500
Received: by mail-wi0-f202.google.com with SMTP id hr7so65698wib.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Nov 2012 14:04:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Achim Leubner <achim_leubner@adaptec.com>
Cc: Joe Perches <joe@perches.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

The ROM address handling in gdth_init_pci() is useless and possibly
dangerous.  This patch removes it.

"pci_resource_start(pdev, 8)" is not well-defined.  PCI resources 0-5 are
standard PCI BARs and 6 is the expansion ROM.  Resource 8 is either an
SR-IOV BAR (if CONFIG_PCI_IOV=y, resources 7-12 are SR-IOV BARs) or a
bridge window (resources 7-10).

The GDT device is neither an SR-IOV device nor a bridge, so in either case
resource 8 should be zero since struct pci_dev is allocated with kzalloc().

It is illegal for a driver to write an arbitrary address to the ROM BAR
because it has no way of knowing whether the ROM will conflict with another
device.

I think the only effect of the code being removed was to:

  1) Enable the ROM at 0xFEFF0000 (possibly causing a conflict with
     another device)
  2) Delay one millisecond
  3) Write zero to the ROM BAR, disabling it

I doubt the delay is needed, but I left it since it seems innocuous.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/scsi/gdth.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5d72274..3efe4ef 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -1107,14 +1107,8 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
 	pci_read_config_word(pdev, PCI_COMMAND, &command);
         command |= 6;
 	pci_write_config_word(pdev, PCI_COMMAND, command);
-	if (pci_resource_start(pdev, 8) == 1UL)
-	    pci_resource_start(pdev, 8) = 0UL;
-        i = 0xFEFF0001UL;
-	pci_write_config_dword(pdev, PCI_ROM_ADDRESS, i);
-        gdth_delay(1);
-	pci_write_config_dword(pdev, PCI_ROM_ADDRESS,
-			       pci_resource_start(pdev, 8));
-        
+	gdth_delay(1);
+
         dp6m_ptr = ha->brd;
 
         /* Ensure that it is safe to access the non HW portions of DPMEM.

