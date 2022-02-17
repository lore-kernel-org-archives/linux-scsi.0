Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B744FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245255AbiBQTg1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:36:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245253AbiBQTgZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:36:25 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80F1165C2C
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:36:10 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id d10so9639523eje.10
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QQgZVJIg25ZIo1gnKwITJGLtmYxNWDIEQXhCRVAIe9A=;
        b=E0FaYLyq7x0YQFQNNSFED6sr60ccjVD8ue0KLjZUnHDj7bAHYScv/qEHBEsV+i7VyU
         egwXtxbkQjdOCmoHKks0HFKnkWVrTMr69iygUQod+LmyZwtSNln6Vpy6VNWJj/7ECLOT
         VX5qgbhBQiXLBCtTARCi/odRfj0CQLVPSPl+qqxUM2LImLC+LWKE1vIE6oMcSWLX9D2E
         eQr1B62l+wxtr3HOQkWIBjU1633tzl+uvDogTPionBIHl7vpCymsUn4HZjj+yMCeIrrF
         0TkwKoNMFOJkjvI0lm4MmeLpT9rBOPgBOPDApIxPdzv0s2KJPblAdMOCOta/48CuHnq2
         bh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QQgZVJIg25ZIo1gnKwITJGLtmYxNWDIEQXhCRVAIe9A=;
        b=xALfrpo1gIrXId+j3okdK2imZa+LrnfWCQ+Kp51JP6HyQW6KYh615FaPo6W6L8hcFw
         Te3Ct+kaqcleu8YUjDOg5ldYnt//6tBlXLFtylfsvhigN4zV1Bh76wvac0bCrCmPbLCS
         FhhT+U+e3Fp920RAGgdg/b7Uw2gcKmRm5GTDJUH3oLeBKRGRljh1085/59FE1YUYpUER
         Q9XavKnzrpGQx27XQbgio/yBOeca3bYq3OzfoOHKyZv4/ty3QYKigcHkj7mtm4uOwHyD
         dMjqD0b+D+HKulxgzpc+lr/V8SKK7zebh6USfMy7YPv2nUsX5/OmfftiVjqY+rJ6H5a4
         r0aA==
X-Gm-Message-State: AOAM533SO4yxCRHoI4STuERD20x4gJhNszNMaV8ncCyjN5NBJhSqj3kW
        R5dOWuduSsy2/TNrLM1S7S86Am7MBaCbx1vLaDwNBw==
X-Google-Smtp-Source: ABdhPJzSAhfPMrENvRgfF3a3xLrXhEhnrXG9UUB5Ccj2R9RSwip3kFAmFVG0PHz8ofH/GED51k9kNjE/2jSkhMLsYhU=
X-Received: by 2002:a17:906:4d8d:b0:6ce:8c3d:6e81 with SMTP id
 s13-20020a1709064d8d00b006ce8c3d6e81mr3448635eju.205.1645126569465; Thu, 17
 Feb 2022 11:36:09 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-20-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-20-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:35:58 +0100
Message-ID: <CAMGffEnXV8HAsfqec40ULZsew5m0Fu=s4N99mt-G7LV5HnkxqQ@mail.gmail.com>
Subject: Re: [PATCH v4 19/31] scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
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
> The call to pm8001_ccb_task_free() at the end of
> pm8001_mpi_task_abort_resp() already frees the ccb tag. So when the
> device NCQ_ABORT_ALL_FLAG is set, the tag should not be freed again.
> Also change the hardcoded 0xBFFFFFFF value to ~NCQ_ABORT_ALL_FLAG as it
> ought to be.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 35d62e5c9200..5cad5504301e 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3700,12 +3700,11 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         mb();
>
>         if (pm8001_dev->id & NCQ_ABORT_ALL_FLAG) {
> -               pm8001_tag_free(pm8001_ha, tag);
>                 sas_free_task(t);
> -               /* clear the flag */
> -               pm8001_dev->id &= 0xBFFFFFFF;
> -       } else
> +               pm8001_dev->id &= ~NCQ_ABORT_ALL_FLAG;
> +       } else {
>                 t->task_done(t);
> +       }
>
>         return 0;
>  }
> --
> 2.34.1
>
