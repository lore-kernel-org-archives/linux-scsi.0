Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9148DC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 16:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244990AbiFHQDq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244958AbiFHQDf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 12:03:35 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C26253FF1
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 09:03:33 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q12-20020a17090a304c00b001e2d4fb0eb4so24191646pjl.4
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 09:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:content-transfer-encoding:mime-version:subject:date:references
         :to:in-reply-to:message-id;
        bh=56eElmp6N/tHcfY1sMkzfDYY4nMzbz8qj7/krHM3Xgo=;
        b=VRufC1Nee7V+2Eq00TxpMofpQCY4Wq3nvlcfoJLTRmZBuLhDFNqtcYw8+ZmRp35K/q
         KUiV145xWD674s+Z68Emj/Y+2AlPN6evU5MjVC5zZ/sjGx6xsaqccx/r5s+MnvcjhIj+
         jLkeve7CcdW0W/J5UbBDfIk8Hx9RVnHdUfSv0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:date:references:to:in-reply-to:message-id;
        bh=56eElmp6N/tHcfY1sMkzfDYY4nMzbz8qj7/krHM3Xgo=;
        b=yeUq9jU7OwIHwcJfelmUoJpCXG0HNZTAUoRrLI/iKe+UNZ7g7fPYp5wuom+SVJDhCt
         kEZrzVWbVuPROyUOlK5/cwysbyGd0wK6cn1YWUJ8SWAO0pfcHzhZ+/Mid9N7yok/Azy3
         FIv4ygzd/VR60bEvumDf/9kEdX2PkUSDV+jjdKtJ2HyzYBSgJo84ptswch5azsXHcits
         y+JRAo0hy6wVPEGPQBsYG8fBEHW2wVvUo4YuGXZnsFxz0iqgHgq6NLH1h/LzR7e1SKGY
         DFw4JLzBfgr4OgjJuWakC9K8OcA8qe6JMuYqzfzRqU7YGQW0JpQXFm3p3wTz8VCQnfCI
         zKEg==
X-Gm-Message-State: AOAM532KDYHqQ/AxNbyeFl3kXpQdzz3uTZQoMNdu3nmTmZC/k2jygjze
        QnEXhcLRBSfzJHSLRJP9ChUhOuK666urUSUPovS2ro9Y5ATn1gRn9t7jztffMgEoK6N6uKnssWa
        kl7AjgS0URWwqm668PfiZPNkvgz3pYPN18uLtgaVLW+L+fF0ldCGROIchp628cWrijkFpXwT2O+
        Q2
X-Google-Smtp-Source: ABdhPJwcKNBAp/5o9tW/K2uojzAVSVka+fhd1cr/dzXtYzgT7XkJ8QUJBSz/ywNGC0vOWevg0+EJyQ==
X-Received: by 2002:a17:90b:1e42:b0:1e8:7669:8a1c with SMTP id pi2-20020a17090b1e4200b001e876698a1cmr20091286pjb.206.1654704212581;
        Wed, 08 Jun 2022 09:03:32 -0700 (PDT)
Received: from smtpclient.apple (vpn.purestorage.com. [192.30.189.1])
        by smtp.gmail.com with ESMTPSA id w10-20020aa7858a000000b0051bce5dc754sm12988384pfn.194.2022.06.08.09.03.31
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jun 2022 09:03:31 -0700 (PDT)
From:   Brian Bunker <brian@purestorage.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] scsi_lib: Don't fail the path in ALUA transition state
Date:   Wed, 8 Jun 2022 09:03:30 -0700
References: <20220607195800.43485-1-brian@purestorage.com>
 <0f741edf62532dbccb25ac5b9fab5031fdbbcd67.camel@suse.com>
