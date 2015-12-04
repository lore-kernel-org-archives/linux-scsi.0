From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC PATCH 76/71] ncr5380: Enable PDMA for DTC chips
Date: Fri, 4 Dec 2015 20:20:13 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512042018180.16802@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <1449183781-2163-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449183781-2163-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Fri, 4 Dec 2015, Ondrej Zary wrote:

> @@ -685,8 +684,10 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
>  	/* All documentation says to check for this. Maybe my hardware is too
>  	 * fast. Waiting for it seems to work fine! KLL
>  	 */
> -	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
> +	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)) {
> +		udelay(4); /* DTC436 chip hangs without this */
>  		;	// FIXME - no timeout
> +	}
>  
>  	/*
>  	 * I know. i is certainly != 0 here but the loop is new. See previous
> 

Given that you've added braces, the redundant semicolon can be removed.

-- 
