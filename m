Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82829C432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5399C20748
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:00:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="QdLJCI+X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfKRJAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 04:00:39 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:45378 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbfKRJAj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 04:00:39 -0500
Received: by mail-il1-f195.google.com with SMTP id o18so15260992ils.12
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 01:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JF9kp24ovq5QmWfmwAAiO7WqudSugVb9zv3CT+u7OBg=;
        b=QdLJCI+XQSMrWiqyn0EdW3adkxRXgzXvZhfrdvkROwhBwyWmC76R0chjVjJ0i48OF+
         Wx1aLJ+ud2Tdz+xc4AytMZ9kxyWyN+yP5/ddiUDQl9vwWr+4ky46ZedKtySxhtMf6OKO
         UHY7BpHrvVVOjovwLf/trxmyEpiHUMBKoSVPoN0KVoAgSkGCm4EgZh0SG6tXsKCsmYRO
         nHuXbtZF9BDFMSok1FUeS9FtwIZreBfNiPYKhPdwxXDxj2I8fb4Ojl9vu9YuxFvioIiF
         XB/HZi6Y5B7cb1qw4wb5KWypoaUuXc/NPtJpRUO0TEzAdiOMjiq1WzgWpEse2p3QpKjc
         ZTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JF9kp24ovq5QmWfmwAAiO7WqudSugVb9zv3CT+u7OBg=;
        b=VDatwmQJlfGUwMEGp9RUlBQ74yPvIJC1eAS8/JWvfji1W6bGlTK/mv3q62RwaGhrLt
         zv5o/12xNWINfZYTVGMKicsvY1L+y5gOl1Zu3szifES8uWOejSwLqI9K102ojEGIHX/D
         uGolf06lOZrOhPmiWvixF5PrjcBNHSacJWWtcFfYbC/dKuJsCIr2Dd2iwJH4wZB9yWOP
         p2+2UBXmAxHvB5wz8Jmx4pHTsrvJw41PbBv/q1QbF4dsacr/HdbcXLN1a4CA38iZqflQ
         J2ya6PEujrpazHeRFk3W9qJZlhNtpBcxRjUATIe5IhpTHUEPf6FlvtCkEJqKH0fs02wk
         Pt2g==
X-Gm-Message-State: APjAAAVavlfqS3cq+VWzHq1Y7v9wXxJUslcSxToab/FfZW6/iKBOisn1
        pk+Z4FMl1/T/Ub5u1fjksRxC4qyQJQT7H9jO+h1o9w==
X-Google-Smtp-Source: APXvYqyBBRRJX/xzlyOFZQvaw5BRaxEh0j4CAZHxyqM+0GpnOQdwNGIciO/ppeFhcAj04zHpirBZj8qkK7Vy7Q/xzec=
X-Received: by 2002:a92:d64d:: with SMTP id x13mr14041434ilp.54.1574067637285;
 Mon, 18 Nov 2019 01:00:37 -0800 (PST)
MIME-Version: 1.0
References: <20191114100910.6153-1-deepak.ukey@microchip.com> <20191114100910.6153-2-deepak.ukey@microchip.com>
In-Reply-To: <20191114100910.6153-2-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 18 Nov 2019 10:00:26 +0100
Message-ID: <CAMGffE=px6fJQCiO_HcSTBttfA0f5Fk1-6wbsYLsRgPY6qmcqA@mail.gmail.com>
Subject: Re: [PATCH V2 01/13] pm80xx : Fix for SATA device discovery.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        jsperbeck@google.com, Vikram Auradkar <auradkar@google.com>,
        ianyar@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 14, 2019 at 11:08 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: peter chang <dpf@google.com>
>
> Driver was  missing complete() call in mpi_sata_completion which
> result in SATA abort error handling is timing out. That causes the
> device to be left in the in_recovery state so subsequent commands
> sent to the device fail and the OS removes access to it.
>
> Signed-off-by: peter chang <dpf@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 73261902d75d..161bf4760eac 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2382,6 +2382,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                         pm8001_printk("task 0x%p done with io_status 0x%x"
>                         " resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                         t, status, ts->resp, ts->stat));
> +               if (t->slow_task)
> +                       complete(&t->slow_task->completion);
>                 pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
> --
> 2.16.3
>
