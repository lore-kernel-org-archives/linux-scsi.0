From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Mon, 29 Jan 2018 10:14:36 +0800
Message-ID: <20180129021434.GB9822@ming.t460p>
References: <20180123161613.14214-1-ming.lei@redhat.com>
 <1516724659.3339.7.camel@sandisk.com>
 <20180123163717.GE13277@ming.t460p>
 <1516726653.3339.20.camel@wdc.com>
 <20180124033109.GA15945@ming.t460p>
 <20180127190920.GA24759@redhat.com>
 <1517091161.3055.7.camel@wdc.com>
 <20180128002356.GA25933@redhat.com>
 <1517159028.3141.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517159028.3141.17.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 28, 2018 at 05:03:49PM +0000, Bart Van Assche wrote:
> On Sat, 2018-01-27 at 19:23 -0500, Mike Snitzer wrote:
> > On Sat, Jan 27 2018 at  5:12pm -0500,
> > Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> > > - The patch at the start of this thread introduces a regression in the
> > >   SCSI core, namely a queue stall if a request completion occurs concurrently
> > >   with the newly added BLK_MQ_S_SCHED_RESTART test in the blk-mq core.
> > 
> > And why is this supposed race unique to SCSI core?  
> 
> That race is not unique to the SCSI core. It is possible that the patch at
> the start of this thread introduces the same race in other block drivers
> but I have not yet tried to verify that.
> 
> > Fact is Ming dutifully implemented what Jens suggested.
> 
> That's a misleading statement. Jens proposed to introduce a new status code
> (which he called "NO_DEV_RESOURCE") but did not specify any of the other
> aspects of Ming's patch. Jens definitely did not ask to introduce new race
> conditions. See also https://www.spinics.net/lists/kernel/msg2703154.html

I don't see what is the difference between my patch and Jens's
suggestion. My patch just introduces new code of "BLK_STS_DEV_RESOURCE"
which is returned to blk-mq if driver can make sure that queue will be
run after resource is available, and keep the current code of
'BLK_STS_RESOURCE', this way is simpler since most of the in-tree
'BLK_STS_RESOURCE' does need to run queue via
blk_mq_delay_run_hw_queue(hctx, 10)? Right?

You just mentioned my patch introduces race, but never explained what is
the race? How is it triggered? When is it?

Now it is the 3rd time for me to ask you explain the introduced race in
my patch V3. Is this your technical way to review/comment patch?

Thanks,
Ming
