Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587D8C77B7A
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 11:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjE3Laz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 07:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjE3Lay (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 07:30:54 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DF1130
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 04:30:30 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-568900c331aso23603057b3.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 04:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685446230; x=1688038230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/lOqziokTWzu7FKth3U9in9RmGygLBX4K+Xq/s6Qy8w=;
        b=f7V+S7oJ8ypXQ1J0qjZO9SM4P0qyzGzYYbgHPujmK5b9ewxONuhlFgk+zhlPo1p0kn
         jQcNNveayeqHutjkcThxUyKVD04A0tQnbvBUHUDlTljQdLylxwVt6Is09gydF149z5v0
         6QJUiiqSjRKyym+vvVV8OHXvu5wP1HoJ0FhYOxwWQHp/xasad099gP78+8+yVoc2TbxN
         TLozm389Mz8Oe+2FVoEsSWZju1oolQzm2NBT5aSd2Pos6Gxt5JkNa/5YfYuPtgbfKr4J
         Kshnx1slZx2LbdGes/8UCQqcZcdZj7CRQMBxAGsi8zGD5vvyKoRY2bdxjxYCkhVP5u0R
         43gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685446230; x=1688038230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/lOqziokTWzu7FKth3U9in9RmGygLBX4K+Xq/s6Qy8w=;
        b=RK1vS4QG2MysCEpiVK6RyX5fIg+DE8WeNcB0S6viFxKUoqs06TnginR+AQbwPsXEfd
         lAPqCKOinF/uKiPcTF0PAQYr0EVmadfOL73bImqUVm/V427m3ecSneusFcOdLl/drWMn
         Xn0YX/9TgoGBbB8RNTfZIIk+NMo8eWOEBZKxXwnIDA0jmKS4eXzGGyZXu1udyLTjbLlK
         65U1dlsu1Q/x/Lnf27MpHQq91xjZbaMve5W2Z+agjH7Xwin70Pv+zasIRMm0RfHWM2xi
         czq3DlZBmIJomGluAuK5xeNniZLLXJX7PsIq09UN+ZO/g2c5DAwn6Vfl9iGV8poNC6hj
         FFpQ==
X-Gm-Message-State: AC+VfDwFKwg+xqJNi7qoXIgMVPnN6/Hknwq+TOQkvX4iWWj/OlIBVjyg
        RnKcS2oNp1rkl9KqNGCR0pTHPoTmo0XykcwBItjYcgm6mFCKfx6/tvs=
X-Google-Smtp-Source: ACHHUZ5MGi/vBFFi6LkvwzKXZgm9ZsM66UKEmBbWI6uJaf3GdkGt4oES6dly8rZ37L+e9/anu5N7OV9+dQWakEvn4eQ=
X-Received: by 2002:a0d:e2c7:0:b0:55a:c89c:69c0 with SMTP id
 l190-20020a0de2c7000000b0055ac89c69c0mr2039822ywe.12.1685446229941; Tue, 30
 May 2023 04:30:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230530061307.525644-1-dlemoal@kernel.org> <ZHW9IQvePaG0yxY8@x1-carbon>
In-Reply-To: <ZHW9IQvePaG0yxY8@x1-carbon>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 30 May 2023 13:30:18 +0200
Message-ID: <CACRpkdZskZ-GktsYL0MXbMwdOQmF=-4yyns3u+-2eHP1Nt_RHg@mail.gmail.com>
Subject: Re: [PATCH] block: improve ioprio value validity checks
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 30, 2023 at 11:09=E2=80=AFAM Niklas Cassel <Niklas.Cassel@wdc.c=
om> wrote:

> We noticed that the LTP test case:
> https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/sy=
scalls/ioprio/ioprio_set03.c
>
> Started failing since this commit in linux-next:
> eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")
>
> The test case expects that a syscall that sets ioprio with a class of 8
> should fail.
>
> Before this commit in linux next, the 16 bit ioprio was defined like this=
:
> 3 bits class | 13 bits level
>
> However, ioprio_check_cap() rejected any priority levels in the range
> 8-8191, which meant that the only bits that could actually be used to
> store an ioprio were:
> 3 bits class | 10 bits unused | 3 bits level
>
> The 10 unused bits were defined to store an ioprio hint in commit:
> 6c913257226a ("scsi: block: Introduce ioprio hints"), so it is now:
> 3 bits class | 10 bits hint | 3 bits level
>
> This meant that the LTP test trying to set a ioprio level of 8,
> will no longer fail. It will now set a level of 0, and a hint of value 1.

Wow good digging! I knew the test would be good for something.
Like for maintaining the test.

> The fix that Damien suggested, which adds multiple boundary checks in the
> IOPRIO_PRIO_VALUE() macro will fix any user space program that uses the u=
api
> header.

Fixing things in the UAPI headers make it easier to do things right
going forward with classes and all.

> However, some applications, like the LTP test case, do not use the
> uapi header, but defines the macros inside their own header.

IIRC that was because there were no UAPI headers when the test
was created, I don't think I was just randomly lazy... Well maybe I
was. The numbers are ABI anyway, not the header files.

> Note that even before commit:
> eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")
>
> The exact same problem existed, ioprio_check_cap() would not give an
> error if a user space program sent in a level that was higher than
> what could be represented by the bits used to define the level,
> e.g. a user space program using IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 8192)
> would not have the syscall return error, even though the level was higher
> than 7. (And the effective level would be 0.)
>
> The LTP test case needs to be updated anyway, since it copies the ioprio
> macros instead of including the uapi header.

Yeah one of the reasons the kernel fails is in order to be
able to slot in new behaviour in response to these ioctls,
so the test should probably just be updated to also test
the new scheduling classes and all that, using the UAPI
headers.

Will you send a patch?

Yours,
Linus Walleij
