From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Tue, 25 Mar 2003 10:45:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030325184530.GA1202@beaverton.ibm.com>
References: <20030325100704.GC3868@beaverton.ibm.com> <1048613872.2070.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1048613872.2070.12.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> On Tue, 2003-03-25 at 04:07, Mike Anderson wrote:
> 
> This isn't right:
> 
> > +	spin_lock_irqsave(shost->host_lock, flags);
> > +	for (lh = shost->my_devices.next; 
> > +	      (!error) && (lh != &shost->my_devices);) {
> > +		sdev = list_entry(lh, struct scsi_device, siblings);
> > +		scsi_device_get(sdev);
> > +		spin_unlock_irqrestore(shost->host_lock, flags);
> 
> You can't use the host_lock to protect the list and then drop it in the
> middle of list traversal.  Doing this is bound to have repercussions for
> hotplug.  I know we're a total mess for hotplug now, but I'd rather not
> add to it.
> 

Probably already implied by your comment but...

I am using the lock to keep the list stable only during the traverse to
the next device which I will get a ref before dropping the lock. The
list could change during the call to the function (i.e an addition /
removal of nodes I do not have ref to).

Even if we went with a subsystem bus_for_each function I believe you are
asking for more state as previous discussed on the host offline subject
to not allow more additions. Correct?

> This problem can't be unique to SCSI, so I think what we need is
> something like a device generic function, like bus_for_each_device,
> except that it's device_for_each_child or something. where we get a
> properly ref counted and protected list traversal that will work for
> hotplugging.
> 

The bus_for_each solution currently use a rw sema which I thought would
not be a good choice for these type of operations as there is a
possibility that we may want to call functions (offline) in interrupt
context.

Are you indicating that sema operations would be ok?

A possible side issue that Mochel can correct me on is that the calling
function would be restricted some as it cannot call device_register /
device_unregister as it would block.

If we want to head this direction we may need to alter the relationship
of children nodes off hosts.

-andmike
--
Michael Anderson
andmike@us.ibm.com

