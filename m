From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Seagate External SMR drive USB resets (XHCI transfer error, not
 timeout)
Date: Thu, 16 Nov 2017 14:42:51 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1711161435280.1287-100000@iolanthe.rowland.org>
References: <20171115232129.102a1122@Vantage.cJ>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115232129.102a1122-WI5o+PA4G9BYumZHjSPV5A@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko-WRw03QTAyf3sq35pWSNszA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens <jens-bugzilla.kernel.org-pLZ6rgtf4/bvLhUCWVjhBQ@public.gmane.org>, Andrey Astafyev <1@246060.ru>, Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 15 Nov 2017, Jérôme Carretero wrote:

> I performed an usbmon capture extract, centered around the event
> (there was a few hundred MBs written for this to happen):
> 
>  Nov 15 22:16:33 Bidule kernel: usb 6-4.3.2.1: reset SuperSpeed USB
>   device number 8 using xhci_hcd
> 
> I can see that the computer is sending a write request, and sees a
> -EPROTO in answer (capture in attachment), so scratch the timeout issue
> (and actually when thinking about it, this matches what UAS was saying,
> except that UAS was taking ages to recover).
> 
> Looked for EPROTO in the usb code, and found a dynamic debug printf in
> XHCI; after enabling it:
> 
>  Nov 15 22:45:03 Bidule kernel: xhci_hcd 0000:07:00.0: Transfer error for slot 13 ep 3 on endpoint
>  Nov 15 22:45:03 Bidule kernel: xhci_hcd 0000:07:00.0: Transfer error for slot 12 ep 3 on endpoint
>  Nov 15 22:45:03 Bidule kernel: usb 6-4.3.3.1: reset SuperSpeed USB device number 9 using xhci_hcd
>  Nov 15 22:45:03 Bidule kernel: usb 6-4.3.2.1: reset SuperSpeed USB device number 8 using xhci_hcd
> 
> First, I understand that a bad USB device could poison the kernel log,
> but shouldn't that xhci_dbg() (and others eg. babble) be at least an
> xhci_info() (I saw 2a9227a5)?

I suspect that if every USB error got printed in the kernel log, people 
would be upset at how much useless information was added.

> Then... I don't know enough to attribute the issue the upstream USB hub(s)
> or the drive endpoint not behaving properly, or the kernel... what
> should I do with these messages?

Here's the error:

b5251480 0.505661 S Bo:6:008:2 -115 196608 = 540a2813 1a33dd99 ab76840c bf72fc6b 60f9fcaf 4d61822c c007ff4e ab72d022
b5251480 0.506280 C Bo:6:008:2 -71 86016 >

This means the kernel tried to write 196608 bytes to the drive.  After
86016 had been transferred, the drive did not reply correctly to the
next output transaction, causing the kernel to perform a reset.  
That's what happened, according to the viewpoint of the xhci-hcd 
driver.

In theory it's possible that the drive did respond correctly and the
information get messed up on the USB cable or on the computer's end.  
Since we can't see what signals were actually sent on the USB bus,
there's no way to be certain.  But it seems most likely that the drive
(or rather, its USB interface) was at fault.

Alan Stern

> I'm still filling the drives, will perform a scrub after, to see if
> the issue causes data loss...

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
