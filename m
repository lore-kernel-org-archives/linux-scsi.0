Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1207DC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 16 May 2022 18:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344531AbiEPSFU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 14:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237743AbiEPSFQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 14:05:16 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731BB377C2
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2022 11:05:11 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id j28so5359973eda.13
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2022 11:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fBfJCGFmnmHFyZCsMK3wiFpbhBcHWLVoHbOFzHKjGMQ=;
        b=OHPDgsoJ9Bun/JRtnlaDF+u3/KFPL+fwQx/BSD+2OcqFjFx/QGXobcm1CRZy7TMtVP
         0LuUnPFijF5+ItJrprEGEPSFe1bpieia/XbLg9lqUOCLhUNssSdIi1+lTGNznxxZwaBL
         2P03KdZI/jfFFNnuJgTizzalP59ckfHmlB4ec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fBfJCGFmnmHFyZCsMK3wiFpbhBcHWLVoHbOFzHKjGMQ=;
        b=srxjSZNiiQ2frq3XIi1H1ms55EwadYH/eLxZn7p83z1xI6C4Kn7f0dQXP2q7oBbiOs
         9eCMNCuYIq8CHBI9CPPqCjsGDO8ENoYe8AyxRM7+mF3fymkFO3+6xy5Q/LuHESksgHsZ
         foNOm4SLbRmz4prdaPF9C1YkfzS1PnhkQkKZxwjG+hBK6d5rsUDOWh6DRfCXqaZgp/Qu
         UFrw1kujhUNTj1iPA8FasCJKmgEwc0WiEYzZo07PI3RvPcLTPswxWrpQ1B/U1TJQzl0Z
         Jty5vyXuP3JQU5RzYQE8JJllP4z/1bU1c9D4AfWALY0KMz2h5mTcDZaMNX1WZhkkuQx5
         /GVQ==
X-Gm-Message-State: AOAM533L89TI990xxbUxog1Yik8pxxMQlUUKADJScVf1juIE3GTh3jx4
        ydPt6wqb5bE+NEylqWN2DaxRVdzqqtM+PDYb
X-Google-Smtp-Source: ABdhPJwcEMALM/rymOL2Sm3T8v1jopBjLOBiuhg+V9GE7zud1A7nq41T2svz69lEC/GZKPwDbMK38g==
X-Received: by 2002:a05:6402:424a:b0:427:d3d0:da1e with SMTP id g10-20020a056402424a00b00427d3d0da1emr14999458edb.262.1652724309577;
        Mon, 16 May 2022 11:05:09 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7c04e000000b0042a5a39ba7esm4681816edo.25.2022.05.16.11.05.08
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 11:05:09 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id m2-20020a1ca302000000b003943bc63f98so34768wme.4
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2022 11:05:08 -0700 (PDT)
X-Received: by 2002:a7b:c8d6:0:b0:394:25ff:2de with SMTP id
 f22-20020a7bc8d6000000b0039425ff02demr27938988wml.154.1652724307865; Mon, 16
 May 2022 11:05:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAOFRbGmGr2Z_sbYmE0SZT48CFkNAWVABnC_4V6x9PzZw-LJO4w@mail.gmail.com>
 <0db186ce-f789-f306-46ed-74ba75dec028@prevas.dk>
In-Reply-To: <0db186ce-f789-f306-46ed-74ba75dec028@prevas.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 16 May 2022 08:04:51 -1000
X-Gmail-Original-Message-ID: <CAHk-=wi4ARjYWqoStREpT9EEGWEVsEknRJX5z2OGoSDcKor8ZA@mail.gmail.com>
Message-ID: <CAHk-=wi4ARjYWqoStREpT9EEGWEVsEknRJX5z2OGoSDcKor8ZA@mail.gmail.com>
Subject: Re: ERROR: drivers: iscsi: iscsi_target.c
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Test Bot <zgrieee@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, May 15, 2022 at 10:48 PM Rasmus Villemoes
<rasmus.villemoes@prevas.dk> wrote:
>
> Hm, looks like cpumask.h should also expose a wrapper for
> bitmap_ord_to_pos ...

I'd rather delete bitmap_ord_to_pos() entirely. We have something like
two uses of it, and both are illegible.

There's a comment about a possible third use, but that one says that
it's not using it because doing it differently is more efficient.

And honestly, that more efficient non-ord_to_pos implementation is
actually a lot more legible to any sane person too.

I think it's a huge mistake to create these kinds of obscure "helper"
functions that have odd semantics that almost nobody needs. It only
results in code that is completely obscure, because nobody is used to
those very unusual functions, so to understand the user you almost
have to go look at what the heck the helper function does.

That "bitmap_onto()" function (another crazy helper) is a great
example. Not only doesn't it use that ord_to_pos helper, the "helpful"
comments that describes the algorithm in terms of it is just much
harder to understand than the actual code.

NONE of those functions should exist at all, imho. That
"bitmap_onto()" function is some really specialized stuff that is used
in *one* single place, where it implements *another* really
specialized helper function, and that *other* helper function also has
exactly use use.

That should have clued people in.

I really think those functions should go away, and just be folded into
mpol_relative_nodemask(), where the semantics for it can actually be
explained.

Helper functions with one single use-case shouldn't be helper
fucntions. They should be inlines in the one single file that uses
them. Trying to make up abstraction layers is not "helping", it's just
making code harder to read, and trying to convince people to use
specialized helpers just causes more cognitive load.

                   Linus
