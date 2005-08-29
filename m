From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 0/2] fusion SAS support
Date: Mon, 29 Aug 2005 12:55:44 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C03CD049F@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52903 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751305AbVH2S42 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 14:56:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org, "Wade, Roy" <Roy.Wade@lsil.com>

On Monday, August 29, 2005 2:01 AM, Christoph Hellwig wrote:

The expander with one crossover cable has been shipped to you
this morning. The crossover should be connected to phy0 on the expander.

> > 
> > /sys/class/sas_port/port-4:3/port-12:0
> > /sys/class/sas_port/port-4:3/port-12:1
> > /sys/class/sas_port/port-4:3/port-12:2
> > /sys/class/sas_port/port-4:3/port-12:3
> > 
> > If so, then the sas_transport code needs to change.
> 
> In the /sys/class/ hierachy they will have to be flat due to the
> way the generic class_device code works.  No it's still open whether
> we will have a flat hierachy of class_devices or whether we'll attach
> extender ports to the struct device of the "parent" port.  I'll prefer
> the former because it keeps the hierachy simpler and mirrors what is
> done in FibreChannel, James prefers the latter.  I'll 
> probably prototype
> both.
> 


Does flat means all sas hbas and expanders would reside in
/sys/class/sas_port ??
How would one figure out the topology parent-child relationship
between hbas-expanders?  I think with large topologies having everything
on the same level will be very messy.   


> I think getting the NDA and docs is more important.  

That is on the way being worked. Hopefully very soon.
I have the spec sitting here next to me.
Ask if you have doubts on anything, and I will explain.


> What I really
> want to do is to call scsi_scan_target for every sas device 
> that's a scsi
> target, so that we can support multi-lun devices easily and 
> coherently with
> other SCSI transports.  Now I need to figure out how to properly get
> information out of the Fusion firmware to only report 
> attached sas devices,
> not individual luns, and I need to make sure different sas 
> devices never
> get the same target id, so scsi_scan_device does the right 
> thing.  This
> could mean I need to the work I suggested to Luben in a 
> previous mail to
> make ->id meaningless for SAS and similar transports, or a 
> scsi midlayer
> to fusion target id mapping.
> 

I will explain - in this loop below in your sas patch:

+	if (*phy_counter >= ioc->num_sas_ports) {
+		sas_add_target(ioc->sas_ports[pg0->PhysicalPort],
+				&ioc->sas_attached[pg0->PhysicalPort],
+				pg0->Bus, pg0->TargetID);
+	} else


add this check below - before calling sas_add_target, 
so you will get the unique scans for each valid scsi target. 
The SMP devices and phys entries for the direct hba phys will be ignored: 
 
			if (le32_to_cpu(sasDevicePg0->DeviceInfo) &
			    (MPI_SAS_DEVICE_INFO_SSP_TARGET |
			     MPI_SAS_DEVICE_INFO_STP_TARGET |
			     MPI_SAS_DEVICE_INFO_SATA_DEVICE )) {


Also - I suggest maintaining a link list of devices in 
the driver when sas_add_target is called. 
This having the sas address, and respective HCTL mapping, and 
other properties. Something similar to the function called 
mpt_sas_get_info() in the 3.02.55 driver.

Thus if you decide to make ->id meaningless for SAS(Lubens thread),
the scsi core could merely send sas address, or maybe an object, or handle, 
or what ever you decide.
Thus the driver could map back to the created object/handle when
sas_add_target occured.
Then for queue command, it can take the object/handle, then translate
to internal bus/target mapping so SCSI_IO request can be sent to 
the firmware as its is today.

> 
> 
> > Hot plug support - how is this going to be done. Take a look
> > at mptscsih_hot_plug_worker_thread, that I sent in 3.02.55.
> 
> We'll probably have a workqueue for it in the transport 
> class, but hotplug
> support isn't on the top of my TODO list, so it'll have to 
> wait a little.

What ever you decide.  Just to let you know the sas firmware send
"device_added" and "device_not_responding" events, so we know when
when devices come and go. We also have events for raid volumes
being added and removed on the fly, and the corresponding hidden phys disk
coming and going as well.  The current hotplug workqueue in the driver is
handling
raid and non-raid events for devices coming and going.
Something for you to consider when you get around to looking at hot plug.

Eric Moore
 



