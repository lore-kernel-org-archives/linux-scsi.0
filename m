From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Compaq RA4x00 logical volumes not detected in kernel 2.6
Date: Wed, 15 Jun 2005 09:12:39 -0500
Message-ID: <1118844759.5045.15.camel@mulgrave>
References: <66EFFC1A2B0A424E87D68EC10B1F458D6597C1@EXCH2.plzen-city.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:59814 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261457AbVFOOMx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 10:12:53 -0400
In-Reply-To: <66EFFC1A2B0A424E87D68EC10B1F458D6597C1@EXCH2.plzen-city.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Hor=E1k?= Daniel <horak@sitmp.cz>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-06-15 at 14:10 +0200, Hor=E1k Daniel wrote:
> I have a problem with detecting logical volumes on Compaq Raid Array
> 4x00 which is connected to my server via Emulex LP8000 Fibre Channel
> card and FC hub. System is CentOS 4 with kernel 2.6.9 (=3DRHEL4 clone=
)
>=20
> I get the following messagen in syslog
>=20
> scsi8 : Emulex LightPulse LP8000 1 Gigabit PCI Fibre Channel Adapter =
on
> PCI bus 04 device 20 irq 5=20
> scsi: unknown device type 12=20
> Vendor: COMPAQ Model: ARRAY CONTROLLER Rev: 2.54=20
> Type: RAID ANSI SCSI revision: 00=20

This is because the RA4100 shows it's volumes as the array controller
type.  You actually have to use array controller commands to access
them.  The cpqfc driver quietly translated these internally, so it's th=
e
only driver that will work with the RA4100 array (unless someone writes
an ULD for type array controller).  Unfortunately, compaq discontinued
support for cpqfc a while ago and the driver has been decaying in the
tree (to the point where it won't really build now).

James


> scsi: unknown device type 12=20
> Vendor: COMPAQ Model: ARRAY CONTROLLER Rev: 2.60=20
> Type: RAID ANSI SCSI revision: 00=20
>=20
> The result of discussion in lpfc forum is that there should be a prob=
lem
> the scanning part of SCSI layer.
>=20
> The detected devices should look like the folling output (these messa=
ges
> are from the same system booted into RHEL3 clone (Whitebox, kernel 2.=
4)
> with the arrays attached via Compaq FC card).
>=20
>  kernel: Starting timer : 0 0
>  kernel:   Vendor: COMPAQ    Model: LOGICAL VOLUME    Rev: 2.60
>  kernel:   Type:   Direct-Access                      ANSI SCSI
> revision: 02
>  kernel: Starting timer : 0 0
>  kernel:   Vendor: COMPAQ    Model: LOGICAL VOLUME    Rev: 2.60
>  kernel:   Type:   Direct-Access                      ANSI SCSI
> revision: 02
>  kernel: Starting timer : 0 0
>  kernel:   Vendor: COMPAQ    Model: LOGICAL VOLUME    Rev: 2.54
>  kernel:   Type:   Direct-Access                      ANSI SCSI
> revision: 02
>  kernel: Starting timer : 0 0
>  kernel: Attached scsi disk sda at scsi2, channel 0, id 0, lun 0
>  kernel: Attached scsi disk sdb at scsi2, channel 0, id 0, lun 1
>  kernel: Attached scsi disk sdc at scsi2, channel 0, id 1, lun 0
>=20
>=20
> 		Thank you
> 			Dan Horak
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
