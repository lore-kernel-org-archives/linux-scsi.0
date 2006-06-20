From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi_transport_sas: introduce a sas_port entity
Date: Tue, 20 Jun 2006 11:37:47 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7019A013@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:8616 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750721AbWFTRhy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 13:37:54 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Saturday, June 17, 2006 1:06 PM, James Bottomley wrote:
> 
> With the tiny amount of bandwidth I had left after doing sas_port, I
> couldn't find the time to look through a 100k patch that wasn't
> production quality to work out what it was doing.

Ok, I will try to work on it this week, and see what I can accomplish.
Next week I have to refocus on SLES10 drivers having my internal driver 
implementation of wide ports for our customer shipment; e.g.
the 100K patch I sent, since the wide port API is not there.

> 
> I just need the smallest patch that keeps mptsas compiling 
> while I push
> the class changes upstream.  You can patch it out in favour of yours
> when you get it working .. as long as you can solve the expander wide
> port issue.

The scsi-misc-2.6 patch with todays date in your kernel.org
home folder has all the wide port API changes backed out?  
Is that on purpose, and what is your plans for your 2.6.18
push to Linus having this?

http://www.kernel.org/pub/linux/kernel/people/jejb/


> 
> > How much testing was done on this patch?  I see sever regression
> > with the driver.  Hotplug it busted.  Hot adding any device will
> > panic.  Also, if you load the driver with devices, then unload the
> > driver, disconnect device, and reload, the driver panics. Also see 
> > some various panics just load/unload/load the driver stack, 
> > with no change of the topology.
> 
> It works for me in my configuration ... which is about the level of
> testing of everything I do.

Ok, then you've not tested hot adding and removing devices/expanders,
nor
unloading and loading the driver as a module.  After further review,
I notice the mptsas driver is not ever calling sas_port_delete_phy, nor
sas_port_delete at driver unload time, as well as hot removing expanders

(which is handled from mptsas_delete_expander_phys).


> 
> > > 
> > > What I did discover is that the actual firmware has no 
> > > concept of a port
> > > below the adapter
> > 
> > Yes it does.  The port_id field is valid when you've formed
> > a port by adding attached devices. This is found in 
> phy_info[]->port_id.
> > The driver retrieves this in sas_io_unit_pg0, device_pg0, and
> > expander_pg1.
> > The port_id is formed at the top level of the hba, and all 
> the devices
> > downstream
> > will all be on the same port_id, forming a sas domain.
> 
> No, it doesn't ... that's the point and the problem.  Ports are formed
> not only on the HBA but also on the expander. See for example the nice
> diagram under the SAS v2 standard (r02) section 4.1.10 Figure 29
> (Multiple Connections on Wide Ports).  The thing I'm trying to show,
> which the fusion BIOS apparently doesn't do is the wide ports on
> expanders.  Without this, we can't show the true tree topology.
> 
> I used the debugging mode of the driver to verify that for a wide port
> to an expander, all the port_id's of the expander phy were the the HBA
> port, not the expander port.  If I'd taken that, I'd have 
> rolled up all
> the phys with separate ports into a spurious wide port.

Correct.  Our implementation has all the port identifiers the same
as the port identifier downstream from the parent HBA.  However with
your's, all
expanders will be having 0 based port identifiers.  Meaning devices on
one expander will endup with the same port identifier as the devices an
another expanders, since index referencing for all expanders start at
zero.
So what this means if channel matters to anyone, or port identifier,
that
someone migrating from older kernels to newer kernel, will end up with
different values.  Id rather not change current implmentation, honoring 
the firmware port id.  Perhaps someday the firmware folks will fix it,
and
Linux drivers would be in line with what mpt firwmare provides.


> > Can't the rphy concepts die?
> 
> an rphy is effectively dead ... that's why the umbrella class 
> is called
> "sas_device".  It just means think on the other end of the port.

Ok fine.  I still think its not required as the port concept
has been a added.  Also, in the mpt driver the rphy instance 
is created for both sides of the port. There is a parent and child
relationship with objects pointing to each other.  
I wonder if the adaptec driver is doing the same?

> 
> No ... I'm going to try wiring two expanders together in a 
> wide port to
> do this, but I suspect I'm going to have difficulty with the cable
> conspiracy.

Let me know if you want a wide port end device.  Its nice to have that
for testing as well as wide ports between expanders.

