From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: S3 with pata_via fails to resume, ide_via82Cxxx works
Date: Wed, 31 Dec 2008 20:15:35 +0100
Message-ID: <20081231201535.4d86c159@neptune.home>
References: <20081230185037.7ec94e94@neptune.home>
	<20081230215953.235ce1b4@neptune.home>
	<200812311919.14579.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp-110-52.adsl.restena.lu ([158.64.110.52]:42929 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751882AbYLaTZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Dec 2008 14:25:38 -0500
In-Reply-To: <200812311919.14579.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Thanks for the patch, it fixes the oops for me too.

Unfortunately the re-discovery of the drive causes at least XFS to
error and shutdown its mounts :(

Is it possible to block any access to the devices on the scanned port
until the scan has completed? Otherwise this renders rescanning
on port with mounted (e.g. /) partition to suicide...

I also wonder why it took so long and there is that complaint about
lost interrupt + failure. Was there some operation in progress that
got "killed" by the scan?

Bruno



Dec 31 19:58:26 venus [   83.716209] Probing IDE interface ide0...
Dec 31 19:58:27 venus [   84.030107] hda: FUJITSU MHY2250BH, ATA DISK d=
rive
Dec 31 19:58:27 venus [   84.390048] hda: host max PIO5 wanted PIO255(a=
uto-tune) selected PIO4
Dec 31 19:58:27 venus [   84.390205] hda: UDMA/100 mode selected
Dec 31 19:58:39 venus [   96.640225] I/O error in filesystem ("hda3") m=
eta-data dev hda3 block 0x202f14       ("xlog_iodone") error 5 buf coun=
t 1024
Dec 31 19:58:39 venus [   96.640274] xfs_force_shutdown(hda3,0x2) calle=
d from line 1062 of file /usr/src/linux-2.6.28/fs/xfs/xfs_log.c.  Retur=
n address =3D 0xc021418a
Dec 31 19:58:39 venus [   96.640331] Filesystem "hda3": Log I/O Error D=
etected.  Shutting down filesystem: hda3
Dec 31 19:58:39 venus [   96.640359] Please umount the filesystem, and =
rectify the problem(s)
Dec 31 18:58:46 venus [  103.710105] hda: dma_timer_expiry: DMA status =
(0x20)
Dec 31 18:58:46 venus [  103.710128] hda: lost interrupt
Dec 31 18:58:46 venus [  103.710148] hda: ide_dma_intr: bad DMA status =
(0x30)
Dec 31 18:58:46 venus [  103.710168] hda: dma_intr: status=3D0x50 { Dri=
veReady SeekComplete }
Dec 31 18:58:46 venus [  103.710192] ide: failed opcode was: unknown
Dec 31 18:58:47 venus [  104.063206] hda: max request size: 512KiB
Dec 31 18:58:47 venus [  104.063230] hda: 488397168 sectors (250059 MB)=
 w/8192KiB Cache, CHS=3D30401/255/63
Dec 31 18:58:47 venus [  104.063450] hda: cache flushes supported
Dec 31 18:59:09 venus [  126.640091] Filesystem "hda3": xfs_log_force: =
error 5 returned.
Dec 31 18:59:39 venus [  156.640109] Filesystem "hda3": xfs_log_force: =
error 5 returned.
Dec 31 19:00:09 venus [  186.640093] Filesystem "hda3": xfs_log_force: =
error 5 returned.



On Wed, 31 December 2008 Bartlomiej Zolnierkiewicz wrote:
> Thanks for the report, the following patch fixes the OOPS for me:
>=20
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: fix ide_port_scan() to do ACPI setup after
> initializing request queues
>=20
> This makes ide_port_scan()'s behavior match ide_host_register()'s
> one and fixes OOPS in elv_may_queue() during port re-scan.
>=20
> Reported-by: Bruno Pr=C3=A9mont <bonbons@linux-vserver.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-probe.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Index: b/drivers/ide/ide-probe.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
> @@ -1694,8 +1694,8 @@ void ide_port_scan(ide_hwif_t *hwif)
>  	hwif->present =3D 1;
> =20
>  	ide_port_tune_devices(hwif);
> -	ide_acpi_port_init_devices(hwif);
>  	ide_port_setup_devices(hwif);
> +	ide_acpi_port_init_devices(hwif);
>  	hwif_register_devices(hwif);
>  	ide_proc_port_register_devices(hwif);
>  }
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
