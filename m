From: Matias Bjorling <m@bjorling.me>
Subject: Re: [RFC] blk-mq: support for shared tags
Date: Thu, 03 Apr 2014 09:45:11 -0700
Message-ID: <533D9017.4070609@bjorling.me>
References: <1396277175-21382-1-git-send-email-hch@lst.de> <533B56D5.5070803@bjorling.me> <20140402074632.GA11359@lst.de> <533CDF24.9030902@bjorling.me> <20140403073631.GA26921@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59984 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaDCQpO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2014 12:45:14 -0400
Received: by mail-pb0-f53.google.com with SMTP id rp16so2114856pbb.12
        for <linux-scsi@vger.kernel.org>; Thu, 03 Apr 2014 09:45:13 -0700 (PDT)
In-Reply-To: <20140403073631.GA26921@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 04/03/2014 12:36 AM, Christoph Hellwig wrote:
> On Wed, Apr 02, 2014 at 09:10:12PM -0700, Matias Bjorling wrote:
>> For the nvme driver, there's a single admin queue, which is outside
>> blk-mq's control, and the X normal queues. Should we allow the shared
>> tags structure to be used (get/put) for the admin queue, without
>> initializing blk-mq? or should the drivers simply implement their own
>> tags for their admin queue?
> 
> I'd still create a request_queue for the internal queue, just not register
> a block device for it.  For example SCSI sets up queues for each LUN
> found, but only a subset actually is exposed as a block device.
> 

Ok. That is good enough for now. A little heavy on the overhead side, if
only the tag logic is needed.

What about the following suggestions for shared tags:

1. Rename it from blk_mq_shared_tags to blk_mq_tag_group. A driver can
have several tag groups that it maintains.
2. Instead of blk_mq_shared_tags structure in blk_mq_reg. Have  function
pointer for getting the tags structure during hctx initialization. This
is interesting for nvme, because it has as set of tags for each hardware
queue it exposes.

Thanks,
Matias
