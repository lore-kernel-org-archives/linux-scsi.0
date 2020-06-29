Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94E4C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A04502225F
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgF2SiZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:38:25 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:53135 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgF2SiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:38:23 -0400
Received: from mail-qv1-f46.google.com ([209.85.219.46]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1M76jv-1jkC6A0CnH-008baZ for <linux-scsi@vger.kernel.org>; Mon, 29 Jun
 2020 20:33:21 +0200
Received: by mail-qv1-f46.google.com with SMTP id el4so4027838qvb.13
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 11:33:20 -0700 (PDT)
X-Gm-Message-State: AOAM530nD3k1TiR69D6pq4SzXGemm5WQ11hLUfq9AKKFaGO3lKqpj7Nl
        O9r+0Bol2VZDhD54FtDBUOLPvOzbMfAbf/PnvTE=
X-Google-Smtp-Source: ABdhPJzSDpLD8MbgKKoGIL6Ux78QrqGdouY4eul9JXJbC/4qbyhSrqbFGuvuRNZItvAXiQYRFMfjLWyUTaFzLxAxPcQ=
X-Received: by 2002:a0c:f385:: with SMTP id i5mr16983132qvk.4.1593455599980;
 Mon, 29 Jun 2020 11:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200629161051.14943-1-bvanassche@acm.org>
In-Reply-To: <20200629161051.14943-1-bvanassche@acm.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 29 Jun 2020 20:33:03 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1H0H82fp_kLDnE4=SihDO4PgB+jDiLjfmUsPfdFYXoCQ@mail.gmail.com>
Message-ID: <CAK8P3a1H0H82fp_kLDnE4=SihDO4PgB+jDiLjfmUsPfdFYXoCQ@mail.gmail.com>
Subject: Re: [PATCH] ch: Do not read past the end of vendor_labels[]
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:SLPDCTGARK4HOubfRadlVd2CtsymfVo+V+ydU7Ztm8LMlePTwrp
 39sw2jslcsbhdoIwz1Dyjcq0uD0oGty+CWW0u+pC5NP62789Txx9hMN8+EROSTkFwZn7A5N
 WUQoF69QdobxKAAUPi8etC91ieo8jNwygqCaDlEAZ8icERD0sQ0O6w+WqbCYIP45WxqaXUC
 H8VAwnKDOeMuDRzKqg2Ow==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZHAY37N1Hrw=:h3v2aMnAHi538bsg0U4uBd
 ragPpblfZm+WDfwJe3YuILll7bSp5Tlze59TK3XvYkKnU94UDh9s+M+5cuCXz8LDhcWxuy9UH
 dA5GMnRu0KfbrSPQGDQCgFuwBau6Pj8IUWbJNOCo6oXjDaX+9WqV6JGCfpoh2QcCmfs06ryel
 hM9Sa/xLuGFikjU6x8ggFRE+sL3lwmoGj2epcHWdmuKD9X4cn97YCGyLQV0Inhbc1iFNG4DUR
 8z+HC1JVLBoEnuLIzFLpCs7YK6qNRLCCldWaFgOinNB0G2FkBV1tJa9SAlQwKj4m4q26Mpl0U
 24jhNvkLwfpbbKxxQP8qr1UGzYgEB+zTOUmai7fjrmqRejmIxcLDbZ6gyWGvfathch3FG38jk
 TbiZz+/QsBCH16D3QxvLZTgWrMyiDgQgPA6v1lV/2u3tDYGAP1k+I2pT5sD+IzsxE6vd1rdaL
 CcwhO8FRiRp6LQXZVGtc2BC6KyPx7k2CtCNgP6po5sVNnP/LZQOTF9bemkpiWqiIG+/vfQoQ+
 YDyzt4aRzvfzfXOQA/vRrAPEfLdpXiV0yyR5okHYdHzK2gCurXDW1sIeTwFh2zdomfQUbYmiw
 BMcLQ9h+qGm2722g+7svKv4BP/JNRqdHDiygeO8/KKdCyFWVE76wtWBC4nDJ61ukuz/gi2phT
 3qj9Ru8iwrpCLmfIwGtypqAxRrsVSJ/SZiXVN0cF4pg/aFOjexZ6e2cK9VM7tG2IcGYb3ieM7
 Xu3M+v5uorUhEiXIgZwbRPwDIQwshWi4e+Yj0oaqaO89LSIbvoSIxPmRnmPiX3dzHLOCDauYF
 bYRl9C0SnEyjCUXpSNoypmPmqZqDcG6TLG4RFpsFnQg6XbJV6g=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 29, 2020 at 6:11 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> This patch fixes the following gcc 10 compiler error:
>
> In function 'memcpy',
>     inlined from 'ch_ioctl' at drivers/scsi/ch.c:666:4:
> ./include/linux/string.h:377:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
>   377 |    __read_overflow2();
>       |    ^~~~~~~~~~~~~~~~~~
>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ch.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
> index b81b397366db..b675a01380eb 100644
> --- a/drivers/scsi/ch.c
> +++ b/drivers/scsi/ch.c
> @@ -651,19 +651,23 @@ static long ch_ioctl(struct file *file,
>                 memset(&vparams,0,sizeof(vparams));
>                 if (ch->counts[CHET_V1]) {
>                         vparams.cvp_n1  = ch->counts[CHET_V1];
> -                       memcpy(vparams.cvp_label1,vendor_labels[0],16);
> +                       strncpy(vparams.cvp_label1, vendor_labels[0],
> +                               ARRAY_SIZE(vparams.cvp_label1));
>                 }

Against which tree is this? I see in mainline the correct

      strncpy(vparams.cvp_label1,vendor_labels[0],16);

rather than the broken memcpy. If this was changed recently to the
broken version, maybe send a revert, or add a "Fixes" tag?

        Arnd
