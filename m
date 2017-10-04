From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/9] bsg-lib: fix use-after-free under memory-pressure
Date: Wed, 4 Oct 2017 08:16:11 +0200
Message-ID: <c87d75ff-9b6c-df5a-e2b3-b6e747a15679@suse.de>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003104845.10417-2-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/03/2017 12:48 PM, Christoph Hellwig wrote:
> From: Benjamin Block <bblock@linux.vnet.ibm.com>
> 
> When under memory-pressure it is possible that the mempool which backs
> the 'struct request_queue' will make use of up to BLKDEV_MIN_RQ count
> emergency buffers - in case it can't get a regular allocation. These
> buffers are preallocated and once they are also used, they are
> re-supplied with old finished requests from the same request_queue (see
> mempool_free()).
> 
> The bug is, when re-supplying the emergency pool, the old requests are
> not again ran through the callback mempool_t->alloc(), and thus also not
> through the callback bsg_init_rq(). Thus we skip initialization, and
> while the sense-buffer still should be good, scsi_request->cmd might
> have become to be an invalid pointer in the meantime. When the request
> is initialized in bsg.c, and the user's CDB is larger than BLK_MAX_CDB,
> bsg will replace it with a custom allocated buffer, which is freed when
> the user's command is finished, thus it dangles afterwards. When next a
> command is sent by the user that has a smaller/similar CDB as
> BLK_MAX_CDB, bsg will assume that scsi_request->cmd is backed by
> scsi_request->__cmd, will not make a custom allocation, and write into
> undefined memory.
> 
> Fix this by splitting bsg_init_rq() into two functions:
>  - bsg_init_rq() is changed to only do the allocation of the
>    sense-buffer, which is used to back the bsg job's reply buffer. This
>    pointer should never change during the lifetime of a scsi_request, so
>    it doesn't need re-initialization.
>  - bsg_initialize_rq() is a new function that makes use of
>    'struct request_queue's initialize_rq_fn callback (which was
>    introduced in v4.12). This is always called before the request is
>    given out via blk_get_request(). This function does the remaining
>    initialization that was previously done in bsg_init_rq(), and will
>    also do it when the request is taken from the emergency-pool of the
>    backing mempool.
> 
> Fixes: 50b4d485528d ("bsg-lib: fix kernel panic resulting from missing allocation of reply-buffer")
> Cc: <stable@vger.kernel.org> # 4.11+
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
> ---
>  block/bsg-lib.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
