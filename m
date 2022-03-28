Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D87C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Mar 2022 09:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239887AbiC1Jjx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Mar 2022 05:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239889AbiC1Jjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2022 05:39:52 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E593A5F4C
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 02:38:09 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id qa43so27359409ejc.12
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 02:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d4HEglnoqIeSelo7ZE22HVT4m/P5unb9lDvwp5CSwmU=;
        b=E95FqUNHihYu5EohN6s32Ei/guM8CdsJA2c8F0Y2W9zMOS+NmbUdQMO1HVHW7LMizS
         FfGbucEWgcBb5CjEzgQoGX/Av/d7EI4DJLMhaUBsNE86+2SrqbGtT1DPLMqbKBm9hTbp
         642j1X8RLqmHTOpR0jL30targqzU2SEDQhjwVqgbwGJeSPRzh1nvWKqikAgmJYyafV9R
         5DoSW/2hcS/Q1ZmPBJwZ+dajpeqLw4+hDCekpU/wJM7oIFXs4eKNqOVqJF4FAXjHzF4B
         dhMl87tzcnqqeeFd3tZwXvs2fMCV7dRQgkEPmiYW8IJ68hZAKJWj5i3bRl8e2WljHH4q
         v0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d4HEglnoqIeSelo7ZE22HVT4m/P5unb9lDvwp5CSwmU=;
        b=GPGF72rHwl3MPHGqtSlWHtstekhnA+0M336WkcdWGjyeOBwFaTkZVSgQwyqhZoYL7E
         sFfVX1ymYBg5V6jfDOBw960BAp7X5ZDB+4aJzT19rihlx2DuQnxBgi1EVW+p5XUuKb2o
         MYC4jvxEsDHP2qK9hosCTrjUuVX/rdw3o59tdLMGxYwERdfbSnXHTywOBMyUeW2vGuR5
         JjdGmTfHsGnQUe2PpE2JuXZGKlEHcqPBwpS7XMjhQcHQCeFCfyc6JoVOSEAeXR8UVq8n
         O7xkkobthLQNyLUW4TJneRLcAnm6aZSAsk4OpJ0qVwjqwlHc+Z+s4hikdhcKJWAPfBCJ
         floA==
X-Gm-Message-State: AOAM533vSHwVAv1qKNBlKoUNZLHlquywOAk0fd01iYY5qZrqWfGOFRyY
        xk0elEriKJ2XR8erlYnc2JXPG0XbmnowCHhL9f1/9w==
X-Google-Smtp-Source: ABdhPJymibQ9nM1jPukcgfU5JAHIxRYUsQ9TtQmR7Gp5RgEc+Tq4Tf9q5xneyD+PSzNA43sopSWy0oZj/gC5UVLc/5k=
X-Received: by 2002:a17:907:8d17:b0:6e0:6fa2:412f with SMTP id
 tc23-20020a1709078d1700b006e06fa2412fmr26006450ejc.441.1648460288468; Mon, 28
 Mar 2022 02:38:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220328084243.301493-1-Ajish.Koshy@microchip.com> <20220328084243.301493-3-Ajish.Koshy@microchip.com>
In-Reply-To: <20220328084243.301493-3-Ajish.Koshy@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 28 Mar 2022 11:37:57 +0200
Message-ID: <CAMGffE=hAb88b3JVG2e3+swuemfiq-B9ZdvCcpfyes9gTeDC=A@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: pm80xx: enable upper inbound, outbound queues
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        damien.lemoal@opensource.wdc.com, john.garry@huawei.com,
        Jinpu Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 28, 2022 at 10:42 AM Ajish Koshy <Ajish.Koshy@microchip.com> wrote:
>
> Executing driver on servers with more than 32 CPUs were faced with command
> timeouts. This is because we were not geting completions for commands
> submitted on IQ32 - IQ63.
>
> Set E64Q bit to enable upper inbound and outbound queues 32 to 63 in the
> MPI main configuration table.
>
> Added 500ms delay after successful MPI initialization as mentioned in
> controller datasheet.
>
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
Please add
  Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported
queues")  so it will pickup
automatically by stable.

> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index b92e82a576e3..f04c6c589615 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -766,6 +766,10 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
>         pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity       = 0x01;
>         pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt          = 0x01;
>
> +       /* Enable higher IQs and OQs, 32 to 63, bit 16*/
> +       if (pm8001_ha->max_q_num > 32)
> +               pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt |=
> +                                                       (1 << 16);
>         /* Disable end to end CRC checking */
>         pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump = (0x1 << 16);
>
> @@ -1027,6 +1031,9 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
>         if (0x0000 != gst_len_mpistate)
>                 return -EBUSY;
>
> +       /* Wait for 500ms after successful MPI initialization*/
> +       msleep(500);
> +
>         return 0;
>  }
>
> --
> 2.31.1
>
