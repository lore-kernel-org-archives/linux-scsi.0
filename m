From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH RESUBMIT 2/3] qla2xxx: remove unnecessary reads of
 PCI_CAP_ID_EXP
Date: Wed, 11 Jul 2012 08:27:33 -0400
Message-ID: <alpine.WNT.2.00.1207110826280.4876@N5102REMCQXM4BS.qlogic.org>
References: <1341957477-30946-1-git-send-email-jdmason@kudzu.us> <1341957477-30946-3-git-send-email-jdmason@kudzu.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:41218
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754454Ab2GKMmm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2012 08:42:42 -0400
In-Reply-To: <1341957477-30946-3-git-send-email-jdmason@kudzu.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Mason <jdmason@kudzu.us>
Cc: James Bottomley <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>


On Tue, 10 Jul 2012, Jon Mason wrote:

> The PCIE capability offset is saved during PCI bus walking.  It will
> remove an unnecessary search in the PCI configuration space if this
> value is referenced instead of reacquiring it.  Also, pci_is_pcie is a
> better way of determining if the device is PCIE or not (as it uses the
> same saved PCIE capability offset).
>
> Signed-off-by: Jon Mason <jdmason@kudzu.us>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Cc: linux-driver@qlogic.com
> ---
> drivers/scsi/qla2xxx/qla_init.c |    4 ++--
> drivers/scsi/qla2xxx/qla_nx.c   |    4 ++--
> drivers/scsi/qla2xxx/qla_os.c   |    4 ++--
> 3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index ca50847..a44653b 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -685,7 +685,7 @@ qla24xx_pci_config(scsi_qla_host_t *vha)
>               pcix_set_mmrbc(ha->pdev, 2048);
>
>       /* PCIe -- adjust Maximum Read Request Size (2048). */
> -     if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
> +     if (pci_is_pcie(ha->pdev))
>               pcie_set_readrq(ha->pdev, 2048);
>
>       pci_disable_rom(ha->pdev);
> @@ -721,7 +721,7 @@ qla25xx_pci_config(scsi_qla_host_t *vha)
>       pci_write_config_word(ha->pdev, PCI_COMMAND, w);
>
>       /* PCIe -- adjust Maximum Read Request Size (2048). */
> -     if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
> +     if (pci_is_pcie(ha->pdev))
>               pcie_set_readrq(ha->pdev, 2048);
>
>       pci_disable_rom(ha->pdev);
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index caf627b..9ce3a8f 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -1620,7 +1620,7 @@ qla82xx_pci_info_str(struct scsi_qla_host *vha, char *str)
>       char lwstr[6];
>       uint16_t lnk;
>
> -     pcie_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
> +     pcie_reg = pci_pcie_cap(ha->pdev);
>       pci_read_config_word(ha->pdev, pcie_reg + PCI_EXP_LNKSTA, &lnk);
>       ha->link_width = (lnk >> 4) & 0x3f;
>
> @@ -2528,7 +2528,7 @@ qla82xx_start_firmware(scsi_qla_host_t *vha)
>       }
>
>       /* Negotiated Link width */
> -     pcie_cap = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
> +     pcie_cap = pci_pcie_cap(ha->pdev);
>       pci_read_config_word(ha->pdev, pcie_cap + PCI_EXP_LNKSTA, &lnk);
>       ha->link_width = (lnk >> 4) & 0x3f;
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 6d1d873..fb8cd38 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -482,12 +482,12 @@ qla24xx_pci_info_str(struct scsi_qla_host *vha, char *str)
>       uint32_t pci_bus;
>       int pcie_reg;
>
> -     pcie_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
> +     pcie_reg = pci_pcie_cap(ha->pdev);
>       if (pcie_reg) {
>               char lwstr[6];
>               uint16_t pcie_lstat, lspeed, lwidth;
>
> -             pcie_reg += 0x12;
> +             pcie_reg += PCI_EXP_LNKCAP;
>               pci_read_config_word(ha->pdev, pcie_reg, &pcie_lstat);
>               lspeed = pcie_lstat & (BIT_0 | BIT_1 | BIT_2 | BIT_3);
>               lwidth = (pcie_lstat &
>

Looks good, thanks.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

