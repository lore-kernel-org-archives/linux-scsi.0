From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: REPORT LUNS
Date: Mon, 23 Jun 2003 09:49:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030623094949.A7705@beaverton.ibm.com>
References: <3EE9DA00.A429F83F@fujitsu-siemens.com> <20030613112222.A23260@beaverton.ibm.com> <3EED69D6.BDB411F7@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:3308 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265247AbTFWQjr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 12:39:47 -0400
Content-Disposition: inline
In-Reply-To: <3EED69D6.BDB411F7@fujitsu-siemens.com>; from josef.moellers@fujitsu-siemens.com on Mon, Jun 16, 2003 at 08:55:18AM +0200
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Josef_M=F6llers?= <josef.moellers@fujitsu-siemens.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 16, 2003 at 08:55:18AM +0200, Josef M=F6llers wrote:
> Patrick Mansfield wrote:
> >=20
> > On Fri, Jun 13, 2003 at 04:04:48PM +0200, Josef M=F6llers wrote:
> > > Hi,
> > >
> > > Wile trying to figure out how to ignore non-existing LUNs on RAID
> > > devices, I have fallen across an error in scsilun_to_int() where =
it
> > > doesn't behave as the comment suggests and a problematic piece of=
 code
> > > in scsi_report_lun_scan().
> > >
> > > Patch is included.
> >=20
> > If we clear the upper bits (address method, per SAM-3), someone has=
 to
> > eventually set them again, and this is not handled today in linux s=
csi
> > core.
>=20
> The comment said that the upper two bits were ignored which they were
> not in the original code, so, apart from fixing the shifts, I also ad=
ded
> the mask to keep the code in sync with the comment. I haven't yet
> followed the use of the value thus created.

Ignored meaning "does nothing with it", when we should probably do
something - proper conversion, an error or warning output. The current
code might work (with high bits set), if we did not exceed the
host->max_lun. We might need an 8 byte lun everywhere to make it work
right for all cases.

Can you give more details of the problem you are seeing, and software
(adapter driver) and hardware in use?

I did not notice your shift changes - I don't see how they work or what
it fixes.

If scsi_lun was: 0x1 0x2 0x3 0x4 0 0 0 0

Current code:

=46irst loop in scsilun_to_int, with i =3D 0:

	lun =3D 0 | ( (0x1 << 8 | 0x2) << 0) =3D 0x0102

Second loop i =3D 2:

	lun =3D 0x0102 | ( (0x3 << 8 | 0x4) << 16) =3D 0x03040102

Your patch would give:

=46irst loop i =3D 0:

	lun =3D 0 | ((0x1 & 0x3f) << 1) | (0x2 << 0) =3D 0x02

Second loop i =3D 2:

	lun =3D 0x02 | ( ((0x3 & 0x3f) << 17) | (0x4 << 16) =3D 0x00060002

-- Patrick Mansfield
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
