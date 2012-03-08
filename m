From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH 1/1] aacraid: Fixes kernel oops in "aac_eh_abort"
Date: Thu, 8 Mar 2012 08:06:49 -0500
Message-ID: <8548A32B-2E46-4444-8802-7D262AADD434@xyratex.com>
References: <C3916DD2A1C2854B8C8E4A1C5919A330D08EB64987@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex195.xyratex.com ([194.131.166.195]:31354 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751404Ab2CHNG4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Mar 2012 08:06:56 -0500
In-Reply-To: <C3916DD2A1C2854B8C8E4A1C5919A330D08EB64987@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mahesh Bagepalli Rajashekhara - ERS, HCL Tech" <maheshbr@hcl.com>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Achim_Leubner@pmc-sierra.com" <Achim_Leubner@pmc-sierra.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, "tony_ruiz@pmc-sierra.com" <tony_ruiz@pmc-sierra.com>

ACK

Sincerely -- Mark Salyzyn

On Mar 8, 2012, at 6:43 AM, Mahesh Bagepalli Rajashekhara - ERS, HCL Tech wrote:

> Hi James,
> 
> This patch fixes the kernel oops in the error handler "aac_eh_abort" function.
> 
> This attached patch is against current upstream kernel
> 
> ObligatoryDisclaimer: Please accept my condolences regarding Outlook's handling of patch attachments (inline gets damaged, please use attachment).
> 
> Signed-off-by: Mahesh Rajashekhara <aacraid@pmc-sierra.com>
> 
> ---
> 
> drivers/scsi/aacraid/commsup.c |    1 +
> drivers/scsi/aacraid/linit.c   |    2 +-
> 2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff -purN a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> --- a/drivers/scsi/aacraid/commsup.c    2012-03-08 14:28:50.000000000 +0530
> +++ b/drivers/scsi/aacraid/commsup.c    2012-03-08 14:31:51.000000000 +0530
> @@ -136,6 +136,7 @@ int aac_fib_setup(struct aac_dev * dev)
>                i < (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
>                i++, fibptr++)
>        {
> +               fibptr->flags = 0;
>                fibptr->dev = dev;
>                fibptr->hw_fib_va = hw_fib;
>                fibptr->data = (void *) fibptr->hw_fib_va->data;
> diff -purN a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> --- a/drivers/scsi/aacraid/linit.c      2012-03-08 14:28:34.000000000 +0530
> +++ b/drivers/scsi/aacraid/linit.c      2012-03-08 14:30:55.000000000 +0530
> @@ -1157,7 +1157,7 @@ static int __devinit aac_probe_one(struc
>        aac->cardtype = index;
>        INIT_LIST_HEAD(&aac->entry);
> 
> -       aac->fibs = kmalloc(sizeof(struct fib) * (shost->can_queue + AAC_NUM_MGT_FIB), GFP_KERNEL);
> +       aac->fibs = kzalloc(sizeof(struct fib) * (shost->can_queue + AAC_NUM_MGT_FIB), GFP_KERNEL);
>        if (!aac->fibs)
>                goto out_free_host;
>        spin_lock_init(&aac->fib_lock);

