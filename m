From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Wed, 05 Sep 2012 20:06:27 +0200
Message-ID: <224495182.5nCXI73U12@linux-lqwf.site>
References: <Pine.LNX.4.44L0.1209041350490.1605-100000@iolanthe.rowland.org> <11638307.8MbrDPKO6y@linux-lqwf.site> <20120905152251.GA2794@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab2IESHs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Sep 2012 14:07:48 -0400
In-Reply-To: <20120905152251.GA2794@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>

On Wednesday 05 September 2012 23:22:55 Aaron Lu wrote:
> On Tue, Sep 04, 2012 at 08:47:15PM +0200, Oliver Neukum wrote:
> > On Tuesday 04 September 2012 13:59:38 Alan Stern wrote:

> > > What requirement are you talking about?  The "no media and door closed" 
> > > thing?  How is that a layering violation?  Are you suggesting this
> > 
> > There is no reason this requirement should apply to any other drive than the
> > device this is aimed at. It comes from the ability of this specific combination
> > to detect medium changes.
> 
> When suspending, I'll check the "no media inside and door closed"
> condition. Do you mean this is a special ability for devices driven by
> sr driver?

No. This is a special requirement for devices supporting ZPODD.
ZPODD are driven by sr. By sr drives many devices which are not sr.
For them doing the check you need to do for ZPODD devices
is wrong.
 
> And after the device is runtime suspended, if the platform has the
> ability to power off the device and the device supports notifying the
> host of user action(i.e inserting a disc to a slot type ODD or pressing
> the eject button of a tray type ODD), it will be powered off to save
> more power. This is ZPODD device.

Sure. I am not saying that your patches are wrong for ZPODD devices.
The problem is with devices that are not ZPODD.

> > > What happens on non-ACPI systems when a new disc is inserted into a
> > > suspended ODD?  How does the drive let the computer know that an insert
> > > event has occurred?
> > 
> > Good question. Again either the kernel polls the drive or there a mechanism
> > specific to the hardware.
> 
> Yes. And the mechanism is called ZPODD :-)

No. There is a mechanism known as ZPODD. There may be others.

> And the reason I didn't allow runtime suspend for medium inside and door
> closed case are:
> 1 ZPODD has a spec and it didn't allow that;

Yet there are drives which are not ZPODD.

> 2 It's not easy to implement. Imagine user just inserts a disc, and the
> sr_suspend routine checks that door is closed so that it wants to
> suspend the device. But actually, after user just inserts a disc, he
> definitely wants to use the device, so it's not a good thing to do. And
> if ZPODD is used, the device will be powered off instantly when the door
> is closed, this is not good.

Therefore you use a reasonable delay in the driver core.

	Regards
		Oliver
