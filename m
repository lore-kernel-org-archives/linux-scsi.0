Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D454CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 09:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FABD2054F
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 09:17:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="gC+7UW89"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbfKAJRj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 05:17:39 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:34655 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728206AbfKAJRi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 05:17:38 -0400
Received: by mail-il1-f193.google.com with SMTP id a13so8172994ilp.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 02:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bjyoy8M6hk/ci1432uabKaGHX9RgBndyW5DKMq2xKT0=;
        b=gC+7UW892XWxSHsGvdkbm6wBZ5vYoL4CZRHarYBGHz7e7vL1txqeubEILzOXrcBk7s
         q4doQ1uExbDFnHEDu7rMItdXH7JO9++UmJQfiUdlW5oo7lmyntXysEv1Q9A1xXsqKF+0
         82Xxdguvuidnf0H54JWByah2VdADStkp0ArFXvfN8MrDDrCSSSTWNkcVkhRwy7h7+lFE
         ssn6nvgyFXVhpMY7NNiECXGER7X5l3PEhoDe9o2DD7KFOg1DLYl7W5uei2qP33HYW78Q
         J7dg3yB0TjR4pcjBWFHOYQqzaDV9kk4T1Ga1JBqXUZ3ggLLUTQNS45q7FzgxiPrL7WLX
         s/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bjyoy8M6hk/ci1432uabKaGHX9RgBndyW5DKMq2xKT0=;
        b=lr71qBVfU1Jb/eD4BHuibXIkt5Dcawo/sigfFRNZHp00/fjBhhOfpF+0+RS8Jcsn7X
         yg3uceac7Uq/R0j9HkMX5ZybT9uT+K1yItDPBpUzf7t6J8VVO7EyYpu3eVqMxZUYKa2q
         ftEaLVJ52q6z+p8DKX4/wIo4oqo9idPIn6NGso9GGMwjHaR/6uxkqhLtRUAAQNGQW9Yn
         XbtOc4cTzR6/1+IJlXjrT6MVyzgs3oBcRPk8X9u2fhpJC88F/oAUS1mqjkZ9vumpE5ZK
         4TWtPm+7bTmEm0/wHO1TCNFm5VPWoK3l68hQMbIDVmiPmJzTBoe4FNYeJjvxNBT0SxhT
         X9UQ==
X-Gm-Message-State: APjAAAXpY9tlq3K4JGmC01WkkzBnPTHUHhdlb1XdYZTbGNsNL0LTEr5r
        q8378IxuHrS0cO6buPfZbLBBfTmG8UgfYfy6SVBf0Q==
X-Google-Smtp-Source: APXvYqyrsD4Rkpk50Q+2K2hWgw8X00K2l8X2zUaCwbz4SBr2vhurYqCyjW5UWzy1bMI9m0eiXPrLYp4Hqt9B+GlAmKg=
X-Received: by 2002:a92:d7c6:: with SMTP id g6mr9519216ilq.298.1572599857946;
 Fri, 01 Nov 2019 02:17:37 -0700 (PDT)
MIME-Version: 1.0
References: <20191031051241.6762-1-deepak.ukey@microchip.com> <20191031051241.6762-3-deepak.ukey@microchip.com>
In-Reply-To: <20191031051241.6762-3-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 1 Nov 2019 10:17:27 +0100
Message-ID: <CAMGffEmz14Qe9i4Utm9GWFnoutsxj4S_KRyXWHxuSAudwCZADg@mail.gmail.com>
Subject: Re: [PATCH 02/12] pm80xx : Initialize variable used as return status.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        jsperbeck@google.com, auradkar@google.com, ianyar@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 31, 2019 at 6:12 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: John Sperbeck <jsperbeck@google.com>
>
> In pm8001_task_exec(), if the PHY is down, then we return the
> current value of 'rc'. We need to make sure it's initialized.
>
> Signed-off-by: John Sperbeck <jsperbeck@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
Looks good, thanks.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 7e48154e11c3..81160e99c75e 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -384,7 +384,7 @@ static int pm8001_task_exec(struct sas_task *task,
>         struct pm8001_port *port = NULL;
>         struct sas_task *t = task;
>         struct pm8001_ccb_info *ccb;
> -       u32 tag = 0xdeadbeef, rc, n_elem = 0;
> +       u32 tag = 0xdeadbeef, rc = 0, n_elem = 0;
>         unsigned long flags = 0;
>
>         if (!dev->port) {
> --
> 2.16.3
>
