Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBB1C64EC4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 18:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjCFSfX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 13:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjCFSfR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 13:35:17 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966313A865
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 10:34:39 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id i34so42616514eda.7
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 10:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678127660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jUkuyszYTAoQtNUlKsSSIkY0E3vOhynrc0QM2L0Yxu4=;
        b=OIdq6HFU9dxUkQTkbHlR0i3CxZpmNK8iA9/2k3NUR75lshbPEzybKO0ppeAVQtKuF4
         CJjYFnA+CmnAnkSwQ9auq5lDt4oSxmdtzx25Tk8a4q++koXNiNtPwT68INEfqYrYeKPl
         zlVnK5ytHemMRijZfUmH53IepVuSJ5DdUpViI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678127660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jUkuyszYTAoQtNUlKsSSIkY0E3vOhynrc0QM2L0Yxu4=;
        b=n5VKOxpKHtCII8Q4e7PMg1Weux/8pGcyaJGXgeHwQFxD875zo5hTf8NV4VlrgJNU9j
         xUOmX1MifUR6Ru/y7mUEs40HLdXwuMe6BGFHm33zqipwThSc8+5UQh5+bsWdefasZwLa
         TAs/d7DiA+BUK45DDnHRfGwZJ6mGHa5rCFb8oJvFWSyJAZLYYcSD2RClvTbibU2/bvto
         bCQPJPUPoKQv0ap9EpFJ0BAodocHAtxo3rsYdW0m2AWL2OC8ZxMjZSgXo72CsFWYALfF
         F48Du/yUqvyGt0eA7ZzjXwtUQpgAibj1XGamueo+OYYMxn95ldmtFEFUKdGkqa4WNdlU
         nd5w==
X-Gm-Message-State: AO0yUKUcol7vqtRDRXBxEMM1SM+QIf0FE/WpAln51vJvTAG9FXs4rZbb
        lbPdZX+em0vHz5oBz72VQNV/SymiDgqdk2S2NetsIg==
X-Google-Smtp-Source: AK7set+0LO9SnrIPP0E06AVckZkwGiH3T5OiROITE7iJu+h+OFt1AiR0iFUiQCD8u0S/8LzfJJ51BQ==
X-Received: by 2002:a17:906:6b1a:b0:8b1:7ab0:a462 with SMTP id q26-20020a1709066b1a00b008b17ab0a462mr11208981ejr.7.1678127660641;
        Mon, 06 Mar 2023 10:34:20 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id u7-20020a50d507000000b004acc6cbc451sm5521310edi.36.2023.03.06.10.34.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 10:34:19 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id s11so42592330edy.8
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 10:34:19 -0800 (PST)
X-Received: by 2002:a50:8711:0:b0:4bb:d098:2138 with SMTP id
 i17-20020a508711000000b004bbd0982138mr6329093edb.5.1678127659323; Mon, 06 Mar
 2023 10:34:19 -0800 (PST)
MIME-Version: 1.0
References: <20230306160651.2016767-1-vernon2gm@gmail.com> <20230306160651.2016767-6-vernon2gm@gmail.com>
 <CAHk-=whVnaTBt2Xm-A+8SMc5-q5CuZBDU6rUZ8yC8GoAnbTBvw@mail.gmail.com> <ZAYtRcbMeRUQFUw/@vernon-pc>
In-Reply-To: <ZAYtRcbMeRUQFUw/@vernon-pc>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 Mar 2023 10:34:02 -0800
X-Gmail-Original-Message-ID: <CAHk-=whA2kEBk3ibg3mrxpuXOAJKdM_MC4MQ8gLmxerZ5URfvg@mail.gmail.com>
Message-ID: <CAHk-=whA2kEBk3ibg3mrxpuXOAJKdM_MC4MQ8gLmxerZ5URfvg@mail.gmail.com>
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

On Mon, Mar 6, 2023 at 10:13=E2=80=AFAM Vernon Yang <vernon2gm@gmail.com> w=
rote:
>
> I also just see nr_cpumask_size exposed to outside, so...

Yeah, it's not great.

nr_cpumask_bits came out of the exact same "this is an internal value
that we use for optimized cpumask accesses", and existed exactly
because it *might* be the same as 'nr_cpu_ids', but it might also be a
simpler "small constant that is big enough" case.

It just depended on the exact kernel config which one was used.

But clearly that internal value then spread outside, and that then
caused problems when the internal implementation changed.

            Linus
