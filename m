Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4E2C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 18:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BC1264EFE
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 18:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhCDSBs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 13:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbhCDSBX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 13:01:23 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2EEC061760
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 10:00:36 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id 7so28680155wrz.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 10:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=8R7Ifb0lG6B9vvUmi1oPee7NhyKlrhTZle2Mf9WBYdQ=;
        b=xsl1yZ6gGZXAoEu02jhqZeM0rHDiFWFH/3g3Kq+bb5AL3RAImOHMR2VPDce9buhUs5
         wgXVWxcIDm9seZmzGULizGtbzfErxlddmAsquXMb40FHvDKf8fo6y7v+HGes/L8Iu2mq
         9k5QhKMJfYOo5VqfsPP//nDxQiT68+5sO9lG6aYhXIvdl3m4dihgCZOElKMozwREOaGD
         I85a/Sgq+RxIR2SAVRmMwpKXeghOUj/PyjpayUbjN4I6l47bJReBrH4pYk6cq3qygw1g
         QuqdlirqO7QM7NxQg4BEOH0ozHE5EMpcX+HEBKztSiZHe48YNFB1km4pJKkNcVApJwk1
         P8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=8R7Ifb0lG6B9vvUmi1oPee7NhyKlrhTZle2Mf9WBYdQ=;
        b=Odkkb9mif211YLrE2m8x7tCvxrm9Fcu9DLLWhd+V1UMhNrhJnl/qLDvtxI9Bm1NyZ+
         s8WCj0+JFPYgNrawdN1nRaRh3VloFUcgJ0pDp8ralIxsayTN+EOTb43mnRsWOc4ZTx+4
         l719yNjGZ6JlcC7LZVmrEioa58LV59GV0W4jciQP3xxoF8ylTPQqIYHsu9uuWUmdd2pz
         swDCtl4d4OUazyacp8xg1jzpSX0sUh/RNq1/11H9G9Ey8NKdpFmuEjSWEDq+C+9y5Wxa
         5z/fJUzuPtvyvPXRoTFkK+9vgi/01fFETqoHW87zeqheRUanNyV8EMnLTkABRJHmnA+P
         frsw==
X-Gm-Message-State: AOAM533Ei+g8F83IgdUrhGzMtDzYvS5d6IudBz+VrceuS+AsoCCO43db
        4A0nw//FM8Iz7pimODCDk7BuwQ==
X-Google-Smtp-Source: ABdhPJzhkm+tkyOCMF8OnkU0x7xGFO/OwotnOJ7F3gwaZPtm3sEslFvYxW4NxGROAFsxgOn4fhDKgA==
X-Received: by 2002:adf:dd4f:: with SMTP id u15mr5426860wrm.260.1614880835435;
        Thu, 04 Mar 2021 10:00:35 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id o20sm322634wmq.5.2021.03.04.10.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:00:34 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9CC271FF7E;
        Thu,  4 Mar 2021 18:00:33 +0000 (GMT)
References: <20210303135500.24673-1-alex.bennee@linaro.org>
 <20210303135500.24673-3-alex.bennee@linaro.org>
 <ff78164cc13b4855911116c2d48929a2@intel.com> <87eegvgr0w.fsf@linaro.org>
 <590e0157d6c44d55aa166ccad6355db5@intel.com>
User-agent: mu4e 1.5.8; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     "Winkler, Tomas" <tomas.winkler@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxim.uvarov@linaro.org" <maxim.uvarov@linaro.org>,
        "joakim.bech@linaro.org" <joakim.bech@linaro.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "arnd@linaro.org" <arnd@linaro.org>,
        "ruchika.gupta@linaro.org" <ruchika.gupta@linaro.org>,
        "Huang, Yang" <yang.huang@intel.com>,
        "Zhu, Bing" <bing.zhu@intel.com>,
        "Matti.Moell@opensynergy.com" <Matti.Moell@opensynergy.com>,
        "hmo@opensynergy.com" <hmo@opensynergy.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>,
        Avri Altman <avri.altman@sandisk.com>
Subject: Re: [RFC PATCH  2/5] char: rpmb: provide a user space interface
Date:   Thu, 04 Mar 2021 17:52:01 +0000
In-reply-to: <590e0157d6c44d55aa166ccad6355db5@intel.com>
Message-ID: <87wnumg5oe.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Winkler, Tomas <tomas.winkler@intel.com> writes:

>> "Winkler, Tomas" <tomas.winkler@intel.com> writes:
>>=20
>> >> The user space API is achieved via a number of synchronous IOCTLs.
>> >>
>> >>   * RPMB_IOC_VER_CMD - simple versioning API
>> >>   * RPMB_IOC_CAP_CMD - query of underlying capabilities
>> >>   * RPMB_IOC_PKEY_CMD - one time programming of access key
>> >>   * RPMB_IOC_COUNTER_CMD - query the write counter
>> >>   * RPMB_IOC_WBLOCKS_CMD - write blocks to device
>> >>   * RPMB_IOC_RBLOCKS_CMD - read blocks from device
>> >>
>> >> The keys used for programming and writing blocks to the device are
>> >> key_serial_t handles as provided by the keyctl() interface.
>> >>
>> >> [AJB: here there are two key differences between this and the
>> >> original proposal. The first is the dropping of the sequence of
>> >> preformated frames in favour of explicit actions. The second is the
>> >> introduction of key_serial_t and the keyring API for referencing the
>> >> key to use]
>> >
>> > Putting it gently I'm not sure this is good idea, from the security po=
int of
>> view.
>> > The key has to be possession of the one that signs the frames as they =
are,
>> it doesn't mean it is linux kernel keyring, it can be other party on dif=
ferent
>> system.
>> > With this approach you will make the other usecases not applicable. It
>> > is less then trivial to move key securely from one system to another.
>>=20
>> OK I can understand the desire for such a use-case but it does constrain=
 the
>> interface on the kernel with access to the hardware to purely providing a
>> pipe to the raw hardware while also having to expose the details of the =
HW
>> to userspace.=20
> This is the use case in Android. The key is in the "trusty" which
> different os running in a virtual environment. The file storage
> abstraction is implemented there. I'm not sure the point of
> constraining the kernel, can you please elaborate on that.

Well the kernel is all about abstracting differences not baking in
assumptions. However can I ask a bit more about this security model?

Is the secure enclave just a separate userspace process or is it in a
separate virtual machine? Is it accessible at all by the kernel running
the driver?

The fact that key id is passed down into the kernel doesn't have to
imply the kernel does the final cryptographic operation. In the ARM
world you could make a call to the secure world to do the operation for
you. I note the keyctl() interface already has support for going to
userspace to make queries of the keyring. Maybe what is really needed is
an abstraction for the kernel to delegate the MAC calculation to some other
trusted process that also understands the keyid.

>
> Also doesn't this break down after a PROGRAM_KEY event as
>> the key will have had to traverse into the "untrusted" kernel?
>
> This is one in a life event of the card happening on the manufacturing
> floor, maybe even not performed on Linux.

In an off list conversation it was suggested that maybe the PROGRAM_KEY
ioctl should be disabled for locked down kernels to dissuade production
use of the facility (it is handy for testing though!).

>> I wonder if virtio-rpmb may be of help here? You could wrap up up the fr=
ont-
>> end in the security domain that has the keys although I don't know how e=
asy
>> it would be for a backend to work with real hardware?
>
> I'm open to see any proposal, not sure I can wrap may head about it right=
 now.=20
>
> Anyway I was about to send the new round of my code,  but let's come to c=
ommon ground first.=20
>

OK - I'll see what the others say.

--=20
Alex Benn=C3=A9e
