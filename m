From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] aacraid: fix shutdown crash when init fails
Date: Fri, 9 Feb 2018 20:13:07 +0000
Message-ID: <039b9fe9bd414b0baee38f19e0b4288d@microsemi.com>
References: <alpine.LRH.2.21.1802082158280.7112@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0062.outbound.protection.outlook.com ([104.47.34.62]:58592
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752218AbeBIUNM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Feb 2018 15:13:12 -0500
In-Reply-To: <alpine.LRH.2.21.1802082158280.7112@math.ut.ee>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>

> -----Original Message-----
> From: mroos@math.ut.ee [mailto:mroos@math.ut.ee] On Behalf Of Meelis
> Roos
> Sent: Thursday, February 08, 2018 11:58 PM
> To: linux-scsi@vger.kernel.org; dl-esc-Aacraid Linux Driver
> <aacraid@microsemi.com>
> Subject: [PATCH] aacraid: fix shutdown crash when init fails
>=20
>=20
> When aacraid init fails with "AAC0: adapter self-test failed.", shutdown =
leads to
> UBSAN warning and then oops:
>=20
> [154316.118423]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [154316.118508] UBSAN: Undefined behaviour in drivers/scsi/scsi_lib.c:232=
8:27
> [154316.118566] member access within null pointer of type 'struct Scsi_Ho=
st'
> [154316.118631] CPU: 2 PID: 14530 Comm: reboot Tainted: G        W       =
 4.15.0-
> dirty #89
> [154316.118701] Hardware name: Hewlett Packard HP NetServer/HP System
> Board, BIOS 4.06.46 PW 06/25/2003 [154316.118774] Call Trace:
> [154316.118848]  dump_stack+0x48/0x65
> [154316.118916]  ubsan_epilogue+0xe/0x40 [154316.118976]
> __ubsan_handle_type_mismatch+0xfb/0x180
> [154316.119043]  scsi_block_requests+0x20/0x30 [154316.119135]
> aac_shutdown+0x18/0x40 [aacraid] [154316.119196]
> pci_device_shutdown+0x33/0x50 [154316.119269]
> device_shutdown+0x18a/0x390 [...] [154316.123435] BUG: unable to handle
> kernel NULL pointer dereference at 000000f4 [154316.123515] IP:
> scsi_block_requests+0xa/0x30
>=20
> This is because aac_shutdown() does
>=20
>         struct Scsi_Host *shost =3D pci_get_drvdata(dev);
>         scsi_block_requests(shost);
>=20
> and that assumes shost has been assigned with pci_set_drvdata().
>=20
> However, pci_set_drvdata(pdev, shost) is done in aac_probe_one() far afte=
r
> bailing out with error from calling the init function
> ((*aac_drivers[index].init)(aac)), and when the init function fails, no e=
rror is
> returned from aac_probe_one() so PCI layer assumes there is driver attach=
ed,
> and tries to shut it down later.
>=20
> Fix it by returning error from aac_probe_one() when card-specific init fu=
nction
> fails.
>=20
> This fixes reboot on my HP NetRAID-4M with dead battery.
>=20
> Signed-off-by: Meelis Roos <mroos@linux.ee>

Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
