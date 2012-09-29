From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Sat, 29 Sep 2012 10:29:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209291024380.29902-100000@netrider.rowland.org>
References: <50665882.8020104@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:35829 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752371Ab2I2O3R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 10:29:17 -0400
In-Reply-To: <50665882.8020104@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oneukum@suse.de>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Sat, 29 Sep 2012, Aaron Lu wrote:

> > I don't think this is a good idea, quite frankly.  sr seems to be a too
> > generic place for that.
> 
> Does this mean sr can only have code that is useful to all devices it
> manages? i.e. If a piece of code enables a feature for a special kind of
> ODD(like the sata based ZPODD), it shouldn't be done in sr?

Drivers are allowed to have special features and quirks that apply only 
to some devices.

> There is nothing in theory stopping us from doing this in ata layer.
> For the loading mechanism, we can always send an ATAPI command to figure
> it out.
> 
> So gentlemen, I need your opinions on where this ZPODD code should live
> before I can continue this work, thanks.

Can arbitrary SCSI devices be ZP, or does this notion apply only to
ATAPI-based drives?  That's the key question, and the answer determines
where the ZP support belongs.

On the other hand, the sr driver certainly deserves to have some form 
of runtime PM support, even for devices that aren't ZP.

Alan Stern

