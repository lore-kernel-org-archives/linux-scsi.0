From: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Subject: Re: [PATCH resend 1/4] scsi/sr: add no_read_disc_info scsi_device flag
Date: Tue, 3 Aug 2010 09:37:30 -0700
Message-ID: <20100803163730.GA31000@one-eyed-alien.net>
References: <4C573BFD.8090407@redhat.com> <Pine.LNX.4.44L0.1008031012160.1853-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1008031012160.1853-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 03, 2010 at 10:14:48AM -0400, Alan Stern wrote:
> On Mon, 2 Aug 2010, Hans de Goede wrote:
>=20
> > Hi,
> >=20
> > On 07/28/2010 03:19 PM, James Bottomley wrote:
> > > On Fri, 2010-07-23 at 10:52 +0200, Hans de Goede wrote:
> > >> Some USB devices emulate a usb-mass-storage attached (scsi) cdrom de=
vice,
> > >> usually this fake cdrom contains the windows software for the device.
> > >> While working on supporting Appotech ax3003 based photoframes, which=
 do
> > >> this I discovered that they will go of into lala land when ever they
> > >> see a READ_DISC_INFO scsi command.
> > >>
> > >> Thus this patch adds a scsi_device flag (which can then be set by the
> > >> usb-storage driver through an unsual-devs entry), to indicate this, =
and
> > >> makes the sr driver honor this flag.
> > >>
> > >> I know this sucks, but as discussed on linux-scsi list there is no o=
ther
> > >> way to make this device work properly.
> > >>
> > >> Looking at usb traces made under windows, windows never sends a
> > >> READ_DISC_INFO during normal interactions with a usb cdrom device. S=
o as
> > >> this cdrom emulation thingie becomes more common we might see more of
> > >> this problem.
> > >
> > > So, I suppose we can do this.  I dislike threading device bugs like t=
his
> > > up and down the stack.  The usb stor_control_thread already does some
> > > command filtering; if it just rejected this command and READ
> > > CAPACITY(16) on the flags, I think it would be far less code and the
> > > SCSI subsystem would just do the right thing.
> > >
> > > I'd actually like to hear from USB what they'd prefer to do.
> > >
> >=20
> > I was sort of hoping that Alan Stern would reply to this, but maybe he =
is
> > on vacation?
>=20
> No, I'm here.  I've been waiting to hear from Matt Dharm.  He's the=20
> usb-storage maintainer, so it's his call.

Sorry, I've been travelling quite a lot lately.

> In general it's hard to know how command filtering at the usb-storage=20
> level will interact with the higher SCSI layers.  In this case we have=20
> James's assurance that it will be okay.

usb-storage is really just a command/data transport mechanism.  I've tried
to keep the command filtering to an absolute minimum.  In the past, we've
engaged in command filtering and it was a pretty big disaster in terms of
maintainance.

Basically, my theory for pushing this into the SCSI layers comes down to
these reasons:

1) A lot of these sorts of things only applies to one type of device or
another.  Either a specific type (CD-ROM, Random-Access, etc) or a specific
vendor.  It is much easier for SCSI layers to identify these devices than
usb-storage to do so.  In this specific case, we need to make a change only
to how CD-ROM devices work; usb-storage doesn't track the device type.

2) A lot of these bugs will re-appear in either sbp2 or UAS, both of which
use SCSI, so let's put all this in a common place rather than replicate it
multiple times.

3) With many of these things, what we are really trying to do is implement
some sort of sea-change in the command stream.  Consider devices which only
accept 6-byte commands instead of 10-byte commands.  Usb-storage could
intercept the 10-byte commands and either re-write all of them
(problematic, we've tried this before) or reject them in such a way as to
try to get the SCSI layers to generate the 6-byte variants (problematic, as
the SCSI folks could change their logic at any time, we've tried this
before).  It makes *way* more sense to just *tell* the SCSI layers what we
want, rather than do various forms of trickery to make it happen.

In short, after years of running around trying to make devices work, the
only reliable and maintainable way for doing this seems to be to make
commands originate correctly, rather than try to intercept the commands
in-flight and do some sort of fixup.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

P:  Nine more messages in admin.policy.
M: I know, I'm typing as fast as I can!
					-- Pitr and Mike
User Friendly, 11/27/97

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFMWEXK3gL8qCooyc4RAnM9AJ44Ee6zb/d8sblHEnSdDnQUtKjCKgCdG7v4
m9FXTsWmTmkCNPzIcP+AKXE=
=oVj8
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
