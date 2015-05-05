From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Question about driver category for submission
Date: Tue, 05 May 2015 10:43:48 -0700
Message-ID: <1430847828.2173.33.camel@HansenPartnership.com>
References: <1430845254.106831601@apps.rackspace.com>
	  <1430846638.2173.29.camel@HansenPartnership.com>
	 <1430847276.34321855@apps.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39554 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965490AbbEERnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 13:43:50 -0400
In-Reply-To: <1430847276.34321855@apps.rackspace.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux@highpoint-tech.com
Cc: linux-scsi@vger.kernel.org

On Tue, 2015-05-05 at 13:34 -0400, linux@highpoint-tech.com wrote:
> So you suggest to add new codes in libsas to provide PM support and
> add other features in mvsas by our own?

well, you seem to be presenting a choice between a new driver and addin=
g
a feature to an existing one.  The sensible engineering course seems to
be to add the feature.

The missing feature, by the way, isn't in mvsas, it's in libsas, which
is the helper library used by quite a few other sas cards.  That would
mean that they'd all gain PM support too.

James

> Regards,
> HighPoiny Linux Team
>=20
>=20
> -----Original Message-----
> From: "James Bottomley" <James.Bottomley@HansenPartnership.com>
> Sent: Tuesday, May 5, 2015 1:23pm
> To: linux@highpoint-tech.com
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: Question about driver category for submission
>=20
> On Tue, 2015-05-05 at 13:00 -0400, linux@highpoint-tech.com wrote:
> > Hello,
> > We would like to submit our driver for Linux kernel embedded. Our
> > product is using Marvell 9480/9495 SAS/SATA controller with Marvell
> > Port Multiplier(PM) controller to provide PM feature for SATA HDDs.
> > From driver source package, we found the Marvell has provided =E2=80=
=9Cmvsas=E2=80=9D
> > source package that covers this chip. But here are questions
> >=20
> > 1.  The =E2=80=9Cmvsas=E2=80=9D is based on SCSI modules so it link=
s to scsi library
> > where it doesn=E2=80=99t support PM feature
>=20
> It links to libsas, which has SATA support provided via libata but ha=
s
> the PM code stubbed out.  The reason for that is that it was always
> thought the benefit of cheap SAS chips was to drive SAS expanders loa=
ded
> with SATA devices, since PMs are very functionally lacking compared t=
o
> SAS expanders, so no-one was motivated to do the work.
>=20
> > 2.  We use the same controller chip, so we can=E2=80=99t have the c=
ode in
> > other category.=20
> > 3. To use PM feature, we need to link to SATA library
> >
> > Our current code is proprietary which uses scsi module and add PM a=
nd
> > staggered drive spin up features. Hence, this question is to ask Li=
nux
> > community to tell us how should we proceed this if we want to open =
our
> > code and get driver embedded? Do we need to add our code based on
> > mvsas source? How do we include SATA library in scsi module? or oth=
er
> > alternatives?
>=20
> Well, you're already including it via libsas; just do the extra libsa=
s
> work to plug in port multipliers and the existing mvsas driver should
> work for you.
>=20
> Staggered spin-ups are more problematic: it needs to be done in the s=
d
> module but there's never been a clear idea of how to do the grouping
> (that's why most enterprise devices do staggered spin ups on their ow=
n).
>=20
> James
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
