From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Tue, 21 Jan 2003 13:16:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2D8E78.4050405@splentec.com>
References: <10426732153816@kroah.com> <200301210000.24705.oliver@neukum.name> <3E2C97D7.1070406@pacbell.net> <200301210150.55286.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:
> 
> Disconnect is not really a callback. There's a distinct lack of a back movement here.
> khubd -> usbcore -> disconnect() in driver -> [layer on top]
> 
> The proposed API in SCSI looks like:
> <bus system> -> LLD -> midlayer -> top layer -> midlayer -> LLD with destroy_slave()
> and that's not OK.

No, not quite.

When the Low Level Device Driver (LLDD), being the transport portal,
notices that the device is going away or has gone away from the
``fabric'' (wlg), it will fire a device-gone event with the kernel.
*Not* necessarily with SCSI Core, in fact I'd rather it didn't,
but with a well defined kernel entry for device-gone events.

At the same time the LLDD will start returning TARGET gone, or
whatever is appropriate to newly queued commands, and error out
all internally queued commands (if it does it's own queuing).
(I've seen this work nicely on mount and read/write(2) and fsck.)

I.e. the ``synchronization'' has started already by the LLDD erroring
out commands, new and queued.

All the while the kernel has started higher level cleaning up,
decrementing ref counts, etc, stuff which may not be so easy to be
cleaned up just by LLDD returning TARGET error.  Even though,
good design dictates that complete cleaning up should happen just
by the LLDD returning TARGET error (e.g. on mount), we *have* to allow
for this immediate high level entry point (as I mentioned above) notification,
which will be kind of ``meeting place'' for events like this.

Depending on what needs to be done at those ``higher'' levels, the
event will eventually bubble down to the SCSI Core with something like
scsi_remove_device() which will do slave_destroy() in the driver.

The point is that at that point in time, it will be *safe* to do
scsi_remove_device() as all ULP have alreay been notified, and they've
relinquished their use of the LLD (Low Level Device), thus the safety.

But there's no such thing as ``waiting around indefinitely'' or
``blocking wait'' as you've suggested in some of your emails.

Even if this UL entry point doesn't do anything, ref counts should
go to zero, after all users error out on this device, at which point
the user can remove the device from *the system* by hand/old method
through proc or whatever finalizes for 2.6.

Those are more or less my thoughts on the subject.

-- 
Luben


