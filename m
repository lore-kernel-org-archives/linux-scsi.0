Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E663C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 15:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A8C923750
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 15:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgLGPwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 10:52:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:39878 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgLGPwu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 10:52:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A2719AB63;
        Mon,  7 Dec 2020 15:52:08 +0000 (UTC)
Subject: Re: [PATCH 03/21] scsi: add scsi_{get,put}_internal_cmd() helper
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        linux-scsi@vger.kernel.org, chenxiang <chenxiang66@hisilicon.com>
References: <20200703130122.111448-1-hare@suse.de>
 <20200703130122.111448-4-hare@suse.de>
 <5b9e5684-2235-7ba7-f81f-6dc46ee141e9@huawei.com>
 <b60ff356-b17b-128a-7b32-8cef3a234286@suse.de>
 <2debadf2-a120-e73f-7fd6-14a3eb89e320@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0633db5c-0616-e42d-2eda-db43d739294a@suse.de>
Date:   Mon, 7 Dec 2020 16:52:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <2debadf2-a120-e73f-7fd6-14a3eb89e320@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/7/20 11:15 AM, John Garry wrote:
> On 16/11/2020 09:03, Hannes Reinecke wrote:
>> On 11/16/20 9:56 AM, John Garry wrote:
>>> On 03/07/2020 14:01, Hannes Reinecke wrote:
>>>> Add helper functions to allow LLDDs to allocate and free
>>>> internal commands.
>>>
>>> Hi Hannes,
>>>
>>> Is there any way to ensure that the request allocated is associated 
>>> with some determined HW queue here?
>>>
>>> The reason for this requirement is that sometimes the LLDD must 
>>> submit some internal IO (for which we allocate an "internal command") 
>>> on a specific HW queue. An example of this is internal abort IO 
>>> commands, which should be submitted on the same queue as the IO which 
>>> we are attempting to abort was submitted.
>>>
>>> So, for sure, the LLDD does not have to honor the hwq associated with 
>>> the request and submit on the desired queue, but then we lose the 
>>> blk-mq CPU hotplug protection. And maybe other problems.
>>>
>>> One way to achieve this is to run scsi_get_internal_cmd() on a CPU 
>>> associated with the desired HW queue, but that's a bit hacky. Not 
>>> sure of another way.
>>>
>> Hmm. You are correct for the 'abort' command; that typically needs to 
>> be submitted to a specific hwq.
>>
>> Let me think about it...
>>
> 
> 
> Hannes,
> 
> Earlier you mentioned " some drivers not only the command needs a tag, 
> but the sgls also, thereby completely messing up our mq tags logic.
> So to map those we'd need to allocate _several_ tags for one command ..."
> 
> Which drivers are these? Can you provide a pointer? Is this the blocker?
> 
Not actually a blocker, more something which I had been thinking about.
Point is, that the current blk-mq design assumes that each command 
requires a tag, and each tag maps to a single entity placed on the 
hardware submission queue.
While this is okay for some drivers, it's not a straightforward match 
for other drivers:
- FC uses 'Exchange IDs' to map commands; however, the lifetime for 
these XIDs is slightly different from the command lifetime.
In case of an error the XID must not be re-used (on the same queue) 
until error recovery has taken place. Which means we cannot use the 
block-layer tags for XIDs but have to implement an internal facility for 
that (cf drivers/scsi/libfc/fc_exch.c to get some idea about that).
- Some drivers like smartpqi or mpt3sas require the command _and the 
sgls_ to be placed on the submission queue, and every entity requires an 
unique tag. So again, we cannot leverage the block-layer tags to control 
the submission queue but have to implement a driver-specific thing.

But I'll be rebasing my patches.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
