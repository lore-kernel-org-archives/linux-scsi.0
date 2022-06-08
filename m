Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DD6C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 18:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbiFHS0L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 14:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiFHS0K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 14:26:10 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8BA26C0C1
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 11:26:08 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id y32so34475243lfa.6
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 11:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=E8E5jutWOLdqIIqMeKsLiQylZWdq1gdhJQksMVW9Z9M=;
        b=HZENjhZssECG5yhMJd99yCGaZ4EUmlP/4NgG0/MplF6zchUXAFTfPMaAYha7f2JxW6
         oYXZdXRr2qiVn1Y9rdVBtKUNRFExSB1PKWaLCI/PFNwj42M4r38jY77vuBHdpltevzaX
         Ybzt+vbX1NuvgDGBsB4rvEt/27kYZsQD6CVEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=E8E5jutWOLdqIIqMeKsLiQylZWdq1gdhJQksMVW9Z9M=;
        b=FdpdWb2BjPPt2E9L32MOpijHXTbpy5Lu6PW+DmVHBWN1R7AwTOIyNJtn4XrPviEFlJ
         Fb1Y0K2mpk9v/GQY0Jq6koiEXllCMOs18U8VgCXT1tSPK/Jr8AUps5yw/4h5q+Oa/Yew
         yBuxI7PH3Ic1Mnay1sIQDevWS8sidJkJJFjGw1m5QDzQILaSDaR1w1zE4x+nPpFiQAyj
         vLeDYvalq7V7+dK4t/3/WHDXx2luG2+yo1K5uHsVmaiQxKvmNceH2VcqrDULlQy0whOg
         BkoiOdpthicUtYy2gY+vlJc6pttz+1y4we1/y8G2SBaLuLpV0Hni3dp4HiuJi4BSt9+H
         mcrA==
X-Gm-Message-State: AOAM533GYxYB+5coRzu9qzXULxiODLMH5v5YRdnKK5T9bfrMZUDewvmA
        VPYiB9/OsudPN5+WGwRfrgS6sf311VXF0PxHEjju51JkitjuXA==
X-Google-Smtp-Source: ABdhPJw9rgAtMwfmxIQTSpZKzMSrv9n5qnfp36uYEziQ+31/Pi1bGW7PdfLtDn6q3+692Sw34NBBF9h3eKmLYV1xad8=
X-Received: by 2002:a05:6512:39c1:b0:44a:e25d:47fd with SMTP id
 k1-20020a05651239c100b0044ae25d47fdmr21905467lfu.580.1654712766449; Wed, 08
 Jun 2022 11:26:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220607195800.43485-1-brian@purestorage.com> <773e57f47ecfe98d2a89fb0611696a754c55505f.camel@suse.com>
In-Reply-To: <773e57f47ecfe98d2a89fb0611696a754c55505f.camel@suse.com>
From:   Brian Bunker <brian@purestorage.com>
Date:   Wed, 8 Jun 2022 11:25:55 -0700
Message-ID: <CAHZQxyKSBrtbkObq4+JJOaM-6r5teuF=02r=vVWx8c56TnhqDQ@mail.gmail.com>
Subject: Re: [PATCH] scsi_lib: Don't fail the path in ALUA transition state
To:     Martin Wilck <martin.wilck@suse.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>I believe these retries should be skipped by returning SUCCESS from
alua_check_sense(). But that can be done in a separate patch.
Maybe. There might be targets that return ALUA state transition for
such a short interval that they could still be helped by the
needs_retry. For us those retries don't really help since our
transition time is in the order of a few seconds.

>I agree, meanwhile :-) We still have to see how this works together
with dm-multipath, for different storage devices with different
transitioning semantics.
I don't think it will be a problem. Until pretty recently, the ALUA
transition state just returned BLK_STS_RESOURCE in the prep_fn which
led to the commands not even being sent to the target while in that
state. So with this patch the requests will be sent to the target at 1
second intervals as long as the target responds with transitioning
state. The experience for the multipath layer will be the same as it
was before the patch to fix the misbehaving targets that stayed in the
transition state too long leading us to this point. With this patch,
the misbehaving targets are still handled, but the path is continually
retried up to the transition timeout which I think is the right thing
to do.

