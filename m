Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC648C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 13:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8200D229C5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 13:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbhAENcm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 08:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbhAENcm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 08:32:42 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9279C061574
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jan 2021 05:32:01 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id i24so31061427edj.8
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jan 2021 05:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/kuRXwHt3t/IuMQmsoMS+DdaWtUFkDKvRFkTnt4xUTs=;
        b=htiFNScV0yszoBumpUPMEGdjDo4ga9oAVPMEP8fzPMsFmJw6uJcDEWBPMewuzJYzBM
         0W0Xd6qGNxJvRDmK6urTeCmNWojJMsLWagsm+Mh/wrwafLXQD+83b+CAmOw6sOt4EgK+
         1rL1CXQU/IpPfzI0vK5UZtozzl+BYU3BBdYfQtXuZoAdeZohgohjyPGlfi5GaBaNR0tc
         nkLhTxHU+7a7HPfeNNbmaExSwzYuxup+Vpk9KqL3+NL7TaJft5WmH0mea+nPi9NaSO1T
         5hK6SeYKi3C0Md/EOdOAY/0a1eVFgpZcDK89Lwhjb9UbmblLo9iRce9TY9UdwkqONFNQ
         3pXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/kuRXwHt3t/IuMQmsoMS+DdaWtUFkDKvRFkTnt4xUTs=;
        b=jF5iOrszf4kHtleuLlfRhMQ3FuXPBBY8QzNLXfjSzqIrDy9n/ghg02iL9X+DRRARwH
         G4ro/Y6BplQlXfhCjoNNkK4hb5VbYmBbtPG0D33RwHtfndKaA1hYUQxkn+OU5WebC17I
         Z8WggxTVZntCP81DwGFyG8/6fpeG7r0PAbxQfg9o7X6QdzVwBpqm1F06fbTk32jrjwod
         6f/okU7AcytGjLNOCb+7xFoLTJvvrUr4A2V//nr06+bh7M6dHl2KXyXIW2UItdAgUeX8
         bZNLHjvpgMqVnWNao716h5t81UxRtHyjKIw/kTkocXomMI3w4rjVwGSpyNILoUSCP3FE
         tF1w==
X-Gm-Message-State: AOAM532pl569MS4UoIK5JsChMSePXcN+2NTkzA9dsxX7TqiQySnIeXx7
        VdvQfzuD/A+RLMJeykYjYKgXZlFq9aHf8vY7tCVIEg==
X-Google-Smtp-Source: ABdhPJzY5JmgSHO1T3PksghjM9eavpGd7W7UFUNpo6+rxeVO4DH66qcyhrcx9Km/7O2GayflMOfPBUmwDTBINwkpDZQ=
X-Received: by 2002:a05:6402:22b4:: with SMTP id cx20mr75564459edb.262.1609853520498;
 Tue, 05 Jan 2021 05:32:00 -0800 (PST)
MIME-Version: 1.0
References: <20201230045743.14694-1-Viswas.G@microchip.com.com> <20201230045743.14694-7-Viswas.G@microchip.com.com>
In-Reply-To: <20201230045743.14694-7-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 5 Jan 2021 14:31:49 +0100
Message-ID: <CAMGffE=06PW7Fc9EC_KxUW5aFk30oicFVZ8MbUC6p=k73KBF7A@mail.gmail.com>
Subject: Re: [PATCH 6/8] pm80xx: Simultaneous poll for all FW readiness.
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

