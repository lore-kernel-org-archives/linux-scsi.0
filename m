From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] scsi: replace strict_strtoul() with kstrtoul()
Date: Sun, 2 Jun 2013 14:28:49 +0300
Message-ID: <CAHp75VdfO_ZTw+i1tX+RHzpApBKD2=WskDPTVgXcn7pWWAd7ZA@mail.gmail.com>
References: <001201ce5e99$b2ea7480$18bf5d80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46986 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3FBL2t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jun 2013 07:28:49 -0400
Received: by mail-ob0-f169.google.com with SMTP id up14so5727746obb.0
        for <linux-scsi@vger.kernel.org>; Sun, 02 Jun 2013 04:28:49 -0700 (PDT)
In-Reply-To: <001201ce5e99$b2ea7480$18bf5d80$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jingoo Han <jg1.han@samsung.com>
Cc: James Bottomley <JBottomley@parallels.com>, James Bottomley <jejb@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>

On Sat, Jun 1, 2013 at 10:29 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.

> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -4204,7 +4204,7 @@ static ssize_t pmcraid_store_log_level(
>         struct pmcraid_instance *pinstance;
>         unsigned long val;
>
> -       if (strict_strtoul(buf, 10, &val))
> +       if (kstrtoul(buf, 10, &val))
>                 return -EINVAL;
>         /* log-level should be from 0 to 2 */
>         if (val > 2)

int ret;

ret = kstrtoul(...);
if (ret)
 return ret;

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 931a7d9..bf36b45 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -790,7 +790,7 @@ sdev_store_queue_ramp_up_period(struct device *dev,
>         struct scsi_device *sdev = to_scsi_device(dev);
>         unsigned long period;
>
> -       if (strict_strtoul(buf, 10, &period))
> +       if (kstrtoul(buf, 10, &period))
>                 return -EINVAL;

Ditto.

--
With Best Regards,
Andy Shevchenko
