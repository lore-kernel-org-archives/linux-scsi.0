From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: When must the io_request_lock be held?
Date: Wed, 07 Aug 2002 18:17:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208072317.g77NH5105324@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id QAA17089
	for <linux-scsi@vger.kernel.org>; Wed, 7 Aug 2002 16:17:09 -0700
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Wed, 07 Aug 2002 11:06:28 PDT." <20020807180628.GD2182@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

andmike@us.ibm.com said:
> 	Maybe I am mis-reading something.

> 	Why would we want to go back to a model of having LL drivers
> 	using locks outside there domain (queue_lock). Should we not be
> 	moving toward having drivers use there own locks.

> 	I would think a future model might be to have queue_locks for
> 	queue operations and possible shared as a scsi device lock, a
> 	host_lock for host data, and LL driver locks used where the
> 	driver needs them. 

We're not really moving back:  Drivers that do their own locking today should 
continue to work under the new model (it just breaks the granularity of the 
io_request_lock, which was used for queueing previously).  Obviously, if those 
drivers move to individual queue locks instead of using the host lock for all 
queues, they get greater throughput but have nastier deadlock potential.

The drivers that don't have their own locks should now rely on either the 
host_lock or the queue_lock depending on what their hardware allows.  The 
re-entrancy of queuecommand is goverened by the programming model of the 
device.  For simple register and single mailbox cards, it doesn't really make 
too much sense to introduce a separate card lock just so they can drop the 
queue locks---It complicates the programming model and has no corresponding 
performance gain.

The bottom line is that there's no reason to require all drivers to develop 
their own locking scheme, but the barriers to this should be decreasing for 
those drivers that can profitably do this.

James


