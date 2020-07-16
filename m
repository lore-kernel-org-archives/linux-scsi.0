Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95518C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 08:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722AD2071B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 08:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sn57Qzsy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgGPIAR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 04:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgGPIAR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2020 04:00:17 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DC3C08C5C0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 01:00:16 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c80so9238730wme.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 01:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=eK+NQpi1H7gGHgVmnjEP/NQYX3h/AgB6eSXs4+PSJIg=;
        b=sn57QzsyyH/w3IwaZ0qzjp/xeuPrzZt7j6tXzWGKXK90sZwzf6oTn8EiYU5aUnn+dS
         CnwtApOXbFaxNR4tEdeFMYlkT422aoRx64dXZ+S5kV20KGZMMjPz8kDOovJxpBafODc6
         R0I6rxpc/y07qIPqgOOQDx+OutoRh8fw7nskpUFw84/uaPKyprC9crt0MCJHakzLJUKs
         Nl6wogMf3oJdZYN9WYdmi/A8PhsBCuy9U4AFX+xuk/oAyl4H1Cp9GeaIVyYNnomNHLNn
         RWOEvIuduHK2lsAlt3FSVtwIcl8d7fo3vuSuiBQmh93VdD88d6h8O8m+mL+foTnDy2Yp
         NMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eK+NQpi1H7gGHgVmnjEP/NQYX3h/AgB6eSXs4+PSJIg=;
        b=MNT3zQXXmExnwtYRSwxnqi9ipBpiGMcqtfG6AdHyD5H8WqCVoJEVcrwNDduzv3z4FL
         1sRFMW2Xa8v+ci6+14s04YEQmoR2EGWelNbJioFiYz2MNnXs6/n02xPGSCqw72+1mqHW
         Rb076LJugmA77U9HkTKk/bcTKy5/8Uu5qgGGPuoX9sRUhnw9ZrdOgxyVzwTE+hGH9zP4
         IdQQ6VQjCD2Puri0U0bUMF/6uutiNc61es0utwvpZcAq4Kl6Q441pMzu6qNtSybHzUst
         1w0K6UkicL0PXviDWtBGpoy/e4Uw1rdeK3srXb0MHHLlqGF/Gud8Txmvj/3o2F7poyfz
         La/w==
X-Gm-Message-State: AOAM5322rxHlYUZspO5VXPkOJeNHhaKA/Ty1afRhKfH+PmoVeOStE6xX
        1FUTWPjGN7CLhs9TUVQfsBGTIQ==
X-Google-Smtp-Source: ABdhPJzyiWXnbPWAnIVh5m8XQyYNIG3Wghkom35f6C3up/cDmURrL5N/1/DpnQ2fW4UcyeX7OG2/IQ==
X-Received: by 2002:a1c:81c8:: with SMTP id c191mr3123266wmd.23.1594886415588;
        Thu, 16 Jul 2020 01:00:15 -0700 (PDT)
Received: from dell ([2.31.163.61])
        by smtp.gmail.com with ESMTPSA id k11sm8160742wrd.23.2020.07.16.01.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 01:00:15 -0700 (PDT)
Date:   Thu, 16 Jul 2020 09:00:13 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/24] Set 3: Fix another set of SCSI related W=1
 warnings
Message-ID: <20200716080013.GO3165313@dell>
References: <20200713080001.128044-1-lee.jones@linaro.org>
 <159484884355.21107.3732344826044180939.b4-ty@oracle.com>
 <20200716071629.GL3165313@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200716071629.GL3165313@dell>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 16 Jul 2020, Lee Jones wrote:

> On Wed, 15 Jul 2020, Martin K. Petersen wrote:
> 
> > On Mon, 13 Jul 2020 08:59:37 +0100, Lee Jones wrote:
> > 
> > > This set is part of a larger effort attempting to clean-up W=1
> > > kernel builds, which are currently overwhelmingly riddled with
> > > niggly little warnings.
> > > 
> > > Slowly working through the SCSI related ones.  There are many.
> > > 
> > > This brings the total of W=1 SCSI wanings from 1690 in v5.8-rc1 to 1109.
> > > 
> > > [...]
> > 
> > [01/24] scsi: aacraid: Repair two kerneldoc headers
> >         https://git.kernel.org/mkp/scsi/c/b115958d91f5
> > [02/24] scsi: aacraid: Fix a few kerneldoc issues
> >         https://git.kernel.org/mkp/scsi/c/cf93fffac261
> > [03/24] scsi: aacraid: Fix logical bug when !DBG
> >         https://git.kernel.org/mkp/scsi/c/2fee77e5b820
> > [04/24] scsi: aacraid: Remove unused variable 'status'
> >         https://git.kernel.org/mkp/scsi/c/0123c7c62d6c
> > [05/24] scsi: aacraid: Demote partially documented function header
> >         https://git.kernel.org/mkp/scsi/c/71aa4d3e0e78
> > [06/24] scsi: aic94xx: Document 'lseq' and repair asd_update_port_links() header
> >         https://git.kernel.org/mkp/scsi/c/966fdadf6fea
> > [07/24] scsi: aacraid: Fix a bunch of function header issues
> >         https://git.kernel.org/mkp/scsi/c/f1134f0eb184
> > [08/24] scsi: aic94xx: Fix a couple of formatting and bitrot issues
> >         https://git.kernel.org/mkp/scsi/c/d2e510505006
> > [09/24] scsi: aacraid: Fill in the very parameter descriptions for rx_sync_cmd()
> >         https://git.kernel.org/mkp/scsi/c/ae272a95133a
> > [10/24] scsi: pm8001: Provide descriptions for the many undocumented 'attr's
> >         https://git.kernel.org/mkp/scsi/c/e1c3e0f8a2ae
> > [11/24] scsi: ipr: Fix a mountain of kerneldoc misdemeanours
> >         https://git.kernel.org/mkp/scsi/c/a96099e2c164
> > [12/24] scsi: virtio_scsi: Demote seemingly unintentional kerneldoc header
> >         https://git.kernel.org/mkp/scsi/c/e31f2661ff41
> > [13/24] scsi: ipr: Remove a bunch of set but checked variables
> >         https://git.kernel.org/mkp/scsi/c/4dc833999e37
> > [14/24] scsi: ipr: Fix struct packed-not-aligned issues
> >         https://git.kernel.org/mkp/scsi/c/f3bdc59f9b11
> > [15/24] scsi: myrs: Demote obvious misuse of kerneldoc to standard comment blocks
> >         https://git.kernel.org/mkp/scsi/c/8a692fdb1d04
> 
> Something wrong with [16/24]?

I see that you reviewed v1.  No need to respond, thanks.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
