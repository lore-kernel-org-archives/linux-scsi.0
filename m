Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9F3C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 06:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346354AbiA1GSz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346342AbiA1GSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 01:18:54 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE0BC061714
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 22:18:54 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id j2so7669468edj.8
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 22:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yFLcWL3wX5JaPY+f6874i39mL+yX89VQGClimCfIyOo=;
        b=QZWjuNgXqs/vw6fCwwQiNjeKFhsEDRgn5oncd3dqBQfIRYQMsKCfBDuTFU1/Abwyud
         Wzcuyubs8Jum6GaZE73JoRcTyODomaJvxBW+UfVBt1KCTBleHkWycogXHw/5OZZJe1Nq
         9PCBBZR8QtRvb08+12Oi7p88WxjuqWDvxq2BElLJpU2lXoy2TM7LJj4fWJ5nBJCutXK0
         M0evGGJHYL7bV7m9b8qvVGoou5cGK4ZY+O21wxGf87lnFHsjW26f6pavx2lzwYvm1ldX
         v763IBpQJJlrROXry70+Ta0zKPXu4budn+iH9LV0NAxXZYhpp1R2wbE6KhLS10sjE9jc
         hRqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yFLcWL3wX5JaPY+f6874i39mL+yX89VQGClimCfIyOo=;
        b=h68hSpbHuvEcpVQQvecTeFQ+bluUwPySGDFvlZ3/28MOdN0Jl7s7l++iMPTJv+4c4+
         ncQoRHQ3429Bx3R6Zxy0njhNXgeYJWatVJlATz6PkTIx5aMzLYqDzQUVH3ou8/51bI8l
         qRMXOJybL/oBdD5Bu4S9HpQlpE4J6Q0JOBNpT+m1ZfuAiB1iiPEi/zlkb28ND+sKC8Mp
         kd5zg4cxfIm82EonEjyh/+mnas/qCUL8/N2QYNEjEhwpSN4EIY9MBtSoxcdoVqV97Dms
         L27a8hp+BMPx/q8Mwy1ZaOEEvT5kBXYyXP4q6QsZeRxiLgwdtzeLEaui3mW7KBFSAsov
         K9Kw==
X-Gm-Message-State: AOAM531u1gz0XLoH0p5oteUBKBlD5u9HH5LOuelYoUb8QxHVBVC1GMht
        fbX//28q48yFYwIL/X7UdXlOzLJfM1S+vjSZ3p5aMg==
X-Google-Smtp-Source: ABdhPJyNqvFZil11Z3ZC5MYW4lNLKxpyY3IUTyZ/WYUUYvWG1mMt4G3rinKGBYFBJFf2yupTLQXMcjX26igmMvI+AIU=
X-Received: by 2002:aa7:da4b:: with SMTP id w11mr6786109eds.118.1643350733042;
 Thu, 27 Jan 2022 22:18:53 -0800 (PST)
MIME-Version: 1.0
References: <1643289172-165636-1-git-send-email-john.garry@huawei.com> <1643289172-165636-4-git-send-email-john.garry@huawei.com>
In-Reply-To: <1643289172-165636-4-git-send-email-john.garry@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 28 Jan 2022 07:18:42 +0100
Message-ID: <CAMGffE=uPMWRHUv_TZz+HtwtxevMN4JH891OgarwThVkRT0cQg@mail.gmail.com>
Subject: Re: [PATCH 3/3] scsi: pm8001: Fix use-after-free for aborted SSP/STP sas_task
To:     John Garry <john.garry@huawei.com>
Cc:     jinpu.wang@ionos.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, damien.lemoal@opensource.wdc.com,
        Ajish.Koshy@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viswas.G@microchip.com,
        chenxiang66@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 27, 2022 at 2:18 PM John Garry <john.garry@huawei.com> wrote:
>
> Currently a use-after-free may occur if a sas_task is aborted by the upper
> layer before we handle the IO completion in mpi_ssp_completion() or
> mpi_sata_completion().
>
> In this case, the following are the two steps in handling those IO
> completions:
> - call complete() to inform the upper layer handler of completion of
>   the IO
> - release driver resources associated with the sas_task in
>   pm8001_ccb_task_free() call
>
> When complete() is called, the upper layer may free the sas_task. As such,
> we should not touch the associated sas_task afterwards, but we do so in
> the pm8001_ccb_task_free() call.
>
> Fix by swapping the complete() and pm8001_ccb_task_free() calls ordering.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
Thx John!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index ce38a2298e75..1134e86ac928 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2185,9 +2185,9 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 pm8001_dbg(pm8001_ha, FAIL,
>                            "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                            t, status, ts->resp, ts->stat);
> +               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>                 if (t->slow_task)
>                         complete(&t->slow_task->completion);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
>                 pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> @@ -2794,9 +2794,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
>                 pm8001_dbg(pm8001_ha, FAIL,
>                            "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                            t, status, ts->resp, ts->stat);
> +               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>                 if (t->slow_task)
>                         complete(&t->slow_task->completion);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
>                 spin_unlock_irqrestore(&circularQ->oq_lock,
> --
> 2.26.2
>
