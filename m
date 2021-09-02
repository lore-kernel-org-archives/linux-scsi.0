Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B805AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 19:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A09AD60F91
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 19:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347424AbhIBTgg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 15:36:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243515AbhIBTgg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 15:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630611336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GqRjsREsB+/ONObRkq1F1c/YtmLOoWASyIlE89Vodh0=;
        b=WnqbvxmNZIGBYNKNu6gorVFIQohGLu4qeO4Fzq+xdcuQcDlj8Ig3qsMCNs9xETbWZtLbQV
        ySm39AFwC3MZQx0dYwhxWgw+Cjyb7f5fu9lOZHOTYoDFNzX/9glOOGjkXegWwuv2yC6371
        P3Y2kk9pdOu/U4WEFpa4MA4zyr4+A5U=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-MeWEhwzqM-mdqTRyix9xdQ-1; Thu, 02 Sep 2021 15:35:35 -0400
X-MC-Unique: MeWEhwzqM-mdqTRyix9xdQ-1
Received: by mail-ed1-f69.google.com with SMTP id s25-20020a50d499000000b003c1a8573042so1539676edi.11
        for <linux-scsi@vger.kernel.org>; Thu, 02 Sep 2021 12:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GqRjsREsB+/ONObRkq1F1c/YtmLOoWASyIlE89Vodh0=;
        b=Agljm6TO0YMfcb7CpGxIAtvup/mg95FYMbKJHtHAI/R+x5zLTVyK5o7w2Lcacahdmo
         Fhxp74gdTJZZmVwonzOmvE/z8AoDy+VlCG63OYjq3gxic6lk3ZhHCube8Nnz5KyvaECg
         XD0WkXbNP7PojtdAjhDVdSU8QeAGrqIQgbPBj3uSqb7lNs9/NUnKfqMRcsnRCSIedjAH
         zgmXmY7HvU4VqPQ4AOr7Eu+efKdkJEnaEqx2Pgpq7/V2g1Te9qawQWS1zur1EEW/9gjQ
         wI7xufJ2HhAtcLeTbdYfQwqLT7IvDyqA3I4Fq0vzCYgjmEPZ35eMeSz0+3jP8W93frLi
         mLWQ==
X-Gm-Message-State: AOAM530eteoNU+DDFQoKTLYqtEH3XP5nbkFniVfhKcEUjMoFo7L3AFK0
        yltFcYbyIR94sGTQJc9PBKqYjbsVQnHhVgc3nzGETQpct1lbZHff5uXxpQUoCpvcpNlxi53Um0C
        Fgn2TOy/yV+I8IArqtlyRkaQC6s99Zs/Ot/BOPA==
X-Received: by 2002:a50:f0d5:: with SMTP id a21mr5126619edm.244.1630611334181;
        Thu, 02 Sep 2021 12:35:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8xCqv9lcoJRcYJsF0K2XYFmb8t6zbIgPCxZ0vssNBVxrrOd+KI7uxIz8SznhlZIrh51wjxU6+hNqCpzMp9go=
X-Received: by 2002:a50:f0d5:: with SMTP id a21mr5126610edm.244.1630611334044;
 Thu, 02 Sep 2021 12:35:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210902162425.17208-1-emilne@redhat.com> <YTEDFs8GdhTi6EUl@infradead.org>
In-Reply-To: <YTEDFs8GdhTi6EUl@infradead.org>
From:   Ewan Milne <emilne@redhat.com>
Date:   Thu, 2 Sep 2021 15:35:23 -0400
Message-ID: <CAGtn9rk0dqCiSQqRkN6BrDeBMjJWLqMmFsbH09Uqi2Yn4U4iQQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: sd: do not call device_add() on scsi_disk with
 uninitialized gendisk ->queue
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It was against git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
branch "fixes".

Looks like your changes resolve ->queue not being set prior to add_device(),
please disregard my patch.  It's not that critical to fix in earlier versions.
Sorry for the noise.

-Ewan

On Thu, Sep 2, 2021 at 1:01 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Sep 02, 2021 at 12:24:25PM -0400, Ewan D. Milne wrote:
> > Calling device_add() makes the scsi_disk visible in sysfs, the accessor
> > routines reference sdkp->disk->queue which was not yet set properly.
> > Fix this by initializing gendisk fields earlier in the function.
>
> What kernel is this against?  This won't apply against linux-next
> as disk->queue is now always set up by __blk_alloc_disk.
>

