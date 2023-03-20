Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BDDC6FD1F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Mar 2023 01:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjCTB7v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Mar 2023 21:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjCTB7u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Mar 2023 21:59:50 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0F53AA4
        for <linux-scsi@vger.kernel.org>; Sun, 19 Mar 2023 18:59:47 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id h25so1404769lfv.6
        for <linux-scsi@vger.kernel.org>; Sun, 19 Mar 2023 18:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1679277585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=veHR4OeBVdmMM7ZoMMD2LEaF+ZQb01kUcsthEQZ+G8o=;
        b=SNcJ+0V8W1TJ4MntzJ+tWV7MHo4J3GQzdu8n70Frwh9hfIq8QJeAepOPu8iQN8X+PI
         718jEIJg59mxJDYCZRplEWtR5a0GmEVRh4EPAtJkC6Hq5jJlDEALE1binS+iGalKfCmv
         EGPciyy8uyBqEs3OImQsnGjVKl5PsCY2jrNl8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679277585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=veHR4OeBVdmMM7ZoMMD2LEaF+ZQb01kUcsthEQZ+G8o=;
        b=o0f4MEwreWht7MBjUDi209+S2X1tShrqiRYoE0rHo5/K+xlSMMkakNP2RmWrrrhKe+
         NnK55Ppt2v4jKzAt/Cm1//sroYtVuvVZHdYdBmnSQ/pkAFuVCH/prGD8TIql9oPxZl/A
         Jx7zfiRhZnC9i2gppxtIt5EqDvKY6eM/4ZBqzxh/Fz0/VTeEcTKW8rqu/3MIMMrWOK3h
         Tf4dFz1PmVJVT4s1Nh5AysX0LXebU91n/vqFQY2fzrOexcZ7u7CLlmeTVoUTd30jDlGJ
         /JFBJPs8AqrM88z8oEeUMLPEHwHrHR5BNHeiwDqdnLvF7UXOCKVY6udtyAYyz4mPwWMC
         zbdA==
X-Gm-Message-State: AO0yUKUZHCMy70jS1u5zeV16QNYdER9MyMbOO4SmcXgjPTf6UfZZeBgs
        Plw93N8Wrl/HghMWUrcwNZ5W7THTusXT4VXr5BUm3w==
X-Google-Smtp-Source: AK7set/XJFVEQIoLo6u0LSW2T83t8rtT2LybFFysGqGyz7d6iPEbfC/arxd6J/Xti7IQhzM4bvrJqA==
X-Received: by 2002:a19:7503:0:b0:4af:5088:959c with SMTP id y3-20020a197503000000b004af5088959cmr6561293lfe.2.1679277585445;
        Sun, 19 Mar 2023 18:59:45 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id c17-20020ac25311000000b004db3900da02sm1472543lfh.73.2023.03.19.18.59.45
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Mar 2023 18:59:45 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id t14so10588435ljd.5
        for <linux-scsi@vger.kernel.org>; Sun, 19 Mar 2023 18:59:45 -0700 (PDT)
X-Received: by 2002:a17:906:2294:b0:927:912:6baf with SMTP id
 p20-20020a170906229400b0092709126bafmr2817236eja.15.1679277564111; Sun, 19
 Mar 2023 18:59:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230320005258.1428043-1-sashal@kernel.org> <20230320005258.1428043-9-sashal@kernel.org>
In-Reply-To: <20230320005258.1428043-9-sashal@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 19 Mar 2023 18:59:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgpK-Gm-nOybRKs1LTD5yb7rPHQ4+=PCDvq61mUpBskYw@mail.gmail.com>
Message-ID: <CAHk-=wgpK-Gm-nOybRKs1LTD5yb7rPHQ4+=PCDvq61mUpBskYw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.2 09/30] cpumask: fix incorrect cpumask scanning
 result checks
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vernon Yang <vernon2gm@gmail.com>,
        Yury Norov <yury.norov@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, mpe@ellerman.id.au,
        tytso@mit.edu, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, christophe.leroy@csgroup.eu,
        npiggin@gmail.com, dmitry.osipenko@collabora.com, joel@jms.id.au,
        nathanl@linux.ibm.com, gustavoars@kernel.org,
        naveen.n.rao@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Mar 19, 2023 at 5:53=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> [ Upstream commit 8ca09d5fa3549d142c2080a72a4c70ce389163cd ]

These are technically real fixes, but they are really just "documented
behavior" fixes, and don't actually matter unless you also have
596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
optimizations"), which doesn't look like stable material.

And if somebody *does* decide to backport commit 596ff4a09b89, you
should then backport all of

  6015b1aca1a2 sched_getaffinity: don't assume 'cpumask_size()' is
fully initialized
  e7304080e0e5 cpumask: relax sanity checking constraints
  63355b9884b3 cpumask: be more careful with 'cpumask_setall()'
  8ca09d5fa354 cpumask: fix incorrect cpumask scanning result checks

but again, none of these matter as long as the constant-sized cpumask
optimized case doesn't exist.

(Technically, FORCE_NR_CPUS also does the constant-size optimizations
even before, but that will complain loudly if that constant size then
doesn't match nr_cpu_ids, so ..).

                   Linus
