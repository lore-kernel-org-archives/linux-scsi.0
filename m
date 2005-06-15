From: Eddie Williams <Eddie.Williams@Steeleye.com>
Subject: Re: Compaq RA4x00 logical volumes not detected in kernel 2.6
Date: Wed, 15 Jun 2005 10:14:02 -0400
Message-ID: <1118844842.4343.46.camel@gator.sc.steeleye.com>
References: <66EFFC1A2B0A424E87D68EC10B1F458D6597C1@EXCH2.plzen-city.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:61606 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261464AbVFOOOL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 10:14:11 -0400
In-Reply-To: <66EFFC1A2B0A424E87D68EC10B1F458D6597C1@EXCH2.plzen-city.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Hor=E1k?= Daniel <horak@sitmp.cz>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

The problem is not with how the driver scans but with the device type
the array returns for each LUN.  The device type being returned by this
array, aka "scsi: unknown device type 12" is defined as "Storage array
controller device (e.g., RAID)".  This array does not return as a
"direct access device", aka device type 0. =20

As you have seen there is no mid-layer driver that knows how to handle
this type.

If you look at the cpqfc driver used with the Compaq FC controller it
converts the device type to 0.  I am not sure if the cpqfc driver is
doing more than just munging the device type from 12 to 0.  It has been
4 or so years since I worked with a 4x00 array and found the same thing
you did.  I was not very disappointed when Compaq discontinued the
4x00!  I had problems with the cpqfc driver and moved the array to a
Qlogic SAN.  When I ran into the issue with the device type as you foun=
d
I chose to go back to the cpqfc driver and work with Compaq to fix the
cpqfc driver rather than trying to fix the device type.

I think the short answer is to use the 4x00 arrays you have to use a
driver that knows how to map the array from a "RAID" device type to a
direct access device type.  That, I think, restricts you to use the
cpqfc driver.  I believe the 4x00 array is broken when it returns the
device type 12 for each LUN and rather than fix the firmware Compaq
chose to have the driver handle it. =20

Your other option is to create a module that will handle the device typ=
e
12 correctly.  I am not familiar with any other arrays that return a
type of 12 so I am not sure the effort is worth it.

Eddie

On Wed, 2005-06-15 at 08:10, Hor=C3=A1k Daniel wrote:
> Hello,
>=20
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
