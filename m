From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: S3 with pata_via fails to resume, ide_via82Cxxx works
Date: Fri, 2 Jan 2009 23:50:34 +0100
Message-ID: <20090102235034.5660b85a@neptune.home>
References: <20081230185037.7ec94e94@neptune.home>
	<20081231201535.4d86c159@neptune.home>
	<20081231232412.173c87a7@neptune.home>
	<200901022213.53606.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp-110-61.adsl.restena.lu ([158.64.110.61]:35044 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757436AbZABW4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jan 2009 17:56:36 -0500
In-Reply-To: <200901022213.53606.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Fri, 02 January 2009 Bartlomiej Zolnierkiewicz wrote:
-snip-
> >=20
> > I guess the binfmt-0000 is cause by XFS reading at wrong location
> > on disc and kernel seeing random data as bin format signature.
> >=20
> >=20
> > On reboot no more bootloader.
> > hexdump with rescue system showed XFS magic in very first sector of
> > the disc, (rescuing the GPT worked - I assume parted used copy at
> > end of disc) though the first partition also got corrupted.
> >=20
> > This looks like the scan is pretty dangerous in case anything has a
> > reference to a disc/partition on the scanned channel :(

That's fine with me - eventually it would even be worth adding a
printk() as reminder on code path for "scan" and "delete_devices"
triggered when there exists an active user of the bus/device being
probed.

This way there is at least a notice in case something goes wrong (and
when the locking is fixed a reminder to adjust the documentation)

> I'm really sorry to hear it but "delete_devices" / "scan" interfaces
> are currently not ready for use on actively used devices (there are
> still some locking issues with the core code that need to be
> addressed before this can be allowed).
>=20
> Even though HOWTO only mentions use for replacing devices (not
> rescaning) I admit that it should be more clear about the above:
>=20
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: update warm-plug HOWTO
>=20
> Reported-by: Bruno Pr=C3=A9mont <bonbons@linux-vserver.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  Documentation/ide/warm-plug-howto.txt |    5 +++++
>  1 file changed, 5 insertions(+)
>=20
> Index: b/Documentation/ide/warm-plug-howto.txt
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/Documentation/ide/warm-plug-howto.txt
> +++ b/Documentation/ide/warm-plug-howto.txt
> @@ -11,3 +11,8 @@ unplug old device(s) and plug new device
>  # echo -n "1" > /sys/class/ide_port/idex/scan
> =20
>  done
> +
> +NOTE: please make sure that partitions are unmounted and that there
> are +no other active references to devices before doing
> "delete_devices" step, +also do not attempt "scan" step on devices
> currently in use -- otherwise +results may be unpredictable and lead
> to data loss if you're unlucky
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
