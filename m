Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD1A6C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 06:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C29164DAF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 06:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhBXGzQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 01:55:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:45832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234218AbhBXGyy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Feb 2021 01:54:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 084EBAE3C;
        Wed, 24 Feb 2021 06:54:13 +0000 (UTC)
Subject: Re: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        "Viswas.G@microchip.com" <Viswas.G@microchip.com>
References: <20210222132405.91369-1-hare@suse.de>
 <a6234ede-74bd-81f0-9d39-db398b79f50a@huawei.com>
 <6d2f5677-b033-9639-82da-655152ad6d8c@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ca83b2b4-8266-17f6-cf08-2673d1fa0881@suse.de>
Date:   Wed, 24 Feb 2021 07:54:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <6d2f5677-b033-9639-82da-655152ad6d8c@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/23/21 6:50 PM, John Garry wrote:
> On 23/02/2021 10:16, John Garry wrote:
>> On 22/02/2021 13:23, Hannes Reinecke wrote:
>>> Hi all,
>>
>> +
>>
>>>
>>> quite some drivers use internal commands for various purposes, most
>>> commonly sending TMFs or querying the HBA status.
>>> While these commands use the same submission mechanism than normal
>>> I/O commands, they will not be counted as outstanding commands,
>>> requiring those drivers to implement their own mechanism to figure
>>> out outstanding commands.
>>> The block layer already has the concept of 'reserved' tags for
>>> precisely this purpose, namely non-I/O tags which live off a separate
>>> tag pool. That guarantees that these commands can always be sent,
>>> and won't be influenced by tag starvation from the I/O tag pool.
>>> This patchset enables the use of reserved tags for the SCSI midlayer
>>> by allocating a virtual LUN for the HBA itself which just serves
>>> as a resource to allocate valid tags from.
>>> This removes quite some hacks which were required for some
>>> drivers (eg. fnic or snic), and allows the use of tagset
>>> iterators within the drivers.
>>>
>>> The entire patchset can be found at
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
>>> reserved-tags.v7
>>
>>
>> Thanks for doing this, I'll have a look.
> 
> So I got this working eventually for hisi_sas - a few fixes needed:
> https://github.com/hisilicon/kernel-dev/commits/private-topic-sas-5.11-resv7 
> 
> 
> I'll have a look at the core patches tomorrow. However, at this point, 
> how about convert just a couple of drivers (the ones which you can test) 
> to get it merged as a start? 31 patches is too many.
> 
Yeah, I know. Actually, I just sent it out so that you can have a look 
at my libsas slow task rework.

But I can easily split it off for just fnic/snic/aacraid/hpsa, and leave 
the libsas slow task stuff for the next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
