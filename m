From: Ben Collins <bcollins@debian.org>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 10:32:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227153247.GL4019@phunnypharm.org>
References: <1077842444.2662.123.camel@mulgrave> <20040227124811.A32109@infradead.org> <1077894499.1806.14.camel@mulgrave> <20040227151551.GK4019@phunnypharm.org> <1077895775.2157.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bristol.phunnypharm.org ([65.207.35.130]:15835 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S263020AbUB0PeF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 10:34:05 -0500
Content-Disposition: inline
In-Reply-To: <1077895775.2157.22.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Feb 27, 2004 at 09:29:34AM -0600, James Bottomley wrote:
> On Fri, 2004-02-27 at 09:15, Ben Collins wrote:
> > If a driver somehow removes it's scsi host and then later attempts a
> > scsi_host_lookup for the id, I think that driver is broken anyway. IOW,
> > it is safe as long as you aren't broken in the first place.
> 
> I'm not thinking about the driver, I'm thinking about the hotplug
> system.  Hotplug events are queued and not locked.  The event identifies
> the scsi device by the (host number, channel number, target, lun)
> quadruple.  The reason it has to do that is that the /proc/scsi/scsi
> add/remove device operate on these numbers.
> 
> If we get a sequence of racing connects and disconnects, we could mis
> identify the devices because of the host number reuse.  That's the race
> I want assurance of making safe if we move to reusing the numbers.
> 
> Obviously, one solution would be to fix the /proc add/remove, but it's a
> bit late in 2.6 to change the interface, I think.

On the same token, if you hot plug/unplug a single device (not a host)
on the same host, you will already have this problem. This wont make the
problem any worse or better. Devices are more likely to get
plugged/unplugged anyway (well, in the case of usb/firewire you
plug/unplug a host/dev combination, but still).

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
WatchGuard - http://www.watchguard.com/
