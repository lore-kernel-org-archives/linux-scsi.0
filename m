From: Doug Ledford <dledford@redhat.com>
Subject: Re: What's the state of sdev->tagged_queue
Date: Fri, 06 Jun 2003 10:04:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE09F82.2060000@redhat.com>
References: <20030606074813.GA18748@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.200]:53916 "EHLO
	lacrosse.corp.redhat.com") by vger.kernel.org with ESMTP
	id S261411AbTFFNwC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 09:52:02 -0400
In-Reply-To: <20030606074813.GA18748@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Hi Doug,

Hi Christoph.

> scsi_ioctl.c has the following comment from you:
> 
>  * The next two ioctls either need to go or need to be changed to
>  * pass tagged queueing changes through the low level drivers.
>  * Simply enabling or disabling tagged queueing without the knowledge
>  * of the low level driver is a *BAD* thing.
> 
> and scsi.h has this:
> 
>  unsigned tagged_queue:1;/* This is going away!!!!  Look at simple_tags
>                             instead!!!  Please fix your driver now!! */
> 
> but several drivers still look at it although it's never touched
> outside scsi_ioctl.c and the individual drivers.  Most drivers uses also
> look pretty bogus.  Can we just the ioctls and the field?

I assume that should read "Can we just kill the ioctls and the field?" :-)

The answer to that is yes I think.  The ioctls for certain, the field 
I'm pretty sure of.  Originally, the field was used as a boolean that 
was when we enabled tagged queueing on a device.  Now, a value of 
simple_tags > 1 should do the same thing.  However, due to usage of 
cmd_per_lun on both tagged and untagged devices (I would have to check 
this, I'm a bit out of touch since my accident) may cause confusion.  If 
we set queue depth to cmd_per_lun the device may look tagged when it is 
in fact not tagged.  The replacement test may need to be if simple_tags 
 > cmd_per_lun to indicate true tagged queueing.


> 53c700.c:	if(SCp->device->tagged_supported && !SCp->device->tagged_queue

This is checking that tagged queueing is supported and not already 
enabled (a holdover from the fact that select_queue_depths would get 
called more than once on a single device if we ever had a scsi 
add-single-device command after the initial device scan).

> AM53C974.c:				if (!hostdata->connected->device->tagged_queue)

Tests tagged queueing not active on a device.

> AM53C974.c:			    cmd->device->tagged_queue = 0;

Disabling tagged queueing on a device.

> AM53C974.c:	if (cmd->device->tagged_queue && (tag != TAG_NONE)) {

Checking for a tagged device with an untagged command.  Others are all 
similar.

> NCR5380.c:						cmd->device->tagged_queue = 0;
> arm/acornscsi.c:	if (SCpnt->device->tagged_queue) {
> arm/acornscsi.c:	    host->SCpnt->device->tagged_queue = 0;
> arm/acornscsi.c:			     scd->tagged_queue ? "en" : "dis",
> arm/fas216.c:	if (SCpnt->device->tagged_queue && SCpnt->cmnd[0] != REQUEST_SENSE &&
> arm/fas216.c:				     scd->tagged_queue ? "en" : "dis",
> ncr53c8xx.c:	if (lp && !lp->numtags && cmd->device && cmd->device->tagged_queue) {
> qla1280.c:			if (cmd->device->tagged_queue)
> qla1280.c:			if (cmd->device->tagged_queue)
> scsi.h:	unsigned tagged_queue:1;/* This is going away!!!!  Look at simple_tags
> scsi_ioctl.c:		sdev->tagged_queue = 1;
> scsi_ioctl.c:		sdev->tagged_queue = 0;
> sym53c8xx.c:	if (lp && !lp->numtags && cmd->device && cmd->device->tagged_queue) {

This does bring up another issue I've been thinking about though so I'll 
suggest it now.

Currently, we use the value of host->this_id to skip the scsi device of 
the host controller in our device scan.  What I would like to do is 
create an sg device entry for this_id that is type processor, is a fake 
device, that implements whatever ioctls at the mid layer level that are 
appropriate, but that also allow the low level driver to register a fall 
through host ioctl routine that can be attached to this device.  This 
would give us a uniform method of accessing host controllers via the 
scsi subsystem.  Generic ioctls that can be handled in the mid layer can 
be done so.  Host adapter specific ioctls can then be handled by the 
driver.  At least this way we wouldn't have to have a different /proc 
method of doing these things in every single driver and we would be able 
to use a normal ioctl interface for things like controlling the various 
smart raid controllers, etc.  Thoughts?

-- 
   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
            Red Hat, Inc.
            1801 Varsity Dr.
            Raleigh, NC 27606


