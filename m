From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] hpsa: add support for legacy boards
Date: Tue, 11 Jul 2017 15:38:15 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D19533CE9D1@avsrvexchmbx2.microsemi.net>
References: <1499755744-79217-1-git-send-email-hare@suse.de>
 <alpine.LRH.2.20.1707111547060.31569@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0073.outbound.protection.outlook.com ([104.47.32.73]:30256
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933351AbdGKPiy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Jul 2017 11:38:54 -0400
In-Reply-To: <alpine.LRH.2.20.1707111547060.31569@math.ut.ee>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Jens Axboe <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: mroos@math.ut.ee [mailto:mroos@math.ut.ee] On Behalf Of Meelis
> Roos
> Sent: Tuesday, July 11, 2017 9:26 AM
> To: Hannes Reinecke <hare@suse.de>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>; Christoph Hellwig
> <hch@lst.de>; James Bottomley
> <james.bottomley@hansenpartnership.com>; Don Brace
> <don.brace@microsemi.com>; Jens Axboe <axboe@kernel.dk>; linux-
> scsi@vger.kernel.org; Hannes Reinecke <hare@suse.com>
> Subject: Re: [PATCH] hpsa: add support for legacy boards
>=20
> EXTERNAL EMAIL
>=20
>=20
> > Add support for legacy boards, ensuring to enable the driver for
> > those boards only when 'hpsa_allow_any' is set.
>=20
> Applied this patch, made sure I had compiled in hpsa and not cciss to
> avoid any variables from initramfs, and still I get this:
>=20
> [    4.015080] hpsa 0000:00:04.0: unrecognized board ID: 0x40800e11, igno=
ring.
> [    4.098473] hpsa 0000:00:04.0: Board ID not found
>=20
> Boot command line was "root=3D/dev/sda1 console=3DttyS0,9600 ro
> hpsa_allow_any=3D1" -
> seems correct.
>=20
> By looking at the code, I should see "unsupported board ID:" and it
> should work, but I see "unrecognized board ID:" and it does not work.
>=20
> Hmm, trying hpsa.hpsa_allow_any=3D1. Much better:
>=20
> [    3.891531] hpsa 0000:00:04.0: unsupported board ID: 0x40800e11
> [    3.962367] hpsa 0000:00:04.0: unsupported board ID: 0x40800e11
> [    4.033493] hpsa 0000:00:04.0: Controller reports max supported comman=
ds
> of 0 Using 16 instead. Ensure that firmware is up to date.
> [    4.175134] hpsa 0000:00:04.0: Physical aborts not supported
> [    4.242931] hpsa 0000:00:04.0: Logical aborts not supported
> [    4.309594] hpsa 0000:00:04.0: HP SSD Smart Path aborts not supported
> [    4.460889] hpsa 0000:00:04.0: Controller reports max supported comman=
ds
> of 0 Using 16 instead. Ensure that firmware is up to date.
> [    4.584679] scsi host0: hpsa
> [    4.587842] hpsa 0000:00:04.0: report luns requested format 2, got 0
> [    4.613215] hpsa 0000:00:04.0: scsi 0:0:0:0: masked Direct-Access     =
COMPAQ
> BD03685A24       PHYS DRV SSDSmartPathCap- En- Exp=3D0
> [    4.613219] hpsa 0000:00:04.0: C0:B1:T0:L0 Volume status is not availa=
ble
> through vital product data pages.
> [    4.613224] hpsa 0000:00:04.0: scsi 0:1:0:0: offline Direct-Access    =
 COMPAQ
> LOGICAL VOLUME   RAID-1(+0) SSDSmartPathCap- En- Exp=3D1
> [    4.613229] hpsa 0000:00:04.0: scsi 0:3:0:0: added RAID              C=
OMPAQ
> Smart Array 5i   controller SSDSmartPathCap- En- Exp=3D1
> [    6.187725] scsi 0:3:0:0: RAID              COMPAQ   Smart Array 5i   =
2.62 PQ: 0
> ANSI: 0
> [...]
> [    6.726872] VFS: Cannot open root device "sda1" or unknown-block(0,0):
> error -6
> [    6.814364] Please append a correct "root=3D" boot option; here are th=
e
> available partitions:
> [    6.914403] Kernel panic - not syncing: VFS: Unable to mount root fs o=
n
> unknown-block(0,0)
>=20
> Controller is detected, there is something behind it but no sda is
> detected and no bootup.
>=20
> What next?
>=20
> And, for readability, we should use something like "Using unsupported
> board ID", not plain "unsupported board ID" - the last one leaves
> assumption that it will not work, although it should.
>=20
> --
> Meelis Roos (mroos@linux.ee)

The 5i controller is probably too old for the hpsa driver to support.=20
The hpsa driver is looking for information to determine if the drive is onl=
ine/offline and
this information is not available.

What was the original issue you were having with the cciss driver?
