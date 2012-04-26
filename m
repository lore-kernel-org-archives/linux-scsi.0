From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Thu, 26 Apr 2012 11:03:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204261026260.1530-100000@iolanthe.rowland.org>
References: <83362.45763.qm@web100010.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52774 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756609Ab2DZPDJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Apr 2012 11:03:09 -0400
In-Reply-To: <83362.45763.qm@web100010.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 26 Apr 2012, Norman Diamond wrote:

> OK, the new code for heuristics makes it PROBABLY good enough to
> change the Prolific bridge from FIX_CAPACITY to CAPACITY_HEURISTICS.
> 
> > Below are two patches that do pretty much what you are asking for.  
> > Please test just the first and then both together.
> 
> Ouch.  Yeah I should expect it to be my responsibility to test, but
> rebuilding the live Linux system that I use is particularly painful.  
> (Of course I have to be grateful that it is even possible in the
> first place, regardless of being painful.)
> 
> Would it be acceptable for me to donate my USB-to-ATA cable to you?

Let's just not worry about it.  It seems pretty clear that the patches 
will fix your immediate problem.

> > +        (sdp->guess_capacity && (n % 2 == 1 || n % 63 == 1))) {
> 
> Imagine a device with 63 blocks.  guess_capacity is true and n % 2 ==
> 1 so this is going to truncate when we don't want to.

Yes.  As the comment at the start of this code says, we err on the side 
of truncating.  Besides, that's what the current algorithm does.

> How is one of these, either in my style:
> (sdp->guess_capacity && (n % 2 != 0) && (n % 63 != 0))) {
> 
> or a popular coding style:
> (sdp->guess_capacity && n % 2 n % 63)) {

(I have no idea what "popular coding style" that might be -- it
contains a syntax error!)

What about a device that has 6362 sectors but reports 6363?  Then your 
test would fail to decrement the value when we do want to.

Anyway, why do you want to test for n % 63 != 0?  You have no
justification for decrementing the block count if the result would
not be divisible by 63.

(Interestingly, I just found an email thread that appears to be the 
origin of the CAPACITY_HEURISTICS flag:

	http://marc.info/?l=linux-usb-devel&m=117025868105192&w=2

Among other things, it suggests testing for divisibility by 255 * 63 
instead of by 63, which ought to help reduce the number of errors.

(Also, it turns out that this flag is used with more than one type of 
device.  It gets turned on automatically for virtually every device 
made by Nokia, Nikon, Pentax, or Motorola.  Apparently the capacity 
bug was very common in firmwares used by camera and cell phone makers.)

> > +            sd_printk(KERN_INFO, sdkp, "(This adjustment may be incorrect)\n");
> 
> I'd like to suggest:
> "(This adjustment may be incorrect.  If this adjustment truncates
> your drive when it should not, please report the error and your
> device's details to linux-usb@vger.kernel.org)"

Okay, I'll change the message.

Bear in mind that if anybody reports a problem caused by the new
"divisible by 63" criterion, we will have to revert the changed test
(the updated message could remain, since it doesn't affect
functionality).

Alan Stern

