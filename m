From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Wed, 11 Jun 2008 14:24:42 -0500
Message-ID: <1213212282.3461.9.camel@localhost.localdomain>
References: <200806010415.05290.chris2553@googlemail.com>
	 <1212950276.3574.7.camel@localhost.localdomain>
	 <200806102206.26818.chris2553@googlemail.com>
	 <200806111858.05114.chris2553@googlemail.com>
	 <20080611191533.GA6189@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42543 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794AbYFKTYt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2008 15:24:49 -0400
In-Reply-To: <20080611191533.GA6189@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Chris Clayton <chris2553@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Wed, 2008-06-11 at 12:15 -0700, Greg KH wrote:
> On Wed, Jun 11, 2008 at 06:58:05PM +0000, Chris Clayton wrote:
> > Jun 11 17:48:13 upstairs udevd-event[1457]: wait_for_sysfs: wait for '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/ioerr_cnt' for 20 mseconds 
> > Jun 11 17:48:18 upstairs last message repeated 236 times
> 
> This doesn't look good.  It looks like a udev rule in your system is
> looking for a file that will never show up.  That's a short way to a
> long delay time :)
> 
> Try commenting out the rule that does this and see if things are fixed.

Actually, there's something seriously wrong here:  ioerr_cnt is a
property of the device, not of the host (as in it will never appear
under .../host4 but under .../host4/targetX:X:X/4:X:X:X/ioerr_cnt).
Perhaps an investigation of why udevd-event is looking under host4/ is
in order.

James


