Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F421C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 06:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFFE061A1B
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 06:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhCYGEV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhCYGEU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 02:04:20 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02770C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 23:04:20 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ce10so988050ejb.6
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 23:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xc4qm/kccB64ZL/Z9kIVPCd5F8VTe+9UeOHA57uzuDo=;
        b=Xepk9gpeltv5ao4YB7k933Z2na67+ORzQZsGHe1dOWWR5SdL6hQ/B5dPEXqYB1LTL1
         DHY0HDlJLo8pAML95Fya3K/PMaH9MrjqmlWk9LDkwXZeNmboxJEsaQaugBbKlP/OSjcL
         OqM4JogopG0DFkhbznUeW6uOrfaEFJJx7iCOt8qrX9SDYlK+8IjyX2fkpapDtdlnNyN6
         mHX6409+8FL+QAkklr0xN2dStv/SFBwznywoBVLqTBEyVKb2pIgMBVYv/w9l4/ICNDbw
         Gudgoz3OaPMf4Q15PHLlgCXw+MFG8V1b0K5/Zkh0mesmRrHHd2LaHBZszrVcrsZ2wfEg
         rl6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xc4qm/kccB64ZL/Z9kIVPCd5F8VTe+9UeOHA57uzuDo=;
        b=HsfM9XGvJDDDTradEBsN2irk1gq3sqrN27Zd2mIltfXIU0N4/SNeTbZlfF87p9k6o/
         zUYg13gDorq0POsN2lWKtZp7s3WRN+HtrvBMWNwTxYGkQKJXuCiXWFXgpSZXZNDbXxod
         6XRKi43GybIt4Doo4NvlOkSE9syeIrPqJlIUsGvycL9winO9MROsWB0HIGfESRBO5EwS
         M9kzIcaz2aX3UGfATPFT9Aw0RuklJ7KaCMy89uXcRiXy+eNM2RiNgCc7XGrnCXibAhqU
         KHPPZyAGiXQbIKOjzPl1I7Q4iRhxDTsQXltCcctxHeByMMgj2uVmfsQ7ySKYKTU/3/II
         ZAag==
X-Gm-Message-State: AOAM531XXmklYTNBdro23+yGzrpKtxJLaYste6JpfmFIm0on/RPPJ1GS
        xBMX1Kmg4rSfNfm5OS3nIGnKLzDva8zY72AtidDu6Q==
X-Google-Smtp-Source: ABdhPJwcFCFiPOaodVd0Mf4CXS6pKqTHYocbxwDcRsMzrJ0uUS66+qJFLfMK62zXPHmaQYDZlnZ3Dbk5yvJ5GvzvlG0=
X-Received: by 2002:a17:907:76a3:: with SMTP id jw3mr7663063ejc.353.1616652258729;
 Wed, 24 Mar 2021 23:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <009d01d71cb1$3fbd5200$bf37f600$@ai0.uk> <CAMGffE=B9QRncb2UO3aCfbH9naYU6-pP_c6T3PuHNRKRpnkDJA@mail.gmail.com>
 <SN6PR11MB3488473F4D3CAEEBE583AB159D689@SN6PR11MB3488.namprd11.prod.outlook.com>
 <SN6PR11MB3488B82D4D39713C6AEE270F9D639@SN6PR11MB3488.namprd11.prod.outlook.com>
 <012c01d720f7$361de9e0$a259bda0$@ai0.uk>
In-Reply-To: <012c01d720f7$361de9e0$a259bda0$@ai0.uk>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 25 Mar 2021 07:04:07 +0100
Message-ID: <CAMGffE=9AwXpoMB16jWLdtDYw+MKN3kEUWLS8v+rG3ngAdjAeA@mail.gmail.com>
Subject: Re: [REGRESSION] pm8001: Adaptec 6805H fails to initialize after v5.10.0
To:     Ash Izat <ash@ai0.uk>, Viswas G <Viswas.G@microchip.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ash, hi Viswas,
On Wed, Mar 24, 2021 at 10:46 PM Ash Izat <ash@ai0.uk> wrote:
>
> Hi Viswas,
>
> Patch applied on top of 5.12-rc4 and it is working perfectly now.
> Double checked and without the patch the issue is still present in 5.12-rc4.
>
> Thank you very much for the prompt response.
>
> Is there any chance this will be backported to longterm (5.10) once it is merged?
Thanks for testing. Viswas please submit a formal patch with
Reported-and-tested-by from Ash,
With the Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of
supported queues")
And add  Cc: stable@vger.kernel.org # 5.10+

So it will be picked up when it is accepted by mainline, LTS
maintainer will pick it up for stable 5.10+

Regards!
Jinpu
>
> > -----Original Message-----
> > From: Viswas.G@microchip.com <Viswas.G@microchip.com>
> > Sent: 24 March 2021 18:07
> > To: jinpu.wang@cloud.ionos.com; ash@ai0.uk; Ruksar.devadi@microchip.com;
> > Vasanthalakshmi.Tharmarajan@microchip.com
> > Cc: linux-scsi@vger.kernel.org
> > Subject: RE: [REGRESSION] pm8001: Adaptec 6805H fails to initialize after
> > v5.10.0
> >
> > Hi Ash,
> >
> > Can you please try this patch ?
> >
> > Regards,
> > Viswas G
>
>
