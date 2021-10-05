Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD17C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFBCF6140B
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhJEDJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 23:09:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229659AbhJEDJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 23:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633403269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pjTDoOAAzTIWtWAnD9QFmDWNSIOiIoKdZfqiCd7MDj8=;
        b=OOP8BwoxhLUrHVUIJcuqWr5gV3OdpG4Y8MpexQ0tW1szPxThwAZ2biKaoOe+Nk1cXGwnB1
        ztd4KoI7ybdR+2TUN6YhHdlY/28uTkw8dk06WOVbZ3yRjUNHLdORzFBPhPBl9xgWiox5l3
        G5L3mRZMH5iA/F1i4cLTPjOvyOELYYo=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-COFbfRGcMyKg7-hse6vUqw-1; Mon, 04 Oct 2021 23:07:48 -0400
X-MC-Unique: COFbfRGcMyKg7-hse6vUqw-1
Received: by mail-yb1-f197.google.com with SMTP id i83-20020a256d56000000b005b706d1417bso19995573ybc.6
        for <linux-scsi@vger.kernel.org>; Mon, 04 Oct 2021 20:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pjTDoOAAzTIWtWAnD9QFmDWNSIOiIoKdZfqiCd7MDj8=;
        b=u2D6alBH2/FEhdEnkOEvgjO2stgCr6p4UHPGP+GUE9szzhn/x00U7YPhj9HSmQ3MzN
         pBF80WmUR/JUv9hFIIAxkf7zvXvMHbROvwwfI8CKsRkmdtpcSyk4cl/g2fgR98daHtEk
         nDsLLtK7FcXmt4y69A/ZmtX/ZkorNZ0eLAuGCaTOhjkJrVT3yIm/zGpfgqOn7qbp/BRi
         +0t1ZZrhxE9TEjrrbvU32WK3B2RZM6A3hd5fZtNTg9f4sIxGlI4ZTI1WWdQWDIM8hh+n
         9MegSWot3habP9H9Q+4AwPc+/cQ21JtHJXcVTnCM/IC34f5uUh91Mk+9wz/7AQAr0EEd
         V54A==
X-Gm-Message-State: AOAM5311snvGVozNYBsKYpPYrTg8/3MRPJL2XAXxg+oq7CzPRW369nBw
        JyMixY9gFNBPc6bXjHT2T6+TTQzuD2J+V9wVGz2CUILm81t+pItn/Ah2pM3xNzX1Pt7sAlhtlSe
        OREnSlWRPLKdJk9sSa6o9BBDZvK+hZTENBjMvuA==
X-Received: by 2002:a25:3212:: with SMTP id y18mr15085582yby.308.1633403267739;
        Mon, 04 Oct 2021 20:07:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9Z7t1JkHo/A+1rsRVz7a2u6bgitPqhzPyh0JDFRQcvuZOTouJuBZlR49WtsVNOq++2fyJ71id7xh0wA5NU54=
X-Received: by 2002:a25:3212:: with SMTP id y18mr15085561yby.308.1633403267525;
 Mon, 04 Oct 2021 20:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210930124415.1160754-1-ming.lei@redhat.com>
In-Reply-To: <20210930124415.1160754-1-ming.lei@redhat.com>
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Tue, 5 Oct 2021 11:07:35 +0800
Message-ID: <CAHj4cs9QMLhnaf_tZF2ypVeEJmAXpHN9c9YsUjKDUbM5rrixfw@mail.gmail.com>
Subject: Re: [PATCH V3] scsi: core: put LLD module refcnt after SCSI device is released
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tested-by: Yi Zhang <yi.zhang@redhat.com>

This patch fixed one panic issue which I found on s390x with blktests srp tests.
https://lore.kernel.org/linux-block/CAHj4cs8XNtkzbbiLnFmVu82wYeQpLkVp6_wCtrnbhODay+OP9w@mail.gmail.com/#t

On Thu, Sep 30, 2021 at 8:44 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> SCSI host release is triggered when SCSI device is freed, and we have to
> make sure that LLD module won't be unloaded before SCSI host instance is
> released because shost->hostt is required in host release handler.
>
> So make sure to put LLD module refcnt after SCSI device is released.
>
> Fix one kernel panic of 'BUG: unable to handle page fault for address'
> reported by Changhui and Yi.
>
> Reported-by: Changhui Zhong <czhong@redhat.com>
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/scsi.c        |  4 +++-
>  drivers/scsi/scsi_sysfs.c  | 12 ++++++++++++
>  include/scsi/scsi_device.h |  1 +
>  3 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index b241f9e3885c..291ecc33b1fe 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -553,8 +553,10 @@ EXPORT_SYMBOL(scsi_device_get);
>   */
>  void scsi_device_put(struct scsi_device *sdev)
>  {
> -       module_put(sdev->host->hostt->module);
> +       struct module *mod = sdev->host->hostt->module;
> +
>         put_device(&sdev->sdev_gendev);
> +       module_put(mod);
>  }
>  EXPORT_SYMBOL(scsi_device_put);
>
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 86793259e541..9ada26814011 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -449,9 +449,16 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>         struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
>         struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
>         unsigned long flags;
> +       struct module *mod;
> +       bool put_mod = false;
>
>         sdev = container_of(work, struct scsi_device, ew.work);
>
> +       if (sdev->put_lld_mod_ref) {
> +               mod = sdev->host->hostt->module;
> +               put_mod = true;
> +       }
> +
>         scsi_dh_release_device(sdev);
>
>         parent = sdev->sdev_gendev.parent;
> @@ -502,11 +509,16 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>
>         if (parent)
>                 put_device(parent);
> +       if (put_mod)
> +               module_put(mod);
>  }
>
>  static void scsi_device_dev_release(struct device *dev)
>  {
>         struct scsi_device *sdp = to_scsi_device(dev);
> +
> +       sdp->put_lld_mod_ref = try_module_get(sdp->host->hostt->module);
> +
>         execute_in_process_context(scsi_device_dev_release_usercontext,
>                                    &sdp->ew);
>  }
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 430b73bd02ac..54b46d590e2d 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -206,6 +206,7 @@ struct scsi_device {
>         unsigned rpm_autosuspend:1;     /* Enable runtime autosuspend at device
>                                          * creation time */
>         unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
> +       unsigned put_lld_mod_ref:1;     /* Put LLD module ref in release */
>
>         bool offline_already;           /* Device offline message logged */
>
> --
> 2.31.1
>


-- 
Best Regards,
  Yi Zhang

