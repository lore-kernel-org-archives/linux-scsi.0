Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0A9C56201
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 06:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F2BA22203
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 06:51:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="bD/Jl40g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgJ3GvR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 02:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgJ3GvR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 02:51:17 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA40C0613CF
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2020 23:51:17 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dn5so5467755edb.10
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2020 23:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W4MMwWjJTGr0lKMmQDvd/2oziQ+mWblsWSI7aODIX5I=;
        b=bD/Jl40g4BVq1KkqjhFljVqxLZd0YplgJ8a5NobrgwjUfbr2wBD7HNFzJglgLtzyQH
         poawLvMb3eKdXBN1GMbdoBOmOvS1IOkJdSsPCiWDmrp5aMjTLL54zXcQNIX/s0KSCu7Y
         qFBtlJMjEbUG46tBCMmFgaPXEp7faF2jLSbS5l0p7WTNnnb+vTtxAp+TGNGrNA6CpjjX
         qDs/xsvgsNLT8rsd9z/Kh/LNNhskwVvnLcxLu9zsaHt0JsBeIUDW9bT/nZoCd1RVlyC8
         v18BnVWhU5VIw8uvidt+/uBwLt8JxLEgvlyJYHOA4w4/Bn6+cyg0zd9mN/X+HAf6HRpo
         kHMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W4MMwWjJTGr0lKMmQDvd/2oziQ+mWblsWSI7aODIX5I=;
        b=epQvhp2f0UD7uAOnoAGL9guaFKlqrydO/qA6Ne7h6423zF1vii/gH45j9C09fIwa7z
         EMnS5V+yBy/qZxiS1gOcqxooJSLq2oirRXnflDPZZY/JNLxZ8Xfh9y8kBg6FRxFYsZpC
         RyxUHvTYXpIaVFSk43DYkl0wsWNt0cKagOKhCFNccS13TkVwiIljX0nUTdbKf+9AiZuk
         lHQX6yQznmPihl6saPVJ+vQuhVK64p1TUu8vCtPQ8Ktcryjrk1+kGcYSB6EhlasbpgER
         H4i8l8Ic7olICEn+pHPMQe/gYUMTSgKxaeRKVK0ZY4v5aXprqJIY876X6NTUqYPHZ+8H
         4JwA==
X-Gm-Message-State: AOAM531/N1lxK44/0CRKl3cXjrdSWgeJsFEMHFGxOrkUHiDIgOil5nXH
        1sxAxIMRj/SzVT5ZYjRH/y3fT4VhYsnrNE4tt5rbWw==
X-Google-Smtp-Source: ABdhPJyxX0cB8Ir+h0YpEXEWKkBreL9sE8/DhLB0VDWDZ16fGxKY3ZGLPPTQAvKWCpB2pMPaY/tbx8CDQIgGx7bRPGo=
X-Received: by 2002:a05:6402:3133:: with SMTP id dd19mr806065edb.100.1604040675673;
 Thu, 29 Oct 2020 23:51:15 -0700 (PDT)
