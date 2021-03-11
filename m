Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562DAC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05A7A64ECD
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCKU3m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhCKU3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:29:34 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E474C061574;
        Thu, 11 Mar 2021 12:29:33 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id B5444425BB;
        Thu, 11 Mar 2021 20:29:25 +0000 (UTC)
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Arnd Bergmann <arnd@linaro.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Joakim Bech <joakim.bech@linaro.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxim Uvarov <maxim.uvarov@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Ruchika Gupta <ruchika.gupta@linaro.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>, yang.huang@intel.com,
        bing.zhu@intel.com, Matti.Moell@opensynergy.com,
        hmo@opensynergy.com, linux-mmc <linux-mmc@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nvme@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
References: <20210303135500.24673-1-alex.bennee@linaro.org>
 <20210303135500.24673-2-alex.bennee@linaro.org>
 <CAK8P3a0W5X8Mvq0tDrz7d67SfQA=PqthpnGDhn8w1Xhwa030-A@mail.gmail.com>
 <20210305075131.GA15940@goby>
 <CAK8P3a0qtByN4Fnutr1yetdVZkPJn87yK+w+_DAUXOMif-13aA@mail.gmail.com>
 <CACRpkdb4RkQvDBgTMW_+7yYBsHNRyJZiT5bn04uQJgk7tKGDOA@mail.gmail.com>
 <6c542548-cc16-af68-c755-df52bd13b209@marcan.st>
 <CAFA6WYOYmTgguVDwpyjnt3gLssqW48qzAkRD_nyPYg0nNhxT2A@mail.gmail.com>
 <beca6bc8-8970-bd01-8de0-6ded1fb69be2@marcan.st>
 <CAFA6WYMSJxK2CjmoLJ6mdNNEfOQOMVXZPbbFRfah7KLeZNfguw@mail.gmail.com>
 <CACRpkdZb5UMyq5qSJE==3ZnH-7fh92q_t4AnE8mPm0oFEJxqpQ@mail.gmail.com>
 <e5d3f4b5-748e-0700-b897-393187b2bb1a@marcan.st>
 <CACRpkdYxMGN3N-jFt1Uw4AkBR-x=dRj6HEvDp6g+2ku7+qCLwg@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [RFC PATCH 1/5] rpmb: add Replay Protected Memory Block (RPMB)
 subsystem
Message-ID: <02d035ca-697d-1634-a434-a43b9c01f4a9@marcan.st>
Date:   Fri, 12 Mar 2021 05:29:23 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CACRpkdYxMGN3N-jFt1Uw4AkBR-x=dRj6HEvDp6g+2ku7+qCLwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: es-ES
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/03/2021 23.31, Linus Walleij wrote:
> I understand your argument, is your position such that the nature
> of the hardware is such that community should leave this hardware
> alone and not try to make use of RPMB  for say ordinary (self-installed)
> Linux distributions?

It's not really that the community should leave this hardware alone, so 
much that I think there is a very small subset of users who will be able 
to benefit from it, and that subset will be happy with a usable 
kernel/userspace interface and some userspace tooling for this purpose, 
including provisioning and such.

Consider the prerequisites for using RPMB usefully here:

* You need (user-controlled) secureboot
* You need secret key storage - so either some kind of CPU-fused key, or 
one protected by a TPM paired with the secureboot (key sealed to PCR 
values and such)
* But if you have a TPM, that can handle secure counters for you already 
AIUI, so you don't need RPMB
* So this means you must be running a non-TPM secureboot system

And so we're back to embedded platforms like Android phones and other 
SoC stuff... user-controlled secureboot is already somewhat rare here, 
and even rarer are the cases where the user controls the whole chain 
including the TEE if any (otherwise it'll be using RPMB already); this 
pretty much excludes all production Android phones except for a few 
designed as completely open systems; we're left with those and a subset 
of dev boards (e.g. the Jetson TX1 I did fuse experiments on). In the 
end, those systems will probably end up with fairly bespoke set-ups for 
any given device or SoC family, for using RPMB.

But then again, if you have a full secureboot system where you control 
the TEE level, wouldn't you want to put the RPMB shenanigans there and 
get some semblance of secure TPM/keystore/attempt throttling 
functionality that is robust against Linux exploits and has a smaller 
attack surface? Systems without EL3 are rare (Apple M1 :-)) so it makes 
more sense to do this on those that do have it. If you're paranoid 
enough to be getting into building your own secure system with 
anti-rollback for retry counters, you should be heading in that directly 
anyway.

And now Linux's RPMB code is useless because you're running the stack in 
the secure monitor instead :-)

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
