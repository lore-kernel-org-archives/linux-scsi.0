Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A94C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 21:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1241464F84
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 21:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241346AbhCDVon (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 16:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241198AbhCDVo2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 16:44:28 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B1DC061756
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 13:43:48 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id e45so28779962ote.9
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 13:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q7tBXV4lZRcDzR1WeLqLPxHv84GSFkk+SyKZ277C1YA=;
        b=BBwDnQyKyqeYcC+rrb3errHEavPdPrQzuH20BcbkwwSkN4sOmjPaHs3qZkHfw3LPxf
         AXPK4CFmZ17nm3gnZoT2Brknojh08y/pQegZL+u4+6Cmz3jRrAkZQwCEfq/THW2YxdtB
         D1JWY8tKCCWgDZsRdnWTJmWGyMCdbLNa6XsceoabVl1IrwZku+HFIV8lnJ9b2gtExOat
         2wQweKIDkUDK7iiTX02F1M8X/ggX0ur2426JxvUK82PsmLZRENvpvb35XC5p9FV5cPhU
         85ROecKQqDuatcFd0RbMUbPspXl0d1zSKXOId8XTESy039ZfA32fP5fbWSzXPc60ry1k
         g8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q7tBXV4lZRcDzR1WeLqLPxHv84GSFkk+SyKZ277C1YA=;
        b=E2YBTeU7cT5fPKu/fo+CjKmA7pNuQek1H3PMxc6CVd9NMwEjnYD7imMGuUIMIq3k96
         JB3B03c+3dqPq2bSeOxpIaYT9oBpRbnbHS9MknXhRK9Enm1vtnmd0xT9/JBJ5yaVL+oJ
         i2ZtgNzHJqfQh9CdM8B9Dw1VAKTz20fH8OuurYvXl0ppwvdZ3wqlUS/zqM3PmfVFsW8H
         61cfmPVqDRxA8WdSpBuf6HpGPUkd69aPVmLzlS9dZUkK8C0svIb5CJC3rUdPdJ/GeIHr
         eoZyJZzj5Fiyn++0DpwZEKnJ/beFoxVa316grJcPtGsmmYZuvUVRLZqqNz9j2upYyUp+
         bpeQ==
X-Gm-Message-State: AOAM533UaIL6rzowIOlJqjApUqCjcpychyCbIfjgiv6fNLIThtMwGS1V
        A1/s0nTlG/xngE05pjk7JcV39h21LqJr/gOo7fQ=
X-Google-Smtp-Source: ABdhPJy4VH9hTVyRKwcTVnfoTCpeZU1NhCuy3a0Xs9hBMHD5RUVuGcDc9VrE5aEbF00ZzxYZhVADVg==
X-Received: by 2002:a9d:7481:: with SMTP id t1mr5180625otk.208.1614894228086;
        Thu, 04 Mar 2021 13:43:48 -0800 (PST)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com. [209.85.167.169])
        by smtp.gmail.com with ESMTPSA id b21sm119052oot.34.2021.03.04.13.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 13:43:47 -0800 (PST)
Received: by mail-oi1-f169.google.com with SMTP id w65so86996oie.7;
        Thu, 04 Mar 2021 13:43:47 -0800 (PST)
X-Received: by 2002:aca:5e85:: with SMTP id s127mr4293199oib.67.1614894226912;
 Thu, 04 Mar 2021 13:43:46 -0800 (PST)
MIME-Version: 1.0
References: <20210303135500.24673-1-alex.bennee@linaro.org>
 <20210303135500.24673-3-alex.bennee@linaro.org> <ff78164cc13b4855911116c2d48929a2@intel.com>
 <87eegvgr0w.fsf@linaro.org> <590e0157d6c44d55aa166ccad6355db5@intel.com>
 <87wnumg5oe.fsf@linaro.org> <baa46857daba4bb685491ea9323fe45f@intel.com>
