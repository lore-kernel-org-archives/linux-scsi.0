From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Warning - running *really* short on DMA buffers while
 doingfiletransfers
Date: Fri, 27 Sep 2002 17:13:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209272113.g8RLD1420775@localhost.localdomain>
References: <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA21549
	for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2002 14:13:12 -0700
In-Reply-To: Message from "Justin T. Gibbs" <gibbs@scsiguy.com>
   of "Fri, 27 Sep 2002 13:52:09 MDT." <2580166224.1033156329@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Andrew Morton <akpm@digeo.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> Since your drive cannot handle 253 tags, when saturated with commands,
> a new command is never submitted to the drive directly.  Instead the
> command waits in the aic7xxx driver's queue until space is available
> on the device.  In FreeBSD, this never happens as tag depth is known
> to, and adjusted by, the mid-layer.  In Linux I must report the queue
> depth without having sufficient load or history with the device to
> know anything about its capabilities so I have no choice but to
> throttle internally should the device support fewer tags than
> initially reported to the OS.  You can determine the actual device
> queue depth from "cat /proc/scsi/aic7xxx/#".  Run a bunch of I/O first
> so that the tag depth gets locked first. 

Linux is perfectly happy just to have you return 1 in queuecommand if the 
device won't accept the tag.  The can_queue parameter represents the maximum 
number of outstanding commands the mid-layer will ever send.  The mid-layer is 
happy to re-queue I/O below this limit if it cannot be accepted by the drive.  
In fact, that's more or less what queue plugging is about.

The only problem occurs if you return 1 from queuecommand with no other 
outstanding I/O for the device.

There should be no reason in 2.5 for a driver to have to implement an internal 
queue.

James


