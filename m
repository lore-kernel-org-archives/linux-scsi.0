From: Petros Koutoupis <petros@petroskoutoupis.com>
Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Mon, 09 May 2016 16:28:58 -0500
Message-ID: <1462829338.1873.4.camel@petroskoutoupis.com>
References: <1462668011.32105.7.camel@petros-ultrathin>
	 <alpine.LNX.2.00.1605081235490.19865@nippy.intranet>
	 <20160509080551.GH29510@mwanda>
	 <3aced88f2434c8dd0a8aa4fd902445a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:64547 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbcEIV3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2016 17:29:09 -0400
In-Reply-To: <3aced88f2434c8dd0a8aa4fd902445a9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, Dan Carpenter <dan.carpenter@oracle.com>, Finn Thain <fthain@telegraphics.com.au>
Cc: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

On Mon, 2016-05-09 at 15:18 +0530, Sumit Saxena wrote:
> >=20
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > Sent: Monday, May 09, 2016 1:36 PM
> > To: Finn Thain
> > Cc: Petros Koutoupis; kashyap.desai@avagotech.com;
> > sumit.saxena@avagotech.com; uday.lingala@avagotech.com;
> > megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org
> > Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
> >=20
> > Smatch doesn't quite catch it because we check "cmd_fusion->scmd" f=
or
> NULL
> >=20
> > then assign "scmd_local =3D cmd_fusion->scmd;" and dereference scmd=
_local
> > unconditionally...
> >=20
> > It does catch part of the bug if you have cross function analysis:
> >=20
> > =C2=A0 drivers/scsi/megaraid/megaraid_sas_fusion.c:2318 complete_cm=
d_fusion()
> > =C2=A0 error: we previously assumed 'cmd_fusion->scmd' could be nul=
l (see
> line 2281)
> >=20
> >=20
> > But that code was from 2010 so I never reported it to the original
> author or the
> >=20
> > list.
> "cmd_fusion->scmd" should not be NULL if scsi_io_req->Function is set=
 to
> MPI2_FUNCTION_SCSI_IO_REQUEST (OR) MEGASAS_MPI2_FUNCTION_LD_IO_REQUES
> (inside these two cases only, cmd_fusion->scmd will be dereferenced).=
 If
> cmd_fusion->scmd is NULL for these "scsi_io_req->Function", that will=
 a
> BUG and
> should not continue with other commands processing in that case.
>=20

Sumit,

To clarify, a detection of cmd_fusion->scmd being NULL with
scsi_io_req->Function set to=C2=A0MPI2_FUNCTION_SCSI_IO_REQUEST or
MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST should instead trigger a
BUG() and not attempt to iterate to the next command in the
list. Thank you.

--
Petros
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
