From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Forcing SCSI capacity for broken SD Card readers
Date: Wed, 16 Dec 2009 14:43:54 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0912161438270.2909-100000@iolanthe.rowland.org>
References: <da824cf30912161038r690e0032lb047c4a667f06c50@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:32914 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757376AbZLPTnz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2009 14:43:55 -0500
In-Reply-To: <da824cf30912161038r690e0032lb047c4a667f06c50@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Clemens Fruhwirth <clemens@endorphin.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Wed, 16 Dec 2009, Grant Grundler wrote:

> +linux-usb
>=20
> On Wed, Dec 16, 2009 at 8:51 AM, Clemens Fruhwirth
> <clemens@endorphin.org> wrote:
> > On Thu, Oct 15, 2009 at 1:29 AM, Grant Grundler <grundler@google.co=
m> wrote:
> >> On Wed, Oct 14, 2009 at 2:13 PM, Clemens Fruhwirth
> >> <clemens@endorphin.org> wrote:
> >>> Short: Attached is an incomplete patch that allows user space to =
force
> >>> the capacity of an scsi device to a specific value. Any not over
> >>> my-dead-body objections with that?
> >>
> >> No major objection - just the usual nits:
> >> Why not make /sys/block/sdX/size writeable?
> >> =C2=A0 =C2=A0(instead of adding an ioctl())
> >
> > Oh, I like that. Sorry it took me so long to reply. It turned out t=
hat
> > this is a much better idea. The value that is printed when reading =
the
> > size attribute is to the value that I set in my patch indirectly
> > through set_capacity. So, making size writable replaces that totall=
y.
> >
> > Patch attached.

Isn't just changing a block device's size at random times a bad thing=20
to do?  The size gets used a for a bunch of different things (checking=20
partition boundaries, validating I/O block ranges, and so on).

> >> After reading the wiki page[1], my impression is that the block si=
ze
> >> gets reported wrong and thus the total capacity is miscalculated f=
or
> >> 1GB-4GB SD cards with 1024 or 2048 byte blocks. Two questions arou=
nd this:
> >> a) Does the host need to know the correct block size for correct o=
peration?
> >
> > From experiments it does not look like that's the case. This is
> > surprising though, as one would suspect the card not to =C2=A0funct=
ion
> > properly otherwise. Frankly speaking, I have not looked down the
> > calling chain, especially how usb-storage treats these blocks, but =
I'd
> > say not at all. Seems like the USB reader, I have, just doesn't get
> > the capacity right, by not considering BLOCK_LEN > 512.

A lot of older card readers can't handle cards larger than 1 or 2 GB (I=
=20
forget which).  Or they see that the card has a larger block size and=20
then don't report it to the host.

> >> b) Do the devices report which SD Card Association spec they are c=
ompliant
> >> =C2=A0 with in the USB headers?

No.  Cards don't report anything but block data; only the reader
provides meta-information.  And it doesn't necessarily know anything
about the card -- in fact, the card might not even be inserted when the
reader is queried.

> > Autofixing this doesn't seem possible to me (except for the partiti=
on
> > trick) as the capacity =3D BLOCK_LEN * BLOCKS. If BLOCK_LEN isn't
> > detected correctly, we can't distinguish a 1GB from 2GB card.
>=20
> Agreed. That's why I'm thinking getting BLOCK_LEN right is more impor=
tant
> than hacking the resulting partition size. I'd be surprised if this c=
onversation
> hasn't already occurred on linux-usb mailing list.

It has.  Even if you managed to fix the block size, there's a good=20
chance the reader wouldn't work with large cards.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
