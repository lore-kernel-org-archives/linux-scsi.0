From: Matias Bjorling <m@bjorling.me>
Subject: Re: [RFC] blk-mq: support for shared tags
Date: Tue, 01 Apr 2014 17:16:21 -0700
Message-ID: <533B56D5.5070803@bjorling.me>
References: <1396277175-21382-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1396277175-21382-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/31/2014 07:46 AM, Christoph Hellwig wrote:
> This series adds support for sharing tags (and thus requests) between
> multiple request_queues.  We'll need this for SCSI, and I think Martin
> also wants something similar for nvme.
> 
> Besides the mess with request contructors/destructors the major RFC here
> is how the blk_mq_alloc_shared_tags API should look like.  For now I've
> been lazy and reused struct blk_mq_reg, but that feels a bit cumbersome.
> Either a separate blk_mq_tags_reg or just passing the few arguments directly
> would work fine for me.
> 

Hi Christoph,

Can you rebase it on top of 3.14. I have trouble applying it for testing.

For nvme, there's need for two separate types of queues. The admin queue
(before initializing blk-mq) and the actual hardware queues.

Should we allow the driver to get/put tags before initializing blk-mq?
Or let drivers implement their own framework?

Thanks,
Matias
