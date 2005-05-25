From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi
Date: Wed, 25 May 2005 11:18:05 -0400
Message-ID: <4294972D.4030807@adaptec.com>
References: <42936441.0b798bab.39a4.ffff9774SMTPIN_ADDED@mx.googlegroups.com>	 <42939610.3070104@cs.wisc.edu> <1116976678.7710.34.camel@mulgrave>	 <000b01c560c0$42c59700$03031eac@ivivity.com> <1116982816.7710.58.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:15320 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262364AbVEYPSI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 11:18:08 -0400
In-Reply-To: <1116982816.7710.58.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: open_iscsi <ESQuicksall_open_iscsi@Comcast.net>, open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

On 05/24/05 21:00, James Bottomley wrote:
> On Tue, 2005-05-24 at 20:25 -0400, open_iscsi wrote:
>=20
>>The MC/S feature of iSCSI is not multi-pathing. Multi-pathing would b=
e the=20
>>use of multiple sessions to reach the same target. Generally the two=20
>>sessions would use the same InitiatorName+ISID but use different Targ=
et=20
>>Portal Groups at the target. In SCSI terms, it is the same initiator=20
>>accessing different SCSI ports.
>=20
>=20
> Well, yes, every driver vendor with a multi-path solution in-driver t=
hat
> made a single presentation to the mid-layer has argued that one...

MC/S in iSCSI can be seen as a "wide port" in SAS.

That is, commands are ordered, nexus is the same, going to the same por=
t,
etc, etc, etc.  MC/S, has nothing to do with multipathing, which sits a=
bove
the nexus level.  With MC/S the nexus is the same.

MC/S is a good thing.

	Luben

P.S. As Eddy mentioned multipathing sits at a higher level, namely
at the session level, where you open a different session to a different
port (=E0 la SCSI parl=E9).
=20
> The bottom line is that implementation must be in-driver.  So every
> driver doing it this way has to have their own separate multi-path
> implementation.  Whether you call it FC/AL or MC/S (or any of the oth=
er
> buzz acronyms) it's still a driver implementation of pathing.
>=20
>=20
>>MC/S can be used to improve band width of a session without using=20
>>multi-pathing and it belongs in the driver because it is hidden from =
the=20
>>upper layers. Think of it like parallel wires, each carrying separate=
 (but=20
>>sequenced) commands in parallel.
>=20
>=20
> So far, no-one has been able to produce any figures to show that MC/S=
 is
> significantly better than symmetric active dm-multipath to an iSCSI
> target, but if you have them, please publish them.
>=20
> Hiding something from the upper layers which the upper layers could d=
o
> equally well themselves is what's considered wrong: it adds code bloa=
t
> with no tangible benefit.
>=20
> James
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
