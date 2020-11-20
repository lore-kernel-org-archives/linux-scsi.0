Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6725FC5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 08:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED36E2053B
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 08:57:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Cec7EiJ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgKTI57 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 03:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgKTI57 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2020 03:57:59 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8915CC0617A7
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2020 00:57:58 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id y17so11765048ejh.11
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2020 00:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EiYc52m2tsrSbLYvJdrgoMyjgl7EaGY6/zDPA50tx08=;
        b=Cec7EiJ8XEubQlVqSJhu5SN8P/y6QMztowV+3Oh10KW9i2az9joSNkuMdsf03XPQ/b
         ExZlIb5qSZzYAG09AqGskUYMOJJWaZ9X47eEWnPOziyeYxQ8oSZbUJqZJIeAhwtwCN7Y
         3qaOtiiC3OLg2DnvQ9rmgnZeuqdtiYc0INLx3dU2+Ig3BJc6FCq7fr7RgjoKGROhM+Lp
         Uxwp/M8MIj+SdaCZizGoaqWDJJN0eHtcqlU1gOB/36e9QE4/2+2ZMojsKZHahhmMiv4K
         mUU8AzV8ZH2yH374RPA0puFu8G/xf3hf7ANBWfT7yg1uN//sd+FDpgXKgaGqkM05Z3Nb
         4UNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EiYc52m2tsrSbLYvJdrgoMyjgl7EaGY6/zDPA50tx08=;
        b=p3+HiXcH/vGeGWavUlEPTRb9jbLid8SlC2YvM8xqjcQGDnbrpMV/8xKw5z+JNV8q4j
         EhtgvymrHQG1Jn7SRM1RNWS+I38zhxPfrC3ulIxcinDCXWOuyGlGlSbfFHNfLb8007HX
         Gx6KyEX6pseRFE0jhYHTmmuup5/Ih0+MzoOh2vQA0+yR84kYxC1UMNxDEZuQXxi5KeZR
         vb6g2rNLmdKgk2gJAqzHlKRbKi5L1NLlXmUX/3lZYRTlCQDOnLbdHxIELTlNHeGQUK9R
         G6qIlrB9SImUvEW8JAVpGYW8Vt1/6GiCwln5yfm8dy4TVbStYwSWAzGsaLqHmsAFq5IW
         GFTg==
X-Gm-Message-State: AOAM531Bxj+wYF5h/osEpOruWO1NGhNb3MFW889QQKdz7/1Kj9C5Xn/4
        VgxpIPfvEIjpvKRfSLNoBCpaHMvfseoZ6GpI0cnqxVQHTXw=
X-Google-Smtp-Source: ABdhPJz7tCFvotvmhC8ZHKNycSuT1fJK6d1SFo2zy37PZ6KA/RS9Yoff8JFik8Z4MvHR8biZCBpDoYBU2x3XS7NUTYU=
X-Received: by 2002:a17:906:6a51:: with SMTP id n17mr14315782ejs.478.1605862677249;
 Fri, 20 Nov 2020 00:57:57 -0800 (PST)
MIME-Version: 1.0
References: <20201120083648.9319-1-vulab@iscas.ac.cn>
In-Reply-To: <20201120083648.9319-1-vulab@iscas.ac.cn>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 20 Nov 2020 09:57:46 +0100
Message-ID: <CAMGffE=jcCppveLkaChvyk1hGWn4c8HHUouWhR2_DwKXYoradw@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: remove casting kcalloc
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 20, 2020 at 9:36 AM Xu Wang <vulab@iscas.ac.cn> wrote:
>
> Remove casting the values returned by kcalloc.
>
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks Xu!
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 3cf3e58b6979..ac0e598b8ac2 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1187,8 +1187,8 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
>                 goto err_out;
>
>         /* Memory region for ccb_info*/
> -       pm8001_ha->ccb_info = (struct pm8001_ccb_info *)
> -               kcalloc(ccb_count, sizeof(struct pm8001_ccb_info), GFP_KERNEL);
> +       pm8001_ha->ccb_info =
> +               kcalloc(ccb_count, sizeof(struct pm8001_ccb_info), GFP_KERNEL);
>         if (!pm8001_ha->ccb_info) {
>                 PM8001_FAIL_DBG(pm8001_ha, pm8001_printk
>                         ("Unable to allocate memory for ccb\n"));
> --
> 2.17.1
>
