Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FBCC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244835AbiBQToG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:44:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244843AbiBQToF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:44:05 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973BF41FB8
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:43:50 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id m3so5575160eda.10
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iK9b8jiqqkHa6gje81CnInAD/gDj7N8a+FbWPZjzrkU=;
        b=gAl75Ykrxco/naYL56wXEsi8+nxAw2lxXeWXpNvzPcFkQqnEUem9L77/00HU/lOg8P
         mFinIb6Y9+6eji81Jsk19DNYLZvJiCR+gaRCYJVtf0klPGSmJSTFpKggBvF6BmhIsSUD
         3X4OhPCMCw/G07gARTTsOLL3p/7aRNRV2lJaXu7sijXMD2o4PpiCelm+c3o6iIWKT0FW
         oA8V8E6v2/IqHzBKT9QtFt/0zKicsEekhMbjwq0IlPPj5g/yT4+IJ41bOW0+86US6BIS
         EulJR+lzxhtafgRLBS0x0d+7GFknh55bz5lBAfVsWyfaVt3/aU6eYh+PX0UEYsYeDJ/9
         S9dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iK9b8jiqqkHa6gje81CnInAD/gDj7N8a+FbWPZjzrkU=;
        b=Kd0/O0V1xAbferNi/GKN9Ye62cXm/CeAH/wCnuLVhbFerymfvkaTQLG4G8HklvBmuW
         A0isD8L608cjHHf2OdtIr0zGNxgYWDkJplASRf/1n19YYkimMz3wL91IxkY90BbaG6x6
         Ey+ja1Ac6UmfiOT6t6aJx2TyIwDTh9chnliAThC8wO2YawDUmDW9755NX2ko+r9oqskx
         WsZ4QIyzceEqLBAtOM2khiuv959tFd/yJv2eRBvlIVnSSLHpf+i1EYxvC1KqV8PYabgT
         p66Wj+EFRJWhq/m7fKCTmr27EBhLxvBlvSyV4RH1/KtUEwZES9bRx8PxVkM4vlAHXtdq
         PGJw==
X-Gm-Message-State: AOAM530loiYr01ktD99ftp6YdlF95bYOi3+xA69KSFtjKIeF0DSVLo0K
        ZEv3bUx1JGv6IppKIPLRGwI3oHSkTD1lihWlOQTFJA==
X-Google-Smtp-Source: ABdhPJxSKZdtsT/wYFGc4MGpfQLTftr2ETb8OG8f7b8wOk8bPtvmf8PySc4zkchbqG16dmugtmnpvbexhZeqhgE0fYA=
X-Received: by 2002:aa7:c047:0:b0:40b:488:547c with SMTP id
 k7-20020aa7c047000000b0040b0488547cmr4373848edo.76.1645127029185; Thu, 17 Feb
 2022 11:43:49 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-26-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-26-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:43:38 +0100
Message-ID: <CAMGffEkQBOxfAAYzx=2ke_TTqg66dYLWnfxMYL2KeRnzHCooLw@mail.gmail.com>
Subject: Re: [PATCH v4 25/31] scsi: pm8001: Simplify pm8001_get_ncq_tag()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 17, 2022 at 2:30 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> To detect if a command is NCQ, there is no need to test all possible NCQ
> command codes. Instead, use ata_is_ncq() to test the command protocol.
>
> Reviewed-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 0440777a9135..1e60ad82635e 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -304,16 +304,12 @@ static int pm8001_task_prep_smp(struct pm8001_hba_info *pm8001_ha,
>  u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag)
>  {
>         struct ata_queued_cmd *qc = task->uldd_task;
> -       if (qc) {
> -               if (qc->tf.command == ATA_CMD_FPDMA_WRITE ||
> -                   qc->tf.command == ATA_CMD_FPDMA_READ ||
> -                   qc->tf.command == ATA_CMD_FPDMA_RECV ||
> -                   qc->tf.command == ATA_CMD_FPDMA_SEND ||
> -                   qc->tf.command == ATA_CMD_NCQ_NON_DATA) {
> -                       *tag = qc->tag;
> -                       return 1;
> -               }
> +
> +       if (qc && ata_is_ncq(qc->tf.protocol)) {
> +               *tag = qc->tag;
> +               return 1;
>         }
> +
>         return 0;
>  }
>
> --
> 2.34.1
>
