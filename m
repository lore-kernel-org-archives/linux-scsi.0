From: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Fri, 13 Jun 2008 06:56:42 +0000
Message-ID: <200806130656.43016.chris2553@googlemail.com>
References: <200806010415.05290.chris2553@googlemail.com> <485027AC.6060901@s5r6.in-berlin.de> <1213212965.3461.12.camel@localhost.localdomain>
Reply-To: chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1213212965.3461.12.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Content-Disposition: inline
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi James,

On Wednesday 11 June 2008, James Bottomley wrote:
> On Wed, 2008-06-11 at 21:29 +0200, Stefan Richter wrote:
> > James Bottomley wrote:
> > > On Wed, 2008-06-11 at 12:15 -0700, Greg KH wrote:
> > >> On Wed, Jun 11, 2008 at 06:58:05PM +0000, Chris Clayton wrote:
> > >>> Jun 11 17:48:13 upstairs udevd-event[1457]: wait_for_sysfs: wait for
> > >>> '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.
> > >>>0/host4/ioerr_cnt' for 20 mseconds Jun 11 17:48:18 upstairs last
> > >>> message repeated 236 times
> > >>
> > >> This doesn't look good.  It looks like a udev rule in your system is
> > >> looking for a file that will never show up.  That's a short way to a
> > >> long delay time :)
> > >>
> > >> Try commenting out the rule that does this and see if things are
> > >> fixed.
> > >
> > > Actually, there's something seriously wrong here:  ioerr_cnt is a
> > > property of the device, not of the host (as in it will never appear
> > > under .../host4 but under .../host4/targetX:X:X/4:X:X:X/ioerr_cnt).
> > > Perhaps an investigation of why udevd-event is looking under host4/ is
> > > in order.
> >
> > So the change which commit b0ed43360fdca227048d88a08290365cb681c1a8
> > "[SCSI] add scsi_host and scsi_target to scsi_bus" introduced is leading
> > the udev scripts onto a wrong trail?
>
> Yes, I think so ... what it does is make us get bus events for the
> target as well as the lun, whereas without it we only get them for the
> lun.  I think something is misparsing the new target event and this is
> where the trouble is coming from.
>

I assume that since we now the source of this problem, you can create it at 
will. I only mention because if you need me to test a patch, it will have to be 
before Tuesday, June 17 - I go on holiday (vacation) on that day.

Thanks

Chris
> James



-- 
Beauty is in the eye of the beerholder.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
