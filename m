Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A494AC4741F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 11:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A0D920A8B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 11:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PshEGiIB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgKELcE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 06:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729227AbgKELbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2020 06:31:03 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014DBC0613CF
        for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2020 03:31:03 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id p19so912529wmg.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2020 03:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=9umkcrTH6616Lze1LBFaD78ku7UDcVqic4D7mrv0kPk=;
        b=PshEGiIBWIOMmmh/kP/WEoPaDFV/7IAI2J16A96CKpV96UkwmKdFDYlS6sLcNVrQ9M
         ofEtBjSF1YXYzcgAuEkY3B6RZv6Ivf0nMHL3Z3uC8xl7rPQ+dtmic0iunMV6QXXIPz2G
         nFbeuDCzv72CykPjJdQ93Cc+bBE355izSem72bUwOh4A3e+xPHKNpYEorzWNq5t+DG8w
         Fl5tvFo+buaNlFQHmyRNa2piGnhrGKXtnuT/wmbGS/+uaf/Q6SIB4tsPnsTrbRE8LV3U
         KTDGxjy8XC32bPcuUcmPc7TBe95PNKMl1lMoy8qPidQ6FjcKXWhc99kM34fdDMyNa4Pr
         6lgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9umkcrTH6616Lze1LBFaD78ku7UDcVqic4D7mrv0kPk=;
        b=t6vqNV5U8ecTeqo9ia1KVffOJZxFsyNZ2RFV588yFfEWEJ2e4rh6VJwbt6jg80qfcy
         DIHKT2xcWewCGPie55LMGBMV1jKlDz4S3jTe+lJbKDymLUbHLeQ2HZwOs23coyGL6pt0
         WqaTSwiYN9QJk6J0NaDfatK7cCRMJOMz56JbBXO4oSso+qBcJkXv/lHs7f/7cw+A2GyY
         HjNZv16DNspzO1KTwTos/C1bD8I1YOmzoZXuyl/umfNrvBjEhBUAOoOcfwZVMliV9US5
         QsOKKUkxGhPGc4jpYoE2gTg0ENckthhwi522FpFYAAd0HFRrXIyi1RN66OoOU9E2kNhx
         D95A==
X-Gm-Message-State: AOAM532MD38XoHFHvywK5mMNo270RqFrUXt65pHWWz+IhhqTnFQ8MqR/
        gp5d/2hKHFVwHzjf+8QsfQnqbg==
X-Google-Smtp-Source: ABdhPJwq08yBmRu3UgLWePjJGmrz2yNOrjh+YwsY07e43MjQpdWjCrWH+f9Oqc6DJWDjtQY09zrm9g==
X-Received: by 2002:a1c:bd0b:: with SMTP id n11mr2268254wmf.111.1604575861731;
        Thu, 05 Nov 2020 03:31:01 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id a15sm2089233wrn.75.2020.11.05.03.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 03:31:01 -0800 (PST)
Date:   Thu, 5 Nov 2020 11:30:59 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Viswas G <Viswas.G@microchip.com>
Subject: Re: [PATCH 3/3] scsi: pm8001: pm8001_hwi: Remove unused variable
 'value'
Message-ID: <20201105113059.GK4488@dell>
References: <20201102102544.1018706-1-lee.jones@linaro.org>
 <20201102102544.1018706-3-lee.jones@linaro.org>
 <CAMGffE=hsihtVGiScC38WMBNejuXjSiyW0Ui7+c1wMHyOdZFMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMGffE=hsihtVGiScC38WMBNejuXjSiyW0Ui7+c1wMHyOdZFMw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 05 Nov 2020, Jinpu Wang wrote:

> +cc Viswas
> 
> On Mon, Nov 2, 2020 at 11:25 AM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > Hasn't been used since 2009.
> >
> > Fixes the following W=1 kernel build warning(s):
> >
> >  drivers/scsi/pm8001/pm8001_hwi.c: In function ‘mpi_set_phys_g3_with_ssc’:
> >  drivers/scsi/pm8001/pm8001_hwi.c:415:6: warning: variable ‘value’ set but not used [-Wunused-but-set-variable]
> >
> > Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/scsi/pm8001/pm8001_hwi.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> > index 2b7b2954ec31a..cb6959afca7fa 100644
> > --- a/drivers/scsi/pm8001/pm8001_hwi.c
> > +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> > @@ -416,7 +416,7 @@ int pm8001_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue)
> >  static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha,
> >                                      u32 SSCbit)
> >  {
> > -       u32 value, offset, i;
> > +       u32 offset, i;
> >         unsigned long flags;
> >
> >  #define SAS2_SETTINGS_LOCAL_PHY_0_3_SHIFT_ADDR 0x00030000
> > @@ -467,7 +467,6 @@ static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha,
> >         so that the written value will be 0x8090c016.
> >         This will ensure only down-spreading SSC is enabled on the SPC.
> >         *************************************************************/
> > -       value = pm8001_cr32(pm8001_ha, 2, 0xd8);
> AFAIR, the programming manual require first read the register and then
> write, Viswas, can you check?

This is an older patch that I have recently rebased.

For this exact reason, I have no longer take out the read() lines,
only the unused/unchecked variables.

If this is not okay, I will happily re-spin.

> >         pm8001_cw32(pm8001_ha, 2, 0xd8, 0x8000C016);
> >
> >         /*set the shifted destination address to 0x0 to avoid error operation */
> >

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
