From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 15:10:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015221031.GF1049@beaverton.ibm.com>
References: <20021015201022.GB1049@beaverton.ibm.com> <200210152038.g9FKc8A03995@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210152038.g9FKc8A03995@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Jeffery, David" <David_Jeffery@adaptec.com>, 'Dave Hansen' <haveblue@us.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> andmike@us.ibm.com said:
> > I never seen the mid layer handle device starvation correctly. It
> > might be because in scsi_queue_next_request we do this:
> 
> > /*
> >  * Just hit the requeue function for the queue.
> >  */
> >   q->request_fn(q);
> 
> > before we check for starved. 
> 
> This starvation code has nothing to do with fairness.  It's job is purely to 
> restart the device queue if we got a host blocked condition and we had to 
> reject commands with zero depth.  When the host blocked abates then we loop 
> over all the starved devices and call their request functions.  Without this, 
> we could get a hang in the block layer queueing.

I am mis-reading what your saying.

Ok it will not handle fairness, but it will trigger a starved and
some_device_starved case when SHpnt->can_queue > 0 and SHpnt->host_busy >=
SHpnt->can_queue. Which is the case we where discussing and is not a
host blocked condition. The reverse ordering of the request_fn call
could cause a device to stayed starved if the device queue depth is near
or equal to the host can_queue.

-andmike
--
Michael Anderson
andmike@us.ibm.com

