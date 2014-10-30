From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 19/36] mac_scsi: Add module option to Kconfig
Date: Thu, 30 Oct 2014 08:44:36 +0100
Message-ID: <5451EC64.8090704@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052611.715435815@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbaJ3Hoi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2014 03:44:38 -0400
In-Reply-To: <20141027052611.715435815@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Allow mac_scsi to be built as a module. Replace the old validation of
> __setup options with code that validates both module and __setup opti=
ons.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/Kconfig    |    2=20
>  drivers/scsi/mac_scsi.c |  112 +++++++++++++++----------------------=
-----------
>  2 files changed, 38 insertions(+), 76 deletions(-)
>=20
> Index: linux/drivers/scsi/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/Kconfig	2014-10-27 16:17:59.000000000 +11=
00
> +++ linux/drivers/scsi/Kconfig	2014-10-27 16:25:42.000000000 +1100
> @@ -1595,7 +1595,7 @@ config ATARI_SCSI_RESET_BOOT
>  	  that leave the devices with SCSI operations partway completed.
> =20
>  config MAC_SCSI
> -	bool "Macintosh NCR5380 SCSI"
> +	tristate "Macintosh NCR5380 SCSI"
>  	depends on MAC && SCSI=3Dy
>  	select SCSI_SPI_ATTRS
>  	help
> Index: linux/drivers/scsi/mac_scsi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/mac_scsi.c	2014-10-27 16:25:40.000000000 =
+1100
> +++ linux/drivers/scsi/mac_scsi.c	2014-10-27 16:25:42.000000000 +1100
> @@ -62,15 +62,18 @@
>  static void mac_scsi_reset_boot(struct Scsi_Host *instance);
>  #endif
> =20
> -static int setup_called =3D 0;
>  static int setup_can_queue =3D -1;
> +module_param(setup_can_queue, int, 0);
>  static int setup_cmd_per_lun =3D -1;
> +module_param(setup_cmd_per_lun, int, 0);
>  static int setup_sg_tablesize =3D -1;
> +module_param(setup_sg_tablesize, int, 0);
>  static int setup_use_pdma =3D -1;
> -#ifdef SUPPORT_TAGS
> +module_param(setup_use_pdma, int, 0);
>  static int setup_use_tagged_queuing =3D -1;
> -#endif
> +module_param(setup_use_tagged_queuing, int, 0);
>  static int setup_hostid =3D -1;
> +module_param(setup_hostid, int, 0);
> =20
>  /* Time (in jiffies) to wait after a reset; the SCSI standard calls =
for 250ms,
>   * we usually do 0.5s to be on the safe side. But Toshiba CD-ROMs on=
ce more
> @@ -102,72 +105,34 @@ static __inline__ void macscsi_write(str
>    out_8(instance->io_port + (reg<<4), value);
>  }
> =20
> -/*
> - * Function : mac_scsi_setup(char *str)
> - *
> - * Purpose : booter command line initialization of the overrides arr=
ay,
> - *
> - * Inputs : str - comma delimited list of options
> - *
> - */
> -
> -static int __init mac_scsi_setup(char *str) {
> +#ifndef MODULE
> +static int __init mac_scsi_setup(char *str)
> +{
>  	int ints[7];
> -=09
> -	(void)get_options( str, ARRAY_SIZE(ints), ints);
> -=09
> -	if (setup_called++ || ints[0] < 1 || ints[0] > 6) {
> -	    printk(KERN_WARNING "scsi: <mac5380>"
> -		" Usage: mac5380=3D<can_queue>[,<cmd_per_lun>,<sg_tablesize>,<host=
id>,<use_tags>,<use_pdma>]\n");
> -	    printk(KERN_ALERT "scsi: <mac5380> Bad Penguin parameters?\n");
> -	    return 0;
> -	}
> -	   =20
> -	if (ints[0] >=3D 1) {
> -		if (ints[1] > 0)
> -			/* no limits on this, just > 0 */
> -			setup_can_queue =3D ints[1];
> -	}
> -	if (ints[0] >=3D 2) {
> -		if (ints[2] > 0)
> -			setup_cmd_per_lun =3D ints[2];
> -	}
> -	if (ints[0] >=3D 3) {
> -		if (ints[3] >=3D 0) {
> -			setup_sg_tablesize =3D ints[3];
> -			/* Must be <=3D SG_ALL (255) */
> -			if (setup_sg_tablesize > SG_ALL)
> -				setup_sg_tablesize =3D SG_ALL;
> -		}
> -	}
> -	if (ints[0] >=3D 4) {
> -		/* Must be between 0 and 7 */
> -		if (ints[4] >=3D 0 && ints[4] <=3D 7)
> -			setup_hostid =3D ints[4];
> -		else if (ints[4] > 7)
> -			printk(KERN_WARNING "mac_scsi_setup: invalid host ID %d !\n", int=
s[4] );
> -	}
> -#ifdef SUPPORT_TAGS=09
> -	if (ints[0] >=3D 5) {
> -		if (ints[5] >=3D 0)
> -			setup_use_tagged_queuing =3D !!ints[5];
> +
> +	(void)get_options(str, ARRAY_SIZE(ints), ints);
> +
> +	if (ints[0] < 1 || ints[0] > 6) {
> +		pr_err("Usage: mac5380=3D<can_queue>[,<cmd_per_lun>[,<sg_tablesize=
>[,<hostid>[,<use_tags>[,<use_pdma>]]]]]\n");
> +		return 0;
>  	}
> -=09
> -	if (ints[0] =3D=3D 6) {
> -	    if (ints[6] >=3D 0)
> +	if (ints[0] >=3D 1)
> +		setup_can_queue =3D ints[1];
> +	if (ints[0] >=3D 2)
> +		setup_cmd_per_lun =3D ints[2];
> +	if (ints[0] >=3D 3)
> +		setup_sg_tablesize =3D ints[3];
> +	if (ints[0] >=3D 4)
> +		setup_hostid =3D ints[4];
> +	if (ints[0] >=3D 5)
> +		setup_use_tagged_queuing =3D ints[5];
> +	if (ints[0] >=3D 6)
>  		setup_use_pdma =3D ints[6];
> -	}
> -#else
> -	if (ints[0] =3D=3D 5) {
> -	    if (ints[5] >=3D 0)
> -		setup_use_pdma =3D ints[5];
> -	}
> -#endif /* SUPPORT_TAGS */
> -=09
>  	return 1;
>  }
> =20
>  __setup("mac5380=3D", mac_scsi_setup);
> +#endif /* !MODULE */
> =20
>  /*
>   * Function : int macscsi_detect(struct scsi_host_template * tpnt)
> @@ -199,13 +164,8 @@ int __init macscsi_detect(struct scsi_ho
>  		tpnt->cmd_per_lun =3D setup_cmd_per_lun;
>  	if (setup_sg_tablesize >=3D 0)
>  		tpnt->sg_tablesize =3D setup_sg_tablesize;
> -
> -    if (setup_hostid >=3D 0)
> -	tpnt->this_id =3D setup_hostid;
> -    else {
> -	/* use 7 as default */
> -	tpnt->this_id =3D 7;
> -    }
> +	if (setup_hostid >=3D 0)
> +		tpnt->this_id =3D setup_hostid & 7;
> =20
>  #ifdef SUPPORT_TAGS
>      if (setup_use_tagged_queuing < 0)
> @@ -219,15 +179,15 @@ int __init macscsi_detect(struct scsi_ho
>  	return 0;
> =20
>      if (macintosh_config->ident =3D=3D MAC_MODEL_IIFX) {
> -	mac_scsi_regp  =3D via1+0x8000;
> -	mac_scsi_drq   =3D via1+0xE000;
> -	mac_scsi_nodrq =3D via1+0xC000;
> +	mac_scsi_regp  =3D (unsigned char *) VIA1_BASE + 0x8000;
> +	mac_scsi_drq   =3D (unsigned char *) VIA1_BASE + 0xE000;
> +	mac_scsi_nodrq =3D (unsigned char *) VIA1_BASE + 0xC000;
>  	/* The IIFX should be able to do true DMA, but pseudo-dma doesn't w=
ork */
>  	flags =3D FLAG_NO_PSEUDO_DMA;
>      } else {
> -	mac_scsi_regp  =3D via1+0x10000;
> -	mac_scsi_drq   =3D via1+0x6000;
> -	mac_scsi_nodrq =3D via1+0x12000;
> +	mac_scsi_regp  =3D (unsigned char *) VIA1_BASE + 0x10000;
> +	mac_scsi_drq   =3D (unsigned char *) VIA1_BASE + 0x6000;
> +	mac_scsi_nodrq =3D (unsigned char *) VIA1_BASE + 0x12000;
>      }
> =20
>      if (! setup_use_pdma)
Hmm. mac_via.h has this:

/*
 * Base addresses for the VIAs. There are two in every machine,
 * although on some machines the second is an RBV or an OSS.
 * The OSS is different enough that it's handled separately.
 *
 * Do not use these values directly; use the via1 and via2 variables
 * instead (and don't forget to check rbv_present when using via2!)
 */

#define VIA1_BASE	(0x50F00000)
#define VIA2_BASE	(0x50F02000)
#define  RBV_BASE	(0x50F26000)

So either that comment is obsolete or you should revert the above
bit ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
