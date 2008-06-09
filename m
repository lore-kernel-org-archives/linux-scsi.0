From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Mon, 9 Jun 2008 10:46:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0806091040440.2943-100000@iolanthe.rowland.org>
References: <200806080619.17531.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200806080619.17531.chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux1394-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 8 Jun 2008, Chris Clayton wrote:

> > The odd thing is that it occurs in the middle of USB initialisation from
> >
> 
> Because of this oddity, I've also built 2.6.26-rc5-git2 with verbose USB 
> debugging on. A boot log from that kernel is attached. You will see lots of 
> ETIME errors from usb. A log from a similarly verbose 2.6.25.5 kernel does not 
> show these errors. usb-devel added to cc list.

In fact the log shows that the 30-second delay occurs in the middle of
ohci1394 (Firewire) initialization, not USB initialization:

Jun  8 05:26:35 upstairs kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[fbfff000-fbfff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8] 
Jun  8 05:26:35 upstairs kernel: ohci_hcd 0000:02:0a.0: urb f71cb680 path 2 ep1in 5e160000 cc 5 --> status -62 
Jun  8 05:26:35 upstairs kernel: hub 1-2:1.0: transfer --> -62 
Jun  8 05:27:08 upstairs kernel: driver: '0000:02:0b.0': driver_bound: bound to device 'ohci1394' 
Jun  8 05:27:08 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:0b.0 to driver ohci1394 

Those -62 errors from ohci_hcd are red herrings.  To test this, try 
booting with "nousb".

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
