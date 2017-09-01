From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/9] blk-mq: only run hw queues for blk-mq
Date: Fri, 1 Sep 2017 10:16:34 +0200
Message-ID: <20170901081634.gliggrnp3wlrysrv@linux-x5ow.site>
References: <20170831172728.15817-1-ming.lei@redhat.com>
 <20170831172728.15817-5-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44601 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751367AbdIAIQg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Sep 2017 04:16:36 -0400
Content-Disposition: inline
In-Reply-To: <20170831172728.15817-5-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Oleksandr Natalenko <oleksandr@natalenko.name>

Hi Ming,

On Fri, Sep 01, 2017 at 01:27:23AM +0800, Ming Lei wrote:
> -		blk_mq_run_hw_queues(q, false);
> +		if (q->mq_ops)
> +			blk_mq_run_hw_queues(q, false);

What speaks against putting the if (q->mq_ops) directly into
blk_mq_run_hw_queues() so we can't accidently call it from the sq path?

Just an idea, no hard preferences here.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
