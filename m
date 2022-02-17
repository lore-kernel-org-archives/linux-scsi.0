Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64025C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbiBQTnu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:43:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiBQTnr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:43:47 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A330741FB1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:43:32 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id i11so9891804eda.9
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LnDE2lEauEJMGRy8l54pQqllDRS3OyU48uKMbzxfwnk=;
        b=DwoNkdEoLmhjlgRy0tVrjJgtZQ7Pq6LGyKz48hvn2Z0oSTym+9eqq52R3UWEab9b+A
         2kC9xt5M11aTopNVAmKFve+sL8lf63bNNUnVWn2FhXkctWKZ4h9lLcYesF9xDy4w7Bb7
         oAsrVk/+9CJZXis0MkI8PMFugUmHT38JNucvIkC7AimXkpVg23X99ofBuSjnA9nV+T2E
         L9tQFx9RTHhut1Rda/gJM+MSKit8e2G5N33HHsWkaqsQkvX9D8GWjepZgTpZjaD2uFTC
         0tSptRLUoUhE4wAUfgV2KtbWOhv1gd/PXfZnSiTxoeJ5tDrtp9jg+5t562FJw7UuJbMC
         0jwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LnDE2lEauEJMGRy8l54pQqllDRS3OyU48uKMbzxfwnk=;
        b=gIqWIjeVoKeBJ6c9aSfVQM0K9s0AMmCI6arkbndMB7oggC66VjmR8hjhSuOl/OeByO
         qsxMgI232VfaGkMgPxGWDDZAaCCqr/1BKh6nK0b3biiJ5ljsFkukDHXR5hpSlYuqvIfa
         Sj2CnRKoJuZ+nS5kF915S5+kYQgupqIiY5Z8MEUX4TJvAy8BG6k6zLhxpKwcmvTxpuzv
         m68n+vcR8B/FB/DbblArPtyYjHmPt0np7GAGcnNLicz6fv+Xpqnx1GG6uMOS2JEgnOxi
         b17mA9TyG1AvYSnL7jIjV+Twerrim5wlodxwbmdSw0LDXiiq5A4ipe+CtddCXCHH4L8x
         z9EQ==
X-Gm-Message-State: AOAM533KiR3keMH5+rjYarImqQ34T/k56qkQdxT06YRLMJtFGMwHATvk
        CAVUy1XksVLYOkShYR62iy8Pr8u/UZNn/aRT71y5Ew==
X-Google-Smtp-Source: ABdhPJyWXXPNdLrM34DIDORw5BPH+5vvqEQW5OPTAsWvJUzeLLxiXN57fLxaPNeuCY9S7n0YnY5aEPsdhY7Yo+T4LrI=
X-Received: by 2002:aa7:c789:0:b0:410:dd40:d458 with SMTP id
 n9-20020aa7c789000000b00410dd40d458mr4551650eds.3.1645127011236; Thu, 17 Feb
 2022 11:43:31 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-25-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-25-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:43:20 +0100
Message-ID: <CAMGffEkkiVXqJTiSoUtpg_zyELhacq9eTYV7uVDC2VXf6QZYmg@mail.gmail.com>
Subject: Re: [PATCH v4 24/31] scsi: libsas: Simplify sas_ata_qc_issue()
 detection of NCQ commands
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
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/libsas/sas_ata.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 50f779088b6e..fcfc8fd4b14f 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -181,14 +181,9 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
>         task->task_proto = SAS_PROTOCOL_STP;
>         task->task_done = sas_ata_task_done;
>
> -       if (qc->tf.command == ATA_CMD_FPDMA_WRITE ||
> -           qc->tf.command == ATA_CMD_FPDMA_READ ||
> -           qc->tf.command == ATA_CMD_FPDMA_RECV ||
> -           qc->tf.command == ATA_CMD_FPDMA_SEND ||
> -           qc->tf.command == ATA_CMD_NCQ_NON_DATA) {
> -               /* Need to zero out the tag libata assigned us */
> +       /* For NCQ commands, zero out the tag libata assigned us */
> +       if (ata_is_ncq(qc->tf.protocol))
>                 qc->tf.nsect = 0;
> -       }
>
>         ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8 *)&task->ata_task.fis);
>         task->uldd_task = qc;
> --
> 2.34.1
>
