From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
Date: Fri, 31 Aug 2007 17:31:35 -0400
Message-ID: <46D888B7.1050301@torque.net>
References: <1188583419.6353.9.camel@linux.site>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34076 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965757AbXHaVcK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Aug 2007 17:32:10 -0400
In-Reply-To: <1188583419.6353.9.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gilbert Wu <Gilbert_Wu@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Gilbert Wu wrote:
> Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source dev=
ice
> driver to fix smartctl utility problem.
>=20
> Contribution:
>    Gilbert Wu <gilbert_wu@adaptec.com>
>=20
> Change Log:
>=20
>=20
> 1. Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"
>    does not work on aic94xx device drive with SATA devices.
>    The smartctl utility send down ATA smart command to aic94xx
>    driver and fail to get the result which is stored on ATA output
>    register.=20
>    In normal case, Aic94xx=E2=80=99s firmware does not return the val=
ue of
>    ATA output register to device driver due to performance reason.
>    To solve this issue then the driver need to turn on internal
>    flag (CSMI_TASK) for particular ATA command to enable firmware
>    to return the value of ATA output register.

Recent versions of smartmontools (say 5.38 from CVS at
sourceforge) don't need the '-d ata' option any more.

If smartctl or smartd see /dev/sd<x> in Linux, they will
assume a SCSI disk, do an INQUIRY and if they see
"ATA     " in the T10 vendor identification field then an
ATA (most likely SATA) disk is assumed behind a SAT layer.
Thereafter ATA commands will be issued, each wrapped in
a SCSI ATA PASS-THROUGH(16) command.

Perhaps you might check that this works with the aic94xx
driver. [It does work with MPT SAS HBAs.]

Doug Gilbert
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
