Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00BBC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 05:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7DEA610A1
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 05:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbhG0FUA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 01:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbhG0FT6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 01:19:58 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D091DC061757
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 22:19:58 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id qk33so1579157ejc.12
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 22:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=faFw8uk+3+vwLKKUakltiHvX03NkoF61MT+TlrILxX8=;
        b=ILhndUXl1+ffaARR8qQ1le3fes1qCZYMtVXNaLgS/cJeM2OlGRWv7d6oY3Ww6LfBiP
         k3eeVqR46rDBcx2fwd4GudvDUj8TskDyV0gOsnYgKGCiOWko7BBXlwuGsiMHidQyPjMA
         sQQnNWNh5tt7UH3EIs12J5UokLwbJ3pxg/KWerOR6Fff1mupn6j0wCsE11PMmcK5ihyj
         gvBkj+WGcTJsHOrBCQsYBk7KF+LE/BRhUcQkMh6xOGKkoJHI0T8xBaAli9vhzgavXGQK
         hn1if22GvwynTZeMotC2lCAiUNkpaoepApFQNOu4SjHjB838BaYYklH4lCxqZMPeT3YZ
         a/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=faFw8uk+3+vwLKKUakltiHvX03NkoF61MT+TlrILxX8=;
        b=rXjN1Beq/XRxh9sm3u6uiUGxEwSfDHJsg6bd2gXA/jOarcoFKVOjzhXz6El4apL5B2
         r484JYuMcpEOsp6Mlrjqq6mrN5yVAc6/vkPq7WATrgALOIZT7LXvm4me511tSz4YZcLO
         VOQbdxtVDCjDoCGN6cctiKPbuI8Ieb1guqILsfEcuVZmuJiStawK3LhOdpC8g3XSkjnT
         Mps3hfbzuKn8eFn0/y8UewmkBSPr8hsLVGGCULTpclOMvLDPZdP1lTYN1o6kTuMSyZfH
         Q0GNV5jwHymU6tCqGkC++w95tB2XflFRdNwYct0J7WI6f102Vbvr8U3+0j319JXVNyUK
         XX3A==
X-Gm-Message-State: AOAM530yqijq3my0tdUrjjpajBSoZq2vNbf6NHlOZSjvtCCu2bhOI8r1
        WVrRt4ha0Qhy+A0WKJTJk1Wl5nSSdMy1B+m3aidfgg==
X-Google-Smtp-Source: ABdhPJwjqtRXaHnOqkt+yYUd17Veryt1WQai/AV2RGKn73zt2XcqQNQBxOHq29ZWXvt2Kg84fysLj0fO8n2x3F+k8PQ=
X-Received: by 2002:a17:907:6297:: with SMTP id nd23mr19545064ejc.62.1627363197451;
 Mon, 26 Jul 2021 22:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210707185945.35559-1-ipylypiv@google.com>
In-Reply-To: <20210707185945.35559-1-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 27 Jul 2021 07:19:46 +0200
Message-ID: <CAMGffEmEJ6NNJ+j=4L6XUdrKej-PXZo-RCtiP1h_jK-eMzA8Ug@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Fix tmf task completion race condition
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, Yu Zheng <yuuzheng@google.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 7, 2021 at 8:59 PM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> The tmf timeout timer may trigger at the same time when the response
> from a controller is being handled. When this happens the sas task may
> get freed before the response processing is finished.
>
> Fix this by calling complete() only when SAS_TASK_STATE_DONE is not set.
>
> Similar race condition was fixed in commit b90cd6f2b905
> ("scsi: libsas: fix a race condition when smp task timeout")
>
> Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>

Looks good to me, thx, sorry for late reply, somehow I missed it.
Acked-by: Jack Wang <jinpu.wang@ionos.com>
>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 6f33d821e545..1d35587c28e0 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -682,8 +682,7 @@ int pm8001_dev_found(struct domain_device *dev)
>
>  void pm8001_task_done(struct sas_task *task)
>  {
> -       if (!del_timer(&task->slow_task->timer))
> -               return;
> +       del_timer(&task->slow_task->timer);
>         complete(&task->slow_task->completion);
>  }
>
> @@ -691,9 +690,14 @@ static void pm8001_tmf_timedout(struct timer_list *t)
>  {
>         struct sas_task_slow *slow = from_timer(slow, t, timer);
>         struct sas_task *task = slow->task;
> +       unsigned long flags;
>
> -       task->task_state_flags |= SAS_TASK_STATE_ABORTED;
> -       complete(&task->slow_task->completion);
> +       spin_lock_irqsave(&task->task_state_lock, flags);
> +       if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
> +               task->task_state_flags |= SAS_TASK_STATE_ABORTED;
> +               complete(&task->slow_task->completion);
> +       }
> +       spin_unlock_irqrestore(&task->task_state_lock, flags);
>  }
>
>  #define PM8001_TASK_TIMEOUT 20
> @@ -746,13 +750,10 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
>                 }
>                 res = -TMF_RESP_FUNC_FAILED;
>                 /* Even TMF timed out, return direct. */
> -               if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
> -                       if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
> -                               pm8001_dbg(pm8001_ha, FAIL,
> -                                          "TMF task[%x]timeout.\n",
> -                                          tmf->tmf);
> -                               goto ex_err;
> -                       }
> +               if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
> +                       pm8001_dbg(pm8001_ha, FAIL, "TMF task[%x]timeout.\n",
> +                                  tmf->tmf);
> +                       goto ex_err;
>                 }
>
>                 if (task->task_status.resp == SAS_TASK_COMPLETE &&
> @@ -832,12 +833,9 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
>                 wait_for_completion(&task->slow_task->completion);
>                 res = TMF_RESP_FUNC_FAILED;
>                 /* Even TMF timed out, return direct. */
> -               if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
> -                       if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
> -                               pm8001_dbg(pm8001_ha, FAIL,
> -                                          "TMF task timeout.\n");
> -                               goto ex_err;
> -                       }
> +               if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
> +                       pm8001_dbg(pm8001_ha, FAIL, "TMF task timeout.\n");
> +                       goto ex_err;
>                 }
>
>                 if (task->task_status.resp == SAS_TASK_COMPLETE &&
> --
> 2.32.0.93.g670b81a890-goog
>
