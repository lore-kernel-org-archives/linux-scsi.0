From: David Brownell <david-b@pacbell.net>
Subject: Re: Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 13:24:08 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <3E2C68F8.7080405@pacbell.net>
References: <10426732153816@kroah.com> <3E2C3380.3070700@splentec.com>
 <3E2C5750.2040301@pacbell.net> <200301202148.23210.oliver@neukum.name>
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
To: Oliver Neukum <oliver@neukum.name>
Cc: Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Oliver Neukum wrote:

> That model cannot be applied to SCSI as it is much more diverse
> in the number of bus types it supports.
> USB can do it, because it knows about hubs. SCSI cannot,
> as there are no hubs in SCSI.

Hubs are irrelevant here, the key functionality is noticing
hardware addition/disconnect.  Parts of it can be done in bus
adapter code, parts of it can't.  SCSI probes LUNS in much
the same way khubd probes hub ports, and as I recall most of
that logic isn't any more specific to the adapter than virtual
root hub code is for USB.


>>Those disconnect() callbacks have a few key responsibilities, very
>>much including shutting down the entire higher level I/O queue to
>>that device.  I think you're saying that SCSI drivers don't have
>>such a responsibility (unlike USB or PCI) ... if so, that would
>>seem to be worth changing.
> 
> 
> If the scsi layer cannot on its own detect that a device or a bus is gone,
> there'll be no sense in having a callback. It's just a complication.

Erm ... which of the three SCSI layers are you talking about?  I was
talking about the highest level, which is precisely the layer I think
has been identified as already needing to know when to shut down the
I/O queues (sd_mod and friends).

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
