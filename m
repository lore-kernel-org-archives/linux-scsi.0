From: David Brownell <david-b@pacbell.net>
Subject: Re: Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 09:22:22 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <3F6F21BE.9090109@pacbell.net>
References: <Pine.LNX.4.44.0309220801330.1696-100000@home.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44.0309220801330.1696-100000@home.osdl.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 22 Sep 2003, Alan Stern wrote:
> 
>>This problem has been cropping up with many, many USB storage devices.  
> 
> 
> Interesting data-point: the device is a happy EHCI camper, and is totally 
> able to read codepage 8 on EHCI.
> 
> However, if I put it behind a USB-1 hub on the EHCI port, I see the same 
> problems I saw with OHCI.

Can you be more clear?  Is that

    (EHCI/OHCI) root port --> USB 2.0 hub --> USB 1.1 hub --> storage device

Or instead

    (EHCI/OHCI) root port --> USB 1.1 hub --> storage device

The former is certainly using EHCI, and the transaction translator in
that USB 2.0 hub ... but I'd expect it to give a different failure mode.
Maybe the same net result, but a different fault code (not -EOVERFLOW),
and likely different recovery procedure in usb-storage/scsi.

The latter is identical with the OHCI-only case, the only involvement
of EHCI being to hand that port over to the (OHCI) companion.


> So it is somehow related to USB-1 vs USB-2. I don't understand why the 
> device would make a difference for something like mode page 8, but it 
> looks like it transfers data fine for _small_ mode page requests under 
> USB-1, and under USB-2 it works even for big ones.

It could be some kind of logic in the device forgetting that to use
the right maxpacket setting in that specific case.

I'm a bit more used to seeing failures the other way around, where
the storage adapter doesn't quite respond correctly at high speed.

- Dave


> 
> 		Linus
> 
> 




-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
