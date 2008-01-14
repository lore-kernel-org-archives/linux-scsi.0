From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: PATCH: usb-storage-psc1350-v4.patch (was Linux scsi
	/	usb-mass-storage and HP printer cardreader bug + fix)
Date: Mon, 14 Jan 2008 10:33:08 -0600
Message-ID: <1200328388.3159.20.camel@localhost.localdomain>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com>
	 <4785F908.3080307@hhs.nl> <47860106.3090509@panasas.com>
	 <4787CE08.5000304@hhs.nl> <1200303645.11301.15.camel@littletux>
	 <478B2F90.7010105@hhs.nl>  <20080114160310.GH14375@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080114160310.GH14375-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Cc: Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, Guillaume Bedot <littletux-QFiJtcdG+fw@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, fedora-kernel-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, USB development list <linux-usb-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, David Brown <usb-storage2-GijAUarxTbMdnm+yROfE0A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 2008-01-14 at 08:03 -0800, Matthew Dharm wrote:
> On Mon, Jan 14, 2008 at 10:46:56AM +0100, Hans de Goede wrote:
> > Guillaume Bedot wrote:
> > >But it fixes only two models.
> > >Do you think other devices (hp or not) can be impacted ?
> > >There are hundreds of models with card readers only for hp :
> > >http://hplip.sourceforge.net/supported_devices/combined.html
> > >
> > >Will this be possible to use "LAST_SECTOR_BUG" quirk for testing without
> > >recompiling a kernel ?
> > >
> > 
> > This is not possible AFAIK, I've already wrote a blog post about this 
> > asking for people to test this, but got no responses.
> 
> Once the patches are accepted by the SCSI people, one of the things we can
> consider doing is enabling this quirk for all USB devices.  It should be
> pretty harmless to all properly working devices, and the performance hit
> should be pretty minimal.

The SCSI patches look OK, with the stylistic points fixed below ...
we'll need two separate patches as well (one for SCSI, one for USB).

> We may be able to convince the SCSI people to enable it for all devices,
> regardless of HCD.

No ... I'm not particularly keen to have enterprise vendors after my
blood ...


> +       /* Some devices (some sdcards for one) don't like it if the last sector
> +          gets read in a larger then 1 sector read */

The comment style in sd is

/*
 * comment
 */

> +       if (sdp->last_sector_bug && rq->nr_sectors > sdp->sector_size / 512 &&

An unlikely() here, please to force the compiler to optimise for the
non-buggy case.  Plus what is the rq->nr_sectors > sdp->sector_size /
512 test supposed to be doing?  that being true is supposed to be a
guarantee of the block layer (and if something goes wrong there's a
check for this lower down).

> +           block + rq->nr_sectors == get_capacity(disk)) {

rq->nr_sectors should be this_count

> +               this_count -= sdp->sector_size / 512;

If you relocate this code to after the sector_size/this_count adjustment
code (i.e. about line 442) you can just do --this_count;

James