In-Reply-To: <baa46857daba4bb685491ea9323fe45f@intel.com>
From:   Arnd Bergmann <arnd@linaro.org>
Date:   Thu, 4 Mar 2021 22:43:30 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0ATHxzS02_5kypbGwHYLaWZmEPG8xtZchWuuM-93o8CA@mail.gmail.com>
Message-ID: <CAK8P3a0ATHxzS02_5kypbGwHYLaWZmEPG8xtZchWuuM-93o8CA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] char: rpmb: provide a user space interface
To:     "Winkler, Tomas" <tomas.winkler@intel.com>
Cc:     =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxim.uvarov@linaro.org" <maxim.uvarov@linaro.org>,
        "joakim.bech@linaro.org" <joakim.bech@linaro.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "ruchika.gupta@linaro.org" <ruchika.gupta@linaro.org>,
        "Huang, Yang" <yang.huang@intel.com>,
        "Zhu, Bing" <bing.zhu@intel.com>,
        "Matti.Moell@opensynergy.com" <Matti.Moell@opensynergy.com>,
        "hmo@opensynergy.com" <hmo@opensynergy.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>,
        Avri Altman <avri.altman@sandisk.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 4, 2021 at 8:54 PM Winkler, Tomas <tomas.winkler@intel.com> wrote:
> > Winkler, Tomas <tomas.winkler@intel.com> writes:
> > >> "Winkler, Tomas" <tomas.winkler@intel.com> writes:
> > >>
> > >> >> The user space API is achieved via a number of synchronous IOCTLs.
> > >> >>
> > >> >>   * RPMB_IOC_VER_CMD - simple versioning API
> > >> >>   * RPMB_IOC_CAP_CMD - query of underlying capabilities
> > >> >>   * RPMB_IOC_PKEY_CMD - one time programming of access key
> > >> >>   * RPMB_IOC_COUNTER_CMD - query the write counter
> > >> >>   * RPMB_IOC_WBLOCKS_CMD - write blocks to device
> > >> >>   * RPMB_IOC_RBLOCKS_CMD - read blocks from device
> > >> >>
> > >> >> The keys used for programming and writing blocks to the device are
> > >> >> key_serial_t handles as provided by the keyctl() interface.
> > >> >>
> > >> >> [AJB: here there are two key differences between this and the
> > >> >> original proposal. The first is the dropping of the sequence of
> > >> >> preformated frames in favour of explicit actions. The second is
> > >> >> the introduction of key_serial_t and the keyring API for
> > >> >> referencing the key to use]
> > >> >
> > >> > Putting it gently I'm not sure this is good idea, from the security
> > >> > point of
> > >> view.
> > >> > The key has to be possession of the one that signs the frames as
> > >> > they are,
> > >> it doesn't mean it is linux kernel keyring, it can be other party on
> > >> different system.
> > >> > With this approach you will make the other usecases not applicable.
> > >> > It is less then trivial to move key securely from one system to another.
> > >>
> > >> OK I can understand the desire for such a use-case but it does
> > >> constrain the interface on the kernel with access to the hardware to
> > >> purely providing a pipe to the raw hardware while also having to
> > >> expose the details of the HW to userspace.
> > > This is the use case in Android. The key is in the "trusty" which
> > > different os running in a virtual environment. The file storage
> > > abstraction is implemented there. I'm not sure the point of
> > > constraining the kernel, can you please elaborate on that.
> >
> > Well the kernel is all about abstracting differences not baking in assumptions.
> > However can I ask a bit more about this security model?
> > Is the secure enclave just a separate userspace process or is it in a separate
> > virtual machine? Is it accessible at all by the kernel running the driver?
>
> It's not an assumption this is working for few years already (https://source.android.com/security/trusty#application_services)
> The model is that you have a trusted environment (TEE)  in which can be in any of the form you described above.
> And there is established agreement via the RPMB key that TEE is only entity that can produce content to be stored on RPBM,
> The RPMB hardware also ensure that nobody can catch it in the middle and replay that storage event.
>
> My point is that interface you are suggesting is not covering all possible usages of RPMB, actually usages that are already in place.

It turned out that the application that we (Linaro) need does have the
same requirements and needs to store the key in a TEE, transferring
the message with the MAC into the kernel, rather than keeping the
key stored in user space or kernel.

However, after I had a look at the nvme-rpmb user space implementation,
I found that this is different, and always expects the key to be stored
in a local file:
https://github.com/linux-nvme/nvme-cli/blob/master/nvme-rpmb.c#L878

This both works with the same kernel interface though, as the kernel
would still get the data along with the HMAC, rather than having the key
stored in the kernel, but it does mean that the frame gets passed to
the kernel in a device specific layout, with at least nvme using an incompatible
layout from everything else.

        Arnd
