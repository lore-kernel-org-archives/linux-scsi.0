Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF03C63777
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 07:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F0320684
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 07:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgKXHNb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 02:13:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:38376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729734AbgKXHNa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Nov 2020 02:13:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CB7B5AD3F;
        Tue, 24 Nov 2020 07:13:28 +0000 (UTC)
Subject: Re: [PATCH v3 7/9] scsi_transport_spi: Freeze request queues instead
 of quiescing
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Stan Johnson <userm57@yahoo.com>
References: <20201123031749.14912-1-bvanassche@acm.org>
 <20201123031749.14912-8-bvanassche@acm.org>
 <12338292-47f8-8d1f-2c80-77912f030932@suse.de>
 <47d1d945-39da-50dc-ef2a-78e92d521d15@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <de3dea38-5824-ee40-06f1-20c699965be4@suse.de>
Date:   Tue, 24 Nov 2020 08:13:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <47d1d945-39da-50dc-ef2a-78e92d521d15@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/24/20 6:09 AM, Bart Van Assche wrote:
> On 11/22/20 11:02 PM, Hannes Reinecke wrote:
>> On 11/23/20 4:17 AM, Bart Van Assche wrote:
>>> Instead of quiescing the request queues involved in domain validation,
>>> freeze these. As a result, the struct request_queue pm_only member is no
>>> longer set during domain validation. That will allow to modify
>>> scsi_execute() such that it stops setting the BLK_MQ_REQ_PREEMPT flag.
>>> Three additional changes in this patch are that scsi_mq_alloc_queue() is
>>> exported, that scsi_device_quiesce() is no longer exported and that
>>> scsi_target_{quiesce,resume}() have been changed into
>>> scsi_target_{freeze,unfreeze}().
>>>
>> The description is now partially wrong, as scsi_mq_alloc_queue() is
>> certainly not exported (why would it?).
>>
>> And it also glosses over the main idea of this patch, namely that not
>> only sdev->request_queue is frozen, but also a completely _new_
>> request queue is allocated to send SPI DV requests over.
>>
>> Please modify the description.
> 
> Hi Hannes,
> 
> Thanks for the feedback. Please take a look at the attached patch.
> 
>>> +    q2 = scsi_mq_alloc_queue(sdev);
>>> +
>>> +    if (q2) {
>>> +        /*
>>> +         * Freeze the target such that no other subsystem can submit
>>> +         * SCSI commands to 'sdev'. Submitting SCSI commands through
>>> +         * q2 may trigger the SCSI error handler. The SCSI error
>>> +         * handler must be able to handle a frozen sdev->request_queue
>>> +         * and must also use blk_mq_rq_from_pdu(q2)->q instead of
>>> +         * sdev->request_queue if it would be necessary to access q2
>>> +         * directly.
>>> +         */
>>
>> ... 'it would be necessary' indicates that it doesn't do so, currently.
>> And the SPI DV code most certainly _is_ submitting SCSI commands.
>> So doesn't the above imply that SCSI EH will fail to work correctly?
>> And if so, why isn't it fixed with some later patch in this series?
>> Or how do you plan to address it?
>> Hmm?
> 
> Before SPI domain validation starts, sdev->request_queue is frozen which
> means that DV will only start after all pending SCSI commands have
> finished, including potential error handling for these commands.
> 
> As far as I know there is only one sdev->request_queue access in the
> SCSI error handler, namely in scsi_eh_lock_door(). Patch 5/9 from this
> series makes the blk_get_request() call in that function use
> BLK_MQ_REQ_NOWAIT so the SCSI error handler should still work fine if a
> DV command fails. Does this answer your question?
> 
My argument wasn't so much about scsi_eh_lock_door() (which will be sent 
only in rare cases), but rather scsi_eh_try_stu() and scsi_eh_tur() as 
invoked from scsi_eh_test_devices() at the end of each SCSI EH step.
Both of which would need similar treatment.

Plus one maybe should revisit scsi_end_request(); that does refer to

	struct request_queue *q = sdev->request_queue;

despite having a 'struct request' as argument; maybe one should modify 
that to

	struct request_queue *q = req->q;

to not start accounting on the wrong queue.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
