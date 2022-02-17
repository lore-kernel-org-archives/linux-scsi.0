Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2566C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245208AbiBQTdk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:33:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245206AbiBQTdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:33:39 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5CB15D38D
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:33:24 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id p9so9679322ejd.6
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bc1puSTidt/+zHnh1G99P5BTfkJXGnq0Q0ntnwkiaBk=;
        b=auV7QWYvOVnoM1+7fyG3mKnu52j6TX3ay0yo9hSi/aisJ06TUOUeWbgScBdy6rpn5V
         ta47h727mwqzw+dWpND+DeHkCyJxleCICqNEtZu0njPJuJTC5/HNTwmSsl537jJ+HIEd
         KJ3CpQHBSiqu+dADMSUUm0LwJvlwp7GZfuIenf5cz/btYQxRQpknOF+YsRHIQ6L/l8kl
         JE8+u0C46PKcLxIvGh3kskJk6PwWwRWTJcolJVD1ZWBF2kwTHjgPJJlMEYTlScpdQmQZ
         nt1P+UZXuQaTJlukpsLkNttXPdU/iKXI4qUu31Srp+qBSecru6T9gncL3bR4/KrRdlhT
         rISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bc1puSTidt/+zHnh1G99P5BTfkJXGnq0Q0ntnwkiaBk=;
        b=dUhcy+dfVVtZeI9jZ6hgXpMhsydawSIUqmfCskUC4t105uvCd6is3QOfJsgxyMhbj/
         QDl/N3LHAxE2xCDg3cuHqW/lGq9Zw6NT8qdHzO6Nyqqmx071nbBQrgafXGElnCW3P02N
         9oHE1oaiiuGr7XwoF5CsuWic+EJX6Djq1ygYg/R66MoMuzij8W5vTsVS0qj9vI7TRNny
         PTFPPOhfVqSM5elk5kEs9yvTtjkpT+fA7OMxPzIr35WFq7YuxF680EWWpEkr98o5MjCn
         5KVbgs2IMKFe4Nhf3Al8l+V+Rs5Aib9lWuJsG5XJR6r6ZU9RCmoe2S8KbLubgfnp+xkD
         OYbQ==
X-Gm-Message-State: AOAM533bsMjDTp4F/jRIbKuFR3+/lakXqAzq+2u9BQFANQH8yckHKEuP
        XZCKcYZWi3v0ilEq+8QW7697jO80VkSOg1F9PagCbw==
X-Google-Smtp-Source: ABdhPJy90o3vnvFc6f/40sVDoovzsFcqoZp9nwXqnhOtzD17sWfVXBNJvwJisyiZuk1vwmDmLWWWnJwuYyKN95P+/SE=
X-Received: by 2002:a17:906:8549:b0:69f:25ee:b38e with SMTP id
 h9-20020a170906854900b0069f25eeb38emr3571858ejy.443.1645126403299; Thu, 17
 Feb 2022 11:33:23 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-19-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-19-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:33:12 +0100
Message-ID: <CAMGffEkdcGTObqDiZrDJE0+SqKHx3K274EV0OfhhzDKnWEz=rA@mail.gmail.com>
Subject: Re: [PATCH v4 18/31] scsi: pm8001: Fix pm80xx_chip_phy_ctl_req()
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
> If pm8001_mpi_build_cmd() fails, the allocated tag should be freed.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 76260d06b6be..a5a99d23cfbe 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4920,8 +4920,13 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
>         payload.tag = cpu_to_le32(tag);
>         payload.phyop_phyid =
>                 cpu_to_le32(((phy_op & 0xFF) << 8) | (phyId & 0xFF));
> -       return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
> -                       sizeof(payload), 0);
> +
> +       rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
> +                                 sizeof(payload), 0);
> +       if (rc)
> +               pm8001_tag_free(pm8001_ha, tag);
> +
> +       return rc;
>  }
>
>  static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
> --
> 2.34.1
>
