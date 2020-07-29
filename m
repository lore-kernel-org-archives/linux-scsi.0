Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9321BC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 06:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 773462070B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 06:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgG2GJq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 02:09:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:47546 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbgG2GJq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 02:09:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9D82CAD6A;
        Wed, 29 Jul 2020 06:09:55 +0000 (UTC)
Subject: Re: [PATCH] scsi_transport_srp: sanitize scsi_target_block/unblock
 sequences
To:     Laurence Oberman <loberman@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <20200728134833.42547-1-hare@suse.de>
 <d8c4f8e27ff77b85588ee237b2b3e408c91839c7.camel@redhat.com>
 <da14033928b356c5691187f819f8e6101901dafd.camel@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <cd1037d9-cbca-0e6d-69e3-f188b34b9d20@suse.de>
Date:   Wed, 29 Jul 2020 08:09:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <da14033928b356c5691187f819f8e6101901dafd.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/28/20 9:50 PM, Laurence Oberman wrote:
> On Tue, 2020-07-28 at 14:43 -0400, Laurence Oberman wrote:
>> On Tue, 2020-07-28 at 15:48 +0200, Hannes Reinecke wrote:
>>> The SCSI midlayer does not allow state transitions from SDEV_BLOCK
>>> to SDEV_BLOCK, so calling scsi_target_block() from
>>> __rport_fast_io_fail()
>>> is wrong as the port is already blocked.
>>> Similarly we don't need to call scsi_target_unblock() afterwards as
>>> the
>>> function has already done this.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>   drivers/scsi/scsi_transport_srp.c | 12 +++++-------
>>>   1 file changed, 5 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_transport_srp.c
>>> b/drivers/scsi/scsi_transport_srp.c
>>> index d4d1104fac99..cba1cf6a1c12 100644
>>> --- a/drivers/scsi/scsi_transport_srp.c
>>> +++ b/drivers/scsi/scsi_transport_srp.c
>>> @@ -395,6 +395,10 @@ static void srp_reconnect_work(struct
>>> work_struct *work)
>>>   	}
>>>   }
>>>   
>>> +/*
>>> + * scsi_target_block() must have been called before this function
>>> is
>>> + * called to guarantee that no .queuecommand() calls are in
>>> progress.
>>> + */
>>>   static void __rport_fail_io_fast(struct srp_rport *rport)
>>>   {
>>>   	struct Scsi_Host *shost = rport_to_shost(rport);
>>> @@ -404,11 +408,7 @@ static void __rport_fail_io_fast(struct
>>> srp_rport *rport)
>>>   
>>>   	if (srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST))
>>>   		return;
>>> -	/*
>>> -	 * Call scsi_target_block() to wait for ongoing shost-
>>>> queuecommand()
>>>
>>> -	 * calls before invoking i->f->terminate_rport_io().
>>> -	 */
>>> -	scsi_target_block(rport->dev.parent);
>>> +
>>>   	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
>>>   
>>>   	/* Involve the LLD if possible to terminate all I/O on the
>>> rport. */
>>> @@ -570,8 +570,6 @@ int srp_reconnect_rport(struct srp_rport
>>> *rport)
>>>   		 * failure timers if these had not yet been started.
>>>   		 */
>>>   		__rport_fail_io_fast(rport);
>>> -		scsi_target_unblock(&shost->shost_gendev,
>>> -				    SDEV_TRANSPORT_OFFLINE);
>>>   		__srp_start_tl_fail_timers(rport);
>>>   	} else if (rport->state != SRP_RPORT_BLOCKED) {
>>>   		scsi_target_unblock(&shost->shost_gendev,
>>
>> This looks OK to me but I guess its alwasy worked by just ignoring it
>> being called or IU would have seenm issues.
>> I etest that stuff pretty heavily.
>> Reviewed-by: Laurence Oberman <loberman@redhat.com>
>>
> 
> Ouch, my last message saw my bad touch typing creep in. Let me try
> again.
> 
> This looks OK to me but I guess its always worked by just ignoring it
> being called or I would have seen issues already.
> I test that stuff pretty heavily and regularly.
> 
> Reviewed-by: Laurence Oberman <loberman@redhat.com>
> 
> 
Well, we've had a customer running into it.
And they do _heavy_ tests, too.

I haven't said it's a regular occurrence :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
