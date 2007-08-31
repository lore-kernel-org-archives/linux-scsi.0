From: Gilbert Wu <Gilbert_Wu@adaptec.com>
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
Date: Fri, 31 Aug 2007 16:56:48 -0700
Message-ID: <1188604608.6036.15.camel@linux.site>
References: <1188583419.6353.9.camel@linux.site>
	 <46D888B7.1050301@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:52544 "HELO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750843AbXHaXnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Aug 2007 19:43:08 -0400
In-Reply-To: <46D888B7.1050301@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-08-31 at 17:31 -0400, Douglas Gilbert wrote:
> Gilbert Wu wrote:
> > Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source d=
evice
> > driver to fix smartctl utility problem.
> >=20
> > Contribution:
> >    Gilbert Wu <gilbert_wu@adaptec.com>
> >=20
> > Change Log:
> >=20
> >=20
> > 1. Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"
> >    does not work on aic94xx device drive with SATA devices.
> >    The smartctl utility send down ATA smart command to aic94xx
> >    driver and fail to get the result which is stored on ATA output
> >    register.=20
> >    In normal case, Aic94xx=E2=80=99s firmware does not return the v=
alue of
> >    ATA output register to device driver due to performance reason.
> >    To solve this issue then the driver need to turn on internal
> >    flag (CSMI_TASK) for particular ATA command to enable firmware
> >    to return the value of ATA output register.
>=20
> Recent versions of smartmontools (say 5.38 from CVS at
> sourceforge) don't need the '-d ata' option any more.
>=20
> If smartctl or smartd see /dev/sd<x> in Linux, they will
> assume a SCSI disk, do an INQUIRY and if they see
> "ATA     " in the T10 vendor identification field then an
> ATA (most likely SATA) disk is assumed behind a SAT layer.
> Thereafter ATA commands will be issued, each wrapped in
> a SCSI ATA PASS-THROUGH(16) command.
>=20
> Perhaps you might check that this works with the aic94xx
> driver. [It does work with MPT SAS HBAs.]
>=20
> Doug Gilbert

The smartctl-5.38 works fine with aic94xx after fixed the ATA register
output problem. I also verify it by adding debug message that
smartctl-5.8 utility sends ATA smart command to aic94xx driver with SAT=
A
device.

Thanks!
Gilbert
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
