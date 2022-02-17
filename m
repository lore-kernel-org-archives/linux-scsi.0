Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB90C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244943AbiBQTEO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:04:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244940AbiBQTEM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:04:12 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18498093D
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:03:56 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hw13so9449739ejc.9
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tk/aaJ73Lsi7movcv3ADiTvoykIAgScd1a/NllAVGy8=;
        b=CZQYl0+Y6tGyA/1ZHuZRCbfn0nH7QP/34fnFrboVlxMJOieorZKQnhc8M6hebH3Ake
         pRRGJrvBomITnEajxZ0vDT4WYcGkLe/Fumi8gK61L2nk/Cyrt3aV/u1XP3Qli9JYRAUK
         282+ZKeZ0fq0tSUfzl4mvrLXDDcGRHPx05NrBbZAlB4NeT0sPDyWgldW7wd3nnZXVYvZ
         vnQx/0VaICyxNsyjtxw1MH8P/JVskrCtpdphG2pmSiCgMcKye16GHFAoTn8TqcvsI9/s
         b70Qkl3UlRLCuEt9cv3aGBrP670wHPJwBdtu2GNH0h+35l9gRO1JexJsD7UWrwKcnSOu
         +OwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tk/aaJ73Lsi7movcv3ADiTvoykIAgScd1a/NllAVGy8=;
        b=Vlo2BNhNSyrpvkgEpfzTzY2dxxhNYIXGvuSpalu5GnVTPI/+wbgVWobYwoTEhU9sHr
         0ndJL1mOcXJ66jz5AMOmdPPV8l2jG0LcjrOcTY+c7KNxqbIklkq8O9h4pOeUP0T7jdYu
         /1JVWk3TLFp+Iz3vVyAQW4aLRQm79zUEjH+yptaFvieDKMM8giKupnzX0dE54q1dqxWg
         +zx7tthm8Z9AlD+2C+cLCpdoemWEmVHrCZ6eH2RIjwHKrw8lNz/KhT6VLBh/D0gSulzs
         cpuIm1BpOz5pM9ofcj/n28ZZ0y9IEEf9D8sANh6q1wN2Mor4YEMhumyuxbKkkIXGPnAu
         mkvA==
X-Gm-Message-State: AOAM530UccDZR3Jmu6zmt0sXXav9RKOJxLR9msl9AO8V/rZoXNWopefg
        IPX0nDLovCFKugiWAbJT0kqQRl4CqFl2RnssYeGwHw==
X-Google-Smtp-Source: ABdhPJwfDiado4Tt/jbEDmVd3cKuZVdL18iPwdZo79bMCcvZBnNezonSbx7vf/iKKo62l1fAKvwSV30ROlEdAdhoiew=
X-Received: by 2002:a17:907:76ac:b0:6ce:72b5:7b7c with SMTP id
 jw12-20020a17090776ac00b006ce72b57b7cmr3417485ejc.735.1645124635573; Thu, 17
 Feb 2022 11:03:55 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-4-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-4-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:03:45 +0100
Message-ID: <CAMGffE=v1kdr5y7sgFmnc6L66RFY6qRP37RvjkmThLdMOvfiSg@mail.gmail.com>
Subject: Re: [PATCH v4 03/31] scsi: pm8001: Fix pm8001_update_flash() local
 variable type
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
> Change the type of partitionSizeTmp from u32 to __be32 to suppress the
> sparse warning:
>
> warning: cast to restricted __be32
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!

> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 66307783c73c..73f036bed128 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -721,7 +721,8 @@ static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)
>         DECLARE_COMPLETION_ONSTACK(completion);
>         u8              *ioctlbuffer;
>         struct fw_control_info  *fwControl;
> -       u32             partitionSize, partitionSizeTmp;
> +       __be32          partitionSizeTmp;
> +       u32             partitionSize;
>         u32             loopNumber, loopcount;
>         struct pm8001_fw_image_header *image_hdr;
>         u32             sizeRead = 0;
> @@ -742,7 +743,7 @@ static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)
>         image_hdr = (struct pm8001_fw_image_header *)pm8001_ha->fw_image->data;
>         while (sizeRead < pm8001_ha->fw_image->size) {
>                 partitionSizeTmp =
> -                       *(u32 *)((u8 *)&image_hdr->image_length + sizeRead);
> +                       *(__be32 *)((u8 *)&image_hdr->image_length + sizeRead);
>                 partitionSize = be32_to_cpu(partitionSizeTmp);
>                 loopcount = DIV_ROUND_UP(partitionSize + HEADER_LEN,
>                                         IOCTL_BUF_SIZE);
> --
> 2.34.1
>
