From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: When must the io_request_lock be held?
Date: Wed, 7 Aug 2002 11:06:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020807180628.GD2182@beaverton.ibm.com>
References: <dledford@redhat.com> <20020807121846.F10872@redhat.com> <200208071648.g77GmGH03563@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200208071648.g77GmGH03563@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> 
> Well, that's just semantics, I won't get into the argument...
> 
> Note also that 2.5 already has per queue locks (that means per individual SCSI 
> devices) which are lock pointers.  In 2.5 current, all the devices that hang 
> off an individual host have their queue_locks initialised to point to the 
> single host->host_lock.  However, drivers which can do it (the type of 
> multi-threaded multi-mailbox ones) will be permitted to use individual and 
> separate queue_locks, rather than the single host_lock, to protect their 
> mailbox registers.  If you are never going to do this, the difference between 
> using host_lock and queue_lock is irrelevant to you.  If you are, you need to 
> begin using the queue_locks.

James,
	Maybe I am mis-reading something.

	Why would we want to go back to a model of having LL drivers
	using locks outside there domain (queue_lock). Should we not be
	moving toward having drivers use there own locks.

	I would think a future model might be to have queue_locks for
	queue operations and possible shared as a scsi device lock, a
	host_lock for host data, and LL driver locks used where the
	driver needs them.

-Mike
-- 
Michael Anderson
andmike@us.ibm.com

