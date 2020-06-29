Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B88C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 00:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CED5E20772
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 00:38:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DVS9jsOi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgF2AiC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 20:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgF2AiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 20:38:02 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E57C03E979;
        Sun, 28 Jun 2020 17:38:02 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id h4so15364481ior.5;
        Sun, 28 Jun 2020 17:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fKC09IE4Z/YqrIvCH2GzaIGeSq5BwtgQav6ZulQOmGE=;
        b=DVS9jsOih21wFhVh4laLeQUpMcGzENt/8f+fcw24HpjGdUruEPS0YQaLwklmgqtsKN
         C7GjQQp6oF6FdLv/i9PplHZFl6l65JMFKSa62JxmljIpEgS/JoCU6LdCVbxNvUtL7B+U
         TYazPq3xHmC+SQLAXkZBuYsHh+RFUcV0fWo5L4ST0qZkGypfTuXnXQDed3zUlafYh+Dt
         wHIkpGoQa2t9jawVS/fggXUsxCasGVqnu6HeVO8Ji77NvHRRqdpsZUisII4IQgEMLHEv
         vKADXj0qZqcxisj2GPJ6hph18faUuNDf8DZhGcpxBfQloktVOdN5fyZXRWYj0eL752ap
         igHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fKC09IE4Z/YqrIvCH2GzaIGeSq5BwtgQav6ZulQOmGE=;
        b=N6MNeAg937VKNL5m9oQMjXQs6XMwFsSBG7EIqSa1xz8ugQXwG/b5ssVqAsPcEMgS+V
         Slbodyji8g6opY+WyvZM2R5MDKvZXIRUMJbsF7aKiE0j94R3hQwafY4at4MROTN39gMY
         ZTkIhjByMAh3evmr0pPt8Mq4w/p4GoONhxuPDm2JQ7tROTqSPKM8Xfd/lr3JMACSNeWV
         zUqdB0BqpfPuGPPzrIHOs95Waj5wfkBNU9C0wrJs3t9gspd5ps+WDHcWKQ7y+2LKPtAN
         OtfsYF/yaYNNEClTqUVBM7TRBScMaonXWacreTtzo2rp3xnO816oMixBvwj2YH32Ad/z
         1YJw==
X-Gm-Message-State: AOAM533wSM6O2y102k5jlOVYwsvdkFm4PXFJkcqTzT4ITvjM6tBpT/IA
        qZWlwQdw5wI5Fi59MrKMCVYjSOc9vri1l/+c7NChnjIKLUs=
X-Google-Smtp-Source: ABdhPJyt8OTEALOBuo2FtWLpnAbtL9sHbnO2QZAL/AQ6JW4hVmTETEXPTsHIcE5/gMKt3mRtZ7BskbHHzt5vCkkzGEw=
X-Received: by 2002:a5e:980f:: with SMTP id s15mr14363091ioj.47.1593391081299;
 Sun, 28 Jun 2020 17:38:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200611100717.27506-1-bob.liu@oracle.com> <CAJhGHyDQLuoCkjwnze_6ZOLwXPtbNxnjxOr=fqqqsR_yxB9xtA@mail.gmail.com>
 <52fa1d81-e585-37eb-55e5-0ed07ce7adc0@oracle.com>
In-Reply-To: <52fa1d81-e585-37eb-55e5-0ed07ce7adc0@oracle.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Mon, 29 Jun 2020 08:37:50 +0800
Message-ID: <CAJhGHyBPrCr3+iu-dMe69J3+tj99ea8crCGBuXc4yoStD+dEFA@mail.gmail.com>
Subject: Re: [PATCH 1/2] workqueue: don't always set __WQ_ORDERED implicitly
To:     Bob Liu <bob.liu@oracle.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, lduncan@suse.com,
        michael.christie@oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 29, 2020 at 8:13 AM Bob Liu <bob.liu@oracle.com> wrote:
