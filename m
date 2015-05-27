From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: PROBLEM: USB drive errors with newer kernel versions
Date: Wed, 27 May 2015 11:06:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1505271054560.1540-100000@iolanthe.rowland.org>
References: <201505261938.11869.gdalmadge@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201505261938.11869.gdalmadge-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gary Dalmadge <gdalmadge-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 26 May 2015, Gary Dalmadge wrote:

> Please see below. Please let me know if you need additional information.

Here's the problem, from right near the start of your trace:

> ffff8800cf87c000 2445467361 S Bo:1:004:2 -115 31 = 55534243 d2000000 00000000 00000a35 00000000 00000000 00000000 000000

0x35 is a SYNCHRONIZE CACHE command, telling the drive to write the 
contents of its internal cache out to the physical medium.

> ffff8800cf87c000 2445467440 C Bo:1:004:2 0 31 >
> ffff8800cf87c000 2445467445 S Bi:1:004:8 -115 13 <
> ffff8800cf87c000 2445467659 C Bi:1:004:8 0 13 = 55534253 d2000000 00000000 01
> ffff8800cf87c000 2445467682 S Bo:1:004:2 -115 31 = 55534243 d3000000 12000000 80000603 00000012 00000000 00000000 000000
> ffff8800cf87c000 2445467811 C Bo:1:004:2 0 31 >
> ffff8800bd45c6c0 2445468603 S Bi:1:004:8 -115 18 <
> ffff8800bd45c6c0 2445468688 C Bi:1:004:8 0 18 = 70000500 0000000a 00000000 20000000 0000
> ffff8800cf87c000 2445468695 S Bi:1:004:8 -115 13 <
> ffff8800cf87c000 2445468811 C Bi:1:004:8 0 13 = 55534253 d3000000 00000000 00

The drive replied with an error status, saying that this was an illegal
request with an invalid operation code.  Obviously it wasn't, and just
as obviously, your drive does not handle the SYNCHRONIZE CACHE command
properly.

It makes sense that this would trigger the error-detection code added
in commit 89fb4cd1f717 (scsi: handle flush errors properly).  After
all, it really was an error in the data-flushing path.

You wrote that the error appears with several different brands and 
types of USB drives.  Almost certainly these drivers share a bug in the 
component that bridges the USB bus to the internal SATA bus.

The real question is what to do about it.

James, do you have any suggestions?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
