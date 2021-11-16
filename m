Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D3E0C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 08:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AA4461A03
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 08:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhKPISP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 03:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbhKPISO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 03:18:14 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352D1C061570
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 00:15:18 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w1so17933696edc.6
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 00:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LUFBCeffdMvGMWsr0ZFice7I2Ahuqm0DuI5vVCIVgZs=;
        b=EIutcE4H6KBOIWujq1QWsBBd0l/AtoMOTJJ+DdYuwM6PFY/rdGWHcFSJb+bp9x7tf/
         c4Ckvp0Nlxv00TrvBre+IGwlmFLYdNkxBtUHpgC2m+kpdAI/zdYYbixZODuKxY8Sjk2k
         1WwSupxLK65+wg8uJBtmzwWX+jiXYLl82uaCQh0aIXtyzvAfgJnqjGqf+WAgZBH8Nygh
         1D5+p76Rvt97BT82iK9ysAkNwSa/srt/5pZ/U+y7X/abVaGCD1RpWoK8n30RHlMpdp1g
         lLocVtdP8Wr+BEUO4pLazHVd/EnyGPYM6vLItK2Noo7iKDoO+RBsVl0sMs+0F9kt96lk
         ARhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LUFBCeffdMvGMWsr0ZFice7I2Ahuqm0DuI5vVCIVgZs=;
        b=SawgS051hOGUroDo1soB0QD2IHDAv6fz22qRZ7R5b6mhuB9e+S0CWdeoLpa6fSIECq
         vY85Mk5p61TNEYEUjP3sO15H3G5mjffaMXrUECfjEXHFcqjxe5JoaLy5o7VaGLFDy5VN
         wrZxoT/pJCugw5tUzDYvJY/daYxPtsHf+GPkYqjwTZGIcBaaNwnQ9BSY/dDqhP1voyGh
         KhgNQ1bski881edx3Qp/YlfmQQFQyyuQE/2crc2nzFq2noILhWblu9qAJhsmluxfvwRS
         I/+Garx4H+h2/tX7R8a2I1SUSx3M3QmZtKuWu04/CwC0tRh41x05vnW41cI80zJcE66i
         CEGg==
X-Gm-Message-State: AOAM531VS9LKyd40zutq8sYp+jYUIApdsrPPZyst7K/1ljzJacxjEM0c
        BK72xWdfhADJLcfCGP04qrYCDnsSlOgGLp1ntTYxBA==
X-Google-Smtp-Source: ABdhPJzOCPWrs9Q1TNdPSbHHQi0COGU8veXsmKHlUMfqr5lLX/cyEDwzpKq47O8+CygOvzmCLdGFpZtBv7eX7wVOjoc=
X-Received: by 2002:a17:907:7d8b:: with SMTP id oz11mr7287495ejc.507.1637050516767;
 Tue, 16 Nov 2021 00:15:16 -0800 (PST)
MIME-Version: 1.0
References: <20211115215750.131696-1-changyuanl@google.com> <20211115215750.131696-3-changyuanl@google.com>
In-Reply-To: <20211115215750.131696-3-changyuanl@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 16 Nov 2021 09:15:06 +0100
Message-ID: <CAMGffEmADJOrfJyjR09rgmCPE5fABOzQC0th0kWEmD6g=-4Ryw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] scsi: pm80xx: Add pm80xx_mpi_build_cmd tracepoint
To:     Changyuan Lyu <changyuanl@google.com>
Cc:     Jack Wang <jinpu.wang@ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 15, 2021 at 10:57 PM Changyuan Lyu <changyuanl@google.com> wrote:
>
> pm8001_mpi_build_cmd() prepares and sends all commands to a controller.
> Having pm80xx_mpi_build_cmd tracepoint can help us with latency issues.
>
> this patch depends on patch "scsi: pm80xx: Add tracepoints".
>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> Signed-off-by: Changyuan Lyu <changyuanl@google.com>
looks ok, thx.
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c         |  5 +++++
>  drivers/scsi/pm8001/pm80xx_tracepoints.h | 28 ++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 124cb69740c6..a63362bdd884 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -42,6 +42,7 @@
>   #include "pm8001_hwi.h"
>   #include "pm8001_chips.h"
>   #include "pm8001_ctl.h"
> + #include "pm80xx_tracepoints.h"
>
>  /**
>   * read_main_config_table - read the configure table and save it.
> @@ -1324,6 +1325,10 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
>         unsigned long flags;
>         int q_index = circularQ - pm8001_ha->inbnd_q_tbl;
>         int rv;
> +       u32 htag = le32_to_cpu(*(__le32 *)payload);
> +
> +       trace_pm80xx_mpi_build_cmd(pm8001_ha->id, opCode, htag, q_index,
> +               circularQ->producer_idx, le32_to_cpu(circularQ->consumer_index));
>
>         WARN_ON(q_index >= PM8001_MAX_INB_NUM);
>         spin_lock_irqsave(&circularQ->iq_lock, flags);
> diff --git a/drivers/scsi/pm8001/pm80xx_tracepoints.h b/drivers/scsi/pm8001/pm80xx_tracepoints.h
> index 84fcfecfd624..5e669a8a9344 100644
> --- a/drivers/scsi/pm8001/pm80xx_tracepoints.h
> +++ b/drivers/scsi/pm8001/pm80xx_tracepoints.h
> @@ -75,6 +75,34 @@ TRACE_EVENT(pm80xx_request_complete,
>                     __entry->running_req)
>  );
>
> +TRACE_EVENT(pm80xx_mpi_build_cmd,
> +           TP_PROTO(u32 id, u32 opc, u32 htag, u32 qi, u32 pi, u32 ci),
> +
> +           TP_ARGS(id, opc, htag, qi, pi, ci),
> +
> +           TP_STRUCT__entry(
> +                   __field(u32, id)
> +                   __field(u32, opc)
> +                   __field(u32, htag)
> +                   __field(u32, qi)
> +                   __field(u32, pi)
> +                   __field(u32, ci)
> +                   ),
> +
> +           TP_fast_assign(
> +                   __entry->id = id;
> +                   __entry->opc = opc;
> +                   __entry->htag = htag;
> +                   __entry->qi = qi;
> +                   __entry->pi = pi;
> +                   __entry->ci = ci;
> +                   ),
> +
> +           TP_printk("ctlr_id = %u opc = %#x htag = %#x QI = %u PI = %u CI = %u",
> +                   __entry->id, __entry->opc, __entry->htag, __entry->qi,
> +                   __entry->pi, __entry->ci)
> +);
> +
>  #endif /* _TRACE_PM80XX_H_ */
>
>  #undef TRACE_INCLUDE_PATH
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>
