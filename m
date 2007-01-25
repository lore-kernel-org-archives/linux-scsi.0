From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] Add VPD support to aacraid
Date: Thu, 25 Jan 2007 13:37:06 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0141A067@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:39723 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965571AbXAYSp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jan 2007 13:45:27 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Mark Haverkamp <markh@linux-foundation.org>

Hannes, I am working the firmware and management software folks to find=
 out how to mine for this information. In your patch, the controller se=
rial number may be helpful, but not necessarily compliant?

Besides persistent device id, what else is gained? The controller ensur=
es persistent device id for the arrays through the meta-data, only migr=
ating if it happens to be a foreign (from another controller) array tha=
t collides with a native array at the same ID. Plug the constituent dri=
ves into totally different IDs in the SAS infrastructure, the ID remain=
s the same as presented by the controller. Plug those drives into anoth=
er controller, and if not taken by an existing array, the ID will again=
 remain the same.

If this is all of your concerns, adding the baggage to the driver will =
be redundant.

Sincerely -- Mark Salyzyn

> Hannes Reinecke wrote:
> > Hi Mark,
> >=20
> > I found to my surprise that the aacraid driver does not support VPD
> > pages at all. I'm somewhat used to modern SCSI HBAs export SCSI-2 d=
isks,
> > but not supporting VPD pages at all is really a bit .. hmm .. SCSI-=
1-ish.
> > And it makes it really impossible to assign a persistent device ID =
to
> > those drives.
> >=20
> [ .. ]
> >=20
> > Anyway, I don't think that it should be too hard to add proper VPD =
page
> > support (ie page 0x83), but for that one would have some documentat=
ion
> > how to ask the controller for it. I'll leave that to you :-)
> > You can use the page 0x80 support as a template.
>
> And here is even the patch, based on scsi-misc.
> Might help on reviewing.
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke			hare@suse.de
> SuSE Linux Products GmbH		S390 & zSeries
> Maxfeldstra=DFe 5				+49 911 74053 688
> 90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
