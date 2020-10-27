Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E038FC55178
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 17:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93A98204EF
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 17:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1816586AbgJ0RHt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 13:07:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:49224 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1816578AbgJ0RHo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Oct 2020 13:07:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C93C1AD2B;
        Tue, 27 Oct 2020 17:07:42 +0000 (UTC)
Subject: Re: [PATCHv6 00/21] scsi: enable reserved commands for LLDDs
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        linux-scsi@vger.kernel.org, chenxiang <chenxiang66@hisilicon.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
References: <20200703130122.111448-1-hare@suse.de>
 <ac78e944-25e1-15d7-7c9e-b7f439079222@huawei.com>
 <47ba045e-a490-198b-1744-529f97192d3b@suse.de>
 <c323d43c-771a-a30f-9bae-4f5d4e834e47@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <92b547b3-29c1-4cb0-6025-a5daa63fb6dc@suse.de>
Date:   Tue, 27 Oct 2020 18:07:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <c323d43c-771a-a30f-9bae-4f5d4e834e47@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/20 5:59 PM, John Garry wrote:
> On 27/10/2020 15:53, Hannes Reinecke wrote:
>>>
>> That was actually on the list of things to do next, ie rebasing this 
>> series now that the shared tags patchset is in.
>>
> 
> Sounds good.
> 
>> Oh, and I do have an updated hpsa patch, which doesn't crash on my 
>> systems. Will be posting that one separately.
> 
> I always thought that change (switch to MQ) looked better with $subject 
> series, but I'll leave that to you and Don.
> 
Yes, same here; with reserved commands hpsa becomes _much_ easier.

Now I only need to figure out a way how to handle consecutive tags;
for some drivers not only the command needs a tag, but the sgls also, 
thereby completely messing up our mq tags logic.
So to map those we'd need to allocate _several_ tags for one command, 
_and_ these additional tags won't be of 'struct request'.
Maybe we can do some tag chaining ...

But I'll be updating the patchset.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
