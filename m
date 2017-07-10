From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Mon, 10 Jul 2017 15:50:42 +0000
Message-ID: <1499701840.3555.7.camel@wdc.com>
References: <20170616082755.22832-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59252 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753646AbdGJPus (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2017 11:50:48 -0400
In-Reply-To: <20170616082755.22832-1-hch@lst.de>
Content-Language: en-US
Content-ID: <C5B8646C9E88F547B4C3FD67F7DDF494@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-06-16 at 10:27 +0200, Christoph Hellwig wrote:
> Remove the SCSI_MQ_DEFAULT config option and default to the blk-mq I/O
> path now that we had plenty of testing, and have I/O schedulers for
> blk-mq.  The module option to disable the blk-mq path is kept around
> for now.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/Kconfig | 11 -----------
>  drivers/scsi/scsi.c  |  4 ----
>  2 files changed, 15 deletions(-)
>=20
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 3c52867dfe28..d384f4f86c26 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -47,17 +47,6 @@ config SCSI_NETLINK
>  	default	n
>  	depends on NET
> =20
> -config SCSI_MQ_DEFAULT
> -	bool "SCSI: use blk-mq I/O path by default"
> -	depends on SCSI
> -	---help---
> -	  This option enables the new blk-mq based I/O path for SCSI
> -	  devices by default.  With the option the scsi_mod.use_blk_mq
> -	  module/boot option defaults to Y, without it to N, but it can
> -	  still be overridden either way.
> -
> -	  If unsure say N.
> -
>  config SCSI_PROC_FS
>  	bool "legacy /proc/scsi/ support"
>  	depends on SCSI && PROC_FS
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 1bf274e3b2b6..3d38c6d463b8 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -800,11 +800,7 @@ MODULE_LICENSE("GPL");
>  module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
> =20
> -#ifdef CONFIG_SCSI_MQ_DEFAULT
>  bool scsi_use_blk_mq =3D true;
> -#else
> -bool scsi_use_blk_mq =3D false;
> -#endif
>  module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO)=
;
> =20
>  static int __init init_scsi(void)

Since a fix for the performance regression triggered by this patch will be =
upstream
soon (see also https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-=
block.git/commit/?h=3Dfor-linus&id=3D32825c45ff8f4cce937ab85b030dc693ceb1aa=
0a):

Acked-by: Bart Van Assche <bart.vanassche@wdc.com>
