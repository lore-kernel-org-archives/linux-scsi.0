From: Doug Ledford <dledford@redhat.com>
Subject: Setting queue depths in the scsi mid layer, an intro
Date: Thu, 10 Oct 2002 22:46:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210110246.g9B2kQVf027614@flossy.devel.redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flossy.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by flossy.devel.redhat.com (8.12.5/8.12.5) with ESMTP id g9B2kQ9Y027616
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2002 22:46:26 -0400
Received: (from dledford@localhost)
	by flossy.devel.redhat.com (8.12.5/8.12.5/Submit) id g9B2kQVf027614
	for linux-scsi@vger.kernel.org; Thu, 10 Oct 2002 22:46:26 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

One of the recent changes to the scsi mid layer was my adjustable queue
depth patch.  This patch requires that all drivers who wish to implement
tagged queueing be updated.  (Yes James, I know that the simple NCR700
driver you've been using does tagged queueing without these updates, but
that won't last because the tagged queueing mechanism needs to be a full
bottom up mechanism in order to work, so very shortly the business of
setting the block layer queue depth will be controlled the via this same
mechanism)

So here's the long and short of it so that maybe some other people can 
help jump in and update drivers.

First, the select_queue_depths call in point in drivers is now deprecated.  
I left the call in active in my patch, but on deeper reflection it was a
wasted effort (I was going to let this continue to work until most/all of
the drivers had been modified, but because scsi_build_commandblocks() now
looks at new_queue_depth instead of queue_depth, this is not possible, in
fact it will likely confuse the hell out of the mid layer because
queue_depth is now suppossed to indicate the actual number of commands
allocated on the device in question, not how many commands you want
allocated, and that's an important distinction) and the
select_queue_depths call in from the mid layer (in scsi_scan.c) will be
going away immediately (Linus, expect a small patch shortly)

The revoke() call in point in scsi drivers will also be going away.  
However, most drivers, if they implement a revoke() call, can simply 
rename it to slave_detach() and be fine (the name is changing to be more 
descriptive, but it does the same basic thing, more on that later).

The replacement for select_queue_depths() is the slave_attach() call in
point.  Once the drive has been identified and the INQUIRY data
sufficiently probed to tell things like device type, scsi level, and
available options (including the new sdtr/wdtr/ppr flags which tell the
low level driver whether or not the device supports these particular
message protocols based upon the INQUIRY return values).  At this point,
the driver is free to do device specific setups.  That can include setting
the queue depth on the device by calling scsi_adjust_queue_depths() entry
point with the scsi device, whether you are enabling tagged command
queueing (and tagged options, coming shortly in an update patch,
basically, 0 means disabled TCQ, MSG_SIMPLE_TAG is simple tags only, and
MSG_ORDERED_TAG will indicate tagged queueing is enabled with both simple
and ordered tags allowed), and the queue depth.  Most disk devices will
end up looking something like this:

scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, queue_depth);

At some later point in time (like in an interrupt handler,
scsi_adjust_queue_depths *is* interrupt context safe) if your driver finds
out that the device doesn't support ordered tags, then it can recall this
command and omit the ORDERED_Q_TAG bit in order to get tagged queueing
with just simple queue tags.  If it doesn't support either tag type, then
call it with (SDptr, 0, <cmd_per_lun>) as the arguments to set it back to
no tagged queueing and your driver's default cmd_per_lun queue depth.

That, of course, is just one thing a driver can do at the slave_attach() 
call in point.  It may also do things like allocate driver specific device 
data storage and attach it to SDptr->hostdata for future use (for example, 
you may keep your queue depth counter or busy flag or other driver 
specific crap like BIOS settings in this data storage area).  Some 
examples are present in the aic7xxx_old.c driver.

Why did we make this change?  Simple, the select_queue_depths() interface 
was broken by design.  It did only one thing when in reality there are a 
number of things that need done at device attach time.  It was only 
possible to change queue depths at this one point in time, never more, 
resulting in things like Justin's aic7xxx driver setting the queue depth 
on all disks to 253 in order to get the best possible performance, but 
when the driver found out that some disk had a hard limit of say 64, it 
was too late to tell the mid layer to adjust things down to a reasonable 
value.  This allows the low level driver to make changes to the queue 
depth later and still have the mid layer honor them.

The revoke->slave_detach change is pretty much a name change only.  I
would have left it alone and just named slave_attach something that made
it obvious they are a matched pair, but invoke(SDptr) sounded more 
like something I would read in a David Eddings novel than a kernel 
function.  The big item is that I'm strongly encouraging drivers to make
use of the SDptr->hostdata pointer to store their data (helps to avoid
things like having to keep sparse direct indexed tables in your driver if
you can have device attached storage space).  The aic7xxx_old driver will
be getting updated to use this device attached storage area, thereby
eliminating quite a few huge arrays currently in each aic7xxx_host struct.  
The slave_detach() call is a place for driver to deconstruct anything they
might have attached to the device, disable the device internally in their
driver, etc.  The most important thing here though is this:

The slave_detach() call, if it deallocates any memory storage attached to 
SDptr->hostdata *must* then NULL out the hostdata pointer.  The scsi mid 
layer is nice and will kfree(SDptr->hostdata) for you on device 
destruction of SDptr->hostdata is non-NULL.  We do this because, by far, 
the common case is a simple kfree() of the area and that's it.  If your 
driver needs to do more, it can make and register the slave_detach() call.  
If it doesn't, no need to bother with slave_detach().  That catches the 
biggest common cases.  Failure to NULL out the SDptr->hostdata after 
kfree()'ing the memory will result in a double kfree() and subsequent 
kernel complaints.



-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  

