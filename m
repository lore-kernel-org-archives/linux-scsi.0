From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] set CONFIG_SCSI_MULTI_LUN by default and update help
Date: Sun, 03 May 2009 09:57:15 -0500
Message-ID: <1241362635.5596.34.camel@mulgrave.int.hansenpartnership.com>
References: <49FDA2CA.4040601@tremplin-utc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48849 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207AbZECO5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 10:57:16 -0400
In-Reply-To: <49FDA2CA.4040601@tremplin-utc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

On Sun, 2009-05-03 at 15:57 +0200, =C3=89ric Piel wrote:
> Hello,=20
>=20
> Here is a patch against 2.6.30-rc4, but probably material for 2.6.31,
> which should avoid a couple of people to have the same problem as me.
>=20
> Eric
> =3D=3D
>=20
> I had to set CONFIG_SCSI_MULTI_LUN to y in order to get my SE W595
> working when plugging it as a mass storage. Looking at SCSI option to
> get a phone behaving correctly was convoluted to say the
> least. There are quite a few other reports about USB card readers
> needing this option as well.
>=20
> This patch improves the help text to make the use of the option more
> obvious and also defaults it to Y. I couldn't find any explicit repor=
ts
> of devices not working because of multiple LUNs probing, but only
> reports of people would had heard of such reports. In addition, every
> mainstream distro have this option activated, so it should definitely
> not be too dangerous.
>=20
> Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>

Actually, I'd really rather not alter the default value of this setting=
=2E
Multi-lun is rapidly becoming obsolete: any modern devices conforming t=
o
SCSI-3 use REPORT LUNS instead of doing LUN scanning, which gets us out
of the issue.  Conversely, the ancient devices which rely on correctly
setting this are more likely to get upset about any change in the
balance.

In your case, just add the changer's inquiry strings with a
BLIST_FORCELUN.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
