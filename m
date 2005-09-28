From: Lukasz Kosewski <lkosewsk@gmail.com>
Subject: Re: [PATCH 3/3] Add disk hotswap support to libata RESEND #5
Date: Wed, 28 Sep 2005 16:21:16 -0400
Message-ID: <355e5e5e05092813211f5ef825@mail.gmail.com>
References: <355e5e5e050926180156e58f59@mail.gmail.com>
	 <433AEB4F.7010502@pobox.com>
	 <355e5e5e0509281258536e4be4@mail.gmail.com>
	 <433AF897.2050400@pobox.com>
Reply-To: Lukasz Kosewski <lkosewsk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750773AbVI1UVT@vger.kernel.org>
In-Reply-To: <433AF897.2050400@pobox.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 9/28/05, Jeff Garzik <jgarzik@pobox.com> wrote:
> Lukasz Kosewski wrote:
> >>>+     if (plugdata) {
> >>>+             writeb(plugdata, mmio_base + hotplug_offset);
> >>>+             for (i = 0; i < host_set->n_ports; ++i) {
> >>>+                     ap = host_set->ports[i];
> >>>+                     if (!(ap->flags & ATA_FLAG_SATA))
> >>>+                             continue;  //No PATA support here... yet
> >>>+                     // Check unplug flag
> >>>+                     if (plugdata & 0x1) {
> >>>+                             /* Do stuff related to unplugging a device */
> >>>+                             ata_hotplug_unplug(ap);
> >>>+                             handled = 1;
> >>>+                     } else if ((plugdata >> 4) & 0x1) {  //Check plug flag
> >>>+                             /* Do stuff related to plugging in a device */
> >>>+                             ata_hotplug_plug(ap);
> >>>+                             handled = 1;
> >>
> >>What happens if both bits are set?  Seems like that could happen, if a
> >>plug+unplug (cable blip?) occurs in rapid succession.
> >
> >
> > What IF both bits are set?  This is why we have a debounce timer to
> > take care of the problem :P
> >
> > The way this is set up, unplugging will win out (plugging will come
> > first, unplugging will come and destroy 'plug's timer, and then the
> > unplug action will be performed on timer expiry).  Personally, I like
> > it this way, but I can reverse the order of these two to make plugging
> > the default action.  Which do you prefer?
>
> The above logic
> * acks multiple events
> * handles only a single event
>
> so either way you lose an event.  In the code as it is written above, if
> both 'plug' and 'unplug' events are noted, then only the unplug get
> handled, and the newly-plugged device is never noticed.

Yeah, that's exactly what it does.  I see your point, but no matter
how I design this (debounce timer, no debounce timer, whatever), in
such a situation we always have either:
- plug/unplug
or
- unplug/plug

One of them will always win.

I will change this so that 'plug' wins (as in, the unplug call will be
made first, the plug second).  This way if we have both bits set, but
what we ACTUALLY wanted was an unplug:
- the unplug API interface ata_port_disables the ap in question.  It
queues up and unplug event.
- the plug API interface deletes the queued plug event, and stores up
a plug on the timer.
- the plug timer event triggers, the first thing it does is execute
ata_scsi_handle_unplug, which the unplug handler would have done
anyways.  It removes the associated struct scsi_device from existence.
 Following this, it does a reset and attempts to detect a new device;
there is none (we actually unplugged it), so it just fails, no device
detected.  So this case works.

If we have both bits set but wanted a a plug:
- the unplug API interface ata_port_disables the ap in question.  It
queues up and unplug event.
- the plug API interface deletes the queued plug event, and stores up
a plug on the timer.
- the plug timer fires off and does what we want.

Is this acceptable?  I'd love to make the hardware acknowledge only
one request and interrupt me again with another, but there is no way
to get it to do that; when you acknowledge a hotplug interrupt it
clears the register of all hotplug events whether you handled them
specifically or not.

Luke
