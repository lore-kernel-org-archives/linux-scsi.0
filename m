From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi_transport_sas: introduce a sas_port entity
Date: Fri, 16 Jun 2006 18:16:19 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70199C24@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9412 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751560AbWFQAQ1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jun 2006 20:16:27 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Monday, June 12, 2006 8:18 AM, James Bottomley wrote:  

> Actually, since the patch was over 100k and I've been running around a
> bit, I didn't really have time to look at it.  What I have 
> managed to do
> is to wedge the port object into the existing mptsas driver.  
> This means
> that it will still compile and run, and there's now more time 
> for you to
> sort out wide ports.

Sorry for the delay, due to me being out for the past three weeks.
I finally got to start looking at this patch late yesterday.
I notice you've already put this in your scsi-misc tree.
I wished you had looked at the source I sent. I realize it was
over 100K, but most of that was mpi updated headers.

How much testing was done on this patch?  I see sever regression
with the driver.  Hotplug it busted.  Hot adding any device will
panic.  Also, if you load the driver with devices, then unload the
driver, disconnect device, and reload, the driver panics. Also see 
some various panics just load/unload/load the driver stack, 
with no change of the topology.

> 
> What I did discover is that the actual firmware has no 
> concept of a port
> below the adapter

Yes it does.  The port_id field is valid when you've formed
a port by adding attached devices. This is found in phy_info[]->port_id.
The driver retrieves this in sas_io_unit_pg0, device_pg0, and
expander_pg1.
The port_id is formed at the top level of the hba, and all the devices
downstream
will all be on the same port_id, forming a sas domain.


, so I actually had to rejig 
> mptsas_probe_one_phy() to
> recognise ports.  I also noticed that on an expander device, 
> we allocate
> and end device for the port that's connected to the HBA.  I didn't do
> anything about this, since that was the behaviour of the old driver
> (even if incorrect), so I assume the wide port update will fix this.

You must be refering to the rphy parent/child relationship.  I never
understand why this concept was added, actually implemented by
Christoph.

Also, I thought you were removing all the concepts of remote phys when
you were
adding the port API.  I notice the driver still has rphy_add and
rphy_delete.
Can't the rphy concepts die?

> @@ -1270,8 +1274,43 @@
>  		phy_info->phy = phy;
>  	}
>  
> +	if (phy_info->attached.handle) {
> +		port_index = -1;
> +		for (i = 0; i < index; i++) {
> +			struct mptsas_phyinfo *tmp = 
> &phy_info[i - index];
> +			if (!tmp->attached.handle)
> +				continue;
> +			if (phy_info->attached.handle == 
> tmp->attached.handle) {
> +				port_index = tmp->port_num;
> +				phy_info->port_num = port_index;
> +				break;
> +			}
> +		}
> +		if (port_index == -1) {
> +			for (i = 0; ; i++) {
> +				struct mptsas_phyinfo *tmp = 
> &phy_info[i - index];
> +				if (!tmp->port) {
> +					port_index = i;
> +					phy_info->port_num = i;
> +					break;
> +				}
> +			}
> +		}
> +
> +		port = phy_info[port_index - index].port;

I'm not very confortable with this crude method of calulating where
the port object is placed in the the mptsas topology.  Here is
an dump of the data structure, where I have two wide ports, one
starts at phy_id=0, and the other at phy_id=4.  The port object
is phy in phy_info[0], and phy_info[1] respectively.  I'd rather
see the port object placed under the phy_info[] it belongs to, and
have the same object pointer in the place holder for all its phys
that form a wide port.

Current driver is:

phy_id=0 port_id=0 port_num=0 rphy=ffff81000af70430
port=ffff81000aa60400
phy_id=1 port_id=0 port_num=0 rphy=0000000000000000
port=ffff81000d14bc00
phy_id=2 port_id=0 port_num=0 rphy=0000000000000000
port=0000000000000000
phy_id=3 port_id=0 port_num=0 rphy=0000000000000000
port=0000000000000000
phy_id=4 port_id=4 port_num=1 rphy=ffff810005c81800
port=0000000000000000
phy_id=5 port_id=4 port_num=1 rphy=0000000000000000
port=0000000000000000
phy_id=6 port_id=4 port_num=1 rphy=0000000000000000
port=0000000000000000
phy_id=7 port_id=4 port_num=1 rphy=0000000000000000
port=0000000000000000

Id rather see:

phy_id=0 port_id=0 port_num=0 rphy=ffff81000af70430
port=ffff81000aa60400
phy_id=1 port_id=0 port_num=0 rphy=0000000000000000
port=ffff81000aa60400
phy_id=2 port_id=0 port_num=0 rphy=0000000000000000
port=ffff81000aa60400
phy_id=3 port_id=0 port_num=0 rphy=0000000000000000
port=ffff81000aa60400
phy_id=4 port_id=4 port_num=1 rphy=ffff810005c81800
port=ffff81000d14bc00
phy_id=5 port_id=4 port_num=1 rphy=0000000000000000
port=ffff81000d14bc00
phy_id=6 port_id=4 port_num=1 rphy=0000000000000000
port=ffff81000d14bc00
phy_id=7 port_id=4 port_num=1 rphy=0000000000000000
port=ffff81000d14bc00



> +
> +		if (!port) {
> +			port = phy_info[port_index - index].port =
> +				sas_port_alloc(dev, port_index);
> +			if (!port)
> +				return -ENOMEM;
> +			sas_port_add(port);
> +		}
> +		sas_port_add_phy(port, phy);
> +	}

