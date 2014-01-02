From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst
Date: Thu, 2 Jan 2014 13:33:52 -0800
Message-ID: <20140102213352.GB9621@xanatos>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218211220.412278148@linuxfoundation.org>
 <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos>
 <52C5D3A9.60708@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52C5D3A9.60708@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Lord <mlord@pobox.com>
Cc: walt <w41ter@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Paul Zimmerman <Paul.Zimmerman@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 02, 2014 at 04:01:29PM -0500, Mark Lord wrote:
> On 14-01-02 02:15 PM, Sarah Sharp wrote:
> > On Tue, Dec 31, 2013 at 12:40:16PM -0800, walt wrote:
> ..
> >> Unfortunately this patch causes a regression when copying large files to my
> >> outboard USB3 drive. (Nothing at all to do with networking.)
> >>
> >> When I try to copy a large (20GB) file to the USB3 drive, the copy dies after
> >> about 7GB, the ext4 journal aborts and the drive is remounted read-only.
> >>
> >> This bug is 100% reproducible (always pretty close to 7GB) and reverting this
> >> patch completely fixes the problem.
> > 
> > Ok, I had feared that would be a consequence of this patch.  I think the
> > problem is that the usb-storage driver submitted an URB with more
> > scatter-gather entries than would fit on the ring segment, the xHCI
> > driver rejected the URB with -ENOMEM, and the SCSI core eventually gave
> > up on the SCSI command.
> 
> Is there not a block layer / scheduler tunable for max sg entries or something?

There is a USB host controller tunable for max number of sg entries
that's passed up to the SCSI or block layer.  We discussed changing it,
but there wasn't a good consensus on what to change it to:

http://marc.info/?l=linux-usb&m=138496358223904&w=2
http://marc.info/?l=linux-netdev&m=138496706007262&w=2

In the end, we thought we didn't need to limit the sglist size because
Paul thought usb-storage limits the overall transfer size to 120K, which
should fit in 31 TRBs:

http://marc.info/?l=linux-usb&m=138498190419312&w=2

Walt, could you see if limiting the sglist size helps, by setting
hcd->self.sg_tablesize in xhci.c to 31?

Sarah Sharp