On Wed, Dec 30, 2020 at 5:47 AM Viswas G <Viswas.G@microchip.com.com> wrote:
>
> From: Bhavesh Jashnani <bjashnani@google.com>
>
> In check_fw_ready() we first wait for ILA to come up and then we
> wait for RAAE to come up and IOPs and so on. This is a sequential check.
> Because of this ILA image seems to be not ready in the allocated time
> and so the driver marks it as "not ready" and then move on to other FW
> images. But ILA does become ready eventually, but is not checked again.
> In this way driver concludes that FW is not ready, when it actually is.
>
> Fix: Instead of sequentially polling each image, we keep polling for all
> images to be ready. The timeout for the polling has been set to the sum
> of what was used for each individual image.
>
> Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thx
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 80 ++++++++++++----------------------------
>  1 file changed, 23 insertions(+), 57 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 407c0cf6ab5f..df679e36954a 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1043,6 +1043,7 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
>         u32 value;
>         u32 max_wait_count;
>         u32 max_wait_time;
> +       u32 expected_mask;
>         int ret = 0;
>
>         /* reset / PCIe ready */
> @@ -1052,70 +1053,35 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
>                 value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
>         } while ((value == 0xFFFFFFFF) && (--max_wait_count));
>
> -       /* check ila status */
> -       max_wait_time = max_wait_count = 50;    /* 1000 milli sec */
> -       do {
> -               msleep(FW_READY_INTERVAL);
> -               value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
> -       } while (((value & SCRATCH_PAD_ILA_READY) !=
> -                       SCRATCH_PAD_ILA_READY) && (--max_wait_count));
> -       if (!max_wait_count)
> -               ret = -1;
> -       else {
> -               pm8001_dbg(pm8001_ha, MSG,
> -                          " ila ready status in %d millisec\n",
> -                          (max_wait_time - max_wait_count));
> -       }
> -
> -       /* check RAAE status */
> -       max_wait_time = max_wait_count = 90;    /* 1800 milli sec */
> -       do {
> -               msleep(FW_READY_INTERVAL);
> -               value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
> -       } while (((value & SCRATCH_PAD_RAAE_READY) !=
> -                               SCRATCH_PAD_RAAE_READY) && (--max_wait_count));
> -       if (!max_wait_count)
> -               ret = -1;
> -       else {
> -               pm8001_dbg(pm8001_ha, MSG,
> -                          " raae ready status in %d millisec\n",
> -                          (max_wait_time - max_wait_count));
> +       /* check ila, RAAE and iops status */
> +       if ((pm8001_ha->chip_id != chip_8008) &&
> +                       (pm8001_ha->chip_id != chip_8009)) {
> +               max_wait_time = max_wait_count = 180;   /* 3600 milli sec */
> +               expected_mask = SCRATCH_PAD_ILA_READY |
> +                       SCRATCH_PAD_RAAE_READY |
> +                       SCRATCH_PAD_IOP0_READY |
> +                       SCRATCH_PAD_IOP1_READY;
> +       } else {
> +               max_wait_time = max_wait_count = 170;   /* 3400 milli sec */
> +               expected_mask = SCRATCH_PAD_ILA_READY |
> +                       SCRATCH_PAD_RAAE_READY |
> +                       SCRATCH_PAD_IOP0_READY;
>         }
> -
> -       /* check iop0 status */
> -       max_wait_time = max_wait_count = 30;    /* 600 milli sec */
>         do {
>                 msleep(FW_READY_INTERVAL);
>                 value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
> -       } while (((value & SCRATCH_PAD_IOP0_READY) != SCRATCH_PAD_IOP0_READY) &&
> -                       (--max_wait_count));
> -       if (!max_wait_count)
> +       } while (((value & expected_mask) !=
> +                                expected_mask) && (--max_wait_count));
> +       if (!max_wait_count) {
> +               pm8001_dbg(pm8001_ha, INIT,
> +               "At least one FW component failed to load within %d millisec: Scratchpad1: 0x%x\n",
> +                       max_wait_time * FW_READY_INTERVAL, value);
>                 ret = -1;
> -       else {
> +       } else {
>                 pm8001_dbg(pm8001_ha, MSG,
> -                          " iop0 ready status in %d millisec\n",
> -                          (max_wait_time - max_wait_count));
> +                       "All FW components ready by %d ms\n",
> +                       (max_wait_time - max_wait_count) * FW_READY_INTERVAL);
>         }
> -
> -       /* check iop1 status only for 16 port controllers */
> -       if ((pm8001_ha->chip_id != chip_8008) &&
> -                       (pm8001_ha->chip_id != chip_8009)) {
> -               /* 200 milli sec */
> -               max_wait_time = max_wait_count = 10;
> -               do {
> -                       msleep(FW_READY_INTERVAL);
> -                       value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
> -               } while (((value & SCRATCH_PAD_IOP1_READY) !=
> -                               SCRATCH_PAD_IOP1_READY) && (--max_wait_count));
> -               if (!max_wait_count)
> -                       ret = -1;
> -               else {
> -                       pm8001_dbg(pm8001_ha, MSG,
> -                                  "iop1 ready status in %d millisec\n",
> -                                  (max_wait_time - max_wait_count));
> -               }
> -       }
> -
>         return ret;
>  }
>
> --
> 2.16.3
>
