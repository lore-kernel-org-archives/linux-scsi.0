Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D0DC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 06:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiFMGkI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 02:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbiFMGkF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 02:40:05 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF45BE01
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jun 2022 23:40:04 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v19so5770016edd.4
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jun 2022 23:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nqL75dGcGHx4ai3/ntg9xJuTeDKQrl0GC/6/v0eyD5Q=;
        b=Ig3CYdsNTJig+0/zVrxzWpBf8sBprAPZXhob1OpTrijxFTIFHquWunIUbfn31i0vZ7
         cajf1Y3oZSYWLoTFvch4/gvn/3akM4LDra567ilui006TFXRGTdwsQTaGHC8rnfXBZzf
         RPv++f+U3YdiraD2N+sqdzuZ4C8uokhzdxeMMQ4sKR571ezh/AqwdNkqFELNKRbpxL8J
         Z2aGyzIWS8+6o0IYzXUHJz/2osZB0z22SSMhIPcYjUM7PjWmf1IWTka5LbmdgbZISrHd
         uAfYJ7QbPsXh8Ql0/flyGpkZQNR+BGJYjcziK8HX8rEcdqpOd9cFLn02evXWIni7dR5/
         T3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nqL75dGcGHx4ai3/ntg9xJuTeDKQrl0GC/6/v0eyD5Q=;
        b=piaUfke0jcEDuutMbTcUSxVValpppagCPcL+g4yfzsc8qfBmYmo3RfCyGbA3Ljv4yO
         S1hMM4sYzyeoTLQUj6ljOC0zE28zF0QXmtHqpZt8C+0S640MQiv+84RmOHFG0pCMdBW3
         juW/RgTos6m976nomOkJ4kApuLyGeXeXZWiVCOz04w+8th2Eb8HnrDOmTrp0mduiaxjL
         VB9cS5wU2TZVS0HiZBu7WYaf6yCZP+6LmiNcrNeAgUBcj9DqDoymToY4EdOrLnsb2y1H
         47ANhVwjxuHiVvySswL3ol9FBL7d9AsJwemLh2Hl9ubGy9L0a5Mh/DvSIgcMNowu+Slk
         8dag==
X-Gm-Message-State: AOAM532opWFSGXNUudaE83jwhzG1psCcl8PGn2tBy5e7W7GxScEkYRyG
        NcwSj4KElAE2mF07S4ChNsu04MiVBNVMrgwfGevguQ==
X-Google-Smtp-Source: ABdhPJypefaBtBfhxeny/ueXgKKYe544J9kiB9N5g8ZGYYYq9BbrUwxstG6/rcLHPXYu85TMb++lPGISdaxgL93dUTE=
X-Received: by 2002:a05:6402:3688:b0:42d:d3ba:4725 with SMTP id
 ej8-20020a056402368800b0042dd3ba4725mr64268655edb.212.1655102402935; Sun, 12
 Jun 2022 23:40:02 -0700 (PDT)
MIME-Version: 1.0
References: <1654879602-33497-1-git-send-email-john.garry@huawei.com> <1654879602-33497-2-git-send-email-john.garry@huawei.com>
In-Reply-To: <1654879602-33497-2-git-send-email-john.garry@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 13 Jun 2022 08:39:52 +0200
Message-ID: <CAMGffEme47RQxM0v7bsjbumE3UqLidhRE6Hb48NS5BG0yMzQqg@mail.gmail.com>
Subject: Re: [PATCH 1/4] scsi: pm8001: Rework shost initial values
To:     John Garry <john.garry@huawei.com>
Cc:     jinpu.wang@ionos.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, hare@suse.de,
        damien.lemoal@opensource.wdc.com, Ajish.Koshy@microchip.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 10, 2022 at 6:52 PM John Garry <john.garry@huawei.com> wrote:
>
> Some values in pm8001_prep_sas_ha_init() are set the same as they would be
> set in scsi_host_alloc(), or could be in the sht (which would be better),
> or later just overwritten, so rework the following:
> - cmd_per_lun can be set in the sht
> - max_lun and max_channel are as scsi_host_alloc() (so no need to set)
> - can_queue is later overwritten (so don't set in
>   pm8001_prep_sas_ha_init())
>
> Signed-off-by: John Garry <john.garry@huawei.com>
lgtm!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 9b04f1a6a67d..4288c6b8f041 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -109,6 +109,7 @@ static struct scsi_host_template pm8001_sht = {
>  #endif
>         .shost_groups           = pm8001_host_groups,
>         .track_queue_depth      = 1,
> +       .cmd_per_lun            = 32,
>  };
>
>  /*
> @@ -605,12 +606,8 @@ static int pm8001_prep_sas_ha_init(struct Scsi_Host *shost,
>
>         shost->transportt = pm8001_stt;
>         shost->max_id = PM8001_MAX_DEVICES;
> -       shost->max_lun = 8;
> -       shost->max_channel = 0;
>         shost->unique_id = pm8001_id;
>         shost->max_cmd_len = 16;
> -       shost->can_queue = PM8001_CAN_QUEUE;
> -       shost->cmd_per_lun = 32;
>         return 0;
>  exit_free1:
>         kfree(arr_port);
> --
> 2.26.2
>
