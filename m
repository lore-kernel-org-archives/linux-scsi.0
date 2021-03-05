Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29451C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 07:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E264D65004
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 07:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhCEHvh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 02:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhCEHvh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 02:51:37 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF80C061574
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 23:51:35 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id dx17so1642567ejb.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 23:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=cKVGTa6ju/LsREjFD7gnw/RP1YjlyJ1xmIXcDe5uO2Q=;
        b=Zh06eYHcY8hTJFgnQm43ngFpY1VdFU7XH/rX9h9CDzvHCJDt78jMLLhoB4pYSKr35m
         OpJKt6P+BL+8/Iz+9LeT4jx8oYAi8tdd0u5jDQFswMWxsob7Ko1AkxoYsdcCH4XdNAKu
         ujcTLn0DF/oTurrWkf52u0TFGu2nZia+eqTZNpp3FB/uZpjq4fpA8gi9BRdXM7v7N1A5
         rrADZKzB7t3bb3bxFnE1kOIuBCZ2Vn61Pp4hDI44+/qDl/weOCkQVskqugNDR+7REKBW
         M1fggiwWZAatHscXciMBsjt6C53L2tLZMIgUgfJvQQWJ2CELTGmvswHaEopVfTo2wXFY
         7FXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=cKVGTa6ju/LsREjFD7gnw/RP1YjlyJ1xmIXcDe5uO2Q=;
        b=H4MCHsf3sJ75vd1+RFPdtHhFK7dHQI/QGpn+XCFELykpiYD3FoRR73wcShoOZYxToT
         tp33DYmhAdeSMKBFdvolZ5cpvjQ9HgCvQb6uCm+T2k/ANi0beJbbAfkv40YLRYraW//R
         3WIKc/PacrFBGI/wyLjI0F2Lk8ckRTsLRzcFjD2DUstCVJGBIRGexn5L2ZBVFBkmElzn
         Tj4KURpni0ImV8WDmqWVnmnKPJuQHKlw4wYQCjSiO8ry+XH5b9eH4iKD6+8eBTFSTXa5
         N1lnxLuU3YUnC48F5u9aTda2eKvYwkbm8YRlyMOCsuGgrt9Yv+9RigpZb2q0CcZsW/Mg
         FLoA==
X-Gm-Message-State: AOAM533Bgd8e0flVp0VqYmcRVDAcKRCGp+ZuKMfOBUhQHDTOcUSmPphU
        Qy/n9350nYEwbziKBvfGIMhqQQ==
X-Google-Smtp-Source: ABdhPJzJyKW6gvVHpeMLZSWCIv+GoQQYb17WsbWJkkvmT+3hnDQcSK0OW77fFBTCRV0flB0vEY8CPA==
X-Received: by 2002:a17:906:7e12:: with SMTP id e18mr1273626ejr.316.1614930694041;
        Thu, 04 Mar 2021 23:51:34 -0800 (PST)
Received: from goby (81-231-61-187-no276.tbcn.telia.com. [81.231.61.187])
        by smtp.gmail.com with ESMTPSA id de17sm1031396ejc.16.2021.03.04.23.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 23:51:33 -0800 (PST)
Date:   Fri, 5 Mar 2021 08:51:31 +0100
From:   Joakim Bech <joakim.bech@linaro.org>
To:     Arnd Bergmann <arnd@linaro.org>
Cc:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxim Uvarov <maxim.uvarov@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        ruchika.gupta@linaro.org,
        "Winkler, Tomas" <tomas.winkler@intel.com>, yang.huang@intel.com,
        bing.zhu@intel.com, Matti.Moell@opensynergy.com,
        hmo@opensynergy.com, linux-mmc <linux-mmc@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nvme@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC PATCH 1/5] rpmb: add Replay Protected Memory Block (RPMB)
 subsystem
Message-ID: <20210305075131.GA15940@goby>
References: <20210303135500.24673-1-alex.bennee@linaro.org>
 <20210303135500.24673-2-alex.bennee@linaro.org>
 <CAK8P3a0W5X8Mvq0tDrz7d67SfQA=PqthpnGDhn8w1Xhwa030-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK8P3a0W5X8Mvq0tDrz7d67SfQA=PqthpnGDhn8w1Xhwa030-A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 04, 2021 at 09:56:24PM +0100, Arnd Bergmann wrote:
