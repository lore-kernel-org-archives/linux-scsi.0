From: Oliver Neukum <Oliver.Neukum@lrz.uni-muenchen.de>
Subject: Re: [RFC] SCSI Hotplug for lk 2.5
Date: Fri, 2 Aug 2002 11:40:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208021113.g72BD2m01761@fachschaft.cup.uni-muenchen.de>
References: <3D49BCDB.392ACAA4@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D49BCDB.392ACAA4@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org


> Here are five categories of SCSI events that are candidates for
> hotplug alerts:
> 	1) scsi (lower level) driver addition or removal
> 	2) scsi host (initiator) addition or removal
> 	3) scsi device (target/lun) addition or removal
> 	4) removable media addition or removal
> 	5) unit attention or "asynchronous event notification"
> I believe hotplug alerts for 2) and 3) are required; for 1)
> is questionable and for 4) + 5) would be "nice to have".

How about new paths to a device? It seems that the FibreChannel
people need that.

> The existing /sbin/hotplug subsystem would be called from the
> kernel space with a first "command line" parameter of "scsi"
> with the following environment variables:
> 	ACTION		add | remove [ | event {for UA or AEN} ]
> 	CATEGORY	DRIVER | HOST | TARGET | MEDIA | EVENT
> 	TARGET_PATH	{for categories TARGET, MEDIA and EVENT}
> 	HOST_PATH	{for categories MEDIA, TARGET, and HOST}
> 	DRIVER_PATH	{for all categories}
> 	PERIPHERAL_TYPE	{for categories MEDIA and TARGET}

Merge this with CATEGORY ?

> 	SCSI_LEVEL	{for categories MEDIA and TARGET}
> 	SCSI_PROTOCOL	SPI | FC | USB_MASS_STORAGE | SBP | SAS ...
> 	.....
> 	VENDOR
> 	PRODUCT
> 	REVISION
>
> There is a trade-off between how much information is passed to
> /sbin/hotplug as environment variables and how much is available
> from driverfs and other sources. Timing of the alerts is important:

Ideally you'd want reduced functionality without driverfs mounted.

> the ACTION=add should be as late as possible so that all driverfs
> information is available (and upper level drivers have attached
> to the device ?).

Yes, after that.

> ACTION=remove (apart from media) comes with no additional
> driverfs (or other kernel) information because the
> host/device is gone :-) In the scsimon driver (see note c) ) there

This is very bad. You may very well have to change permissions
of a device node.

	Regards
		Oliver
