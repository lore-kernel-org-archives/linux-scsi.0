From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] SGIWD93: use cached memory access to make driver work
 on IP28
Date: Tue, 27 Nov 2007 09:28:14 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711270927370.22167@anakin>
References: <20071126223921.A566CC2B26@solo.franken.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:36492 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbXK0I2R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Nov 2007 03:28:17 -0500
In-Reply-To: <20071126223921.A566CC2B26@solo.franken.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, ralf@linux-mips.org, James.Bottomley@HansenPartnership.com

On Mon, 26 Nov 2007, Thomas Bogendoerfer wrote:
> --- a/drivers/scsi/sgiwd93.c
> +++ b/drivers/scsi/sgiwd93.c
> @@ -33,19 +33,27 @@
>  
>  struct ip22_hostdata {
>  	struct WD33C93_hostdata wh;
> -	struct hpc_data {
> -		dma_addr_t      dma;
> -		void		*cpu;
> -	} hd;
> +	dma_addr_t dma;
> +	void *cpu;
> +	void *dev;
>  };
>  
>  #define host_to_hostdata(host) ((struct ip22_hostdata *)((host)->hostdata))
>  
>  struct hpc_chunk {
>  	struct hpc_dma_desc desc;
> -	u32 _padding;	/* align to quadword boundary */
> +	u32 _padding[128/4 - 3];	/* align to biggest cache line size */
                     ^^^^^^^^^
(128 - sizeof(struct hpc_dma_desc))/4?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