>
> On 6/28/20 11:54 PM, Lai Jiangshan wrote:
> > On Thu, Jun 11, 2020 at 6:29 PM Bob Liu <bob.liu@oracle.com> wrote:
> >>
> >> Current code always set 'Unbound && max_active == 1' workqueues to ordered
> >> implicitly, while this may be not an expected behaviour for some use cases.
> >>
> >> E.g some scsi and iscsi workqueues(unbound && max_active = 1) want to be bind
> >> to different cpu so as to get better isolation, but their cpumask can't be
> >> changed because WQ_ORDERED is set implicitly.
> >
> > Hello
> >
> > If I read the code correctly, the reason why their cpumask can't
> > be changed is because __WQ_ORDERED_EXPLICIT, not __WQ_ORDERED.
> >
> >>
> >> This patch adds a flag __WQ_ORDERED_DISABLE and also
> >> create_singlethread_workqueue_noorder() to offer an new option.
> >>
> >> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> >> ---
> >>  include/linux/workqueue.h | 4 ++++
> >>  kernel/workqueue.c        | 4 +++-
> >>  2 files changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> >> index e48554e..4c86913 100644
> >> --- a/include/linux/workqueue.h
> >> +++ b/include/linux/workqueue.h
> >> @@ -344,6 +344,7 @@ enum {
> >>         __WQ_ORDERED            = 1 << 17, /* internal: workqueue is ordered */
> >>         __WQ_LEGACY             = 1 << 18, /* internal: create*_workqueue() */
> >>         __WQ_ORDERED_EXPLICIT   = 1 << 19, /* internal: alloc_ordered_workqueue() */
> >> +       __WQ_ORDERED_DISABLE    = 1 << 20, /* internal: don't set __WQ_ORDERED implicitly */
> >>
> >>         WQ_MAX_ACTIVE           = 512,    /* I like 512, better ideas? */
> >>         WQ_MAX_UNBOUND_PER_CPU  = 4,      /* 4 * #cpus for unbound wq */
> >> @@ -433,6 +434,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
> >>  #define create_singlethread_workqueue(name)                            \
> >>         alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
> >>
> >> +#define create_singlethread_workqueue_noorder(name)                    \
> >> +       alloc_workqueue("%s", WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | \
> >> +                       WQ_UNBOUND | __WQ_ORDERED_DISABLE, 1, (name))
> >
> > I think using __WQ_ORDERED without __WQ_ORDERED_EXPLICIT is what you
> > need, in which case cpumask is allowed to be changed.
> >
>
> I don't think so, see function workqueue_apply_unbound_cpumask():
>
> wq_unbound_cpumask_store()
>  > workqueue_set_unbound_cpumask()
>    > workqueue_apply_unbound_cpumask() {
>      ...
> 5276                 /* creating multiple pwqs breaks ordering guarantee */
> 5277                 if (wq->flags & __WQ_ORDERED)
> 5278                         continue;
>                           ^^^^
>                           Here will skip apply cpumask if only __WQ_ORDERED is set.

wq_unbound_cpumask_store() is for changing the cpumask of
*all* workqueues. I don't think it can be used to make
scsi and iscsi workqueues bound to different cpu.

apply_workqueue_attrs() is for changing the cpumask of the specific
workqueue, which can change the cpumask of __WQ_ORDERED workqueue
(but without __WQ_ORDERED_EXPLICIT).

>
> 5280                 ctx = apply_wqattrs_prepare(wq, wq->unbound_attrs);
>
>      }
>
> Thanks for your review.
> Bob
>
> > Just use alloc_workqueue() with __WQ_ORDERED and max_active=1. It can
> > be wrapped as a new function or macro, but I don't think> create_singlethread_workqueue_noorder() is a good name for it.
> >
> >>  extern void destroy_workqueue(struct workqueue_struct *wq);
> >>
> >>  struct workqueue_attrs *alloc_workqueue_attrs(void);
> >> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> >> index 4e01c44..2167013 100644
> >> --- a/kernel/workqueue.c
> >> +++ b/kernel/workqueue.c
> >> @@ -4237,7 +4237,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
> >>          * on NUMA.
> >>          */
> >>         if ((flags & WQ_UNBOUND) && max_active == 1)
> >> -               flags |= __WQ_ORDERED;
> >> +               /* the caller may don't want __WQ_ORDERED to be set implicitly. */
> >> +               if (!(flags & __WQ_ORDERED_DISABLE))
> >> +                       flags |= __WQ_ORDERED;
> >>
> >>         /* see the comment above the definition of WQ_POWER_EFFICIENT */
> >>         if ((flags & WQ_POWER_EFFICIENT) && wq_power_efficient)
> >> --
> >> 2.9.5
> >>
>
