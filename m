From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: When must the io_request_lock be held?
Date: Wed, 07 Aug 2002 11:48:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208071648.g77GmGH03563@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA24842
	for <linux-scsi@vger.kernel.org>; Wed, 7 Aug 2002 09:48:20 -0700
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Wed, 07 Aug 2002 12:18:46 EDT." <20020807121846.F10872@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>, linux-scsi@vger.kernel.org

dledford@redhat.com said:
> Then you better not *ever* release the lock under those conditions.   

Exactly so.

dledford@redhat.com said:
> Again, if Marcello takes my patch, this will become easier as well
> since  it adds a host->lock lock that allows you to get your driver
> off the  horrible io_request_lock once and for all.  (Note: I may have
> to change  the name to host->host_lock to make it match 2.5, but that
> just annoys the  hell out of me because I *detest* totally redundant
> names like that...)

Well, that's just semantics, I won't get into the argument...

Note also that 2.5 already has per queue locks (that means per individual SCSI 
devices) which are lock pointers.  In 2.5 current, all the devices that hang 
off an individual host have their queue_locks initialised to point to the 
single host->host_lock.  However, drivers which can do it (the type of 
multi-threaded multi-mailbox ones) will be permitted to use individual and 
separate queue_locks, rather than the single host_lock, to protect their 
mailbox registers.  If you are never going to do this, the difference between 
using host_lock and queue_lock is irrelevant to you.  If you are, you need to 
begin using the queue_locks.

James



