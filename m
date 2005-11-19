From: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Sat, 19 Nov 2005 15:57:15 +0100
Message-ID: <200511191557.15533.kilian.cavalotti@lip6.fr>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <437E5E1E.2080902@torque.net> <437E80AA.2030400@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4-g19.free.fr ([212.27.42.30]:60371 "EHLO smtp4-g19.free.fr")
	by vger.kernel.org with ESMTP id S1751015AbVKSO5Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Nov 2005 09:57:16 -0500
In-Reply-To: <437E80AA.2030400@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: brking@us.ibm.com, linux-scsi@vger.kernel.org

On Saturday 19 November 2005 02:32, Douglas Gilbert wrote:
> Here are the test results for that patch. They indicate
> that the READ_CAPACITY(16) is getting to the disk (which
> doesn't support it since its capacity is 18 GB).

So it seems promising. :)

=46YI, I had reports from users who said to be able to use a >2TB exter=
nal=20
storage array (different vendor) with that same 39160 Adaptec HBA.

Here's part of their dmesg:
scsi4 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
=A0 =A0 =A0 =A0 =A0<Adaptec 3960D Ultra160 SCSI adapter>
=A0 =A0 =A0 =A0 =A0aic7899: Ultra160 Wide Channel A, SCSI Id=3D7, 32/25=
3 SCBs
(scsi4:A:0): 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
=A0 =A0Type: =A0 Direct-Access =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0ANSI SCSI revision: 03
scsi4:A:0:0: Tagged Queuing enabled. =A0Depth 4
SCSI device sdg: 2686132224 1024-byte hdwr sectors (2750599 MB)
SCSI device sdg: drive cache: write back
=A0 sdg: unknown partition table
Attached scsi disk sdg at scsi4, channel 0, id 0, lun 0

The weird part is that the driver does not even seem to invoke READ=20
CAPACITY(16) command, but directly succeed in getting device size.

To sum up my experiences so far:
--------------------|----------------|---------------|-----------------=
---------
Ext. device (>2TB)  | HBA            | Driver	     | Result		=09
--------------------|----------------|---------------|-----------------=
---------
Infortrend EonStore | Adaptec 39160  | aic7xxx       | READ CAPACITY(16=
) fails
A16U-G1410          |		     |               |
--------------------|----------------|---------------|-----------------=
---------
Infortrend EonStore | LSI Logic U320 | mptbase       | READ CAPACITY(16=
)
A16U-G1410          |		     |               | success=09
--------------------|----------------|---------------|-----------------=
---------
Proware             | Adaptec 39160  | aic7xxx       | Direct success
--------------------|----------------|---------------|-----------------=
---------

So it seems to come from both the external device and the aic7xxx drive=
r,since=20
the EonStore works with another HBA, and the aic7xxx works with another=
=20
device...

It seems quite strange to me, but I hope gurus here will have a rationa=
l=20
explanation. :)

Best regards,
--=20
Kilian CAVALOTTI                      Administrateur r=E9seaux et syst=E8=
mes
UPMC / CNRS - LIP6 (C870)
8, rue du Capitaine Scott                          Tel. : 01 44 27 88 5=
4
75015 Paris - France                               Fax. : 01 44 27 70 0=
0
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
