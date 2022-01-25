Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0735EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 12:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245759AbiAYMN7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 07:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347710AbiAYMKz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jan 2022 07:10:55 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1B5C061749
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jan 2022 04:08:44 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id k25so30128714ejp.5
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jan 2022 04:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bnTeOdUZ1f18AewsYNZJ5wSThzHFTuycY7IVqVPOkq4=;
        b=ZvHEkk5xUxPuGXPnF5qSuvyzgrOJuihK9Y7jz5RAAisK5c7Llx+i3W5Cim8Es9HwKQ
         KeR7WV4260zLaoLr9S7z5ZjLj6L0PiqoTCS+AaxkLgx63ttkPdzm1qZaLEuVgTlw3SY4
         +TkggyDT1NjuTNf4ubfR+Hi77GRyFzO6PGoKcAAbp3bwQpcPov13FdXRmDc5er8IYhQa
         7U3WamVIW5u0uoCphTZzxwiCUsanHATz6flPKGpHH5M4fXs0DUYxoQ7soSiu2vbQLfyM
         xhM9OYRvxgwI0BwQeIl69WroDpTU3u+6NiYm6qikHVDqAKXPFdctOQQSZzIQINkai3md
         a7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bnTeOdUZ1f18AewsYNZJ5wSThzHFTuycY7IVqVPOkq4=;
        b=1Nrpvxpvt48lEVVBwRrTEyaROFpDs6WCRifLsvshEK9hr59mMRm7GcfrRNSVpvFLu1
         JHBehdmLOCHmZX6fhc0gdp5Ngs5wMhRWJlsbOXu1Q0yJB316GSoBhebPNZbpzKiXdJVu
         rmG2E0+pq3MQ7wonSgPvB2hD0+MI5A9jSi2e91LKzxkAvGi4+MVvp6dqYKYL58rYW1XK
         /oWBmXciEoqhfGR2Ti7GGqfBfM51mPWWJcQrDZyzZVzZxa8Q03KZofoe4RSh2FS5g7Iu
         S94505tcsOqUSL+nZ0M5FD9qbMGlZ7VcyaxvZ2rAPSmm9MqcQ1SARUv/zITVlROEdUFU
         IpMw==
X-Gm-Message-State: AOAM532dOpxyVnbRtpRRq+/PSYfUsnxtbQXErtNJJAXa4TZBRusrkCMh
        7wX58yuHr5OKrwvQvZ4cQffaEhQME1GBOiMpxcchpw==
X-Google-Smtp-Source: ABdhPJz2+mIM5zA6wUdvIdNw7dCbU7p6GO73rgF0MZ2UBLSc7rUHX6MYpPx/oW8XBB/mbeH2j2BN4/3E3HfcMDU6OGs=
X-Received: by 2002:a17:907:3f84:: with SMTP id hr4mr16347608ejc.443.1643112522894;
 Tue, 25 Jan 2022 04:08:42 -0800 (PST)
MIME-Version: 1.0
References: <1643110372-85470-1-git-send-email-john.garry@huawei.com> <1643110372-85470-2-git-send-email-john.garry@huawei.com>
In-Reply-To: <1643110372-85470-2-git-send-email-john.garry@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 25 Jan 2022 13:08:31 +0100
Message-ID: <CAMGffEn1mCb=EmspNnRw_H0es5ZfBWMrZj9G8J7y=_YH3PdF6Q@mail.gmail.com>
Subject: Re: [PATCH 01/16] scsi: libsas: Use enum for response frame DATAPRES field
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        artur.paszkiewicz@intel.com, jinpu.wang@ionos.com,
        chenxiang66@hisilicon.com, Ajish.Koshy@microchip.com,
        yanaijie@huawei.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com, liuqi115@huawei.com, Viswas.G@microchip.com,
        damien.lemoal@opensource.wdc.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 12:38 PM John Garry <john.garry@huawei.com> wrote:
>
> As defined in table 126 of the SAS spec 1.1, use an enum for the DATAPRES
> field, which makes reading the code easier.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Thx!
> ---
>  drivers/scsi/libsas/sas_task.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
> index 2966ead1d421..7240fd22b154 100644
> --- a/drivers/scsi/libsas/sas_task.c
> +++ b/drivers/scsi/libsas/sas_task.c
> @@ -7,6 +7,12 @@
>  #include <scsi/sas.h>
>  #include <scsi/libsas.h>
>
> +enum {
> +       NO_DATA = 0,
> +       RESPONSE_DATA = 1,
> +       SENSE_DATA = 2,
> +};
> +
>  /* fill task_status_struct based on SSP response frame */
>  void sas_ssp_task_response(struct device *dev, struct sas_task *task,
>                            struct ssp_response_iu *iu)
> @@ -15,11 +21,11 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
>
>         tstat->resp = SAS_TASK_COMPLETE;
>
> -       if (iu->datapres == 0)
> +       if (iu->datapres == NO_DATA)
>                 tstat->stat = iu->status;
> -       else if (iu->datapres == 1)
> +       else if (iu->datapres == RESPONSE_DATA)
>                 tstat->stat = iu->resp_data[3];
> -       else if (iu->datapres == 2) {
> +       else if (iu->datapres == SENSE_DATA) {
>                 tstat->stat = SAS_SAM_STAT_CHECK_CONDITION;
>                 tstat->buf_valid_size =
>                         min_t(int, SAS_STATUS_BUF_SIZE,
> --
> 2.26.2
>
