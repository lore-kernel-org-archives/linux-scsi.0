From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in
 usb3 port
Date: Wed, 26 Sep 2012 10:50:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209261042270.1727-100000@iolanthe.rowland.org>
References: <20120925211910.GH32108@xanatos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52366 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756736Ab2IZOuN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2012 10:50:13 -0400
In-Reply-To: <20120925211910.GH32108@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Adrian Sandu <dexter@d3xt3r01.tk>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Tue, 25 Sep 2012, Sarah Sharp wrote:

> Alan, I'm wondering if the xHCI ring expansion is causing issues with
> USB hard drives under xHCI.  Testing with a Buffalo USB 3.0 hard drive
> with an NEC uPD720200 xHCI host, I see that the usb-storage and SCSI
> initialization produces I/O errors on random sectors in 3.4.0, 3.4.6,
> and 3.5.0.  I can't get those errors to be reproduced in 3.3.1.
> 
> The xHCI ring expansion was added in 3.4, and we changed the xHCI's
> sg_tablesize:
> 
> int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
> {
> ...
>         /* Accept arbitrarily long scatter-gather lists */
>         hcd->self.sg_tablesize = ~0;
> 
> The usb-storage driver sets the tablesize thus:
> 
> static unsigned int usb_stor_sg_tablesize(struct usb_interface *intf)
> {
>         struct usb_device *usb_dev = interface_to_usbdev(intf);
> 
>         if (usb_dev->bus->sg_tablesize) {
>                 return usb_dev->bus->sg_tablesize;
>         }
>         return SG_ALL;
> }
> 
> I notice that SG_ALL is set to SCSI_MAX_SG_SEGMENTS, which is only 128.
> Should we be passing an arbitrarily large number to the SCSI core?

Yes, there's no reason not to.  The block layer will make sure that
each individual request has a sufficiently small number of segments.

> There's some wording in include/scsi/scsi.h about also limiting the
> number of chained sgs to 2048.  I'm wondering if we're hitting some bugs
> in the SCSI layer because we're setting the sg_tablesize so high.

I doubt it.  Anyway, this stuff is handled by the block layer now, not
the SCSI layer.  If you look through drivers/scsi, you'll see that 
SG_ALL is used only in various SCSI interface drivers, not in the core.

> Alternately, we could be hitting bugs in the USB 3.0 firmware when we
> attempt to issue a read or write that's too big.  The read on Adrian's
> hard drive failed on a bigger read request (122880 bytes).  It would be
> interesting to see if it works fine if the xHCI sg_tablesize is limited.
> I'm going to try that with my own drive on 3.5.4 and see if it helps.

There were examples in the earlier usbmon traces where 122880-byte 
reads succeeded, for whatever that's worth...

I doubt very much that you are anywhere close to hitting that limit.  
If a 120-KB transfer has more than 128 SG segments then on average each
segment would be under 1024 bytes, a lot smaller than a page, which
seems unlikely.  I don't think I've ever seen a transfer needing more
than about 8 segments.

Alan Stern

