From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Fwd: [PATCH v4 01/22] [SCSI] megaraid_sas: Use correct #define for
 MSI-X capability
Date: Mon, 22 Apr 2013 17:54:49 -0600
Message-ID: <CAErSpo6-VD1=-0b1TOk60A3=LLSuCVMHJ-=+iQfUoQEZFWNnxg@mail.gmail.com>
References: <20130422230012.32621.15224.stgit@bhelgaas-glaptop> <20130422231019.32621.25028.stgit@bhelgaas-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36140 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3DVXzL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Apr 2013 19:55:11 -0400
Received: by mail-ob0-f173.google.com with SMTP id xn12so36302obc.32
        for <linux-scsi@vger.kernel.org>; Mon, 22 Apr 2013 16:55:11 -0700 (PDT)
In-Reply-To: <20130422231019.32621.25028.stgit@bhelgaas-glaptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

---------- Forwarded message ----------
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, Apr 22, 2013 at 5:10 PM
Subject: [PATCH v4 01/22] [SCSI] megaraid_sas: Use correct #define for
MSI-X capability
To: linux-pci@vger.kernel.org
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, Gavin Shan
<shangw@linux.vnet.ibm.com>, "James E.J. Bottomley"
<JBottomley@parallels.com>


Previously we used PCI_MSI_FLAGS to locate a register in the MSI-X
capability.  This did work because the MSI and MSI-X flags happen
to be at the same offsets, but was confusing.

PCI_MSIX_FLAGS_ENABLE is already defined in include/uapi/linux/pci_regs.h,
so no need to define it again.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Neela Syam Kolli <megaraidlinux@lsi.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |    3 ---
 drivers/scsi/megaraid/megaraid_sas_base.c |    4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h
b/drivers/scsi/megaraid/megaraid_sas.h
index 408d254..684cc34 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1488,7 +1488,4 @@ struct megasas_mgmt_info {
        int max_index;
 };

-#define msi_control_reg(base) (base + PCI_MSI_FLAGS)
-#define PCI_MSIX_FLAGS_ENABLE (1 << 15)
-
 #endif                         /*LSI_MEGARAID_SAS_H */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9d53540..7c90d57 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3984,12 +3984,12 @@ static int megasas_probe_one(struct pci_dev *pdev,
        if (reset_devices) {
                pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
                if (pos) {
-                       pci_read_config_word(pdev, msi_control_reg(pos),
+                       pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS,
                                             &control);
                        if (control & PCI_MSIX_FLAGS_ENABLE) {
                                dev_info(&pdev->dev, "resetting MSI-X\n");
                                pci_write_config_word(pdev,
-                                                     msi_control_reg(pos),
+                                                     pos + PCI_MSIX_FLAGS,
                                                      control &
                                                      ~PCI_MSIX_FLAGS_ENABLE);
                        }
