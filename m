From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 1/3] g_NCR5380: Remove deprecated __setup
Date: Mon, 26 Sep 2016 10:46:02 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1609261043580.4703@nippy.intranet>
References: <1474743545-4731-1-git-send-email-linux@rainbow-software.org> <1474743545-4731-2-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1474743545-4731-2-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sat, 24 Sep 2016, Ondrej Zary wrote:

> Remove deprecated __setup for parsing command line parameters. 
> g_NCR5380.* parameters could be used instead.

Removing useful features is deprecated too.

The best reason I can see for removing the __setup parameters is that the 
g_NCR5380 module parameters clash with those of the g_NCR5380_mmio module 
(when both are built-in). But only a custom kernel would configure them as 
built-in drivers, and it probably would not have both drivers enabled. So 
a clash seems unlikely.

Anyway, Christoph seems to be OK with this so I won't object. But if you 
assume that no-one has built-in g_NCR5380{,_mmio} drivers, or you believe 
that the benefit outweighs the inconvenience of the breakage caused, then 
the commit log should explain that.

-- 

> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/scsi/g_NCR5380.c |  135 ----------------------------------------------
>  1 file changed, 135 deletions(-)
> 
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