Id rather you be sending the port identifier that our firmware provides
in
phy_info[].port_id, rather then an arbitrary calculated value.


>  		phy_info->starget = NULL;
> @@ -1822,14 +1866,16 @@
>  		       "attaching %s device, channel %d, id %d, 
> phy %d\n",
>  		       ioc->name, ds, ev->channel, ev->id, ev->phy_id);
>  
> +		port = phy_info[phy_info->port_id - 
> phy_info->phy_id].port;
> +

This is sole reason for panic in the ADD_DEVICE case.  The problem
is the port has not be set up by this point.  Usually the fw event
saying a device has been added occurs prior to the discovery event
that refreshes the topology.  Thus we will need to refresh the
topology prior to the time we pull the port, as well as adding a sanity
check to insure the port pointer is non-zero.


>  		mptsas_parse_device_info(&identify, 
> &phy_info->attached);
>  		switch (identify.device_type) {
>  		case SAS_END_DEVICE:
> -			rphy = sas_end_device_alloc(phy_info->phy);
> +			rphy = sas_end_device_alloc(port);
>  			break;
>  		case SAS_EDGE_EXPANDER_DEVICE:
>  		case SAS_FANOUT_EXPANDER_DEVICE:
> -			rphy = 
> sas_expander_alloc(phy_info->phy, identify.device_type);
> +			rphy = sas_expander_alloc(port, 
> identify.device_type);
>  			break;
>  		default:
>  			rphy = NULL;
> 

This switch case for edge and fanout expanders in the hotplug thread
needs
to be removed. Only end devices apply here.  The SAS_DEVICE_ADDED and 
SAS_DEVICE_NOT_RESPONDING events only apply to end devices, not
expanders.
We handle the adding of deleting of expanders when we get a discovery
event.

Also - I would like to point out that when I have a disk device that is
a wide port,
when its hot added containing, I will get the sas_device_added event on
the first 
phy that was added.  The handling of the other phys come later, called
from
a different instance of the hotplug tread.  We will need to call the
transport layer 
API sometime later to notify about the other phys added to the port.
The current code is not handling that case.

BTW: - James, do you have the equipment to create a disk device that is
a wide port?
The way I'm doing it is by connecting two 1068 SAS controller to
another.
On controller is running in initiator mode, and the other running in
target mode.
We have a target mode driver that creates ramdisk images to simulate
disk devices.  
Every disk device on each phy containing the same sas address, thus
forming a wide port.
Connect both controller with a quad crossover cable containing four
phys. 
That is how I'm testing here in our labs. Do you have two 1068s so you
can simulate this? 
If not, allow me to assit you with this setup.

Eric Moore 
