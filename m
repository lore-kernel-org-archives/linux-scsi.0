Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5166FC64EC4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 18:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjCFSs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 13:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjCFSsZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 13:48:25 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DFE2BEEF
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 10:48:23 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id cw28so42799728edb.5
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 10:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678128502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+AuRXdo16JeR9PnbP32vE+RmxUJH9KHyOeCFYJO9N8=;
        b=cfLBMhsxEmyjxzpNdu5x3WI0oXcOEnEr8VoAG5m38Cw4/kQTo9PWxpACKwcyjytSKD
         ydU9ygHtlfqv6Q6/ugWeApD883giDkCXBpD8NOvECUqwxj4akokkyUxVfHre/EMVa2oa
         4SHO37wicSka3vGgpwhCmiBzDQRvxlNbPRHeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678128502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m+AuRXdo16JeR9PnbP32vE+RmxUJH9KHyOeCFYJO9N8=;
        b=Xr8YBMackcyWwc/3ehb8WQ9bojIdZSMe/+N05JfblDamI/FSLCBZfjhyJLALLyz/bF
         m/1EW0Ob2JrQ75lS6Ru3r2aQ+gzBIXww1X1NbnCn7urBQLJBsBMBHreQrzHnCultH0PC
         1ZYfGpCOMnXdrMFTNXvf+Zf2xdA2YqySgpmfp9i0tzgoUiUgIpOeijj5ExYctCbNPKa0
         oiLF89GjMUBVPkBS9F1ZO609xHgqr9zBxTdaKnM/JID/Lmww+niiB2Q7WI1Vu+ciEq+t
         0YQlsbNL0O90sopFrSAuWJXE+KidNRXMh/jRoYc/2ScjxqtF77o6LyyGkSZur/cAWHki
         wdxA==
X-Gm-Message-State: AO0yUKXOyDgblafQBLU++vALog327TAaoqvHOZvxa9v1SWjkG68Qf4x5
        llSoP7gjFEDe6/bQa0m37J5utaCQnIAfANHsdrkALg==
X-Google-Smtp-Source: AK7set9rshReCYVvFem4q9Qywe1Zzr7HuOIxc0kpYkUTQjGO3YeaYTbfUrxwBF+/cjBg64foKg4blw==
X-Received: by 2002:aa7:cd55:0:b0:4c0:e156:7954 with SMTP id v21-20020aa7cd55000000b004c0e1567954mr9151498edw.34.1678128502091;
        Mon, 06 Mar 2023 10:48:22 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id u7-20020a50d507000000b004acc6cbc451sm5537222edi.36.2023.03.06.10.48.21
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 10:48:21 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id x3so42681585edb.10
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 10:48:21 -0800 (PST)
X-Received: by 2002:a50:cd15:0:b0:4c1:1555:152f with SMTP id
 z21-20020a50cd15000000b004c11555152fmr6419391edi.5.1678128500729; Mon, 06 Mar
 2023 10:48:20 -0800 (PST)
MIME-Version: 1.0
References: <20230306160651.2016767-1-vernon2gm@gmail.com> <20230306160651.2016767-4-vernon2gm@gmail.com>
In-Reply-To: <20230306160651.2016767-4-vernon2gm@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 Mar 2023 10:48:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj73=Os1p=W7D2va=Rd81ZKvjb35yWgXQNgn1hXNRpAbw@mail.gmail.com>
Message-ID: <CAHk-=wj73=Os1p=W7D2va=Rd81ZKvjb35yWgXQNgn1hXNRpAbw@mail.gmail.com>
Subject: Re: [PATCH 3/5] scsi: lpfc: fix lpfc_cpu_affinity_check() if no
 further cpus set
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
> -                               if (new_cpu =3D=3D nr_cpumask_bits)
> +                               if (new_cpu >=3D nr_cpumask_bits)

This all should use "nr_cpu_ids", not "nr_cpumask_bits".

But I really suspect that it should all be rewritten to not do that
thing over and over, but just use a helper function for it.

  int lpfc_next_present_cpu(int n, int alternate)
  {
        n =3D cpumask_next(n, cpu_present_mask);
        if (n >=3D nr_cpu_ids)
                n =3D alternate;
        return n;
  }

and then you could just use

        start_cpu =3D lpfc_next_present_cpu(new_cpu, first_cpu);

or similar.

              Linus

PS. We "kind of" already have a helper function for this:
cpumask_next_wrap(). But it's really meant for a different pattern
entirely, so let's not confuse things.
