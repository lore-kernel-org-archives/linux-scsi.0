From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] more ncr updates
Date: Fri, 26 Sep 2003 16:44:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030926154433.GN24824@parcelfarce.linux.theplanet.co.uk>
References: <20030926151751.GA23650@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63460 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262365AbTIZPoe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 11:44:34 -0400
Content-Disposition: inline
In-Reply-To: <20030926151751.GA23650@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: willy@debian.org, linux-scsi@vger.kernel.org

On Fri, Sep 26, 2003 at 05:17:51PM +0200, Christoph Hellwig wrote:
>  - kill pre-2.4 'dma mapping' code
>  - kill nvram support
>  - kill pci leftovers

I'd already done most of this in the parisc 2.6 tree ...

> --- 1.48/drivers/scsi/Makefile	Tue Sep 23 13:50:13 2003
> +++ edited/drivers/scsi/Makefile	Thu Sep 25 20:54:35 2003
> @@ -136,11 +136,9 @@
>  ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
>  		:= -DCONFIG_NCR53C8XX_PREFETCH \
>  			-DCONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS \
> -			-DCONFIG_SCSI_NCR53C8XX_NO_NVRAM \
>  			-DSCSI_NCR_BIG_ENDIAN -DSIMULATED_INTFLY
> -ncr53c8xx-flags-$(CONFIG_SCSI_NCR_Q720) \
> -		:= -DCONFIG_SCSI_NCR53C8XX_NO_NVRAM \
> -			-DSIMULATED_INTFLY
> +ncr53c8xx-flags-$(CONFIG_SCSI_NCR_Q720)	\
> +		:= -DSIMULATED_INTFLY
>  CFLAGS_ncr53c8xx.o	:= $(ncr53c8xx-flags-y) $(ncr53c8xx-flags-m)
>  zalon7xx-objs	:= zalon.o ncr53c8xx.o
>  NCR_Q720_mod-objs	:= NCR_Q720.o ncr53c8xx.o

Missed this bit, applied.

> @@ -3478,9 +3398,7 @@
>  	**	that drive the LED directly.
>  	**	Also probe initial setting of GPIO0 as output.
>  	*/
> -	if ((driver_setup.led_pin ||
> -	     (nvram && nvram->type == SCSI_NCR_SYMBIOS_NVRAM)) &&
> -	    !(np->features & FE_LEDC) && !(np->sv_gpcntl & 0x01))
> +	if (driver_setup.led_pin)
>  		np->features |= FE_LED0;
>  
>  	/*

Are you sure this is right?  I have:

        if ((driver_setup.led_pin) &&
            !(np->features & FE_LEDC) && !(np->sv_gpcntl & 0x01))
                np->features |= FE_LED0;


> @@ -3507,43 +3425,18 @@
>  		tcb_p tp = &np->target[i];
>  
>  		tp->usrsync = 255;

heh, you made the same mistake I did ;-)  this line can also be dropped ...

> -		}
> +		tp->usrsync = driver_setup.default_sync;

... because this is the next line in the new order.  But I didn't notice
till I was checking your patch.

> -/*
> - * DMAable pools.
> - */

I thought it was worth leaving this comment in.  No big deal either way,
I guess.

> -/*==========================================================
> -**
> -**	SCSI data transfer direction
> -**
> -**	Until some linux kernel version near 2.3.40, 
> -**	low-level scsi drivers were not told about data 
> -**	transfer direction. We check the existence of this 
> -**	feature that has been expected for a _long_ time by 
> -**	all SCSI driver developers by just testing against 
> -**	the definition of SCSI_DATA_UNKNOWN. Indeed this is 
> -**	a hack, but testing against a kernel version would 
> -**	have been a shame. ;-)
> -**
> -**==========================================================
> -*/
> -#ifdef	SCSI_DATA_UNKNOWN
> -
>  #define scsi_data_direction(cmd)	(cmd->sc_data_direction)
>  
> -#else
> -
> -#define	SCSI_DATA_UNKNOWN	0
> -#define	SCSI_DATA_WRITE		1
> -#define	SCSI_DATA_READ		2
> -#define	SCSI_DATA_NONE		3
> -
> -static __inline__ int scsi_data_direction(Scsi_Cmnd *cmd)
> -{
> -	int direction;
> -
> -	switch((int) cmd->cmnd[0]) {
> -	case 0x08:  /*	READ(6)				08 */
> -	case 0x28:  /*	READ(10)			28 */
> -	case 0xA8:  /*	READ(12)			A8 */
> -		direction = SCSI_DATA_READ;
> -		break;
> -	case 0x0A:  /*	WRITE(6)			0A */
> -	case 0x2A:  /*	WRITE(10)			2A */
> -	case 0xAA:  /*	WRITE(12)			AA */
> -		direction = SCSI_DATA_WRITE;
> -		break;
> -	default:
> -		direction = SCSI_DATA_UNKNOWN;
> -		break;
> -	}
> -
> -	return direction;
> -}
> -
> -#endif	/* SCSI_DATA_UNKNOWN */
> -

Forgot to take that out.  Done.

> @@ -619,71 +598,6 @@
>  #define PSEUDO_720_ID 0x5a00
>  #endif

I went further than this and took out PSEUDO_720_ID and all places that
filled it in and checked its value.  ncr53c8xx is now really ncr53c720.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
