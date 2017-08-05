From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 04/14] blk-mq-sched: improve dispatching from sw queue
Date: Sat, 5 Aug 2017 21:40:06 +0800
Message-ID: <20170805134001.GA4157@ming.t460p>
References: <20170731165111.11536-1-ming.lei@redhat.com>
 <20170731165111.11536-6-ming.lei@redhat.com>
 <1501544074.2466.29.camel@wdc.com>
 <20170801101718.GB31452@ming.t460p>
 <20170801105013.GD31452@ming.t460p>
 <1501600301.2475.1.camel@wdc.com>
 <20170802033135.GB7267@ming.t460p>
 <1501724126.30887.3.camel@wdc.com>
 <20170803031344.GA8327@ming.t460p>
 <1501781583.2922.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501781583.2922.12.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 03, 2017 at 05:33:13PM +0000, Bart Van Assche wrote:
> On Thu, 2017-08-03 at 11:13 +0800, Ming Lei wrote:
> > On Thu, Aug 03, 2017 at 01:35:29AM +0000, Bart Van Assche wrote:
> > > On Wed, 2017-08-02 at 11:31 +0800, Ming Lei wrote:
> > > > On Tue, Aug 01, 2017 at 03:11:42PM +0000, Bart Van Assche wrote:
> > > > > On Tue, 2017-08-01 at 18:50 +0800, Ming Lei wrote:
> > > > > > On Tue, Aug 01, 2017 at 06:17:18PM +0800, Ming Lei wrote:
> > > > > > > How can we get the accurate 'number of requests in progress' efficiently?
> > > > > 
> > > > > Hello Ming,
> > > > > 
> > > > > How about counting the number of bits that have been set in the tag set?
> > > > > I am aware that these bits can be set and/or cleared concurrently with the
> > > > > dispatch code but that count is probably a good starting point.
> > > > 
> > > > It has to be atomic_t, which is too too heavy for us, please see the report:
> > > > 
> > > > 	http://marc.info/?t=149868448400003&r=1&w=2
> > > > 
> > > > Both Jens and I want to kill hd_struct.in_flight, but looks still no
> > > > good way. 
> > > 
> > > Hello Ming,
> > > 
> > > Sorry but I disagree that a new atomic variable should be added to keep track
> > > of the number of busy requests. Counting the number of bits that are set in
> > > the tag set should be good enough in this context.
> > 
> > That won't work because the tag set is host wide and shared by all LUNs.
> 
> Hello Ming,
> 
> Are you aware that the SCSI core already keeps track of the number of busy requests
> per LUN? See also the device_busy member of struct scsi_device. How about giving the
> block layer core access in some way to that counter?

Yes, I know that.

Last time I mentioned it to Christoph that this counter can be used for
implementing Runtime PM for avoiding to introduce one new counter to 
account pending I/O.

But for this purpose(estimating how many requests to dequeue from hctxs),
it isn't a good idea:

1) strictly speaking, atomic counter isn't enough, and lock 
is needed, because we need to make sure that the counter can't
be changed during dequeuing requests, so exporting the counter
to block won't work

2) even though you may think it is just for estimating, and
not use a lock, it isn't good too, because for some SCSI devices,
q->queue_depth is very small, both qla2xxx and lfpc's .cmd_perf_lun
is 3. So it can be very inaccurate since it is normal to dequeue
requests from all hctx at the same time.

Also I have posted V2 today, from the test result on SRP, looks
it is good to dequeue one request one time, so I suggest that we
follow mq scheduler's way to dequeue request(pick up one in one time)
for blk-mq 'none' in this patchset. We may consider to improve
it in future if there is better & mature idea.


Thanks,
Ming
