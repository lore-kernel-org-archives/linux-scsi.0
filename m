From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: xhci: suspend/resume issues
Date: Mon, 22 Nov 2010 15:15:24 -0800
Message-ID: <20101122231524.GA26888@xanatos>
References: <20101110195426.GB4823@redhat.com>
 <2DEEA3AB13739D45A22ADDB5086AEA0B914AD4@sshaexmb1.amd.com>
 <20101111191904.GK4823@redhat.com>
 <20101111210420.GA9020@xanatos>
 <20101116154756.GZ4823@redhat.com>
 <2DEEA3AB13739D45A22ADDB5086AEA0B9A6287@sshaexmb1.amd.com>
 <20101119185907.GA30923@xanatos>
 <20101119225602.GP18100@redhat.com>
 <20101119233046.GA13059@xanatos>
 <20101122224947.GD18100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3001 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717Ab0KVXPy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2010 18:15:54 -0500
Content-Disposition: inline
In-Reply-To: <20101122224947.GD18100@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Zickus <dzickus@redhat.com>
Cc: "Xu, Andiry" <Andiry.Xu@amd.com>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org

Ccing the scsi and USB mass storage devices lists on this issue.
Background: a USB 3.0 mass storage device shows up as a USB 2.0 device
after resume, and then migrates back to USB 3.0 speeds after a reset.

On Mon, Nov 22, 2010 at 05:49:47PM -0500, Don Zickus wrote:
> On Fri, Nov 19, 2010 at 03:30:46PM -0800, Sarah Sharp wrote:
> > The fifth patch had no effect on whether the device showed up as
> > SuperSpeed after a system resume, so I don't think it's needed.  Even
> > after the four I sent yesterday, the device still shows up as high speed
> > at first, which means USB persist won't work for it.  I'm going to look
> > into Alan Stern's suggestion to reorder the HS ports to be before the SS
> > ports.  I will probably need you to test again.
> > 
> > Thanks for working with me on this.
> 
> Thanks Sarah for you help.
> 
> Another issue popped up for me.  I noticed when I suspend having a usb3
> filesystem mounted (ie mount /dev/sdb2 /mnt), when the system comes back
> up, the filesystem is remounted onto /media (probably a distro thing) but
> more importantly it comes back as /dev/sdbc (note the 'c' and not 'b').

That's normal, as the USB core thinks the device disconnected, and a new
device was placed on that same port.  The USB core has to assume it was
a new device, so the block layer will create a new filesystem (sdc) for
it.  That's just a by-product of the broken device connecting as high
speed and then re-connecting as SuperSpeed once it's reset.

I was going to create a patch to reorder the ports, but Greg KH declined
to take the 2 patches that you've successfully tested for 2.6.37, as
they're too large.  Since I can't fix your broken device in 2.6.37, I'll
skip the workarounds I sent you and just send the split roothub patches
for 2.6.38.  Those should fix your issues, since they do an equivalent
thing to the disable ports patches I sent.  I'll have to send those
patches to test once they're finished.

> Looking into my previously mounted /mnt directory yields an i/o error
> (probably because it is now under /dev/sdc).

As long as it doesn't produce any kernel oops, that's normal.  The
kernel has noticed the device went away, but userspace hasn't.  At
least, that's my general impression.  You'll have to ask the USB mass
storage guys, or the SCSI folks for the details on how that's supposed
to work.

> Unmounting everything and remounting 'mount /dev/sdc2 /mnt' (using the new
> letter 'c' instead of 'b') works fine and no data loss seems to occur.
> 
> Just thought it might be annoying and was wondering if you had any ideas
> on that?

There's no way to work around it if the device disconnects, AFAIK.

Sarah
