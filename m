From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC] support for sysfs string based properties for SCSI (1/3)
Date: 05 May 2003 19:05:52 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1052179553.1888.461.camel@mulgrave>
References: <1051989099.2036.7.camel@mulgrave>
	<1051989565.2036.14.camel@mulgrave> <20030505170202.GA1296@kroah.com>
	<1052154516.1888.33.camel@mulgrave>  <20030505171745.GA1477@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030505171745.GA1477@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>, Mike Anderson <andmike@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2003-05-05 at 12:17, Greg KH wrote:
> On Mon, May 05, 2003 at 12:08:35PM -0500, James Bottomley wrote:
> > Nothing prevents users from doing it the callback way.  However,
> > callbacks aren't a scaleable interface for properties that have to be
> > shared and overridden.
> 
> I don't understand the "shared and overridden" aspect.  Do you mean a
> default attribute for all types of SCSI devices, with the ability for an
> individual device to override the attribute with it's own values if it
> wants to?  That still seems doable within the driver model today,
> without having to rely on bus specific functions.

Yes, but the problem is how to communicate the override between the HBA
driver and SCSI. The override is required because changing some
properties may require changes at many levels.  The queue_depth in the
example I gave is the obvious one:

- the device needs to make sure it has internal resources for the
revised queue depth.  It also has to implement the change.
- the mid-layer needs to do the adjustment
- As does the block layer (I didn't implement this one in my patch).

The interface obviously belongs in the SCSI API, but one API entry per
property causes the interface to explode and also makes it quite
difficult to add new ones, so we need a generic get/set property
interface; however, then we need to know what property, hence the
strings.

> Hm, this is _really_ calling for what Pat calls "attributes".  Take a
> look at the ones in the class model, and let me know if those would work
> for you for devices.  If so, I'll be glad to add them, which should help
> you out here.

Well, I analysed the class interface.  It currently won't do what we
need, but it might be able to if it supported an inheritance, so there
would be a device class which could then be extended by the drivers to
override the properties they need.  However, isn't this type of
inheritance going to be a real pain using function pointers, and if we
only support overrides of show/store, it's probably simpler just to
support the strings based interface.

James
