From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: 27 Feb 2004 09:29:34 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077895775.2157.22.camel@mulgrave>
References: <1077842444.2662.123.camel@mulgrave>
	<20040227124811.A32109@infradead.org> <1077894499.1806.14.camel@mulgrave>
	<20040227151551.GK4019@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:22745 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263017AbUB0P3v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 10:29:51 -0500
In-Reply-To: <20040227151551.GK4019@phunnypharm.org>
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-02-27 at 09:15, Ben Collins wrote:
> If a driver somehow removes it's scsi host and then later attempts a
> scsi_host_lookup for the id, I think that driver is broken anyway. IOW,
> it is safe as long as you aren't broken in the first place.

I'm not thinking about the driver, I'm thinking about the hotplug
system.  Hotplug events are queued and not locked.  The event identifies
the scsi device by the (host number, channel number, target, lun)
quadruple.  The reason it has to do that is that the /proc/scsi/scsi
add/remove device operate on these numbers.

If we get a sequence of racing connects and disconnects, we could mis
identify the devices because of the host number reuse.  That's the race
I want assurance of making safe if we move to reusing the numbers.

Obviously, one solution would be to fix the /proc add/remove, but it's a
bit late in 2.6 to change the interface, I think.

James


