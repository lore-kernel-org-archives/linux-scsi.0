From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB storage devices and SAT
Date: Mon, 4 Aug 2008 11:51:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0808041147580.3818-100000@iolanthe.rowland.org>
References: <489656EC.5000602@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34037 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752998AbYHDPv6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2008 11:51:58 -0400
In-Reply-To: <489656EC.5000602@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Mon, 4 Aug 2008, Douglas Gilbert wrote:

> USB storage devices that support SAT (the T10 SCSI to ATA
> translation standard) are beginning to appear.
> 
> SAT enables tools like smartmontools to access SMART data
> on a ATA disk in a USB enclosure. We have run into
> a problem. It seems that the usb storage subsystem is wedded
> to the idea of sense data that is no longer than 18 bytes. **
> That doesn't play well with SAT which uses descriptor format
> sense data that is made up of an 8 byte header plus zero or
> more descriptors. SAT uses a 14 byte "ATA return" (sense)
> descriptor to yield the ATA registers. That means the sense
> data length is 22 bytes when an ATA return descriptor is
> required.
> 
> Alan Stern has already noted to another smartmontools developer
> that such a change is likely to break some USB storage devices.
> Perhaps the maximum sense buffer size could be optionally
> specified per usb storage device. Alternatively the usb mass
> storage logic could make some dynamic decisions itself.
> For example if the (disk) device responds successfully to either
> SCSI ATA PASS_THROUGH (12 or 16 byte) command then it will
> be capable of (at least) 22 byte sense data. A T10 vendor
> identification field in a standard INQUIRY response of
> "ATA     " is another indication of a device that supports
> SAT.

If either of these techniques could be used for dynamically detecting
when a device can reliably support 22-byte REQUEST SENSE, they would be
okay.

I tend to agree with Matt that it would be best to have the higher
layers tell usb-storage exactly how much sense data they want to get.
The problem is that these higher layers would not know about the 
18-byte restriction on many earlier USB devices, so usb-storage would 
probably end up needing to make its own dynamic decisions anyway.

Alan Stern


