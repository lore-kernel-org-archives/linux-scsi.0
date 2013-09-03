From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 7/7] scsi/qla2xxx: use pcie_is_pcie() to simplify code
Date: Tue, 3 Sep 2013 16:18:28 -0400
Message-ID: <alpine.WNT.2.00.1309031617550.7184@N5102REMCQXM4BS.qlogic.org>
References: <1378193715-25328-1-git-send-email-wangyijing@huawei.com> <1378193715-25328-7-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:8339 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324Ab3ICUSq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2013 16:18:46 -0400
In-Reply-To: <1378193715-25328-7-git-send-email-wangyijing@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Gavin Shan <shangw@linux.vnet.ibm.com>, Bjorn Helgaas <bhelgaas@google.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, David Miller <davem@davemloft.net>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

Looks good.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

On Tue, 3 Sep 2013, Yijing Wang wrote:

> Use pci_is_pcie() instead of pci_find_capability
> to simplify code.
>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Cc: linux-driver@qlogic.com
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> drivers/scsi/qla2xxx/qla_mr.c |    6 ++----
> 1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
> index d799379..5f74271 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.c
> +++ b/drivers/scsi/qla2xxx/qla_mr.c
> @@ -507,7 +507,7 @@ qlafx00_pci_config(scsi_qla_host_t *vha)
> 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
>
> 	/* PCIe -- adjust Maximum Read Request Size (2048). */
> -	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
> +	if (pci_is_pcie(ha->pdev))
> 		pcie_set_readrq(ha->pdev, 2048);
>
> 	ha->chip_revision = ha->pdev->revision;
> @@ -660,10 +660,8 @@ char *
> qlafx00_pci_info_str(struct scsi_qla_host *vha, char *str)
> {
> 	struct qla_hw_data *ha = vha->hw;
> -	int pcie_reg;
>
> -	pcie_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
> -	if (pcie_reg) {
> +	if (pci_is_pcie(ha->pdev)) {
> 		strcpy(str, "PCIe iSA");
> 		return str;
> 	}
>
