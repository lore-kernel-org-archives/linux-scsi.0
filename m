From: Doug Ledford <dledford@redhat.com>
Subject: Re: Degraded I/O performance, since 2.5.41
Date: Thu, 10 Oct 2002 21:59:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021011015933.GC27073@redhat.com>
References: <haveblue@us.ibm.com> <3DA611DF.3000206@us.ibm.com> <200210110109.g9B19FJ14530@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210110109.g9B19FJ14530@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-scsi@vger.kernel.org

On Thu, Oct 10, 2002 at 06:09:14PM -0700, James Bottomley wrote:
> OK, this patch should fix it.  Do your performance numbers for ips improve 
> again with this?

Well, it should help.  Most drivers set cmd_per_lun too low to really be 
good here (and well they should because you only want it big enough to 
keep a CD-R or tape streaming, no more, because it's only intended to be 
used on non-tagged devices, disks should have their depth set via 
scsi_adjust_queue_depth() by the low level driver).  This is in fact the 
right thing to do though, so I've added it to my code here as well since 
it's required in order for cmd_per_lun to do the right thing in regards to 
untagged devices.  The real answer is to update the ServeRAID driver to 
the new tagged queue adjustment mechanism I just wrote an intro to and 
sent to linux-scsi.

As a side note, the generic block layer tagged queueing mechanism may not 
be suitable for a lot of SCSI drivers (I know it's not suitable for mine 
at all).  How many of the drivers in the scsi tree today keep a shared tag 
table between all devices on a host and how many of them have separate tag 
tables for each device?  Show of hands anyone?  Justin, what about the 
modern aic7xxx driver?  Gerard?

> James
> 


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
