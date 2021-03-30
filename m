Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D66BC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 07:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D9716195C
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 07:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhC3Heq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 03:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhC3HeP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Mar 2021 03:34:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D1761957;
        Tue, 30 Mar 2021 07:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617089655;
        bh=YtguDODw8Uj/hE0IRHyy+onzpCZQS84rIgWYYMtsB8E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Rt3OaYykxMqzqMwR/09kXKocomqoYkBD7dGW2fk8T6GGtr3z3fIlZ76/GaLVGn6U4
         a/J/5ce9TayAuAfr7Hn/l9YINP5jaaMcJbdsV0LNg3CuSw7axu1G+sI2MsoTXf6fus
         8gaWOHLi5KD+Req07Wjb7blmGp67SLvEwmybP5v3Rqf1twp1icUzg20dYnh6fkbSgX
         CS1Vz5UbQUibD3vECLRdceMe8W4yH/h9h8s3lq5NZF0meT/K1cr7SmzD2i6CJq79ku
         99lVpHilpQnuDC4ZDjW2P1GIJqEUz9Q3GAHnX7Cq5JuzvVe4iAixsdg8+zLl7AC7cI
         HAyAUrpaLBIZg==
Received: by mail-oi1-f179.google.com with SMTP id x207so15630905oif.1;
        Tue, 30 Mar 2021 00:34:15 -0700 (PDT)
X-Gm-Message-State: AOAM532DpQsj2IdKANAO00X6A4MBWwpwiuDpy0RZjnx8gF8Y3hGpvqkx
        H/BZPVgIp+9G0K5hZe1RyNp3xLwqa0MxrHFSrws=
X-Google-Smtp-Source: ABdhPJw0JQhzHmFxsYjMFHKlfwtjreUcv9Xt8M6EVj8RxkFv3RdkCCY+IC2JvTqgveJWXVah6ctFL0OE0khmM55zXSc=
X-Received: by 2002:a05:6808:3d9:: with SMTP id o25mr2303636oie.4.1617089654371;
 Tue, 30 Mar 2021 00:34:14 -0700 (PDT)
MIME-Version: 1.0
References: <yq1wntpgxxr.fsf@ca-mkp.ca.oracle.com> <20210330071958.3788214-1-slyfox@gentoo.org>
 <20210330071958.3788214-3-slyfox@gentoo.org>
In-Reply-To: <20210330071958.3788214-3-slyfox@gentoo.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 30 Mar 2021 09:34:00 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2CmQpKynwGbtdWH+1L4=SkX2y4XKggT=8DrnsjxU4hSw@mail.gmail.com>
Message-ID: <CAK8P3a2CmQpKynwGbtdWH+1L4=SkX2y4XKggT=8DrnsjxU4hSw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] hpsa: add an assert to prevent from __packed reintroduction
To:     Sergei Trofimovich <slyfox@gentoo.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Don Brace <don.brace@microchip.com>,
        linux-ia64@vger.kernel.org, storagedev@microchip.com,
        linux-scsi <linux-scsi@vger.kernel.org>, jszczype@redhat.com,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>, thenzl@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 30, 2021 at 9:23 AM Sergei Trofimovich <slyfox@gentoo.org> wrote:

> +/*
> + * Make sure our embedded atomic variable is aligned. Otherwise we break atomic
> + * operations on architectures that don't support unaligned atomics like IA64.
> + *
> + * The assert guards against reintroductin against unwanted __packed to
> + * the struct CommandList.
> + */
> +static_assert(offsetof(struct CommandList, refcount) % __alignof__(atomic_t) == 0);
> +

There are a few other members that need to be aligned: the work_struct
has another
atomic_t inside it, and there are a few pointers that might rely on
being written to
atomically.

While you could add a static_assert for each member, the easier solution is to
just not ask for the members to be misaligned in the first place.

       Arnd
