Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C5BC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 13:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF6AC229C5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 13:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbhAEN0q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 08:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729089AbhAEN0p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 08:26:45 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E635CC061574
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jan 2021 05:26:04 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b73so31037827edf.13
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jan 2021 05:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=51AnKIRbaB3ioi3J7GIJnioQhfvwoADh31F7hPwn/OM=;
        b=SOpyjVavO8sBKPsfRKD1l/1/JvaeZIfHv93bo4TCmLen/VXgeTrvDwr3Zyt5wcJn+s
         0Bw3Wt1piba7iHRkN3RoAhZwPOm7oFjB4WzMYEBNrrnXpI2TPHd72ky4qvsMjPRY1RB6
         Gz2JjaA02pIXV6du5r2nGiNx8QcwSPwj7IuUDGyAm17anwWxd1fA20x9oyYaaLIDm1eu
         3dOFZo+NqWwKBmaydXi9XlB7qJIbpQjK+YV9Ce6uvH+AaqivC9WlffG72JwY0BNRj5iT
         7zSIE53jNi7tpBr+So+oFdQJFKtCxw4nCFIzMSHD36wCyuotnpKhGkuUaSJPZV851hmt
         TO/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=51AnKIRbaB3ioi3J7GIJnioQhfvwoADh31F7hPwn/OM=;
        b=KaiASsbM2K0yf92n5V7DUFOTL/C3EDNib6jARTAtYedXulab5IB7VwGsF2wVVJohUT
         2/QVTyiaTM6ZtPjG/k0BxaQpqAfxl5DmtGa7g4fu9cp0ivDQUE7QFAuahaA3g+tQBo2B
         X9svW6/ZRdSniEKYZ24U9A9eXY6SUya61WuCa8br1B9eMBaZxgKfgSTnsDFjm0YTkiFj
         e6sFz0pbS1Lvz7M/7fw1r2ci/glzkWW3ymA+uBqrCo/KOiyNCOHfDbaNCC/7Jc8/sRbE
         9+TnIoeMQ7KbhE+4pUfQ3K6+PwJ6YJHOkMaK+b8G7h5RE8GJoHwjz+rMGwLy6CAT11eh
         DYbg==
X-Gm-Message-State: AOAM530ASJTHwvwwvXIOdC0Knl02147emLJ9Z8hMQCZT1o0dSlIkX4h+
        iWGFKTHwnJEuOSHUhUXR+QlS8SP9DT0eFbttkoYRrA==
X-Google-Smtp-Source: ABdhPJw6+dft+A7O2Mczk78y8uSmXawPaV+5ExLfkZO3XNuSznUua+WZo4t6pIsHReerMC6OLO4diXuDV4MKMkmweug=
X-Received: by 2002:a05:6402:a53:: with SMTP id bt19mr77275284edb.104.1609853163716;
 Tue, 05 Jan 2021 05:26:03 -0800 (PST)
MIME-Version: 1.0
References: <20201230045743.14694-1-Viswas.G@microchip.com.com> <20201230045743.14694-6-Viswas.G@microchip.com.com>
In-Reply-To: <20201230045743.14694-6-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 5 Jan 2021 14:25:52 +0100
Message-ID: <CAMGffEkrL3KxK9M6kU5JC7GEtYn349t+jgbb_5X5se+Mx9gppA@mail.gmail.com>
Subject: Re: [PATCH 5/8] pm80xx: fix driver fatal dump failure.
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
> From: Viswas G <Viswas.G@microchip.com>
>
> The fatal dump function pm80xx_get_fatal_dump() has two issues that
> result in the fatal dump not being completed successfully.
>
> 1. When trying collect fatal_logs from the application it is getting
> failed, because we are not shifting MEMBASE-II register properly.
> Once we read 64K region of data we have to shift the MEMBASE-II register
> and read the next chunk of data, then only we would be able to get
> complete data.
>
> 2. If timeout occurs our application will get stuck because we are not
> handling this case. In this patch it resolves all these issues.
>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thx
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 7d0eada11d3c..407c0cf6ab5f 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -349,10 +349,15 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
>                                 sprintf(
>                                 pm8001_ha->forensic_info.data_buf.direct_data,
>                                 "%08x ", 0xFFFFFFFF);
> -                               pm8001_cw32(pm8001_ha, 0,
> +                               return((char *)pm8001_ha->forensic_info.data_buf.direct_data -
> +                                               (char *)buf);
> +                       }
> +       /* reset fatal_forensic_shift_offset back to zero and reset MEMBASE 2 register to zero */
> +                       pm8001_ha->fatal_forensic_shift_offset = 0; /* location in 64k region */
> +                       pm8001_cw32(pm8001_ha, 0,
>                                         MEMBASE_II_SHIFT_REGISTER,
>                                         pm8001_ha->fatal_forensic_shift_offset);
> -                       }
> +               }
>                         /* Read the next block of the debug data.*/
>                         length_to_read = pm8001_mr32(fatal_table_address,
>                         MPI_FATAL_EDUMP_TABLE_ACCUM_LEN) -
> @@ -373,13 +378,12 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
>                                                                 = 0;
>                                 pm8001_ha->forensic_info.data_buf.read_len = 0;
>                         }
> -               }
>         }
>         offset = (int)((char *)pm8001_ha->forensic_info.data_buf.direct_data
>                         - (char *)buf);
>         pm8001_dbg(pm8001_ha, IO, "get_fatal_spcv: return4 0x%x\n", offset);
> -       return (char *)pm8001_ha->forensic_info.data_buf.direct_data -
> -               (char *)buf;
> +       return ((char *)pm8001_ha->forensic_info.data_buf.direct_data -
> +               (char *)buf);
>  }
>
>  /* pm80xx_get_non_fatal_dump - dump the nonfatal data from the dma
> --
> 2.16.3
>
