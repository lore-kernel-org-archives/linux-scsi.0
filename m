From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sat, 15 Mar 2008 13:34:20 -0500
Message-ID: <1205606060.6767.55.camel@localhost.localdomain>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
	 <1205529619.2904.87.camel@localhost.localdomain>
	 <1205531922.3522.57.camel@lov.site>
	 <1205590788.6767.12.camel@localhost.localdomain>
	 <1205594256.3109.53.camel@lov.site>
	 <1205597776.6767.40.camel@localhost.localdomain>
	 <1205604100.6767.43.camel@localhost.localdomain>
	 <1205605604.3109.148.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54977 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153AbYCOSeX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2008 14:34:23 -0400
In-Reply-To: <1205605604.3109.148.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Sat, 2008-03-15 at 19:26 +0100, Kay Sievers wrote:
> On Sat, 2008-03-15 at 13:01 -0500, James Bottomley wrote:
> > On Sat, 2008-03-15 at 11:16 -0500, James Bottomley wrote:
> > > On Sat, 2008-03-15 at 16:17 +0100, Kay Sievers wrote:
> > > > We just need to create something like a "contains" link from th=
e
> > > > component to the scsi device, and a "enclosure" link at the scs=
i device
> > > > back to the component, right?
> > >=20
> > > Assuming you're moving to the single tree model, then I can easil=
y do
> > > this:
> > >=20
> > > <real enclosure device>/<enclosure>/<enclosure component>/device =
-> link
> > > to component device
> > >=20
> > > with a back link in the component device pointing to the enclosur=
e
> > > component.
> > >=20
> > > The way components work, probably blowing away enclosure_componen=
t_class
> > > makes the most sense anyway.
> >=20
> > OK, so this is the patch doing the above; is this what you had in m=
ind?
> > We're now managing all the links.
>=20
> Yeah, that looks fine.
>=20
> While I in general don't really like the <classname>:<devname> symlin=
ks.
> One needs to readdir() the whole device directory to find them, which=
 is
> not nice for a 1:1 relationship link between two devices. I would pre=
fer
> to be able to find an enclosure component for a LUN by simply looking
> at:
>   /sys/bus/scsi/devices/0:0:0:0/enclosure/
> instead of searching for that composed link, because one can't predic=
t
> its name. Can there ever be more than one link from a device to an
> enclosure?
>=20
> Also the "device" link, it will work to use that name, I guess, but i=
t
> has usually a different meaning, as all "device" links are just
> meaninglessly pointing to the next parent device with !SYSFS_DEPRECAT=
ED.
> =EF=BB=BFWith !SYSFS_DEPRECATED <classname>:<devname> links are no lo=
nger
> created for any device, the class device directories just live in a
> subdirectory with the class name.

Right, but we can't do that with enclosure components, otherwise it
really will be a multi rooted tree.

> Do you prefer the <classname>:<devname>, "device" names?

I'm not wedded to the name.  I like the backlink because it tells me
where a device is in the enclosure when I look at it, but it could be
called anything.  I chose those names to match what's in 2.6.24, but I
suppose there aren't very many users yet, since it was new functionalit=
y
in 2.6.24.

If the backlink were called "enclosure_component", that would probably
be fine.  Not sure I have a better name than "device" for the actual
device in the enclosure slot, though.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
