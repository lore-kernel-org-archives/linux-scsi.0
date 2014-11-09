From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 19/36] mac_scsi: Add module option to Kconfig
Date: Sun, 9 Nov 2014 23:17:09 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1411091123260.4669@nippy.intranet>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052611.715435815@telegraphics.com.au> <5451EC64.8090704@suse.de> <alpine.LNX.2.00.1410311520041.7380@nippy.intranet> <54534955.7000108@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:39032 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaKIMSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2014 07:18:11 -0500
In-Reply-To: <54534955.7000108@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org


On Fri, 31 Oct 2014, Hannes Reinecke wrote:

> On 10/31/2014 08:17 AM, Finn Thain wrote:
> > 
> > On Thu, 30 Oct 2014, Hannes Reinecke wrote:
> > 
> >> On 10/27/2014 06:26 AM, Finn Thain wrote:
> >>> Allow mac_scsi to be built as a module. Replace the old validation of 
> >>> __setup options with code that validates both module and __setup 
> >>> options.
> >>>
> >>> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> >>>
> >>> ---
> >>>  drivers/scsi/Kconfig    |    2 
> >>>  drivers/scsi/mac_scsi.c |  112 +++++++++++++++---------------------------------
> >>>  2 files changed, 38 insertions(+), 76 deletions(-)
> >>>
> >>> Index: linux/drivers/scsi/Kconfig
> >>> ===================================================================
> >>> --- linux.orig/drivers/scsi/Kconfig	2014-10-27 16:17:59.000000000 +1100
> >>> +++ linux/drivers/scsi/Kconfig	2014-10-27 16:25:42.000000000 +1100
> >>> @@ -1595,7 +1595,7 @@ config ATARI_SCSI_RESET_BOOT
> >>>  	  that leave the devices with SCSI operations partway completed.
> >>>  
> >>>  config MAC_SCSI
> >>> -	bool "Macintosh NCR5380 SCSI"
> >>> +	tristate "Macintosh NCR5380 SCSI"
> >>>  	depends on MAC && SCSI=y
> >>>  	select SCSI_SPI_ATTRS
> >>>  	help
> >>> Index: linux/drivers/scsi/mac_scsi.c
> >>> ===================================================================
> >>> --- linux.orig/drivers/scsi/mac_scsi.c	2014-10-27 16:25:40.000000000 +1100
> >>> +++ linux/drivers/scsi/mac_scsi.c	2014-10-27 16:25:42.000000000 +1100
> >>> @@ -62,15 +62,18 @@
> >>>  static void mac_scsi_reset_boot(struct Scsi_Host *instance);
> >>>  #endif
> >>>  
> >>> -static int setup_called = 0;
> >>>  static int setup_can_queue = -1;
> >>> +module_param(setup_can_queue, int, 0);
> >>>  static int setup_cmd_per_lun = -1;
> >>> +module_param(setup_cmd_per_lun, int, 0);
> >>>  static int setup_sg_tablesize = -1;
> >>> +module_param(setup_sg_tablesize, int, 0);
> >>>  static int setup_use_pdma = -1;
> >>> -#ifdef SUPPORT_TAGS
> >>> +module_param(setup_use_pdma, int, 0);
> >>>  static int setup_use_tagged_queuing = -1;
> >>> -#endif
> >>> +module_param(setup_use_tagged_queuing, int, 0);
> >>>  static int setup_hostid = -1;
> >>> +module_param(setup_hostid, int, 0);
> >>>  
> >>>  /* Time (in jiffies) to wait after a reset; the SCSI standard calls for 250ms,
> >>>   * we usually do 0.5s to be on the safe side. But Toshiba CD-ROMs once more
> >>> @@ -102,72 +105,34 @@ static __inline__ void macscsi_write(str
> >>>    out_8(instance->io_port + (reg<<4), value);
> >>>  }
> >>>  
> >>> -/*
> >>> - * Function : mac_scsi_setup(char *str)
> >>> - *
> >>> - * Purpose : booter command line initialization of the overrides array,
> >>> - *
> >>> - * Inputs : str - comma delimited list of options
> >>> - *
> >>> - */
> >>> -
> >>> -static int __init mac_scsi_setup(char *str) {
> >>> +#ifndef MODULE
> >>> +static int __init mac_scsi_setup(char *str)
> >>> +{
> >>>  	int ints[7];
> >>> -	
> >>> -	(void)get_options( str, ARRAY_SIZE(ints), ints);
> >>> -	
> >>> -	if (setup_called++ || ints[0] < 1 || ints[0] > 6) {
> >>> -	    printk(KERN_WARNING "scsi: <mac5380>"
> >>> -		" Usage: mac5380=<can_queue>[,<cmd_per_lun>,<sg_tablesize>,<hostid>,<use_tags>,<use_pdma>]\n");
> >>> -	    printk(KERN_ALERT "scsi: <mac5380> Bad Penguin parameters?\n");
> >>> -	    return 0;
> >>> -	}
> >>> -	    
> >>> -	if (ints[0] >= 1) {
> >>> -		if (ints[1] > 0)
> >>> -			/* no limits on this, just > 0 */
> >>> -			setup_can_queue = ints[1];
> >>> -	}
> >>> -	if (ints[0] >= 2) {
> >>> -		if (ints[2] > 0)
> >>> -			setup_cmd_per_lun = ints[2];
> >>> -	}
> >>> -	if (ints[0] >= 3) {
> >>> -		if (ints[3] >= 0) {
> >>> -			setup_sg_tablesize = ints[3];
> >>> -			/* Must be <= SG_ALL (255) */
> >>> -			if (setup_sg_tablesize > SG_ALL)
> >>> -				setup_sg_tablesize = SG_ALL;
> >>> -		}
> >>> -	}
> >>> -	if (ints[0] >= 4) {
> >>> -		/* Must be between 0 and 7 */
> >>> -		if (ints[4] >= 0 && ints[4] <= 7)
> >>> -			setup_hostid = ints[4];
> >>> -		else if (ints[4] > 7)
> >>> -			printk(KERN_WARNING "mac_scsi_setup: invalid host ID %d !\n", ints[4] );
> >>> -	}
> >>> -#ifdef SUPPORT_TAGS	
> >>> -	if (ints[0] >= 5) {
> >>> -		if (ints[5] >= 0)
> >>> -			setup_use_tagged_queuing = !!ints[5];
> >>> +
> >>> +	(void)get_options(str, ARRAY_SIZE(ints), ints);
> >>> +
> >>> +	if (ints[0] < 1 || ints[0] > 6) {
> >>> +		pr_err("Usage: mac5380=<can_queue>[,<cmd_per_lun>[,<sg_tablesize>[,<hostid>[,<use_tags>[,<use_pdma>]]]]]\n");
> >>> +		return 0;
> >>>  	}
> >>> -	
> >>> -	if (ints[0] == 6) {
> >>> -	    if (ints[6] >= 0)
> >>> +	if (ints[0] >= 1)
> >>> +		setup_can_queue = ints[1];
> >>> +	if (ints[0] >= 2)
> >>> +		setup_cmd_per_lun = ints[2];
> >>> +	if (ints[0] >= 3)
> >>> +		setup_sg_tablesize = ints[3];
> >>> +	if (ints[0] >= 4)
> >>> +		setup_hostid = ints[4];
> >>> +	if (ints[0] >= 5)
> >>> +		setup_use_tagged_queuing = ints[5];
> >>> +	if (ints[0] >= 6)
> >>>  		setup_use_pdma = ints[6];
> >>> -	}
> >>> -#else
> >>> -	if (ints[0] == 5) {
> >>> -	    if (ints[5] >= 0)
> >>> -		setup_use_pdma = ints[5];
> >>> -	}
> >>> -#endif /* SUPPORT_TAGS */
> >>> -	
> >>>  	return 1;
> >>>  }
> >>>  
> >>>  __setup("mac5380=", mac_scsi_setup);
> >>> +#endif /* !MODULE */
> >>>  
> >>>  /*
> >>>   * Function : int macscsi_detect(struct scsi_host_template * tpnt)
> >>> @@ -199,13 +164,8 @@ int __init macscsi_detect(struct scsi_ho
> >>>  		tpnt->cmd_per_lun = setup_cmd_per_lun;
> >>>  	if (setup_sg_tablesize >= 0)
> >>>  		tpnt->sg_tablesize = setup_sg_tablesize;
> >>> -
> >>> -    if (setup_hostid >= 0)
> >>> -	tpnt->this_id = setup_hostid;
> >>> -    else {
> >>> -	/* use 7 as default */
> >>> -	tpnt->this_id = 7;
> >>> -    }
> >>> +	if (setup_hostid >= 0)
> >>> +		tpnt->this_id = setup_hostid & 7;
> >>>  
> >>>  #ifdef SUPPORT_TAGS
> >>>      if (setup_use_tagged_queuing < 0)
> >>> @@ -219,15 +179,15 @@ int __init macscsi_detect(struct scsi_ho
> >>>  	return 0;
> >>>  
> >>>      if (macintosh_config->ident == MAC_MODEL_IIFX) {
> >>> -	mac_scsi_regp  = via1+0x8000;
> >>> -	mac_scsi_drq   = via1+0xE000;
> >>> -	mac_scsi_nodrq = via1+0xC000;
> >>> +	mac_scsi_regp  = (unsigned char *) VIA1_BASE + 0x8000;
> >>> +	mac_scsi_drq   = (unsigned char *) VIA1_BASE + 0xE000;
> >>> +	mac_scsi_nodrq = (unsigned char *) VIA1_BASE + 0xC000;
> >>>  	/* The IIFX should be able to do true DMA, but pseudo-dma doesn't work */
> >>>  	flags = FLAG_NO_PSEUDO_DMA;
> >>>      } else {
> >>> -	mac_scsi_regp  = via1+0x10000;
> >>> -	mac_scsi_drq   = via1+0x6000;
> >>> -	mac_scsi_nodrq = via1+0x12000;
> >>> +	mac_scsi_regp  = (unsigned char *) VIA1_BASE + 0x10000;
> >>> +	mac_scsi_drq   = (unsigned char *) VIA1_BASE + 0x6000;
> >>> +	mac_scsi_nodrq = (unsigned char *) VIA1_BASE + 0x12000;
> >>>      }
> >>>  
> >>>      if (! setup_use_pdma)
> >> Hmm. mac_via.h has this:
> >>
> >> /*
> >>  * Base addresses for the VIAs. There are two in every machine,
> >>  * although on some machines the second is an RBV or an OSS.
> >>  * The OSS is different enough that it's handled separately.
> >>  *
> >>  * Do not use these values directly; use the via1 and via2 variables
> >>  * instead (and don't forget to check rbv_present when using via2!)
> >>  */
> >>
> >> #define VIA1_BASE	(0x50F00000)
> >> #define VIA2_BASE	(0x50F02000)
> >> #define  RBV_BASE	(0x50F26000)
> >>
> >> So either that comment is obsolete or you should revert the above
> >> bit ...
> > 
> > Use of via1 had to be changed because that symbol is not exported.
> > 
> > The comment you quoted is probably not wrong; it relates to programming 
> > the VIA chip itself (see ADB drivers for example). But in this driver we 
> > aren't interested in the VIA1 chip so I'd say niether via1 or VIA1_BASE is 
> > good style. Hence my use of bare addresses in the platform resource 
> > initializers in patch 21.
> > 
> > This example of VIA1_BASE + offset disappears in patch 21 (you can find an 
> > unrelated example in arch/m68k/mac/config.c but that was not my doing).
> > 
> > This patch is not meant to change the actual addresses used by mac_scsi; 
> > it just makes the driver modular. Use of VIA1_BASE seemed like a good way 
> > to express the fact that the addresses are not changed yet (some models 
> > use new addresses after patch 21).
> > 
> > Basically, I just wanted a modular driver for debugging and bisection and 
> > I wanted it early in the patch series. A modular mac_scsi.c aligns better 
> > with atari_scsi.c and sun3_scsi.c as they are already modular. That means 
> > that the three subsequent patches which convert {atari,mac,sun3}_scsi.c to 
> > platform drivers also align nicely (so I could cross check them).
> > 
> Fair enough.
> 
> Just needed some clarification here. My Mac experience ceased with a
> IIcx :-)

Hannes, can I get a reviewed-by tag for this patch please?

-- 
