From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 1/6] bsg: fix kernel panic resulting from missing
        allocation of a reply-buffer
Date: Wed, 16 Aug 2017 12:53:18 +0200
Message-ID: <20170816105318.GA30759@lst.de>
References: <20170810093217.GL24539@lst.de> <20170810221038.GA918@bblock-ThinkPad-W530> <20170811083808.GA5497@lst.de> <20170811091415.GA8099@lst.de> <20170811134929.GA1249@bblock-ThinkPad-W530> <20170811143649.GA32381@lst.de> <20170811153203.GA31625@bblock-ThinkPad-W530> <20170811153553.GA6372@lst.de> <20170811160142.GB31625@bblock-ThinkPad-W530> <20170814163217.GA18228@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170814163217.GA18228@bblock-ThinkPad-W530>
Sender: linux-block-owner@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 14, 2017 at 06:32:17PM +0200, Benjamin Block wrote:
> > -	blk_end_request_all(rq, BLK_STS_OK);
> > -
> >  	put_device(job->dev);	/* release reference for the request */
> >
> >  	kfree(job->request_payload.sg_list);
> >  	kfree(job->reply_payload.sg_list);
> > -	kfree(job);
> > +	blk_end_request_all(rq, BLK_STS_OK);
> 
> What is the reason for moving that last line? Just wondering whether
> that might change the behavior somehow, although it doesn't look like it
> from the code.

The job is now allocated as part of the request, so we must fre
it last.  The only change in behavior is that the reference gets dropped
a bit earlier, but once ownership is handed to the block layer
it's not needed, as are the memory allocations for the S/G lists.

> > +{
> > +	struct bsg_job *job = blk_mq_rq_to_pdu(req);
> > +
> > +	memset(job, 0, sizeof(*job));
> > +	job->req = req;
> > +	job->request = job->sreq.cmd;
> 
> That doesn't work with bsg.c if the request submitted by the user is
> bigger than BLK_MAX_CDB. There is code in blk_fill_sgv4_hdr_rq() that
> will reassign the req->cmd point in that case to something else.
> 
> This is maybe wrong in the same vein as my Patch 1 is. If not for the
> legacy code in bsg.c, setting this here, will miss changes to that
> pointer between request-allocation and job-submission.
> 
> So maybe just move this to bsg_create_job().

Yes, this should be in  indeed.

> 
> > +	job->dd_data = job + 1;
> > +	job->reply = job->sreq.sense = kzalloc(job->reply_len, gfp);
> 
> job->reply_len will be 0 here, won't it? You probably have to pull the
> "job->reply_len = SCSI_SENSE_BUFFERSIZE" here from bsg_create_job().

True.
