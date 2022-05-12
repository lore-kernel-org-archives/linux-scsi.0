Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87F1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 19:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357909AbiELTLT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 15:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbiELTLS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 15:11:18 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6873439683
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 12:11:16 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g23so7331050edy.13
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 12:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SLT11SGZSlspM3ztqa+Z4xJFeyllWtbNbH4XI/ki7KQ=;
        b=Akos8r1uW3mKq93eO2Gh+RThomTvKQVXEIPNJLgU4e/OsWiyliXUyDvXM1KCZowBG5
         iB8r5GxgdwJONwg8JLTbxiugmdxYSNQ3UZHr+t/+uKRqH4lkyjc4uv95+s+5+nQlfzSG
         6pdmK4AOO1sJl6dZGjA/eOhr2a7EqbPThcB8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SLT11SGZSlspM3ztqa+Z4xJFeyllWtbNbH4XI/ki7KQ=;
        b=PzE0reO9yrsP+N1qSX3NOFqYzgNRHy3av0GYko3j7AwOLtsskSmP2XPDKUUxop7tIw
         Upj5uLj52tV1KjA54s4BMRFxYuucZ5k98qf4tbPrvNuOvYtNgue7rNVACnsk3Zbq5Afa
         gy61JrqRz24LirF+bS+b9iLwM46plhVxRWxJ6Kj8z4ADsvR/BPcbykl6flYSdk8LHDzJ
         Be7laWLZ3ubvci9d45knpOmR4OvFFdNP6FZYvohrgQ6XEazWAqeuRUkpff6Q3lbi9mBI
         WahrdQc7mMVoWN2PQqZxB0z0RPZxC3OHRkH9Ej8VtVuVwxebZlPIDwFDGOPZ3NyBCkLw
         GypA==
X-Gm-Message-State: AOAM532GnjUBMnxwKL1QWpsN0QiDlio3zEXXG/H62KiHPAHz6q0feYRY
        Ym8uN444GT7zdNkgvi9tcs9IHopwgE5AaTjU0Fg=
X-Google-Smtp-Source: ABdhPJzgaLq/0V9Uq6YKvTpvUfuPgiAY2+8Ub2LPJX5H4DTNDxwUBVQ/xkQfB3GFWTh7/jHvvzCa6A==
X-Received: by 2002:a05:6402:90d:b0:428:bda9:3e6b with SMTP id g13-20020a056402090d00b00428bda93e6bmr13985150edz.132.1652382674177;
        Thu, 12 May 2022 12:11:14 -0700 (PDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id m21-20020aa7c2d5000000b0042617ba639asm64542edp.36.2022.05.12.12.11.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 12:11:12 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id p189so3589453wmp.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 12:11:12 -0700 (PDT)
X-Received: by 2002:a1c:4c06:0:b0:394:65c4:bd03 with SMTP id
 z6-20020a1c4c06000000b0039465c4bd03mr1229662wmf.8.1652382672075; Thu, 12 May
 2022 12:11:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAOFRbGmGr2Z_sbYmE0SZT48CFkNAWVABnC_4V6x9PzZw-LJO4w@mail.gmail.com>
In-Reply-To: <CAOFRbGmGr2Z_sbYmE0SZT48CFkNAWVABnC_4V6x9PzZw-LJO4w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 12 May 2022 12:10:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh5E-xdc5P6SfN-ey6zvVri43rTj0g8kjUBWD3hhE-jiw@mail.gmail.com>
Message-ID: <CAHk-=wh5E-xdc5P6SfN-ey6zvVri43rTj0g8kjUBWD3hhE-jiw@mail.gmail.com>
Subject: Re: ERROR: drivers: iscsi: iscsi_target.c
To:     Test Bot <zgrieee@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Mingzhe Zou <mingzhe.zou@easystack.cn>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 12, 2022 at 11:42 AM Test Bot <zgrieee@gmail.com> wrote:
>
> void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
> {
>         int ord, cpu;
>         cpumask_t conn_allowed_cpumask;

Yeah, that's not how you are supposed to use 'cpumask_t'

This is why we have CONFIG_CPUMASK_OFFSTACK and 'cpumask_var_t', so
that the pattern is

        cpumask_var_t mask;

        if (!alloc_cpumask_var(&mask, GFP_KERNEL))
                return -ENOMEM;
        ... use 'mask' here as a  ...
        free_cpumask_var(mask);

and if the cpumask is small, it's allocated on the stack (and that
'alloc_cpumask_var()' becomes a no-op) and if it's huge, it has a real
allocation so that the stack frame doesn't grow too big.

The problem seems to have been introduced in this merge window by
commit d72d827f2f26 ("scsi: target: Add iscsi/cpus_allowed_list in
configfs"), but I didn't really look any closer than a plain "git
blame", so it might have happened before that too.

I also didn't check whether there was some explicit reason why the
code couldn't allocate the cpumask this way.

Btw, it's worth noting that 'cpumask_t' is always the full static
compile-time NR_CPUS bits in size, but a dynamically allocated
'cpumask_var_t' is only nr_cpumask_bits in size (ie the actual maximum
on that machine, as opposed to the theoretical maximum size). So they
are *not* exactly the same kind of 'cpumask_t' pointer in the end, but
no sane code should care (ie you have to do something else wrong for
the alloc_cpumask_var() pattern to not work).

           Linus
