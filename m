From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Warning - running *really* short on DMA buffers while
 doingfiletransfers
Date: Fri, 27 Sep 2002 13:52:09 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <2580166224.1033156329@aslan.btc.adaptec.com>
References: <3D94AC8B.4AB6EB09@digeo.com>
 <2561606224.1033154176@aslan.btc.adaptec.com> <3D94B33F.EB3B9D41@digeo.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <3D94B33F.EB3B9D41@digeo.com>
Content-Disposition: inline
To: Andrew Morton <akpm@digeo.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Watch the read of sector 528598.  It was inserted into the
> elevator at 24989.185 seconds, was taken off the elevator by
> the driver at 24989.186 seconds and was completed in bio_endio()
> at 24992.273 seconds.  That trace was taken with 253 tags.  I
> don't have a 4-tag trace handy but it was much the same, with
> a two-second lag.
> 
> I am assuming that the driver submits the request to the disk
> shortly after calling elv_next_request().  If I'm wrong, and
> the driver itself is hanging onto the request for a significant
> amount of time then the disk is not the source of the delay.

Since your drive cannot handle 253 tags, when saturated with commands,
a new command is never submitted to the drive directly.  Instead the
command waits in the aic7xxx driver's queue until space is available
on the device.  In FreeBSD, this never happens as tag depth is known
to, and adjusted by, the mid-layer.  In Linux I must report the
queue depth without having sufficient load or history with the device
to know anything about its capabilities so I have no choice but to
throttle internally should the device support fewer tags than initially
reported to the OS.  You can determine the actual device queue
depth from "cat /proc/scsi/aic7xxx/#".  Run a bunch of I/O first so
that the tag depth gets locked first.

--
Justin
