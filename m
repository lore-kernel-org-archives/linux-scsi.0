From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [Lsf] [LSF/MM TOPIC] block-mq issues with FC
Date: Tue, 12 Apr 2016 13:16:21 -0600
Message-ID: <570D4985.9020108@kernel.dk>
References: <57079616.4000202@suse.de> <20160408174006.GI2781@linux.intel.com>
 <20160408180621.GA6110@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34093 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021AbcDLTQY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2016 15:16:24 -0400
Received: by mail-ig0-f176.google.com with SMTP id gy3so115797982igb.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2016 12:16:24 -0700 (PDT)
In-Reply-To: <20160408180621.GA6110@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, Matthew Wilcox <willy@linux.intel.com>
Cc: Hannes Reinecke <hare@suse.de>, lsf@lists.linux-foundation.org, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On 04/08/2016 12:06 PM, Keith Busch wrote:
> On Fri, Apr 08, 2016 at 01:40:06PM -0400, Matthew Wilcox wrote:
>>   - Inability to use all queues supported by a device.  Intel's P3700
>>     supports 31 queues, but block-mq insists on assigning an even multiple
>>     of CPUs to each queue.  So if you have 48 CPUs, it will use 24 queues.
>>     If you have 128 CPUs, it will only use 16 of the queues.
>
> While it'd be better to use all the available h/w resources, that's
> actually not the worst part.
>
> The real problems occur when there are more physical/unique CPUs than
> h/w queues since blk-mq does not consider CPU topology beyond thread
> siblings. With 128 CPUs, blk-mq may use all 31 queues P3700 supports,
> but many CPU groups won't share a last-level-cache.
>
> Smarter assignment would reclaim some untapped performance, and we can
> share such code prior to the session.

There's definitely room for improvement in the cpu mapping code.

However, on the original complaint, it's by design (or, working as 
intended) - this was done to keep the layout symmetrical. It's been 
discussed on the mailing lists before. We can have a discussion whether 
we should change this or not, of course.

-- 
Jens Axboe

