Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BD4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244903AbiBQTBy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:01:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244898AbiBQTBx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:01:53 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDBB237D2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:01:38 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b13so11481965edn.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/J7W+6l+Yx6mew9QpywZnOmqJcHFbYnq5KlKkLcaiU=;
        b=Uqd9J0wWdOBLHFJ25Va72IjUtQjVJSNS31HimsAkNh2qnDKSxyuRkNi7yZKdK8blu6
         o8XYOBLpG2ZT0ICOdYuPJS68fSwURSdBWKyDEkrUDZsGDM0CKiP/GqQ6eq073bYh9tZ8
         u1RtSUtrVuQVU9mrrHnyUhMXhDWZkQPJWvfXo7R1EzWzGqHayY1NIhYkxQ9qxE4wP44h
         FCzxT3C34gZFFuVUU/U0Buua2KFIXCmuXwSoXp1AwXjFl4pN6aLw16OwIdtJ4UGIdkQ4
         ax/C5037CuN71QMa0jXuDenYpH0tLp/8dtbE3lBW34DbqjJaGPIIf6bOJXvXyOBURQAm
         eGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/J7W+6l+Yx6mew9QpywZnOmqJcHFbYnq5KlKkLcaiU=;
        b=UyLiC9KwUZ3g0hxtecwJ8NVe/UGZddoFTU7KhmWoPUWu5q6l7BEYvzmsYfA1ZiWQS7
         UuvRbn1ik2NRo/cgIDGZpT9y4SSqmkvhSyvqa3rmf7tzfNOJPGu7zIo4wHF6ohFDmP8a
         CaBtJi9ksoSRFywQXDGudlqMSDxg4LWAcYtPLbdK4+DTXwVwOeP8m1DExrVcty2lF2Jy
         NVNpv+jaXqUH8EJE8W39GllGXk7pm/eyXJbL3WjcdiqlLxXLoL/qsnfarK8N1Pzx5nC+
         y/AoyjB0D3r/mSW5lKlN46dPSaCD5NrV3YMlwNCQW+5tfnTTBjwHk6ApEbyL9F7+F+s8
         zMlQ==
X-Gm-Message-State: AOAM530ZZHWo0PB/wwABKeu/+C1/L2/25P1O/6sxHUHatuDfpER3ReYq
        5S/zrXppLFlv68v5yno1+NbZW89fXomho/rXGMEqKQ==
X-Google-Smtp-Source: ABdhPJzOI/v2JbHXnDvEgAyoTkbFdTeOKGlUODVephFDtb9xF/FvvxwUVDaJp3aeJxTGnI9eE8LWL79lmLMO/t8tl64=
X-Received: by 2002:a50:9b12:0:b0:410:b926:d2d3 with SMTP id
 o18-20020a509b12000000b00410b926d2d3mr4203185edi.331.1645124496804; Thu, 17
 Feb 2022 11:01:36 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-3-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-3-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:01:26 +0100
Message-ID: <CAMGffEk-e=dB6NYmPmgLgL8awG_1oeLDd0SD=uNTcPnAT9X+2A@mail.gmail.com>
Subject: Re: [PATCH v4 02/31] scsi: pm8001: Fix __iomem pointer use in pm8001_phy_control()
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
> Avoid the sparse warning "warning: cast removes address space '__iomem'
> of expression" by declaring the qp pointer as "u32 __iomem *".
> Accordingly, change the accesses to the qp array to use readl().
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
looks good to me.
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 8c12fbb9c476..4ab0ea9483f2 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -234,14 +234,13 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
>                 }
>                 {
>                         struct sas_phy *phy = sas_phy->phy;
> -                       uint32_t *qp = (uint32_t *)(((char *)
> -                               pm8001_ha->io_mem[2].memvirtaddr)
> -                               + 0x1034 + (0x4000 * (phy_id & 3)));
> -
> -                       phy->invalid_dword_count = qp[0];
> -                       phy->running_disparity_error_count = qp[1];
> -                       phy->loss_of_dword_sync_count = qp[3];
> -                       phy->phy_reset_problem_count = qp[4];
> +                       u32 __iomem *qp = pm8001_ha->io_mem[2].memvirtaddr
> +                               + 0x1034 + (0x4000 * (phy_id & 3));
> +
> +                       phy->invalid_dword_count = readl(qp);
> +                       phy->running_disparity_error_count = readl(&qp[1]);
> +                       phy->loss_of_dword_sync_count = readl(&qp[3]);
> +                       phy->phy_reset_problem_count = readl(&qp[4]);
>                 }
>                 if (pm8001_ha->chip_id == chip_8001)
>                         pm8001_bar4_shift(pm8001_ha, 0);
> --
> 2.34.1
>
