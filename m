From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Tue, 21 Jan 2003 08:30:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301211330.h0LDUZl02463@localhost.localdomain>
References: <alan@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id FAA20602
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2003 05:30:48 -0800
In-Reply-To: Message from Alan <alan@lxorguk.ukuu.org.uk>
   of "21 Jan 2003 03:31:54 GMT." <1043119913.13397.14.camel@dhcp22.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

alan@lxorguk.ukuu.org.uk said:
> Providing you refcount objects and defer freeing of resources its not
> normally too terrible  

We already have a struct device, which is a ref counted object precisely for 
this purpose, embedded inside Scsi_Device.

One of the issues doing this is fast reattachment: the device goes away then 
comes back before we've cleared the outstanding command queue.

In the latter case, I think we could use some of the work Luben Tuikov has 
been doing to make the cmnd structures tie more closely to the device:  as 
long as we remove the device from user visibility as soon as it is removed, we 
can keep the Scsi_Device object around until the ref count falls to zero, and 
even create a new one while this is going on.  Commands attached to the old 
device still error out.

It would still be nice if the trigger for Scsi_device removal came from a USB 
hotplug event at user level, but I'm not too bothered about that.

James