>Note that this would change with Hannes' latest patch.
("scsi_dh_alua: mark port group as failed after ALUA transitioning
timeout").
This will still result in a path failure when the transition timeout
is exceeded I think.

Thanks,
Brian
On Wed, Jun 8, 2022 at 10:13 AM Martin Wilck <martin.wilck@suse.com> wrote:
>
> On Tue, 2022-06-07 at 12:58 -0700, Brian Bunker wrote:
> > The error path for the SCSI check condition of not ready, target in
> > ALUA state transition, will result in the failure of that path after
> > the retries are exhausted. In most cases that is well ahead of the
> > transition timeout established in the SCSI ALUA device handler.
> >
> > Instead, reprep the command and re-add it to the queue after a 1
> > second
> > delay. This will allow the handler to take care of the timeout and
> > only fail the path in the transition state if the target has exceeded
> > the transition timeout (default 60 seconds).
> >
> > Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> > Acked-by: Seamus Connor <sconnor@purestorage.com>
> > Signed-off-by: Brian Bunker <brian@purestorage.com>
>
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>
> > ---
> >  drivers/scsi/scsi_lib.c | 44 +++++++++++++++++++++++----------------
> > --
> >  1 file changed, 25 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 6ffc9e4258a8..1afb267ff9a2 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -118,7 +118,7 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int
> > reason)
> >         }
> >  }
> >
> > -static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
> > +static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd, unsigned long
> > msecs)
> >  {
> >         struct request *rq = scsi_cmd_to_rq(cmd);
> >
> > @@ -128,7 +128,12 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd
> > *cmd)
> >         } else {
> >                 WARN_ON_ONCE(true);
> >         }
> > -       blk_mq_requeue_request(rq, true);
> > +
> > +       if (msecs) {
> > +               blk_mq_requeue_request(rq, false);
> > +               blk_mq_delay_kick_requeue_list(rq->q, msecs);
> > +       } else
> > +               blk_mq_requeue_request(rq, true);
> >  }
> >
> >  /**
> > @@ -658,14 +663,6 @@ static unsigned int scsi_rq_err_bytes(const
> > struct request *rq)
> >         return bytes;
> >  }
> >
> > -/* Helper for scsi_io_completion() when "reprep" action required. */
> > -static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
> > -                                     struct request_queue *q)
> > -{
> > -       /* A new command will be prepared and issued. */
> > -       scsi_mq_requeue_cmd(cmd);
> > -}
> > -
> >  static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
> >  {
> >         struct request *req = scsi_cmd_to_rq(cmd);
> > @@ -683,14 +680,21 @@ static bool scsi_cmd_runtime_exceeced(struct
> > scsi_cmnd *cmd)
> >         return false;
> >  }
> >
> > +/*
> > + * When ALUA transition state is returned, reprep the cmd to
> > + * use the ALUA handlers transition timeout. Delay the reprep
> > + * 1 sec to avoid aggressive retries of the target in that
> > + * state.
> > + */
> > +#define ALUA_TRANSITION_REPREP_DELAY   1000
> > +
> >  /* Helper for scsi_io_completion() when special action required. */
> >  static void scsi_io_completion_action(struct scsi_cmnd *cmd, int
> > result)
> >  {
> > -       struct request_queue *q = cmd->device->request_queue;
> >         struct request *req = scsi_cmd_to_rq(cmd);
> >         int level = 0;
> > -       enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
> > -             ACTION_DELAYED_RETRY} action;
> > +       enum {ACTION_FAIL, ACTION_REPREP, ACTION_DELAYED_REPREP,
> > +             ACTION_RETRY, ACTION_DELAYED_RETRY} action;
> >         struct scsi_sense_hdr sshdr;
> >         bool sense_valid;
> >         bool sense_current = true;      /* false implies "deferred
> > sense" */
> > @@ -779,8 +783,8 @@ static void scsi_io_completion_action(struct
> > scsi_cmnd *cmd, int result)
> >                                         action =
> > ACTION_DELAYED_RETRY;
> >                                         break;
> >                                 case 0x0a: /* ALUA state transition
> > */
> > -                                       blk_stat = BLK_STS_TRANSPORT;
> > -                                       fallthrough;
> > +                                       action =
> > ACTION_DELAYED_REPREP;
> > +                                       break;
> >                                 default:
> >                                         action = ACTION_FAIL;
> >                                         break;
> > @@ -839,7 +843,10 @@ static void scsi_io_completion_action(struct
> > scsi_cmnd *cmd, int result)
> >                         return;
> >                 fallthrough;
> >         case ACTION_REPREP:
> > -               scsi_io_completion_reprep(cmd, q);
> > +               scsi_mq_requeue_cmd(cmd, 0);
> > +               break;
> > +       case ACTION_DELAYED_REPREP:
> > +               scsi_mq_requeue_cmd(cmd,
> > ALUA_TRANSITION_REPREP_DELAY);
> >                 break;
> >         case ACTION_RETRY:
> >                 /* Retry the same command immediately */
> > @@ -933,7 +940,7 @@ static int scsi_io_completion_nz_result(struct
> > scsi_cmnd *cmd, int result,
> >   * command block will be released and the queue function will be
> > goosed. If we
> >   * are not done then we have to figure out what to do next:
> >   *
> > - *   a) We can call scsi_io_completion_reprep().  The request will
> > be
> > + *   a) We can call scsi_mq_requeue_cmd().  The request will be
> >   *     unprepared and put back on the queue.  Then a new command
> > will
> >   *     be created for it.  This should be used if we made forward
> >   *     progress, or if we want to switch from READ(10) to READ(6)
> > for
> > @@ -949,7 +956,6 @@ static int scsi_io_completion_nz_result(struct
> > scsi_cmnd *cmd, int result,
> >  void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int
> > good_bytes)
> >  {
> >         int result = cmd->result;
> > -       struct request_queue *q = cmd->device->request_queue;
> >         struct request *req = scsi_cmd_to_rq(cmd);
> >         blk_status_t blk_stat = BLK_STS_OK;
> >
> > @@ -986,7 +992,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
> > unsigned int good_bytes)
> >          * request just queue the command up again.
> >          */
> >         if (likely(result == 0))
> > -               scsi_io_completion_reprep(cmd, q);
> > +               scsi_mq_requeue_cmd(cmd, 0);
> >         else
> >                 scsi_io_completion_action(cmd, result);
> >  }
>


-- 
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
