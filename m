From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 19/36] mac_scsi: Add module option to Kconfig
Date: Fri, 31 Oct 2014 09:33:25 +0100
Message-ID: <54534955.7000108@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052611.715435815@telegraphics.com.au> <5451EC64.8090704@suse.de> <alpine.LNX.2.00.1410311520041.7380@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbaJaIdb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2014 04:33:31 -0400
In-Reply-To: <alpine.LNX.2.00.1410311520041.7380@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On 10/31/2014 08:17 AM, Finn Thain wrote:
>=20
> On Thu, 30 Oct 2014, Hannes Reinecke wrote:
>=20
>> On 10/27/2014 06:26 AM, Finn Thain wrote:
>>> Allow mac_scsi to be built as a module. Replace the old validation =
of=20
>>> __setup options with code that validates both module and __setup=20
>>> options.
>>>
>>> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>>>
>>> ---
>>>  drivers/scsi/Kconfig    |    2=20
>>>  drivers/scsi/mac_scsi.c |  112 +++++++++++++++--------------------=
-------------
>>>  2 files changed, 38 insertions(+), 76 deletions(-)
>>>
>>> Index: linux/drivers/scsi/Kconfig
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> --- linux.orig/drivers/scsi/Kconfig	2014-10-27 16:17:59.000000000 +=
1100
>>> +++ linux/drivers/scsi/Kconfig	2014-10-27 16:25:42.000000000 +1100
>>> @@ -1595,7 +1595,7 @@ config ATARI_SCSI_RESET_BOOT
>>>  	  that leave the devices with SCSI operations partway completed.
>>> =20
>>>  config MAC_SCSI
>>> -	bool "Macintosh NCR5380 SCSI"
>>> +	tristate "Macintosh NCR5380 SCSI"
>>>  	depends on MAC && SCSI=3Dy
>>>  	select SCSI_SPI_ATTRS
>>>  	help
>>> Index: linux/drivers/scsi/mac_scsi.c
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> --- linux.orig/drivers/scsi/mac_scsi.c	2014-10-27 16:25:40.00000000=
0 +1100
>>> +++ linux/drivers/scsi/mac_scsi.c	2014-10-27 16:25:42.000000000 +11=
00
>>> @@ -62,15 +62,18 @@
>>>  static void mac_scsi_reset_boot(struct Scsi_Host *instance);
>>>  #endif
>>> =20
>>> -static int setup_called =3D 0;
>>>  static int setup_can_queue =3D -1;
>>> +module_param(setup_can_queue, int, 0);
>>>  static int setup_cmd_per_lun =3D -1;
>>> +module_param(setup_cmd_per_lun, int, 0);
>>>  static int setup_sg_tablesize =3D -1;
>>> +module_param(setup_sg_tablesize, int, 0);
>>>  static int setup_use_pdma =3D -1;
>>> -#ifdef SUPPORT_TAGS
>>> +module_param(setup_use_pdma, int, 0);
>>>  static int setup_use_tagged_queuing =3D -1;
>>> -#endif
>>> +module_param(setup_use_tagged_queuing, int, 0);
>>>  static int setup_hostid =3D -1;
>>> +module_param(setup_hostid, int, 0);
>>> =20
>>>  /* Time (in jiffies) to wait after a reset; the SCSI standard call=
s for 250ms,
>>>   * we usually do 0.5s to be on the safe side. But Toshiba CD-ROMs =
once more
>>> @@ -102,72 +105,34 @@ static __inline__ void macscsi_write(str
>>>    out_8(instance->io_port + (reg<<4), value);
>>>  }
>>> =20
>>> -/*
>>> - * Function : mac_scsi_setup(char *str)
>>> - *
>>> - * Purpose : booter command line initialization of the overrides a=
rray,
>>> - *
>>> - * Inputs : str - comma delimited list of options
>>> - *
>>> - */
>>> -
>>> -static int __init mac_scsi_setup(char *str) {
>>> +#ifndef MODULE
>>> +static int __init mac_scsi_setup(char *str)
>>> +{
>>>  	int ints[7];
>>> -=09
>>> -	(void)get_options( str, ARRAY_SIZE(ints), ints);
>>> -=09
>>> -	if (setup_called++ || ints[0] < 1 || ints[0] > 6) {
>>> -	    printk(KERN_WARNING "scsi: <mac5380>"
>>> -		" Usage: mac5380=3D<can_queue>[,<cmd_per_lun>,<sg_tablesize>,<ho=
stid>,<use_tags>,<use_pdma>]\n");
>>> -	    printk(KERN_ALERT "scsi: <mac5380> Bad Penguin parameters?\n"=
);
>>> -	    return 0;
>>> -	}
>>> -	   =20
>>> -	if (ints[0] >=3D 1) {
>>> -		if (ints[1] > 0)
>>> -			/* no limits on this, just > 0 */
>>> -			setup_can_queue =3D ints[1];
>>> -	}
>>> -	if (ints[0] >=3D 2) {
>>> -		if (ints[2] > 0)
>>> -			setup_cmd_per_lun =3D ints[2];
>>> -	}
>>> -	if (ints[0] >=3D 3) {
>>> -		if (ints[3] >=3D 0) {
>>> -			setup_sg_tablesize =3D ints[3];
>>> -			/* Must be <=3D SG_ALL (255) */
>>> -			if (setup_sg_tablesize > SG_ALL)
>>> -				setup_sg_tablesize =3D SG_ALL;
>>> -		}
>>> -	}
>>> -	if (ints[0] >=3D 4) {
>>> -		/* Must be between 0 and 7 */
>>> -		if (ints[4] >=3D 0 && ints[4] <=3D 7)
>>> -			setup_hostid =3D ints[4];
>>> -		else if (ints[4] > 7)
>>> -			printk(KERN_WARNING "mac_scsi_setup: invalid host ID %d !\n", i=
nts[4] );
>>> -	}
>>> -#ifdef SUPPORT_TAGS=09
>>> -	if (ints[0] >=3D 5) {
>>> -		if (ints[5] >=3D 0)
>>> -			setup_use_tagged_queuing =3D !!ints[5];
>>> +
>>> +	(void)get_options(str, ARRAY_SIZE(ints), ints);
>>> +
>>> +	if (ints[0] < 1 || ints[0] > 6) {
>>> +		pr_err("Usage: mac5380=3D<can_queue>[,<cmd_per_lun>[,<sg_tablesi=
ze>[,<hostid>[,<use_tags>[,<use_pdma>]]]]]\n");
>>> +		return 0;
>>>  	}
>>> -=09
>>> -	if (ints[0] =3D=3D 6) {
>>> -	    if (ints[6] >=3D 0)
>>> +	if (ints[0] >=3D 1)
>>> +		setup_can_queue =3D ints[1];
>>> +	if (ints[0] >=3D 2)
>>> +		setup_cmd_per_lun =3D ints[2];
>>> +	if (ints[0] >=3D 3)
>>> +		setup_sg_tablesize =3D ints[3];
>>> +	if (ints[0] >=3D 4)
>>> +		setup_hostid =3D ints[4];
>>> +	if (ints[0] >=3D 5)
>>> +		setup_use_tagged_queuing =3D ints[5];
>>> +	if (ints[0] >=3D 6)
>>>  		setup_use_pdma =3D ints[6];
>>> -	}
>>> -#else
>>> -	if (ints[0] =3D=3D 5) {
>>> -	    if (ints[5] >=3D 0)
>>> -		setup_use_pdma =3D ints[5];
>>> -	}
>>> -#endif /* SUPPORT_TAGS */
>>> -=09
>>>  	return 1;
>>>  }
>>> =20
>>>  __setup("mac5380=3D", mac_scsi_setup);
>>> +#endif /* !MODULE */
>>> =20
>>>  /*
>>>   * Function : int macscsi_detect(struct scsi_host_template * tpnt)
>>> @@ -199,13 +164,8 @@ int __init macscsi_detect(struct scsi_ho
>>>  		tpnt->cmd_per_lun =3D setup_cmd_per_lun;
>>>  	if (setup_sg_tablesize >=3D 0)
>>>  		tpnt->sg_tablesize =3D setup_sg_tablesize;
>>> -
>>> -    if (setup_hostid >=3D 0)
>>> -	tpnt->this_id =3D setup_hostid;
>>> -    else {
>>> -	/* use 7 as default */
>>> -	tpnt->this_id =3D 7;
>>> -    }
>>> +	if (setup_hostid >=3D 0)
>>> +		tpnt->this_id =3D setup_hostid & 7;
>>> =20
>>>  #ifdef SUPPORT_TAGS
>>>      if (setup_use_tagged_queuing < 0)
>>> @@ -219,15 +179,15 @@ int __init macscsi_detect(struct scsi_ho
>>>  	return 0;
>>> =20
>>>      if (macintosh_config->ident =3D=3D MAC_MODEL_IIFX) {
>>> -	mac_scsi_regp  =3D via1+0x8000;
>>> -	mac_scsi_drq   =3D via1+0xE000;
>>> -	mac_scsi_nodrq =3D via1+0xC000;
>>> +	mac_scsi_regp  =3D (unsigned char *) VIA1_BASE + 0x8000;
>>> +	mac_scsi_drq   =3D (unsigned char *) VIA1_BASE + 0xE000;
>>> +	mac_scsi_nodrq =3D (unsigned char *) VIA1_BASE + 0xC000;
>>>  	/* The IIFX should be able to do true DMA, but pseudo-dma doesn't=
 work */
>>>  	flags =3D FLAG_NO_PSEUDO_DMA;
>>>      } else {
>>> -	mac_scsi_regp  =3D via1+0x10000;
>>> -	mac_scsi_drq   =3D via1+0x6000;
>>> -	mac_scsi_nodrq =3D via1+0x12000;
>>> +	mac_scsi_regp  =3D (unsigned char *) VIA1_BASE + 0x10000;
>>> +	mac_scsi_drq   =3D (unsigned char *) VIA1_BASE + 0x6000;
>>> +	mac_scsi_nodrq =3D (unsigned char *) VIA1_BASE + 0x12000;
>>>      }
>>> =20
>>>      if (! setup_use_pdma)
>> Hmm. mac_via.h has this:
>>
>> /*
>>  * Base addresses for the VIAs. There are two in every machine,
>>  * although on some machines the second is an RBV or an OSS.
>>  * The OSS is different enough that it's handled separately.
>>  *
>>  * Do not use these values directly; use the via1 and via2 variables
>>  * instead (and don't forget to check rbv_present when using via2!)
>>  */
>>
>> #define VIA1_BASE	(0x50F00000)
>> #define VIA2_BASE	(0x50F02000)
>> #define  RBV_BASE	(0x50F26000)
>>
>> So either that comment is obsolete or you should revert the above
>> bit ...
>=20
> Use of via1 had to be changed because that symbol is not exported.
>=20
> The comment you quoted is probably not wrong; it relates to programmi=
ng=20
> the VIA chip itself (see ADB drivers for example). But in this driver=
 we=20
> aren't interested in the VIA1 chip so I'd say niether via1 or VIA1_BA=
SE is=20
> good style. Hence my use of bare addresses in the platform resource=20
> initializers in patch 21.
>=20
> This example of VIA1_BASE + offset disappears in patch 21 (you can fi=
nd an=20
> unrelated example in arch/m68k/mac/config.c but that was not my doing=
).
>=20
> This patch is not meant to change the actual addresses used by mac_sc=
si;=20
> it just makes the driver modular. Use of VIA1_BASE seemed like a good=
 way=20
> to express the fact that the addresses are not changed yet (some mode=
ls=20
> use new addresses after patch 21).
>=20
> Basically, I just wanted a modular driver for debugging and bisection=
 and=20
> I wanted it early in the patch series. A modular mac_scsi.c aligns be=
tter=20
> with atari_scsi.c and sun3_scsi.c as they are already modular. That m=
eans=20
> that the three subsequent patches which convert {atari,mac,sun3}_scsi=
=2Ec to=20
> platform drivers also align nicely (so I could cross check them).
>=20
=46air enough.

Just needed some clarification here. My Mac experience ceased with a
IIcx :-)

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
