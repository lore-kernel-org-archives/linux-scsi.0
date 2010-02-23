From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Patch]: Enable SCSI Wait Scan only if BLK_DEV_INITRD is set.
Date: Tue, 23 Feb 2010 17:08:30 +0100
Message-ID: <4B83FD7E.1070601@s5r6.in-berlin.de>
References: <4B830AEB.3010905@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49388 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab0BWQJJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 11:09:09 -0500
In-Reply-To: <4B830AEB.3010905@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Ren=C3=A9 Bolldorf wrote:

(I'm not sure whether the maintainers are going to accept that change
this time around, but anyway:)

> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 9191d1e..b785703 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -258,21 +258,22 @@ config SCSI_SCAN_ASYNC
>   	  or async on the kernel's command line.
>=20
>   config SCSI_WAIT_SCAN
> -	tristate  # No prompt here, this is an invisible symbol.
> +	tristate "SCSI Wait Scan"
>   	default m
>   	depends on SCSI
> +	depends on SCSI_SCAN_ASYNC
>   	depends on MODULES
[...]
> +	depends on BLK_DEV_INITRD

There needs to be an additional "depends on m" now that you made it
visible, so that it cannot be set to y.

> +	help
> +	  scsi_wait_scan is a loadable module which waits until all the asy=
nc scans are
> +	  complete.  The idea is to use it in initrd/ initramfs scripts.  Y=
ou modprobe
> +	  it after all the modprobes of the root SCSI drivers and it will w=
ait until
> +	  they have all finished scanning their buses before allowing the b=
oot to
> +	  proceed.
[...]
> +	  People that use a initramfs should say Y or M.

They "...should say M." actually.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D-=3D- --=3D- =3D-=3D=3D=3D
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
