From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst [NEW HARDWARE]
Date: Thu, 16 Jan 2014 12:46:14 -0800
Message-ID: <20140116204614.GB27608@xanatos>
References: <20140109235045.GA17660@xanatos>
 <52D4791B.3030309@gmail.com>
 <20140114172056.GB12126@xanatos>
 <52D5ABBD.7090202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26578 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaAPUqT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 15:46:19 -0500
Content-Disposition: inline
In-Reply-To: <52D5ABBD.7090202@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walt <w41ter@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Jan 14, 2014 at 01:27:25PM -0800, walt wrote:
> On 01/14/2014 09:20 AM, Sarah Sharp wrote:
> > On Mon, Jan 13, 2014 at 03:39:07PM -0800, walt wrote:
> 
> >> Sarah, I just fixed my xhci bug for US$19.99 :)
> >>
> >> #lspci | tail -1
> >> 04:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 03)
> >>
> >> This new NEC usb3 controller does everything the ASMedia controller should have
> >> done from the start.
> 
>  
> > I just got a similar report from someone with a Fresco Logic host
> > controller, so I may need you to test a work-around patch for the
> > ASMedia host at some point.

Hmm, the Fresco Logic host issue seems unrelated.

> Oy, Sarah! ;)  I put the ASMedia adapter in my older amd64 machine, and, well,
> the stupid thing Just Works(TM) with kernel 3.12.7!  (Yes, with the same disk
> docking station, too.)

Ugh.  Well, I suppose we can chalk it up to hardware failure?  I think
you're the only one to report a verified issue with the Link TRB patch.

You are sure you're running a vanilla 3.12.7 kernel, right?

> I can't believe the adapter works perfectly in a different computer.  Have you
> seen this kind of thing before?

No, at least not this particular host-dying-only-on-one-machine failure
mode.

> At the moment I have two machines using your xhci driver and both work perfectly,
> so I thank you again :)
> 
> I'm not sure where to go with this next.  I could put the adapter back in the
> other machine again if you have more patches to test.

I think any patches I was going to send are moot with this new
information.  The issue with your PCI add-in card only happens in
combination with a specific motherboard, so I don't think it makes sense
to disable the no-op TRBs for that host.

If lots of other people start reporting the same issue with the ASMedia
0.96 host, and reverting commit 35773dac5f862cb1c82ea151eba3e2f6de51ec3e
"usb: xhci: Link TRB must not occur within a USB payload burst" helps
them, then I'll reconsider that decision.

Thank you so much for your patience while debugging this issue, and
being willing to try all sorts of kernels and patches.  I'm glad we
finally figured out what the issue was, and you have working xHCI hosts
now.

Sarah Sharp
