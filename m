From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Mon, 8 Jan 2007 15:03:15 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D704E9054@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C73370.CC696A8B"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61699 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030179AbXAHWDY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Jan 2007 17:03:24 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, manon@manon.de, azimman@vmware.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C73370.CC696A8B
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On  Saturday, January 06, 2007 8:31 AM, James Bottomley wrote:

>=20
> DID_BUS_BUSY causes an immediate retry, but it does debit the retry
> count, so it shouldn't cause "infinite retries" ... if it=20
> does, there's
> something else wrong here.
>=20
> I should also point out that the MPI_SCSI_STATUS_BUSY is
> SAM_STAT_BUSY ... this return will cause a queue stop and a=20
> requeue, but
> it doesn't actually debit the retries, so it *may* cause an infinite
> loop if the system is permanently busy.
>=20
> Finally, whatever's causing this, it should probably be=20
> treated the same
> for all fusion bus types ...
>=20

James -  I was incorrect in the way I worded this patch.  Please read
further.

Original request came to me an you from Manon Goo <manon@manon.de> on
November 21, see attached.

Here is what VMware says, per Adam Zimman <azimman@vmware.com>:

"VMkernel emulates a 1030/SPI.   Path Failovers induce the vmkernel to
return a BUSY
status for VM initiated SCSI I/O requests.  After a few I/O commands are
returned with
BUSY status, the RHEL VM will make the disk read-only.  The host status
of DID_BUS_BUSY
causes the RHEL scsi error recovery process to retry a BUSY I/O at most
5 times and=20
then return an I/O failure upward in the I/O stack. If the I/O request
failed with a scsi=20
status of BUSY rather than a host status of DID_BUS_BUSY, the RHEL scsi
error recovery process
would retry the I/O indefinitely."


In the 03.02.19, we add added the current logic for the following
reason:

"When a target device responds with BUSY status, the MPT driver was
sending DID_OK to the=20
SCSI mid layer, which caused the IO to be retried indefinitely between
the mid layer and the=20
driver.  By changing the driver return status to DID_BUS_BUSY, the
target BUSY status can=20
now flow through the mid layer to an upper layer Failover driver, which
will manage the I/O timeout."

Eric=20





------_=_NextPart_001_01C73370.CC696A8B
Content-Type: message/rfc822
Content-Transfer-Encoding: 7bit

X-MimeOLE: Produced By Microsoft Exchange V6.5
Received: from namail.ad.lsil.com ([172.21.36.18]) by NAMAIL4.ad.lsil.com with Microsoft SMTPSVC(6.0.3790.1830); Tue, 21 Nov 2006 18:39:34 -0700
MIME-Version: 1.0
Content-Type: multipart/signed;
	protocol="application/pgp-signature";
	micalg=pgp-sha1;
	boundary="==========0E442153109575A7A4AD=========="
Received: from milmhbs1.lsil.com ([147.145.21.209]) by namail.ad.lsil.com with Microsoft SMTPSVC(6.0.3790.1830); Tue, 21 Nov 2006 18:39:33 -0700
Received: from mail1.lsil.com (mail1.lsil.com [147.145.40.21]) by milmhbs1.lsil.com (8.12.11/8.12.10) with ESMTP id kAM1dQqW002772 for <Eric.Moore@lsil.com>; Tue, 21 Nov 2006 17:39:26 -0800
Received: from psmtp.com (exprod7mx87.postini.com [64.18.2.246]) by mail1.lsil.com (8.12.11/8.12.11) with SMTP id kAM1dKG8029950 for <Eric.Moore@lsil.com>; Tue, 21 Nov 2006 17:39:25 -0800 (PST)
Received: from source ([195.49.152.199]) (using TLSv1) by exprod7mx87.postini.com ([64.18.6.14]) with SMTP; Tue, 21 Nov 2006 17:39:19 PST
Received: from smtp.dg-i.net (localhost [127.0.0.1]) by localhost (Postfix) with ESMTP id 4FF66D004; Wed, 22 Nov 2006 02:39:17 +0100 (CET)
Received: from tun0.eva.adm.dg-i.net (tun0.eva.adm.dg-i.net [195.49.153.196]) by smtp.dg-i.net (Postfix) with ESMTP id E0383D003; Wed, 22 Nov 2006 02:39:15 +0100 (CET)
Content-class: urn:content-classes:message
Subject: concerning mptscsih.c
Date: Tue, 21 Nov 2006 18:39:26 -0700
Message-ID: <387AD120B7609E1E4A46AFD9@eva.local>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: concerning mptscsih.c
Thread-Index: AccN1xAfVOJ7JmFES22NGAYhC50wXg==
From: "Manon Goo" <manon@manon.de>
To: "Moore, Eric" <Eric.Moore@lsi.com>,
	<James.Bottomley@SteelEye.com>
Cc: "Andreas Dembach" <ad@dg-i.net>,
	"David Berghoff" <david@dg-i.net>
Reply-To: "Manon Goo" <manon@manon.de>

--==========0E442153109575A7A4AD==========
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Dear Sirs,

When changing from kernel 2.6.13 to 2.6.14 a change to the mtpscsih.c=20
driver was introduced thet changed the behaviour of the driver in respect=20
to timeouts.

The introduced changes around line 760.  As far as I undestand this change=20
propagets a bussy device running async as a host failture.
This is extremely troublesome when using the mptscsi driver with vmware ESX =

because esx expects the driver to wait when doing SAN pathfailovers or=20
going async.
Is there any chance to have the old behavior ?

Thanks in advance
Manon Goo


                        break;

+               case MPI_IOCSTATUS_SCSI_DATA_OVERRUN:           /* 0x0044 =
*/
+                       sc->resid=3D0;
                case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:        /* 0x0040 =
*/
                case MPI_IOCSTATUS_SUCCESS:                     /* 0x0000 =
*/
-                       scsi_status =3D pScsiReply->SCSIStatus;
-                       sc->result =3D (DID_OK << 16) | scsi_status;
+                       if (scsi_status =3D=3D MPI_SCSI_STATUS_BUSY)
+                               sc->result =3D (DID_BUS_BUSY << 16) |=20
scsi_status;
+                       else
+                               sc->result =3D (DID_OK << 16) | =
scsi_status;
                        if (scsi_state =3D=3D 0) {
                                ;
                        } else if (scsi_state &=20
MPI_SCSI_STATE_AUTOSENSE_VALID) {


Manon Goo
Dembach Goo Informatik GmbH & Co KG
Rathenauplatz 9
D-50674 K=C3=B6ln
Tel: +49 221 801483 0
Mobil: +49 177 8091974
Fax: +49 221 801483 20
Email: manon@dg-i.net


--==========0E442153109575A7A4AD==========
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (Darwin)

iD8DBQFFY6pPGsjj3OYWNZERAk19AJ0ZqDSyFRfhmRTfsWY2eyNitjnFpgCg79Pm
GHUTjzKzpqInsJd/3a5saSQ=
=hLRd
-----END PGP SIGNATURE-----

--==========0E442153109575A7A4AD==========--


------_=_NextPart_001_01C73370.CC696A8B--
