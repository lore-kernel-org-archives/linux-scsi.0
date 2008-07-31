From: Gal Rosen <galr@storwize.com>
Subject: Re: SCSI device rescan, detection of disconnected device,
	or	switched devices.
Date: Thu, 31 Jul 2008 19:09:31 +0300
Message-ID: <1217520571.6768.14.camel@galr-linux.storwiz.com>
References: <1217248348.4133.51.camel@galr-linux>
	 <488DC55C.2050603@s5r6.in-berlin.de> <1217487434.25491.34.camel@galr-linux>
	 <4891792C.6020304@s5r6.in-berlin.de> <1217504895.25491.69.camel@galr-linux>
	 <1217513749.3333.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.storwize.com ([62.90.10.208]:22772 "EHLO swdc2.storwiz.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750828AbYGaQJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 12:09:33 -0400
In-Reply-To: <1217513749.3333.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

On Thu, 2008-07-31 at 09:15 -0500, James Bottomley wrote:
> Oh ... you're not really talking about hotplug, which is why everyone=
 is
> confused.  Hotplug is when you add or remove something from the bus.
> What you've done is reconfigure the array.
>=20
> Most of the hotplug we do depends on the transport model (because wha=
t's
> on the transport is changing).  Array reconfiguration has no hotplug
> event because SAM-3 has no real way of passing the information
> asynchronously.  The best it can do is Unit Attention/reported luns d=
ata
> has changed (asc=3D0x3f/ascq=3D0xe) on the next command.
>=20
> The problem is that there's no way to process the event correctly eve=
n
> when we get it.  All we can do is issue another report LUNS command a=
nd
> compare.  However, just because it looks like a single LUN disappeare=
d
> doesn't mean the others weren't permuted or altered in some way (whic=
h
> data we cannot get).
>=20

=EF=BB=BFWhy? if I keep a mapping between sg devices and device id (Inq=
uiry page
0x83) then I have all the data.

Gal.

> So ... this event is manual intervention required because you have to
> tell SCSI what you did to the array, it can't work it out for itself.
>=20
> James
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
