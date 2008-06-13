From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Fri, 13 Jun 2008 09:12:50 -0500
Message-ID: <1213366370.3434.1.camel@localhost.localdomain>
References: <200806010415.05290.chris2553@googlemail.com>
	 <485027AC.6060901@s5r6.in-berlin.de>
	 <1213212965.3461.12.camel@localhost.localdomain>
	 <200806130656.43016.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46647 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677AbYFMOM5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2008 10:12:57 -0400
In-Reply-To: <200806130656.43016.chris2553@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chris2553@googlemail.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org

On Fri, 2008-06-13 at 06:56 +0000, Chris Clayton wrote:
> Hi James,
> 
> On Wednesday 11 June 2008, James Bottomley wrote:
> > On Wed, 2008-06-11 at 21:29 +0200, Stefan Richter wrote:
> > > James Bottomley wrote:
> > > > On Wed, 2008-06-11 at 12:15 -0700, Greg KH wrote:
> > > >> On Wed, Jun 11, 2008 at 06:58:05PM +0000, Chris Clayton wrote:
> > > >>> Jun 11 17:48:13 upstairs udevd-event[1457]: wait_for_sysfs: wait for
> > > >>> '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.
> > > >>>0/host4/ioerr_cnt' for 20 mseconds Jun 11 17:48:18 upstairs last
> > > >>> message repeated 236 times
> > > >>
> > > >> This doesn't look good.  It looks like a udev rule in your system is
> > > >> looking for a file that will never show up.  That's a short way to a
> > > >> long delay time :)
> > > >>
> > > >> Try commenting out the rule that does this and see if things are
> > > >> fixed.
> > > >
> > > > Actually, there's something seriously wrong here:  ioerr_cnt is a
> > > > property of the device, not of the host (as in it will never appear
> > > > under .../host4 but under .../host4/targetX:X:X/4:X:X:X/ioerr_cnt).
> > > > Perhaps an investigation of why udevd-event is looking under host4/ is
> > > > in order.
> > >
> > > So the change which commit b0ed43360fdca227048d88a08290365cb681c1a8
> > > "[SCSI] add scsi_host and scsi_target to scsi_bus" introduced is leading
> > > the udev scripts onto a wrong trail?
> >
> > Yes, I think so ... what it does is make us get bus events for the
> > target as well as the lun, whereas without it we only get them for the
> > lun.  I think something is misparsing the new target event and this is
> > where the trouble is coming from.
> >
> 
> I assume that since we now the source of this problem, you can create it at 
> will. I only mention because if you need me to test a patch, it will have to be 
> before Tuesday, June 17 - I go on holiday (vacation) on that day.

Yes, we can; thanks!

The problem though is that it's in the udev scripts, so there's nothing
we can fix in the kernel, we now need to persuade the various distros to
fix it (if they're actually broken), so it might take a while.

James


