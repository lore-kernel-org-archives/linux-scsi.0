From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V6 2/6] block: tracking request allocation with
 q_usage_counter
Date: Wed, 27 Sep 2017 08:10:02 +0200
Message-ID: <b9e876e1-4509-086a-2899-c64d3cb66485@suse.de>
References: <20170927054853.6647-1-ming.lei@redhat.com>
 <20170927054853.6647-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54202 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750858AbdI0GKI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Sep 2017 02:10:08 -0400
In-Reply-To: <20170927054853.6647-3-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>

On 09/27/2017 07:48 AM, Ming Lei wrote:
> This usage is basically same with blk-mq, so that we can
> support to freeze legacy queue easily.
> 
> Also 'wake_up_all(&q->mq_freeze_wq)' has to be moved
> into blk_set_queue_dying() since both legacy and blk-mq
> may wait on the wait queue of .mq_freeze_wq.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-core.c | 14 ++++++++++++++
>  block/blk-mq.c   |  7 -------
>  2 files changed, 14 insertions(+), 7 deletions(-)
> 
As indicated in the other (similar) patch from Bart, we have a customer
report running into a q_usage_counter underflow with legacy-sq.
So this patch is actually a bugfix.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
