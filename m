From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] mac_esp: fix PIO mode
Date: Wed, 02 Dec 2009 15:40:45 -0800 (PST)
Message-ID: <20091202.154045.142858043.davem@davemloft.net>
References: <alpine.OSX.2.00.0911231452300.468@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.0911231452300.468@localhost>
Sender: linux-m68k-owner@vger.kernel.org
To: fthain@telegraphics.com.au
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>
Date: Mon, 23 Nov 2009 14:57:42 +1100 (EST)

> 
> The mac_esp PIO algorithm no longer works in 2.6.31 and crashes my Centris 
> 660av. So here's a better one.
> 
> One of the SCSI drives I tested still doesn't like the PIO mode and fails 
> with "esp: esp0: Reconnect IRQ2 timeout" (the same drive works fine in 
> PDMA mode).
> 
> This failure happens when esp_reconnect_with_tag() tries to read in two 
> tag bytes but the chip only provides one (0x20). I don't know what causes 
> this. I decided not to waste any more time trying to fix it because the 
> best solution is to rip out the PIO mode altogether and use the DMA 
> engine.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Can you explain why the esp_slave_configure() part of your patch
is necessary?

> Index: linux-2.6.31/drivers/scsi/esp_scsi.c
> ===================================================================
> --- linux-2.6.31.orig/drivers/scsi/esp_scsi.c	2009-11-23 12:52:45.000000000 +1100
> +++ linux-2.6.31/drivers/scsi/esp_scsi.c	2009-11-23 12:53:30.000000000 +1100
> @@ -2405,12 +2405,6 @@ static int esp_slave_configure(struct sc
>  	struct esp_target_data *tp = &esp->target[dev->id];
>  	int goal_tags, queue_depth;
>  
> -	if (esp->flags & ESP_FLAG_DISABLE_SYNC) {
> -		/* Bypass async domain validation */
> -		dev->ppr  = 0;
> -		dev->sdtr = 0;
> -	}
> -
>  	goal_tags = 0;
>  
>  	if (dev->tagged_supported) {
> @@ -2433,6 +2427,11 @@ static int esp_slave_configure(struct sc
>  	}
>  	tp->flags |= ESP_TGT_DISCONNECT;
>  
> +	if (esp->flags & ESP_FLAG_DISABLE_SYNC) {
> +		dev->wdtr = spi_support_wide(dev->sdev_target) = 0;
> +		dev->sdtr = spi_support_sync(dev->sdev_target) = 0;
> +	}
> +
>  	if (!spi_initial_dv(dev->sdev_target))
>  		spi_dv_device(dev);
>  

That part...

Thanks.
