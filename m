From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 5/7] blk-mq: initialize request on allocation
Date: Thu, 17 Apr 2014 23:07:59 +0800
Message-ID: <CACVXFVNR-FQPkN9j41GKtx71rXR=u0tJZbeWRf7c3setm5m+FA@mail.gmail.com>
References: <1397464212-4454-1-git-send-email-hch@lst.de>
	<1397464212-4454-6-git-send-email-hch@lst.de>
	<CACVXFVMAq0qw5vXqShmhcTTA5nww_OYaVz-yiEaf3_Q3-nrJfQ@mail.gmail.com>
	<20140417145705.GA14787@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:58543 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaDQPIA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2014 11:08:00 -0400
In-Reply-To: <20140417145705.GA14787@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Matias Bjorling <m@bjorling.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Thu, Apr 17, 2014 at 10:57 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Apr 17, 2014 at 10:54:23PM +0800, Ming Lei wrote:
>> On Mon, Apr 14, 2014 at 4:30 PM, Christoph Hellwig <hch@lst.de> wrote:
>> > If we want to share tag and request allocation between queues we cannot
>> > initialize the request at init/free time, but need to initialize it
>> > at allocation time as it might get used for different queues over its
>> > lifetime.
>>
>> Could you explain the use pattern? Looks you mean there are
>> still users of the tag/req even after it is freed, that looks a bit
>> weird since the tag/req can still be reallocated in another path
>> after it is freed.
>
> No difference in use pattern.  But blk_rq_init initializes the rq->q field,
> and a request might get reused for a different queue.

If so, it may be better to only initialize the rq->q in allocation
because Jens said 'It's done that way because of presumed cache
hotness on completion'.


Thanks,
-- 
Ming Lei
