Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89F9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 16:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85EFD23358
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 16:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbhATQxI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 11:53:08 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:56151 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731111AbhATQnE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Jan 2021 11:43:04 -0500
Received: from [192.168.0.5] (ip5f5aed2c.dynamic.kabel-deutschland.de [95.90.237.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 848ED20645D55;
        Wed, 20 Jan 2021 17:42:12 +0100 (CET)
Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit
To:     Martin Wilck <mwilck@suse.com>, John Garry <john.garry@huawei.com>,
        Don.Brace@microchip.com, pmenzel@molgen.mpg.de,
        Kevin.Barnett@microchip.com, Scott.Teel@microchip.com,
        Justin.Lindley@microchip.com, Scott.Benesh@microchip.com,
        Gerry.Morong@microchip.com, Mahesh.Rajashekhara@microchip.com,
        hch@infradead.org, joseph.szczypek@hpe.com, POSWALD@suse.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Ming Lei <ming.lei@redhat.com>
Cc:     linux-scsi@vger.kernel.org, it+linux-scsi@molgen.mpg.de,
        gregkh@linuxfoundation.org
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
 <160763254769.26927.9249430312259308888.stgit@brunhilda>
 <ddd8bca4-2ae7-a2dc-cca6-0a2ff85a7d35@molgen.mpg.de>
 <SN6PR11MB28487527276CEBC75D36A732E1C60@SN6PR11MB2848.namprd11.prod.outlook.com>
 <85c6e1705c55fb930ac13bc939279f0d1faa526f.camel@suse.com>
 <SN6PR11MB2848C1195C65F87C910E979BE1A70@SN6PR11MB2848.namprd11.prod.outlook.com>
 <b3e4e597-779b-7c1e-0d3c-07bc3dab1bb5@huawei.com>
 <4555695d649afada5d4358485f0a146aa0848f65.camel@suse.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <f97756ca-84fc-9960-80fb-14e65986c880@molgen.mpg.de>
Date:   Wed, 20 Jan 2021 17:42:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4555695d649afada5d4358485f0a146aa0848f65.camel@suse.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19.01.21 15:12, Martin Wilck wrote:
> On Tue, 2021-01-19 at 10:33 +0000, John Garry wrote:
>>>>
>>>> Am 10.12.20 um 21:35 schrieb Don Brace:
>>>>> From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
>>>>>
>>>>> * Correct scsi-mid-layer sending more requests than
>>>>>      exposed host Q depth causing firmware ASSERT issue.
>>>>>      * Add host Qdepth counter.
>>>>
>>>> This supposedly fixes the regression between Linux 5.4 and 5.9,
>>>> which
>>>> we reported in [1].
>>>>
>>>>        kernel: smartpqi 0000:89:00.0: controller is offline:
>>>> status code
>>>> 0x6100c
>>>>        kernel: smartpqi 0000:89:00.0: controller offline
>>>>
>>>> Thank you for looking into this issue and fixing it. We are going
>>>> to
>>>> test this.
>>>>
>>>> For easily finding these things in the git history or the WWW, it
>>>> would be great if these log messages could be included (in the
>>>> future).
>>>> DON> Thanks for your suggestion. Well add them in the next time.
>>>>
>>>> Also, that means, that the regression is still present in Linux
>>>> 5.10,
>>>> released yesterday, and this commit does not apply to these
>>>> versions.
>>>>
>>>> DON> They have started 5.10-RC7 now. So possibly 5.11 or 5.12
>>>> depending when all of the patches are applied. The patch in
>>>> question
>>>> is among 28 other patches.
>>>>
>>>> Mahesh, do you have any idea, what commit caused the regression
>>>> and
>>>> why the issue started to show up?
>>>> DON> The smartpqi driver sets two scsi_host_template member
>>>> fields:
>>>> .can_queue and .nr_hw_queues. But we have not yet converted to
>>>> host_tagset. So the queue_depth becomes nr_hw_queues * can_queue,
>>>> which is more than the hw can support. That can be verified by
>>>> looking
>>>> at scsi_host.h.
>>>>           /*
>>>>            * In scsi-mq mode, the number of hardware queues
>>>> supported by
>>>> the LLD.
>>>>            *
>>>>            * Note: it is assumed that each hardware queue has a
>>>> queue
>>>> depth of
>>>>            * can_queue. In other words, the total queue depth per
>>>> host
>>>>            * is nr_hw_queues * can_queue. However, for when
>>>> host_tagset
>>>> is set,
>>>>            * the total queue depth is can_queue.
>>>>            */
>>>>
>>>> So, until we make this change, the queue_depth change prevents
>>>> the
>>>> above issue from happening.
>>>
>>> can_queue and nr_hw_queues have been set like this as long as the
>>> driver existed. Why did Paul observe a regression with 5.9?
>>>
>>> And why can't you simply set can_queue to (ctrl_info-
>>>> scsi_ml_can_queue / nr_hw_queues)?
>>>
>>> Don: I did this in an internal patch, but this patch seemed to work
>>> the best for our driver. HBA performance remained steady when
>>> running benchmarks.
> 
> That was a stupid suggestion on my part. Sorry.
> 
>> I guess that this is a fallout from commit 6eb045e092ef ("scsi:
>>    core: avoid host-wide host_busy counter for scsi_mq"). But that
>> commit
>> is correct.
> 
> It would be good if someone (Paul?) could verify whether that commit
> actually caused the regression they saw.

We can reliably trigger the issue with a certain load pattern on a certain hardware.

I've compiled 6eb045e092ef  and got (as with other affected kernels) "controller is offline: status code 0x6100c" after 15 minutes of the test load.
I've compiled 6eb045e092ef^ and the load is running for 3 1/2 hours now.

So you hit it.

> Looking at that 6eb045e092ef, I notice this hunk:
> 
>   
> -       busy = atomic_inc_return(&shost->host_busy) - 1;
>          if (atomic_read(&shost->host_blocked) > 0) {
> -               if (busy)
> +               if (scsi_host_busy(shost) > 0)
>                          goto starved;
> 
> Before 6eb045e092ef, the busy count was incremented with membarrier
> before looking at "host_blocked". The new code does this instead:
> 
> @ -1403,6 +1400,8 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>                  spin_unlock_irq(shost->host_lock);
>          }
>   
> +       __set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> +
> 
> but it happens *after* the "host_blocked" check. Could that perhaps
> have caused the regression?

I'm not into this and can't comment on that. But if you need me to test any patch for verification, I'll certainly can do that.

Best
   Donald

>
> 
> Thanks
> Martin
> 
