From: sullivan <sullivan@austin.ibm.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Tue, 9 Apr 2002 08:35:36 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020409083536.M7333@austin.ibm.com>
References: <200204081917.g38JHg905081@localhost.localdomain> <3CB23461.1FA57A9E@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3CB23461.1FA57A9E@torque.net>; from dougg@torque.net on Mon, Apr 08, 2002 at 08:22:57PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Mon, Apr 08, 2002 at 08:22:57PM -0400, Douglas Gilbert wrote:
> James Bottomley wrote:
> > 
> > patmans@us.ibm.com said:
> > > We could have a set of interfaces to get a SCSI UUID, and then have
> > > hotplug tell us which interface (or module?) to use. That way we don't
> > > require sg.
> > 
> > I'm in two minds about this one.  Deciding exactly what constitutes the UUID
> > for a particular device can be non trivial.  Usually you have to probe for the
> > supported vital product pages, and if they have the WWN one use that otherwise
> > fall back to the (less guaranteed to be unique) SCSI-2 serial number page or
> > finally make something up dependent on what unique numbers you can get from
> > the device.
> > 
> > It makes sense to me that this type of complex rule (of thumb almost) based
> > lookup is best done from user level by doing the explicit SCSI commands if
> > necessary.
> > 
> > However, I'm biased.  From a philosophical point of view, I like the hotplug
> > approach because it allows us to eject a lot of the use once initialisation
> > code into user space from the kernel.
> 
> Interesting discussion.
> 
> To see what the hotplug subsystem approach might look like,
> see http://www.torque.net/scsi/scsimon.html . This is a
> proposed scsi subsystem upper level driver (gathering dust). 
> What sets it apart from the others is that it is not device
> based. It has a single (misc) device name and can be thought 
> of as a window through to the scsi mid level. It supplies 
> hotplug alerts whenever a scsi device is attached or detached.
> [Unfortunately scsi hosts being registered or unregistered
> does not cause hotplug alerts.] Attaches and detaches are
> given event numbers (ascending sequence) and a time_since_boot.
> 
> That said, I like the devfs/devfsd approach as well.
>  
Thanks Doug. I've taken a look at it looks like it would work very well in providing the event generation support in the non devfs case.


> > > The device_list[] (black/white list) should also come from user land.
> > > Maybe hotplug could get the device_list[] characteristics, including
> > > the UUID method for the device.
> > 
> > > I'd also like a uuid stored in Scsi_Device for multi-path support in
> > > the mid-layer (independent of how it's set). This uuid could not be
> > > stored in the partition or as part of the file system.
> > 
> > If we can come up with a nice, general mechanism, there's no reason why it
> > cannot apply outside the SCSI system, so I wouldn't necessarily tie it to
> > Scsi_Devce.  More likely (and actually what the persistent binding begins) is
> > to tie it to the concept of the Mochel internal device tree.
> 
Patrick Mochel had mentioned before that he was looking at providing a unique identifier field as part of the common driverfs infrastructure. I'll check and see what his current thoughts are.

> In Patrick Mansfield's and my report_lun/twin_inquiry patch
> the full INQUIRY response (evpd=0 cmdtt=0) is placed in
> Scsi_Device. It could be useful to make that available 
> (in ascii-hex) via driverfs/hot_plug to the user space.
Sounds good. I'll take a look at the patch and see about adding the driverfs implementation needed to support it.

> 
> Eric's point is a good one about dirty INQUIRY data. This
> is especially the case with what might be a large
> group of "scsi" devices that linux needs to cope with:
> usb2 and ieee1394 talking to an external ATA disk. For
> the same Maxtor disk one INQUIRY (1394) tells me that it
> is a scsi 6 compliant device while the other INQUIRY (usb2)
> truncates the response at 28 bytes. I'm pretty sure they ignore
> the evpd bit as well.
> 
> 
> I'm attempting to get this patch working against 2.5.7-dj3
> (as it has captured most of the good patches from the list
> that haven't made it any further to date). There is a long
> way to go but here are some notes:
>   - driverfs is documented in:
>      Documentation/driver-model.txt
>      Documentation/filesystems/driverfs.txt
>   - driverfs in built into 2.5 kernels but needs to be
>     mounted. The documentation uses "/devices" as a
>     mount point; driverfs seems more comfortable with me:
>       mkdir /driverfs ; mount -t driverfs none /driverfs
> 
> Doug Gilbert
