Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14637C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 15:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244423AbiFHPjm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 11:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244236AbiFHPjl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 11:39:41 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1AC1C7EF7
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 08:39:38 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id l18so15857698lje.13
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 08:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=BkCPKCsXKXc0WnUY0e9m7Ka4xt/s0uOUdtwkY4iVXKw=;
        b=c06l3hjkRFzgF9++fe7VqEQjv+xiKaGD/xniIWT0jBAsGNrxVoYCsd1yJjI4O2Vcds
         FQnUrAcfmRlMmEVGSzi1EggS37QnI3s7n6OGvsmxui36Wc7HoDYsZswNCrgkErwOerCg
         7E7EySZiLnq4sXwQZkXvnuyK6ETxnwopcpanM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=BkCPKCsXKXc0WnUY0e9m7Ka4xt/s0uOUdtwkY4iVXKw=;
        b=Yi4Zt6u069EeHk8r8/EucNko/lVVvNRIHxTlzwAYK1EnhENM7Bd77IHx0No/HTbKHM
         kwiGIGgVQnktX2HIkVXqed+VQTWzCkAoLYY+uMh24EwIJHTowM3/q+Hxv8uu/HlW1ZLd
         5hAIzq8cnS3TQG+8b9NmXSmPnjWXa1wrRwM9dGpg02mQ7e6Hs/nJetZ4RZKDvKfwun/o
         tYHmQJ6muBbRHfdqR/CIvdasT2Ulz1lQS5Izc80yzol/85dCc/QI8rP2Qj8DqYFQGDa0
         VJ8bcTyJVtrEYgdBeX9zHPLWRYBDq0161C/CoCgTGD0iJFKK8H4Kvgc/TFeIGwdANRNX
         jecA==
X-Gm-Message-State: AOAM532EpHw7OeqfbBuTpBn0OE7Hh0czy/7PEGaaA4pUdx46eJSY6EOe
        y4zzF7Sudo4/RICwQ2tOwwan1GJjWOMl5Z0trmOWo/qfKpFcJw==
X-Google-Smtp-Source: ABdhPJypdNNF3uKAbXOnjcuZt5Ac4UHUz+R0KEv+sPLPufYev99lC/p/eFm4DGOHpczn32n/+FDvvyFQmE7XsJ11LGw=
X-Received: by 2002:a2e:a5c4:0:b0:255:6c62:7c31 with SMTP id
 n4-20020a2ea5c4000000b002556c627c31mr20211469ljp.384.1654702776756; Wed, 08
 Jun 2022 08:39:36 -0700 (PDT)
MIME-Version: 1.0
References: CAHZQxy+Ou+6yVWsDug1V=so=rcehPBfoTkzD7XCbtGKLybRWwA@mail.gmail.com <20220608153543.6621CCE36@lindbergh.monkeyblade.net>
In-Reply-To: <20220608153543.6621CCE36@lindbergh.monkeyblade.net>
From:   Brian Bunker <brian@purestorage.com>
Date:   Wed, 8 Jun 2022 08:39:25 -0700
Message-ID: <CAHZQxyKVo7cTq0gGL0nckO3uGebjoDXrr7_3j-A=tJnNA40CvQ@mail.gmail.com>
Subject: Re: Undelivered Mail Returned to Sender
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Please explain how th (failing the path after the timeout) will come to
> pass.
>
> AFAICS, this means that commands will first be retried without delay
> from the mid layer (NEEDS_RETRY / maybe_retry logic in Are you relying
> scsi_decide_disposition()), until the retries are exhausted. After
> that, they'll be requeued on the high layer, with a 1s delay and
> retries reloaded. How do we make sure this doesn't go on forever?
>
> Do you rely on alua_rtpg() setting the state to STANDBY and
> alua_prep_fn() subsequently returning an error?
>
> I believe this should at least be explained more clearly with comments.
>
> Other than that, the patch looks good to me.

 The intention here is as you describe. The "needs retry" logic that
comes out of the device handler is inadequate for the multi second
ALUA transition. The "maybe retry" will retry the operation, but those
retries are all exhausted very quickly. So, yes, when the retries are
exhausted and the target is still returning ASYMMETRIC ACCESS STATE
TRANSITION, 04h/0Ah, the path should not be failed since the target is
still within its transition timer in most cases. From my
interpretation of the SPC specification, failing the path so quickly
is incorrect.

After the initial retries are exhausted, the command is re-prepped and
returns to the device handler. I added the 1 second delay so that the
initiator doesn't keep aggressively retrying that path as the
transition state can last for some time. The device_handler will take
care of setting the path state to standby, as you stated above, and an
error is returned should the transition timer expire during this
re-prep looping from its prep_fn. This will satisfy the concern of a
misbehaving target that stays in the transition state too long. If the
transition timer does not fire, which will be the case I would expect
virtually all of the time, the request will succeed or fail once the
port group enters either an active or error state post transition
state.

Thanks,
Brian

