From: David Brownell <david-b@pacbell.net>
Subject: Re: Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 12:08:48 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <3E2C5750.2040301@pacbell.net>
References: <10426732153816@kroah.com> <200301170043.36577.oliver@neukum.name>
 <20030117085047.GB2531@beaverton.ibm.com>
 <200301171155.36452.oliver@neukum.name>
 <20030117105414.E359@one-eyed-alien.net> <3E2C3380.3070700@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Luben Tuikov <luben@splentec.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.name>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Luben Tuikov wrote:

>> The way this should work is that the LLD calls scsi_remove_device(), and
>> that cuts off the flow of commands.  The LLD can promise to error-out any
>> pending commands in the device command queue.
> 
> 
> I take it you mean that the transport will tell the LLDD that the device
> is gone and it (LLDD) call the one above, SCSI Core to remove the device.
> 
> Hmm, more thinking needs to be done here, as shouldn't this be handled
> by hotplugging? I.e. Targets do not *initiate* events.

Not exactly, but the bus driver ("transport"?) certainly does initiate
reports like "here's a new device on the bus" or "that device is gone".
That's when hotplugging kicks in (both in-kernel and in-userland).

And the only way to access a device ("target") on the bus is to give a
request to that bus driver.  If, when servicing that request, the bus
driver notices the device is gone ... that can act a lot like a device
initiating a "device gone" event would look.


> The transport can notify that the device is gone, but an ULP entity will
> call scsi_remove_device() not the other way around.

That's how USB works today:  khubd shuts things down.  Device drivers
get disconnect() callbacks, just as when their modules are removed.

EXCEPT that "khubd" is part of usbcore (roughly analagous to parts
of the scsi mid-layer) ... so the drivers acting as host side proxies
for the target hardware ("usb device") are purely reactive.  Their
only roles in hotplug scenarios are to bind to devices (when a new
one appears, using probe callbacks) or unbind from them (when one
goes away, using disconnect callbacks).

Those disconnect() callbacks have a few key responsibilities, very
much including shutting down the entire higher level I/O queue to
that device.  I think you're saying that SCSI drivers don't have
such a responsibility (unlike USB or PCI) ... if so, that would
seem to be worth changing.

- Dave



-------------------------------------------------------
This SF.NET email is sponsored by: FREE  SSL Guide from Thawte
are you planning your Web Server Security? Click here to get a FREE
Thawte SSL guide and find the answers to all your  SSL security issues.
http://ads.sourceforge.net/cgi-bin/redirect.pl?thaw0026en
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
