From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v3 13/15] scsi: ufs: add missing memory barriers
Date: Thu, 22 Oct 2015 22:21:43 +0900
Message-ID: <CAC5umyhkAdEjtFd+r3EOKfkPdFgfZ5juH0Wg2983=UqUSzkD7Q@mail.gmail.com>
References: <1441188795-4600-1-git-send-email-ygardi@codeaurora.org>
	<1441188795-4600-14-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:32929 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbbJVNVo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Oct 2015 09:21:44 -0400
In-Reply-To: <1441188795-4600-14-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>

2015-09-02 19:13 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> Performing several writes to UFS host controller registers has
> no gurrantee of ordering, so we must make sure register writes
> to setup request list base address etc. are performed before the
> run/stop register is enabled.
> In addition, when setting up a task request, we must make sure
> the updating of descriptors takes places before ringing the
> doorbell, similarly to setting up a transfer request.
>
> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index fc2a52d..298511a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -401,11 +401,9 @@ static inline int ufshcd_get_lists_status(u32 reg)
>          *  1           UTRLRDY
>          *  2           UTMRLRDY
>          *  3           UCRDY
> -        *  4           HEI
> -        *  5           DEI
> -        * 6-7          reserved
> +        * 4-7          reserved
>          */
> -       return (((reg) & (0xFF)) >> 1) ^ (0x07);
> +       return ((reg & 0xFF) >> 1) ^ 0x07;
>  }
>
>  /**
> @@ -2726,7 +2724,7 @@ out:
>   * To bring UFS host controller to operational state,
>   * 1. Enable required interrupts
>   * 2. Configure interrupt aggregation
> - * 3. Program UTRL and UTMRL base addres
> + * 3. Program UTRL and UTMRL base address
>   * 4. Configure run-stop-registers
>   *
>   * Returns 0 on success, non-zero value on failure
> @@ -2756,8 +2754,13 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
>                         REG_UTP_TASK_REQ_LIST_BASE_H);
>
>         /*
> +        * Make sure base address and interrupt setup are updated before
> +        * enabling the run/stop registers below.
> +        */
> +       wmb();
> +
> +       /*
>          * UCRDY, UTMRLDY and UTRLRDY bits must be 1
> -        * DEI, HEI bits must be 0
>          */
>         reg = ufshcd_readl(hba, REG_CONTROLLER_STATUS);
>         if (!(ufshcd_get_lists_status(reg))) {
> @@ -3920,7 +3923,13 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
>
>         /* send command to the controller */
>         __set_bit(free_slot, &hba->outstanding_tasks);
> +
> +       /* Make sure descriptors are ready before ringing the task doorbell */
> +       wmb();
> +
>         ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
> +       /* Make sure that doorbell is committed immediately */
> +       wmb();

Is this wmb() after ringing tm doorbell is needed?

>
>         spin_unlock_irqrestore(host->host_lock, flags);
>
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
