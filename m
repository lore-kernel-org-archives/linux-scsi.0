Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933E4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244980AbiBQTHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:07:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237866AbiBQTHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:07:21 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C781185678
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:07:05 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id a23so9548419eju.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+VfRc6/9BA68DygL4UCGSJckgF2yK1JrNYNp59HBs08=;
        b=jFQqL4UtzoQHrOTWAiD2HgLO5fEDTD4vuQ1Gdw56jkkFZa4uXrnXouFlkCV1e6uuFK
         K7EcFbIYtklstX+fRS7gIEqGfB0o0RDPtFU9BbYk5nH9Ld72wl0yYZUiggoSa3ju5jco
         O7sFgGJS85XIFRwj5Zxj+JDp39dUvKzXT5h4w/LqxD6zNf5Qvp6XA19Nu1PhG3qWr0Cy
         DfmiuUREY9/4+PxEovjYF0qp9n3DdmSH1sahAGkaUmuTa2l9XEV2ixbE2NKh1fdx/yXD
         KHUNiZd4etSLryxaYj+I4lyZgFF17saHXc5BU5BSZ4BXXmXanCgtu1tY4hWCZztUjEWW
         AsLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+VfRc6/9BA68DygL4UCGSJckgF2yK1JrNYNp59HBs08=;
        b=e2wcP5JgatBikb/zBZCFKC5n7gDE0iR3TpgdLTwaUYjYRbWTE4qJ+pCbKJKLFGYcyY
         o1xI4X+G9d1CVz/BQvFXU14ARvNc6NSRkCk9rMX3b58e6Vd8qdWEDZr3xUCFY83277Gj
         cNGYsM+9HEoFH4ofg8cyIcDG9ZAMdlRzELlmX5WL8ovO16LUIgMLmlELSYthxN3/Ve9y
         s2TKgziY77Xvg6d38V52FUI21tLJlH3Hug0ckVXOLb/NgM1jo3hDuo6G3Bc+KVQmQ+7p
         /oW10Pi/4y7TQUOwheItUk06J1YhRJM1c32oFLz9TFpGR8G3vZ5lTGwmGGqZc0/6VLMU
         uAOA==
X-Gm-Message-State: AOAM532dNUn3TjEpBAzPhSThsmW+Dm+qwufdsuCGk1hvQQ2xTkcorR10
        zjKSw2Z4/iosNRCscMq8pPP4dH/Pzzl3U51t8HNvZw==
X-Google-Smtp-Source: ABdhPJxbk/gekTwcffVrTQtkOaLwntLI/Y/alq6Z8P1eII7VX5iM99K5irxMtZAptMc4BTA5mvXEzPATZXXW1xxe+GU=
X-Received: by 2002:a17:906:c299:b0:6b6:baa1:e5cb with SMTP id
 r25-20020a170906c29900b006b6baa1e5cbmr3483705ejz.624.1645124824373; Thu, 17
 Feb 2022 11:07:04 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-6-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-6-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:06:53 +0100
Message-ID: <CAMGffEk0+ntVYYz3fOYFhbQvYhjPR9=SqByATAEGUz21y0TZFQ@mail.gmail.com>
Subject: Re: [PATCH v4 05/31] scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
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
> The declaration of the local variable destination1 in
> pm80xx_pci_mem_copy() as a pointer to a u32 results in the sparse
> warning:
>
> warning: incorrect type in assignment (different base types)
>     expected unsigned int [usertype]
>     got restricted __le32 [usertype]
>
> Furthermore, the destination" argument of pm80xx_pci_mem_copy() is
> wrongly declared with the const attribute.
>
> Fix both problems by changing the type of the "destination" argument
> to "__le32 *" and use this argument directly inside the
> pm80xx_pci_mem_copy() function, thus removing the need for the
> destination1 local variable.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index f1663a10693a..0b3386a3c508 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -67,18 +67,16 @@ int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shift_value)
>  }
>
>  static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
> -                               const void *destination,
> +                               __le32 *destination,
>                                 u32 dw_count, u32 bus_base_number)
>  {
>         u32 index, value, offset;
> -       u32 *destination1;
> -       destination1 = (u32 *)destination;
>
> -       for (index = 0; index < dw_count; index += 4, destination1++) {
> +       for (index = 0; index < dw_count; index += 4, destination++) {
>                 offset = (soffset + index);
>                 if (offset < (64 * 1024)) {
>                         value = pm8001_cr32(pm8001_ha, bus_base_number, offset);
> -                       *destination1 =  cpu_to_le32(value);
> +                       *destination = cpu_to_le32(value);
>                 }
>         }
>         return;
> --
> 2.34.1
>
