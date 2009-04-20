From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/3] mpt fusion: Queue full event handling
Date: Mon, 20 Apr 2009 12:52:11 -0700
Message-ID: <660360F4F2570145BD872F298951B17A76BCB0BA@cosmail03.lsi.com>
References: <da824cf30904200938w627426ds4cee8a08b851e07@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og59.obsmtp.com ([64.18.14.183]:33903 "EHLO
	chip3og59.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbZDTTw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2009 15:52:27 -0400
In-Reply-To: <da824cf30904200938w627426ds4cee8a08b851e07@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Monday, April 20, 2009 10:39 AM,  Grant Grundler wrote:
> > =A0 =A0 =A0 =A0u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is_log=
ical_volume; /* is=20
> this logical volume */
>=20
> "is this logical volume" comment is just repeating the=20
> variable name. :)
> Maybe point at a description (e.g. "See page XX of Programmers Guide"=
)
> or omit this comment.

This is a boolean variable meaning whether the device object is a raid =
volume or not.  If its a raid volume, this is set to 1.  If its not a r=
aid volume, this is set to zero.  When its set to zero, then it means t=
he device could be bare drive, hidden raid component, or some other per=
iphial like tape, cdrom, etc.

>=20
> > + =A0 =A0 =A0 /* this belongs to volume */
> > + =A0 =A0 =A0 u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is_hidd=
en_raid_component;
>=20
> Does "belongs to a volume" mean a "logical volume"?

This is a boolean variable meaning whether the device object is a hidde=
n raid component.   A hidden raid component is a drive belonging to a r=
aid volume set.

>=20
> Suggestion: replace with something like /* is physical dev=20
> part of volume? */
>=20
> > + =A0 =A0 =A0 /* this valid when is_hidden_raid_component set */
> > + =A0 =A0 =A0 u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0volume_=
id;
>=20
> When looking at code, I would have associated volume_id
> with "is_logical_volume" variable. Maybe call this "hidden_raid_VID" =
?

This is the target id for the volume when the device object happens to =
be a hidden raid component.

>=20
> > + =A0 =A0 =A0 /* cached data for a removed device */
> > + =A0 =A0 =A0 u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is_cach=
ed;
>=20
> "cached data" generally refers to user payload data.
> I'm pretty sure that's not meant here.
> Suggestion:  /* Device info is cached (or not) */
>=20
> It's interesting to know this if the device has been removed.
> But the act of caching has to take place before the device is
> gone and thus, this flag will tell us the data was
> read once "before" and may not be current.
>=20
> Some devices will change the SCSI model string after
> they've spun up and loaded the full firmware from reserved
> tracks on the media.
>=20

No it doesn't  mean that.  =20

What this variable means that this device object is still live in the l=
ink list after the bare drive has been deleted, hence the data for this=
 object is cached.   The reason we are caching the device object is due=
 to a customer request.   This particular customer want us to support r=
eporting hidden raid components after then have been removed.    They w=
ant their storage apps to report this information so the service suppor=
t reps can identify which drive was pulled or failed.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
