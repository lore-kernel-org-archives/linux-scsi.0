Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4159C00A89
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 10:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A00C2072C
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 10:59:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="IMkCYisC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgKEK7t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 05:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgKEK7s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2020 05:59:48 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F355C0613CF
        for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2020 02:59:48 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id j20so1051807edt.8
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2020 02:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CNzITlzsbT5rFkpF+DN4/uOQu/133nEiYrzrIGmnciQ=;
        b=IMkCYisC/oi/q3sQ28EbqAaOrzeM10V/M6NdINTCWEF2Tr94Kpqfme3deX76Am7JfB
         VgMDuj3oJk0xQRQpLHQ/Nltzk4jRfWuFMRZ07imI3W04Ai48kIWDApavPgPHqp6PqlA4
         acz4grbA888Y5HFaKVYxQpZIaJ/Y+auWjy91E2aKLqMFilJXgtnjSjJom6snHHaeiM5Q
         p5gy8fkE9MWL6hzfImpoMpqMHnEKHl8oVKU46wcqxkEkEErBq+v7BkPuHsWbUqwP3363
         14djRHE96Ft1LbYK8aZORC8ZpcjmmHBJ6baVCNo3hUppNGVbbKsu/J1S5K63cXoi1juf
         L4qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CNzITlzsbT5rFkpF+DN4/uOQu/133nEiYrzrIGmnciQ=;
        b=Xw9FOMa4+oAWCEof/JrbfHdPU70nJ1UFVgxBxJEKehK4D7ffUDiqQreot8oqScMaJd
         Bkkof1yBLB6C/Cyw7u32b8IwYVv9WyR3ry9NQCNzqcIgjCcxXJ9T3kmgE5Dxxul/IzL9
         s7pw/qSJ42HAM44t132uom7ixzRHXdDdhPZLewH0HP6C7MW0gjxJ7Pe5eiUApnPkb3vo
         3srlsUlVgiSrOF2dMlQgF3N+qjolt0bugSgZJSqzyh031LTFZlmSao7gWYJYsD5tvYeR
         pDGbuhkWK0dA36WW9zWMZCaKpRs3DnxHAVysK8Fc7TShODSFor/hZ/wHglbe7onW70Qi
         gulg==
X-Gm-Message-State: AOAM532rWhawhmp8BJQ7O8jA0qk0vWJxey6or4d2GxKNaEHFf6NR1VYd
        puVrf84AnmqpV/+Qs2tmtazqAX/1UAVqKB1S+dTDzQ==
X-Google-Smtp-Source: ABdhPJxu6ufBRobFEJbzI8/lobXYJMoLoFuBnx31AsEjqWAh6a6ShHhGahr7BP7euR/bLW+CKkuJN93qpuSR5tvLifs=
X-Received: by 2002:aa7:db82:: with SMTP id u2mr1924886edt.262.1604573987209;
 Thu, 05 Nov 2020 02:59:47 -0800 (PST)
MIME-Version: 1.0
References: <20201102102544.1018706-1-lee.jones@linaro.org> <20201102102544.1018706-3-lee.jones@linaro.org>
In-Reply-To: <20201102102544.1018706-3-lee.jones@linaro.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 5 Nov 2020 11:59:35 +0100
Message-ID: <CAMGffE=hsihtVGiScC38WMBNejuXjSiyW0Ui7+c1wMHyOdZFMw@mail.gmail.com>
Subject: Re: [PATCH 3/3] scsi: pm8001: pm8001_hwi: Remove unused variable 'value'
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Viswas G <Viswas.G@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+cc Viswas

On Mon, Nov 2, 2020 at 11:25 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> Hasn't been used since 2009.
>
> Fixes the following W=3D1 kernel build warning(s):
>
>  drivers/scsi/pm8001/pm8001_hwi.c: In function =E2=80=98mpi_set_phys_g3_w=
ith_ssc=E2=80=99:
>  drivers/scsi/pm8001/pm8001_hwi.c:415:6: warning: variable =E2=80=98value=
=E2=80=99 set but not used [-Wunused-but-set-variable]
>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
> index 2b7b2954ec31a..cb6959afca7fa 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -416,7 +416,7 @@ int pm8001_bar4_shift(struct pm8001_hba_info *pm8001_=
ha, u32 shiftValue)
>  static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha,
>                                      u32 SSCbit)
>  {
> -       u32 value, offset, i;
> +       u32 offset, i;
>         unsigned long flags;
>
>  #define SAS2_SETTINGS_LOCAL_PHY_0_3_SHIFT_ADDR 0x00030000
> @@ -467,7 +467,6 @@ static void mpi_set_phys_g3_with_ssc(struct pm8001_hb=
a_info *pm8001_ha,
>         so that the written value will be 0x8090c016.
>         This will ensure only down-spreading SSC is enabled on the SPC.
>         *************************************************************/
> -       value =3D pm8001_cr32(pm8001_ha, 2, 0xd8);
AFAIR, the programming manual require first read the register and then
write, Viswas, can you check?
>         pm8001_cw32(pm8001_ha, 2, 0xd8, 0x8000C016);
>
>         /*set the shifted destination address to 0x0 to avoid error opera=
tion */
> --
> 2.25.1
>
