From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH 8/8] blk-mq: support per-distpatch_queue flush machinery
Date: Thu, 11 Sep 2014 07:53:09 +0800
Message-ID: <CACVXFVNMfe1bGRmeQf-xKxA=YnD8e=dXwBQmoJzx_HNiPFJYHQ@mail.gmail.com>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
	<1410267949-21904-9-git-send-email-ming.lei@canonical.com>
	<20140909184856.GG16750@infradead.org>
	<CACVXFVNhmvy+aSgbJX8zgRVJQS0q6PWJLhmy_XVN_9YvSFdwag@mail.gmail.com>
	<20140910190247.GA28821@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48229 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaIJXxM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 19:53:12 -0400
In-Reply-To: <20140910190247.GA28821@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Thu, Sep 11, 2014 at 3:02 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Sep 10, 2014 at 09:40:11AM +0800, Ming Lei wrote:
>> I am wondering we can do that because lifetime is totally different
>> between flush requests and tag_set requests which are initialized
>> before request queue is created.
>
> We shouldn't do it in the tag sets, but where we allocate and free
> each hctx: blk_mq_init_queue and blk_mq_free_hw_queues.

That should work, but both flush queue's allocation and .init_request()
have to move to the function because hctx->numa_node is basically
ready in blk_mq_init_queue().  Then blk_init_flush() only need to allocate
the data for legacy case.


Thanks,
