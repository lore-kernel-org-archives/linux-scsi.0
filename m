From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Autosense requirement
Date: Wed, 31 Jul 2002 11:04:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207311604.g6VG4Dn02203@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA01720
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jul 2002 09:04:21 -0700
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Mon, 29 Jul 2002 16:18:46 PDT." <20020729161846.A4342@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

patmans@us.ibm.com said:
> I have some patches from the multi-path that I could break out,
> especially some list iterators -  multi-path needs the Scsi_Device
> separated from Scsi_Host. Iterators were added so the underlying
> structures are not visible - that is, so host_queue is not directly
> referenced, and I can put any type of data structure in its place.
> This is one of the broadest changes (potentially affects all adapter
> drivers) in the multi-path patch.

I was planning to introduce the Scsi_[Host,Device,Cmnd] structures to the 
concept of struct list_head as part of the error handler re-write.  The error 
handler needs lists for the concept of reset locality (i.e. dump all commands 
for all LUNS of this target, dump all commands for all devices on this bus), 
although its a non time critical section, so it wouldn't necessarily matter 
having to have it loop over every device to find only the ones it's interested 
in.

> Having Scsi_Device on its own list could also help in hot-replacement
> of single pathed devices (Scsi_Host can be removed without having to
> remove a Scsi_Device off of its host_queue).

Isn't this going to cause serious problems for the driverfs stuff?  
Effectively you're changing the parent pointer under the device which alters 
the layout of the device tree.

> If you make changes in the host/device list(s) please consider that I
> need to have the Scsi_Devices on their own list separate from the
> Scsi_host list. 

Could you post some of the details of this (separated from the multi-path 
patch if possible)?  Thanks,

James
 

