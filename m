From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 08 Apr 2002 14:17:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204081917.g38JHg905081@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA20327
	for <linux-scsi@vger.kernel.org>; Mon, 8 Apr 2002 12:17:47 -0700
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Mon, 08 Apr 2002 11:27:36 PDT." <20020408112735.A26427@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org

patmans@us.ibm.com said:
> We could have a set of interfaces to get a SCSI UUID, and then have
> hotplug tell us which interface (or module?) to use. That way we don't
> require sg.

I'm in two minds about this one.  Deciding exactly what constitutes the UUID 
for a particular device can be non trivial.  Usually you have to probe for the 
supported vital product pages, and if they have the WWN one use that otherwise 
fall back to the (less guaranteed to be unique) SCSI-2 serial number page or 
finally make something up dependent on what unique numbers you can get from 
the device.

It makes sense to me that this type of complex rule (of thumb almost) based 
lookup is best done from user level by doing the explicit SCSI commands if 
necessary.

However, I'm biased.  From a philosophical point of view, I like the hotplug 
approach because it allows us to eject a lot of the use once initialisation 
code into user space from the kernel.

> The device_list[] (black/white list) should also come from user land.
> Maybe hotplug could get the device_list[] characteristics, including
> the UUID method for the device.

> I'd also like a uuid stored in Scsi_Device for multi-path support in
> the mid-layer (independent of how it's set). This uuid could not be
> stored in the partition or as part of the file system. 

If we can come up with a nice, general mechanism, there's no reason why it 
cannot apply outside the SCSI system, so I wouldn't necessarily tie it to 
Scsi_Devce.  More likely (and actually what the persistent binding begins) is 
to tie it to the concept of the Mochel internal device tree.

James


