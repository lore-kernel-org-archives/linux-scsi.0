Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E476C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 08:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3531B61008
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 08:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbhH3IYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 04:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhH3IYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 04:24:53 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F361BC061575
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 01:23:59 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g22so20361865edy.12
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 01:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=INq3PeJNk21IiyrDQ4wUcFpDlKyp0QG9dCi7jJsj6FE=;
        b=M7upBBhibwjuaB6hNhLcTftdYYNTuBOmWe5OSHUKMSh2f7qIG6l02koMLXebRutdlC
         dQh3lJ6w102wgrz08uV2TACHns2NFou+1tsWbmlJqoZ5xJfprM0dHYjA7PZ3jHSboY2T
         Zj1vZw7R/Q4yWM8mFh2OauzVehysFwvM47fnZkgC5stRlbabuuuz1UddIvbHwcbKypkn
         4TO5Dgt8+T2nVh9wPIzvRIv90T8EHHBsin8NNuwKIDUqisL3ev2bG1qKuNOJbD3Cnmu5
         zs1o07lCDvkjbrTPWJ36vcYyfUX0BmCuWnRIZQdv0sMygwtlhdum1A8QfovUEHnKKFZJ
         fSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=INq3PeJNk21IiyrDQ4wUcFpDlKyp0QG9dCi7jJsj6FE=;
        b=jVtuL0lrAsnWM2ciSQ1HD9JTAC5sbez15WKggZoC0cvLGfNxsO9TXFF/p3ePVpmCsa
         KyzKA2dqXgJ0HkKyOwoV3Djo1dlUg+g7U8WVwxA5lLMlo32u/HPoCz10dfgzjFO0rFCU
         K1iIlPyNaoH/hBJUhbVd47if0JsoE9z28LxvGndjUgDw0QR65U57iIhSugQciiZ9NdJd
         HDFrDUNZMQKMfL9djSkepXl9DQIVWIIkpvkd0ZxSXeLBHkyn/l5RRn6yTuzUT+L4Hw7z
         w49U7su8NFMmbcsKkgy28l8QH+UCZRkj0MP/eMN8d6i0GMmIlWrkqJ68yDGLlYImv8Vw
         DGfg==
X-Gm-Message-State: AOAM531fpdJSWzf5AtFLCemCOEICGYpzdcI1vOvjQ4OWGp6jN7ZgzbI+
        a5I91fvn29/jxvjDV70L91JOhX+hACGj7um94t6fhA==
X-Google-Smtp-Source: ABdhPJxJHonTj7UGy89F+hL9fWJkxyGFH01rBUrgxz5U/LlnC4yN/WoyH7DikGxN1wBm1LqmjQx/bqB/FMp5T8bnsbo=
X-Received: by 2002:aa7:dd4e:: with SMTP id o14mr5096169edw.104.1630311838449;
 Mon, 30 Aug 2021 01:23:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210823082338.67309-1-Ajish.Koshy@microchip.com> <20210823082338.67309-4-Ajish.Koshy@microchip.com>
In-Reply-To: <20210823082338.67309-4-Ajish.Koshy@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 30 Aug 2021 10:23:47 +0200
Message-ID: <CAMGffEmt7QEd4L_d0hSyXy31GTkMcGM2ei7dD3JNF=F+Wjhuqw@mail.gmail.com>
Subject: Re: [PATCH 3/4] scsi: pm80xx: Corrected Inbound and Outbound queue logging
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 23, 2021 at 9:28 AM Ajish Koshy <Ajish.Koshy@microchip.com> wrote:
>
> From: Viswas G <Viswas.G@microchip.com>
>
> Corrected inbound queue and outbound queue size in 'ib_log'
> and 'ob_log' sysfs entries.
>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index ec05c42e8ee6..b25e447aa3bd 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -409,6 +409,7 @@ static ssize_t pm8001_ctl_ib_queue_log_show(struct device *cdev,
>         char *str = buf;
>         int start = 0;
>         u32 ib_offset = pm8001_ha->ib_offset;
> +       u32 queue_size = pm8001_ha->max_q_num * PM8001_MPI_QUEUE * 128;
>  #define IB_MEMMAP(c)   \
>                 (*(u32 *)((u8 *)pm8001_ha->     \
>                 memoryMap.region[ib_offset].virt_ptr +  \
> @@ -419,7 +420,7 @@ static ssize_t pm8001_ctl_ib_queue_log_show(struct device *cdev,
>                 start = start + 4;
>         }
>         pm8001_ha->evtlog_ib_offset += SYSFS_OFFSET;
> -       if (((pm8001_ha->evtlog_ib_offset) % (PM80XX_IB_OB_QUEUE_SIZE)) == 0)
> +       if (((pm8001_ha->evtlog_ib_offset) % queue_size) == 0)
>                 pm8001_ha->evtlog_ib_offset = 0;
>
>         return str - buf;
> @@ -445,6 +446,7 @@ static ssize_t pm8001_ctl_ob_queue_log_show(struct device *cdev,
>         char *str = buf;
>         int start = 0;
>         u32 ob_offset = pm8001_ha->ob_offset;
> +       u32 queue_size = pm8001_ha->max_q_num * PM8001_MPI_QUEUE * 128;
>  #define OB_MEMMAP(c)   \
>                 (*(u32 *)((u8 *)pm8001_ha->     \
>                 memoryMap.region[ob_offset].virt_ptr +  \
> @@ -455,7 +457,7 @@ static ssize_t pm8001_ctl_ob_queue_log_show(struct device *cdev,
>                 start = start + 4;
>         }
>         pm8001_ha->evtlog_ob_offset += SYSFS_OFFSET;
> -       if (((pm8001_ha->evtlog_ob_offset) % (PM80XX_IB_OB_QUEUE_SIZE)) == 0)
> +       if (((pm8001_ha->evtlog_ob_offset) % queue_size) == 0)
>                 pm8001_ha->evtlog_ob_offset = 0;
>
>         return str - buf;
> --
> 2.27.0
>
