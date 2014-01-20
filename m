From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst [NEW HARDWARE]
Date: Mon, 20 Jan 2014 10:14:42 -0800
Message-ID: <20140120181442.GA5545@xanatos>
References: <20140109235045.GA17660@xanatos>
 <52D4791B.3030309@gmail.com>
 <20140114172056.GB12126@xanatos>
 <52D5ABBD.7090202@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
 <52DAE2BF.7020208@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D45FF6C@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D45FF6C@AcuExch.aculab.com>
Sender: stable-owner@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'walt' <w41ter@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 20, 2014 at 11:21:14AM +0000, David Laight wrote:
> From: walt 
> > On 01/17/2014 06:34 AM, David Laight wrote:
> > 
> > > Can you try the patch I posted that stops the ownership on LINK TRBs
> > > being changed before that on the linked-to TRB?
> > 
> > Please disregard my earlier post about the patch not applying cleanly.
> > That was the usual html corruption, so I found the original on the usb
> > list and it was okay.
> > 
> > Sadly, the patch didn't fix the ASMedia lockup behavior, however :(
> > 
> > I did notice that the lockup occurred only when copying *to* the usb3
> > drive, and not when copying from it.  I think that may be new behavior
> > but I can't swear to it.
> 
> Consistent with another report that says that ethernet worked provided
> that TSO was disabled (ie no sg tx).
> (Without the patch to delay he ownership change on link trbs it didn't
> work at all.)

Please be more clear.  What do you mean by these statements?  That
someone privately reported that your earlier patch [1] did not help
them, but applying your new patch [2] on top of the old patch did?

[1] http://marc.info/?l=linux-usb&m=138418996717941&w=2
[2] http://marc.info/?l=linux-usb&m=138996538403468&w=2

In general, will you please Cc me and the USB list when replying to
privately reported bugs/confirmations that patches work?  Or if the
confirmation was reported, please provide a link to the mailing list
discussion or bugzilla entry.  We need to keep bug and fix confirmations
publicly archived.  Please keep me on Cc since I filter mail based on
that.

> A guess...
> 
> In queue_bulk_sg_tx() try calling xhci_v1_0_td_remainder() instead
> of xhci_td_remainder().

Why?  Walt has a 0.96 xHCI host controller, and the format for how to
calculate the TD remainder changed between the 0.96 and the 1.0 spec.
That's why we have xhci_v1_0_td_remainder() and xhci_td_remainder().

Sarah Sharp
