Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98C7C43215
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 17:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91A2520684
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 17:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfK0RC6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 12:02:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:59558 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726984AbfK0RC6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Nov 2019 12:02:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ABD37B27C;
        Wed, 27 Nov 2019 17:02:56 +0000 (UTC)
Subject: Re: [PATCH 4/8] blk-mq: Facilitate a shared sbitmap per tagset
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-5-hare@suse.de> <20191126110527.GE32135@ming.t460p>
 <8a10e2f0-bbdc-8b47-a118-0fd7837ef44e@suse.de>
 <20191126155445.GB17602@ming.t460p>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <5561a568-a559-fee8-83aa-449befedae47@suse.de>
Date:   Wed, 27 Nov 2019 18:02:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191126155445.GB17602@ming.t460p>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/19 4:54 PM, Ming Lei wrote:
> On Tue, Nov 26, 2019 at 12:27:50PM +0100, Hannes Reinecke wrote:
>> On 11/26/19 12:05 PM, Ming Lei wrote:
[ .. ]
>>>  From performance viewpoint, all hctx belonging to this request queue should
>>> share one scheduler tagset in case of BLK_MQ_F_TAG_HCTX_SHARED, cause
>>> driver tag queue depth isn't changed.
>>>
>> Hmm. Now you get me confused.
>> In an earlier mail you said:
>>
>>> This kind of sharing is wrong, sched tags should be request
>>> queue wide instead of tagset wide, and each request queue has
>>> its own & independent scheduler queue.
>>
>> as in v2 we _had_ shared scheduler tags, too.
>> Did I misread your comment above?
> 
> Yes, what I meant is that we can't share sched tags in tagset wide.
> 
> Now I mean we should share sched tags among all hctxs in same request
> queue, and I believe I have described it clearly.
> 
I wonder if this makes a big difference; in the end, scheduler tags are 
primarily there to allow the scheduler to queue more requests, and 
potentially merge them. These tags are later converted into 'real' ones 
via blk_mq_get_driver_tag(), and only then the resource limitation takes 
hold.
Wouldn't it be sufficient to look at the number of outstanding commands 
per queue when getting a scheduler tag, and not having to implement yet 
another bitmap?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
