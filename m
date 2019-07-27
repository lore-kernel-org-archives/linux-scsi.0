From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 0/2] block/scsi/dm-rq: fix leak of request private
 data in dm-mpath
Date: Sat, 27 Jul 2019 10:12:20 +0800
Message-ID: <20190727021219.GA6926@ming.t460p>
References: <20190720030637.14447-1-ming.lei@redhat.com>
 <20190726162046.GA7523@t480-pf1aa2c2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190726162046.GA7523@t480-pf1aa2c2>
Sender: stable-owner@vger.kernel.org
To: Benjamin Block <bblock@linux.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 26, 2019 at 06:20:46PM +0200, Benjamin Block wrote:
> Hey Ming Lei,
> 
> On Sat, Jul 20, 2019 at 11:06:35AM +0800, Ming Lei wrote:
> > Hi,
> > 
> > When one request is dispatched to LLD via dm-rq, if the result is
> > BLK_STS_*RESOURCE, dm-rq will free the request. However, LLD may allocate
> > private data for this request, so this way will cause memory leak.
> 
> I am confused about this. Probably because I am not up-to-date with
> all of blk-mq. But if you free the LLD private data before the request
> is finished, what is the LLD doing if the request finishes afterwards?
> Would that not be an automatic use-after-free?

Wrt. this special use case, the underlying request is totally covered by
dm-rq after .queue_rq() returns BLK_STS_*RESOURCE. So the request won't
be re-dispatched by blk-mq at all.

thanks,
Ming
