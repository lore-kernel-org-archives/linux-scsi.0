From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Date: Tue, 21 Jan 2014 09:51:30 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D4609BF@AcuExch.aculab.com>
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com>
 <20140114172056.GB12126@xanatos> <52D5ABBD.7090202@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
 <52DAE2BF.7020208@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D45FF6C@AcuExch.aculab.com>
 <20140120181442.GA5545@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140120181442.GA5545@xanatos>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Sarah Sharp' <sarah.a.sharp@linux.intel.com>
Cc: 'walt' <w41ter@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Sarah Sharp
> On Mon, Jan 20, 2014 at 11:21:14AM +0000, David Laight wrote:
...
> > A guess...
> >
> > In queue_bulk_sg_tx() try calling xhci_v1_0_td_remainder() instead
> > of xhci_td_remainder().
> 
> Why?  Walt has a 0.96 xHCI host controller, and the format for how to
> calculate the TD remainder changed between the 0.96 and the 1.0 spec.
> That's why we have xhci_v1_0_td_remainder() and xhci_td_remainder().

I just wonder how many of those differences are just differences in the
specification, rather than differences in the hardware implementation.
In some cases it might be that the old hardware just ignored the value.

I know that the xhci hardware on my ivy bridge cpu does look at that
value (at least checking for zero), since things failed in subtle ways
when I got it wrong.

In this case it was just something easy to change that might be worth
trying.  I didn't necessarily expect it to make a positive difference.

	David