MIME-Version: 1.0
References: <20201030060913.14886-1-Viswas.G@microchip.com.com> <20201030060913.14886-2-Viswas.G@microchip.com.com>
In-Reply-To: <20201030060913.14886-2-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 30 Oct 2020 07:51:04 +0100
Message-ID: <CAMGffE=A-Q9D0aXj5DEVn95aJBS3hzqu+qntYzxOe6xavHKZkw@mail.gmail.com>
Subject: Re: [PATCH V2 1/4] pm80xx: make mpi_build_cmd locking consistent
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>, Ruksar.devadi@microchip.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yuuzheng@google.com, vishakhavc@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 30, 2020 at 6:59 AM Viswas G <Viswas.G@microchip.com.com> wrote:
>
> From: peter chang <dpf@google.com>
>
> Driver submit all internal requests (like abort_task, event
> acknowledgment etc.) through inbound queue 0. While submitting those,
> driver does not acquire any lock and it may lead to a race when there
> is an IO request coming in CPU0 and submitted through inbound queue 0.
> To avoid this, lock acquisition has been moved to pm8001_mpi_build_cmd().
> All command submission will go through this path.
>
> Signed-off-by: peter chang <dpf@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
This commit message is easy to follow.
Thanks.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 21 +++++++++++++++------
>  drivers/scsi/pm8001/pm80xx_hwi.c |  8 --------
>  2 files changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 2b7b2954ec31..597d7a096a97 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1356,12 +1356,19 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
>  {
>         u32 Header = 0, hpriority = 0, bc = 1, category = 0x02;
>         void *pMessage;
> -
> -       if (pm8001_mpi_msg_free_get(circularQ, pm8001_ha->iomb_size,
> -               &pMessage) < 0) {
> +       unsigned long flags;
> +       int q_index = circularQ - pm8001_ha->inbnd_q_tbl;
> +       int rv = -1;
> +
> +       WARN_ON(q_index >= PM8001_MAX_INB_NUM);
> +       spin_lock_irqsave(&circularQ->iq_lock, flags);
> +       rv = pm8001_mpi_msg_free_get(circularQ, pm8001_ha->iomb_size,
> +                       &pMessage);
> +       if (rv < 0) {
>                 PM8001_IO_DBG(pm8001_ha,
> -                       pm8001_printk("No free mpi buffer\n"));
> -               return -ENOMEM;
> +                             pm8001_printk("No free mpi buffer\n"));
> +               rv = -ENOMEM;
> +               goto done;
>         }
>
>         if (nb > (pm8001_ha->iomb_size - sizeof(struct mpi_msg_hdr)))
> @@ -1384,7 +1391,9 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
>                 pm8001_printk("INB Q %x OPCODE:%x , UPDATED PI=%d CI=%d\n",
>                         responseQueue, opCode, circularQ->producer_idx,
>                         circularQ->consumer_index));
> -       return 0;
> +done:
> +       spin_unlock_irqrestore(&circularQ->iq_lock, flags);
> +       return rv;
>  }
>
>  u32 pm8001_mpi_msg_free_set(struct pm8001_hba_info *pm8001_ha, void *pMsg,
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 7593f248afb2..5fe50e0effcd 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4281,7 +4281,6 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
>         char *preq_dma_addr = NULL;
>         __le64 tmp_addr;
>         u32 i, length;
> -       unsigned long flags;
>
>         memset(&smp_cmd, 0, sizeof(smp_cmd));
>         /*
> @@ -4377,10 +4376,8 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
>
>         build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag,
>                                 &smp_cmd, pm8001_ha->smp_exp_mode, length);
> -       spin_lock_irqsave(&circularQ->iq_lock, flags);
>         rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &smp_cmd,
>                         sizeof(smp_cmd), 0);
> -       spin_unlock_irqrestore(&circularQ->iq_lock, flags);
>         if (rc)
>                 goto err_out_2;
>         return 0;
> @@ -4444,7 +4441,6 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>         u64 phys_addr, start_addr, end_addr;
>         u32 end_addr_high, end_addr_low;
>         struct inbound_queue_table *circularQ;
> -       unsigned long flags;
>         u32 q_index, cpu_id;
>         u32 opc = OPC_INB_SSPINIIOSTART;
>         memset(&ssp_cmd, 0, sizeof(ssp_cmd));
> @@ -4582,10 +4578,8 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
>                         ssp_cmd.esgl = 0;
>                 }
>         }
> -       spin_lock_irqsave(&circularQ->iq_lock, flags);
>         ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
>                         &ssp_cmd, sizeof(ssp_cmd), q_index);
> -       spin_unlock_irqrestore(&circularQ->iq_lock, flags);
>         return ret;
>  }
>
> @@ -4819,10 +4813,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>                         }
>                 }
>         }
> -       spin_lock_irqsave(&circularQ->iq_lock, flags);
>         ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
>                         &sata_cmd, sizeof(sata_cmd), q_index);
> -       spin_unlock_irqrestore(&circularQ->iq_lock, flags);
>         return ret;
>  }
>
> --
> 2.16.3
>
