From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: Re: [PATCH] block: Remove request_queue argument from
 blk_execute_rq_nowait
Date: Tue, 6 Aug 2019 07:24:56 -0300
Message-ID: <20190806102456.GA29914@continental>
References: <20190806011754.7722-1-marcos.souza.org@gmail.com>
 <20190806051911.GA13409@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190806051911.GA13409@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Doug Gilbert <dgilbert@interlog.com>, Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, Hannes Reinecke <hare@suse.com>, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:SCSI TARGET SUBSYSTEM" <target-devel@vger.k>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 06, 2019 at 07:19:11AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 05, 2019 at 10:17:51PM -0300, Marcos Paulo de Souza wrote:
> > +void blk_execute_rq_nowait(struct gendisk *bd_disk, struct request *rq,
> > +			int at_head, rq_end_io_fn *done)
> 
> We store a ->rq_disk in struct request, so we should also not need
> that.  And at_head should either become a bool, or be replaced with
> a flags argument, ints used boolean are usually not a good idea.

Makes sense.

> 
> > @@ -81,7 +80,7 @@ void blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
> 
> And all the same argument changes that apply to blk_execute_rq_nowait
> apply to blk_execute_rq as well.

Thanks for the suggestions, I will send a v2 soon.
