Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D321C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 07:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FBC060F70
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 07:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhKBHK7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 03:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhKBHKd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 03:10:33 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DFDC06120D
        for <linux-scsi@vger.kernel.org>; Tue,  2 Nov 2021 00:07:59 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id f4so14226979edx.12
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2021 00:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/5xtnsLeU8/aRvH8Hyj70TTy0FFgH8iptQcMJiCaXzU=;
        b=Oa34V69RUftdVOkdTtH1sFSojVOC9MJfIyuaBu8Vsohi/qZ+uISRJwXaWeb1O3F3w8
         0yJ2o7iQ2V36/3hg0A/1t9PSCXm6Tm6ozjP9G1aCSNiHTDBSpyupmzQ/FlLF5qooRxv4
         5CewzhHTZa51GSCwFerDWf8w+N4guUnU4+c0a2Ljihmwsez2bG0S0FxnOsCuCQz1nC1y
         GO+3euL8LfJrhC7Dr1kS0y9IwxEeyJLw5vHLNCbTzvmCsrv+0jfmwNhKoH1nEcTZwggd
         H0LrrNdHfCgKfHl14/K89NQQYkV+LabsJW7pb9HzikthhgAUmXBD9Z1LvJON1X94fJu3
         v6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/5xtnsLeU8/aRvH8Hyj70TTy0FFgH8iptQcMJiCaXzU=;
        b=2Fd5vtwe+b6WuweX7RUijZjdUwfa+vyuBLeOsdrUUhRnNdtP0jqoP5+YE6QNTnce0g
         bZTkgLnThFXqqQJDTlZCU3TZczh7vvnIN0h6rg0exlt5E7YfOF1jHfEjqc/Go3dgt3rK
         4eQpEb6sgNT88DStL3mnOhmnzIeR7DailY+4Ks9fTzS9tPg+O2F/72SZcMrMoPYkKM2D
         ha+1P4igGv8dhdZkaRgzZY01UQRx1CVSqtGgRaxp86lS54PUozPHimkFDGq83SiJRUGk
         M1jiQJx4Q2Jj4akYr+wYZQIAtGNgLR0hs2C4v41uOcsjeJMcnd3sh/21MkWKqUWpwa39
         Wlfw==
X-Gm-Message-State: AOAM533SYCTKUpHT0J3cvcygD5i/P9VOwJQSyWQ+NMbV7YKdcUob3Jxv
        3JEImg+3zFN2U0lptXJTlXIPsyfTgCnbidBIH/lGkKvBpQze1aMm
X-Google-Smtp-Source: ABdhPJyYXaOEHpPdQhbyuFwSkB16MlOxTd/0/PcoLCuoa4Y1idpK5BM5Uzo7EAkGVpiOvCJERD+mim23gnl2zZd+ziE=
X-Received: by 2002:a17:907:6d07:: with SMTP id sa7mr25837679ejc.339.1635836877739;
 Tue, 02 Nov 2021 00:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211101232825.2350233-1-ipylypiv@google.com> <20211101232825.2350233-4-ipylypiv@google.com>
In-Reply-To: <20211101232825.2350233-4-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 2 Nov 2021 08:07:46 +0100
Message-ID: <CAMGffEkPT4vWf1mYfS1-4asurU6xUAowBmquBsC2vMQ44L_6DQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] scsi: pm80xx: Update WARN_ON check in pm8001_mpi_build_cmd()
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 2, 2021 at 12:29 AM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> Starting from commit 05c6c029a44d9 ("scsi: pm80xx: Increase number of
> supported queues") driver initializes only max_q_num queues.
> Do not use an invalid queue if the WARN_ON condition is true.
>
> Fixes: 7640e1eb8c5de ("scsi: pm80xx: Make mpi_build_cmd locking consistent")
> Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 1a593f2b2c87..3d41f0ac6595 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1325,7 +1325,9 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
>         int q_index = circularQ - pm8001_ha->inbnd_q_tbl;
>         int rv;
>
> -       WARN_ON(q_index >= PM8001_MAX_INB_NUM);
> +       if (WARN_ON(q_index >= pm8001_ha->max_q_num))
> +               return -EINVAL;
> +
>         spin_lock_irqsave(&circularQ->iq_lock, flags);
>         rv = pm8001_mpi_msg_free_get(circularQ, pm8001_ha->iomb_size,
>                         &pMessage);
> --
> 2.33.1.1089.g2158813163f-goog
>
