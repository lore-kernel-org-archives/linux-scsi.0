Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A373C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 08:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 512E6613C0
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 08:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbhDFIOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 04:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbhDFIOx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 04:14:53 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED13BC06174A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 01:14:45 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r22so2938937edq.9
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 01:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/oodTGUtpjR9mn81/E+2ZbAmaXggnMVC/khZLuyk4Kc=;
        b=eTyZ7t7dO6B0EVW+hTkH6qJwZe1ayiq2R10CRgldfWbqD+S0knb+eP+hBA8TIzMEde
         J6HJofHWqw+F7MKopXMg+wpEAG0DuMwZO4f9vbwnGwH7ycDUmb+/lMTzQ7AV6/VYADLi
         MsEswzJfJTwNHihMVcz0CgvDkyg+SrfdsKDFzKLB/YVue7auoam5QdhL2+xDzXtGiFk2
         Ki8H5bMA1DhdxLufLhdadpy9zbkrzOC/I/pd0TEjoA1MViEcU0ZDY1zTdJ44h2p8cyZH
         xdnQPunGNqwHNaT20vb5FZZxbbzZushJ3f56bPZlt9pfwigYbwX7DquS5y9PR0abQFJm
         3vCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/oodTGUtpjR9mn81/E+2ZbAmaXggnMVC/khZLuyk4Kc=;
        b=l5hFsqz5ILorcWmPDZ8ZNFolwQP98rkE7EmkzZfxpApv8kEr//6/7m/YSpmR4LqDs5
         zePgAcyH2EvLLGGhzuFo1nVZoZCU1o4RsQsD3EbfSj+Uqzz3EH71b9PA0wwFZ8fTJtJJ
         xMJDJBoIyNnq4NSsLAg+bYLAIFOqD1ollSt6ViBcddmueIoPMCeLAQO6VRYBpNZZp//b
         ZNvsopxWLy6+w8QrJZk6PjlfxxWP2K9ocPb1IIJCNxU3CjzDn23YjfRblv6CFP4YUKZr
         s/VwqOdyUWoh5wTzDrX4d4jonZiPg/lSTtlU/y3P+KLId5g1OwgZ42r0gIGT+2kbYvnj
         35vA==
X-Gm-Message-State: AOAM532Vk530yD+7x1bqcLmo4sYFACY46uQyQHEWZ881CRPD1QoenXVB
        +3CBeBvyFX8fXd4wcmsC/Oha8XYlUFulpxsYg/SUyA==
X-Google-Smtp-Source: ABdhPJwWb6ukMrVR2vs5plsyX4cfpr/cZ7indMvlVZco1OtcF0JytdBcrIuJvUGDFOCAeZUF79WfIlQcxzktXvShe10=
X-Received: by 2002:a05:6402:447:: with SMTP id p7mr36274594edw.89.1617696884700;
 Tue, 06 Apr 2021 01:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210329183639.1674307-1-ipylypiv@google.com> <20210329183639.1674307-2-ipylypiv@google.com>
In-Reply-To: <20210329183639.1674307-2-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 6 Apr 2021 10:14:34 +0200
Message-ID: <CAMGffEkBX65d2w5OZ3=FWj+HnZe1WOqRpWkiEQdn3LuWNasCiQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: pm80xx: Increase timeout for pm80xx mpi_uninit_check()
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, Yu Zheng <yuuzheng@google.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Viswas G <Viswas.G@microchip.com>,
        Deepak Ukey <deepak.ukey@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 29, 2021 at 8:37 PM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> The mpi_uninit_check() takes longer for inbound doorbell register to be
> cleared. Increased the timeout substantially so that the driver does not
> fail to load.
>
> Previously, the inbound doorbell wait time was mistakenly increased in
> the mpi_init_check() instead of the mpi_uninit_check(). It is okay to
> leave the mpi_init_check() wait time as is as these are timeout values
> and if there is a failure, waiting longer is not an issue.
>
> Fixes: e90e236250e9 ("scsi: pm80xx: Increase timeout for pm80xx
> mpi_uninit_check")
> Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
looks ok to me!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 84315560e8e1..a6f65666c98e 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1502,9 +1502,9 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
>
>         /* wait until Inbound DoorBell Clear Register toggled */
>         if (IS_SPCV_12G(pm8001_ha->pdev)) {
> -               max_wait_count = 4 * 1000 * 1000;/* 4 sec */
> +               max_wait_count = (30 * 1000 * 1000) /* 30 sec */
>         } else {
> -               max_wait_count = 2 * 1000 * 1000;/* 2 sec */
> +               max_wait_count = (15 * 1000 * 1000) /* 15 sec */
>         }
>         do {
>                 udelay(1);
> --
> 2.31.0.291.g576ba9dcdaf-goog
>
