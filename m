From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH V2] scsi: replace strict_strtoul() with kstrtoul()
Date: Mon, 3 Jun 2013 13:51:03 +0300
Message-ID: <CAHp75VcAVtFx31_=BF=G5vDPKKXM4rkwZcFnZLp42E1nGD-gbw@mail.gmail.com>
References: <000f01ce6039$984e6540$c8eb2fc0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:60589 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab3FCKvD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jun 2013 06:51:03 -0400
Received: by mail-oa0-f43.google.com with SMTP id o6so934812oag.16
        for <linux-scsi@vger.kernel.org>; Mon, 03 Jun 2013 03:51:03 -0700 (PDT)
In-Reply-To: <000f01ce6039$984e6540$c8eb2fc0$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jingoo Han <jg1.han@samsung.com>
Cc: James Bottomley <JBottomley@parallels.com>, James Bottomley <jejb@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>

On Mon, Jun 3, 2013 at 12:06 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> ---
> Changes since v1:
> - Used return code from kstrtoul().
>
>  drivers/scsi/pmcraid.c    |    6 ++++--
>  drivers/scsi/scsi_sysfs.c |    6 ++++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 8e1b737..39b42a4 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -4203,9 +4203,11 @@ static ssize_t pmcraid_store_log_level(
>         struct Scsi_Host *shost;
>         struct pmcraid_instance *pinstance;
>         unsigned long val;
> +       int ret;
>
> -       if (strict_strtoul(buf, 10, &val))
> -               return -EINVAL;
> +       ret = kstrtoul(buf, 10, &val);
> +       if (ret)
> +               return ret;
>         /* log-level should be from 0 to 2 */
>         if (val > 2)
>                 return -EINVAL;
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 931a7d9..4a8b675 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -789,9 +789,11 @@ sdev_store_queue_ramp_up_period(struct device *dev,
>  {
>         struct scsi_device *sdev = to_scsi_device(dev);
>         unsigned long period;
> +       int ret;
>
> -       if (strict_strtoul(buf, 10, &period))
> -               return -EINVAL;
> +       ret = kstrtoul(buf, 10, &period);
> +       if (ret)
> +               return ret;
>
>         sdev->queue_ramp_up_period = msecs_to_jiffies(period);
>         return period;
> --
> 1.7.10.4
>
>



--
With Best Regards,
Andy Shevchenko
