From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 04/12] [SCSI] qla2xxx: Use standard PCIe Capability Link
 register field names
Date: Fri, 4 Jan 2013 12:31:11 -0700
Message-ID: <CAErSpo6-BFtr=HH_5zLUrVK6goiVsNTq5pwmn+_wj4_z9kY-3A@mail.gmail.com>
References: <F5D084D6342F9B479C34599BB0A03E4D020128@AVMB1.qlogic.org>
 <D63B9804CB63AD4FAAD966037695664603A72C@avmb2.qlogic.org> <CAErSpo6rs2+Sp3WrqsH7DXb+uZ=c7z8YnT1-GpCd96kKNW1_-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAErSpo6rs2+Sp3WrqsH7DXb+uZ=c7z8YnT1-GpCd96kKNW1_-w@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I haven't heard anything, so I'm going to push this through the PCI
tree.  Let me know if anybody objects or would like to handle it
differently.

On Mon, Dec 17, 2012 at 12:21 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Ping.  I didn't push this through my tree because I didn't want to
> create conflicts with other changes to this file.  But I think this
> can be merged any time.
>
> On Fri, Dec 7, 2012 at 3:29 PM, Giridhar Malavali
> <giridhar.malavali@qlogic.com> wrote:
>> Acked-by: Giridhar Malavali
>>
>> On 12/7/12 12:17 AM, "Saurav Kashyap" <saurav.kashyap@qlogic.com> wrote:
>>
>>>Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
>>>
>>>Thanks,
>>>~Saurav
>>>
>>>
>>>
>>>>Use the standard #defines for PCIe Link Capability register fields
>>>>rather than bare numbers.  This also uses the new PCI Express Capability
>>>>accessor rather than reading the capability directly.
>>>>
>>>>Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>>>CC: Andrew Vasquez <andrew.vasquez@qlogic.com>
>>>>CC: linux-driver@qlogic.com
>>>>CC: "James E.J. Bottomley" <JBottomley@parallels.com>
>>>>CC: linux-scsi@vger.kernel.org
>>>>---
>>>> drivers/scsi/qla2xxx/qla_os.c |   14 +++++---------
>>>> 1 files changed, 5 insertions(+), 9 deletions(-)
>>>>
>>>>diff --git a/drivers/scsi/qla2xxx/qla_os.c
>>>>b/drivers/scsi/qla2xxx/qla_os.c
>>>>index d501bf5..b5d070f 100644
>>>>--- a/drivers/scsi/qla2xxx/qla_os.c
>>>>+++ b/drivers/scsi/qla2xxx/qla_os.c
>>>>@@ -480,18 +480,14 @@ qla24xx_pci_info_str(struct scsi_qla_host *vha,
>>>>char *str)
>>>>      static char *pci_bus_modes[] = { "33", "66", "100", "133", };
>>>>      struct qla_hw_data *ha = vha->hw;
>>>>      uint32_t pci_bus;
>>>>-     int pcie_reg;
>>>>
>>>>-     pcie_reg = pci_pcie_cap(ha->pdev);
>>>>-     if (pcie_reg) {
>>>>+     if (pci_is_pcie(ha->pdev)) {
>>>>              char lwstr[6];
>>>>-             uint16_t pcie_lstat, lspeed, lwidth;
>>>>+             uint32_t lstat, lspeed, lwidth;
>>>>
>>>>-             pcie_reg += PCI_EXP_LNKCAP;
>>>>-             pci_read_config_word(ha->pdev, pcie_reg, &pcie_lstat);
>>>>-             lspeed = pcie_lstat & (BIT_0 | BIT_1 | BIT_2 | BIT_3);
>>>>-             lwidth = (pcie_lstat &
>>>>-                 (BIT_4 | BIT_5 | BIT_6 | BIT_7 | BIT_8 | BIT_9)) >> 4;
>>>>+             pcie_capability_read_dword(ha->pdev, PCI_EXP_LNKCAP, &lstat);
>>>>+             lspeed = lstat & PCI_EXP_LNKCAP_SLS;
>>>>+             lwidth = (lstat & PCI_EXP_LNKCAP_MLW) >> 4;
>>>>
>>>>              strcpy(str, "PCIe (");
>>>>              if (lspeed == 1)
>>>>
>>>>--
>>>>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>>>the body of a message to majordomo@vger.kernel.org
>>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>
>>
