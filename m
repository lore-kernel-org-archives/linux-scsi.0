Return-Path: <SRS0=Hkn+=DY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5E3C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Oct 2020 06:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 224232073A
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Oct 2020 06:24:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LFmO5/Sy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436615AbgJQGYF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Oct 2020 02:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411862AbgJQGYE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Oct 2020 02:24:04 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936FBC061755
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2020 23:24:00 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id b138so3793509yba.5
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2020 23:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qp+VenraDtPhabJ4sLub62rP0hM+GPnsh5CvC8dU6P0=;
        b=LFmO5/Sy4YD/YaOXE/OgdEbUmSVGCxNRE2lZ6qcpH6zlVweBG3XZkB6rb2q9kHHHF1
         mFIaQGWRukYp7Arx42I+1lXiUNa09KczuiRpOgENewuwz9INUCElmYzR4hNbtN5Xg+LR
         pspnbKzlBzW35Y6SMtpdTkJInW1jvGxnxCJqEOC3aavoYDlEPJeSRHcni2T8Dq5FhNbm
         tbVJd4sBhOQ6aG+8wrqoWfkP8EvZ7vAfvftLOotDBZaur8ls+ib6leYx5Nok80EX2n6F
         qYZRB+v55BMs0H34bzSsVTIgqj/iDbQl+ArTuC407twUdqOxAyAjMOlBzmAT/PJ2cWQq
         j8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qp+VenraDtPhabJ4sLub62rP0hM+GPnsh5CvC8dU6P0=;
        b=P/7zkdME7Gg5w8iLnC9YbOkzaUFRlM3xxbKiT7buM+vt7Bjy4zgVKtWAW7roqrMZ6x
         AHIs+SmUIV1XL829ReeY4qepkMWG3IegPM3soyJ2ObiZIXncmWpRFGnuQ5HPY9R/xy+I
         fuxNPUEFFDHL4zC0ZkVx5DchVJb10iNXo1PiQU4p0mi2objPzvskxrSHEAYDfW5iQ1kK
         tg0C2KWWL/4Fw5qrcRlupATeupys0p6OwYodgtrkmTBFzQ5LcHjlW0MYL6udXXWrd2Fr
         5yJUFh+OmKDyIS8cfvxsUj4DCUBhyElUkluliEzRvIySO5AL4sZQ+TrApP9wXRX7e793
         PjPA==
X-Gm-Message-State: AOAM533lu1bldzTJjSYdexmlIKlRwKcnunxCYLEaSMU5w/7stNlprek6
        JT0wGIsgwEeYCBr5nLZ0IkFZXeUumdNsaDDOOcQ=
X-Google-Smtp-Source: ABdhPJxPyPlTYWlseSeggV5BiJq/lJZCQpKtnoZl4E/8cxO9HYwoxs8m/7lvpecy7DkW/1TIf2XeRFQdU8gfP0jnWdc=
X-Received: by 2002:a25:5f06:: with SMTP id t6mr9105845ybb.501.1602915839685;
 Fri, 16 Oct 2020 23:23:59 -0700 (PDT)
MIME-Version: 1.0
References: <20201010032539.426615-1-ming.lei@redhat.com>
In-Reply-To: <20201010032539.426615-1-ming.lei@redhat.com>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Sat, 17 Oct 2020 14:23:47 +0800
Message-ID: <CACVXFVMNGdd_ahhdn+v9YgjU_J-XfsosUz6H-Vz7Hfh3r7EHxQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: don't start concurrent async scan on same host
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Linux SCSI List <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Oct 10, 2020 at 4:23 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> Current scsi host scan mechanism supposes to fallback into sync host
> scan if async scan is in-progress. However, this rule isn't strictly
> respected, because scsi_prep_async_scan() doesn't hold scan_mutex when
> checking shost->async_scan. When scsi_scan_host() is called
> concurrently, two async scan on same host may be started, and hang in
> do_scan_async() is observed.
>
> Fixes this issue by checking & setting shost->async_scan atomically
> with shost->scan_mutex.
>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/scsi_scan.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index f2437a7570ce..9af50e6f94c4 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1714,15 +1714,16 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
>   */
>  static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>  {
> -       struct async_scan_data *data;
> +       struct async_scan_data *data = NULL;
>         unsigned long flags;
>
>         if (strncmp(scsi_scan_type, "sync", 4) == 0)
>                 return NULL;
>
> +       mutex_lock(&shost->scan_mutex);
>         if (shost->async_scan) {
>                 shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
> -               return NULL;
> +               goto err;
>         }
>
>         data = kmalloc(sizeof(*data), GFP_KERNEL);
> @@ -1733,7 +1734,6 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>                 goto err;
>         init_completion(&data->prev_finished);
>
> -       mutex_lock(&shost->scan_mutex);
>         spin_lock_irqsave(shost->host_lock, flags);
>         shost->async_scan = 1;
>         spin_unlock_irqrestore(shost->host_lock, flags);
> @@ -1748,6 +1748,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>         return data;
>
>   err:
> +       mutex_unlock(&shost->scan_mutex);
>         kfree(data);
>         return NULL;
>  }
> --
> 2.25.2
>

Hello Guys,

Ping...

Thanks,
Ming Lei
