Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7013C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 23:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiCCXS2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 18:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiCCXSZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 18:18:25 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFAFDEB1;
        Thu,  3 Mar 2022 15:17:37 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id k7so5254279ilo.8;
        Thu, 03 Mar 2022 15:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IunjLamQyiN4ktCSVGqQoYbINqbAWtg7y28TD4hVajw=;
        b=WdEq8Z/fW+RL+Ej4Z4MFuld6ZS/v8HLUbxQGRncbLZD49oQmlx/ygy9YpL76W4YMdG
         dPTLPRcfVspo2oDtOcXWrBJGSLhVKZX4Tgv+EaQaDXxg8aILtMholWijNBkhpdkyukq9
         /nmmMX4v5JORNe4LrGEY/f6RR4w0MsbZuj2V6VmtsZHrn8npzp4URUBhvys6mnUKUBn3
         gQ5nCmY+DKZQm1yACzBkMPDp25V6e7YdkHZe/ebB9G0ktfy1tjmDfMkP9mslH4f36AOG
         SmMICNRXWvf2YisP9UZx/ntekFAJBNN0LjJqH5dNr3jwP4+i4rqCC+vU28v9Ds5TS7Ad
         /VfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IunjLamQyiN4ktCSVGqQoYbINqbAWtg7y28TD4hVajw=;
        b=D+zGdkAmEAVPf/8m0BvtPyM8jm62pSTIpfey8KsfeNYeW+3RFzdzfltiozBcUKiBvU
         sj4tSugLyjo3OFakISzonyGtOAvF3u1JZKE5SXSgAzhPeNQO0OOESxB+Q9TIig5g5rJs
         qioD4a9iGY6zyl8SFo8PlW0Oh1P/Q3F0J8o3TaOfkYInF5vXwMV3BkKjxpJoX9haPR8u
         +WbW00C5kkSLAQPQLEem3SN73MXr+eG4fW3U364wRJrDVEDvDRY5uo0SBuoBT0hS2sCd
         +ILzzAWmdobpOii4TkG/xF24kwtSjZsOtNugMJGdw5E66OWkv04Dc4Bb2E3skNg2/PeU
         v9vQ==
X-Gm-Message-State: AOAM530lpxD82Wa6c/cau0od3jA45oLH0T0NkJKAqI2zn3ecL3OtiFNE
        KywBVcYRcpBbQgJg+8+hEszx/Vz/gBvASYQV3L8=
X-Google-Smtp-Source: ABdhPJxi8VypfVGr9Khjx8L28LU1hG/qzef02DaLMAkHfbs2sOCVurtw7fWFOlTYy2xjj36m0p2movbsKHKZ2XFic4Q=
X-Received: by 2002:a92:c908:0:b0:2c1:a287:8868 with SMTP id
 t8-20020a92c908000000b002c1a2878868mr32170001ilp.321.1646349456482; Thu, 03
 Mar 2022 15:17:36 -0800 (PST)
MIME-Version: 1.0
References: <20220127151945.1244439-1-trix@redhat.com> <d26d4bd8-b5e1-f4d5-b563-9bc4dd384ff8@acm.org>
 <0adde369-3fd7-3608-594c-d199cce3c936@redhat.com> <e3ae392a16491b9ddeb1f0b2b74fdf05628b1996.camel@perches.com>
 <46441b86-1d19-5eb4-0013-db1c63a9b0a5@redhat.com> <8dd05afd-0bb9-c91b-6393-aff69f1363e1@redhat.com>
 <233660d0-1dee-7d80-1581-2e6845bf7689@linux-m68k.org> <CABRYuGk+1AGpvfkR7=LTCm+bN4kt55fwQnQXCjidSXWxuMWsiQ@mail.gmail.com>
 <95f5be1d-f5f3-478-5ccb-76556a41de78@linux-m68k.org>
In-Reply-To: <95f5be1d-f5f3-478-5ccb-76556a41de78@linux-m68k.org>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 4 Mar 2022 00:17:25 +0100
Message-ID: <CANiq72kOJh_rGg6cT+S833HYqwHnZJzZss8v+kQDcgz_cZUfBQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: megaraid: cleanup formatting of megaraid
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     Konrad Wilhelm Kleine <kkleine@redhat.com>,
        Tom Rix <trix@redhat.com>, Joe Perches <joe@perches.com>,
        Bart Van Assche <bvanassche@acm.org>,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        megaraidlinux.pdl@broadcom.com, scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 3, 2022 at 11:44 PM Finn Thain <fthain@linux-m68k.org> wrote:
>
> Others might argue that they should always be changed from,
>
> /*
>  * this style
>  * of multiline comment
>  */
>
> to
>
> /* this style
>  * of multiline comment
>  */

In general, for things that the coding style guide talks about, we
should follow them, even if some subsystems do not (they can always
override in their folder if they really, really want it). So, here for
instance, the first one should be used.

Cheers,
Miguel
