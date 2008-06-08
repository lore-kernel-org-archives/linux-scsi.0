From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Sun, 08 Jun 2008 13:37:56 -0500
Message-ID: <1212950276.3574.7.camel@localhost.localdomain>
References: <200806010415.05290.chris2553@googlemail.com>
	 <20080606110345.581fdc77.akpm@linux-foundation.org>
	 <1212777612.16182.21.camel@localhost.localdomain>
	 <200806080619.17531.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200806080619.17531.chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2008-06-08 at 06:19 +0000, Chris Clayton wrote:
> --Boundary-00=_NG3SIU63+Zdv2JV
> Content-Type: text/plain;
>   charset="utf-8"
> Content-Transfer-Encoding: quoted-printable
> Content-Disposition: inline
> 
> On Friday 06 June 2008, James Bottomley wrote:
> > On Fri, 2008-06-06 at 11:03 -0700, Andrew Morton wrote:
> > > On Fri, 06 Jun 2008 10:22:22 -0500 James Bottomley=20
> <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> > > > On Thu, 2008-06-05 at 23:25 -0700, Andrew Morton wrote:
> > > > > On Thu, 5 Jun 2008 23:21:45 -0700 Andrew Morton=20
> <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > > > > > <watches wodim wibble for five minutes then report "CD/DVD-Record=
> er
> > > > > > not ready."  Pretends not to have noticed.>
> > > > >
> > > > > It goes much better when the CD is inserted upside up.
> > > >
> > > > So I can close this regression if I send you a pack of CD ring labels
> > > > with "other way up" on them for you to affix to the underside of your
> > > > CDs ... ?
> > >
> > > Would prefer double-sided CDs.
> >
> > I just discovered my budget only runs to a permanent marker for you to
> > write the instructions on the rim yourself ...
> >
> > > Is this 20-second-delay thing known-about/expected/etc?
> >
> > If it's not the scsi_bus_uevent problem, then no, it isn't.
> >
> > The odd thing is that it occurs in the middle of USB initialisation from
> >
> 
> Because of this oddity, I've also built 2.6.26-rc5-git2 with verbose USB 
> debugging on. A boot log from that kernel is attached. You will see lots of 
> ETIME errors from usb. A log from a similarly verbose 2.6.25.5 kernel does not 
> show these errors. usb-devel added to cc list.

I'm starting to think this might be a distribution problem.  I tried
booting my laptop on your config (only system I have with ata_piix)
without an initrd (bit painful for fedora 9) and I didn't see any slow
downs (in fact it was a lot faster than previously; makes note to file
bug with redhat about their initramfs).

The one thing the patch you identified does is to add the SCSI target to
the BUS and type model for the generic device.  What this does is to add
extra uevents for the target.  If your hotplug handlers aren't set up to
expect this, they could be delaying the system progress.

What hotplug scripts are you using (and does /sbin/hotplug exist)?

> > > upstairs kernel: usb 11-2: Product: USB Flash Memory Jun  6 17:26:31
> > > upstairs kernel: usb 11-2: SerialNumber: 0EC065712361A91E
> >
> > I'm a bit baffled as to how that could be SCSI related, but I suppose it
> > could be udev related somehow.  Perhaps turning on driver core debugging
> > might help (that's CONFIG_DEBUG DRIVER ... it depends on
> > CONFIG_DEBUG_KERNEL for activation).  Hopefully the verbose kernel logs
> > from here might tell us what's going on in the lacunae.
> >
> 
> Triggered by James' bafflement and for my own peace of mind, I've run another
> bisect session. This time I started with v2.6.26 as good and v2.6.26-rc2 as bad.
> It highlighted the same patch as the "culprit".

Actually, that's not really necessary.  Bisection is taking you back
through kernel history, so unless the bug has two separate causes, it's
pretty likely to home in on the same section of code.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
