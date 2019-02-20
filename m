From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] scsi: fix oops in scsi_uninit_cmd()
Date: Wed, 20 Feb 2019 07:18:36 -0800
Message-ID: <20190220151836.GA11695@infradead.org>
References: <20190219072743.13606-1-yanaijie@huawei.com>
 <1550595388.31902.133.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1550595388.31902.133.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Steffen Maier <maier@linux.ibm.com>
List-Id: linux-scsi@vger.kernel.org

[fullquote removed, please follow proper mail etiquette]

On Tue, Feb 19, 2019 at 08:56:28AM -0800, Bart Van Assche wrote:
> regression in the SCSI sd driver due to the switch from the legacy block
> layer to scsi-mq. The above patch introduces two atomic operations in the
> hot path and hence would introduce a performance regression. I think this
> can be avoided by making sure that sd_uninit_command() gets called before
> the request tag is freed. What changes would be required to make the block
> layer core call sd_uninit_command() before the request tag is freed? Would
> introducing prep_rq_fn and unprep_rq_fn callbacks in struct blk_mq_ops and
> making sure that the SCSI core sets these callback function pointers
> appropriately be sufficient? Would such a change allow to simplify the NVMe
> initiator driver? Are there any alternatives to this approach that are more
> elegant?

Additional indirect calls in the I/O fast path is something I'd rather
avoid.  But I don't fully understand the problem yet - where do
we release a disk reference from blk_update_request?  And why can't
we move that release to __blk_mq_end_request?

> 
> Thanks,
> 
> Bart.
---end quoted text---
