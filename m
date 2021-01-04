Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AA5C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 06:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C156207B3
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 06:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbhADGpx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 01:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbhADGpx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 01:45:53 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DB0C061574
        for <linux-scsi@vger.kernel.org>; Sun,  3 Jan 2021 22:45:12 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ce23so35457280ejb.8
        for <linux-scsi@vger.kernel.org>; Sun, 03 Jan 2021 22:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XA6Xz03rOOXGUKY3D4OvGVKuF3oQKR/u5dRSChDL1hI=;
        b=L5iSS+UDvUhj63xkP0ot9vY8qVJYT/ZFdKc7+kSyfSCwdeMla0mFVmF0WFfpnLlYGo
         PsKtxp6OosjoZVj57Sidr7qTfGjLmUuTGNB7ySqKCBq/jXWgmcRynwJ/AHhwqudmTOBn
         qeqO0UZszfZRIQeyCET9+KpOGw8FVcL6TG5KstcVGUp6mzSy/gSKztWs+lr8RR0TFyYm
         k5WdZJHaw3+dG0Hcsl+8GkkUp+xSDtLWd6ivGB0g7ZEhgeoBCc8VNdXyihFUbNOYe+9Z
         5HIsW/o5Gpi1/az38YUh8qe3ayxSgWv0HmcvO8K1ZCUtPGeHPG4h3ZrDWXtXtvhPK4D2
         xKag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XA6Xz03rOOXGUKY3D4OvGVKuF3oQKR/u5dRSChDL1hI=;
        b=LDrT4DuiBU8NgcV+/30L1iYGTrikOyE78x+JZNAw9RNB78crTZho0FpdSy02NZug/x
         a9L1nrP+BhPqQDhDXt67xCwmJ9I0aXwIhSEVabOPBWi3wAmHgp0J+R8F5wf6DZozKCVy
         0j29+80f8Ar1nvC79lxIR9jAldoiGDFYhkHhIDFpmIYYzHGkJowJ23puZ7YWEbAkw8Xc
         EMX+fhEZA+SfTkp7raxcS5nDzvcXnmE/+9anWd3HAV48KT7qjhjJCFDBnel54h/05i4I
         nb9+pJk89JlYvULrOCUDCIqW9705fZgoTQK37/xwCpOJbOCCxbq/zQ4O7zdAaveY1Tpu
         PNqw==
X-Gm-Message-State: AOAM530Lsf7gpICi2+7lY5w2zgFdRFjsj6S4VLLhMdF1xeHbG52P2+NF
        rMVNMF3871pb+ZLrxw1gYWQuSKyz5RydMK5UcwYxpw==
X-Google-Smtp-Source: ABdhPJxHWXPJyFO0/Q4hEu57Wwg54PRxTu+t0SU0paoEPbQM5AdyJhzWtU7HnDmcOPyqFYcOWwmlGM+XsBxtW56bIvI=
X-Received: by 2002:a17:906:2e85:: with SMTP id o5mr65056789eji.521.1609742710994;
 Sun, 03 Jan 2021 22:45:10 -0800 (PST)
MIME-Version: 1.0
References: <20201230045743.14694-1-Viswas.G@microchip.com.com> <20201230045743.14694-2-Viswas.G@microchip.com.com>
In-Reply-To: <20201230045743.14694-2-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 4 Jan 2021 07:45:00 +0100
Message-ID: <CAMGffEkqLCm_KR9=nvjAJ8eXau4p6SQ1n0Ux2F5AWG+92PbA-w@mail.gmail.com>
Subject: Re: [PATCH 1/8] pm80xx: No busywait in MPI init check
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
> From: akshatzen <akshatzen@google.com>
>
> We do not need to busy wait during mpi_init_check. I confirmed that
> mpi_init_check is not being invoked in an ATOMIC context. It is being
> called from pm8001_pci_resume, pm8001_pci_probe. Hence we are
> replacing the udelay which busy waits with msleep.
>
> Signed-off-by: akshatzen <akshatzen@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
Thanks akshatzen!
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 6 +++---
>  drivers/scsi/pm8001/pm80xx_hwi.h | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 6772b0924dac..9c4b8b374ab8 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -997,7 +997,7 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
>                 max_wait_count = SPC_DOORBELL_CLEAR_TIMEOUT;
>         }
>         do {
> -               udelay(1);
> +               msleep(FW_READY_INTERVAL);
>                 value = pm8001_cr32(pm8001_ha, 0, MSGU_IBDB_SET);
>                 value &= SPCv_MSGU_CFG_TABLE_UPDATE;
>         } while ((value != 0) && (--max_wait_count));
> @@ -1010,9 +1010,9 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
>                 return -EBUSY;
>         }
>         /* check the MPI-State for initialization upto 100ms*/
> -       max_wait_count = 100 * 1000;/* 100 msec */
> +       max_wait_count = 5;/* 100 msec */
>         do {
> -               udelay(1);
> +               msleep(FW_READY_INTERVAL);
>                 gst_len_mpistate =
>                         pm8001_mr32(pm8001_ha->general_stat_tbl_addr,
>                                         GST_GSTLEN_MPIS_OFFSET);
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index ec48bc276de6..2b6b52551968 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -220,8 +220,8 @@
>  #define SAS_DOPNRJT_RTRY_TMO            128
>  #define SAS_COPNRJT_RTRY_TMO            128
>
> -#define SPCV_DOORBELL_CLEAR_TIMEOUT    (30 * 1000 * 1000) /* 30 sec */
> -#define SPC_DOORBELL_CLEAR_TIMEOUT     (15 * 1000 * 1000) /* 15 sec */
> +#define SPCV_DOORBELL_CLEAR_TIMEOUT    (30 * 50) /* 30 sec */
> +#define SPC_DOORBELL_CLEAR_TIMEOUT     (15 * 50) /* 15 sec */
>
>  /*
>    Making ORR bigger than IT NEXUS LOSS which is 2000000us = 2 second.
> --
> 2.16.3
>
