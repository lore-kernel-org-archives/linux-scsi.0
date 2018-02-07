From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 2/8] blk-mq: introduce BLK_MQ_F_GLOBAL_TAGS
Date: Wed, 7 Feb 2018 08:44:55 +0800
Message-ID: <20180207004454.GB13470@ming.t460p>
References: <20180205152035.15016-1-ming.lei@redhat.com>
 <20180205152035.15016-3-ming.lei@redhat.com>
 <20180206203336.GC16027@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180206203336.GC16027@vader.DHCP.thefacebook.com>
Sender: linux-block-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 06, 2018 at 12:33:36PM -0800, Omar Sandoval wrote:
> On Mon, Feb 05, 2018 at 11:20:29PM +0800, Ming Lei wrote:
......
> >  
> > +	/* need to restart all hw queues for global tags */
> > +	if (hctx->flags & BLK_MQ_F_GLOBAL_TAGS) {
> > +		struct blk_mq_hw_ctx *hctx2;
> > +		int i;
> > +
> > +		queue_for_each_hw_ctx(hctx->queue, hctx2, i)
> > +			if (blk_mq_run_hw_queue(hctx2, true))
> > +				return true;
> 
> Is it intentional that we stop after the first hw queue does work? That
> seems fine but it's a little confusing because the comment claims we
> restart everything.

Good catch, will update comment in V3.

Thanks,
Ming