> On Wed, Mar 3, 2021 at 2:54 PM Alex Bennée <alex.bennee@linaro.org> wrote:
> >
> > A number of storage technologies support a specialised hardware
> > partition designed to be resistant to replay attacks. The underlying
> > HW protocols differ but the operations are common. The RPMB partition
> > cannot be accessed via standard block layer, but by a set of specific
> > commands: WRITE, READ, GET_WRITE_COUNTER, and PROGRAM_KEY. Such a
> > partition provides authenticated and replay protected access, hence
> > suitable as a secure storage.
> >
> > The RPMB layer aims to provide in-kernel API for Trusted Execution
> > Environment (TEE) devices that are capable to securely compute block
> > frame signature. In case a TEE device wishes to store a replay
> > protected data, requests the storage device via RPMB layer to store
> > the data.
> >
> > A TEE device driver can claim the RPMB interface, for example, via
> > class_interface_register(). The RPMB layer provides a series of
> > operations for interacting with the device.
> >
> >   * program_key - a one time operation for setting up a new device
> >   * get_capacity - introspect the device capacity
> >   * get_write_count - check the write counter
> >   * write_blocks - write a series of blocks to the RPMB device
> >   * read_blocks - read a series of blocks from the RPMB device
> 
> Based on the discussion we had today in a meeting, it seems the
> main change that is needed is to get back to the original model
> of passing the encrypted data to the kernel instead of cleartext
> data, as the main use case we know of is to have the key inside of
> the TEE device and not available to the kernel or user space.
> 
Yes, for OP-TEE we have to encrypt all data going to RPMB, since the
information goes via non-secure world. We get the integrity by applying
the HMAC with the key that is being discussed in this thread. The TEE
owns and is responsible for programming the key (and that should be
something that is achieved as part of the manufacturing process).

> This is also required to be able to forward the encrypted data
> through the same interface on a KVM host, when the guest
> uses virtio-rpmb, and the host forwards the data into an mmc or
> ufs device.
> 
> That said, I can also imagine use cases where we do want to
> store the key in the kernel's keyring, so maybe we end up needing
> both.
> 
The concern I have in those cases is that you need to share the RPMB key
in some way if you need to access the RPMB device from secure side as
well as from the non-secure side. Technically doable I guess, but in
practice and in terms of security it doesn't seem like a good approach.

In a shared environment like that you also have the problem that you
need to agree on how to actually store files on the RPMB device. OP-TEE
has it's own "FAT-look-a-like" implementation when using RPMB. But if
you need mutual access, then you need to get into agreement on where to
actually store the files in the RPMB.

However, if secure side for some reason doesn't use RPMB at all, then
kernel could of course take control of it and use it.

I would probably not spend too much time on taking that use case into
account until we actually see a real need for it.

> > The detailed operation of implementing the access is left to the TEE
> > device driver itself.
> >
> > [This is based-on Thomas Winkler's proposed API from:
> >
> >   https://lore.kernel.org/linux-mmc/1478548394-8184-2-git-send-email-tomas.winkler@intel.com/
> >
> > The principle difference is the framing details and HW specific
> > bits (JDEC vs NVME frames) are left to the lower level TEE driver to
> > worry about. The eventual userspace ioctl interface will aim to be
> > similarly generic. This is an RFC to follow up on:
> >
> >   Subject: RPMB user space ABI
> >   Date: Thu, 11 Feb 2021 14:07:00 +0000
> >   Message-ID: <87mtwashi4.fsf@linaro.org>]
> >
> > Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> > Cc: Tomas Winkler <tomas.winkler@intel.com>
> > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > Cc: Linus  Walleij <linus.walleij@linaro.org>
> > Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> > Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > ---
> >  MAINTAINERS                |   7 +
> >  drivers/char/Kconfig       |   2 +
> >  drivers/char/Makefile      |   1 +
> >  drivers/char/rpmb/Kconfig  |  11 +
> >  drivers/char/rpmb/Makefile |   7 +
> >  drivers/char/rpmb/core.c   | 429 +++++++++++++++++++++++++++++++++++++
> >  include/linux/rpmb.h       | 163 ++++++++++++++
> 
> 
> My feeling is that it should be a top-level subsystem, in drivers/rpmb
> rather than drivers/char/rpmb, as you implement an abstraction layer
> that other drivers can plug into, rather than a simple driver.
> 
>        Arnd

-- 
Regards,
Joakim
