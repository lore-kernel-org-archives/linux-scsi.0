From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] scsi_transport_sas: introduce a sas_port entity
Date: Sat, 17 Jun 2006 12:06:26 -0700
Message-ID: <1150571206.3283.18.camel@mulgrave>
References: <664A4EBB07F29743873A87CF62C26D70199C24@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:48285 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750712AbWFRXOQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jun 2006 19:14:16 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70199C24@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-06-16 at 18:16 -0600, Moore, Eric wrote:
> Sorry for the delay, due to me being out for the past three weeks.
> I finally got to start looking at this patch late yesterday.
> I notice you've already put this in your scsi-misc tree.
> I wished you had looked at the source I sent. I realize it was
> over 100K, but most of that was mpi updated headers.

With the tiny amount of bandwidth I had left after doing sas_port, I
couldn't find the time to look through a 100k patch that wasn't
production quality to work out what it was doing.

I just need the smallest patch that keeps mptsas compiling while I push
the class changes upstream.  You can patch it out in favour of yours
when you get it working .. as long as you can solve the expander wide
port issue.

> How much testing was done on this patch?  I see sever regression
> with the driver.  Hotplug it busted.  Hot adding any device will
> panic.  Also, if you load the driver with devices, then unload the
> driver, disconnect device, and reload, the driver panics. Also see 
> some various panics just load/unload/load the driver stack, 
> with no change of the topology.

It works for me in my configuration ... which is about the level of
testing of everything I do.

> > 
> > What I did discover is that the actual firmware has no 
> > concept of a port
> > below the adapter
> 
> Yes it does.  The port_id field is valid when you've formed
> a port by adding attached devices. This is found in phy_info[]->port_id.
> The driver retrieves this in sas_io_unit_pg0, device_pg0, and
> expander_pg1.
> The port_id is formed at the top level of the hba, and all the devices
> downstream
> will all be on the same port_id, forming a sas domain.

No, it doesn't ... that's the point and the problem.  Ports are formed
not only on the HBA but also on the expander. See for example the nice
diagram under the SAS v2 standard (r02) section 4.1.10 Figure 29
(Multiple Connections on Wide Ports).  The thing I'm trying to show,
which the fusion BIOS apparently doesn't do is the wide ports on
expanders.  Without this, we can't show the true tree topology.

I used the debugging mode of the driver to verify that for a wide port
to an expander, all the port_id's of the expander phy were the the HBA
port, not the expander port.  If I'd taken that, I'd have rolled up all
the phys with separate ports into a spurious wide port.

> , so I actually had to rejig 
> > mptsas_probe_one_phy() to
> > recognise ports.  I also noticed that on an expander device, 
> > we allocate
> > and end device for the port that's connected to the HBA.  I didn't do
> > anything about this, since that was the behaviour of the old driver
> > (even if incorrect), so I assume the wide port update will fix this.
> 
> You must be refering to the rphy parent/child relationship.  I never
> understand why this concept was added, actually implemented by
> Christoph.
> 
> Also, I thought you were removing all the concepts of remote phys when
> you were
> adding the port API.  I notice the driver still has rphy_add and
> rphy_delete.
> Can't the rphy concepts die?

an rphy is effectively dead ... that's why the umbrella class is called
"sas_device".  It just means think on the other end of the port.

> BTW: - James, do you have the equipment to create a disk device that is
> a wide port?
> The way I'm doing it is by connecting two 1068 SAS controller to
> another.
> On controller is running in initiator mode, and the other running in
> target mode.
> We have a target mode driver that creates ramdisk images to simulate
> disk devices.  
> Every disk device on each phy containing the same sas address, thus
> forming a wide port.
> Connect both controller with a quad crossover cable containing four
> phys. 
> That is how I'm testing here in our labs. Do you have two 1068s so you
> can simulate this? 
> If not, allow me to assit you with this setup.

No ... I'm going to try wiring two expanders together in a wide port to
do this, but I suspect I'm going to have difficulty with the cable
conspiracy.

James


