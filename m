From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 15:14:15 -0400 (EDT)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0309221511300.2840-100000@ida.rowland.org>
References: <Pine.LNX.4.44.0309221133220.2153-100000@home.osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44.0309221133220.2153-100000@home.osdl.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Linus Torvalds <torvalds@osdl.org>
Cc: David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 22 Sep 2003, Linus Torvalds wrote:

> Yes. Additional testing (making the code just increase the size of the 
> transfer until it fails) shows that a size of 63 still works, but a size 
> of 64 bytes fails.
> 
> Actually - with a 64-byte transfer, we appear to get the 64 bytes ok, but 
> the subsequent CSW status word read fails, so the 64-byte case seems to be 
> the one that starts confusing the device.
> 
> If I remember right, USB-1 "big packets" are 64 bytes in size, and a 
> 64-byte bulk transfer would be two packets (one full-sized one, one 
> zero-sized one).

It's not quite that simple.  If the host requested a transfer that was 
larger than 64 bytes and the device only had 64 bytes of data available, 
then yes, it would send a 64-byte packet followed by a short 0-byte packet 
to indicate an early termination.  But if (as in this case) the host 
requested a 64-byte transfer, the device would send exactly those 64 bytes 
in a single packet and nothing else -- there being no need to indicate an 
early termination.

>  So this seems to support the notion that the device is 
> fine as long as it can fit the whole bulk transfer in just one packet.
> 
> Which cleanly explains why EHCI "just worked". 

Alan Stern



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
