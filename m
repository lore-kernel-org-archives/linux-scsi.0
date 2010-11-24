From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Wed, 24 Nov 2010 08:55:02 -0800 (PST)
Message-ID: <447417.38293.qm@web31807.mail.mud.yahoo.com>
References: <1290593429.14652.33.camel@mulgrave.site>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1290593429.14652.33.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org

--- On Wed, 11/24/10, James Bottomley <James.Bottomley@suse.de> wrote:

> The basic problem isn't devices lying ... the worst we'll
> do is current
> behaviour (not SYNC when we should).=A0 The problem is
> devices that get
> confused (or worse simply crash the firmware).=A0 The
> best way to avoid
> the crashing firmware problem ... if we can assume that
> modern USB
> devices are better is to key off the SCSI version.=A0
> Unfortunately, in
> spite of several attempts, we've never managed to stop
> usbstorage lying
> about this:
>=20
> =A0=A0=A0 =A0=A0=A0 /* Some devices
> report a SCSI revision level above 2 but are
> =A0=A0=A0 =A0=A0=A0=A0=A0* unable
> to handle the REPORT LUNS command (for which
> =A0=A0=A0 =A0=A0=A0=A0=A0* support
> is mandatory at level 3).=A0 Since we already have
> =A0=A0=A0 =A0=A0=A0=A0=A0* a
> Get-Max-LUN request, we won't lose much by setting the
> =A0=A0=A0 =A0=A0=A0=A0=A0* revision
> level down to 2.=A0 The only devices that would be
> =A0=A0=A0 =A0=A0=A0=A0=A0* affected
> are those with sparse LUNs. */
> =A0=A0=A0 =A0=A0=A0 if
> (sdev->scsi_level > SCSI_2)
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> sdev->sdev_target->scsi_level =3D
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 sdev->scsi_level =3D
> SCSI_2;
>=20
> Untangling all of this would be rather complex, I fear.

CBI/BBB isn't supposed to be, nor is designed to support SAM-modern dev=
ices. So while REQUEST LUN /may/ work on some devices which implement i=
t in their firmware, it is NOT a requirement for those devices as they =
are not required to adhere to any SAM version. Those transport protocol=
s define a class-specific request to get the maximum LUN, and another t=
o reset the target port (instead of I_T Reset or LU Reset). They also d=
o not support SCSI Status completion of the command, nor Autosense. The=
y also do not provide TMFs. They provide none of the SCSI transport pro=
tocol services in support of the Execute Command procedure call. The SC=
SI layer shouldn't be trying to guess their "SCSI version", and or trea=
t them as real SCSI devices sending REPORT LUNs, etc. commands.

Newer, modern transport protocols over USB, are part of SAM, and it is =
devices who connect via those protocols that are being disadvantaged, d=
ue to the adoption (assumption) of CBI/BBB well into the SCSI layer.

To this effect, the transport protocol can tell upper layers if the dev=
ice is true SCSI (new usb transports or other) or hybrid (usb-storage).=
 In the former case, the device is a SCSI device, in the latter, only b=
asic commands should be attempted.

This isn't to say that firmware for those devices wouldn't be buggy. Of=
 course it will, and most will probably port their legacy FW over to th=
e new SPTL, but the protocol requirements are there by design (i.e. the=
re is no longer Get Max Lun class-specific request, the application cli=
ent has to send REPORT LUNS, and FW has to answer it) and we have to ac=
commodate that.

It is in this spirit that this patch doesn't change wire behavior, but =
simply parses data returned by a command already supported by older pro=
tocols.

     Luben