To:     linux-scsi@vger.kernel.org
In-Reply-To: <0f741edf62532dbccb25ac5b9fab5031fdbbcd67.camel@suse.com>
Message-Id: <FBC92B92-7923-4EEC-8A41-1F6F28628BD8@purestorage.com>
X-Mailer: Apple Mail (2.3696.100.31)
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
> 
> Regards
> Martin
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
> On Jun 8, 2022, at 12:44 AM, Martin Wilck <Martin.Wilck@suse.com> wrote:
> 
> On Tue, 2022-06-07 at 12:58 -0700, Brian Bunker wrote:
>> The error path for the SCSI check condition of not ready, target in
>> ALUA state transition, will result in the failure of that path after
>> the retries are exhausted. In most cases that is well ahead of the
>> transition timeout established in the SCSI ALUA device handler.
>> 
>> Instead, reprep the command and re-add it to the queue after a 1
>> second
>> delay. This will allow the handler to take care of the timeout and
>> only fail the path in the transition state if the target has exceeded
>> the transition timeout (default 60 seconds).
>> 
> 
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
> 
> Regards
> Martin
> 
> 
>> Acked-by: Krishna Kant <krishna.kant@purestorage.com>
>> Acked-by: Seamus Connor <sconnor@purestorage.com>
>> Signed-off-by: Brian Bunker <brian@purestorage.com>
>> ---
>>  drivers/scsi/scsi_lib.c | 44 +++++++++++++++++++++++----------------
>> --
>>  1 file changed, 25 insertions(+), 19 deletions(-)
>> 
> 
> 
> 
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 6ffc9e4258a8..1afb267ff9a2 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -118,7 +118,7 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int
>> reason)
>>         }
>>  }
>>  
>> -static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
>> +static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd, unsigned long
>> msecs)
>>  {
>>         struct request *rq = scsi_cmd_to_rq(cmd);
>>  
>> @@ -128,7 +128,12 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd
>> *cmd)
>>         } else {
>>                 WARN_ON_ONCE(true);
>>         }
>> -       blk_mq_requeue_request(rq, true);
>> +
>> +       if (msecs) {
>> +               blk_mq_requeue_request(rq, false);
>> +               blk_mq_delay_kick_requeue_list(rq->q, msecs);
>> +       } else
>> +               blk_mq_requeue_request(rq, true);
>>  }
>>  
>>  /**
>> @@ -658,14 +663,6 @@ static unsigned int scsi_rq_err_bytes(const
>> struct request *rq)
>>         return bytes;
>>  }
>>  
>> -/* Helper for scsi_io_completion() when "reprep" action required. */
>> -static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
>> -                                     struct request_queue *q)
>> -{
>> -       /* A new command will be prepared and issued. */
>> -       scsi_mq_requeue_cmd(cmd);
>> -}
>> -
>>  static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
>>  {
>>         struct request *req = scsi_cmd_to_rq(cmd);
>> @@ -683,14 +680,21 @@ static bool scsi_cmd_runtime_exceeced(struct
>> scsi_cmnd *cmd)
>>         return false;
>>  }
>>  
>> +/*
>> + * When ALUA transition state is returned, reprep the cmd to
>> + * use the ALUA handlers transition timeout. Delay the reprep
>> + * 1 sec to avoid aggressive retries of the target in that
>> + * state.
>> + */
>> +#define ALUA_TRANSITION_REPREP_DELAY   1000
>> +
>>  /* Helper for scsi_io_completion() when special action required. */
>>  static void scsi_io_completion_action(struct scsi_cmnd *cmd, int
>> result)
>>  {
>> -       struct request_queue *q = cmd->device->request_queue;
>>         struct request *req = scsi_cmd_to_rq(cmd);
>>         int level = 0;
>> -       enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
>> -             ACTION_DELAYED_RETRY} action;
>> +       enum {ACTION_FAIL, ACTION_REPREP, ACTION_DELAYED_REPREP,
>> +             ACTION_RETRY, ACTION_DELAYED_RETRY} action;
>>         struct scsi_sense_hdr sshdr;
>>         bool sense_valid;
>>         bool sense_current = true;      /* false implies "deferred
>> sense" */
>> @@ -779,8 +783,8 @@ static void scsi_io_completion_action(struct
>> scsi_cmnd *cmd, int result)
>>                                         action =
>> ACTION_DELAYED_RETRY;
>>                                         break;
>>                                 case 0x0a: /* ALUA state transition
>> */
>> -                                       blk_stat = BLK_STS_TRANSPORT;
>> -                                       fallthrough;
>> +                                       action =
>> ACTION_DELAYED_REPREP;
>> +                                       break;
>>                                 default:
>>                                         action = ACTION_FAIL;
>>                                         break;
>> @@ -839,7 +843,10 @@ static void scsi_io_completion_action(struct
>> scsi_cmnd *cmd, int result)
>>                         return;
>>                 fallthrough;
>>         case ACTION_REPREP:
>> -               scsi_io_completion_reprep(cmd, q);
>> +               scsi_mq_requeue_cmd(cmd, 0);
>> +               break;
>> +       case ACTION_DELAYED_REPREP:
>> +               scsi_mq_requeue_cmd(cmd,
>> ALUA_TRANSITION_REPREP_DELAY);
>>                 break;
>>         case ACTION_RETRY:
>>                 /* Retry the same command immediately */
>> @@ -933,7 +940,7 @@ static int scsi_io_completion_nz_result(struct
>> scsi_cmnd *cmd, int result,
>>   * command block will be released and the queue function will be
>> goosed. If we
>>   * are not done then we have to figure out what to do next:
>>   *
>> - *   a) We can call scsi_io_completion_reprep().  The request will
>> be
>> + *   a) We can call scsi_mq_requeue_cmd().  The request will be
>>   *     unprepared and put back on the queue.  Then a new command
>> will
>>   *     be created for it.  This should be used if we made forward
>>   *     progress, or if we want to switch from READ(10) to READ(6)
>> for
>> @@ -949,7 +956,6 @@ static int scsi_io_completion_nz_result(struct
>> scsi_cmnd *cmd, int result,
>>  void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int
>> good_bytes)
>>  {
>>         int result = cmd->result;
>> -       struct request_queue *q = cmd->device->request_queue;
>>         struct request *req = scsi_cmd_to_rq(cmd);
>>         blk_status_t blk_stat = BLK_STS_OK;
>>  
>> @@ -986,7 +992,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
>> unsigned int good_bytes)
>>          * request just queue the command up again.
>>          */
>>         if (likely(result == 0))
>> -               scsi_io_completion_reprep(cmd, q);
>> +               scsi_mq_requeue_cmd(cmd, 0);
>>         else
>>                 scsi_io_completion_action(cmd, result);
>>  }
> 

