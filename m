From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko-WRw03QTAyf3sq35pWSNszA@public.gmane.org>
Subject: Re: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for one more Seagate
 device
Date: Mon, 13 Nov 2017 12:38:14 -0500
Message-ID: <20171113123814.4e70a498@Vantage.cJ>
References: <20171110151344.10563-1-hdegoede@redhat.com>
        <20171112164234.48b5185c@Vantage.cJ>
        <46d6dde9-e811-9655-96db-a046de521782@246060.ru>
        <20171113011438.458369bf@Vantage.cJ>
        <3d276729-63f7-9727-4a22-55849712439c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3d276729-63f7-9727-4a22-55849712439c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrey Astafyev <1@246060.ru>, Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Hans,

On Mon, 13 Nov 2017 10:04:53 +0100
Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Hi,
>=20
> On 13-11-17 07:14, J=C3=A9r=C3=B4me Carretero wrote:
> > On Mon, 13 Nov 2017 07:01:30 +0300
> > Andrey Astafyev <1@246060.ru> wrote:
> >  =20
> >> 13.11.2017 00:42, J=C3=A9r=C3=B4me Carretero =D0=BF=D0=B8=D1=88=D0=B5=
=D1=82: =20
> >>> Nov 12 16:20:59 Bidule kernel: sd 22:0:0:0: [sdaa] tag#2
> >>> uas_eh_abort_handler 0 uas-tag 3 inflight: CMD OUT
> >>> [...]
> >>> Do you see such things?

> > For my devices, adding US_FL_NO_ATA_1X to unusual_uas.h didn't
> > change anything, and while adding US_FL_IGNORE_UAS (using
> > quirks=3D0bc2:ab34:u,0bc2:ab38:u) there are still device resets,
> > but they cause shorter hangs in system activity (~1 second when
> > UAS was more like ~20). =20
>=20
> The errors you are seeing are write errors. If you're seeing these
> errors with both the usb-storage and uas drivers then there likely
> is something wrong with your setup / hardware.

My latest drives are Seagate Backup+ Hub 8TB and have ~ 50 hours of
uptime. I have connected them to different controllers and they do the
same as the first generation of the same capacity from 2015.

SMART says that everything is OK on these disks (I have another that
was RMA'ed and the symptoms of failure are something else), and if there
were USB errors, the messages wouldn't be at the higher SCSI level, I
guess I would see "xact failed" USB errors... no?

> Does the drive in question use an external power-supply or is it
> USB bus-powered? If it is the latter then that is likely the problem.

External power supply & ~2-ft cable provided by Seagate.

> Anyways things I would check and try to swap are both the cable
> used, the power-supply used (if any), the USB-port used as well
> as trying the disk on a completely different computer.

I did that. The same thing happens.

> I've the feeling something is busted with your hardware, it
> could be the disk itself. Did you mention that this was the first
> release of a new higher capacity ? Those often have some kinks
> which are worked out in later revisions.

No, that's about the 3rd release I think.


I really suspect this has to do with GC activity of these SMR drives,
as if the write activity is throttled or in more spaced bursts (same
USB-level intensity), then there is no problem.

I will do longer tests and see if only some of them do that, after
they have been subjected to similar usage history.


Best regards,

--=20
J=C3=A9r=C3=B4me
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
