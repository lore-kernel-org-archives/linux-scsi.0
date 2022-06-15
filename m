Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3106C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jun 2022 18:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345964AbiFOS5S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jun 2022 14:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiFOS5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2022 14:57:17 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E7B39175
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 11:57:16 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id a29so20347307lfk.2
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 11:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IA/Nfnvsktst34eWNe42G7OMd7iCZuXBerNp7A17zbY=;
        b=gBLSouUFCvTmZCe0d2n1rmBk0UpEFr92fycmZbNCS7+9fKN9WmLMyiHyR0DyFxivQH
         uVYsZDsg6SFuCEuJErtmEB/cZmrxx01a1Emcj0ebCZ0Y0BduJqz+SR7RLK8ne5vWRIBU
         GGNel7VB8PLADYGxnrnXUBfpORe80Ta6yYzJRx5UWkoOr0PYGH62YS13N//bpz+q5ZPR
         /GnBVzlkSV7UkEbZKSF67KPEeXaczCs+Hp7vgT3zfTwg+fwHBHsdG5IQDVifsuwwNxWA
         M5oJqr1H6T/ZTiPptkaYKTQCkcATd0Pvsm/Bvn1ZOBO0CN9gPYBvBrPe/eLrU9fMZsSF
         6u3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IA/Nfnvsktst34eWNe42G7OMd7iCZuXBerNp7A17zbY=;
        b=by+TpwBrbFTK5rpYAoMCbfm4nsKjlF9x+hkdcES53ySYMp7y6TTVdvcpDs87iwI8tQ
         fzvOS1APd10W4xawdPcLYFjhnIGX9ZC3AdhTIwTTUvawDvkTCmjdBvpGqVXy4aih+jJU
         TqudShqne2hOOqFhIYBFpKEfRaKxfEdqgQKwvKC8XKjOjMVIE7DbwQh0UaSDbjnrAee7
         OQa1+7U1h34u7kOwmPHYR8b1ze8jHw8l4Uu51y7Jdo9O+vSh+6WJFqFO5n/y8sAEuYA4
         1fHJwqPcXqDdta6SaWQDJvstRPs9KlJEquD+Frp0+ynDBMSBAVxfgaXfpvBZb4PkwdSw
         cjPQ==
X-Gm-Message-State: AJIora8BAq0RKPTN6iIWJFbTi0oZxwEKpauM99Q7H6QFX5A46DdBxXRU
        KY46sVtEx6ubfGLils0KJzCKJqn6HV/OAZBSiGo=
X-Google-Smtp-Source: AGRyM1sB2F8IKuM1Kui5dwyWjR6vVs1s6Gsua5PnN1huXpL8XBqOYVeJZztD5OF+tZ7qvtBrBo8d+a9x0oLGMhg6tN0=
X-Received: by 2002:a05:6512:340c:b0:479:7236:64b3 with SMTP id
 i12-20020a056512340c00b00479723664b3mr496763lfr.653.1655319434590; Wed, 15
 Jun 2022 11:57:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220607131953.11584-1-d.bogdanov@yadro.com> <237bed01-819a-55be-5163-274fac3b61e6@oracle.com>
In-Reply-To: <237bed01-819a-55be-5163-274fac3b61e6@oracle.com>
From:   Adam Hutchinson <ajhutchin@gmail.com>
Date:   Wed, 15 Jun 2022 14:57:03 -0400
Message-ID: <CAFU8FUgwMX_d85OG+qC+qTX-NpFiSVkwBtradzAmeJW-3PCmEQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: iscsi: prefer xmit of DataOut before new cmd
To:     open-iscsi@googlegroups.com
Cc:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Is there any reason not to use time as an indicator that pending R2Ts
need to be processed?  Could R2Ts be tagged with a timestamp when
received and only given priority over new commands if the age of the
R2T at the head exceeds some configurable limit? This would guarantee
R2T will eventually be serviced even if the block layer doesn't reduce
the submission rate of new commands, it wouldn't remove the
performance benefits of the current algorithm which gives priority to
new commands and it would be a relatively simple solution.  A
threshold of 0 could indicate that R2Ts should always be given
priority over new commands. Just a thought..

Regards,
Adam

On Wed, Jun 15, 2022 at 11:37 AM Mike Christie
<michael.christie@oracle.com> wrote:
>
> On 6/7/22 8:19 AM, Dmitry Bogdanov wrote:
> > In function iscsi_data_xmit (TX worker) there is walking through the
> > queue of new SCSI commands that is replenished in parallell. And only
> > after that queue got emptied the function will start sending pending
> > DataOut PDUs. That lead to DataOut timer time out on target side and
> > to connection reinstatment.
> >
> > This patch swaps walking through the new commands queue and the pending
> > DataOut queue. To make a preference to ongoing commands over new ones.
> >
> > Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
> > Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>
> Let's do this patch. I've tried so many combos of implementations and
> they all have different perf gains or losses with different workloads.
> I've already been going back and forth with myself for over a year
> (the link for my patch in the other mail was version N) and I don't
> think a common solution is going to happen.
>
> You patch fixes the bug, and I've found a workaround for my issue
> where I tweak the queue depth, so I think we will be ok.
>
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
>
> --
> You received this message because you are subscribed to the Google Groups "open-iscsi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/open-iscsi/237bed01-819a-55be-5163-274fac3b61e6%40oracle.com.



-- 
"Things turn out best for the people who make the best out of the way
things turn out." - Art Linkletter
