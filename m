From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI device rescan, detection of disconnected device,
	or	switched devices.
Date: Thu, 31 Jul 2008 11:20:30 -0500
Message-ID: <1217521230.3333.16.camel@localhost.localdomain>
References: <1217248348.4133.51.camel@galr-linux>
	 <488DC55C.2050603@s5r6.in-berlin.de> <1217487434.25491.34.camel@galr-linux>
	 <4891792C.6020304@s5r6.in-berlin.de> <1217504895.25491.69.camel@galr-linux>
	 <1217513749.3333.7.camel@localhost.localdomain>
	 <1217520571.6768.14.camel@galr-linux.storwiz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38561 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbYGaQUc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 12:20:32 -0400
In-Reply-To: <1217520571.6768.14.camel@galr-linux.storwiz.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gal Rosen <galr@storwize.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

On Thu, 2008-07-31 at 19:09 +0300, Gal Rosen wrote:
> On Thu, 2008-07-31 at 09:15 -0500, James Bottomley wrote:
> > Oh ... you're not really talking about hotplug, which is why everyo=
ne is
> > confused.  Hotplug is when you add or remove something from the bus=
=2E
> > What you've done is reconfigure the array.
> >=20
> > Most of the hotplug we do depends on the transport model (because w=
hat's
> > on the transport is changing).  Array reconfiguration has no hotplu=
g
> > event because SAM-3 has no real way of passing the information
> > asynchronously.  The best it can do is Unit Attention/reported luns=
 data
> > has changed (asc=3D0x3f/ascq=3D0xe) on the next command.
> >=20
> > The problem is that there's no way to process the event correctly e=
ven
> > when we get it.  All we can do is issue another report LUNS command=
 and
> > compare.  However, just because it looks like a single LUN disappea=
red
> > doesn't mean the others weren't permuted or altered in some way (wh=
ich
> > data we cannot get).
> >=20
>=20
> =EF=BB=BFWhy? if I keep a mapping between sg devices and device id (I=
nquiry page
> 0x83) then I have all the data.

No we don't, it depends on array policy.  Most arrays when told to take
10% of space from 10 luns and create a new one won't change the WWN of
the existing 10 LUNS, so we have no idea what just happened or what we
should do about it (incidentally, this is an example of a
reconfiguration you probably wanted to do offline anyway).

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
