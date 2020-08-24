Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAACC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 10:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADF3020738
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 10:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WxNtDNt3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgHXKXZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 06:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgHXKXZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 06:23:25 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C610DC061573
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 03:23:24 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id b9so4343143oiy.3
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 03:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2IOojcGR9COEVxhDetFIaFroty5bft67wvgXoWgDklM=;
        b=WxNtDNt3KmHoWg+8PEAhZp4mV1Ah+HG2snG8vW4rXQWu7Iw9Vu73brlXa01rGaJOZJ
         +5E22/nkqbc8xbPYL+ysTb3CiHKZEMrTDvQhsGJpD0L9+KQMUNdurOlWH8noo8YIRDP/
         edk6ciVtTfJ7c/TV3CUxY+SkJJ618FTe71tms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2IOojcGR9COEVxhDetFIaFroty5bft67wvgXoWgDklM=;
        b=a5ZQ34Umj+NDnFzbz9Fp38SEdJRtheuUb5/gq4pKlPQ8s6yOsgrgRfHN390FyFBUY8
         5pd1pGPlK8j4zqIA549LxI5A/yVXxcSCGAbkSxvC/nW6g/SUzSvgYWzBPhHZHhyz6P5L
         Bj8OLQFxzesCqWakLc8ZTPcrc4rmulIs1AXN1lcHgemeaMIujWs7SKNJQv5X2zlzd5ur
         ZuEgfZN005okvXaB8DzbRC4HgkfTn22YOAp1Ca/78ozjQo5QSkK4modoI7UwnctU2k2e
         peMQWStV2EHv7g8zAOzgIp0/k5STS62jCmHFygP/AP/kTXgrCAwsHGW+LYLVQnFoSE+P
         jiAw==
X-Gm-Message-State: AOAM532zjZxat3CMvX5JOiFIQQQBVA6e7J/4y3IGGeQWEmFn0ek9tjK8
        9QDtnTWPMIirXFpKqjQPSSM4hBhyaLKZW4b1jTpJIw==
X-Google-Smtp-Source: ABdhPJzkpI4vQv1xjEV/oo8g07aVkl7dyZ5OFR2M1/v0x6bPQnmHfh5jqON1/xA2pe6eKTxSoyLui1ohDLXp3RQAQ2c=
X-Received: by 2002:a05:6808:30f:: with SMTP id i15mr2641898oie.7.1598264602686;
 Mon, 24 Aug 2020 03:23:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200814130426.2741171-1-sreekanth.reddy@broadcom.com> <yq1a6yoviti.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1a6yoviti.fsf@ca-mkp.ca.oracle.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Mon, 24 Aug 2020 15:53:10 +0530
Message-ID: <CAK=zhgq-5CNQObiwDutLPGG3CbmpAbj+RbDGX-xGu6mVP_WZYw@mail.gmail.com>
Subject: Re: [PATCH v1] mpt3sas: Add support for Non-secure Aero and Sea PCI IDs
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 21, 2020 at 7:57 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Sreekanth,
>
> > This patch will add support for Non-secure Aero & Sea adapters' PCI
> > IDs.
>
> That wording is misleading since you're effectively removing support for
> these controllers.

Actually we want the driver to claim the non-secure (i.e. invalid &
tempered) Aero & Sea devices and print the error message to the user
that he is using invalid/tempered Devices. So that user can change to
'Hard Secure'/'config secure' cards.

We will rephrase above line as below,

"This patch will claim non-secure Aero & Sea adapter's PCI IDs & quit
the device initialization (without enabling the HBA firmware) with a
Error message"

>
> > Driver will throw an warning message when a non-secure type controller
> > is detected. Purpose of this interface is to avoid interacting with
> > any firmware which is not secured/signed by Broadcom.
>
> The request was to log a warning. Why would we want to disable support
> for these devices in the driver?

Actually  the request is to log an error message but I was confused
with your previous comment and made changes to log a warning message.
As explained in description the purpose of disabling support for these
devices in the driver is to avoid interacting with any firmware which
is not secured/signed by Broadcom.

Thanks,
Sreekanth

>
> --
> Martin K. Petersen      Oracle Linux Engineering
