Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE88C43215
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 01:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1040920898
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 01:50:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="e3OQntoE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfKUBuQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 20:50:16 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55360 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfKUBuQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 20:50:16 -0500
Received: by mail-wm1-f66.google.com with SMTP id b11so1848929wmb.5
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2019 17:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FG0xwp6HVYe1f5DDSVU7DrWAa/EAcoi4UERXNfS+PzA=;
        b=e3OQntoEJyi6412ZXF96CoksLqmA1uxrmTF03xvE9Tq8EHl5fBKJXH1euEuimV+DR4
         ksVzfvNZPgUKmh9tMthjxBCnDQpS74MKSmcLaxnGMkzApR5/lMxCHrHEQf1ZEaHlqo/I
         cW6dLyyuSNUWEQipJszZZaZk5YhdOnANz3u/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FG0xwp6HVYe1f5DDSVU7DrWAa/EAcoi4UERXNfS+PzA=;
        b=APA04B+MINGFygioIOBm+jBuO0/BmGIyiGnsKRwtW8DzXzKvbn/ytB0IIcbjVKHYJM
         li7DpoHgH17+G921tVopHAp7D+JXm9UCeX4oYk3I8dbTs12hG3ixIcrSDJu/WENPmNln
         fL2toGZ75M9v3HbRZYFgofEa8okvF8+4ZPMzm136IwFDN/Wr31bQfjh7k8xfAYizxnTS
         sfmBMo7rPxQGep2uG8sVzN0ApUEcGitZMyIt9xCPfkbJ5QYQZhhDnoQuuFnkK9eZ9Cxm
         rAMM71yISEb7/4lXGXSF8M3/tLJnweyPUg2i2pZxIMB2h0PnjMn/tokU3kNXn9xcuu/i
         kbWw==
X-Gm-Message-State: APjAAAViZDjPb/MobqFY+dkfC30SI7oNpEDzJ/jvRpr6UG+8AIaJr6hC
        WHtXbEEQ3LiIqsVy3rwW3UdZ0h2j4NCU36zzyow91Q==
X-Google-Smtp-Source: APXvYqyfbJQGLLIjAIFZGC2/WpovD17wheezTOr/BBTkBa+ChmHy434DUgxK3hVwTyjF5ci6QZ5l1u5RHZedl2IZL0g=
X-Received: by 2002:a7b:c181:: with SMTP id y1mr6717738wmi.16.1574301013750;
 Wed, 20 Nov 2019 17:50:13 -0800 (PST)
MIME-Version: 1.0
References: <c7c78e42173ad8bc6e8c775bf6e98f54@mail.gmail.com> <20191121012148.GE24548@ming.t460p>
In-Reply-To: <20191121012148.GE24548@ming.t460p>
From:   Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Date:   Wed, 20 Nov 2019 18:50:02 -0700
Message-ID: <CADbZ7Fqcx4rWLB7MMVj+J+9n0bMGENj-WZZijiOHN0WrL6OV0A@mail.gmail.com>
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Ewan Milne <emilne@redhat.com>, axboe@kernel.dk,
        bart.vanassche@wdc.com, hare@suse.de, hch@lst.de,
        jejb@linux.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>You just see large IO size from driver side or device side, and do you
>>know why the big size IO is submitted to driver? Block layer's IO merge
>>contributes a lot for that, and IO merge usually starts to work

May be it contribute to some extent, but I do not think streaming
applications have any incentive/reason to give small IO. An
application like Netflix need to read as much data as soon as possible
and serve to customers, they have no reason to read in small chunks.
In fact, they read in huge chunks.
That is why sequential IO is normally large chunks and random IO (
which is more DB kind of operations ) is small IO.
Only exception I know of is database REDO logs, that are small
sequential IO, because there the DB is logging small transactions --
but they go to SSDs.

>>Yeah, that is why my patches just bypass sdev->device_busy for SSD, and
>>looks you misunderstood the idea behind the patches, right?

No, I got the idea, I am just saying most high end controllers have an
IO size limit  , and even if the block layer merges IO, it does not
help, since they have to be broken to the max size the controller
supports. Also, most high end controllers have their own merging
logic, and hence not too much dependent on upper layer merging for
them

On Wed, Nov 20, 2019 at 6:22 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Wed, Nov 20, 2019 at 02:58:40PM -0700, Sumanesh Samanta wrote:
> > >Ordinarily I'd prefer a host template attribute as Sumanesh proposed,
> > >but I dislike wrapping the examination of that and the queue flag in
> > >a macro that makes it not obvious how the behavior is affected.
> >
> > I think we can have a host template attribute and discard this check
> > altogether, that is not check device_busy for both SDD and HDDs.
> >
> > As both you and Hannes mentioned, this change affects high end controllers
> > most, and most of them have some storage IO size limit. Also, for HDD
> > sequential IO is almost always large and
> > touch the controller max IO size limit.
>
> You just see large IO size from driver side or device side, and do you
> know why the big size IO is submitted to driver? Block layer's IO merge
> contributes a lot for that, and IO merge usually starts to work
> after queue becomes busy which can be signaled from !blk_mq_get_dispatch_budget().
>
> That is why we implements .get_budget and .put_budget on SCSI for fixing
> sequential IO performance regression.
>
> 0df21c86bdbf scsi: implement .get_budget and .put_budget for blk-mq
> aeec77629a4a scsi: allow passing in null rq to scsi_prep_state_check()
> b347689ffbca blk-mq-sched: improve dispatching from sw queue
> de1482974080 blk-mq: introduce .get_budget and .put_budget in blk_mq_ops
>
> Also HDD may be connected to high end HBA too.
>
> > Thus, I am not sure merge matters
> > for these kind of controllers.
>
> Yeah, that is why my patches just bypass sdev->device_busy for SSD, and
> looks you misunderstood the idea behind the patches, right?
>
>
>
> Thanks,
> Ming
>
