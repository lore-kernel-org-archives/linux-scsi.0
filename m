Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4831C55178
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 16:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 992062225C
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 16:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796333AbgJ0P6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 11:58:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:55084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1803554AbgJ0PxG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Oct 2020 11:53:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B8B39ACE6;
        Tue, 27 Oct 2020 15:53:04 +0000 (UTC)
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
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <47ba045e-a490-198b-1744-529f97192d3b@suse.de>
Date:   Tue, 27 Oct 2020 16:53:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <ac78e944-25e1-15d7-7c9e-b7f439079222@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/20 4:27 PM, John Garry wrote:
> On 03/07/2020 14:01, Hannes Reinecke wrote:
>> Hi all,
>>
>> quite some drivers use internal commands for various purposes, most
>> commonly sending TMFs or querying the HBA status.
>> While these commands use the same submission mechanism than normal
>> I/O commands, they will not be counted as outstanding commands,
>> requiring those drivers to implement their own mechanism to figure
>> out outstanding commands.
>> The block layer already has the concept of 'reserved' tags for
>> precisely this purpose, namely non-I/O tags which live off a separate
>> tag pool. That guarantees that these commands can always be sent,
>> and won't be influenced by tag starvation from the I/O tag pool.
>> This patchset enables the use of reserved tags for the SCSI midlayer
>> by allocating a virtual LUN for the HBA itself which just serves
>> as a resource to allocate valid tags from.
>> This removes quite some hacks which were required for some
>> drivers (eg. fnic or snic), and allows the use of tagset
>> iterators within the drivers.
>>
>> The entire patchset can be found at
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git 
>> reserved-tags.v6
>>
> 
> Hi Hannes,
> 
> Any chance you can repost this series? I'm being a bit of a nag :)
> 
> It now looks like some drivers may also need this for supporting 
> io_uring in SCSI mid-layer:
> https://lore.kernel.org/linux-scsi/20201015133541.60400-1-kashyap.desai@broadcom.com/ 
> 
> 
> And it's also useful for the runtime PM which we were supporting for 
> hisi_sas, to track IOs.
> 
> I know that you were hoping for a few more reviews, but I don't think 
> that they are coming for v6 now. And at least I gave a few comments 
> here, like:
> 
> https://lore.kernel.org/linux-scsi/b03c1256-8255-5e7f-dda3-df036aaef812@huawei.com/ 
> 
> 
> And there were other comments.
> 
That was actually on the list of things to do next, ie rebasing this 
series now that the shared tags patchset is in.

Oh, and I do have an updated hpsa patch, which doesn't crash on my 
systems. Will be posting that one separately.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
