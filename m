From: Andrew Morton <akpm@digeo.com>
Subject: Re: Warning - running *really* short on DMA buffers while
 doingfiletransfers
Date: Fri, 27 Sep 2002 12:36:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D94B33F.EB3B9D41@digeo.com>
References: <3D94AC8B.4AB6EB09@digeo.com> <2561606224.1033154176@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

"Justin T. Gibbs" wrote:
> 
> >> Which unfortunately characterizes only a single symptom without breaking
> >> it down on a transaction by transaction basis.  We need to understand
> >> how many writes were queued by the OS to the drive between each read to
> >> know if the drive is actually allowing writes to pass reads or not.
> >>
> >
> > Given that I measured a two-second read latency with four tags,
> > that would be about 60 megabytes of write traffic after the
> > read was submitted.  Say, 120 requests.  That's with a tag
> > depth of four.
> 
> I still don't follow your reasoning.  Your benchmark indicates the
> latency for several reads (cat kernel/*.c), not the per-read latency.
> The two are quite different and unless you know the per-read latency and
> whether it was affected by filling the drive's entire cache with
> pent up writes (again these are writes that are above and beyond
> those still assigned tags) you are still speculating that writes
> are passing reads.
> 
> If you can tell me exactly how you ran your benchmark, I'll find the
> information I want by using a SCSI bus analyzer to sniff the traffic
> on the bus.

I did it by tracing.  4 meg printk buffer, teach printk to timestamp
its output, add tracing printk's, then stare at the output.

The patches are at

http://www.zip.com.au/~akpm/linux/patches/2.5/2.5.38/2.5.38-mm1/experimental/printk-big-buf.patch
http://www.zip.com.au/~akpm/linux/patches/2.5/2.5.38/2.5.38-mm1/experimental/elevator-debug.patch

One sample trace is at
http://www.zip.com.au/~akpm/linux/patches/trace.txt

Watch the read of sector 528598.  It was inserted into the
elevator at 24989.185 seconds, was taken off the elevator by
the driver at 24989.186 seconds and was completed in bio_endio()
at 24992.273 seconds.  That trace was taken with 253 tags.  I
don't have a 4-tag trace handy but it was much the same, with
a two-second lag.

I am assuming that the driver submits the request to the disk
shortly after calling elv_next_request().  If I'm wrong, and
the driver itself is hanging onto the request for a significant
amount of time then the disk is not the source of the delay.
