From: "lindar_liu" <lindar_liu@usish.com>
Subject: RE: [PATCH 11/16] pm8001: clean up unnecessary MSI/MSI-X capability find
Date: Fri, 9 Aug 2013 10:57:58 +0800
Message-ID: <00aa01ce94ac$412320b0$c3696210$@com>
References: <1375967421-26540-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:36622 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967411Ab3HIDQY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2013 23:16:24 -0400
In-Reply-To: <1375967421-26540-1-git-send-email-wangyijing@huawei.com>
Content-Language: zh-cn
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Yijing Wang' <wangyijing@huawei.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>
Cc: 'Hanjun Guo' <guohanjun@huawei.com>, jiang.liu@huawei.com, xjtuwjp@gmail.com, linux-scsi@vger.kernel.org

On 08/08/2013 9:10 PM, Yijing Wang wrote: 
> PCI core will initialize device MSI/MSI-X capability in
> pci_msi_init_pci_dev(). So device driver should use pci_dev-
> >msi_cap/msix_cap to determine whether the device support MSI/MSI-X
> instead of using pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
> Access to PCIe device config space again will consume more time.
>
It's fine.
You can add my Acked-by.

Thanks,
Lindar
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: xjtuwjp@gmail.com
> Cc: lindar_liu@usish.com
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/pm8001/pm8001_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c
> b/drivers/scsi/pm8001/pm8001_init.c
> index 3861aa1..1ee61e8 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -734,7 +734,7 @@ static u32 pm8001_request_irq(struct
> pm8001_hba_info *pm8001_ha)
>  	pdev = pm8001_ha->pdev;
> 
>  #ifdef PM8001_USE_MSIX
> -	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX))
> +	if (pdev->msix_cap)
>  		return pm8001_setup_msix(pm8001_ha);
>  	else {
>  		PM8001_INIT_DBG(pm8001_ha,
> --
> 1.7.1

