From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Subject: Re: [PATCH] mvsas:Fix possible NULL pointer deference in mvs_dev_found_notify
Date: Wed, 9 Mar 2016 22:33:47 +0200
Message-ID: <CAOE4rSzh_ipuuWP1=5Kfu1=9-OqH9Nedko3tscJrC4F-GAG0nQ@mail.gmail.com>
References: <1457531917-568-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34408 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbcCIUds (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2016 15:33:48 -0500
In-Reply-To: <1457531917-568-1-git-send-email-xerofoify@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.de>, luisbg@osg.samsung.com, Wilfried.Weissmann@gmx.at, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

2016-03-09 15:58 GMT+02:00 Nicholas Krause <xerofoify@gmail.com>:
> This adds properly checking after the call to mvs_find_dev_mvi
> due to this function being able to return a NULL pointer and if
> this does arise we will deference it in mvs_alloc_dev due to
> this function never checking if a NULL pointer is given as
> it's input argument.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/scsi/mvsas/mv_sas.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index 83cd3ea..7afb248 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1191,6 +1191,10 @@ int mvs_dev_found_notify(struct domain_device *dev, int lock)
>         struct mvs_device *mvi_device;
>
>         mvi = mvs_find_dev_mvi(dev);
> +       if (!mvi) {
> +               res = -1;
> +               goto found_out;
> +       }
>
>         if (lock)
>                 spin_lock_irqsave(&mvi->lock, flags);
> --
> 2.5.0
>

It doesn't look right,
if mvi will be NULL and lock will be set then at

found_out:
    if (lock)
        spin_unlock_irqrestore(&mvi->lock, flags);

there will be mvi dereference, besides spin_lock_irqsave wasn't even called.
And without this patch dereference would happen on mvi->lock which is
before use in mvs_alloc_dev

About whether mvs_find_dev_mvi can return NULL it looks like it's possible,
but I'm not sure if it practically happens. I guess it did hence patch.
