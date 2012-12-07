From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH 04/12] [SCSI] qla2xxx: Use standard PCIe Capability Link
 register field names
Date: Fri, 7 Dec 2012 08:17:38 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D020128@AVMB1.qlogic.org>
References: <20121205205740.13851.43284.stgit@bhelgaas.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20121205205740.13851.43284.stgit@bhelgaas.mtv.corp.google.com>
Content-Language: en-US
Content-ID: <A9C6DC7206F14342B94ED3BD995B329A@qlogic.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>

Thanks,
~Saurav



>Use the standard #defines for PCIe Link Capability register fields
>rather than bare numbers.  This also uses the new PCI Express Capability
>accessor rather than reading the capability directly.
>
>Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>CC: Andrew Vasquez <andrew.vasquez@qlogic.com>
>CC: linux-driver@qlogic.com
>CC: "James E.J. Bottomley" <JBottomley@parallels.com>
>CC: linux-scsi@vger.kernel.org
>---
> drivers/scsi/qla2xxx/qla_os.c |   14 +++++---------
> 1 files changed, 5 insertions(+), 9 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
>index d501bf5..b5d070f 100644
>--- a/drivers/scsi/qla2xxx/qla_os.c
>+++ b/drivers/scsi/qla2xxx/qla_os.c
>@@ -480,18 +480,14 @@ qla24xx_pci_info_str(struct scsi_qla_host *vha,
>char *str)
>       static char *pci_bus_modes[] = { "33", "66", "100", "133", };
>       struct qla_hw_data *ha = vha->hw;
>       uint32_t pci_bus;
>-      int pcie_reg;
>
>-      pcie_reg = pci_pcie_cap(ha->pdev);
>-      if (pcie_reg) {
>+      if (pci_is_pcie(ha->pdev)) {
>               char lwstr[6];
>-              uint16_t pcie_lstat, lspeed, lwidth;
>+              uint32_t lstat, lspeed, lwidth;
>
>-              pcie_reg += PCI_EXP_LNKCAP;
>-              pci_read_config_word(ha->pdev, pcie_reg, &pcie_lstat);
>-              lspeed = pcie_lstat & (BIT_0 | BIT_1 | BIT_2 | BIT_3);
>-              lwidth = (pcie_lstat &
>-                  (BIT_4 | BIT_5 | BIT_6 | BIT_7 | BIT_8 | BIT_9)) >> 4;
>+              pcie_capability_read_dword(ha->pdev, PCI_EXP_LNKCAP, &lstat);
>+              lspeed = lstat & PCI_EXP_LNKCAP_SLS;
>+              lwidth = (lstat & PCI_EXP_LNKCAP_MLW) >> 4;
>
>               strcpy(str, "PCIe (");
>               if (lspeed == 1)
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
