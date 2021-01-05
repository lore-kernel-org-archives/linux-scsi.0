Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D03C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 13:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E9C3229C5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 13:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbhAENeX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 08:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbhAENeX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 08:34:23 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E79C061795
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jan 2021 05:33:42 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id b9so41242067ejy.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jan 2021 05:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iIkVLx83G41CWRKC0CLW06TbH7oAaNkFqT99VAPH524=;
        b=iYxL0Nf9SE7lyCVhYHiUpDtJCjYWKP4Sxsy0sxyAo2XdrFxKkuttTPGB7cVQF4ukoi
         iVCqButSMpr+8AQNcLWaQyt8OrcIeDEX/iY5wnEJKaQVVG6mXdqoveZioSIimEv1Z4r8
         Peke5HEHMqhUCBvkBhAOHsAcKxBwrJ5IiFnW+NzOsvlXk7Q76xGfi1NgBJ2QSKvby1CN
         8AQfpGcrZ7px4XpbYjKnIPtLZoCKi/csZ6FzxwHxn23OiiR1I0Bw1yt34dKAdnZyc7yQ
         5nV0UM+DUIUwHZc3h1wVniJyXfwkomPTEnBWFbOB3ANKNZ4VFB2eqTWcTFE0D16iF8Jj
         bMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iIkVLx83G41CWRKC0CLW06TbH7oAaNkFqT99VAPH524=;
        b=L0jwjkiVfxvftbFcLIB2UvXy7JkS1hXvFfKfZtV+Lrw3ABTr7RaHxQk9CcGoKGM4MA
         1u84DpkZG2KwuWAhwTl5sb5+IBYtZXi8V2bgqOYbV0v5DFuzO/j79vrPTcBTkSs/lnpC
         Vm5UHv6By7b21KVCr6zB9wyJUkqkGrLalSPh6FyXoR8rRG0rypownaQIFOYhBTh5Gfew
         d5TJKifhG6JrraZxNU57HzCV7wOhB2yypPA2We+n0LZ/5S3dval6bdj6iIHTavtjzWi9
         vuDmxwXgKodMii6IHgNd+UeLQ85A42bNXKVkB5o0f4f12iwvTyBVkxRBKwOFceOAqTPn
         pZ+w==
X-Gm-Message-State: AOAM531pGFIFBpTrYJn0xW41ip6HJWmTxnYTUc+VvdNRtkwbDH/bYs/X
        mXeud6XcUZSuKzk5ZWS4I9Vp/5avSTFZ0dFBXqwrAQ==
X-Google-Smtp-Source: ABdhPJx8R0GgG+WZA0Uu5zjRHa9c+vOSz3G+mJBOehdEmxvOv4uLc3CVQD+NjV7aWSCtPabgpK0UgJPefTKF4SOVTqE=
X-Received: by 2002:a17:906:4756:: with SMTP id j22mr31702969ejs.353.1609853621566;
 Tue, 05 Jan 2021 05:33:41 -0800 (PST)
MIME-Version: 1.0
References: <20201230045743.14694-1-Viswas.G@microchip.com.com> <20201230045743.14694-8-Viswas.G@microchip.com.com>
In-Reply-To: <20201230045743.14694-8-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 5 Jan 2021 14:33:31 +0100
Message-ID: <CAMGffEkL4XyRZTQYGhm50svB6FBs7oG9oP87bKqGk85aTcfmPQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] pm80xx: Log SATA IOMB completion status on failure.
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>, Ruksar.devadi@microchip.com,
        yuuzheng@google.com, vishakhavc@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com,
        bjashnani@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 30, 2020 at 5:48 AM Viswas G <Viswas.G@microchip.com.com> wrote:
>
> From: Vishakha Channapattan <vishakhavc@google.com>
>
> Added a log message in sata completion path to log the status of failed
> command. If the status does not match any expected status, another
> message will be logged.
>
> On IO failure with known status, log message will be
>
> [ 1712.951735] pm80xx0:: mpi_sata_completion 2269: IO failed device_id
> 16385 status 0x1 tag XX
>
> If the firmware returns unexpected status, log message of the following
> format will be logged -
>
> [ 1712.951735] pm80xx0:: mpi_sata_completion XXXX: Unknown status
> device_id XXXXX status 0xX tag XX
>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thx
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index df679e36954a..e7fef42b4f6c 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2437,10 +2437,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 return;
>         }
>
> -       if (unlikely(status))
> -               pm8001_dbg(pm8001_ha, IOERR,
> -                          "status:0x%x, tag:0x%x, task::0x%p\n",
> -                          status, tag, t);
> +       if (status != IO_SUCCESS) {
> +               pm8001_dbg(pm8001_ha, FAIL,
> +                       "IO failed device_id %u status 0x%x tag %d\n",
> +                       pm8001_dev->device_id, status, tag);
> +       }
>
>         /* Print sas address of IO failed device */
>         if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
> @@ -2762,7 +2763,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                         atomic_dec(&pm8001_dev->running_req);
>                 break;
>         default:
> -               pm8001_dbg(pm8001_ha, DEVIO, "Unknown status 0x%x\n", status);
> +               pm8001_dbg(pm8001_ha, DEVIO,
> +                               "Unknown status device_id %u status 0x%x tag %d\n",
> +                       pm8001_dev->device_id, status, tag);
>                 /* not allowed case. Therefore, return failed status */
>                 ts->resp = SAS_TASK_COMPLETE;
>                 ts->stat = SAS_DEV_NO_RESPONSE;
> --
> 2.16.3
>
