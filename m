From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUG?] GDTH driver not working after upgrade to 2.6.24
Date: Thu, 31 Jan 2008 12:08:38 +0200
Message-ID: <47A19E26.30107@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:56624 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760762AbYAaKIw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 05:08:52 -0500
In-Reply-To: <fnqka6$l46$1@ger.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org

On Wed, Jan 30 2008 at 21:47 +0200, Sven K=F6hler <skoehler@upb.de> wro=
te:
> Hi,
>=20
> so i have upgraded a system to kernel 2.6.24. After that, it failed t=
o=20
> boot with the usual message telling, that the rootfs on device /dev/s=
da1=20
>   cannot be mounted (a raid1 run by the controller below).
>=20
> With 2.6.23.12, everything is working fine.
>=20
> # lspci -v:
>=20
> 03:01.0 RAID bus controller: Intel Corporation RAID Controller
>          Subsystem: Intel Corporation Unknown device 01db
>          Flags: bus master, 66MHz, slow devsel, latency 64, IRQ 17
>          Memory at ddffc000 (32-bit, prefetchable) [size=3D16K]
>          [virtual] Expansion ROM at deef0000 [disabled] [size=3D32K]
>          Capabilities: [80] Power Management version 2
>=20
> # GDT-related dmesg output (2.6.23.12):
>=20
> GDT-HA: Storage RAID Controller Driver. Version: 3.05
> ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 24 (level, low) -> IRQ 17
> GDT-HA: Found 1 PCI Storage RAID Controllers
> Configuring GDT-PCI HA at 3/1 IRQ 17
> GDT-HA 0: Name: SRCU42L
> scsi0 : SRCU42L
> scsi 0:0:0:0: Direct-Access     Intel    Host Drive  #00       PQ: 0 =
ANSI: 2
> scsi 0:2:6:0: Processor         ESG-SHV  SCA HSBP M29     1.06 PQ: 0 =
ANSI: 2
> sd 0:0:0:0: [sda] 143299800 512-byte hardware sectors (73369 MB)
> sd 0:0:0:0: [sda] Assuming Write Enabled
> sd 0:0:0:0: [sda] Assuming drive cache: write through
> sd 0:0:0:0: [sda] 143299800 512-byte hardware sectors (73369 MB)
> sd 0:0:0:0: [sda] Assuming Write Enabled
> sd 0:0:0:0: [sda] Assuming drive cache: write through
>   sda: sda1 sda2 < sda5 >
> sd 0:0:0:0: [sda] Attached SCSI disk
>=20
> # cat /boot/config-2.6.24 |grep GDT
>=20
> CONFIG_SCSI_GDTH=3Dy
>=20
>=20
>=20
>=20
> Any ideas?
>=20
> http://www.kernel.org/diff/diffview.cgi?file=3D%2Fpub%2Flinux%2Fkerne=
l%2Fv2.6%2Fpatch-2.6.24.bz2=20
> show huge drivers/scsi/gdth* related changes.
>=20
> Can't test at the moment. System went production.
>=20
>=20
> Regards,
>    Sven
>=20

Hi Sven!

CCing to the scsi mailing list.=20

Yes the gdth driver passed an open hart surgery in kernel 2.6.24. The b=
ad thing
about it is that all three of the Coders that did that did not have any=
 HW to work
on. One of them is me. We did cry for tester for a long time but no one=
 came forward.

Could you test patches for us? first thing would be to enable debug out=
put patch below.

If you absolutely need a 2.6.24 kernel, + gdth in a production system y=
ou could
checkout the 2.6.23 driver and compile. The old driver will work the sa=
me in 2.6.24.
It will not however even compile in 2.6.25-rcx.

If any one wants to send me a card that uses the gdth driver, I will be=
 very happy
to debug this card, and return it once I'm done.

Boaz

---
git-diff --stat -p
 drivers/scsi/gdth.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index c825239..eca72c4 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -188,6 +188,7 @@ static int __gdth_queuecommand(gdth_ha_str *ha, str=
uct scsi_cmnd *scp,
 				struct gdth_cmndinfo *cmndinfo);
 static void gdth_scsi_done(struct scsi_cmnd *scp);
=20
+#define DEBUG_GDTH 1
 #ifdef DEBUG_GDTH
 static unchar   DebugState =3D DEBUG_GDTH;
=20




=20

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
