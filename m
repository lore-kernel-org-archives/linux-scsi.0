From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst
Date: Fri, 3 Jan 2014 15:29:29 -0800
Message-ID: <20140103232929.GD4193@xanatos>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218211220.412278148@linuxfoundation.org>
 <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos>
 <52C6D9F1.9000709@gmail.com>
 <20140103195455.GA4193@xanatos>
 <52C729CE.9050307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52C729CE.9050307@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: walt <w41ter@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 03, 2014 at 01:21:18PM -0800, walt wrote:
> I'm so sorry Sarah, that was another mistake.  The mistake is so stupid I'm not
> going to publish it here :(
> 
> Once I finally ran the kernel with debugging actually compiled in, dmesg contains
> xhci debugging messages.  Wow :)
> 
> It's a big file so I zipped and attached it, which I hope is acceptable in lkml.

Yep, that's fine.  Sticking it in pastebin (or up on your server) is
also fine, if it gets really big.

> BTW, this dmesg is from a kernel with sg_tablesize = 31, which as I said before
> doesn't fix the problem.  The cp stopped around 7GB just as before.
> 
> Sorry for the noise...

No worries! :)  With the dmesg, I can finally see what happened:

[  188.703059] xhci_hcd 0000:03:00.0: Cancel URB ffff8800b7d2e0c0, dev 1, ep 0x2, starting at offset 0xbb7b9000
[  188.703072] xhci_hcd 0000:03:00.0: // Ding dong!
[  193.711022] xhci_hcd 0000:03:00.0: xHCI host not responding to stop endpoint command.
[  193.711029] xhci_hcd 0000:03:00.0: Assuming host is dying, halting host.
[  193.711046] xhci_hcd 0000:03:00.0: // Halt the HC
[  193.711060] xhci_hcd 0000:03:00.0: Killing URBs for slot ID 1, ep index 0
[  193.711066] xhci_hcd 0000:03:00.0: Killing URBs for slot ID 1, ep index 2
[  193.711078] xhci_hcd 0000:03:00.0: Killing URBs for slot ID 1, ep index 3
[  193.711096] xhci_hcd 0000:03:00.0: Calling usb_hc_died()
[  193.711103] xhci_hcd 0000:03:00.0: HC died; cleaning up
[  193.711116] xhci_hcd 0000:03:00.0: xHCI host controller is dead.

It seems that the xHCI driver tried to stop the endpoint ring in order
to cancel a SCSI transfer, and the driver never got a response for that.

The offset is rather suspicious (0xbb7b9000), and it probably means the
driver attempted to cancel a transfer that had been moved to the
beginning of the ring segment, with no-op TRBs before the link TRB.

I suspect David's patch triggers a bug in the command cancellation code.
There's also the unlikely possibility that the no-op TRBs did indeed
cause the host to hang.  Either way, I'll have to look into it.

I'll let you know when I have some diagnostic patches ready.

Sarah Sharp
