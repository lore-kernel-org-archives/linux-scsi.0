Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC01C6FA99
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 18:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjCFSDX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 13:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCFSDV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 13:03:21 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8C97AA2
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 10:02:51 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id cw28so42289398edb.5
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 10:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678125766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nHiIbvE8ZF8yskiSHfLDDBQes7IipQHv7U2Dux2wiEU=;
        b=aS+ztAEvl5rXUV+bl4aUHKg/JjsEs5Q5O8O5esPopXwbfxpYA6cmA8oaxYHNUlU/xv
         pUDQ2Ag73sCMAC9SLcPIQilnahRnTUpOOhtVRnm6z8j74E8n2sdDsydvWCPi/1J2K4/F
         Y77RZfSte/kHcjeeE//5gW1NADu31WanG7wgE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678125766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nHiIbvE8ZF8yskiSHfLDDBQes7IipQHv7U2Dux2wiEU=;
        b=6hggPf4+TYHorAwKBc/3KnBvtqIGBl3QTgyeNAxNy/YPVljp9sm0oixZB5l29LIcgM
         nKclsWVQiCNbPKd3J5gvu0AYhubK4fRunZoPnwkko5yUEi5pPr71L0dzRADr78aINa82
         m6P6UWDONXHSJleLE0xommMgntwnU+n/WarzkBegxFxSBWR96AbkythLCqwyrz7Rtuc8
         YTqZ9FsPu4KMMF1I9b6F6czDHA8nR2Z74FniZcF8lCJynkzvasA5AhFsbIN6CMsb0VWx
         mnVA1sx3XhiaeNJi435m5jj50VDSSHDTWvqgfs5k9qVYp3HiwoodmWx14PlrppRH5Ijs
         /GSQ==
X-Gm-Message-State: AO0yUKULf4OSCrJjEmgpA0NaZ0KqMDItDPNeHOWOwhq3HsIFpA3hoRzB
        K2iqr8O7otyNMk48o3dpGQtridC4jDJo00mw1ixW2w==
X-Google-Smtp-Source: AK7set9NS+Pizo6BarcHyhzXqyrGF6AU2/bUGMSfitxeskrbOkUxw2LJ8YvCGicCeLISvGM/dPsGNw==
X-Received: by 2002:a17:907:3f18:b0:8f6:5a70:cccc with SMTP id hq24-20020a1709073f1800b008f65a70ccccmr15603102ejc.66.1678125765870;
        Mon, 06 Mar 2023 10:02:45 -0800 (PST)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id ot19-20020a170906ccd300b008b9d2da5343sm4873140ejb.210.2023.03.06.10.02.44
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 10:02:45 -0800 (PST)
Received: by mail-ed1-f45.google.com with SMTP id g3so42385667eda.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 10:02:44 -0800 (PST)
X-Received: by 2002:a50:9fa8:0:b0:4ae:e5f1:7c50 with SMTP id
 c37-20020a509fa8000000b004aee5f17c50mr6466912edf.5.1678125764592; Mon, 06 Mar
 2023 10:02:44 -0800 (PST)
MIME-Version: 1.0
References: <20230306160651.2016767-1-vernon2gm@gmail.com> <20230306160651.2016767-6-vernon2gm@gmail.com>
 <CAHk-=whVnaTBt2Xm-A+8SMc5-q5CuZBDU6rUZ8yC8GoAnbTBvw@mail.gmail.com> <CAHk-=witXXeQuP9fgs4dDL2Ex0meXQiHJs+3JEfNdaPwngMVEg@mail.gmail.com>
In-Reply-To: <CAHk-=witXXeQuP9fgs4dDL2Ex0meXQiHJs+3JEfNdaPwngMVEg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 Mar 2023 10:02:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj5hFp39ZM7fEtmctwkWdHHnx0X7c2j5Z8L+b18jUgcMQ@mail.gmail.com>
Message-ID: <CAHk-=wj5hFp39ZM7fEtmctwkWdHHnx0X7c2j5Z8L+b18jUgcMQ@mail.gmail.com>
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

On Mon, Mar 6, 2023 at 9:47=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The drivers/char/random.c code is very wrong, and does
>
>              if (cpu =3D=3D nr_cpumask_bits)
>                              cpu =3D cpumask_first(&timer_cpus);
>
> which fails miserably exactly because it doesn't use ">=3D".

Turns out this "cpu =3D=3D nr_cpumask_bits" pattern exists in a couple of
other places too.

It was always wrong, but it always just happened to work. The lpfc
SCSI driver in particular seems to *love* this pattern:

        start_cpu =3D cpumask_next(new_cpu, cpu_present_mask);
        if (start_cpu =3D=3D nr_cpumask_bits)
                start_cpu =3D first_cpu;

and has repeated it multiple times, all incorrect.

We do have "cpumask_next_wrap()", and that *seems* to be what the lpcf
driver actually wants to do.

.. and then we have kernel/sched/fair.c, which is actually not buggy,
just odd. It uses nr_cpumask_bits too, but it uses it purely for its
own internal nefarious reasons - it's not actually related to the
cpumask functions at all, its just used as a "not valid CPU number".

I think that scheduler use is still very *wrong*, but it doesn't look
actively buggy.

The other cases all look very buggy indeed, but yes, they happened to
work, and now they don't. So commit 596ff4a09b89 ("cpumask:
re-introduce constant-sized cpumask optimizations") did break them.

I'd rather fix these bad users than revert, but there does seem to be
an alarming number of these things, which worries me:

     git grep '=3D=3D nr_cpumask_bits'

and that's just checking for this *exact* thing.

                Linus
