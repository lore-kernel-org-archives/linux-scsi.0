Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F84EC07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03AA8613CF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239545AbhGNPJp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 11:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhGNPJn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 11:09:43 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9FAC061760
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 08:06:51 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so2806094oti.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 08:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8YiH8+P/GYggmS9FkGJgJ7JmHee/6ylMrnanql7uyQo=;
        b=LP05I3DgupzAgfL4J5btk9IhIEy02Yv9jrcfj9/XbgglJLC745V5qheogVfIs4Ow0Q
         hxlHqnYGaKKoMU+US66ZRH23IT7uBIQFjxJ4PFF4Fno1P3rrfY7lBBYbVNI2HyKTraAy
         H898D6Llhi15EGceNXC21s7ZwQE6C2YXv7Ku+RupGb5kAE2Wl0CTuRTiH7z/Ly1iQSfo
         jp5t6bnTJ2sEwzwUoZdOlLNhgfKGGPoWj0zVS0Ea1T/3ntzi5+q8JVtGQIIfL4Wh0IpN
         03DMNL3VYn55sQB8yv85ywC6VPv+7whiWHTpWXZxMJti315W++e3+7MPiE0Co6wfa/+c
         68Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8YiH8+P/GYggmS9FkGJgJ7JmHee/6ylMrnanql7uyQo=;
        b=foaa0aBq2dHrwXbIQJ/X9AoaHYgFSw8EClkF0dlpABXKhSlpFHIueICaW8FKgEQfrS
         zmYBl3wabkUYFI1cr1lRJh1c8scpYVoTVNTHcoSzrtt7Xx0h0Av5heDPPGgtoKNm8hhj
         SDrJctgptt5EpxgZt+T/pTVzyCClGQrhVHguLS6h/QIv21xzzznYcMiYC6CF9m8wSoWd
         k2aGq+XYkGyu1d08Y4AnYxqQgP+2Z76YxnJ76pbk6Z8HWF4Mb5ZAxqWAeICF0nKDquI5
         BHeuwD+jbyflrXcyVaNuUsS4BJUqWndO6fx/TNHjnUr7/a50rTPDvxhNXPq9XOOLvDSg
         qwGA==
X-Gm-Message-State: AOAM5330gG8qPB6pihh7uxeAmVp1tHl/3MWhdpzB/41TXBbXp5oyWDdK
        pjJ9B0dKxPfhyuPqfEQGAVEdNBwM8WY/rwg/0Vd6Kg==
X-Google-Smtp-Source: ABdhPJxxWjFSbu10XUt6ENkGkcYIsqHhifAJ2KXMlLHv0EUApj91lhGmpBGjyb7d74F82HXlMaGXswhZJJ3WqsqIgRg=
X-Received: by 2002:a9d:d04:: with SMTP id 4mr8898501oti.251.1626275210727;
 Wed, 14 Jul 2021 08:06:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210714143239.2529044-1-geert@linux-m68k.org> <CAMuHMdWv8-6fBDLb8cFvvLxsb7RkEVkLNUBeCm-9yN9_iJkg-g@mail.gmail.com>
In-Reply-To: <CAMuHMdWv8-6fBDLb8cFvvLxsb7RkEVkLNUBeCm-9yN9_iJkg-g@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Wed, 14 Jul 2021 17:06:23 +0200
Message-ID: <CANpmjNO7reWQQCce+grJsfEjNcGzvrrsF2450DhE4CzCkvFt0w@mail.gmail.com>
Subject: Re: Build regressions/improvements in v5.14-rc1
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        linux-um <linux-um@lists.infradead.org>,
        scsi <linux-scsi@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 14 Jul 2021 at 16:44, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
[...]
>   + /kisskb/src/include/linux/compiler_attributes.h: error:
> "__GCC4_has_attribute___no_sanitize_coverage__" is not defined
> [-Werror=undef]:  => 29:29

https://lkml.kernel.org/r/20210714150159.2866321-1-elver@google.com

Thanks for the report.
