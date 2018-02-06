From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V2 2/8] blk-mq: introduce BLK_MQ_F_GLOBAL_TAGS
Date: Tue, 6 Feb 2018 16:18:20 -0700
Message-ID: <398c755a-ada6-1e60-9562-51b69476e55d@kernel.dk>
References: <20180205152035.15016-1-ming.lei@redhat.com>
 <20180205152035.15016-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180205152035.15016-3-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 2/5/18 8:20 AM, Ming Lei wrote:
> Quite a few HBAs(such as HPSA, megaraid, mpt3sas, ..) support multiple
> reply queues, but tags is often HBA wide.
> 
> These HBAs have switched to use pci_alloc_irq_vectors(PCI_IRQ_AFFINITY)
> for automatic affinity assignment.
> 
> Now 84676c1f21e8ff5(genirq/affinity: assign vectors to all possible CPUs)
> has been merged to V4.16-rc, and it is easy to allocate all offline CPUs
> for some irq vectors, this can't be avoided even though the allocation
> is improved.
> 
> So all these drivers have to avoid to ask HBA to complete request in
> reply queue which hasn't online CPUs assigned, and HPSA has been broken
> with v4.15+:
> 
> 	https://marc.info/?l=linux-kernel&m=151748144730409&w=2
> 
> This issue can be solved generically and easily via blk_mq(scsi_mq) multiple
> hw queue by mapping each reply queue into hctx, but one tricky thing is
> the HBA wide(instead of hw queue wide) tags.
> 
> This patch is based on the following Hannes's patch:
> 
> 	https://marc.info/?l=linux-block&m=149132580511346&w=2
> 
> One big difference with Hannes's is that this patch only makes the tags sbitmap
> and active_queues data structure HBA wide, and others are kept as NUMA locality,
> such as request, hctx, tags, ...
> 
> The following patch will support global tags on null_blk, also the performance
> data is provided, no obvious performance loss is observed when the whole
> hw queue depth is same.

GLOBAL implies that it's, strangely enough, global. That isn't really the
case. Why not call this BLK_MQ_F_HOST_TAGS or something like that? I'd
welcome better names, but global doesn't seem to be a great choice.

BLK_MQ_F_SET_TAGS?

-- 
Jens Axboe
