From: adam radford <aradford@gmail.com>
Subject: Re: [patch] [SCSI] megaraid_sas: release lock on error path
Date: Tue, 16 Apr 2013 14:22:08 -0700
Message-ID: <CAHtARFE9ckz9-2YFwHrTZb8BFNxCSkZL_TmbL8vFvdJ__5kyDQ@mail.gmail.com>
References: <20130416074419.GA1571@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:47542 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331Ab3DPVWJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 17:22:09 -0400
In-Reply-To: <20130416074419.GA1571@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org

On Tue, Apr 16, 2013 at 12:44 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> We should unlock here before returning.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 9d53540..eb2385f 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4931,11 +4931,12 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
>                 printk(KERN_ERR "megaraid_sas: timed out while"
>                         "waiting for HBA to recover\n");
>                 error = -ENODEV;
> -               goto out_kfree_ioc;
> +               goto out_up;
>         }
>         spin_unlock_irqrestore(&instance->hba_lock, flags);
>
>         error = megasas_mgmt_fw_ioctl(instance, user_ioc, ioc);
> +      out_up:
>         up(&instance->ioctl_sem);
>
>        out_kfree_ioc:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks Dan, this looks good.

Acked-by: Adam Radford <aradford@gmail.com>

-Adam
