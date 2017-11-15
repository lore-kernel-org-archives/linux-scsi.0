From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko-WRw03QTAyf3sq35pWSNszA@public.gmane.org>
Subject: Seagate External SMR drive USB resets (was: Re: [PATCH] uas: Add
 US_FL_NO_ATA_1X quirk for one more Seagate device)
Date: Wed, 15 Nov 2017 16:43:14 -0500
Message-ID: <20171115164314.74ce972f@Vantage.cJ>
References: <20171110151344.10563-1-hdegoede@redhat.com>
        <20171112164234.48b5185c@Vantage.cJ>
        <46d6dde9-e811-9655-96db-a046de521782@246060.ru>
        <20171113011438.458369bf@Vantage.cJ>
        <3d276729-63f7-9727-4a22-55849712439c@redhat.com>
        <20171113123814.4e70a498@Vantage.cJ>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113123814.4e70a498-WI5o+PA4G9BYumZHjSPV5A@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens <jens-bugzilla.kernel.org-pLZ6rgtf4/bvLhUCWVjhBQ@public.gmane.org>, Andrey Astafyev <1@246060.ru>, Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Hans,


Tests are currently undergoing with drives operating in plain USB mass
storage class. In a first time, I'm filling drives with data
(uncontrolled corpus, just TBs that I have on hand). It looks like the
drives with most usage history are the ones that drop most often.

kernel: usb 3-4.1.1: reset SuperSpeed USB device number 6 using xhci_hcd
kernel: usb 3-4.2.1: reset SuperSpeed USB device number 7 using xhci_hcd
kernel: usb 3-4.3.1.1: reset SuperSpeed USB device number 13 using xhci_hcd
kernel: usb 3-4.3.2.1: reset SuperSpeed USB device number 14 using xhci_hcd
kernel: usb 3-4.4: reset SuperSpeed USB device number 8 using xhci_hcd
kernel: usb 6-4.3.2.1: reset SuperSpeed USB device number 8 using xhci_hcd
kernel: usb 6-4.3.3.1: reset SuperSpeed USB device number 9 using xhci_hcd
kernel: usb 6-4.4.1: reset SuperSpeed USB device number 6 using xhci_hcd

Will provide some more interesting/visual data later.


I'm surprised that the message "reset SuperSpeed USB device ..." is
displayed without prior information about why.
Someone with more background could give hints?


I took a look at the USB MSC code and have few questions / observations:

- It looks like (haven't tested it yet) the CONFIG_DYNAMIC_DEBUG isn't
  used with the USB mass storage debugging infrastructure, please
  confirm? If unused, are we interested to have a patch that would go
  back to regular pr_debug() that can work with dynamic debugging?

  Because with several of these drives / lots of activity / occasional
  issues, it looks like it will be hard to catch (yes I can use usbmon).

- It looks like there is no configurable timeout for USB MSC requests.
  Perhaps the device is not responding in time and this is why it's
  reset?


Best regards,

--=20
J=C3=A9r=C3=B4me


On Mon, 13 Nov 2017 12:38:14 -0500
J=C3=A9r=C3=B4me Carretero <cJ-ko-WRw03QTAyf3sq35pWSNszA@public.gmane.org> wrote:

> Hi Hans,
>=20
> On Mon, 13 Nov 2017 10:04:53 +0100
> Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> > Hi,
> >=20
> > On 13-11-17 07:14, J=C3=A9r=C3=B4me Carretero wrote: =20
> > > On Mon, 13 Nov 2017 07:01:30 +0300
> > > Andrey Astafyev <1@246060.ru> wrote:
> > >    =20
> > >> 13.11.2017 00:42, J=C3=A9r=C3=B4me Carretero =D0=BF=D0=B8=D1=88=D0=
=B5=D1=82:   =20
> > >>> Nov 12 16:20:59 Bidule kernel: sd 22:0:0:0: [sdaa] tag#2
> > >>> uas_eh_abort_handler 0 uas-tag 3 inflight: CMD OUT
> > >>> [...]
> > >>> Do you see such things? =20
>=20
> > > For my devices, adding US_FL_NO_ATA_1X to unusual_uas.h didn't
> > > change anything, and while adding US_FL_IGNORE_UAS (using
> > > quirks=3D0bc2:ab34:u,0bc2:ab38:u) there are still device resets,
> > > but they cause shorter hangs in system activity (~1 second when
> > > UAS was more like ~20).   =20
> >=20
> > The errors you are seeing are write errors. If you're seeing these
> > errors with both the usb-storage and uas drivers then there likely
> > is something wrong with your setup / hardware. =20
>=20
> My latest drives are Seagate Backup+ Hub 8TB and have ~ 50 hours of
> uptime. I have connected them to different controllers and they do the
> same as the first generation of the same capacity from 2015.
>=20
> SMART says that everything is OK on these disks (I have another that
> was RMA'ed and the symptoms of failure are something else), and if
> there were USB errors, the messages wouldn't be at the higher SCSI
> level, I guess I would see "xact failed" USB errors... no?
>=20
> > Does the drive in question use an external power-supply or is it
> > USB bus-powered? If it is the latter then that is likely the
> > problem. =20
>=20
> External power supply & ~2-ft cable provided by Seagate.
>=20
> > Anyways things I would check and try to swap are both the cable
> > used, the power-supply used (if any), the USB-port used as well
> > as trying the disk on a completely different computer. =20
>=20
> I did that. The same thing happens.
>=20
> > I've the feeling something is busted with your hardware, it
> > could be the disk itself. Did you mention that this was the first
> > release of a new higher capacity ? Those often have some kinks
> > which are worked out in later revisions. =20
>=20
> No, that's about the 3rd release I think.
>=20
>=20
> I really suspect this has to do with GC activity of these SMR drives,
> as if the write activity is throttled or in more spaced bursts (same
> USB-level intensity), then there is no problem.
>=20
> I will do longer tests and see if only some of them do that, after
> they have been subjected to similar usage history.
>=20
>=20
> Best regards,
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
