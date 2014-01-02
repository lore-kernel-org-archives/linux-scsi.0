From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst
Date: Thu, 2 Jan 2014 11:15:10 -0800
Message-ID: <20140102191510.GA9621@xanatos>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218211220.412278148@linuxfoundation.org>
 <52C32BB0.90600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52C32BB0.90600@gmail.com>
Sender: stable-owner@vger.kernel.org
To: walt <w41ter@gmail.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, David Laight <david.laight@aculab.com>, Mark Lord <mlord@pobox.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 31, 2013 at 12:40:16PM -0800, walt wrote:
> On 12/18/2013 01:11 PM, Greg Kroah-Hartman wrote:
> > 3.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: David Laight <David.Laight@ACULAB.COM>
> > 
> > commit 35773dac5f862cb1c82ea151eba3e2f6de51ec3e upstream.
> > 
> > Section 4.11.7.1 of rev 1.0 of the xhci specification states that a link TRB
> > can only occur at a boundary between underlying USB frames (512 bytes for
> > high speed devices).
> > 
> > If this isn't done the USB frames aren't formatted correctly and, for example,
> > the USB3 ethernet ax88179_178a card will stop sending...
> 
> 
> Unfortunately this patch causes a regression when copying large files to my
> outboard USB3 drive. (Nothing at all to do with networking.)
> 
> When I try to copy a large (20GB) file to the USB3 drive, the copy dies after
> about 7GB, the ext4 journal aborts and the drive is remounted read-only.
> 
> This bug is 100% reproducible (always pretty close to 7GB) and reverting this
> patch completely fixes the problem.

Ok, I had feared that would be a consequence of this patch.  I think the
problem is that the usb-storage driver submitted an URB with more
scatter-gather entries than would fit on the ring segment, the xHCI
driver rejected the URB with -ENOMEM, and the SCSI core eventually gave
up on the SCSI command.

Do you have CONFIG_USB_DEBUG turned on for 3.13?  If so, you should see
dmesg output from this statement shortly before your drive fails:

if (num_trbs >= TRBS_PER_SEGMENT) {
	xhci_err(xhci, "Too many fragments %d, max %d\n",
		num_trbs, TRBS_PER_SEGMENT - 1);
	return -ENOMEM;
}

> (Note to Sarah:  I recently emailed you about this problem, and I *wrongly*
> said that reverting the patch doesn't help.  That was a mistake, sorry.)
> 
> I'm happy to try any debugging suggestions/tricks.

Unfortunately a real fix for this is going to take a bit.  I have a
couple different solutions to the bug the patch solved, but they're much
more invasive than the original patch and will take a couple weeks to
implement and thoroughly test.

If David's patch is just reverted, USB ethernet on 3.12 and later breaks
under xHCI.  The networking folks added scatter-gather support in 3.12.
Those patches could be reverted, but I suspect David Miller will not be
happy with that solution, since the real problem is the xHCI driver
itself, and EHCI scatter-gather works fine.

I think the short term solution is to simply turn off scatter-gather all
together under xHCI until this gets fixed.  It could mean a big
performance hit for USB storage devices, but that means we get correct
behavior for both USB ethernet and USB storage.

> BTW, please tell me if I've cc'd too many people.

Nope, you're fine.  I've Cc'ed the USB and SCSI mailing lists as well.

Sarah Sharp
