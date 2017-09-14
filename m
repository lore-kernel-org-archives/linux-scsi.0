From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V4 08/10] block: allow to allocate req with RQF_PREEMPT
 when queue is preempt frozen
Date: Thu, 14 Sep 2017 09:15:37 +0800
Message-ID: <20170914011532.GA16105@ming.t460p>
References: <20170911111021.25810-1-ming.lei@redhat.com>
 <20170911111021.25810-9-ming.lei@redhat.com>
 <1505145834.2802.17.camel@wdc.com>
 <20170912034057.GC31533@ming.t460p>
 <20170913164803.GB10407@ming.t460p>
 <1505323703.2654.3.camel@wdc.com>
 <20170913174759.GB24862@ming.t460p>
 <1505329670.2404.10.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1505329670.2404.10.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "cavery@redhat.com" <cavery@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 13, 2017 at 07:07:53PM +0000, Bart Van Assche wrote:
> On Thu, 2017-09-14 at 01:48 +0800, Ming Lei wrote:
> > No, that patch only changes blk_insert_cloned_request() which is used
> > by dm-rq(mpath) only, nothing to do with the reported issue during
> > suspend and sending SCSI Domain validation.
> 
> There may be other ways to fix the SCSI domain validation code.

Again the issue isn't in domain validation, it is in quiesce,
so we need to fix quiesce, instead of working around transport_spi.

Also What is the other way? Why not this patchset?

> 
> Regarding the hang during resume: I have not been able to reproduce that
> hang with Jens' latest for-next branch. If that hang would turn out not to
> be reproducible with v4.13-rc1, why to change the behavior of the block
> layer with regard to PREEMPT requests?

Previously you object this patchset because you mention there
is race, now you want to change to another reason?

So I suppose there isn't the race you worried about.

PREEMPT is special enough but used widely, not like NVMe,
traditional SCSI doesn't has a specific queue for
administration purpose only, then RFQ_PREEMPT need to
be dispatched to the same queue even normal I/O is not
allowed at that time.

Because it is a common/generic issue with quiesce, we have to
avoid I/O hang with quiesce. This way is a generic enough for
cover all this kind of issue. And no side effect on normal I/O
of block layer.

Can you make sure that the following two points can't happen
wrt. I/O hang during suspend/resume?

	- no normal I/O is triggered during suspend

	- all I/O requests in queue will be drained out before
	entering suspend

-- 
Ming
