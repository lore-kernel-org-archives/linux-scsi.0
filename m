Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77974C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 08:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4469D61268
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 08:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhKPIR5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 03:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhKPIRw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 03:17:52 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AADC061570
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 00:14:55 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id b15so83715379edd.7
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 00:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XzSSxSA1/FOKWj9NU6/Te33y9OqjhK0LTlbaYaXlfWU=;
        b=RaACe8jjnWzTbGGMh7Fao3xoElu6Qx7Ci/81Xb8AZYpHztrKV5ZvET1ixTljfFIVGJ
         eEo1iE+vhVopB8yQnEFmrJ7CxAX4167V64E0O8atiy5XezioqjSXQBQLl2fFOJyDWw1Y
         iAwX7QSbdhHD4wxDUvjmP9t1mLo99nuQMTkLvjAgCNsP04/CXTWYW+m9TWJYOUDnoudJ
         V3ScVoldI/+Hz30PTdofTvPiP9n8hfaGfvuaOd8Z+QBBD+5ctOwHm7V9rl0kbtLpmxyq
         wucJUkimHyFPLb1KQRr2fz+OsB3bZR/+eQ7inX6Lr+zf5PnPsyeNQDDFxAyB/nkO7Oz/
         HbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XzSSxSA1/FOKWj9NU6/Te33y9OqjhK0LTlbaYaXlfWU=;
        b=Vc6asp5BEufo6shQarZMuN2fiKp8H24WKNIJ7h3veD0gzIh9FcfLit1qU2elq9btj5
         TcNtAcg2+Bwbs3+JEf2qmyKwa1ToGZQR++J+YFZ9+uQGIcqbVtxV9bu/AjYgoRlvgceu
         lceqZWZ0KhzzHi6OE+NBGsgMY4MPTbVrSoKNc3DX+IzbRttuTAWiSbFQXf8q3R0HKfIn
         JGd1y9TeFgu9SQOfzFfLj+3oTra/XiCmQqgWGZ99w9Ty8NTqEkqplyY16iZ/u3D+zsJh
         9me8zTxNspmj88dUvAY+WUAXUS5nsN3eku22gn3kq2O8TmlUnXPbTFRNYbxwgImkaWTO
         p4kw==
X-Gm-Message-State: AOAM530aOjQm3vcxzVHMptZ58P9GYYriyqTQnNfZxwSIj+BzXcFlVz1J
        eZPG5iqZysm/3aMaWFdUkzNJ0nUJavs0K3pUChaEsw==
X-Google-Smtp-Source: ABdhPJyvEyMdeu06FoXEaTGPFGdH+/zHBUIL5cSuoDMjHs7l4dmwma53kcsUVTjRDQIS6Km9aCDTdnJ7F4zqzG5iE3A=
X-Received: by 2002:a17:907:7d86:: with SMTP id oz6mr7055236ejc.193.1637050494037;
 Tue, 16 Nov 2021 00:14:54 -0800 (PST)
