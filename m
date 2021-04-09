Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E56C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 06:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C158610F7
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 06:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhDIGBH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 02:01:07 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:45507 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhDIGBG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 02:01:06 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 82DD92EA050;
        Fri,  9 Apr 2021 02:00:53 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id aJbgcIIVp0dE; Fri,  9 Apr 2021 01:41:57 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id B9FA52EA028;
        Fri,  9 Apr 2021 02:00:52 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v17 44/45] sg: add blk_poll support
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20210408014531.248890-1-dgilbert@interlog.com>
 <20210408014531.248890-45-dgilbert@interlog.com>
 <de77707e-a4dc-78f8-43a3-48c90f2eec5a@suse.de>
 <0e12db0f-b15c-c788-3207-b204a052bd04@interlog.com>
Message-ID: <b1070c9e-b686-493f-6bde-cb6f63e6de8d@interlog.com>
Date:   Fri, 9 Apr 2021 02:00:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0e12db0f-b15c-c788-3207-b204a052bd04@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-08 12:28 p.m., Douglas Gilbert wrote:
> On 2021-04-08 4:14 a.m., Hannes Reinecke wrote:
>> On 4/8/21 3:45 AM, Douglas Gilbert wrote:
<snip>

>>> +/*
>>> + * If the sg_request object is not inflight, return -ENODATA. This function
>>> + * returns 1 if the given object was in inflight state and is in await_rcv
>>> + * state after blk_poll() returns 1 or more. If blk_poll() fails, then that
>>> + * (negative) value is returned. Otherwise returns 0. Note that blk_poll()
>>> + * may complete unrelated requests that share the same q and cookie.
>>> + */
>>> +static int
>>> +sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q, int 
>>> loop_count)
>>> +{
>>> +    int k, n, num;
>>> +
>>> +    num = (loop_count < 1) ? 1 : loop_count;
>>> +    for (k = 0; k < num; ++k) {
>>> +        if (atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)
>>> +            return -ENODATA;
>>> +        n = blk_poll(q, srp->cookie, loop_count < 0 /* spin if negative */);
>>> +        if (n > 0)
>>> +            return atomic_read(&srp->rq_st) == SG_RS_AWAIT_RCV;
>>
>> That _technically_ is a race condition;
>> the first atomic_read() call might return a different value than the second one.
>> And this arguably is a mis-use of atomic _counters_, as here they are just 
>> used to store fixed values, not counters per se.
>> Why not use 'READ/WRITE_ONCE' ?
> 
> Here is what I found in testing:
> 
>          thread 1                     thread 2
>          [want sr1p compl.]          [want sr2p compl.]
>         ===============================================
>          sr1p INFLIGHT                sr2p INFLIGHT
>          blk_poll(cookie)
>              -> 1 (sr2p -> AWAIT)
>          sr1p not in AWAIT
>              so return 0
>                                       blk_poll(cookie)
>                                         ->1 (sr1p -> AWAIT)
>                                       sr2p is in AWAIT
>                                          so return 1
>           [called again]
>           sr1p not INFLIGHT
>              so returns -ENODATA
> 
> Assuming the caller in thread 1 was sg_wait_event_srp() then
> an -ENODATA return is interpreted as found one (and a check is
> done for the AWAIT state and if not -EPROTO is returned to the
> user).
> 
> So both threads have found their requests have been completed
> so all is well programmatically. But blk_poll(), which becomes
> mq_poll() to the LLD, found completions other than what the sg
> driver (or other ULD) was looking for since both requests were
> on the same (hardware) queue.
> 
> Whenever blk_poll() returns > 0, I believe the question of a before
> and after race is moot. That is because blk_poll() has done a lot
> of work when it returns > 0 including the possibility of changing
> the state of the current request (in the current thread). It has:
>    - visited the LLD which has completed at least one outstanding
>      request on given q/cookie
>    - told the block layer it has completed 1 or more requests
>    - the block layer completion code:
>        - calls the scsi mid-level completion code
>           - calls the scsi ULD completion code
> 
>  From my testing without that recently added line:
>      return atomic_read(&srp->rq_st) == SG_RS_AWAIT_RCV;
> 
> then test code with a single thread won't fail, two threads will seldom
> fail (by incorrectly believing its srp has completed just because
> blk_poll() completed _something_ in the window it was looking in).
> And the failure rate will increase with the number of threads
> running.

Stepping back from the details, this is all new stuff (i.e. iopoll/
blk_poll in the scsi subsystem). The patches it depends on by Kashyap
Desai haven't hit the mainline yet. My testing is based on a patch
in the scsi_debug driver modelling the way I think it will work. My
megaraid hardware is from the previous century (or close to it) so
I doubt that I can test it on real hardware in the short term.

Plus I believe iopoll/blk_poll will work async (or at least I haven't
found a reason why not) but all the blk_poll() code I have found
in the kernel is only sync.

Somewhat related to this discussion I have found a new issue that
I would like to fix. So I plan to have a version 18 . Plus I have
been changing http to https in the various links to my documentation.

Doug Gilbert
