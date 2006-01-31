From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: Re: [PATCH] add SPI transport class to fusion
Date: Mon, 30 Jan 2006 21:39:42 -0700
Message-ID: <000b01c62620$5b72ffb0$2c1015ac@ericmoore>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F22140C@NAMAIL2.ad.lsil.com> <1138670309.3283.54.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:13752 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030230AbWAaEjz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 23:39:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@lst.de

On Monday, January 30, 2006 6:18 PM, James Bottomley wrote:

> If we can get the inquiry strings of this GEM device, we can blacklist
> only it (presumably it lies about its capabilities in its inquiry page
> and then goes out to lunch when people try to negotiate with it).
> 

I will see if I can find a system with GEM proc, and send that info tommorrow.

>> Id rather we being creating a virtual channel for the RAID volumes on
>> channel=1, and leave the hidden disks on channel=0 along with all other
>> real devices.   That is what we are doing in mptsas.c, and I would like
>> to keep similar logic so we are not confusing the customer where the
>> raid
>> volumes are located.
> 
> I'd love to do this ... unfortunately, that will change the existing
> numbering for RAID arrays (for instance, my current IM raid is 6:0:0:0,
> if I follow this it would now become 6:1:0:0, which wouldn't be the same
> as the fusion bios).
> 

For SAS, nothing is matching BIOS H:C:T:L mapping when
the driver loads.  For example, an IM raid volume at 6:0:0:1, 
would end up being at 6:8:0:1 when the driver loads.  
That provided you had an 8 port card.   Or at  6:4:0:1 if you
had a 4 port card.  

What we are doing in that driver is setting the virtual channel = `ioc->num_ports`.
So for SAS1068, the `ioc->num_ports=8`.
and for SAS1064 the `ioc->num_ports=4`.
.
So if we did this in the SPI driver, the virtual channel =`ioc->num_ports=1`.

(this  hoping this not breaking any applications with assumptions that
there is only one channel for devices)

>>   For instance, the 1068 has upto 8 ports, so we
>> put the virtual channel out on channel=8.   I'm not sure how the
>> sdev->no_uld_attach flag works, e.g my concern is whether this flag
>> would work when we mix real exposed devices and hidden disk on 
>> the same channel? If that works, would it be possible for you to change
>> this?
> 
> The gating problem is that we have to have unique numbers for H:C:T:L
> regardless of the flag and the fusion bios seems happy to have a logical
> device and a physical device on the same number.  If the bios would
> assign non overlapping target id's then we'd be fine with a mixture of
> hidden and exposed devices on one channel, but as it doesn't there has
> to be an artificial way of differentiating them.
> 

Is the BIOS H:C:T:L mapping for RAID volumes the issue?  
Its already broken in the SAS implementation, so I'm thinking
what difference does it make here?

The problem of overlapping ID's can be solved something like this:

Where `ioc->num_ports=1`

Prior to slave_alloc, we already have the information on which target_ids
belong to the hidden disk, and which target_ids is belong to the raid_volume.

Volume target_id = ioc->raid_data.pIocPg2->RaidVolume[].VolumeID 
Hidden Device target id = ioc->raid_data.pIocPg3->PhysDisk[].PhysDiskID

>From slave_alloc, we create our own virtual device/target, setting our own unique mapping,
and private flags accordingly. 

So for channel=0, for all target_ids equal to pIocPg3->PhysDisk[].PhysDiskID, then 
`vdev->vtarget->tflags` equal to MPT_TARGET_FLAGS_RAID_COMPONENT , 
and we set sdev->no_uld_attach = 1.  For non-raided devices on this
channel, we set sdev->no_uld_attach = 0. 
All queue_command request for hidden devices with tflags set for RAID_COMPONENT, 
will be sent with function=MPI_FUNCTION_SCSI_IO_REQUEST.

So for channel=`ioc->num_ports`,  and the target_ids equal to pIocPg2->RaidVolume[].VolumeID 
`vdev->vtarget->tflags` &= ~(MPT_TARGET_FLAGS_RAID_COMPONENT ), and some
magic done to spi_transport so dv is not done to any device on channel=`ioc->num_ports`.
All queue_command request are sent with function=MPI_FUNCTION_SCSI_IO_REQUEST.

And other places in your spi code you can assume that `ioc->num_ports`, is the RAID channel.


>> YOur only queise io when commands are issued in the context of
>> mptspi_dv_device,
>> meaning  mptscsih_quiese_raid() is called over there.
>> But what about someone opening a /dev/sg0 handle, and sending data
>> across?  Do you think
>> we should be queuiese io for all io doing RAID_PASSTHRU from
>> queue_command entry point,
>> instead of only handling the dv case.  But what about the performance
>> hit of loading
>> driver when dv is going on.  Any thoughts on this?
> 
> Yes ... it's the job of whoever is issuing passthrough I/O to ensure the
> RAID is quiesced (if they need it ... there are plenty of commands that
> could be usefully executed even with the RAID running), so really, we
> only need it for the DV because additional I/O could interfere with
> that.
> 

I'm not clear what your saying.

My concern is this:
Someone opens a handle to /dev/sda which mapps to the RAID volume,
and at the same some someone opens a handle to a hidden device handle /dev/sg1, 
then  a write is sent to the driver occuring to both device handles simultaneously.   
What magic is occuring above the fusion driver in the sg stack that quiesce's the IO from
being sent to /dev/sda?  

Right now I'm not totally convienced that we will not experience data corruption unless
we send to firmware the QUIESE_IO call from the mptscsih_quiese_raid() function.
The mere result would be firmware is quiesing the IO in firmware queue to 
the raid volume at /dev/sda, when data is being sent to the hidden disk at /dev/sg1.

> OK ... that's a consequence of the code transforming to nothing.  It
> probably needs to be resurrected as a spi_schedule_dv() call.

right, we need to do spi_schedule_dv() from mpt_resume. 

Thanks
 


