From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 1/3] g_NCR5380: Remove deprecated __setup
Date: Thu, 29 Sep 2016 08:56:51 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1609290841400.22268@nippy.intranet>
References: <1475002825-18132-1-git-send-email-linux@rainbow-software.org> <1475002825-18132-2-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:60648 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932620AbcI1W4d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 18:56:33 -0400
In-Reply-To: <1475002825-18132-2-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Acked-by: Finn Thain <fthain@telegraphics.com.au>

On Tue, 27 Sep 2016, Ondrej Zary wrote:

> Remove deprecated __setup for parsing command line parameters.
> g_NCR5380.* parameters could be used instead.
> 
> This might break existing setups with g_NCR5380 built-in (if there are
> any). But it has to go in order to remove the overrides[] array.

Instead of "in order to" I think you meant "along with" (otherwise it 
seems to be a non-sequitur). No matter.

-- 

> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  Documentation/scsi/g_NCR5380.txt |   10 ---
>  drivers/scsi/g_NCR5380.c         |  135 --------------------------------------
>  2 files changed, 145 deletions(-)
> 
> diff --git a/Documentation/scsi/g_NCR5380.txt b/Documentation/scsi/g_NCR5380.txt
> index fd88015..843cbae 100644
> --- a/Documentation/scsi/g_NCR5380.txt
> +++ b/Documentation/scsi/g_NCR5380.txt
> @@ -21,16 +21,6 @@ NCR53c400 card, the Trantor T130B in its default configuration:
>  The NCR53c400 does not support DMA but it does have Pseudo-DMA which is
>  supported by the driver.
>  
> -If the default configuration does not work for you, you can use the kernel
> -command lines (eg using the lilo append command):
> -	ncr5380=addr,irq
> -	ncr53c400=addr,irq
> -	ncr53c400a=addr,irq
> -	dtc3181e=addr,irq
> -
> -The driver does not probe for any addresses or ports other than those in
> -the OVERRIDE or given to the kernel as above.
> -
>  This driver provides some information on what it has detected in
>  /proc/scsi/g_NCR5380/x where x is the scsi card number as detected at boot
>  time. More info to come in the future.
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 516bd6c..7e50b44e 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -56,136 +56,6 @@ static struct override {
>  
>  #define NO_OVERRIDES ARRAY_SIZE(overrides)
>  
> -#ifndef MODULE
> -
> -/**
> - *	internal_setup		-	handle lilo command string override
> - *	@board:	BOARD_* identifier for the board
> - *	@str: unused
> - *	@ints: numeric parameters
> - *
> - * 	Do LILO command line initialization of the overrides array. Display
> - *	errors when needed
> - *
> - *	Locks: none
> - */
> -
> -static void __init internal_setup(int board, char *str, int *ints)
> -{
> -	static int commandline_current;
> -	switch (board) {
> -	case BOARD_NCR5380:
> -		if (ints[0] != 2 && ints[0] != 3) {
> -			printk(KERN_ERR "generic_NCR5380_setup : usage ncr5380=" STRVAL(NCR5380_map_name) ",irq,dma\n");
> -			return;
> -		}
> -		break;
> -	case BOARD_NCR53C400:
> -		if (ints[0] != 2) {
> -			printk(KERN_ERR "generic_NCR53C400_setup : usage ncr53c400=" STRVAL(NCR5380_map_name) ",irq\n");
> -			return;
> -		}
> -		break;
> -	case BOARD_NCR53C400A:
> -		if (ints[0] != 2) {
> -			printk(KERN_ERR "generic_NCR53C400A_setup : usage ncr53c400a=" STRVAL(NCR5380_map_name) ",irq\n");
> -			return;
> -		}
> -		break;
> -	case BOARD_DTC3181E:
> -		if (ints[0] != 2) {
> -			printk("generic_DTC3181E_setup : usage dtc3181e=" STRVAL(NCR5380_map_name) ",irq\n");
> -			return;
> -		}
> -		break;
> -	}
> -
> -	if (commandline_current < NO_OVERRIDES) {
> -		overrides[commandline_current].NCR5380_map_name = (NCR5380_map_type) ints[1];
> -		overrides[commandline_current].irq = ints[2];
> -		if (ints[0] == 3)
> -			overrides[commandline_current].dma = ints[3];
> -		else
> -			overrides[commandline_current].dma = DMA_NONE;
> -		overrides[commandline_current].board = board;
> -		++commandline_current;
> -	}
> -}
> -
> -
> -/**
> - * 	do_NCR53C80_setup		-	set up entry point
> - *	@str: unused
> - *
> - *	Setup function invoked at boot to parse the ncr5380= command
> - *	line.
> - */
> -
> -static int __init do_NCR5380_setup(char *str)
> -{
> -	int ints[10];
> -
> -	get_options(str, ARRAY_SIZE(ints), ints);
> -	internal_setup(BOARD_NCR5380, str, ints);
> -	return 1;
> -}
> -
> -/**
> - * 	do_NCR53C400_setup		-	set up entry point
> - *	@str: unused
> - *	@ints: integer parameters from kernel setup code
> - *
> - *	Setup function invoked at boot to parse the ncr53c400= command
> - *	line.
> - */
> -
> -static int __init do_NCR53C400_setup(char *str)
> -{
> -	int ints[10];
> -
> -	get_options(str, ARRAY_SIZE(ints), ints);
> -	internal_setup(BOARD_NCR53C400, str, ints);
> -	return 1;
> -}
> -
> -/**
> - * 	do_NCR53C400A_setup	-	set up entry point
> - *	@str: unused
> - *	@ints: integer parameters from kernel setup code
> - *
> - *	Setup function invoked at boot to parse the ncr53c400a= command
> - *	line.
> - */
> -
> -static int __init do_NCR53C400A_setup(char *str)
> -{
> -	int ints[10];
> -
> -	get_options(str, ARRAY_SIZE(ints), ints);
> -	internal_setup(BOARD_NCR53C400A, str, ints);
> -	return 1;
> -}
> -
> -/**
> - * 	do_DTC3181E_setup	-	set up entry point
> - *	@str: unused
> - *	@ints: integer parameters from kernel setup code
> - *
> - *	Setup function invoked at boot to parse the dtc3181e= command
> - *	line.
> - */
> -
> -static int __init do_DTC3181E_setup(char *str)
> -{
> -	int ints[10];
> -
> -	get_options(str, ARRAY_SIZE(ints), ints);
> -	internal_setup(BOARD_DTC3181E, str, ints);
> -	return 1;
> -}
> -
> -#endif
> -
>  #ifndef SCSI_G_NCR5380_MEM
>  /*
>   * Configure I/O address of 53C400A or DTC436 by writing magic numbers
> @@ -741,8 +611,3 @@ static struct isapnp_device_id id_table[] = {
>  
>  MODULE_DEVICE_TABLE(isapnp, id_table);
>  #endif
> -
> -__setup("ncr5380=", do_NCR5380_setup);
> -__setup("ncr53c400=", do_NCR53C400_setup);
> -__setup("ncr53c400a=", do_NCR53C400A_setup);
> -__setup("dtc3181e=", do_DTC3181E_setup);
> 
