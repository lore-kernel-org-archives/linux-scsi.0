From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: 25 Mar 2003 11:37:49 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048613872.2070.12.camel@mulgrave>
References: <20030325100704.GC3868@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030325100704.GC3868@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-03-25 at 04:07, Mike Anderson wrote:

This isn't right:

> +	spin_lock_irqsave(shost->host_lock, flags);
> +	for (lh = shost->my_devices.next; 
> +	      (!error) && (lh != &shost->my_devices);) {
> +		sdev = list_entry(lh, struct scsi_device, siblings);
> +		scsi_device_get(sdev);
> +		spin_unlock_irqrestore(shost->host_lock, flags);

You can't use the host_lock to protect the list and then drop it in the
middle of list traversal.  Doing this is bound to have repercussions for
hotplug.  I know we're a total mess for hotplug now, but I'd rather not
add to it.

This problem can't be unique to SCSI, so I think what we need is
something like a device generic function, like bus_for_each_device,
except that it's device_for_each_child or something. where we get a
properly ref counted and protected list traversal that will work for
hotplugging.

Pat, can you think of anything nicely generic?  We have a non-standard
list to traverse and would probably have to hold the list lock prior to
entry?

James


