From: sullivan <sullivan@austin.ibm.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Tue, 9 Apr 2002 08:55:36 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020409085536.N7333@austin.ibm.com>
References: <patmans@us.ibm.com> <200204081917.g38JHg905081@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200204081917.g38JHg905081@localhost.localdomain>; from James.Bottomley@SteelEye.com on Mon, Apr 08, 2002 at 02:17:42PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Apr 08, 2002 at 02:17:42PM -0500, James Bottomley wrote:
> patmans@us.ibm.com said:
> > We could have a set of interfaces to get a SCSI UUID, and then have
> > hotplug tell us which interface (or module?) to use. That way we don't
> > require sg.
> 
> I'm in two minds about this one.  Deciding exactly what constitutes the UUID 
> for a particular device can be non trivial.  Usually you have to probe for the 
> supported vital product pages, and if they have the WWN one use that otherwise 
> fall back to the (less guaranteed to be unique) SCSI-2 serial number page or 
> finally make something up dependent on what unique numbers you can get from 
> the device.
> 
> It makes sense to me that this type of complex rule (of thumb almost) based 
> lookup is best done from user level by doing the explicit SCSI commands if 
> necessary.
> 
> However, I'm biased.  From a philosophical point of view, I like the hotplug 
> approach because it allows us to eject a lot of the use once initialisation 
> code into user space from the kernel.
> 
> > The device_list[] (black/white list) should also come from user land.
> > Maybe hotplug could get the device_list[] characteristics, including
> > the UUID method for the device.
> 
> > I'd also like a uuid stored in Scsi_Device for multi-path support in
> > the mid-layer (independent of how it's set). This uuid could not be
> > stored in the partition or as part of the file system. 
> 
> If we can come up with a nice, general mechanism, there's no reason why it 
> cannot apply outside the SCSI system, so I wouldn't necessarily tie it to 
> Scsi_Devce.  More likely (and actually what the persistent binding begins) is 
> to tie it to the concept of the Mochel internal device tree.

I think this is the decision that is the most difficult. Setting up nodes on driverfs provides a consistent location and format (if we are careful) for surfacing information on devices. I find it much more difficult to keep up with where stuff is and what format it's in in /proc. Also, I must confess that keeping track of what userland utilites to use to collect various pieces of device information strains my limited memory cells. Of course this comes at the cost of extra code in the kernel.

> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
