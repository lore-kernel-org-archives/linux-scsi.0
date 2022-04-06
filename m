Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06A2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 15:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbiDFPHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 11:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbiDFPGu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 11:06:50 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115B25332AB
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 05:03:37 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bg10so3805659ejb.4
        for <linux-scsi@vger.kernel.org>; Wed, 06 Apr 2022 05:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=whOdS+ZcH7sIpEntYe8CJFTcnKkZdKG28Xb/p70XMvo=;
        b=JsHKfdW83fLPaATYi8d9V3sljgvsb0oN7RRpWT6JB80/10uDk+SQamUjz4rob4ZZS0
         gpka4IkmpVK6jnRr8X2aNLtGHqzOjKiM0WQE3+Uy9zMVEejPzHP+aTUse0FLHKtxo317
         Rh4ephi89YgTP7m13Ladzc1N+VqpWWIaw76MYLR5gPZqVY4jnvJ55WcIK2D4KbzCEtNU
         +JV6+V1KVZ/izMtnIZqPqWqhJmXK7Qeo7Vc1i7RSdjLG9qqq6Uo0xHbhojxwh6mP4S2f
         8oeJHaXtzLyGDYh4waFsXrD37rwYqLPmR5fdTDK7kVDH/zVBJxSQsRx6DatNT+8FnZsU
         IozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=whOdS+ZcH7sIpEntYe8CJFTcnKkZdKG28Xb/p70XMvo=;
        b=wBf9GSKxGwgMXgDXsrxk5mKzS19sL0jR0SDwJJxyBm73sepJtjhFfr3bKfjEaHavLD
         +cGuRiWK1Fc8aWag1Wtm5EnB9CSwwgOPOVvT6E1JxfxDq3H5pxQpJ+sgBjLETCqi6LP7
         K2+ibu69FkavUZAnLEQ8J0Xid7B9oJ9LQWhD6nQmA76x4IQ4N8kEcz5wzTHo2ZWwVIIv
         z8DUX0DqDxZkVsmNgR06My51//uI7WPTQjJmMBaYZxO/3W8P3F9uht3/XymWu/e6AdE0
         JDee0WWjRRoGBpDrMRWFeBp+V6cCYLaOmVupr68UP/+C1v9RCC26O/I5h0mY5n0G83kU
         k8NQ==
X-Gm-Message-State: AOAM531NtERUJ77TcpwpZjOwvnnjEbKakPAZSV1dAk+NkrO+OrvUmGyW
        TJlcsQTYDHQyHs7b9bk9TWv80iFGzlEN7w==
X-Google-Smtp-Source: ABdhPJxWPoa96Rp6WyUCbZqG8Rc+VbSNKHl6bbF4sy2t/iT60ay3eCLeVu4In006GQNqNwkQToMQvA==
X-Received: by 2002:a05:6402:51d4:b0:410:a328:3c86 with SMTP id r20-20020a05640251d400b00410a3283c86mr8318099edd.55.1649246062857;
        Wed, 06 Apr 2022 04:54:22 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id j8-20020aa7c0c8000000b0041934547989sm7922351edp.55.2022.04.06.04.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 04:54:21 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 179711FFB7;
        Wed,  6 Apr 2022 12:54:21 +0100 (BST)
References: <20220405093759.1126835-1-alex.bennee@linaro.org>
 <8b3ce88f65fd11523a4d2daab3c617f7089eb1ce.camel@gmail.com>
 <87r16bk013.fsf@linaro.org>
 <aeb64d1c4bbddfd8463c07a40ab1fc78be0d158d.camel@gmail.com>
User-agent: mu4e 1.7.12; emacs 28.1.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     linux-kernel@vger.kernel.org, maxim.uvarov@linaro.org,
        joakim.bech@linaro.org, ulf.hansson@linaro.org,
        ilias.apalodimas@linaro.org, arnd@linaro.org,
        ruchika.gupta@linaro.org, tomas.winkler@intel.com,
        yang.huang@intel.com, bing.zhu@intel.com,
        Matti.Moell@opensynergy.com, hmo@opensynergy.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH  v2 0/4] rpmb subsystem, uapi and virtio-rpmb driver
Date:   Wed, 06 Apr 2022 12:22:00 +0100
In-reply-to: <aeb64d1c4bbddfd8463c07a40ab1fc78be0d158d.camel@gmail.com>
Message-ID: <87ee2ajuky.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean Huo <huobean@gmail.com> writes:

> On Tue, 2022-04-05 at 16:43 +0100, Alex Benn=C3=A9e wrote:
>>=20
>> Bean Huo <huobean@gmail.com> writes:
>>=20
>> > Hi Alex,
>> >=20
>> > Thanks for this unified RPMB interface, I wanted to verify this on
>> > our
>> > UFS, it seems you didn't add the UFS access interface in this
>> > version=20
>> > from your userspace tools, right?
>>=20
>> No I didn't but it should be easy enough to add some function pointer
>> redirection everywhere one of the op_* functions calls a vrpmb_*
>> function. Do you already have a UFS RPMB device driver?
>>=20
>
> Hi Alex,
> Thanks for your feedback.
>
> We now access UFS RPMB through the RPMB LUN BSG device, RPMB is a well-
> known LU and we have a userspace tool to access it.
>
> I see that if we're going to use your interface, "static struct
> rpmb_ops" should be registered from a lower-level driver, for example
> in a UFS driver, yes there should be no problem with this registration,
> but I don't know with the current way Compared, what are the advantages
> to add a driver. maybe the main advantage is that we will have an
> unified user space tool for RPMB. right?

Pretty much. The main issue for virtio-rpmb is it doesn't really fit
neatly into the block stack because all it does is the RPMB part so a
non-block orientate API makes sense.

Can you point be to where the UFS driver does it's current RPMB stuff?

>
> Kind regards,
> Bean


--=20
Alex Benn=C3=A9e
