Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F154C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 15:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2039206F1
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 15:54:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RySqVmaj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgF1Pyw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 11:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgF1Pyv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 11:54:51 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2F9C03E979;
        Sun, 28 Jun 2020 08:54:51 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g18so14218893wrm.2;
        Sun, 28 Jun 2020 08:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sEfpGNC1wgHInVbFM/yJkO/397CoGeIpiR31ps+GqnY=;
        b=RySqVmajWV6OJ+iQX3hGEZ4N8UoeksvAL7R8YX+DoCwaicjMoJaqy342V+OpKzHsqi
         lPZ7R4qe5X2nZczwgkpCv3yI9NlZOSryVdb52+xYjoFqvQ9gX4b0HHd9IrC14w7Iklcb
         uFEIsCZxQps4O0qGBKX5GgyhxoIvTaG+iEaNSPDGVt0qFgxXPOvaL5Tsj6rItoVy+C+A
         6E2eeL/708cAfNpuCiYhdeOJY0/A59LoAS8QaDmWW3POhxp0K3i94z+/1ScJEqH6zpFr
         D7KPM15Jsui4v9h53M6+2hRUX3Zb1b7Vcs2S+5po6Ixh2sPc5Ty8o7cmY/h4dELa4hwn
         XsHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sEfpGNC1wgHInVbFM/yJkO/397CoGeIpiR31ps+GqnY=;
        b=BhFCl2218dBr+fIiYNxL52MIlbv9pZwNQKrapZWXKr5jfaL7amDOjwcuryP2IZ7d/c
         ia2z5NTXJYv/cK+AUjqLAJrCvCLXWffJTld0HJxKX13CNeUy6EQI5ZrAIZwA4Te4q1f1
         U/teA2Vli1ziNMlXdgq2kqo2J0tH5XtaMYpx3rhH7BrV3wJo/YqwvB9ebZUZQ6tmtpf+
         RFxc3yafD2eLS7kDC3oLJHAICfqJUDbI0HGtwulQQfCi35WC6iLYoUpCRg4TTmmXIhiB
         pUDEeFdYkMVVhioi35PeqlnIQJmKn4RabSJSi1VsQ0P2Uh92IbR8cOigSEPtCxchvfw7
         XYtQ==
X-Gm-Message-State: AOAM533q9sPK4rHyTcaHXsKx4X1gDn+nRSp1uimNXmXTK30hAnE3VRUb
        8MCvamTqGEJiYDVJURRjL6+UDf1vTNjNzXJ+tx4=
X-Google-Smtp-Source: ABdhPJyXfnsc3DPdGe1IaBxe+LCRIZkifchnFRbAacIOGQqLZU0NIUnLM09Dp40041gsmjwm364kCA8GepFmOmc0YH0=
X-Received: by 2002:a5d:55c9:: with SMTP id i9mr13066890wrw.404.1593359690077;
 Sun, 28 Jun 2020 08:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200611100717.27506-1-bob.liu@oracle.com>
In-Reply-To: <20200611100717.27506-1-bob.liu@oracle.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Sun, 28 Jun 2020 23:54:38 +0800
Message-ID: <CAJhGHyDQLuoCkjwnze_6ZOLwXPtbNxnjxOr=fqqqsR_yxB9xtA@mail.gmail.com>
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

On Thu, Jun 11, 2020 at 6:29 PM Bob Liu <bob.liu@oracle.com> wrote:
>
> Current code always set 'Unbound && max_active == 1' workqueues to ordered
> implicitly, while this may be not an expected behaviour for some use cases.
>
> E.g some scsi and iscsi workqueues(unbound && max_active = 1) want to be bind
> to different cpu so as to get better isolation, but their cpumask can't be
> changed because WQ_ORDERED is set implicitly.

Hello

If I read the code correctly, the reason why their cpumask can't
be changed is because __WQ_ORDERED_EXPLICIT, not __WQ_ORDERED.

>
> This patch adds a flag __WQ_ORDERED_DISABLE and also
> create_singlethread_workqueue_noorder() to offer an new option.
>
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>  include/linux/workqueue.h | 4 ++++
>  kernel/workqueue.c        | 4 +++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index e48554e..4c86913 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -344,6 +344,7 @@ enum {
>         __WQ_ORDERED            = 1 << 17, /* internal: workqueue is ordered */
>         __WQ_LEGACY             = 1 << 18, /* internal: create*_workqueue() */
>         __WQ_ORDERED_EXPLICIT   = 1 << 19, /* internal: alloc_ordered_workqueue() */
> +       __WQ_ORDERED_DISABLE    = 1 << 20, /* internal: don't set __WQ_ORDERED implicitly */
>
>         WQ_MAX_ACTIVE           = 512,    /* I like 512, better ideas? */
>         WQ_MAX_UNBOUND_PER_CPU  = 4,      /* 4 * #cpus for unbound wq */
> @@ -433,6 +434,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
>  #define create_singlethread_workqueue(name)                            \
>         alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
>
> +#define create_singlethread_workqueue_noorder(name)                    \
> +       alloc_workqueue("%s", WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | \
> +                       WQ_UNBOUND | __WQ_ORDERED_DISABLE, 1, (name))

I think using __WQ_ORDERED without __WQ_ORDERED_EXPLICIT is what you
need, in which case cpumask is allowed to be changed.

Just use alloc_workqueue() with __WQ_ORDERED and max_active=1. It can
be wrapped as a new function or macro, but I don't think
create_singlethread_workqueue_noorder() is a good name for it.

>  extern void destroy_workqueue(struct workqueue_struct *wq);
>
>  struct workqueue_attrs *alloc_workqueue_attrs(void);
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 4e01c44..2167013 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4237,7 +4237,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
>          * on NUMA.
>          */
>         if ((flags & WQ_UNBOUND) && max_active == 1)
> -               flags |= __WQ_ORDERED;
> +               /* the caller may don't want __WQ_ORDERED to be set implicitly. */
> +               if (!(flags & __WQ_ORDERED_DISABLE))
> +                       flags |= __WQ_ORDERED;
>
>         /* see the comment above the definition of WQ_POWER_EFFICIENT */
>         if ((flags & WQ_POWER_EFFICIENT) && wq_power_efficient)
> --
> 2.9.5
>
