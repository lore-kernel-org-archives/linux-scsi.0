Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BD9C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 13:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2BCD61374
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 13:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhJRN3C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 09:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231814AbhJRN1B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 09:27:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A11C60EFE;
        Mon, 18 Oct 2021 13:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634563490;
        bh=Wrg1gLaNSkOVsbaHPa86t0+1ZCN45SC1LSyRyh0i74U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dV8KTEDh7BcIR0Kl17EbZu09NWj7MKmJPw9xQaxi57C14YUbnO+p+khtj6aDgUbMo
         0v8qbcKBoGXJtRFQxAWqGZnAfztfLhsvnphvT32wtoqm37pVoWAUYqZSUxSvKmwKEu
         r7A85x6fWT1YqKTiMAaJ1Zno9ooc97cud8ty4GyfWrNpjM6+abswBV3aMqLVzccJba
         iy7WUw6gkFRgsG7OfBoir89POwWTCd+5RT3q53l1E5BFLvgv3RkYb9iI6Wbj/Bm7qD
         6CfjdqfoaA5gPRZTkKR1L/9jVP9z/U1DxvU0w+ekKZUqG0QRh7QzbMPnFs3FnZJFt4
         /2KKmyQrBDJuw==
Received: by mail-ed1-f45.google.com with SMTP id a25so71209913edx.8;
        Mon, 18 Oct 2021 06:24:50 -0700 (PDT)
X-Gm-Message-State: AOAM532PI68+qW2OZNTdb5ac67gaPljtXoSX+QH5kpAaHG1NSfCA8aEL
        hv5n9CaTQOUft+0KJB2UxK0xW1hHEkfcWwp3sw==
X-Google-Smtp-Source: ABdhPJwJp66/mbeoS946PTfEodPH9WSktJ7q0aZ4rB1sYJUsau+I+zXONWG+AiPIJksRWj2sksZo3XrPPghjAb6gHxI=
X-Received: by 2002:a50:da06:: with SMTP id z6mr45662114edj.355.1634563424098;
 Mon, 18 Oct 2021 06:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <20211007080934.108804-1-chanho61.park@samsung.com>
 <CGME20211007081135epcas2p2d577fc8dec75471cf42024eda6a45690@epcas2p2.samsung.com>
 <20211007080934.108804-14-chanho61.park@samsung.com> <YWmHQ5CVQd97JzHJ@robh.at.kernel.org>
 <003d01d7c3b6$dccac760$96605620$@samsung.com>
In-Reply-To: <003d01d7c3b6$dccac760$96605620$@samsung.com>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 18 Oct 2021 08:23:31 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKkA3i=-uyEz81tscRSNa5-RisYa_b_VaJmOurkPz+f=g@mail.gmail.com>
Message-ID: <CAL_JsqKkA3i=-uyEz81tscRSNa5-RisYa_b_VaJmOurkPz+f=g@mail.gmail.com>
Subject: Re: [PATCH v4 13/16] dt-bindings: ufs: exynos-ufs: add io-coherency property
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        SCSI <linux-scsi@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Oct 17, 2021 at 7:27 PM Chanho Park <chanho61.park@samsung.com> wrote:
>
> > > +  samsung,sysreg:
> > > +    $ref: '/schemas/types.yaml#/definitions/phandle'
> > > +    description: phandle for FSYSx sysreg interface, used to control
> > > +                 sysreg register bit for UFS IO Coherency
> > > +
> > > +  samsung,ufs-shareability-reg-offset:
> > > +    $ref: '/schemas/types.yaml#/definitions/uint32'
> > > +    description: Offset to the shareability register for io-coherency
> >
> > Make these a single property: <phandle offset>
>
> As I already mentioned previous e-mail [1], I need to support two ufs
> instances for exynosauto v9 soc.

Don't expect me to remember. That was 100s of reviews ago.

>
> syscon_fsys2: syscon@17c20000 {
>         compatible = "samsung,exynosautov9-sysreg", "syscon";
>         reg = <0x17c20000 0x1000>;
> };
>
> ufs_0: ufs0@17e00000 {
>         <snip>
>         samsung,sysreg = <&syscon_fsys2>;
>         samsung,ufs-shareability-reg-offset = <0x710>;

samsung,ufs-shareability-reg = <&syscon_fsys2 0x710>;

> };
>
> To be added ufs_1 like below
> ufs_1: ufs0@17f00000 {
>         <snip>
>         samsung,sysreg = <&syscon_fsys2>;
>         samsung,ufs-shareability-reg-offset = <0x714>;

samsung,ufs-shareability-reg = <&syscon_fsys2 0x714>;

I still don't see what's the problem?

> };
>
> [1]:
> https://lore.kernel.org/linux-scsi/000901d7b0e0$e618b220$b24a1660$@samsung.c
> om/
>
> If you prefer them to be separated sysreg phandles which directly pointing
> the register, I'm able to change it.
> But, the syscon_fsys2 can be used for other IPs as well such as ethernet.
>
> Best Regards,
> Chanho Park
>