> On Wed, Jun 8, 2022 at 8:28 AM Brian Bunker <brian@purestorage.com> wrote:
>>
>> > Please explain how th (failing the path after the timeout) will come to
>> > pass.
>> >
>> > AFAICS, this means that commands will first be retried without delay
>> > from the mid layer (NEEDS_RETRY / maybe_retry logic in Are you relying
>> > scsi_decide_disposition()), until the retries are exhausted. After
>> > that, they'll be requeued on the high layer, with a 1s delay and
>> > retries reloaded. How do we make sure this doesn't go on forever?
>> >
>> > Do you rely on alua_rtpg() setting the state to STANDBY and
>> > alua_prep_fn() subsequently returning an error?
>> >
>> > I believe this should at least be explained more clearly with comments.
>> >
>> > Other than that, the patch looks good to me.
>> The intention here is as you describe. The "needs retry" logic that
>> comes out of the device handler is inadequate for the multi second
>> ALUA transition. The "maybe retry" will retry the operation, but those
>> retries are all exhausted very quickly. So, yes, when the retries are
>> exhausted and the target is still returning ASYMMETRIC ACCESS STATE
>> TRANSITION, 04h/0Ah, the path should not be failed since the target is
>> still within its transition timer in most cases. From my
>> interpretation of the SPC specification, failing the path so quickly
>> is incorrect.
>>
>> After the initial retries are exhausted, the command is re-prepped and
>> returns to the device handler. I added the 1 second delay so that the
>> initiator doesn't keep aggressively retrying that path as the
>> transition state can last for some time. The device_handler will take
>> care of setting the path state to standby, as you stated above, and an
>> error is returned should the transition timer expire during this
>> re-prep looping from its prep_fn. This will satisfy the concern of a
>> misbehaving target that stays in the transition state too long. If the
>> transition timer does not fire, which will be the case I would expect
>> virtually all of the time, the request will succeed or fail once the
>> port group enters either an active or error state post transition
>> state.
>>
>>
>> On Wed, Jun 8, 2022 at 12:45 AM Martin Wilck <martin.wilck@suse.com> wrote:
>> >
>> > On Tue, 2022-06-07 at 12:58 -0700, Brian Bunker wrote:
>> > > The error path for the SCSI check condition of not ready, target in
>> > > ALUA state transition, will result in the failure of that path after
>> > > the retries are exhausted. In most cases that is well ahead of the
>> > > transition timeout established in the SCSI ALUA device handler.
>> > >
>> > > Instead, reprep the command and re-add it to the queue after a 1
>> > > second
>> > > delay. This will allow the handler to take care of the timeout and
>> > > only fail the path in the transition state if the target has exceeded
>> > > the transition timeout (default 60 seconds).
>> > >
>> >
>> > Please explain how th (failing the path after the timeout) will come to
>> > pass.
>> >
>> > AFAICS, this means that commands will first be retried without delay
>> > from the mid layer (NEEDS_RETRY / maybe_retry logic in Are you relying
>> > scsi_decide_disposition()), until the retries are exhausted. After
>> > that, they'll be requeued on the high layer, with a 1s delay and
>> > retries reloaded. How do we make sure this doesn't go on forever?
>> >
>> > Do you rely on alua_rtpg() setting the state to STANDBY and
>> > alua_prep_fn() subsequently returning an error?
>> >
>> > I believe this should at least be explained more clearly with comments.
>> >
>> > Other than that, the patch looks good to me.
>> >
>> > Regards
>> > Martin
>> >
>> >
>> > > Acked-by: Krishna Kant <krishna.kant@purestorage.com>
>> > > Acked-by: Seamus Connor <sconnor@purestorage.com>
>> > > Signed-off-by: Brian Bunker <brian@purestorage.com>
>> > > ---
>> > >  drivers/scsi/scsi_lib.c | 44 +++++++++++++++++++++++----------------
>> > > --
>> > >  1 file changed, 25 insertions(+), 19 deletions(-)
>> > >
>> >
>> >
>> >
>> >
>> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> > > index 6ffc9e4258a8..1afb267ff9a2 100644
>> > > --- a/drivers/scsi/scsi_lib.c
>> > > +++ b/drivers/scsi/scsi_lib.c
>> > > @@ -118,7 +118,7 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int
>> > > reason)
>> > >         }
>> > >  }
>> > >
>> > > -static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
>> > > +static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd, unsigned long
>> > > msecs)
>> > >  {
>> > >         struct request *rq = scsi_cmd_to_rq(cmd);
>> > >
>> > > @@ -128,7 +128,12 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd
>> > > *cmd)
>> > >         } else {
>> > >                 WARN_ON_ONCE(true);
>> > >         }
>> > > -       blk_mq_requeue_request(rq, true);
>> > > +
>> > > +       if (msecs) {
>> > > +               blk_mq_requeue_request(rq, false);
>> > > +               blk_mq_delay_kick_requeue_list(rq->q, msecs);
>> > > +       } else
>> > > +               blk_mq_requeue_request(rq, true);
>> > >  }
>> > >
>> > >  /**
>> > > @@ -658,14 +663,6 @@ static unsigned int scsi_rq_err_bytes(const
>> > > struct request *rq)
>> > >         return bytes;
>> > >  }
>> > >
>> > > -/* Helper for scsi_io_completion() when "reprep" action required. */
>> > > -static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
>> > > -                                     struct request_queue *q)
>> > > -{
>> > > -       /* A new command will be prepared and issued. */
>> > > -       scsi_mq_requeue_cmd(cmd);
>> > > -}
>> > > -
>> > >  static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
>> > >  {
>> > >         struct request *req = scsi_cmd_to_rq(cmd);
>> > > @@ -683,14 +680,21 @@ static bool scsi_cmd_runtime_exceeced(struct
>> > > scsi_cmnd *cmd)
>> > >         return false;
>> > >  }
>> > >
>> > > +/*
>> > > + * When ALUA transition state is returned, reprep the cmd to
>> > > + * use the ALUA handlers transition timeout. Delay the reprep
>> > > + * 1 sec to avoid aggressive retries of the target in that
>> > > + * state.
>> > > + */
>> > > +#define ALUA_TRANSITION_REPREP_DELAY   1000
>> > > +
>> > >  /* Helper for scsi_io_completion() when special action required. */
>> > >  static void scsi_io_completion_action(struct scsi_cmnd *cmd, int
>> > > result)
>> > >  {
>> > > -       struct request_queue *q = cmd->device->request_queue;
>> > >         struct request *req = scsi_cmd_to_rq(cmd);
>> > >         int level = 0;
>> > > -       enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
>> > > -             ACTION_DELAYED_RETRY} action;
>> > > +       enum {ACTION_FAIL, ACTION_REPREP, ACTION_DELAYED_REPREP,
>> > > +             ACTION_RETRY, ACTION_DELAYED_RETRY} action;
>> > >         struct scsi_sense_hdr sshdr;
>> > >         bool sense_valid;
>> > >         bool sense_current = true;      /* false implies "deferred
>> > > sense" */
>> > > @@ -779,8 +783,8 @@ static void scsi_io_completion_action(struct
>> > > scsi_cmnd *cmd, int result)
>> > >                                         action =
>> > > ACTION_DELAYED_RETRY;
>> > >                                         break;
>> > >                                 case 0x0a: /* ALUA state transition
>> > > */
>> > > -                                       blk_stat = BLK_STS_TRANSPORT;
>> > > -                                       fallthrough;
>> > > +                                       action =
>> > > ACTION_DELAYED_REPREP;
>> > > +                                       break;
>> > >                                 default:
>> > >                                         action = ACTION_FAIL;
>> > >                                         break;
>> > > @@ -839,7 +843,10 @@ static void scsi_io_completion_action(struct
>> > > scsi_cmnd *cmd, int result)
>> > >                         return;
>> > >                 fallthrough;
>> > >         case ACTION_REPREP:
>> > > -               scsi_io_completion_reprep(cmd, q);
>> > > +               scsi_mq_requeue_cmd(cmd, 0);
>> > > +               break;
>> > > +       case ACTION_DELAYED_REPREP:
>> > > +               scsi_mq_requeue_cmd(cmd,
>> > > ALUA_TRANSITION_REPREP_DELAY);
>> > >                 break;
>> > >         case ACTION_RETRY:
>> > >                 /* Retry the same command immediately */
>> > > @@ -933,7 +940,7 @@ static int scsi_io_completion_nz_result(struct
>> > > scsi_cmnd *cmd, int result,
>> > >   * command block will be released and the queue function will be
>> > > goosed. If we
>> > >   * are not done then we have to figure out what to do next:
>> > >   *
>> > > - *   a) We can call scsi_io_completion_reprep().  The request will
>> > > be
>> > > + *   a) We can call scsi_mq_requeue_cmd().  The request will be
>> > >   *     unprepared and put back on the queue.  Then a new command
>> > > will
>> > >   *     be created for it.  This should be used if we made forward
>> > >   *     progress, or if we want to switch from READ(10) to READ(6)
>> > > for
>> > > @@ -949,7 +956,6 @@ static int scsi_io_completion_nz_result(struct
>> > > scsi_cmnd *cmd, int result,
>> > >  void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int
>> > > good_bytes)
>> > >  {
>> > >         int result = cmd->result;
>> > > -       struct request_queue *q = cmd->device->request_queue;
>> > >         struct request *req = scsi_cmd_to_rq(cmd);
>> > >         blk_status_t blk_stat = BLK_STS_OK;
>> > >
>> > > @@ -986,7 +992,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
>> > > unsigned int good_bytes)
>> > >          * request just queue the command up again.
>> > >          */
>> > >         if (likely(result == 0))
>> > > -               scsi_io_completion_reprep(cmd, q);
>> > > +               scsi_mq_requeue_cmd(cmd, 0);
>> > >         else
>> > >                 scsi_io_completion_action(cmd, result);
>> > >  }
>> >
>>
>>
>> --
>> Brian Bunker
>> PURE Storage, Inc.
>> brian@purestorage.com
>
>
>
> --
> Brian Bunker
> PURE Storage, Inc.
> brian@purestorage.com



-- 
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
