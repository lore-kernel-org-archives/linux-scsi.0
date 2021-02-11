Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BA1C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 16:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB8A464E74
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 16:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhBKQOa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 11:14:30 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:60719 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbhBKQMS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 11:12:18 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id ADAE02EA572;
        Thu, 11 Feb 2021 11:11:18 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id h-rD3B4uW+6y; Thu, 11 Feb 2021 10:56:08 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id B215F2EA56C;
        Thu, 11 Feb 2021 11:11:17 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3] scsi_debug: add new defer_type for mq_poll
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>
References: <20210209225624.108341-1-dgilbert@interlog.com>
 <CAHsXFKEhiwHmMmJ00eeA1ikP3wdiJP2xggsuO0Qc9H1ogNXnVQ@mail.gmail.com>
 <c9084cf7-4f75-dc62-1927-a2695f6cc52c@interlog.com>
 <3253ac6a020bd3c36ed03519c4182250@mail.gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <9fc5ef5c-1871-c0e1-8ba6-1489c4a0656a@interlog.com>
Date:   Thu, 11 Feb 2021 11:11:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3253ac6a020bd3c36ed03519c4182250@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-11 7:13 a.m., Kashyap Desai wrote:
>> Kashyap,
>> There is another issue here, namely iodepth > host_max_queue (64 > 32) and
>> in my setup that is not handled well. So there is a problem with
>> scsi_debug
>> *** or the mid-level in handling this case.
>>
>> If you have modified the sd driver to call blk_poll() then perhaps you
>> could try
>> the above test again with a reduced iodepth.
> 
> Doug -
> 
> I debug the issue and found the fix. We need to remove below code to handle
> this new defer type for mq poll.
> Earlier I did not used " REQ_HIPRI" to handle mq poll, but now you are
> managing it through REQ_HIPRI check, it is safe and required to have below
> patch.
> 
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b9ec3a47fbf1..c50de49a2c2f 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5437,13 +5437,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd,
> struct sdebug_dev_info *devip,
>          sd_dp = sqcp->sd_dp;
>          spin_unlock_irqrestore(&sqp->qc_lock, iflags);
> 
> -       /* Do not complete IO from default completion path.
> -        * Let it to be on queue.
> -        * Completion should happen from mq_poll interface.
> -        */
> -       if ((sqp - sdebug_q_arr) >= (submit_queues - poll_queues))
> -               return 0;
> -
>          if (!sd_dp) {
>                  sd_dp = kzalloc(sizeof(*sd_dp), GFP_ATOMIC);
>                  if (!sd_dp) {
> 
> 
> On top of your v3 patch + above fix, I am able to run IO and there are no
> issues.  There is no issue with higher QD as well, so we are good to go.
> 
> Tested-by: Kashyap Desai <kashyap.desai@broadcom.com>
> 
> So how shall we progress now ? Shall I ask Martin to pick all the patches
> from " [PATCH v3 0/4] io_uring iopoll in scsi layer" since this patch has
> dependency on my series.

Kashyap,
Good catch!

You could roll all the scsi_debug stuff into one patch and put both
our sign-offs on it, or present it as two patches:
   - first one: your original plus this fix
   - second one: mine with your tested-by on it

Since this is new functionality for the scsi sub-system, it is unlikely
that all the corner cases have been visited. However, with what we have
in place for the next cycle, others have something reasonably solid to
build on.

Doug Gilbert

>> *** the scsi_debug should either yield a TASK SET FULL status or return
>>       SCSI_MLQUEUE_HOST_BUSY from queuecommand() when it has run out of
>>       slots.
>>
>>> [seqprecon]
>>> filename=/dev/sdd
>>> [seqprecon]
>>> filename=/dev/sde
>>> [seqprecon]
>>> filename=/dev/sdf
>>>
>>>
>>> I will ask Martin to pick all the patches from "[v3,1/4] add io_uring
>>> with IOPOLL support in the scsi layer" except scsi_debug. We can work
>>> on scsi_debug and send standalone patch.
>>>
>>> Kashyap

