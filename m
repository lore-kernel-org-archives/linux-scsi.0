Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE11C74A4B
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 17:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjCFRaa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 12:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjCFRaO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 12:30:14 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119FD67810
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 09:29:38 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cw28so41882970edb.5
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 09:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678123771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hyTtB/4llIx7xJW4yBF6B/aJvNGYAxGhl43lVEfQF64=;
        b=FQsHP01JWW59RwAk38+Q/kxXTDHxilylSztx59oelvW6wAt5oVrlY5/SQnx7fQocXB
         CP8GDvujVsLUxEqmCJlRIrgc08LVXYP//hgawsxldM/X8Q+lGRcdMB+l4p9Z91BxxN86
         aOqcDoHeseNaW1vdtqMXYz1g6d+5R4vj32iXA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678123771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hyTtB/4llIx7xJW4yBF6B/aJvNGYAxGhl43lVEfQF64=;
        b=xbZu75TEbNjY4woMEG1bqW8jf6M+se0AX6e+IxImn2WmJK9FkMpbhTXjiYXz2ONBwb
         UKJdpMXyOiLSB5nUa3ZHY6m95KvAptYH6FEB67w5E7k6toli1p+Fp5QvFYt3k1LsH5MN
         UF1///0/Xyu81qVAmM+qbduWT4y/Xvd9pPvg+AaULk1FJalIKVMzm4Wxe1aEZCoThOmI
         QBLy09UUyQWLdQt5vQliO0Z10DUUxtH+E5BkGRmjs+NFUmmenp3RDYFHkNRD5egAaK/T
         DjIBUmo1aXmYzPxU+L/HiEEZnkSFaMtG7kZ83ixEJsySi9jJsYCv7dR7OtI8K+DUeZvK
         x5Yg==
X-Gm-Message-State: AO0yUKXZlLv87MQqiYrF1+gjzE6znWV+p4/bllM6M09DJJ3P2EYJBIPl
        6cKU2Es2sFJxZgvT2PT0Lm+yIRXWkqI+yTmmgqGQZQ==
X-Google-Smtp-Source: AK7set+nuiyI//rqEhIx408Utf4FYlKt4cfQ8/bgmQgdDtcw6bleByfg6BPZ5m0QaPjnIgPcjjsq1w==
X-Received: by 2002:a17:907:6e01:b0:8e0:4baf:59d7 with SMTP id sd1-20020a1709076e0100b008e04baf59d7mr14737124ejc.31.1678123770934;
        Mon, 06 Mar 2023 09:29:30 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id q9-20020a170906678900b008d68d018153sm4806035ejp.23.2023.03.06.09.29.28
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 09:29:29 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id u9so41954200edd.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 09:29:28 -0800 (PST)
X-Received: by 2002:a17:906:4997:b0:877:7480:c75d with SMTP id
 p23-20020a170906499700b008777480c75dmr5644673eju.0.1678123768103; Mon, 06 Mar
 2023 09:29:28 -0800 (PST)
MIME-Version: 1.0
References: <20230306160651.2016767-1-vernon2gm@gmail.com> <20230306160651.2016767-6-vernon2gm@gmail.com>
In-Reply-To: <20230306160651.2016767-6-vernon2gm@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 Mar 2023 09:29:10 -0800
X-Gmail-Original-Message-ID: <CAHk-=whVnaTBt2Xm-A+8SMc5-q5CuZBDU6rUZ8yC8GoAnbTBvw@mail.gmail.com>
Message-ID: <CAHk-=whVnaTBt2Xm-A+8SMc5-q5CuZBDU6rUZ8yC8GoAnbTBvw@mail.gmail.com>
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

On Mon, Mar 6, 2023 at 8:07=E2=80=AFAM Vernon Yang <vernon2gm@gmail.com> wr=
ote:
>
> After commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
> optimizations"), the cpumask size is divided into three different case,
> so fix comment of cpumask_xxx correctly.

No no.

Those three cases are meant to be entirely internal optimizations.
They are literally just "preferred sizes".

The correct thing to do is always that

   * Returns >=3D nr_cpu_ids if no cpus set.

because nr_cpu_ids is always the *smallest* of the access sizes.

That's exactly why it's a ">=3D". The CPU mask stuff has always
historically potentially used a different size than the actual
nr_cpu_ids, in that it could do word-sized scans even when the machine
might only have a smaller set of CPUs.

So the whole "small" vs "large" should be seen entirely internal to
cpumask.h. We should not expose it outside (sadly, that already
happened with "nr_cpumask_size", which also was that kind of thing.

So no, this patch is wrong. If anything, the comments should be strengthene=
d.

Of course, right now Guenter seems to be reporting a problem with that
optimization, so unless I figure out what is going on I'll just need
to revert it anyway.

                Linus

                Linus
