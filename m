Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08EFDC32771
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 01:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1B61246AF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 01:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BwS97FSA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbgASBeT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 20:34:19 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:39519 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgASBeS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 20:34:18 -0500
Received: by mail-vk1-f193.google.com with SMTP id t129so7683319vkg.6;
        Sat, 18 Jan 2020 17:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YOy40kYlSRJclesJG6H5aRLwvZhYiklMAWqruJZ0en4=;
        b=BwS97FSAKRnaHtKWH9takdEk63YQtw6ltsEzbj6h5508/c28yy8HGu8FjnziuzHRq4
         WoH6KurFyqzS88HsDAGvnf9W6Gy7j8heab/32yfXcZFtIEBMLb3FfC9VhmbVzbaJwctK
         9aBrcHXXa1GDYKybKgAXknUGIiqFYKgAl/gz1GHwkD4pFHlMZ6CrTkxFknECsaXb8YbC
         2sEXNY/7Kiw7V84AyW53qe+IleZbwaC2T7bOJeGNzv0IFxyIk8JHRyj4BUG/T8L0N+LD
         vVVk42LJSQoXkqoE+8jBRYffNUEn+udihRwQ8ctZqAstBdWwgJV4HpdeGYTZQssUYPDQ
         Lcog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YOy40kYlSRJclesJG6H5aRLwvZhYiklMAWqruJZ0en4=;
        b=jrHKQrfpopLDFI31jIVZU0+yEp2bq6C5OJFTogKoUWhqCUA8D3c8YBYwfpr3aMFQNq
         FOFQaz/SLJ5KVAefu2IxDliZtoM3qbR6n5INySboeYbMqKhwGNGyKr53LU8qsgYBC8Ft
         BHLDmYnGchjmmimyt/0Gu8l4A51GNYKo6fXRAh+oGLeF/ysoRLxSr0mIlA2cxD08r6e1
         pl8xCRdrS26iTzwl2kiJz2WNa1Y0LEZcK7Se2XmxH9+2CsVz+UXxwzx6My2b0Q4uMSLa
         jsQ00q9W/3fgQBkXfR1p/hECxYVeZenPZeSxFLehPAIIkabLKplM8IX21JWw5QvguhJk
         pNmA==
X-Gm-Message-State: APjAAAXMYY7lfMMEEI0qYocD8S4TEIF6hOoDvFtLoLdTBgeVcqnDf222
        TfM8A4F6sjypTktBBaJ7mp4gn33k4SWxTbfU1X9EGpO/
X-Google-Smtp-Source: APXvYqx8jz5ODeunFRmwOOX/yO4hoqzktmLWHqLQaGh5VQrj05K0qMDVy6CwCw60283ItNvWag2cHDpBjFAEvZqE+cM=
X-Received: by 2002:a1f:252:: with SMTP id 79mr28685604vkc.96.1579397657185;
 Sat, 18 Jan 2020 17:34:17 -0800 (PST)
MIME-Version: 1.0
References: <20200119001327.29155-1-huobean@gmail.com> <20200119001327.29155-2-huobean@gmail.com>
 <CAGOxZ52QU-W-MKd05cqXVRO82QMpG1Y9+AzPx4zHsZsioGS1Og@mail.gmail.com>
In-Reply-To: <CAGOxZ52QU-W-MKd05cqXVRO82QMpG1Y9+AzPx4zHsZsioGS1Og@mail.gmail.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 07:03:41 +0530
Message-ID: <CAGOxZ50RFhPRqHPxCMepawiVsTXOLGqWBw0d74oB=HryRUfxLw@mail.gmail.com>
Subject: Re: [PATCH v3 1/8] scsi: ufs: Fix ufshcd_probe_hba() reture value in
 case ufshcd_scsi_add_wlus() fails
To:     Bean Huo <huobean@gmail.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, asutoshd@codeaurora.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean

On Sun, Jan 19, 2020 at 7:00 AM Alim Akhtar <alim.akhtar@gmail.com> wrote:
>
> Hi Bean
>
> On Sun, Jan 19, 2020 at 5:44 AM Bean Huo <huobean@gmail.com> wrote:
> >
> > From: Bean Huo <beanhuo@micron.com>
> >
> > A non-zero error value likely being returned by ufshcd_scsi_add_wlus()
> > in case of failure of adding the WLs, but ufshcd_probe_hba() doesn't
> > use this value, and doesn't report this failure to upper caller.
> > This patch is to fix this issue.
> >
> > Fixes: 2a8fa600445c ("ufs: manually add well known logical units")
> > Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> > ---
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>
Sorry for noise, its not signed-off, please have my

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

> >  drivers/scsi/ufs/ufshcd.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index bea036ab189a..9a9085a7bcc5 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -7032,7 +7032,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
> >                         ufshcd_init_icc_levels(hba);
> >
> >                 /* Add required well known logical units to scsi mid layer */
> > -               if (ufshcd_scsi_add_wlus(hba))
> > +               ret = ufshcd_scsi_add_wlus(hba);
> > +               if (ret)
> >                         goto out;
> >
> >                 /* Initialize devfreq after UFS device is detected */
> > --
> > 2.17.1
> >
>
>
> --
> Regards,
> Alim



-- 
Regards,
Alim
