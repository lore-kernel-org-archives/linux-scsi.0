From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [PATCH] scsi: make scsi_devinfo infrastructure optional
Date: Sat, 12 Feb 2011 21:54:43 +0100
Message-ID: <20110212205443.GA2912@joi.lan>
References: <201102091515.16202.bzolnier@gmail.com>
 <AANLkTinbsTuvRWQXt8ViTKaD+VbH9YG9X-RqzvsdEV_h@mail.gmail.com>
 <1297440366.4967.83.camel@mulgrave.site>
 <201102121316.51333.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49678 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1BLU4l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Feb 2011 15:56:41 -0500
Content-Disposition: inline
In-Reply-To: <201102121316.51333.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 01:16:50PM +0100, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] scsi: make scsi_devinfo table content optional
> 
> Add CONFIG_SCSI_QUIRKS config option (default y and dependent
> on EMBEDDED config option) to allow disabling of the default
> scsi_devinfo table content.

Note: all uses of CONFIG_EMBEDDED were recently moved to CONFIG_EXPERT.
(see commit 6a108a14fa356ef607be308b68337939e56ea94e)
This one should probably use it too.

> 
> The output code size savings are ~7.5k for CONFIG_SCSI_QUIRKS=n
> (as measured on x86-64):
> 
> CONFIG_SCSI_QUIRKS=y:
>    text    data     bss     dec     hex filename
>    5965    5520     288   11773    2dfd drivers/scsi/scsi_devinfo.o
> 
> CONFIG_SCSI_QUIRKS=n:
>    text    data     bss     dec     hex filename
>    3740      48     288    4076     fec drivers/scsi/scsi_devinfo.o
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/scsi/Kconfig        |    9 +++++++++
>  drivers/scsi/scsi_devinfo.c |    2 ++
>  2 files changed, 11 insertions(+)
> 
> Index: b/drivers/scsi/Kconfig
> ===================================================================
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -47,6 +47,15 @@ config SCSI_TGT
>  	  If you want to use SCSI target mode drivers enable this option.
>  	  If you choose M, the module will be called scsi_tgt.
>  
> +config SCSI_QUIRKS
> +	bool "SCSI quirks list" if EMBEDDED
> +	default y
> +	help
> +	  This option enables deprecated in-kernel list of devices
> +	  that require settings that differ from the default.
> +
> +	  If unsure say Y.
> +
>  config SCSI_NETLINK
>  	bool
>  	default	n
> Index: b/drivers/scsi/scsi_devinfo.c
> ===================================================================
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -53,6 +53,7 @@ static struct {
>  	char *revision;	/* revision known to be bad, unused */
>  	unsigned flags;
>  } scsi_static_device_list[] __initdata = {
> +#ifdef CONFIG_SCSI_QUIRKS
>  	/*
>  	 * The following devices are known not to tolerate a lun != 0 scan
>  	 * for one reason or another. Some will respond to all luns,
> @@ -251,6 +252,7 @@ static struct {
>  	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
>  	{"Zzyzx", "RocketStor 500S", NULL, BLIST_SPARSELUN},
>  	{"Zzyzx", "RocketStor 2000", NULL, BLIST_SPARSELUN},
> +#endif
>  	{ NULL, NULL, NULL, 0 },
>  };
>  
> --
