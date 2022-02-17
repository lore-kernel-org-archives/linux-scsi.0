Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79F2C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 18:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244656AbiBQS45 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 13:56:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244654AbiBQS45 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 13:56:57 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443015BD1A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 10:56:42 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id cm8so1697205edb.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 10:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AXDXco6m4lCPOgebPPtf+aQx9sOn0zEalG/lyBlp8wA=;
        b=QeOs3ns93nor7ASR6ksv9s666noySbRWjh2xpz3sbLge6u9gFnbteYKt/hyPYgWN7K
         yuoNGVcJPnvDB+00I+F0gtNUfILJbzSvXSzdpGjNnWMriMsTs//gqC5/IwkqvpTyPXt4
         KuNHRSYSSinUsH3+KSnmtC3kKAvx4OlIjItY8IQ1PImdHpcUkqjCGlpn5rtzng3X2WdD
         VBDuJtrYC/r5ZQDbAqIGwogi3BAFVHpCmXkgcy3xe6ic4KTL/LcbN65hvK1DzMKg5eTw
         fB2O3nWv8zZ1/DeOODdQpC23hl2DZS6r+Vz2d7PzuErTwenEZXgOcflHxAeEhRsUMBGH
         GoBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AXDXco6m4lCPOgebPPtf+aQx9sOn0zEalG/lyBlp8wA=;
        b=ConeXl/Pudle2SI6jwkb7fUBJUirSnPXOAl/enM7WX0TlBa11F2x2QMp9j+kV/tN40
         WWASxJ+RY6UciU4eMkGfOdHLtTuVetXndctht3OkJ4Ahg3kUkX1+g4fLO91XMn8PgJxa
         zzm2w/XDALeieT6TOLeWJAedxVEK3BYIKbYprk/OYy8gIJyQkV29NHVxQOFxh90WpO6T
         xqpyYp9y5OQzflxPkSl2DzO1B1yN/VtmI1yYUT8jCnr01kExTG+C6LoLpHH1uFrI5aI+
         89q/pc40i90f+tRxNPOqB9inUM4s+mJOYIvS0YeZPW5vCXXSlEHQ63sQAh7QMbhXr50n
         2s6A==
X-Gm-Message-State: AOAM533+7+7D8qeVKHzQ+LtC4cPDkUqTks6YDt0JMblSC6uouLNIP1Fd
        LSbN0VemT7T87C554/h7CO/jcPExxf8Oet77qi7Ggg==
X-Google-Smtp-Source: ABdhPJxaYpwygIg0ww/iPKW2OGqEhxqczBpkRCZ4hF3TngJQ87TuaQ6Fap/ek+tEqqLE3JD08gsoEHxZok1OXrjFZ5U=
X-Received: by 2002:a05:6402:2707:b0:410:d100:6937 with SMTP id
 y7-20020a056402270700b00410d1006937mr4194582edd.428.1645124200852; Thu, 17
 Feb 2022 10:56:40 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-2-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-2-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 19:56:30 +0100
Message-ID: <CAMGffEnn5rgQBV1vH3-c338sH9oxt6g57zWmSzgxen3++X=vJw@mail.gmail.com>
Subject: Re: [PATCH v4 01/31] scsi: libsas: Fix sas_ata_qc_issue() handling of
 NCQ NON DATA commands
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
> To detect for the DMA_NONE (no data transfer) DMA direction,
> sas_ata_qc_issue() tests if the command protocol is ATA_PROT_NODATA.
> This test does not include the ATA_CMD_NCQ_NON_DATA command as this
> command protocol is defined as ATA_PROT_NCQ_NODATA (equal to
> ATA_PROT_FLAG_NCQ) and not as ATA_PROT_NODATA.
>
> To include both NCQ and non-NCQ commands when testing for the DMA_NONE
> DMA direction, use "!ata_is_data()".
>
> Fixes: 176ddd89171d ("scsi: libsas: Reset num_scatter if libata marks qc as NODATA")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx
> ---
>  drivers/scsi/libsas/sas_ata.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index e0030a093994..50f779088b6e 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -197,7 +197,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
>                 task->total_xfer_len = qc->nbytes;
>                 task->num_scatter = qc->n_elem;
>                 task->data_dir = qc->dma_dir;
> -       } else if (qc->tf.protocol == ATA_PROT_NODATA) {
> +       } else if (!ata_is_data(qc->tf.protocol)) {
>                 task->data_dir = DMA_NONE;
>         } else {
>                 for_each_sg(qc->sg, sg, qc->n_elem, si)
> --
> 2.34.1
>
