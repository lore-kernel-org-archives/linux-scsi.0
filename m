Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741DFC41514
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 16:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31EE420684
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 16:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfHLQWB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 12:22:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4662 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbfHLQWB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Aug 2019 12:22:01 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 809D92F126BC02611484;
        Tue, 13 Aug 2019 00:21:57 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.238) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Tue, 13 Aug 2019
 00:21:51 +0800
From:   John Garry <john.garry@huawei.com>
Subject: Re: [PATCH V2 0/5] blk-mq: improvement on handling IO during CPU
 hotplug
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20190812134312.16732-1-ming.lei@redhat.com>
 <20190812134608.GA16803@ming.t460p>
CC:     <linux-block@vger.kernel.org>, Minwoo Im <minwoo.im.dev@gmail.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        "Christoph Hellwig" <hch@lst.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Busch <keith.busch@intel.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Message-ID: <658b0e7f-72f6-3673-d35e-4d8078069258@huawei.com>
Date:   Mon, 12 Aug 2019 17:21:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <20190812134608.GA16803@ming.t460p>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.238]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/08/2019 14:46, Ming Lei wrote:
> Hi John,
>
> On Mon, Aug 12, 2019 at 09:43:07PM +0800, Ming Lei wrote:
>> Hi,
>>
>> Thomas mentioned:
>>     "
>>      That was the constraint of managed interrupts from the very beginning:
>>
>>       The driver/subsystem has to quiesce the interrupt line and the associated
>>       queue _before_ it gets shutdown in CPU unplug and not fiddle with it
>>       until it's restarted by the core when the CPU is plugged in again.
>>     "
>>
>> But no drivers or blk-mq do that before one hctx becomes dead(all
>> CPUs for one hctx are offline), and even it is worse, blk-mq stills tries
>> to run hw queue after hctx is dead, see blk_mq_hctx_notify_dead().
>>
>> This patchset tries to address the issue by two stages:
>>
>> 1) add one new cpuhp state of CPUHP_AP_BLK_MQ_ONLINE
>>
>> - mark the hctx as internal stopped, and drain all in-flight requests
>> if the hctx is going to be dead.
>>
>> 2) re-submit IO in the state of CPUHP_BLK_MQ_DEAD after the hctx becomes dead
>>
>> - steal bios from the request, and resubmit them via generic_make_request(),
>> then these IO will be mapped to other live hctx for dispatch
>>
>> Please comment & review, thanks!
>>
>> V2:
>> 	- patch4 & patch 5 in V1 have been merged to block tree, so remove
>> 	  them
>> 	- address comments from John Garry and Minwoo
>>
>>
>> Ming Lei (5):
>>   blk-mq: add new state of BLK_MQ_S_INTERNAL_STOPPED
>>   blk-mq: add blk-mq flag of BLK_MQ_F_NO_MANAGED_IRQ
>>   blk-mq: stop to handle IO before hctx's all CPUs become offline
>>   blk-mq: re-submit IO in case that hctx is dead
>>   blk-mq: handle requests dispatched from IO scheduler in case that hctx
>>     is dead
>>
>>  block/blk-mq-debugfs.c     |   2 +
>>  block/blk-mq-tag.c         |   2 +-
>>  block/blk-mq-tag.h         |   2 +
>>  block/blk-mq.c             | 143 +++++++++++++++++++++++++++++++++----
>>  block/blk-mq.h             |   3 +-
>>  drivers/block/loop.c       |   2 +-
>>  drivers/md/dm-rq.c         |   2 +-
>>  include/linux/blk-mq.h     |   5 ++
>>  include/linux/cpuhotplug.h |   1 +
>>  9 files changed, 146 insertions(+), 16 deletions(-)
>>
>> Cc: Bart Van Assche <bvanassche@acm.org>
>> Cc: Hannes Reinecke <hare@suse.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Keith Busch <keith.busch@intel.com>
>> --
>> 2.20.1
>>
>
> Sorry for forgetting to Cc you.

Already subscribed :)

I don't mean to hijack this thread, but JFYI we're getting around to 
test https://github.com/ming1/linux/commits/v5.2-rc-host-tags-V2 - 
unfortunately we're still seeing a performance regression. I can't see 
where it's coming from. We're double-checking the test though.

Thanks,
John

>
>
> Thanks,
> Ming
>
> .
>


