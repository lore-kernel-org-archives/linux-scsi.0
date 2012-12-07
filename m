From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH 04/12] [SCSI] qla2xxx: Use standard PCIe Capability Link
 register field names
Date: Fri, 7 Dec 2012 22:29:11 +0000
Message-ID: <D63B9804CB63AD4FAAD966037695664603A72C@avmb2.qlogic.org>
References: <F5D084D6342F9B479C34599BB0A03E4D020128@AVMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.199.154.209] ([213.199.154.209]:49131 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab2LGWaa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 17:30:30 -0500
In-Reply-To: <F5D084D6342F9B479C34599BB0A03E4D020128@AVMB1.qlogic.org>
Content-Language: en-US
Content-ID: <21BFB3DBCFCAD04D99661F2D4E902228@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>, Bjorn Helgaas <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Acked-by: Giridhar Malavali

On 12/7/12 12:17 AM, "Saurav Kashyap" <saurav.kashyap@qlogic.com> wrote:

>Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
>
>Thanks,
>~Saurav
>
>
>
>>Use the standard #defines for PCIe Link Capability register fields
>>rather than bare numbers.  This also uses the new PCI Express Capability
>>accessor rather than reading the capability directly.
>>
>>Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>CC: Andrew Vasquez <andrew.vasquez@qlogic.com>
>>CC: linux-driver@qlogic.com
>>CC: "James E.J. Bottomley" <JBottomley@parallels.com>
>>CC: linux-scsi@vger.kernel.org
>>---
>> drivers/scsi/qla2xxx/qla_os.c |   14 +++++---------
>> 1 files changed, 5 insertions(+), 9 deletions(-)
>>
>>diff --git a/drivers/scsi/qla2xxx/qla_os.c
>>b/drivers/scsi/qla2xxx/qla_os.c
>>index d501bf5..b5d070f 100644
>>--- a/drivers/scsi/qla2xxx/qla_os.c
>>+++ b/drivers/scsi/qla2xxx/qla_os.c
>>@@ -480,18 +480,14 @@ qla24xx_pci_info_str(struct scsi_qla_host *vha,
>>char *str)
>> 	static char *pci_bus_modes[] = { "33", "66", "100", "133", };
>> 	struct qla_hw_data *ha = vha->hw;
>> 	uint32_t pci_bus;
>>-	int pcie_reg;
>> 
>>-	pcie_reg = pci_pcie_cap(ha->pdev);
>>-	if (pcie_reg) {
>>+	if (pci_is_pcie(ha->pdev)) {
>> 		char lwstr[6];
>>-		uint16_t pcie_lstat, lspeed, lwidth;
>>+		uint32_t lstat, lspeed, lwidth;
>> 
>>-		pcie_reg += PCI_EXP_LNKCAP;
>>-		pci_read_config_word(ha->pdev, pcie_reg, &pcie_lstat);
>>-		lspeed = pcie_lstat & (BIT_0 | BIT_1 | BIT_2 | BIT_3);
>>-		lwidth = (pcie_lstat &
>>-		    (BIT_4 | BIT_5 | BIT_6 | BIT_7 | BIT_8 | BIT_9)) >> 4;
>>+		pcie_capability_read_dword(ha->pdev, PCI_EXP_LNKCAP, &lstat);
>>+		lspeed = lstat & PCI_EXP_LNKCAP_SLS;
>>+		lwidth = (lstat & PCI_EXP_LNKCAP_MLW) >> 4;
>> 
>> 		strcpy(str, "PCIe (");
>> 		if (lspeed == 1)
>>
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>


