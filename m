From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI device rescan, detection of disconnected device,
	or	switched devices.
Date: Thu, 31 Jul 2008 09:15:49 -0500
Message-ID: <1217513749.3333.7.camel@localhost.localdomain>
References: <1217248348.4133.51.camel@galr-linux>
	 <488DC55C.2050603@s5r6.in-berlin.de> <1217487434.25491.34.camel@galr-linux>
	 <4891792C.6020304@s5r6.in-berlin.de> <1217504895.25491.69.camel@galr-linux>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40543 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351AbYGaOPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 10:15:52 -0400
In-Reply-To: <1217504895.25491.69.camel@galr-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gal Rosen <galr@storwize.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

On Thu, 2008-07-31 at 14:48 +0300, Gal Rosen wrote:
> On Thu, 2008-07-31 at 10:34 +0200, Stefan Richter wrote:
> > Gal Rosen wrote:
> > > I will try to make my question more clear.
> > > I would like to put a box between the client and the storage, and to be
> > > fully transparent against the host. All changes on the storage
> > > (add/remove/extend devices) should be present automatically to the
> > > client. In a direct connection between client and storage the
> > > administrator will coordinate between the client and storage before
> > > making any changes, in my configuration I do not want to add
> > > administration work on my box that stands between the client and the
> > > storage.
> > > Addition is simple, the application on my box can once in a while scan
> > > the SCSI BUS, and then the Linux system will create new sg devices.
> > > In removal of a device the Linux system will not remove sg devices after
> > > scan. In that case again I can do it from my application, such when I
> > > get attention on SCSI command, I can decide to remove the device by
> > > echoing to the /sys file system.
> > 
> > I really don't know how the FibreChannel drivers handle device removal.
> > But from what I gather from the documentation of
> > fc_remote_port_delete(), which the qla2xxx drivers use, the /dev/sg
> > devices should automatically disappear
> >   - after a connection loss timeout,
> >   - provided that userspace doesn't have the device file opened
> >     (among else this is manifest in the kernel in a reference count of
> >     the logical unit device representation),
> >   - provided that you manage your device files with udev.
> > 
> > http://lxr.linux.no/linux+v2.6.26/drivers/scsi/scsi_transport_fc.c#L2756
> > 
> 
> This is true; when the remote port is no longer exists, after timeout
> all the sg devices will disappear, but what if I am changing the
> configuration in the disk array, and remove only one logical device.
> There will not be any event for that. The hotplug implementation in the
> SCSI today creates events of add/remove when adding/removing HBA, or
> when the FC link go down and up again, but not for additional and
> removal of devices. In the linux documentation in scsi_mid_low_api.txt
> it is written that "The hotplug concept may be extended to SCSI
> devices". I guess that nobody implemented it because what you said
> previously in this thread that someone could hold reference to the
> device.

Oh ... you're not really talking about hotplug, which is why everyone is
confused.  Hotplug is when you add or remove something from the bus.
What you've done is reconfigure the array.

Most of the hotplug we do depends on the transport model (because what's
on the transport is changing).  Array reconfiguration has no hotplug
event because SAM-3 has no real way of passing the information
asynchronously.  The best it can do is Unit Attention/reported luns data
has changed (asc=0x3f/ascq=0xe) on the next command.

The problem is that there's no way to process the event correctly even
when we get it.  All we can do is issue another report LUNS command and
compare.  However, just because it looks like a single LUN disappeared
doesn't mean the others weren't permuted or altered in some way (which
data we cannot get).

So ... this event is manual intervention required because you have to
tell SCSI what you did to the array, it can't work it out for itself.

James


