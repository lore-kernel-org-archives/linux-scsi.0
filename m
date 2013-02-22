From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 02/15] pm80xx: Added vendor and device ids for SPCv/ve
 controllers
Date: Fri, 22 Feb 2013 17:22:14 +0000
Message-ID: <1361553734.2372.48.camel@dabdike.int.hansenpartnership.com>
References: <511A3532.1090402@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42631 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757524Ab3BVRWS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2013 12:22:18 -0500
In-Reply-To: <511A3532.1090402@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

On Tue, 2013-02-12 at 04:27 -0800, Anand wrote:
> >From edeb2b4b89ff6c7ddbb73366a2b4f6a86815d8eb Mon Sep 17 00:00:00 20=
01
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Mon, 4 Feb 2013 12:15:28 +0530
> Subject: [PATCH 02/15] pm80xx: Added vendor and device ids for
> SPCv/SPCve controllers
>=20
> Updated of pci id table  with device, vendor, subdevice and subvendor
> ids for 8081, 8088, 8089 SAS/SATA controllers
>=20
> Signed-off-by: Sakthivel K <DL.Team.PMC.SPC.Linux.open.source@pmcs.co=
m>
> Signed-off-by: Anand Kumar S <DL.Team.PMC.SPC.Linux.open.source@pmcs.=
com>

This doesn't build:

  CC [M]  drivers/scsi/pm8001/pm8001_init.o
drivers/scsi/pm8001/pm8001_init.c:857:37: error: =E2=80=98chip_8008=E2=80=
=99 undeclared
here (not in a function)
drivers/scsi/pm8001/pm8001_init.c:859:37: error: =E2=80=98chip_8018=E2=80=
=99 undeclared
here (not in a function)
drivers/scsi/pm8001/pm8001_init.c:861:37: error: =E2=80=98chip_8009=E2=80=
=99 undeclared
here (not in a function)
drivers/scsi/pm8001/pm8001_init.c:863:37: error: =E2=80=98chip_8019=E2=80=
=99 undeclared
here (not in a function)
make[3]: *** [drivers/scsi/pm8001/pm8001_init.o] Error 1

That's because you don't define this chip_8019 until patch 03/15 ...
that doesn't work.  The series has to be bisectable.  That means that
each patch applied in series must build and actually function.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
