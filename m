From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Wed, 8 Dec 2010 00:01:57 -0800 (PST)
Message-ID: <859462.89140.qm@web31809.mail.mud.yahoo.com>
References: <1291784742.24312.40.camel@mulgrave.site>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291784742.24312.40.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@suse.de>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--- On Tue, 12/7/10, James Bottomley <James.Bottomley@suse.de> wrote:
> Greg KH wrote:
> > On Tue, Dec 07, 2010 at 04:02:26PM -0800, Luben Tuikov
> wrote:
> > > --- On Sun, 12/5/10, Luben Tuikov <ltuikov@yahoo.com>
> wrote:
> > > > --- On Wed, 11/24/10, Luben Tuikov
> > > > <ltuikov@yahoo.com>
> > > > wrote:
> > > > >=20
> > > > > CBI/BBB isn't supposed to be, nor is
> designed to
> > > > support
> > > > > SAM-modern devices. So while REQUEST
> LUN /may/ work on
> > > > some
> > > > > devices which implement it in their
> firmware, it is
> > > > NOT a
> > > > > requirement for those devices as they
> are not required
> > > > to
> > > > > adhere to any SAM version. Those
> transport protocols
> > > > define
> > > > > a class-specific request to get the
> maximum LUN, and
> > > > another
> > > > > to reset the target port (instead of
> I_T Reset or LU
> > > > Reset).
> > > > > They also do not support SCSI Status
> completion of
> > > > the
> > > > > command, nor Autosense. They also do
> not provide TMFs.
> > > > They
> > > > > provide none of the SCSI transport
> protocol services
> > > > in
> > > > > support of the Execute Command
> procedure call. The
> > > > SCSI
> > > > > layer shouldn't be trying to guess
> their "SCSI
> > > > version", and
> > > > > or treat them as real SCSI devices
> sending REPORT
> > > > LUNs, etc.
> > > > > commands.
> > > > >=20
> > > > > Newer, modern transport protocols over
> USB, are part
> > > > of
> > > > > SAM, and it is devices who connect via
> those protocols
> > > > that
> > > > > are being disadvantaged, due to the
> adoption
> > > > (assumption) of
> > > > > CBI/BBB well into the SCSI layer.
> > > > >=20
> > > > > To this effect, the transport protocol
> can tell upper
> > > > > layers if the device is true SCSI (new
> usb transports
> > > > or
> > > > > other) or hybrid (usb-storage). In the
> former case,
> > > > the
> > > > > device is a SCSI device, in the latter,
> only basic
> > > > commands
> > > > > should be attempted.
> > > > >=20
> > > > > This isn't to say that firmware for
> those devices
> > > > wouldn't
> > > > > be buggy. Of course it will, and most
> will probably
> > > > port
> > > > > their legacy FW over to the new SPTL,
> but the
> > > > protocol
> > > > > requirements are there by design (i.e.
> there is no
> > > > longer
> > > > > Get Max Lun class-specific request, the
> application
> > > > client
> > > > > has to send REPORT LUNS, and FW has to
> answer it) and
> > > > we
> > > > > have to accommodate that.
> > > > >=20
> > > > > It is in this spirit that this patch
> doesn't change
> > > > wire
> > > > > behavior, but simply parses data
> returned by a
> > > > command
> > > > > already supported by older protocols.
> > > >=20
> > > > Did anyone pick up this patch?
> > >=20
> > > It's been over 6 weeks now that this patch's been
> in these mailing lists.
> > > Will anyone pick up this patch, or should I stop
> posting it every
> > > week? Please let me know--it's been posted here 6
> times in the last 6
> > > weeks.
> >=20
> > James, this is all you.=A0 Any thoughts?
>=20
> Well, not other than I've already said:=A0 I think it
> looks OK, so I
> marked it for my merge window queue.=A0 I'd still rather
> like USB people
> to confirm that the original reason why this was done (to
> prevent device
> crashes on the mode sense) is no longer an issue ... but
> it's only USB
> stuff, so suppose I'm OK with finding out in the field.

Check their responses above in this thread. The USB people seem to be o=
kay with it. The thread is archived here: http://marc.info/?t=3D1290445=
08400003&r=3D1&w=3D2.

   Luben
