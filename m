From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: 3ware queue depth [was: Re: HIGHMEM4G config for 1GB RAM on
 desktop?]
Date: Wed, 01 Sep 2004 22:23:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1094077436l.22433l.3l@drinkel.cistron.nl>
References: <200408021602.34320.swsnyder@insightbb.com>
	<1094030083l.3189l.2l@traveler> <1094030194l.3189l.3l@traveler>
	<200409010233.31643.lkml@lpbproductions.com>
	<1094032735l.3189l.7l@traveler> <20040901110944.A10160@infradead.org>
	<1094036919l.3189l.11l@traveler> <20040901194325.GA11762@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	Format=Flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S267758AbUIAW0u@vger.kernel.org>
In-Reply-To: <20040901194325.GA11762@beaverton.ibm.com> (from
	patmans@us.ibm.com on Wed Sep  1 21:43:25 2004)
Content-Disposition: inline
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, Christoph Hellwig <hch@infradead.org>, lkml@lpbproductions.com, Timothy Miller <miller@techsource.com>, Jens Axboe <axboe@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 01 Sep 2004 21:43:25, Patrick Mansfield wrote:
> On Wed, Sep 01, 2004 at 11:08:39AM +0000, Miquel van Smoorenburg wrote:
> 
> > +	/* make sure blockdev queue depth is at least 2 * scsi depth */
> > +	if (SDptr->request_queue->nr_requests < 2 * max_cmds)
> > +		SDptr->request_queue->nr_requests = 2 * max_cmds;
> 
> Why would you want nr_requests different (and larger) only for this
> driver?

Because for the Linux I/O scheduler to work, nr_requests needs to
be at least twice as big as the scsi queue depth.

For all other scsi drivers, the scsi queue depth is somewhere between
0 and 63. Most are between 1 and 8.

Default nr_requests is 128, so this problem exists only with the
3ware driver/controller that has a queue depth of 254 ..

It's more complicated than that though when you have more than
one scsi device attached to the 3ware controller (multiple raid
arrays or JBODs defined), since the total queue depth of the
controller is 254. In that case one scsi device can starve
others on the same controller, so you want to tune down the
queue depth per device .. e.g. with 8 JBODs set queue_depth
per device to 32, set nr_requests to 128.

Perhaps the initial queue_depth per device should be set to
254 / tw_dev->tw_num_units, that would be optimal.
Something like

	max_cmds = tw_host->can_queue / tw_dev->tw_num_units;
	if (max_cmds > TW_MAX_CMDS_PER_LUN)
		max_cmds = TW_MAX_CMDS_PER_LUN;

I think such a change should be submitted through the people
at 3ware, though.

> Is modifying nr_requests allowed?

Well we need to do the same things that ll_rw_blk::queue_requests_store()
does, only we don't need to worry about locking or existing queue
contents since the queue has been instantiated but the scsi device
is not active yet.

I do notice now however, that between 2.6.4 and 2.6.9-rc1
blk_queue_congestion_threshold() has been added which we should
probably call after adjusting nr_requests. Unfortunately it's
a static function in ll_rw_blk.c ..

Perhaps we should export the functionality of queue_requests_store()
as, say, queue_adjust_nr_requests() (like scsi_adjust_queue_depth) ?
Jens ?

Anyway, for now, perhaps the mucking with nr_requests should be
taken out and a change like the above should be sent to the
people at 3ware.

I'll submit the sysfs code for inclusion in -mm and the nr_requests
stuff to 3ware.

Mike.
