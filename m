Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105A0C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 16:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E39FB22CAF
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 16:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hdDBXsoU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgHKQeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 12:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728969AbgHKQea (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2020 12:34:30 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD12C061787
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2020 09:34:30 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b79so12190102qkg.9
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2020 09:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=GgDm8VbRRTjshsOKjAe5aNqGADx4e2KHBrxxCeHXyho=;
        b=hdDBXsoU/z/tjrwT/IlpV+QucUDijC/g7pMgFvyO4/nUxlxDWZ2pP//W43hb6u7ZX7
         Nz3v6aHgwVn5Q/W+KEaidJeKx93Xvso5UhLN1E4jnk0koQVPh56oMDDxwKq5KwGl1mUP
         W1t66DVoNHl0qc8fFe1S8J8T2p5q/E+ulQndY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=GgDm8VbRRTjshsOKjAe5aNqGADx4e2KHBrxxCeHXyho=;
        b=dQbaARWZDoGQnpMEIi99JP0bz5SyToutwNzrbnGd85jI5humgjOFPlXtyC03r6aZRn
         v46BUKAz/px0odEhMEVje39ahHptYgbGTin6dmH1CYiVBOQVqyZ+q0QyRJCiaKWN0who
         qmooI168FCiz/wk8wErVx7jLuXmpm/krjhs3wPEVd3Hr0KTcGxNSG8oiXSNcbV8ov46A
         nn+h6uXsupgcbfvTJ+E3uBooOO7c5ZnM/HH0AHxFO3ZHnRKRP+Z6EA+SgF8bqAEpuXIO
         3v7HrlOlpY7Dtp+R8pamEyM4UGRtlPfUeldgzWLzlheluwQjUU1LXI3XdmpDjDPeKnNx
         3+tQ==
X-Gm-Message-State: AOAM530stgtVilr4AhDKIcyWpOemjemV0n4Dju6FqZjgB8U1BG5kQ4rG
        dE69MLYMmBAl90VwtzCTDlK59Bp05O3I88yMW8qXEA==
X-Google-Smtp-Source: ABdhPJy6c8Y3RvSatU61ItN52UoCWo3ul5hI7j8JyZVS/FXnWKOn+y0JXfX6Zhz47q/O52xZiT+9gNgL2nddTW9YsLA=
X-Received: by 2002:a05:620a:9c6:: with SMTP id y6mr1873831qky.27.1597163668144;
 Tue, 11 Aug 2020 09:34:28 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-3-git-send-email-john.garry@huawei.com>
 <20200611025759.GA453671@T590> <6ef76cdf-2fb3-0ce8-5b5a-0d7af0145901@huawei.com>
 <8ef58912-d480-a7e1-f04c-da9bd85ea0ae@huawei.com> <eaf188d5-dac0-da44-1c83-31ff2860d8fa@suse.de>
 <3b80b46173103c62c2f94e25ff517058@mail.gmail.com> <3742b7d4-df43-58ae-172d-2ff1ae46c33d@huawei.com>
In-Reply-To: <3742b7d4-df43-58ae-172d-2ff1ae46c33d@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQBVjmvxAE7FMYb7GtMRWGcwtMcECgJRJzAeAmYD0J0CUmtFnQMQPP3WAliipVQBosZEVwD0GAf5q7yOW6A=
Date:   Tue, 11 Aug 2020 22:04:25 +0530
Message-ID: <6a5165c33813676b735cfde06133d03a@mail.gmail.com>
Subject: RE: [PATCH RFC v7 02/12] blk-mq: rename blk_mq_update_tag_set_depth()
To:     John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > diff --git a/block/mq-deadline.c b/block/mq-deadline.c index
> > 9d75374..bc413dd 100644
> > --- a/block/mq-deadline.c
> > +++ b/block/mq-deadline.c
> > @@ -385,6 +385,8 @@ static struct request *dd_dispatch_request(struct
> > blk_mq_hw_ctx *hctx)
> >
> >          spin_lock(&dd->lock);
> >          rq = __dd_dispatch_request(dd);
> > +       if (rq)
> > +               atomic_dec(&rq->mq_hctx->elevator_queued);
>
> Is there any reason why this operation could not be taken outside the
> spinlock? I assume raciness is not a problem with this patch...

No issue if we want to move this outside spinlock.

>
> >          spin_unlock(&dd->lock);
> >
> >          return rq;
> > @@ -574,7 +576,6 @@ static void dd_finish_request(struct request *rq)
> >                          blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
> >                  spin_unlock_irqrestore(&dd->zone_lock, flags);
> >          }
> > -       atomic_dec(&rq->mq_hctx->elevator_queued);
> >   }
> >
> >   static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
> > --
> > 2.9.5
> >
> > Kashyap
> > .#
>
>
> btw, can you provide signed-off-by if you want credit upgraded to Co-
> developed-by?

I will send you merged patch which you can push to your git repo.

Kashyap

>
> Thanks,
> john
