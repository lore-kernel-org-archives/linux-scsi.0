From: Rob Landley <rob@landley.net>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 03:36:15 -0500
Message-ID: <200710150336.15774.rob@landley.net>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015060015.GB32268@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760163AbXJOJ01@vger.kernel.org>
In-Reply-To: <20071015060015.GB32268@kroah.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

On Monday 15 October 2007 1:00:15 am Greg KH wrote:
> If you hate USB storage devices using scsi, please use the ub driver,
> that is what it was written for.

For the embedded space, the ability to configure out the scsi layer is 
interesting from a size perspective.  I bookmarked that a while back, but had 
forgotten about it.  Thanks for the reminder.

For the desktop I don't object to the scsi layer.  I object to the naming.  
Merging a half-dozen different types of devices into a single name space, and 
then warning us that the order they appear within that namespace could be the 
result of race conditions...  Seems like an artificially inflated problem to 
me.  Don't merge them together and each namespace is a smaller problem, often 
with only a single device or with a stable relationship between the devices.

(That said, the answer to my original question, "is the block layer still in 
use" seems to be yes, so creating a 00-INDEX for Documentation/block is a 
good thing, and I'll go do that.  I acknowledge that I asked this question 
_horribly_, due to having other unresolved issues with the scsi layer...)

> When did usb-storage devices ever show up as /dev/usb0?  USB flash disks
> are really SCSI devices, look at the USB storage spec for proof of that.

Um, possibly I _was_ playing with the ub driver and got a /dev/ub0.  (I 
vaguely recall playing with back around...  February?  When did it wander 
across Pavel's blog...  I don't actually remember if I got it to work or 
not.)  Possibly this is from playing with a usb scanner back around 2004.  (I 
just dragged out my other USB device from that period, an ethernet dongle, 
but it doesn't create /dev anything.  Just shows up as usb2. :)

The point I was trying to make is that it seems to me like it would be 
possible to keep the namespace separate here, and thus reduce the enumeration 
problems to the point where common cases (like my laptop) aren't impacted by 
them during early boot.  I don't think anybody (outside the embedded space) 
is actually upset that /dev/hda now goes through the scsi layer:  they're 
upset Ubuntu 7.04 no longer calls it /dev/hda.

> thanks,
>
> greg k-h

Thank you,

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
