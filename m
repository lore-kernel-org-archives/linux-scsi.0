From: merez@codeaurora.org
Subject: Re: [PATCH v3 3/6] scsi: ufs: fix interrupt status clears
Date: Mon, 6 May 2013 03:49:14 -0700
Message-ID: <e14cec05842551acd931f06e48d5aad2.squirrel@www.codeaurora.org>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
    <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
    <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
    <001301ce4a1b$cb5bda50$62138ef0$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46222 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab3EFKtO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 06:49:14 -0400
In-Reply-To: <001301ce4a1b$cb5bda50$62138ef0$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <jbottomley@parallels.com>

Tested-by: Maya Erez <merez@codeaurora.org>

> There is no need to check the version to clear
> the interrupt status. And the order is changed
> prior to actual handling.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index feaf221..e04c74e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1582,11 +1582,8 @@ static irqreturn_t ufshcd_intr(int irq, void
> *__hba)
>  	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
>
>  	if (intr_status) {
> +		ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
>  		ufshcd_sl_intr(hba, intr_status);
> -
> -		/* If UFSHCI 1.0 then clear interrupt status register */
> -		if (hba->ufs_version == UFSHCI_VERSION_10)
> -			ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
>  		retval = IRQ_HANDLED;
>  	}
>  	spin_unlock(hba->host->host_lock);
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

