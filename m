From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH v4 3/6] scsi: ufs: fix interrupt status clears
Date: Wed, 8 May 2013 20:49:52 +0530
Message-ID: <CALMYJDvj5k4vwEib7kqFoWOumabWnxTpKB0hH=kh8ar9Kx0VDQ@mail.gmail.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com> <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
 <002601ce4bc7$dd78f530$986adf90$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:38310 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab3EHPUO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 11:20:14 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf3so967528bkc.21
        for <linux-scsi@vger.kernel.org>; Wed, 08 May 2013 08:20:13 -0700 (PDT)
In-Reply-To: <002601ce4bc7$dd78f530$986adf90$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Wed, May 8, 2013 at 2:11 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> There is no need to check the version to clear
> the interrupt status. And the order is changed
> prior to actual handling.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> Tested-by: Maya Erez <merez@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index feaf221..e04c74e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1582,11 +1582,8 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
>         intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
>
>         if (intr_status) {
> +               ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
>                 ufshcd_sl_intr(hba, intr_status);
> -
> -               /* If UFSHCI 1.0 then clear interrupt status register */
> -               if (hba->ufs_version == UFSHCI_VERSION_10)
> -                       ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
>                 retval = IRQ_HANDLED;
>         }
>         spin_unlock(hba->host->host_lock);
> --
> 1.7.0.4
>
>

Acked-by: Santosh Y <santoshsy@gmail.com>


-- 
~Santosh
