Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF74C388F7
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 11:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95BA720867
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 11:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Z1lqTcfj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgKELea (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 06:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730129AbgKELeX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2020 06:34:23 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3BBC0613CF
        for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2020 03:34:22 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o21so2144368ejb.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2020 03:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VWo6yd+G0DMHwjQ8Qn0WyGHl+atD3x1g8lOySdwJkmM=;
        b=Z1lqTcfjMklfVVWWeZJYIcnHZ7MnCMyrxDHfm1XHTjq252L1fzo2YuH+s6Y0jVpH6E
         deAoAl3OK+XPC9FMtJSF0DjmXFEiC7VCTnGjEf4rZraxuG0O7HgMthCRGn7R6DRg3u1P
         nr6Us58VGqAUFp3p3INmXoLi1nqp0iq3Ai3jQFJxmOii2+ey9Uk3jKEkgVrKbJ0gmcpF
         D2x2kApCdMcoMm0AEaIIZH790hufpSfl6PpeUDOQ5ZajS/sfdXJjBud3d2AORMXauTYY
         QnxOLaAOKno1j+o5MDo2TifnrNE0QHhznzGSuRq3T4f3UPmVIC/3F21XA5UZtKeGXKlY
         HxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VWo6yd+G0DMHwjQ8Qn0WyGHl+atD3x1g8lOySdwJkmM=;
        b=l6AT+JwL+/wmiRsBbYRZdWf7TtmHW4a8iCpyksNCEUT/j251vT5i3gcwMEt9xkuEU2
         QQLer4KlbUqPV15qKXbU83/UxSiFwblXKL2WpcytAqGQkBv87mXuVIgEnX6/UwlDAJ7F
         GAWhxRiYLlxz04NuF1WxetBpV7Qbm4iHoRnhUyRdgIKEAP51s1O5VK2hD2VLpzQAWCqI
         bWKeadSdf4zktC5a6ydtVRZUP/T09anUSGfZznmYWTsiDybFF/jsmithtsVDqaEdeQ3E
         T3N/3DjnZmcdqre8qoMFKOESa7Rf1QfrRYtdSLuHJqOnbFH0NUrbIyo3hMf7HsGj5RGY
         pRoQ==
X-Gm-Message-State: AOAM530Ksq0z08OtcQ0CsmICHr+5qF3zTg7AcAC9DnB2dYdC/fFPv3eh
        yz0Jir5Dx2eryqj5EKaltsbmtHy7i+pH0nDjoTJipA==
X-Google-Smtp-Source: ABdhPJxSC7JfbH83Vtk3gGBK9xGfZPpCpCXdIWv2KCuAQxuANPI6gyI6UiowTEHUALc2z3YV7PNWRtyshFLtD1AOhH4=
X-Received: by 2002:a17:906:57ca:: with SMTP id u10mr1176500ejr.389.1604576061413;
 Thu, 05 Nov 2020 03:34:21 -0800 (PST)
MIME-Version: 1.0
References: <20201102102544.1018706-1-lee.jones@linaro.org>
 <20201102102544.1018706-3-lee.jones@linaro.org> <CAMGffE=hsihtVGiScC38WMBNejuXjSiyW0Ui7+c1wMHyOdZFMw@mail.gmail.com>
 <20201105113059.GK4488@dell>
In-Reply-To: <20201105113059.GK4488@dell>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 5 Nov 2020 12:34:08 +0100
Message-ID: <CAMGffEnYXG52YhGkHEc7YMALab9eXgjNRTf46Qb7Nf-XaTBXRw@mail.gmail.com>
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

On Thu, Nov 5, 2020 at 12:31 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Thu, 05 Nov 2020, Jinpu Wang wrote:
>
> > +cc Viswas
> >
> > On Mon, Nov 2, 2020 at 11:25 AM Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > Hasn't been used since 2009.
> > >
> > > Fixes the following W=3D1 kernel build warning(s):
> > >
> > >  drivers/scsi/pm8001/pm8001_hwi.c: In function =E2=80=98mpi_set_phys_=
g3_with_ssc=E2=80=99:
> > >  drivers/scsi/pm8001/pm8001_hwi.c:415:6: warning: variable =E2=80=98v=
alue=E2=80=99 set but not used [-Wunused-but-set-variable]
> > >
> > > Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/scsi/pm8001/pm8001_hwi.c | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/p=
m8001_hwi.c
> > > index 2b7b2954ec31a..cb6959afca7fa 100644
> > > --- a/drivers/scsi/pm8001/pm8001_hwi.c
> > > +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> > > @@ -416,7 +416,7 @@ int pm8001_bar4_shift(struct pm8001_hba_info *pm8=
001_ha, u32 shiftValue)
> > >  static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_=
ha,
> > >                                      u32 SSCbit)
> > >  {
> > > -       u32 value, offset, i;
> > > +       u32 offset, i;
> > >         unsigned long flags;
> > >
> > >  #define SAS2_SETTINGS_LOCAL_PHY_0_3_SHIFT_ADDR 0x00030000
> > > @@ -467,7 +467,6 @@ static void mpi_set_phys_g3_with_ssc(struct pm800=
1_hba_info *pm8001_ha,
> > >         so that the written value will be 0x8090c016.
> > >         This will ensure only down-spreading SSC is enabled on the SP=
C.
> > >         *************************************************************=
/
> > > -       value =3D pm8001_cr32(pm8001_ha, 2, 0xd8);
> > AFAIR, the programming manual require first read the register and then
> > write, Viswas, can you check?
>
> This is an older patch that I have recently rebased.
>
> For this exact reason, I have no longer take out the read() lines,
> only the unused/unchecked variables.
>
> If this is not okay, I will happily re-spin.
then please re-spin, thanks
>
> > >         pm8001_cw32(pm8001_ha, 2, 0xd8, 0x8000C016);
> > >
> > >         /*set the shifted destination address to 0x0 to avoid error o=
peration */
> > >
>
> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> Senior Technical Lead - Developer Services
> Linaro.org =E2=94=82 Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
