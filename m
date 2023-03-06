Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A456DC61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 17:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCFRtJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 12:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjCFRs4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 12:48:56 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC7A567A6
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 09:48:26 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id a25so42330683edb.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 09:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678124872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yHxMDJkAMxG+U7tsJ3okEl2/ScLLX/X7tonuUjq/u1I=;
        b=ckVkcyPoPmhakiRDn8WT3GtuhY1iVz4TCIFpaSpRNFSI5T5+f5NLSEXb7HrV0L1aIA
         3njxBfRcnIMISOh8QOdW8d7OHbEvEK/fUE8EFBWiiwlx+uAecoKDuJY/UGdrpdtvTDmu
         dvlI7sFA1gNjKGDa4lQafh2mXWwvBTIsa6xpw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678124872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yHxMDJkAMxG+U7tsJ3okEl2/ScLLX/X7tonuUjq/u1I=;
        b=14MdXqLAoL6/wgZ7O8IAVpephAHL/r807Hhkoa+l3US4iP87sElkqj4nSML/Ku4Ltg
         Wm7igFGnMRUM2GTvY3+Yzo7jJufP1yXis+ph5OoZjmuMzmeQfwZCTUk/z8HSnbzzA6Fi
         pdTwI4++PeyVVQ9y33T4aqYFgBAYHOJrvOOWiSVGHwOgDaQDI5wCOkHIxAFbZp558IOw
         wZfp/6t0tfMjnJrN0kFV0gwmIk6a2mUhpZ6nrdTKKo4qnDYLUKCyIKsCBYlH4j3c17Zb
         HGD7fYAm/LYjckiLzNj31ApbMlRXYY+IHsgPRHtknV40iZvny2wKobF6YMGVR6X799WB
         ru5A==
X-Gm-Message-State: AO0yUKVTDPwPU0oW+zwGMPBPYe7F7F99wtVxwNRRB1oEW/F31De/4nfp
        /GyzQycmZrqoA6rMFXRknuhpVATO/jO9kju4G1YVqw==
X-Google-Smtp-Source: AK7set/jGKpcikKjI/tTMm5rvNV3qxGTox+L6y+yNONu3uxYGJifElo5ahabFud+M5oy+0jvoGX5SA==
X-Received: by 2002:aa7:ccc7:0:b0:4ac:c4ed:f1d5 with SMTP id y7-20020aa7ccc7000000b004acc4edf1d5mr10154437edt.1.1678124872513;
        Mon, 06 Mar 2023 09:47:52 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id e21-20020a50d4d5000000b004d47ce55e57sm3813919edj.10.2023.03.06.09.47.51
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 09:47:51 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id j11so22569447edq.4
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 09:47:51 -0800 (PST)
X-Received: by 2002:a17:906:4997:b0:877:7480:c75d with SMTP id
 p23-20020a170906499700b008777480c75dmr5674931eju.0.1678124871381; Mon, 06 Mar
 2023 09:47:51 -0800 (PST)
MIME-Version: 1.0
References: <20230306160651.2016767-1-vernon2gm@gmail.com> <20230306160651.2016767-6-vernon2gm@gmail.com>
 <CAHk-=whVnaTBt2Xm-A+8SMc5-q5CuZBDU6rUZ8yC8GoAnbTBvw@mail.gmail.com>
In-Reply-To: <CAHk-=whVnaTBt2Xm-A+8SMc5-q5CuZBDU6rUZ8yC8GoAnbTBvw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 Mar 2023 09:47:34 -0800
X-Gmail-Original-Message-ID: <CAHk-=witXXeQuP9fgs4dDL2Ex0meXQiHJs+3JEfNdaPwngMVEg@mail.gmail.com>
Message-ID: <CAHk-=witXXeQuP9fgs4dDL2Ex0meXQiHJs+3JEfNdaPwngMVEg@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpumask: fix comment of cpumask_xxx
To:     Vernon Yang <vernon2gm@gmail.com>
Cc:     tytso@mit.edu, Jason@zx2c4.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        yury.norov@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 6, 2023 at 9:29=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The correct thing to do is always that
>
>    * Returns >=3D nr_cpu_ids if no cpus set.
>
> because nr_cpu_ids is always the *smallest* of the access sizes.
>
> Of course, right now Guenter seems to be reporting a problem with that
> optimization, so unless I figure out what is going on I'll just need
> to revert it anyway.

Ahh. And the reason is exactly that people do *not* follow that
"Returns >=3D nr_cpu_ids" rule.

The drivers/char/random.c code is very wrong, and does

             if (cpu =3D=3D nr_cpumask_bits)
                             cpu =3D cpumask_first(&timer_cpus);

which fails miserably exactly because it doesn't use ">=3D".

Oh well.

I'll have to look for more of this pattern, but basically all those
"xyz_cpumask_bits" things were supposed to always be just internal to
that header file implementation, which is *exactly* why you have to
check the result for ">=3D nr_cpu_ids".

       Linus