MIME-Version: 1.0
References: <20211115215750.131696-1-changyuanl@google.com> <20211115215750.131696-2-changyuanl@google.com>
In-Reply-To: <20211115215750.131696-2-changyuanl@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 16 Nov 2021 09:14:43 +0100
Message-ID: <CAMGffEkLi-Jk8XR1Yv-NT7N678cAGFWGszsnpWmh628fJYUhAA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: pm80xx: Add tracepoints
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
> Tracepoints for tracking controller and ATA commands issued and
> completed.
>
> Signed-off-by: Akshat Jain <akshatzen@google.com>
> Signed-off-by: Changyuan Lyu <changyuanl@google.com>
looks ok, thx.
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/Makefile             |  7 +-
>  drivers/scsi/pm8001/pm8001_sas.c         | 16 +++++
>  drivers/scsi/pm8001/pm80xx_hwi.c         |  7 ++
>  drivers/scsi/pm8001/pm80xx_tracepoints.c | 10 +++
>  drivers/scsi/pm8001/pm80xx_tracepoints.h | 85 ++++++++++++++++++++++++
>  5 files changed, 123 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/scsi/pm8001/pm80xx_tracepoints.c
>  create mode 100644 drivers/scsi/pm8001/pm80xx_tracepoints.h
>
> diff --git a/drivers/scsi/pm8001/Makefile b/drivers/scsi/pm8001/Makefile
> index 02b7338999cc..bbb51b7312f1 100644
> --- a/drivers/scsi/pm8001/Makefile
> +++ b/drivers/scsi/pm8001/Makefile
> @@ -6,9 +6,12 @@
>
>
>  obj-$(CONFIG_SCSI_PM8001) += pm80xx.o
> +
> +CFLAGS_pm80xx_tracepoints.o := -I$(src)
> +
>  pm80xx-y += pm8001_init.o \
>                 pm8001_sas.o  \
>                 pm8001_ctl.o  \
>                 pm8001_hwi.o  \
> -               pm80xx_hwi.o
> -
> +               pm80xx_hwi.o  \
> +               pm80xx_tracepoints.o
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 83e73009db5c..c9a16eef38c1 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -40,6 +40,7 @@
>
>  #include <linux/slab.h>
>  #include "pm8001_sas.h"
> +#include "pm80xx_tracepoints.h"
>
>  /**
>   * pm8001_find_tag - from sas task to find out  tag that belongs to this task
> @@ -527,6 +528,9 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
>  void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
>         struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx)
>  {
> +       struct ata_queued_cmd *qc;
> +       struct pm8001_device *pm8001_dev;
> +
>         if (!ccb->task)
>                 return;
>         if (!sas_protocol_ata(task->task_proto))
> @@ -549,6 +553,18 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
>                 /* do nothing */
>                 break;
>         }
> +
> +       if (sas_protocol_ata(task->task_proto)) {
> +               // For SCSI/ATA commands uldd_task points to ata_queued_cmd
> +               qc = task->uldd_task;
> +               pm8001_dev = ccb->device;
> +               trace_pm80xx_request_complete(pm8001_ha->id,
> +                       pm8001_dev ? pm8001_dev->attached_phy : PM8001_MAX_PHYS,
> +                       ccb_idx, 0 /* ctlr_opcode not known */,
> +                       qc ? qc->tf.command : 0, // ata opcode
> +                       pm8001_dev ? atomic_read(&pm8001_dev->running_req) : -1);
> +       }
> +
>         task->lldd_task = NULL;
>         ccb->task = NULL;
>         ccb->ccb_tag = 0xFFFFFFFF;
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index b9f6d83ff380..5e6ab7a3b996 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -42,6 +42,7 @@
>   #include "pm80xx_hwi.h"
>   #include "pm8001_chips.h"
>   #include "pm8001_ctl.h"
> +#include "pm80xx_tracepoints.h"
>
>  #define SMP_DIRECT 1
>  #define SMP_INDIRECT 2
> @@ -4543,6 +4544,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>         struct sas_task *task = ccb->task;
>         struct domain_device *dev = task->dev;
>         struct pm8001_device *pm8001_ha_dev = dev->lldd_dev;
> +       struct ata_queued_cmd *qc = task->uldd_task;
>         u32 tag = ccb->ccb_tag;
>         int ret;
>         u32 q_index, cpu_id;
> @@ -4762,6 +4764,11 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>                         }
>                 }
>         }
> +       trace_pm80xx_request_issue(pm8001_ha->id,
> +                               ccb->device ? ccb->device->attached_phy : PM8001_MAX_PHYS,
> +                               ccb->ccb_tag, opc,
> +                               qc ? qc->tf.command : 0, // ata opcode
> +                               ccb->device ? atomic_read(&ccb->device->running_req) : 0);
>         ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
>                         &sata_cmd, sizeof(sata_cmd), q_index);
>         return ret;
> diff --git a/drivers/scsi/pm8001/pm80xx_tracepoints.c b/drivers/scsi/pm8001/pm80xx_tracepoints.c
> new file mode 100644
> index 000000000000..344aface9cdb
> --- /dev/null
> +++ b/drivers/scsi/pm8001/pm80xx_tracepoints.c
> @@ -0,0 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Trace events in pm8001 driver.
> + *
> + * Copyright 2020 Google LLC
> + * Author: Akshat Jain <akshatzen@google.com>
> + */
> +
> +#define CREATE_TRACE_POINTS
> +#include "pm80xx_tracepoints.h"
> diff --git a/drivers/scsi/pm8001/pm80xx_tracepoints.h b/drivers/scsi/pm8001/pm80xx_tracepoints.h
> new file mode 100644
> index 000000000000..84fcfecfd624
> --- /dev/null
> +++ b/drivers/scsi/pm8001/pm80xx_tracepoints.h
> @@ -0,0 +1,85 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Trace events in pm8001 driver.
> + *
> + * Copyright 2020 Google LLC
> + * Author: Akshat Jain <akshatzen@google.com>
> + */
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM pm80xx
> +
> +#if !defined(_TRACE_PM80XX_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_PM80XX_H
> +
> +#include <linux/tracepoint.h>
> +#include "pm8001_sas.h"
> +
> +TRACE_EVENT(pm80xx_request_issue,
> +           TP_PROTO(u32 id, u32 phy_id, u32 htag, u32 ctlr_opcode,
> +                    u16 ata_opcode, int running_req),
> +
> +           TP_ARGS(id, phy_id, htag, ctlr_opcode, ata_opcode, running_req),
> +
> +           TP_STRUCT__entry(
> +                   __field(u32, id)
> +                   __field(u32, phy_id)
> +                   __field(u32, htag)
> +                   __field(u32, ctlr_opcode)
> +                   __field(u16,  ata_opcode)
> +                   __field(int, running_req)
> +                   ),
> +
> +           TP_fast_assign(
> +                   __entry->id = id;
> +                   __entry->phy_id = phy_id;
> +                   __entry->htag = htag;
> +                   __entry->ctlr_opcode = ctlr_opcode;
> +                   __entry->ata_opcode = ata_opcode;
> +                   __entry->running_req = running_req;
> +                   ),
> +
> +           TP_printk("ctlr_id = %u phy_id = %u htag = %#x, ctlr_opcode = %#x ata_opcode = %#x running_req = %d",
> +                   __entry->id, __entry->phy_id, __entry->htag,
> +                   __entry->ctlr_opcode, __entry->ata_opcode,
> +                   __entry->running_req)
> +);
> +
> +TRACE_EVENT(pm80xx_request_complete,
> +           TP_PROTO(u32 id, u32 phy_id, u32 htag, u32 ctlr_opcode,
> +                    u16 ata_opcode, int running_req),
> +
> +           TP_ARGS(id, phy_id, htag, ctlr_opcode, ata_opcode, running_req),
> +
> +           TP_STRUCT__entry(
> +                   __field(u32, id)
> +                   __field(u32, phy_id)
> +                   __field(u32, htag)
> +                   __field(u32, ctlr_opcode)
> +                   __field(u16,  ata_opcode)
> +                   __field(int, running_req)
> +                   ),
> +
> +           TP_fast_assign(
> +                   __entry->id = id;
> +                   __entry->phy_id = phy_id;
> +                   __entry->htag = htag;
> +                   __entry->ctlr_opcode = ctlr_opcode;
> +                   __entry->ata_opcode = ata_opcode;
> +                   __entry->running_req = running_req;
> +                   ),
> +
> +           TP_printk("ctlr_id = %u phy_id = %u htag = %#x, ctlr_opcode = %#x ata_opcode = %#x running_req = %d",
> +                   __entry->id, __entry->phy_id, __entry->htag,
> +                   __entry->ctlr_opcode, __entry->ata_opcode,
> +                   __entry->running_req)
> +);
> +
> +#endif /* _TRACE_PM80XX_H_ */
> +
> +#undef TRACE_INCLUDE_PATH
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_PATH .
> +#define TRACE_INCLUDE_FILE pm80xx_tracepoints
> +
> +#include <trace/define_trace.h>
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>
